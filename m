Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51109 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbcBHJ2p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Feb 2016 04:28:45 -0500
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id AD9F63566D3
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Feb 2016 10:22:34 +0100 (CET)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aCzTcgOOuJ1F for <linux-btrfs@vger.kernel.org>;
	Mon,  8 Feb 2016 10:22:34 +0100 (CET)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Feb 2016 10:22:34 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 08 Feb 2016 18:22:34 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 4.4.0 - no space left with >1.7 TB free space left
Message-ID: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Linux 4.4.0 - btrfs is mainly used to host lots of test containers, 
often snapshots, and at times, there is heavy IO in many of them for 
extended periods of time. btrfs is on HDDs.


Every few days I'm getting "no space left" in a container running mongo 
3.2.1 database. Interestingly, haven't seen this issue in containers 
with MySQL. All databases have chattr +C set on their directories.

Why would it fail, if there is so much space left?


2016-02-07T06:06:14.648+0000 E STORAGE  [thread1] WiredTiger (28) 
[1454825174:633585][9105:0x7f2b7e33e700], 
file:collection-33-7895599108848542105.wt, WT_SESSION.checkpoint: 
collection-33-7895599108848542105.wt write error: failed to write 4096 
bytes at offset 20480: No space left on device
2016-02-07T06:06:14.648+0000 E STORAGE  [thread1] WiredTiger (28) 
[1454825174:648740][9105:0x7f2b7e33e700], checkpoint-server: checkpoint 
server error: No space left on device
2016-02-07T06:06:14.648+0000 E STORAGE  [thread1] WiredTiger (-31804) 
[1454825174:648766][9105:0x7f2b7e33e700], checkpoint-server: the process 
must exit and restart: WT_PANIC: WiredTiger library panic
2016-02-07T06:06:14.648+0000 I -        [thread1] Fatal Assertion 28558
2016-02-07T06:06:14.648+0000 I -        [thread1]

***aborting after fassert() failure


2016-02-07T06:06:14.694+0000 I -        [WTJournalFlusher] Fatal 
Assertion 28559
2016-02-07T06:06:14.694+0000 I -        [WTJournalFlusher]

***aborting after fassert() failure


2016-02-07T06:06:15.203+0000 F -        [WTJournalFlusher] Got signal: 6 
(Aborted).






# df -h /srv
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda4       2.7T  1.1T  1.7T  39% /srv

# btrfs fi df /srv
Data, RAID1: total=1.25TiB, used=1014.01GiB
System, RAID1: total=32.00MiB, used=240.00KiB
Metadata, RAID1: total=15.00GiB, used=13.13GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs fi show /srv
Label: 'btrfs'  uuid: 105b2e0c-8af2-45ee-b4c8-14ff0a3ca899
         Total devices 2 FS bytes used 1.00TiB
         devid    1 size 2.63TiB used 1.26TiB path /dev/sda4
         devid    2 size 2.63TiB used 1.26TiB path /dev/sdb4

btrfs-progs v4.0.1



Tomasz Chmielewski
http://wpkg.org

