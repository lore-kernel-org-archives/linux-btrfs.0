Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exchange-west-ht02.tripadvisor.com ([192.170.138.102]:8684 "EHLO
	exchange-west.tripadvisor.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbaHTNrN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 09:47:13 -0400
Message-ID: <53F4A59E.6090907@tripadvisor.com>
Date: Wed, 20 Aug 2014 09:41:50 -0400
From: "Benjamin O'Connor" <boconnor@tripadvisor.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
References: <0f416a00a2dabac75caa768581a5e965@admin.virtall.com>
In-Reply-To: <0f416a00a2dabac75caa768581a5e965@admin.virtall.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As a counter-argument, I use BTRFS on a filesystem with about 280TB raw right now as a 
fileserver.  Note that this is mostly transient data (raid 0), and I have stuck with 3.14, 
hearing the horror stories of 3.15/3.16 locking up.

Even at that size (29TB LUNs), I have been able to add and remove devices and rebalance 
with no issues other than it causing increased IO and taking several weeks to move that 
much data around.

Definitely avoid 3.15/3.16 and test out your workload first if possible to make sure it 
performs properly.  Also build the filesystem and put data on it and test device 
removals/rebuilds to make sure it works with your OS, btrfs tools, and kernel version. 
All that being said it works great for us where we value COW and expansion/rebalancing 
over performance and redundancy.

The filesystem is exported via NFS and rsync to over 200 clients over 10gb/sec ethernet, 
and hits around 5-7gb/sec balanced between reads and writes.

One of our alternative file storage needs that I'd also hoped to move to BTRFS consisted 
of subtrees of 255 directories, each with 255 directories under them, and 255 directories 
under them with 1 file in each (don't ask).  That *did not* work well under BTRFS -- 
probably due to the metadata juggling required in creating or removing any one file that 
far down in such a bizarre tree.  We kept that particular area under XFS.

-ben


Tomasz Chmielewski wrote:
>>> we are thinking about using BtrFS on standard hardware for a
>>> fileserver with about 50T (100T raw) of storage (25Ã—4TByte).
>>>
>>
>> I would recommend carefully reading this thread titled: "1 week to
>> rebuid 4x 3TB raid10 is a long time!"
>
> So I have a 2 x 2.6 TB devices in btrfs RAID-1, 716G used. Linux 3.16.
>
> One of the disks failed.
>
> "btrfs device delete missing /home" is taking 9 days so far, on an idle system:
>
> root 4828 0.3 0.0 17844 260 pts/1 D+ Aug11 38:18 btrfs device delete missing /home
>
> There is some kind of btrfs debug info printed in dmesg which seems to tell me that the
> operation is working, like:
>
> [744657.598810] BTRFS info (device sda4): relocating block group 908951814144 flags 17
> [744672.021612] BTRFS info (device sda4): found 4784 extents
> [744688.604997] BTRFS info (device sda4): found 4784 extents
> [744689.133397] BTRFS info (device sda4): relocating block group 910025555968 flags 17
> [744701.162678] BTRFS info (device sda4): found 4196 extents
> [744725.000459] BTRFS info (device sda4): found 4196 extents
>
>
> but other than that, the recovery time doesn't look optimistic to me, there is no ability
> to check the progress etc.
>
>

-- 
-----------------------------
Benjamin O'Connor
TechOps Systems Administrator
TripAdvisor Media Group

boconnor@tripadvisor.com
c. 617-312-9072
-----------------------------

