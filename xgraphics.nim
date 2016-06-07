## #
## #  The Sciter Engine of Terra Informatica Software, Inc.
## #  http://sciter.com
## # 
## #  The code and information provided "as-is" without
## #  warranty of any kind, either expressed or implied.
## # 
## #  (C) 2003-2015, Terra Informatica Software, Inc.
## # 
## #
## #  Sciter's platform independent graphics interface. Used in custom behaviors / event handlers to draw on element's surface in native code.
## # 
## #  Essentially this mimics Graphics object as close as possible.
## # 

import xtypes,xdom
type
  HGFX* = pointer
  HIMG* = pointer
  HPATH* = pointer
  HTEXT* = pointer
  REAL* = cfloat
  POS* = REAL

## # position

type
  DIM* = REAL

## # dimension

type
  ANGLE* = REAL

## # angle (radians)

type
  COLOR* = cuint

## # COLOR

type
  COLOR_STOP* = object
    color*: COLOR
    offset*: cfloat            ## # 0.0 ... 1.0
  
  GRAPHIN_RESULT* = enum
    GRAPHIN_PANIC = - 1,         ## # e.g. not enough memory
    GRAPHIN_OK = 0, GRAPHIN_BAD_PARAM = 1, ## # bad parameter
    GRAPHIN_FAILURE = 2,        ## # operation failed, e.g. restore() without save()
    GRAPHIN_NOTSUPPORTED = 3


type
  DRAW_PATH_MODE* = enum
    DRAW_FILL_ONLY = 1, DRAW_STROKE_ONLY = 2, DRAW_FILL_AND_STROKE = 3


type
  SCITER_LINE_JOIN_TYPE* = enum
    SCITER_JOIN_MITER = 0, SCITER_JOIN_ROUND = 1, SCITER_JOIN_BEVEL = 2,
    SCITER_JOIN_MITER_OR_BEVEL = 3


type
  SCITER_LINE_CAP_TYPE* = enum
    SCITER_LINE_CAP_BUTT = 0, SCITER_LINE_CAP_SQUARE = 1, SCITER_LINE_CAP_ROUND = 2


type
  SCITER_TEXT_ALIGNMENT* = enum
    TEXT_ALIGN_DEFAULT, TEXT_ALIGN_START, TEXT_ALIGN_END, TEXT_ALIGN_CENTER


type
  SCITER_TEXT_DIRECTION* = enum
    TEXT_DIRECTION_DEFAULT, TEXT_DIRECTION_LTR, TEXT_DIRECTION_RTL,
    TEXT_DIRECTION_TTB


