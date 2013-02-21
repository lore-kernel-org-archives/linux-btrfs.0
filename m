Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55284 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3BUN0a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 08:26:30 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id F2F077C067E
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 06:26:29 -0700 (MST)
Date: Thu, 21 Feb 2013 08:26:27 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: fix wrong outstanding_extents when doing DIO write
Message-ID: <20130221132627.GC12051@shiny.masoncoding.com>
References: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
 <5125ED66.4060405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5125ED66.4060405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 02:48:22AM -0700, Miao Xie wrote:
> When running the 083th case of xfstests on the filesystem with
> "compress-force=lzo", the following WARNINGs were triggered.
>   WARNING: at fs/btrfs/inode.c:7908
>   WARNING: at fs/btrfs/inode.c:7909
>   WARNING: at fs/btrfs/inode.c:7911
>   WARNING: at fs/btrfs/extent-tree.c:4510
>   WARNING: at fs/btrfs/extent-tree.c:4511
> 
> This problem was introduced by the patch "Btrfs: fix deadlock due
> to unsubmitted". In this patch, there are two bugs which caused
> the above problem.

I saw this as well on test 132 last night.  My plan was to track it down
this morning, so discovering it already fixed while I slept was
wonderful.

Thanks Miao.  Josef I've got this one and Miao's defrag unmount patch
queued up.

-chris
