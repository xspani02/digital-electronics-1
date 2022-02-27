# Lab 2: Šimon Špánik

### 2-bit comparator

1. Karnaugh maps for other two functions:

   Greater than:

   ![B g A](https://user-images.githubusercontent.com/99726477/155887139-491d2bc8-d9de-4e19-b0db-ba059ca9e463.PNG)

   Less than:

   ![B l A](https://user-images.githubusercontent.com/99726477/155887145-95719413-5a29-4c26-9e0e-dae9470a6c53.PNG)

2. Equations of simplified SoP (Sum of the Products) form of the "greater than" function and simplified PoS (Product of the Sums) form of the "less than" function.

   ![image](https://user-images.githubusercontent.com/99726477/155887119-60e91d3d-1e67-4921-9b7c-61b4b856c633.png)
### 4-bit comparator

1. Listing of VHDL stimulus process from testbench file (`testbench.vhd`) with at least one assert (use BCD codes of your student ID digits as input combinations). Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

   Last two digits of my student ID: **xxxx??**

```vhdl
    p_stimulus : process
    begin
        -- Report a note at the beginning of stimulus process
        report "Stimulus process started" severity note;

        -- First test case
        s_b <= "0101"; -- Such as "0101" if ID = xxxx56
        s_a <= "1001";        -- Such as "0110" if ID = xxxx56
        wait for 100 ns;
        -- Expected output
        assert ((s_B_greater_A = 'WRITE_CORRECT_VALUE_HERE') and
                (s_B_equals_A  = 'WRITE_CORRECT_VALUE_HERE') and
                (s_B_less_A    = 'WRITE_CORRECT_VALUE_HERE'))
        -- If false, then report an error
        report "Input combination COMPLETE_THIS_TEXT FAILED" severity error;

        -- Report a note at the end of stimulus process
        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;
```

2. Text console screenshot during your simulation, including reports.

   ![image](https://user-images.githubusercontent.com/99726477/155330053-fe5c5a28-c323-40a8-951f-1e7da239ac28.png)

3. Link to your public EDA Playground example:

  https://www.edaplayground.com/x/N4qk
