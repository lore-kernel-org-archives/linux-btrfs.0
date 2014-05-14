Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:9061 "EHLO
	mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENS2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 14:28:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 14 May 2014 20:43:41 +0200
From: laie <laie@halifax.rwth-aachen.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: destroyed disk in btrfs raid
In-Reply-To: <20140511141957.GC23212@carfax.org.uk>
References: <2a45648842c071a8e0d3285541d96c6f@halifax.rwth-aachen.de>
 <20140509175827.GG16185@carfax.org.uk>
 <20140509180137.GH16185@carfax.org.uk>
 <c1b636dffe4c70c4e15010000e730703@halifax.rwth-aachen.de>
 <20140511141957.GC23212@carfax.org.uk>
Message-ID: <91b2e7cdfaa8aa12469240cf4a2e3d05@halifax.rwth-aachen.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-05-11 16:19, Hugo Mills wrote:
> On Tue, May 13, 2014 at 10:16:59AM +0200, laie wrote:
>> On 2014-05-09 20:01, Hugo Mills wrote:
>> >On Fri, May 09, 2014 at 06:58:27PM +0100, Hugo Mills wrote:
>> >>On Fri, May 09, 2014 at 08:02:45PM +0200, laie wrote:
>> >>> Now I'm looking for a way to tell btrfs to provide me with a list of the
>> >>> corrupted files and delete them afterwards. This would be great, because
>> >>> otherwise it would take very long to get the data back from slow backups.
>> >>
>> >>   Simple solution: cat every file to /dev/null, and see which ones
>> >>fail with an I/O error. With RAID-0 data, losing a device is going to
>> >>damage most files, though, so don't necessarily expect much to survive.

I finished building the List, about 40% of the Data is gone. So far so 
good.

As next step I planned to delete these files. This is not possible 
because I'm not able to mount the fs r/w.

btrfs: allowing degraded mounts
btrfs: bdev /dev/mapper/luks-0 errs: wr 37519, rd 32783, flush 0, 
corrupt 0, gen 0
Btrfs: too many missing devices, writeable mount is not allowed
btrfs: open_ctree failed

Is it correct remove the missing device now:

btrfs device delete missing /mnt

Or do I have to add the replacement first?
