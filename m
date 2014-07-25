Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758889AbaGYCQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 22:16:55 -0400
Message-ID: <53D1BE15.1080000@cn.fujitsu.com>
Date: Fri, 25 Jul 2014 10:16:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: integration tree updated
References: <53D1B595.7070908@fb.com>
In-Reply-To: <53D1B595.7070908@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi chris,

It seems that two of my wrong patches got merged in integration branch:
6068d17c8ab5bce946e9678ed2064e9f966cbe62 btrfs: Merge default subvolume 
mount codes into btrfs_mount_subvol().
8a2166332e332541f13b34b7248c0f14f575731e btrfs: Call mount_subtree() 
even 'subvolid=' mount option is given.

These two patches does not completely work, and the successor patch is 
under review.(the show_path one)

If it is OK for you, please remove these two patches.

Thanks,
Qu
-------- Original Message --------
Subject: integration tree updated
From: Chris Mason <clm@fb.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年07月25日 09:40
> Hi everyone,
>
> I've pushed out my current integration branch.  It does have a few of
> Miao Xie's patches missing because there were some rejects.  I think
> this was just because some things got pulled in out of order, and I'll
> get it fixed up.
>
> Also missing is Mark's quota snapshot deletion fixes.  They were
> crashing during btrfs/011 with CONFIG_DEBUG_PAGE_ALLOC on.  We'll get
> that nailed down.
>
> integration is subject to rebasing, so please treat it more like a patch
> queue.  It is very lightly tested, the goal is just to show which
> patches are already applied and which ones are still pending.
>
> Thanks!
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

