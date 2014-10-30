Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:43554 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579AbaJ3SEu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 14:04:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID1 fails to recover chunk tree
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54523D86.5040906@gmail.com>
Date: Thu, 30 Oct 2014 12:04:48 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com>
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com> <54523D86.5040906@gmail.com>
To: Zack Coffey <tech42.clickwir@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 30, 2014, at 7:30 AM, Zack Coffey <tech42.clickwir@gmail.com> wrote:

> Rob, That second drive was immediately put to use elsewhere. I figured having only the metadata on that drive, it wouldn't matter. The data stayed single and wasn't part of the second drive, only the metadata was. I must not be capable of understanding why that wouldn't work.

single profile means all devices get btrfs chunks. If you do something like:

# mkfs.btfs /dev/sda

By default you get data profile = single, and metadata profile = DUP. If you then

# btrfs add /dev/sdb /mnt/btrfs
# btrfs -mconvert=raid1  /mnt/btrfs

you now have a volume that is data = single and metadata = raid1. The way the allocator works is that it will first allocate 1GiB data chunks to the device with the most free space remaining, so if that's /dev/sdb it will allocate 1GiB data chunks there until free space is the same for both sda and sdb. And once they have equal space btrfs allocates 1GiB data chunks alternating sda and sdb.

Single profile doesn't mean only one device gets data chunks. Is that the misunderstanding?


Chris Murphy