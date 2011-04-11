From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs balancing start - and stop?
Date: Mon, 11 Apr 2011 09:42:17 +0100
Message-ID: <chaz20110411084217.GB5587@seebyte.com>
References: <20110403185341.GA11024@yahoo.fr> <Bj8nJL4D1uB@helmut.hullen.de> <20110404190753.GC9371@yahoo.fr> <chaz20110406114350.GA20568@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110406114350.GA20568@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-04-06 12:43:50 +0100, Stephane Chazelas:
[...]
> The rate is going down. It's now down to about 14kB/s
> 
> [658654.295752] btrfs: relocating block group 3919858106368 flags 20
> [671932.913235] btrfs: relocating block group 3919589670912 flags 20
> [686189.296126] btrfs: relocating block group 3919321235456 flags 20
> [701511.523990] btrfs: relocating block group 3919052800000 flags 20
> [718591.316339] btrfs: relocating block group 3918784364544 flags 20
> [725567.081031] btrfs: relocating block group 3918515929088 flags 20
> [744415.011581] btrfs: relocating block group 3918247493632 flags 20
> [762365.021458] btrfs: relocating block group 3917979058176 flags 20
> [780504.726067] btrfs: relocating block group 3917710622720 flags 20
[...]
> At this rate, the balancing would be over in about 8 years.
[...]

Hurray! The btrfs balance eventually ran through after almost exactly 2 weeks.
It didn't get down to 0:

[1189505.152717] btrfs: found 60527 extents
[1189505.440565] btrfs: relocating block group 3910731300864 flags 20
[1199805.071045] btrfs: found 60235 extents
[1199805.447821] btrfs: relocating block group 3910462865408 flags 20
[1207914.737372] btrfs: found 58039 extents

iostat reckons 9TB have been written to  disk in the whole
process (4.5TB read from them (!?)).

There hasn't been any change in allocation though:

# df -h /backup
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda4             8.2T  3.5T  3.2T  53% /backup
# btrfs fi df /backup
Data, RAID0: total=3.42TB, used=3.41TB
System, RAID1: total=16.00MB, used=228.00KB
Metadata, RAID1: total=28.00GB, used=20.47GB
# btrfs fi show
Label: none  uuid: a0ae35c4-51f2-405f-a4bb-e4f134b1d193
        Total devices 3 FS bytes used 3.43TB
        devid    4 size 2.73TB used 1.17TB path /dev/sdc
        devid    3 size 2.73TB used 1.17TB path /dev/sdb
        devid    2 size 2.70TB used 1.14TB path /dev/sda4

Btrfs Btrfs v0.19

Still 1.5TB missing.

-- 
Stephane
