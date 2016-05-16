Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35718 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbcEPLZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 07:25:14 -0400
Received: by mail-io0-f176.google.com with SMTP id d62so205504932iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 04:25:14 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: Ferry Toth <ftoth@exalondelft.nl>, linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <796f1fb5-8e96-39e1-7149-eb67b9d4847f@gmail.com>
Date: Mon, 16 May 2016 07:25:09 -0400
MIME-Version: 1.0
In-Reply-To: <nh9p2p$cns$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-15 08:12, Ferry Toth wrote:
> Is there anything going on in this area?
>
> We have btrfs in RAID10 using 4 HDD's for many years now with a rotating
> scheme of snapshots for easy backup. <10% files (bytes) change between
> oldest snapshot and the current state.
>
> However, the filesystem seems to become very slow, probably due to the
> RAID10 and the snapshots.
While it's not exactly what you're thinking of, have you tried running 
BTRFS in raid1 mode on top of two DM/MD RAID0 volumes?  This provides 
the same degree of data integrity that BTRFS raid10 does, but gets 
measurably better performance.
>
> It would be fantastic if we could just add 4 SSD's to the pool and btrfs
> would just magically prefer to put often accessed files there and move
> older or less popular files to the HDD's.
>
> In my simple mind this can not be done easily using bcache as that would
> require completely rebuilding the file system on top of bcache (can not
> just add a few SSD's to the pool), while implementing a cache inside btrfs
> is probably a complex thing with lots of overhead.
You may want to look into dm-cache, as that doesn't require reformatting 
the source device.  It doesn't quite get the same performance as bcache, 
but for me at least, the lower performance is a reasonable trade-off for 
being able to easily convert a device to use it, and being able to 
easily convert away from it if need be.
>
> Simply telling the allocator to prefer new files to go to the ssd and
> move away unpopular stuff to hdd during balance should do the trick, or am
> I wrong?
In theory this would work as a first implementation, but it would need 
to have automatic data migration as an option to be considered 
practical, and that's not as easy to do correctly.

