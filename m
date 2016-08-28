Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v-27-120-84-145.ub-freebit.net ([27.120.84.145]:46250 "EHLO
        mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbcH1ImK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 04:42:10 -0400
Received: from rose (218-45-17-226.flets.kamome.or.jp [218.45.17.226])
        by mail.reasonset.net (Postfix) with ESMTPSA id 111CF7C48001
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 17:41:14 +0900 (JST)
Date: Sun, 28 Aug 2016 17:41:13 +0900
From: MASAKI Yuhsuke <yek@reasonset.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Crush on btrfs device delete missing
Message-ID: <20160828174113.2854956a@rose>
In-Reply-To: <pan$74431$bc836653$60152c18$c71d2df3@cox.net>
References: <20160828142252.0ded31f7@rose>
        <pan$74431$bc836653$60152c18$c71d2df3@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan.

Sorry, I was careless.
(And sorry illrelevant To header.)

System is a Kernel 4.7.2 Manjaro Linux default setting.

===
$ uname -r
4.7.2-1-MANJARO
===

and btrfs progs.

===
$ pacman -Q btrfs-progs
btrfs-progs 4.7-1
===

result of btrfs fi usage /path/to/volume

===
Overall:
    Device size:		  19.10TiB
    Device allocated:		  10.71TiB
    Device unallocated:		   8.39TiB
    Device missing:		   2.73TiB
    Used:			  10.71TiB
    Free (estimated):		   4.19TiB	(min: 4.19TiB)
    Data ratio:			      2.00
    Metadata ratio:		      1.99
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,RAID1: Size:5.34TiB, Used:5.34TiB
   /dev/dm-1	   1.78TiB
   /dev/dm-2	   1.78TiB
   /dev/dm-3	   1.78TiB
   /dev/dm-4	   1.78TiB
   /dev/dm-5	   1.78TiB
   /dev/mapper/hymaster_6	   2.00GiB
   missing	   1.78TiB

Metadata,single: Size:112.00MiB, Used:0.00B
   /dev/dm-1	  16.00MiB
   /dev/dm-2	  16.00MiB
   /dev/dm-3	  16.00MiB
   /dev/dm-4	  16.00MiB
   /dev/dm-5	  24.00MiB
   missing	  24.00MiB

Metadata,RAID1: Size:14.00GiB, Used:12.40GiB
   /dev/dm-1	   3.00GiB
   /dev/dm-2	   3.00GiB
   /dev/dm-3	   6.00GiB
   /dev/dm-4	   5.00GiB
   /dev/dm-5	   5.00GiB
   missing	   6.00GiB

System,RAID1: Size:32.00MiB, Used:784.00KiB
   /dev/dm-1	  32.00MiB
   /dev/dm-2	  32.00MiB

Unallocated:
   /dev/dm-1	 966.47GiB
   /dev/dm-2	 965.47GiB
   /dev/dm-3	 966.50GiB
   /dev/dm-4	 965.50GiB
   /dev/dm-5	 965.50GiB
   /dev/mapper/hymaster_6	   2.73TiB
   missing	 967.50GiB
===

Result of btrfs filesystem show /path/to/volume

===
Label: 'HyMasterBtr'  uuid: c78a98fb-4718-4f30-abae-466ebf6e2d8f
	Total devices 7 FS bytes used 5.36TiB
	devid    1 size 2.73TiB used 1.79TiB path /dev/mapper/hymaster_1
	devid    2 size 2.73TiB used 1.79TiB path /dev/mapper/hymaster_2
	devid    4 size 2.73TiB used 1.79TiB path /dev/mapper/hymaster_3
	devid    5 size 2.73TiB used 1.79TiB path /dev/mapper/hymaster_4
	devid    6 size 2.73TiB used 1.79TiB path /dev/mapper/hymaster_5
	devid    7 size 2.73TiB used 2.00GiB path /dev/mapper/hymaster_6
	*** Some devices missing
===

Result of btrfs filesystem df

===
Data, RAID1: total=5.34TiB, used=5.34TiB
System, RAID1: total=32.00MiB, used=784.00KiB
Metadata, RAID1: total=14.00GiB, used=12.40GiB
Metadata, single: total=112.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B
===


Thank you.



On Sun, 28 Aug 2016 08:06:47 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> MASAKI Yuhsuke posted on Sun, 28 Aug 2016 14:22:52 +0900 as excerpted:
> 
> > btrfs device delete missing always crushes and stop system.
> > It log console only not STDOUT/STDERR or core file.  
> 
> While I'm unlikely to be able to help with the problem, for those who 
> can, you're missing some critical information, including kernel and
> btrfs- progs versions (if they're old, please try a current 4.6 or
> 4.7 kernel if on current, or 4.4 if on LTS, and an appropriately
> matched or newer btrfs userspace as well), and btrfs filesystem usage
> or btrfs filesystem show and btrfs filesystem df outputs.
> 

