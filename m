Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51028 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaK2Ui4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 15:38:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xuon8-0003Mx-9y
	for linux-btrfs@vger.kernel.org; Sat, 29 Nov 2014 21:38:54 +0100
Received: from 66.87.138.157 ([66.87.138.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 21:38:54 +0100
Received: from eternaleye by 66.87.138.157 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 21:38:54 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Sat, 29 Nov 2014 12:38:39 -0800
Message-ID: <m5dash$58v$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:

> On Mon, Nov 24, 2014 at 01:23:05PM +0800, Liu Bo wrote:
>> This brings a strong-but-slow checksum algorithm, sha256.
>> 
>> Actually btrfs used sha256 at the early time, but then moved to crc32c
>> for performance purposes.
>> 
>> As crc32c is sort of weak due to its hash collision issue, we need a
>> stronger algorithm as an alternative.
>> 
>> Users can choose sha256 from mkfs.btrfs via
>> 
>> $ mkfs.btrfs -C 256 /device
> 
> There's already some good feedback so I'll try to cover what hasn't been
> mentioned yet.
> 
> I think it's better to separate the preparatory works from adding the
> algorithm itself. The former can be merged (and tested) independently.
> 
> There are several checksum algorithms that trade off speed and strength
> so we may want to support more than just sha256. Easy to add but I'd
> rather see them added in all at once than one by one.

Why not just use the kernel crypto API? Then the user can just specify any 
hash the kernel supports.

> Another question is if we'd like to use different checksum for data and
> metadata. This would not cost any format change if we use the 2 bytes in
> super block csum_type.

Mmm, that might be a good reason - although maybe store an entry in some 
tree of the full crypto api spec, and have a special value of one byte 
meaning "crypto API" and the other byte counts how many bytes the csum is.

> Optional/crazy/format change stuff:
> 
> * per-file checksum algorithm - unlike compression, the whole file would
>   have to use the same csum algo
>   reflink would work iff the algos match
>   snapshotting is unaffected
> 
> * per-subvolume checksum algorithm - specify the csum type at creation
>   time, or afterwards unless it's modified
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
W

