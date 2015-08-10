Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35096 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbbHJOwB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 10:52:01 -0400
Received: by igbjg10 with SMTP id jg10so2334053igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 07:52:00 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 10 Aug 2015 10:52:00 -0400
Message-ID: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
Subject: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone,

I have a four-drive RAID1 array, and since yesterday, some problem has
rendered it unmountable (read/write anyhow).  One drive reports a read
error, so maybe the drive is failing, but I've had that happen before,
and it was easy to swap in a new drive.  This time, two more drives
are reporting that they "failed to read the system array."  I managed
to mount it read-only (by specifying the node of the fourth drive) and
rsync everything to a backup drive.  Now I'd like to try to repair.
This is where I'm running into problems.  Since I can't mount it
read-write, I can't do a scrub, so I tried "btrfs check --repair", and
this is what I got:

# btrfs check --repair /dev/sde
enabling repair mode
Checking filesystem on /dev/sde
UUID: ecdff84d-b4a2-4286-a1c1-cd7e5396901c
checking extents
ref mismatch on [1667931533312 524288] extent item 1, found 2
attempting to repair backref discrepency for bytenr 1667931533312
Ref doesn't match the record start and is compressed, please take a
btrfs-image of this file system and send it to a btrfs developer so
they can complete this functionality for bytenr 1667931639808
failed to repair damaged filesystem, aborting

Since this specifically told me to contact a developer, I figured this
is something you guys want to know about.  :)

Also, I was wondering if perhaps someone can help me figure out how to
repair it.

There are only two files that appear to be unrecoverable when I rsync,
and I can restore those from an earlier backup.  Since I can't mount
read/write, I can't go and delete those files, so I seem to be stuck.



BTRFS works beautifully with single drive configurations.  I have
multiple, and I've never had a problem.  On the other hand seem to
have LOTS of trouble with 4-drive RAID1.  I get OOPSes regularly.
I've tried reporting them on bugzilla.kernel.org, but it doesn't
appear that btrfs devs actually use that.  Is this list a better place
to report those?


Thanks for the help!

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
Open Graphics Project
