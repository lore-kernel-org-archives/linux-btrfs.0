Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:47161 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab3ANLRV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 06:17:21 -0500
Received: by mail-la0-f48.google.com with SMTP id ej20so3642401lab.21
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2013 03:17:20 -0800 (PST)
Message-ID: <50F3E93D.7000707@gmail.com>
Date: Mon, 14 Jan 2013 11:17:17 +0000
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs for files > 10GB = random spontaneous CRC failure.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Since I had some free time over Christmas, I decided to conduct few 
tests over btrFS to se how it will cope with "real life storage" for 
normal "gray users" and I've found that filesystem will always mess up 
your files that are larger than 10GB.

Long story:
I've used my set of data that I've got nicelly backed up on personal 
raid 5 to populate btrfs volumes: music, slr pics and video (an just a 
few document). Disks used in test are all "green" 2TB disks from WD.

1. First I started with creating btrfs (4k blocks) on one disk, filling 
it up and then adding second disk -> convert to raid1 through balance -> 
convert to raid10 trough balance. Unfortunately converting to raid1 
failed - because of CRC error in 49 files that vere bigger > 10GB. At 
this point I was a bit spooked up that my controllers are failing or 
that drives got some bad sectors. Tested everything (took few days) and 
it turns out that there is no "apparent" issue with hardware (bad 
sectors or io down to disks).
2. At this point I thought "cool this will be a perfect test case for 
scrub to show it's magical power!". Created raid1 over two volumes -> 
try scrubbing -> FAIL ... It turns out that magically I've got corrupted 
CRC in two exactly same logical locations on two different disks (~34 
files > 10GB affected) hence scrub can't do anything with it. It only 
reports it as "uncorrectable errors"
3. Performed same test on raid10 setup (still 4k block). Same results 
(just different file count).

Ok, time to dig more into this because it starts get intriguing. I'm 
running ubuntu server 12.10 (64bit) with stock kernel, so my next step 
was to get 3.7.1 kernel + new btrfs tool straight from git repo.
Unfortunatelly 1 & 2 & 3 still provides same results, corrupt CRC only 
in files > 10GB.
At this point I thought "fine maybe when I'll expand allocation block - 
it will make less block needed for big file to fit in resulting in 
propperly storing those" -> time for 16K leafs :) (-n 16K -l 16K) 
sectors are still 4K for known reasons :P. Well, it does exactly the 
same thing -> 1 & 2 & 3 same results, big files get automagically corrupt.


Something about test data:
music - not more than 200MB files (tipical mix of mp3 & aac) 10 K files 
give or take.
pics - not more than 20MB (typical point & shot + dslr) 6K files give or 
take.
video1 - collection of little ones with size more than 300MB, less than 
1.5GB ~ 400 files
video2 - collection of 5GB - 18GB files ~400 files

I guess that stating that "files >10GB" are only affected is a long 
shot, but so far I've not seen file less than 10GB affected (I was not 
really thorough about checking size, but all files that size I've 
checked were more than 10GB)

ps. As a footnote I'll add that I've tried shuffling test 1, 2 & 3 
without video2 and it all work just fine.

If you've got any ideas for work around ( other than zfs :D ) I'm happy 
to try it out.

Tom.
