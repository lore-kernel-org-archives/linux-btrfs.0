Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34580 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbcAVO2B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 09:28:01 -0500
Received: by mail-ig0-f177.google.com with SMTP id ik10so11845866igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 06:28:01 -0800 (PST)
Subject: Re: RAID1 disk upgrade method
To: Sean Greenslade <sean@seangreenslade.com>, linux-btrfs@vger.kernel.org
References: <20160122034538.GA25196@coach.student.rit.edu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A23C45.4090805@gmail.com>
Date: Fri, 22 Jan 2016 09:27:17 -0500
MIME-Version: 1.0
In-Reply-To: <20160122034538.GA25196@coach.student.rit.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-21 22:45, Sean Greenslade wrote:
> Hi, all. I have a box running a btrfs raid1 of two disks. One of the
> disks started reallocating sectors, so I've decided to replace it
> pre-emptively. And since larger disks are a bit cheaper now, I'm trading
> up. The current disks are 2x 2TB, and I'm going to be putting in 2x 3TB
> disks. Hopefully this should be reasonably straightforward, since the
> raid is still healthy, but I wanted to ask what the best way to go about
> doing this would be.
>
> I have the ability (through shuffling other drive bays around) to mount
> the 2 existing drives + one new drive all at once. So my first blush
> thought would be to mount one of the new drives, partition it, then
> "btrfs replace" the worse existing drive.
>
> Another possibility is to "btrfs add" the new drive, balance, then
> "btrfs device delete" the old drive. Would that make more sense if the
> old drive is still (mostly) good?
>
> Or maybe I could just create a new btrfs partiton on the new device,
> copy over the data, then shuffle the disks around and balance the new
> single partition into raid1.
>
>
> Which of these makes the most sense? Or is there something else I
> haven't thought of?
Just to further back up what everyone else has said, 'btrfs replace' is 
the preferred way to do this, largely because it's significantly more 
efficient and puts less stress on the disks.  Using add/delete requires 
rewriting everything on the filesystem at least once, and possibly twice 
depending on how you do it, whereas replace just rewrites the half of 
the chunk that's on the disk being replaced, and updates some metadata 
on the other disk.

That said, if you have the time, it may be better for you to use 
send/receive and create a new filesystem from scratch so that you can be 
certain that you have a clean filesystem with all the new features.  If 
you do go this way, use send/receive if possible, it's much more 
efficient than rsync or cp, and can preserve almost everything (unlike 
rsync).
