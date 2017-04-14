Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44363 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752052AbdDNTl5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 15:41:57 -0400
Received: from merkaba.localnet (ppp-93-104-46-226.dynamic.mnet-online.de [93.104.46.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 7573A1A1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 21:35:25 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [4.9] btrfs check --repair looping over file extent discount errors
Date: Fri, 14 Apr 2017 21:35:24 +0200
Message-ID: <1603810.ePCDQapENk@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

backup harddisk connected via eSATA. Hard kernel hang, mouse pointer freezing 
two times seemingly after finishing /home backup and creating new snapshot on 
source BTRFS SSD RAID 1 for / in order to backup it. I did scrubbed / and it 
appears to be okay, but I didn´t run btrfs check on it. Anyway deleting that 
subvolume works and I as I suspected an issue with the backup disk I started 
with that one.

I got

merkaba:~> btrfs --version
btrfs-progs v4.9.1

merkaba:~> cat /proc/version
Linux version 4.9.20-tp520-btrfstrim+ (martin@merkaba) (gcc version 6.3.0 
20170321 (Debian 6.3.0-11) ) #6 SMP PREEMPT Mon Apr 3 11:42:17 CEST 2017

merkaba:~> btrfs fi sh feenwald
Label: 'feenwald'  uuid: […]
        Total devices 1 FS bytes used 1.26TiB
        devid    1 size 2.73TiB used 1.27TiB path /dev/sdc1

on Debian unstable on ThinkPad T520 connected via eSATA port on Minidock.


I am now running btrfs check --repair on it after without --repair the command 
reported file extent discount errors and it appears to loop on the same file 
extent discount errors for ages. Any advice?

I do have another backup harddisk with BTRFS that worked fine today, so I do 
not need to recover that drive immediately. I may let it run for a little more 
time, but then will abort the repair process as I really think its looping 
just over and over and over the same issues again. At some time I may just 
copy all the stuff that is on that harddisk, but not on the other one over to 
the other one and mkfs.btrfs the filesystem again, but I´d rather like to know 
whats happening here.

Here is output:

merkaba:~> btrfs check --repair /dev/sdc1
enabling repair mode
Checking filesystem on /dev/sdc1
[… UUID ommited …]
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
[… hours later …]
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072
root 257 inode 4979842 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 78798848
root 257 inode 4980212 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 143360
root 257 inode 4980214 errors 100, file extent discount
Found file extent holes:
        start: 0, len: 4227072

This basically seems to go on like this forever.

Thanks,
-- 
Martin