type
  SCITER_TEXT_FORMAT* = object
    fontFamily*: ptr WideCString
    fontWeight*: cuint         ## # 100...900, 400 - normal, 700 - bold
    fontItalic*: bool
    fontSize*: cfloat          ## # dips
    lineHeight*: cfloat        ## # dips
    textDirection*: SCITER_TEXT_DIRECTION
    textAlignment*: SCITER_TEXT_ALIGNMENT ## # horizontal alignment
    lineAlignment*: SCITER_TEXT_ALIGNMENT ## # a.k.a. vertical alignment for roman writing systems
    localeName*: ptr WideCString

  image_write_function* = proc (prm: pointer; data: ptr byte; data_length: cuint): bool
  SciterGraphicsAPI* = object
    imageCreate*: proc (poutImg: ptr HIMG; width: cuint; height: cuint; withAlpha: bool): GRAPHIN_RESULT ## 
                                                                                             ## # 
                                                                                             ## image 
                                                                                             ## primitives
    ## # construct image from B[n+0],G[n+1],R[n+2],A[n+3] data.
    ## # Size of pixmap data is pixmapWidth*pixmapHeight*4
    imageCreateFromPixmap*: proc (poutImg: ptr HIMG; pixmapWidth: cuint;
                                pixmapHeight: cuint; withAlpha: bool;
                                pixmap: ptr byte): GRAPHIN_RESULT
    imageAddRef*: proc (himg: HIMG): GRAPHIN_RESULT
    imageRelease*: proc (himg: HIMG): GRAPHIN_RESULT
    imageGetInfo*: proc (himg: HIMG; width: ptr cuint; height: ptr cuint;
                       usesAlpha: ptr bool): GRAPHIN_RESULT ## #GRAPHIN_RESULT
                                                        ## #      SCFN(imageGetPixels)( HIMG himg,
                                                        ## #           image_write_function* dataReceiver );
    imageClear*: proc (himg: HIMG; byColor: COLOR): GRAPHIN_RESULT
    imageLoad*: proc (bytes: ptr byte; num_bytes: cuint; pout_img: ptr HIMG): GRAPHIN_RESULT ## 
                                                                                  ## # 
                                                                                  ## load 
                                                                                  ## png/jpeg/etc. 
                                                                                  ## image 
                                                                                  ## from 
                                                                                  ## stream 
                                                                                  ## of 
                                                                                  ## bytes
    imageSave*: proc (himg: HIMG; pfn: ptr image_write_function; prm: pointer; bpp: cuint; ## 
                                                                                ## # 
                                                                                ## SECTION: 
                                                                                ## graphics 
                                                                                ## primitives 
                                                                                ## and 
                                                                                ## drawing 
                                                                                ## operations
                                                                                ## 
                                                                                ## # 
                                                                                ## create 
                                                                                ## COLOR 
                                                                                ## value
    ## # save png/jpeg/etc. image to stream of bytes
    ## # function and its param passed "as is" 
    ## #24,32 if alpha needed
                    quality: cuint): GRAPHIN_RESULT ## # png: 0, jpeg:, 10 - 100 
    RGBA*: proc (red: cuint; green: cuint; blue: cuint; alpha: cuint): COLOR ## #= 255
    gCreate*: proc (img: HIMG; pout_gfx: ptr HGFX): GRAPHIN_RESULT
    gAddRef*: proc (gfx: HGFX): GRAPHIN_RESULT
    gRelease*: proc (gfx: HGFX): GRAPHIN_RESULT ## # Draws line from x1,y1 to x2,y2 using current lineColor and lineGradient.
    gLine*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS): GRAPHIN_RESULT ## # Draws rectangle using current 
                                                                     ## lineColor/lineGradient and 
                                                                     ## fillColor/fillGradient with (optional) rounded corners.
    gRectangle*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS): GRAPHIN_RESULT ## # Draws 
                                                                          ## rounded 
                                                                          ## rectangle using 
                                                                          ## current 
                                                                          ## lineColor/lineGradient and 
                                                                          ## fillColor/fillGradient with 
                                                                          ## (optional) 
                                                                          ## rounded 
                                                                          ## corners.
    gRoundedRectangle*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS; radii8: ptr DIM): GRAPHIN_RESULT ## 
                                                                                               ## # 
                                                                                               ## Draws 
                                                                                               ## circle 
                                                                                               ## or 
                                                                                               ## ellipse 
                                                                                               ## using 
                                                                                               ## current 
                                                                                               ## lineColor/lineGradient 
                                                                                               ## and 
                                                                                               ## fillColor/fillGradient.
    ## #DIM[8] - four rx/ry pairs 
    gEllipse*: proc (hgfx: HGFX; x: POS; y: POS; rx: DIM; ry: DIM): GRAPHIN_RESULT ## # Draws closed arc using current 
                                                                      ## lineColor/lineGradient and 
                                                                      ## fillColor/fillGradient.
    gArc*: proc (hgfx: HGFX; x: POS; y: POS; rx: POS; ry: POS; start: ANGLE; sweep: ANGLE): GRAPHIN_RESULT ## 
                                                                                          ## # 
                                                                                          ## Draws 
                                                                                          ## star.
    gStar*: proc (hgfx: HGFX; x: POS; y: POS; r1: DIM; r2: DIM; start: ANGLE; rays: cuint): GRAPHIN_RESULT ## 
                                                                                          ## # 
                                                                                          ## Closed 
                                                                                          ## polygon.
    gPolygon*: proc (hgfx: HGFX; xy: ptr POS; num_points: cuint): GRAPHIN_RESULT ## # Polyline.
    gPolyline*: proc (hgfx: HGFX; xy: ptr POS; num_points: cuint): GRAPHIN_RESULT ## # SECTION: Path 
                                                                        ## operations
    pathCreate*: proc (path: ptr HPATH): GRAPHIN_RESULT
    pathAddRef*: proc (path: HPATH): GRAPHIN_RESULT
    pathRelease*: proc (path: HPATH): GRAPHIN_RESULT
    pathMoveTo*: proc (path: HPATH; x: POS; y: POS; relative: bool): GRAPHIN_RESULT
    pathLineTo*: proc (path: HPATH; x: POS; y: POS; relative: bool): GRAPHIN_RESULT
    pathArcTo*: proc (path: HPATH; x: POS; y: POS; angle: ANGLE; rx: DIM; ry: DIM;
                    is_large_arc: bool; clockwise: bool; relative: bool): GRAPHIN_RESULT
    pathQuadraticCurveTo*: proc (path: HPATH; xc: POS; yc: POS; x: POS; y: POS;
                               relative: bool): GRAPHIN_RESULT
    pathBezierCurveTo*: proc (path: HPATH; xc1: POS; yc1: POS; xc2: POS; yc2: POS; x: POS;
                            y: POS; relative: bool): GRAPHIN_RESULT
    pathClosePath*: proc (path: HPATH): GRAPHIN_RESULT
    gDrawPath*: proc (hgfx: HGFX; path: HPATH; dpm: DRAW_PATH_MODE): GRAPHIN_RESULT ## # end of path 
                                                                           ## opearations
                                                                           ## # 
                                                                           ## SECTION: 
                                                                           ## affine 
                                                                           ## tranformations:
    gRotate*: proc (hgfx: HGFX; radians: ANGLE; cx: ptr POS; ## #= 0
                  cy: ptr POS): GRAPHIN_RESULT ## #= 0
    gTranslate*: proc (hgfx: HGFX; cx: POS; cy: POS): GRAPHIN_RESULT
    gScale*: proc (hgfx: HGFX; x: DIM; y: DIM): GRAPHIN_RESULT
    gSkew*: proc (hgfx: HGFX; dx: DIM; dy: DIM): GRAPHIN_RESULT ## # all above in one shot
    gTransform*: proc (hgfx: HGFX; m11: POS; m12: POS; m21: POS; m22: POS; dx: POS; dy: POS): GRAPHIN_RESULT ## 
                                                                                            ## # 
                                                                                            ## end 
                                                                                            ## of 
                                                                                            ## affine 
                                                                                            ## tranformations.
                                                                                            ## 
                                                                                            ## # 
                                                                                            ## SECTION: 
                                                                                            ## state 
                                                                                            ## save/restore
    gStateSave*: proc (hgfx: HGFX): GRAPHIN_RESULT
    gStateRestore*: proc (hgfx: HGFX): GRAPHIN_RESULT ## # end of state save/restore
                                                 ## # SECTION: drawing attributes
                                                 ## # set line width for subsequent drawings.
    gLineWidth*: proc (hgfx: HGFX; width: DIM): GRAPHIN_RESULT
    gLineJoin*: proc (hgfx: HGFX; `type`: SCITER_LINE_JOIN_TYPE): GRAPHIN_RESULT
    gLineCap*: proc (hgfx: HGFX; `type`: SCITER_LINE_CAP_TYPE): GRAPHIN_RESULT ## #GRAPHIN_RESULT SCFN
                                                                        ## #      (*gNoLine ( HGFX hgfx ) { gLineWidth(hgfx,0.0); }
                                                                        ## # COLOR for solid lines/strokes
    gLineColor*: proc (hgfx: HGFX; c: COLOR): GRAPHIN_RESULT ## # COLOR for solid fills
    gFillColor*: proc (hgfx: HGFX; color: COLOR): GRAPHIN_RESULT ## #inline void
                                                          ## #      graphics_no_fill ( HGFX hgfx ) { graphics_fill_color(hgfx, graphics_rgbt(0,0,0,0xFF)); }
                                                          ## # setup parameters of linear gradient of lines.
    gLineGradientLinear*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS;
                              stops: ptr COLOR_STOP; nstops: cuint): GRAPHIN_RESULT ## # 
                                                                              ## setup 
                                                                              ## parameters of 
                                                                              ## linear 
                                                                              ## gradient of 
                                                                              ## fills.
    gFillGradientLinear*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS;
                              stops: ptr COLOR_STOP; nstops: cuint): GRAPHIN_RESULT ## # 
                                                                              ## setup 
                                                                              ## parameters of 
                                                                              ## line 
                                                                              ## gradient 
                                                                              ## radial 
                                                                              ## fills.
    gLineGradientRadial*: proc (hgfx: HGFX; x: POS; y: POS; rx: DIM; ry: DIM;
                              stops: ptr COLOR_STOP; nstops: cuint): GRAPHIN_RESULT ## # 
                                                                              ## setup 
                                                                              ## parameters of 
                                                                              ## gradient 
                                                                              ## radial 
                                                                              ## fills.
    gFillGradientRadial*: proc (hgfx: HGFX; x: POS; y: POS; rx: DIM; ry: DIM;
                              stops: ptr COLOR_STOP; nstops: cuint): GRAPHIN_RESULT
    gFillMode*: proc (hgfx: HGFX; even_odd: bool): GRAPHIN_RESULT ## # SECTION: text
                                                           ## # create text layout using element's styles
    ## # false - fill_non_zero 
    textCreateForElement*: proc (ptext: ptr HTEXT; text: ptr WideCString;
                               textLength: cuint; he: HELEMENT): GRAPHIN_RESULT ## # 
                                                                           ## create text 
                                                                           ## layout using 
                                                                           ## explicit 
                                                                           ## format 
                                                                           ## declaration
    textCreate*: proc (ptext: ptr HTEXT; text: ptr WideCString; textLength: cuint;
                     format: ptr SCITER_TEXT_FORMAT): GRAPHIN_RESULT
    textGetMetrics*: proc (text: HTEXT; minWidth: ptr DIM; maxWidth: ptr DIM;
                         height: ptr DIM; ascent: ptr DIM; descent: ptr DIM;
                         nLines: ptr cuint): GRAPHIN_RESULT
    textSetBox*: proc (text: HTEXT; width: DIM; height: DIM): GRAPHIN_RESULT ## # draw text with position (1..9 on MUMPAD) at px,py
                                                                    ## # Ex: gDrawText( 100,100,5) will draw text box with its center at 100,100 px
    gDrawText*: proc (hgfx: HGFX; text: HTEXT; px: POS; py: POS; position: cuint): GRAPHIN_RESULT ## 
                                                                                     ## # 
                                                                                     ## SECTION: 
                                                                                     ## image 
                                                                                     ## rendering
                                                                                     ## 
                                                                                     ## # 
                                                                                     ## draws 
                                                                                     ## img 
                                                                                     ## onto 
                                                                                     ## the 
                                                                                     ## graphics 
                                                                                     ## surface 
                                                                                     ## with 
                                                                                     ## current 
                                                                                     ## transformation 
                                                                                     ## applied 
                                                                                     ## (scale, 
                                                                                     ## rotation).
    gDrawImage*: proc (hgfx: HGFX; himg: HIMG; x: POS; y: POS; w: ptr DIM; ## # SECTION: coordinate space
    ## #= 0
    ## #= 0
                     h: ptr DIM; ## #= 0
                     ix: ptr cuint; ## #= 0
                     iy: ptr cuint; ## #= 0
                     iw: ptr cuint; ## #= 0
                     ih: ptr cuint; opacity: ptr cfloat): GRAPHIN_RESULT ## #= 0, if provided is in 0.0 .. 1.0
    gWorldToScreen*: proc (hgfx: HGFX; inout_x: ptr POS; inout_y: ptr POS): GRAPHIN_RESULT ## #inline GRAPHIN_RESULT
                                                                                ## #      graphics_world_to_screen ( HGFX hgfx, POS* length)
                                                                                ## #{
                                                                                ## #   return graphics_world_to_screen ( hgfx, length, 0);
                                                                                ## #}
    gScreenToWorld*: proc (hgfx: HGFX; inout_x: ptr POS; inout_y: ptr POS): GRAPHIN_RESULT ## #inline GRAPHIN_RESULT
                                                                                ## #      graphics_screen_to_world ( HGFX hgfx, POS* length)
                                                                                ## #{
                                                                                ## #   return graphics_screen_to_world (hgfx, length, 0);
                                                                                ## #}
                                                                                ## # SECTION: clipping
    gPushClipBox*: proc (hgfx: HGFX; x1: POS; y1: POS; x2: POS; y2: POS; opacity: cfloat): GRAPHIN_RESULT ## #=1.f
    gPushClipPath*: proc (hgfx: HGFX; hpath: HPATH; opacity: cfloat): GRAPHIN_RESULT ## # pop clip 
                                                                            ## layer 
                                                                            ## previously set by 
                                                                            ## gPushClipBox or 
                                                                            ## gPushClipPath
    ## #=1.f
    gPopClip*: proc (hgfx: HGFX): GRAPHIN_RESULT

  LPSciterGraphicsAPI* = ptr SciterGraphicsAPI
