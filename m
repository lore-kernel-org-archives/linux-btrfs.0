From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs balancing start - and stop?
Date: Wed, 6 Apr 2011 12:43:50 +0100
Message-ID: <chaz20110406114350.GA20568@seebyte.com>
References: <20110403185341.GA11024@yahoo.fr> <Bj8nJL4D1uB@helmut.hullen.de> <20110404190753.GC9371@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110404190753.GC9371@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-04 20:07:54 +0100, Stephane Chazelas:
[...]
> > > 4.7 more days to go. And I reckon it will have written about 9
> > > TB to disk by that time (which is the total size of the volume,
> > > though only 3.8TB are occupied).
> > 
> > Yes - that's the pessimistic estimation. As Hugo has explained it can  
> > finish faster - just look to the data tomorrow again.
> [...]
> 
> That may be an optimistic estimation actually, as there hasn't
> been much progress in the last 34 hours:
[...]

The rate is going down. It's now down to about 14kB/s

[658654.295752] btrfs: relocating block group 3919858106368 flags 20
[671932.913235] btrfs: relocating block group 3919589670912 flags 20
[686189.296126] btrfs: relocating block group 3919321235456 flags 20
[701511.523990] btrfs: relocating block group 3919052800000 flags 20
[718591.316339] btrfs: relocating block group 3918784364544 flags 20
[725567.081031] btrfs: relocating block group 3918515929088 flags 20
[744415.011581] btrfs: relocating block group 3918247493632 flags 20
[762365.021458] btrfs: relocating block group 3917979058176 flags 20
[780504.726067] btrfs: relocating block group 3917710622720 flags 20

Even though it is reading and writing to disk at a much higher
rate. Here stats every second:

--dsk/sda-----dsk/sdb-----dsk/sdc--
 read  writ: read  writ: read  writ
   0     0 : 540k    0 :  12k    0
   0     0 : 704k    0 :  20k    0
   0     0 :1068k    0 :  24k    0
   0     0 : 968k    0 :   0     0
   0     0 : 932k    0 :4096B    0
   0     0 : 832k  880k: 152k 1320k
  60k 4096B: 880k  140k:   0    28M
  68k    0 : 308k    0 :4096B 9240k
   0    48k:   0     0 :   0  7852k
   0     0 : 576k 6192k:4096B   26M
   0     0 : 100k   18M:   0     0
   0     0 :  28k   10M:   0     0
   0     0 :   0  7020k:   0     0
   0     0 :  52k   13M:   0     0
   0    12k: 528k   17M:   0    12k
   0     0 : 884k    0 :8192B    0
   0     0 :1068k    0 :  20k    0
   0     0 : 660k    0 :   0     0
   0    40k: 776k    0 :4096B    0
   0     0 : 576k    0 :   0     0
   0     0 : 596k    0 :8192B    0
1096k   28k: 664k    0 :4096B    0
   0     0 : 660k    0 :   0     0
   0     0 : 592k    0 :8192B    0

At this rate, the balancing would be over in about 8 years.

Since the start of the balance:
Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sda              10.04         1.56         1.57    1228286    1237359
sdc             396.24         1.77         3.95    1397015    3115057
sdb             421.17         1.87         3.95    1473759    3115093

I think that's the end of my attempt to transfer that FS to
another machine (see other thread). I'll have to ditch that copy
and try again from scratch with another approach.

Before I do that, is there anything I can do to help investigate
the problem?

regards,
Stephane
