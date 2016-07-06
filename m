Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34801 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbcGFWOJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 18:14:09 -0400
Received: by mail-pf0-f170.google.com with SMTP id h14so56557pfe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 15:14:09 -0700 (PDT)
Received: from [192.168.0.105] (c-73-71-109-161.hsd1.ca.comcast.net. [73.71.109.161])
        by smtp.googlemail.com with ESMTPSA id c13sm6608748pfc.40.2016.07.06.15.14.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 15:14:07 -0700 (PDT)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Corey Coughlin <corey.coughlin.cc3@gmail.com>
Subject: raid1 has failing disks, but smart is clear
Message-ID: <577D82AE.3040005@gmail.com>
Date: Wed, 6 Jul 2016 15:14:06 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
     Hoping you all can help, have a strange problem, think I know 
what's going on, but could use some verification.  I set up a raid1 type 
btrfs filesystem on an Ubuntu 16.04 system, here's what it looks like:

btrfs fi show
Label: none  uuid: 597ee185-36ac-4b68-8961-d4adc13f95d4
     Total devices 10 FS bytes used 3.42TiB
     devid    1 size 1.82TiB used 1.18TiB path /dev/sdd
     devid    2 size 698.64GiB used 47.00GiB path /dev/sdk
     devid    3 size 931.51GiB used 280.03GiB path /dev/sdm
     devid    4 size 931.51GiB used 280.00GiB path /dev/sdl
     devid    5 size 1.82TiB used 1.17TiB path /dev/sdi
     devid    6 size 1.82TiB used 823.03GiB path /dev/sdj
     devid    7 size 698.64GiB used 47.00GiB path /dev/sdg
     devid    8 size 1.82TiB used 1.18TiB path /dev/sda
     devid    9 size 1.82TiB used 1.18TiB path /dev/sdb
     devid   10 size 1.36TiB used 745.03GiB path /dev/sdh

I added a couple disks, and then ran a balance operation, and that took 
about 3 days to finish.  When it did finish, tried a scrub and got this 
message:

scrub status for 597ee185-36ac-4b68-8961-d4adc13f95d4
     scrub started at Sun Jun 26 18:19:28 2016 and was aborted after 
01:16:35
     total bytes scrubbed: 926.45GiB with 18849935 errors
     error details: read=18849935
     corrected errors: 5860, uncorrectable errors: 18844075, unverified 
errors: 0

So that seems bad.  Took a look at the devices and a few of them have 
errors:
...
[/dev/sdi].generation_errs 0
[/dev/sdj].write_io_errs   289436740
[/dev/sdj].read_io_errs    289492820
[/dev/sdj].flush_io_errs   12411
[/dev/sdj].corruption_errs 0
[/dev/sdj].generation_errs 0
[/dev/sdg].write_io_errs   0
...
[/dev/sda].generation_errs 0
[/dev/sdb].write_io_errs   3490143
[/dev/sdb].read_io_errs    111
[/dev/sdb].flush_io_errs   268
[/dev/sdb].corruption_errs 0
[/dev/sdb].generation_errs 0
[/dev/sdh].write_io_errs   5839
[/dev/sdh].read_io_errs    2188
[/dev/sdh].flush_io_errs   11
[/dev/sdh].corruption_errs 1
[/dev/sdh].generation_errs 16373

So I checked the smart data for those disks, they seem perfect, no 
reallocated sectors, no problems.  But one thing I did notice is that 
they are all WD Green drives.  So I'm guessing that if they power down 
and get reassigned to a new /dev/sd* letter, that could lead to data 
corruption.  I used idle3ctl to turn off the shut down mode on all the 
green drives in the system, but I'm having trouble getting the 
filesystem working without the errors.  I tried a 'check --repair' 
command on it, and it seems to find a lot of verification errors, but it 
doesn't look like things are getting fixed.  But I have all the data on 
it backed up on another system, so I can recreate this if I need to.  
But here's what I want to know:

1.  Am I correct about the issues with the WD Green drives, if they 
change mounts during disk operations, will that corrupt data?
2.  If that is the case:
     a.) Is there any way I can stop the /dev/sd* mount points from 
changing?  Or can I set up the filesystem using UUIDs or something more 
solid?  I googled about it, but found conflicting info
     b.) Or, is there something else changing my drive devices?  I have 
most of drives on an LSI SAS 9201-16i card, is there something I need to 
do to make them fixed?
     c.) Or, is there a script or something I can use to figure out if 
the disks will change mounts?
     d.) Or, if I wipe everything and rebuild, will the disks with the 
idle3ctl fix work now?

Regardless of whether or not it's a WD Green drive issue, should I just 
wipefs all the disks and rebuild it?  Is there any way to recover this?  
Thanks for any help!


     ------- Corey
