Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59362 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaJLW4I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 18:56:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XdS3Z-00047S-VF
	for linux-btrfs@vger.kernel.org; Mon, 13 Oct 2014 00:56:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 00:56:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 00:56:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [REGRESSION?] Used+avail gives more than size of device
Date: Sun, 12 Oct 2014 22:55:54 +0000 (UTC)
Message-ID: <pan$10714$bcab7b52$f88ec3cf$1547168d@cox.net>
References: <10721429.ggFParDapp@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 12 Oct 2014 11:56:51 +0200 as excerpted:


> On 3.17, i.e. since the size reporting changes, I get:
> 
> merkaba:~> LANG=C df -hT -t btrfs
> Filesystem              Type   Size  Used Avail Use% Mounted on
> /dev/mapper/sata-debian btrfs   30G   19G   21G  48% /
> /dev/mapper/sata-debian btrfs   30G   19G   21G  48% /mnt/debian-zeit
> /dev/mapper/msata-daten btrfs  200G  185G   15G  93% /daten
> /dev/mapper/msata-home  btrfs  160G  135G   48G  75% /mnt/home-zeit
> /dev/mapper/msata-home  btrfs  160G  135G   48G  75% /home
> 
> I wonder about used and avail not adding up to total size of filesystem:
> 19+21 = 40 GiB instead of 30 GiB for / and 135+48 = 183 GiB for /home.
> Only /daten seems to be correct.

That's standard df, not btrfs fi df.

Due to the way btrfs works and the constraints of the printing format 
that standard df uses, it cannot and will not present a full picture of 
filesystem usage.  Some compromises must be made in the choice of which 
available filesystem stats to present and the manner in which they are 
presented within the limited df format, and no matter which compromises 
are chosen, standard df output will always look a bit screwy for /some/ 
btrfs filesystem layouts.

> / and /home are RAID 1 spanning two SSDs. /daten is single.
> 
> I wondered about compression taken into account? They use compress=lzo.
> [...]  Any explaination for the discrepancy, can it just be due to the
> compression?

It's not compression, but FWIW, I believe I know what's going on...

> merkaba:~> mount | grep btrfs
> /dev/mapper/sata-debian on / type btrfs
> (rw,noatime,compress=lzo,ssd,space_cache)
> /dev/mapper/sata-debian on /mnt/debian-zeit type btrfs
> (rw,noatime,compress=lzo,ssd,space_cache)
> /dev/mapper/msata-daten on /daten type btrfs
> (rw,noatime,compress=lzo,ssd,space_cache)
> /dev/mapper/msata-home on /mnt/home-zeit type btrfs
> (rw,noatime,compress=lzo,ssd,space_cache)
> /dev/mapper/msata-home on /home type btrfs
> (rw,noatime,compress=lzo,ssd,space_cache)
> 
> 
> merkaba:~> btrfs fi sh
> Label: 'debian'  uuid: […]
>    Total devices 2 FS bytes used 18.47GiB
>    devid   1 size 30.00GiB used 30.00GiB path /dev/mapper/sata-debian
>    devid   2 size 30.00GiB used 30.00GiB path /dev/mapper/msata-debian
> 
> Label: 'daten'  uuid: […]
>    Total devices 1 FS bytes used 184.82GiB
>    devid   1 size 200.00GiB used 188.02GiB path /dev/mapper/msata-daten
> 
> Label: 'home'  uuid: […]
>    Total devices 2 FS bytes used 134.39GiB
>    devid   1 size 160.00GiB used 160.00GiB path /dev/mapper/msata-home
>    devid   2 size 160.00GiB used 160.00GiB path /dev/mapper/sata-home
> 
> 
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.99GiB, used=17.84GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=645.88MiB
> unknown, single: total=224.00MiB, used=0.00

> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=131.46GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=2.93GiB
> unknown, single: total=512.00MiB, used=0.00

> merkaba:~> btrfs fi df /daten
> Data, single: total=187.01GiB, used=184.53GiB
> System, single: total=4.00MiB, used=48.00KiB
> Metadata, single: total=1.01GiB, used=292.31MiB
> unknown, single: total=112.00MiB, used=0.00


Side observation, doesn't look like you have btrfs-progs 3.16.1 yet, 
since btrfs fi df is still reporting unknown for that last chunk-type 
instead of global reserve.


While I didn't follow the (standard) df information presentation change 
discussion closely enough to know what the resolution was, looking at the 
numbers above I believe I know what's going on with df.

First, focus on "used", using / as an example.

df (standard) used:			19 G
btrfs fi show (total line) used:	18.47 GiB
btrfs fi df (sum all types) used:	17.84 GiB + 646 MiB ~= 18.5 GiB

So the displayed usage for all three reports agrees, roughly 19 G used.

Compression?  Only actual (used) data/metadata can compress, the left 
over free space won't; it's "left over".  So any effects of compression 
would be seen in the above "used" numbers.  The numbers above are close 
enough to each other that compression can't be playing a part.[1]

OK, so what's deal with (standard) df, then?  If the discrepancy isn't 
coming from used, where's it coming from?

Simple enough.  What's the big difference between the filesystem that 
appears correct and the other two?  Big hint, take a look at the second 
field of the btrfs fi df output.  Hint #2, btrfs fi show, count the 
number of devices.

Back to standard df, "available": 

/	21 GiB	/2	10.5 GiB	10.5 (avail) + 19 (used) ~  30 GiB
/data	15 GiB	--	15 GiB		15 (avail) + 185 (used)  ~ 200 GiB
/home	48 GiB	/2	24 GiB	 	24 (avail) + 135 (used)  ~ 160 GiB

It's the raid-factor.  =:^)

Btrfs in the kernel is apparently accounting for raid-factor in used 
space in whatever function standard df is using, but not in available 
space, even where that available space is already chunk-allocated (btrfs 
fi show, individual devices, size vs. used, where "used" simply means 
chunk-allocated for show) and thus the raid-factor known.

---
[1] As an exercise, try comparing du's usage numbers with the above.  Its
--apparent-size parameter can be informative as well, given that btrfs 
folds small files directly into the metadata and thus doesn't take a full 
4KiB block for them.

For my small 8-gig btrfs / here, used:

df -m:				2109
du -xsm:			3462
du -xsm --apparent-size:	2817
btrfs fi show, totals line:	2058 (2.01 GiB * 1024)

With raid1 for both data and metadata so metadata-folded files have the 
same number of copies as data, if I'm reading the numbers correctly:

3462 - 2817	=	645 MiB saved due to small-file folding.

2817 - 2109	=	708 MiB saved due to lzo.

(The 2109 to 2058 difference is I guess due to differences in calculation 
method and rounding error.)

FWIW I used reiserfs previously and still use it on my spinning rust.  It 
does "tail folding" but not transparent compression, and when I switched 
to btrfs with lzo I noticed usage dropped, not by great leaps, but 
noticeably.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

