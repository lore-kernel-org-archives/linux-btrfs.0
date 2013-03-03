Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-158.wadns.net ([196.220.39.158]:10604 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753252Ab3CCXg2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 18:36:28 -0500
Message-ID: <5133DE6D.8040306@swiftspirit.co.za>
Date: Mon, 04 Mar 2013 01:36:13 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send & receive produces "Too many open files in system"
References: <51220452.9070403@statystyka.net>
In-Reply-To: <51220452.9070403@statystyka.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/18 12:37 PM, Adam Ryczkowski wrote:
> ...
> to migrate btrfs from one partition layout to another.
> ...
> <source> sits on top of lvm2 logical volume, which sits on top of 
> cryptsetup Luks device which subsequentely sits on top of mdadm RAID-6 
> spanning a partition on each of 4 hard drives ... is a read-only 
> snaphot which I estimate contain ca. 100GB data.
> ...
> <destination> is btrfs multidevice raid10 filesystem, which is based 
> on 4 cryptsetup Luks devices, each live as a separate partition on the 
> same 4 physical hard drives ...
> ...
> about 8MB/sek read (and the same speed of write) from each of all 4 
> hard drives).
>
I hope you've solved this already - but if not:

The unnecessarily complex setup aside, a 4-disk RAID6 is going to be 
slow - most would have gone for a RAID10 configuration, albeit that it 
has less redundancy.

Another real problem here is that you are copying data from these disks 
to themselves. This means that for every read and write that all four of 
the disks have to do two seeks. This is time-consuming of the order of 
7ms per seek depending on the disks you have. The way to avoid these 
unnecessary seeks is to first copy the data to a separate unrelated 
device and then to copy from that device to your final destination device.

To increase RAID6 write performance (Perhaps irrelevant here) you can 
try optimising the stripe_cache_size value. It can use a ton of memory 
depending on how large a stripe cache setting you end up with. Search 
online for "mdraid stripe_cache_size".

To increase the read performance you can try optimising the md arrays' 
readahead. As above, search online for "blockdev setra". This should 
hopefully make a noticeable difference.

Good luck.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

