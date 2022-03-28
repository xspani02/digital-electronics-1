# Lab 6: YOUR_FIRSTNAME LASTNAME

### Bidirectional counter

1. Listing of VHDL code of the completed process `p_cnt_up_down`. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
    --------------------------------------------------------
    -- p_cnt_up_down:
    -- Clocked process with synchronous reset which implements
    -- n-bit up/down counter.
    --------------------------------------------------------
    p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then   -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear all bits

            elsif (en_i = '1') then -- Test if counter is enabled

                if (cnt_up_i = '1') then 
                    s_cnt_local <= s_cnt_local + 1;
                elsif (cnt_up_i = '0') then 
                    s_cnt_local <= s_cnt_local - 1;
                end if;
            end if;
        end if;
    end process p_cnt_up_down;
```

2. Screenshot with simulated time waveforms. Test reset as well. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

  Up:
  ![image](https://user-images.githubusercontent.com/99726477/159711522-a373bf5c-cc3c-40a3-8c89-4ee17fdd8213.png)
  
  Down:
  ![image](https://user-images.githubusercontent.com/99726477/159711626-f318d413-2fdb-4e41-b27f-65e58954611a.png)


### Two counters

1. Image of the top layer structure including both counters, ie a 4-bit bidirectional counter from *Part 4* and a 16-bit counter with a 10 ms time base from *Experiments on your own*. The image can be drawn on a computer or by hand. Always name all inputs, outputs, components and internal signals!

   ![image](https://user-images.githubusercontent.com/99726477/160413677-22dbb5ff-c1f0-4fe3-a3ff-0419907611ba.png)
