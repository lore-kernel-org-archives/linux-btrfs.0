From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs balancing start - and stop?
Date: Mon, 4 Apr 2011 20:07:54 +0100
Message-ID: <20110404190753.GC9371@yahoo.fr>
References: <20110403185341.GA11024@yahoo.fr>
 <Bj8nJL4D1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj8nJL4D1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-03 21:35:00 +0200, Helmut Hullen:
> Hallo, Stephane,
> 
> Du meintest am 03.04.11:
> 
> >>>> balancing about 2 TByte needed about 20 hours.
> 
> [...]
> 
> >> Hugo has explained the limits of regarding
> >>
> >>         dmesg | grep relocating
> >>
> >> or (more simple) the last lines of "dmesg" and looking for the
> >> "relocating" lines. But: what do these lines tell now? What is the
> >> (pessimistic) estimation when you extrapolate the data?
> 
> [...]
> 
> > 4.7 more days to go. And I reckon it will have written about 9
> > TB to disk by that time (which is the total size of the volume,
> > though only 3.8TB are occupied).
> 
> Yes - that's the pessimistic estimation. As Hugo has explained it can  
> finish faster - just look to the data tomorrow again.
[...]

That may be an optimistic estimation actually, as there hasn't
been much progress in the last 34 hours:

# dmesg | awk -F '[][ ]+' '/reloc/ &&n++%5==0 {x=(n-$7)/($2-t)/1048576; printf "%s\t%s\t%.2f\t%*s\n", $2/3600,$7, x, x/3, ""; t=$2; n=$7}' | tr ' ' '*' | tail -40
125.629 4170039951360   11.93   ***
125.641 4166818725888   70.99   ***********************
125.699 4157155049472   43.87   **************
125.753 4144270147584   63.34   *********************
125.773 4137827696640   84.98   ****************************
125.786 4134606471168   64.39   *********************
125.823 4124942794752   70.09   ***********************
125.87  4112057892864   71.66   ***********************
125.887 4105615441920   100.60  *********************************
125.898 4102394216448   81.26   ***************************
125.935 4092730540032   69.06   ***********************
126.33  4085751218176   4.69    *
131.904 4072597880832   0.63
132.082 4059712978944   19.20   ******
132.12  4053270528000   45.52   ***************
132.138 4050049302528   45.60   ***************
132.225 4040385626112   29.68   *********
132.267 4027500724224   81.17   ***************************
132.283 4021058273280   106.31  ***********************************
132.29  4017837047808   110.42  ************************************
132.316 4008173371392   100.54  *********************************
132.358 3995288469504   81.18   ***************************
132.475 3988846018560   14.62   ****
132.514 3985624793088   21.55   *******
132.611 3975961116672   26.40   ********
132.663 3963076214784   65.31   *********************
132.678 3956633763840   120.11  ****************************************
132.685 3956365328384   10.26   ***
137.701 3949922877440   0.34
137.709 3946701651968   106.54  ***********************************
137.744 3937037975552   72.10   ************************
137.889 3927105863680   18.18   ******
137.901 3926837428224   5.85    *
141.555 3926300557312   0.04
141.93  3925226815488   0.76
151.227 3924421509120   0.02
151.491 3924153073664   0.27
151.712 3923616202752   0.64
165.301 3922542460928   0.02
174.346 3921737154560   0.02

At this rate (third field expressed in MiB/s), it could take
months to complete.

iostat still reports writes at about 5MiB/s though. Note that
this system is not doing anything else at all.

There definitely seems to be scope for optimisation in the
"balancing" I'd say.

-- 
Stephane
