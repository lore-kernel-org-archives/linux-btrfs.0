From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs balancing start - and stop?
Date: Sun, 3 Apr 2011 19:53:41 +0100
Message-ID: <20110403185341.GA11024@yahoo.fr>
References: <1301682810.11424.5.camel@sc.lan>
 <Bj0jd3Ey1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bj0jd3Ey1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-01 21:26:00 +0200, Helmut Hullen:
> Hallo, Stephane,

Hi Helmut,

> Du meintest am 01.04.11:
> 
> >> balancing about 2 TByte needed about 20 hours.
> > [...]
> 
> > I've got a balance running since Monday on a 9TB volume (3.5 of which
> > are used, 3.2 allegedly free), showing no sign of finishing soon.
> > Should I be worried?
> 
> > Using /proc/sys/vm/block_dump, I can see it's seeking all over the
> > place, which is probably why throughput is not high. I can also see
> > it writing several times to the same sectors.
> 
> 
> Hugo has explained the limits of regarding
> 
>         dmesg | grep relocating
> 
> or (more simple) the last lines of "dmesg" and looking for the  
> "relocating" lines. But: what do these lines tell now? What is the  
> (pessimistic) estimation when you extrapolate the data?
> 
> (please excuse my gerlish)
[...]

$ dmesg | grep reloc | sed -e 1b -e '$!d'
[370178.209571] btrfs: relocating block group 5612075220992 flags 20
[546163.062739] btrfs: relocating block group 3923616202752 flags 20

So, if it's to go down to zero:

$ echo $((3923616202752*(546163.062739-370178.209571)/(5612075220992-3923616202752)/86400))
4.7332292856705722

4.7 more days to go. And I reckon it will have written about 9
TB to disk by that time (which is the total size of the volume,
though only 3.8TB are occupied).

-- 
Stephane
