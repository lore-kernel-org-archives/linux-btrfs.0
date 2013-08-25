Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40014 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755320Ab3HYT3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 15:29:20 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Ability to free space on a full btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <521A2F78.908@dalmat.net>
Date: Sun, 25 Aug 2013 13:29:15 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <502292E7-02F9-4398-905B-BA58D186CA7E@colorremedies.com>
References: <521A2F78.908@dalmat.net>
To: Matthieu Dalstein <matthieu.dalstein@dalmat.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2013, at 10:23 AM, Matthieu Dalstein <matthieu.dalstein@dalmat.net> wrote:

> athena:~# btrfs fi df /mnt/storage/
> Data: total=613.30GB, used=472.69GB

So it seems the issue is that data chunks once allocated aren't deallocated, and 

> Metadata, DUP: total=3.00GB, used=2.50GB

the file system is thus unable to allocate another metadata chunk. So it's stuck. I don't know if removing a snapshot will necessarily help but it may be worth a try and see if these numbers change enough to allow file deletion. 

Another way out of this that's worked for some people in the past is to btrfs device add another disk to the volume. Maybe just 1GB of USB stick space is enough so that it can allocate another metadata chunk. But I'd give it as much of the fastest storage you have: can be any disk partition, or LV. But I've also done it with a USB stick partition.

After it's added, see if you can do a balance, which should free most of those 141GB of data chunks. And then you can btrfs device delete the recently added device, which will move whatever data/metadata chunks are on it, back to the primary device for the volume.


Chris Murphy