Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:58594 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcAVDpl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 22:45:41 -0500
Received: from coach.student.rit.edu (coach.student.rit.edu [129.21.178.64])
	by cartman.routify.me (Postfix) with ESMTPSA id 4122381A62
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 22:45:40 -0500 (EST)
Date: Thu, 21 Jan 2016 22:45:38 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: linux-btrfs@vger.kernel.org
Subject: RAID1 disk upgrade method
Message-ID: <20160122034538.GA25196@coach.student.rit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all. I have a box running a btrfs raid1 of two disks. One of the
disks started reallocating sectors, so I've decided to replace it
pre-emptively. And since larger disks are a bit cheaper now, I'm trading
up. The current disks are 2x 2TB, and I'm going to be putting in 2x 3TB
disks. Hopefully this should be reasonably straightforward, since the
raid is still healthy, but I wanted to ask what the best way to go about
doing this would be.

I have the ability (through shuffling other drive bays around) to mount
the 2 existing drives + one new drive all at once. So my first blush
thought would be to mount one of the new drives, partition it, then
"btrfs replace" the worse existing drive.

Another possibility is to "btrfs add" the new drive, balance, then
"btrfs device delete" the old drive. Would that make more sense if the
old drive is still (mostly) good?

Or maybe I could just create a new btrfs partiton on the new device,
copy over the data, then shuffle the disks around and balance the new
single partition into raid1.


Which of these makes the most sense? Or is there something else I
haven't thought of?

System info:

[sean@rat ~]$ uname -a
Linux rat 4.3.3-3-ARCH #1 SMP PREEMPT Wed Jan 20 08:12:23 CET 2016
x86_64 GNU/Linux

[sean@rat ~]$ btrfs --version
btrfs-progs v4.3.1

All drives are spinning rust. Original raid1 was created ~Aug 2013, on
kernel 3.10.6.


Thanks,

--Sean
