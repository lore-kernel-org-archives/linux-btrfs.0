Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:63167 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLMALO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 19:11:14 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so3748731yha.32
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 16:11:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141212233503.GH1442@carfax.org.uk>
References: <548B7220.1040403@pobox.com>
	<20141212225918.GG1442@carfax.org.uk>
	<548B795F.2050509@pobox.com>
	<20141212233503.GH1442@carfax.org.uk>
Date: Fri, 12 Dec 2014 17:11:14 -0700
Message-ID: <CAJCQCtRRJwYoF19Z2CVo+re9GLh13fGrrO_OyyHwTyPV4VKPDg@mail.gmail.com>
Subject: Re: RAID0 extent sizes?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on looking at how identically sized, empty, qcow2 files grow
when they're added to a Btrfs volume, the 1GiB Btrfs chunk or
allocation unit, doesn't have an immediate physical allocation. It's
more of a virtual thing, but it has a physical manifestation.

Single profile, 5 disks: As data is copied, one drive has one chunk
allocated to it, and data is copied into that chunk and thus into one
qcow2 file until the qcow2 file is about 1GiB in size. Then it stops
growing and another qcow2 file starts to grow, again up to 1GiB in
size. Until all qcow2s are 1GiB. Now when everyone is identical, they
actually aren't, chances are one of them has some little bit of extra
metadata so the allocator is going to pick the block device with the
most free space next, which is how this can affect uneven sized
devices.

For raid0,5,6 I'm not sure if my interpretation is correct. But what I
see is, at the time the chunk is allocated, the block devices with
sufficient free space belong to it; and grow in 64KB increments. e.g.
5 qcow2's in a Btrfs data raid0 will grow to ~1GiB in size each as I
copy 5GiB of data to the volume. Since I used raid1 metadata in all
cases, the qcow2's are a bit uneven in practice. If I then add a 6th
qcow2, I don't immediately notice it grow. I *think* it's because the
most recent chunk is still only writing to the block devices available
at the time that chunk was created; shortly though I start seeing that
6th qcow2 grow. This suggests that this volume has 5 strip (device)
chunks; and a 6 strip chunks.

*sigh* for what it's worth, Btrfs chunk is not the same thing as mdadm
chunk. The mdadm chunk is a strip, since that's what SNIA's dictionary
calls it. A stripe is strip x numdevices. So if you have a 5 device
raid0, that's 5 strips of 64KB each, or a stripe size of 320KB meaning
it takes a file of at least 320KB to write to all 5 disks at the same
time.

And I side note that in the latest Phoronix raid tests, Btrfs is
kicking ass compared to most everything else.

Chris Murphy
