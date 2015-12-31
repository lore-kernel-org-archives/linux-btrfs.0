Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34148 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbLaQU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 11:20:29 -0500
Received: by mail-lf0-f45.google.com with SMTP id y184so241029518lfc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 08:20:29 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 31 Dec 2015 11:20:28 -0500
Message-ID: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com>
Subject: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I run a weekly scrub, using Marc Merlin's btrfs-scrub script.
Usually, it completes without a problem, but this week it failed.  I
ran the scrub manually & it stops shortly:

john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md124p2
ERROR: scrubbing /dev/md124p2 failed for device id 1: ret=-1, errno=5
(Input/output error)
scrub device /dev/md124p2 (id 1) canceled
scrub started at Thu Dec 31 00:26:34 2015 and was aborted after 00:01:29
data_extents_scrubbed: 110967
tree_extents_scrubbed: 99638
data_bytes_scrubbed: 2548817920
tree_bytes_scrubbed: 1632468992
read_errors: 0
csum_errors: 0
verify_errors: 0
no_csum: 1573
csum_discards: 74371
super_errors: 0
malloc_errors: 0
uncorrectable_errors: 0
unverified_errors: 0
corrected_errors: 0
last_physical: 4729667584

john@mariposa:~$ sudo /sbin/btrfs scrub status /dev/md124p2
scrub status for 9b5a6959-7df1-4455-a643-d369487d24aa
scrub started at Thu Dec 31 00:29:06 2015, running for 00:01:15
total bytes scrubbed: 3.46GiB with 0 errors

My Ubuntu 14.04 workstation is using the 4.2 kernel (Wily).  I'm using
btrfs-tools v4.3.1.  Btrfs is on top of mdadm raid1 (imsm).
Autodefrag is enabled. Both drives have checked out ok on smart tests.
Some directories are set up with nodatacow for VMs, etc.

john@mariposa:~$ sudo btrfs fi show
Label: none  uuid: 9b5a6959-7df1-4455-a643-d369487d24aa
Total devices 1 FS bytes used 961.46GiB
devid    1 size 1.76TiB used 978.04GiB path /dev/md124p2

Funny thing is, if the scrub hadn't failed, I wouldn't know there were
any problems!  I've rebooted twice since the original scrub that
failed w/o a problem.  I've backed up all my files to an ext4
partition, again w/o a problem.

I've been searching for a clue on the wiki, mailing list, etc. on how
to fix this, but I'm at a loss.  From what I read, I shouldn't be able
to boot my workstation.  How should I go about repairing this?  Any
help would be greatly appreciated.

Thanks.

    -John


BTW, I did run btrfs-find-root at one point & got the following:

john@mariposa:~$ sudo btrfs-find-root /dev/md124p2
Superblock thinks the generation is 1031315
Superblock thinks the level is 1
Found tree root at 1039015591936 gen 1031315 level 1
Well block 1039013101568(gen: 1031314 level: 1) seems good, but
generation/level doesn't match, want gen: 1031315 level: 1
Well block 1039003533312(gen: 1031313 level: 1) seems good, but
generation/level doesn't match, want gen: 1031315 level: 1
Well block 1039006171136(gen: 1031311 level: 0) seems good, but
generation/level doesn't match, want gen: 1031315 level: 1

... 500+ lines skipped...

Well block 519183810560(gen: 163422 level: 0) seems good, but
generation/level doesn't match, want gen: 1031315 level: 1
Well block 143915876352(gen: 38834 level: 0) seems good, but
generation/level doesn't match, want gen: 1031315 level: 1
Well block 4243456(gen: 3 level: 0) seems good, but generation/level
doesn't match, want gen: 1031315 level: 1
Well block 4194304(gen: 2 level: 0) seems good, but generation/level
doesn't match, want gen: 1031315 level: 1
