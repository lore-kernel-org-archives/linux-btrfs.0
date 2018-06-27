Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54943 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbeF0ILI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 04:11:08 -0400
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bceb24d5-fa2f-b019-fc60-146fa7a62844@gmx.com>
Date: Wed, 27 Jun 2018 16:10:55 +0800
MIME-Version: 1.0
In-Reply-To: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月26日 14:00, Misono Tomohiro wrote:
> Hello Nikolay,
> 
> I noticed that commit 5d23515be669 ("btrfs: Move qgroup rescan
> on quota enable to btrfs_quota_enable") in 4.17 sometimes causes
> to fail correctly rescanning quota when quota is enabled.
> 
> Simple reproducer:
> 
> $ mkfs.btrfs -f $DEV
> $ mount $DEV /mnt
> $ dd if=/dev/urandom of=/mnt/file bs=1000 count=1000
> $ btrfs quota enbale /mnt
> $ umount /mnt
> $ btrfs check $DEV
> ...
> checking quota groups
> Counts for qgroup id: 0/5 are different
> our:            referenced 1019904 referenced compressed 1019904
> disk:           referenced 16384 referenced compressed 16384
> diff:           referenced 1003520 referenced compressed 1003520
> our:            exclusive 1019904 exclusive compressed 1019904
> disk:           exclusive 16384 exclusive compressed 16384
> diff:           exclusive 1003520 exclusive compressed 1003520
> found 1413120 bytes used, error(s) found
> ...
> 
> This can be also observed in btrfs/114. (Note that progs < 4.17
> returns error code 0 even if quota is not consistency and therefore
> test will incorrectly pass.)

BTW, would you please try to dump the quota tree for such mismatch case?

It could be a btrfs-progs bug which it should skip quota checking if it
found the quota status item has RESCAN flag.

Thanks,
Qu

> 
> My observation is that this commit changed to call initial quota rescan
> when quota is enabeld instead of first comit transaction after enabling
> quota, and therefore if there is something not commited at that time,
> their usage will not be accounted.
> 
> Actually this can be simply fixed by calling "btrfs rescan" again or
> calling "btrfs fi sync" before "btrfs quota enable".
> 
> I think the commit itself makes the code much easier to read, so it may
> be better to fix the problem in progs (i.e. calling sync before quota enable).
> 
> Do you have any thoughts?
> 
> Thanks,
> Tomohiro Misono
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
