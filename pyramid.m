/******************************************************************************
  Author: Geoffrey Pitman
  Created: 10/1/2015
  Due: 10/9/2015
  Course: CSC235-210
  Professor: Dr. Spiegel
  Assignment: #2
  Filename: pyramid.m
  Description: Calculate the surface area and volume of a four sided pyramid
  Purpose:  To learn SPARC basics; print, read, store, load, arithmetic ops
 *****************************************************************************/ 
 
 
 !register aliases
define(in_address,%l0)
define(base_value,%l1)
define(pHeight_value,%l2)
define(tHeight_value,%l3)
define(pArea_value,%l4)
define(pVolume_value,%l5)

!Labels:
!   Creates a symbolic name for the code/data that follows and also 
!   assigns it a type. It's similar to defining a variable with a given name 
!   and type/size, but does not actually allocate space for it. 
!   Pretty much used to create aliases for variables
    .data
    .align 4    !  aligns bus access
prompt_base:
    .asciz "Enter the Base >"
prompt_pHeight:
    .asciz "Enter the Height of the Pyramid >"
prompt_tHeight:
    .asciz	"Enter the Height of the Triangles >"
negative_base:
    .asciz "Error: Base must be positive number\n"
not_pyramid:
    .asciz "Error: Values entered not a pyramid\n"
informat:
    .asciz  "%d"
outformat_results:
    .asciz "Pyramid: \nSurface Area: %d square feet\nVolume: %d cubic feet\n"
    .align 4
user_input:
    .word 0
	
    !.global user_input    !to print label's value in gdb - (gdb) p user_input
    .global main
main:
    save    %sp,-96,%sp                !allocate registers to program
		
    !Prompt user for base:
    set     prompt_base,%o0            !set output string
    call    printf                     !print
    nop                                !can't fill delay slot
    !Get the base:
    !scanf(informat, &user_input)
    set     informat,%o0               !set input format
    set     user_input,%o1             !user_input will point to user's input
    call    scanf                      !get input
    nop                                !playing it safe
    set     user_input,in_address      !hand off user input addr to local reg
    ld      [in_address],base_value    !dereference and store value 
    
    !if base is negative, branch to base_error and EXIT:
    cmp     base_value,0               !compare base value with 0
    bl      base_error                 !branch if base < 0
    nop                                !playing it safe
    !else continue, and prompt user for heights
	
    !Prompt user for pyramid height:
    set     prompt_pHeight,%o0         !set output string
    call    printf                     !print
    nop                                !can't fill delay slot
    !Get the the pyramid height:
    !scanf(informat, &user_input)
    set     informat,%o0               !set input format
    set     user_input,%o1             !user_input will point to user's input
    call    scanf                      !get input
    nop                                !playing it safe
    set     user_input,in_address      !hand off user input addr to local reg
    ld      [in_address],pHeight_value !dereference and store value
	
    !Prompt user for triangle height:
    set     prompt_tHeight,%o0         !set output string
    call    printf                     !print
    nop                                !can't fill delay slot
    !Get the the triangle height:
    !scanf(informat, &user_input)
    set     informat,%o0               !set input format
    set     user_input,%o1             !user_input will point to user's input
    call    scanf                      !get input
    nop                                !playing it safe
    set     user_input,in_address      !hand off user input addr to local reg
    ld      [in_address],tHeight_value !dereference and store value
	
    !if tHeight < pHeight, branch to height_error and EXIT:
    cmp     tHeight_value,pHeight_value !compare tHeight with pHeight
    bl      height_error                !branch if tHeight < pHeight
    nop                                 !playing it safe
    !else continue, and calculate results:
	
    !calculate: volume = base * pHeight / 3
    !mul(base_value,pHeight_value)     !base * pHeight
    mov     base_value,%o0             !first operand
    call    .mul                       !call multipy, result stored in %o0
    mov     pHeight_value,%o1          !fill delay slot, second operand
    !mov     %o0,pVolume_value          !copy result to local register
    !div(pVolume,3)                    !(base * pHeight) / 3
    !mov     pVolume_value,%o0          !first operand
    call    .div                       !call divide, result stored in %o0
    mov     3,%o1                      !fill delay slot, second operand
    mov     %o0,pVolume_value          !copy result to local register
	
    !calculate: area = 2 * base * tHeight + base * base
    add     base_value,base_value,pArea_value !2 * base = base + base
    !mul(pArea_value,tHeight_value)    2base * tHeight
    mov     pArea_value,%o0            !first operand
    call    .mul                       !call multiply, result stored in %o0
    mov     tHeight_value,%o1          !fill delay slot, second operand
    mov     %o0,pArea_value            !copy result to local register
    !mul(base_value,base_value)        base * base
    mov     base_value,%o0             !first operand
    call    .mul                       !call multiply, result stored in %o0
    mov     base_value,%o1             !fill delay slot, second operand
	!last time base's value is needed, so we can overwrite with (base*base)
    !mov     %o0,base_value             !copy result to local register
    add     %o0,pArea_value,pArea_value !(2base*tHeight) + (base*base)
	
    !print results:
    set     outformat_results,%o0      !set output string
    mov     pArea_value,%o1            !move area result into %o1
    call    printf                     !print
    mov     pVolume_value,%o2          !fill delay slot, volume to %o2
    !fall through to done and EXIT...
	
done:	
    call    exit,0                     !exit routine
    mov     0,%o0                      !move return code into delay slot

base_error:
    set     negative_base,%o0          !set output string
    call    printf,0                   !print
    nop                                !can't fill delay slot
    b       done                       !branch to done
    nop                                !can't fill delay slot
	
height_error:
    set     not_pyramid,%o0            !set output string
    call    printf,0                   !print
    nop                                !can't fill delay slot
    b       done                       !branch to done
    nop                                !can't fill delay slot
