Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9829 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbbHYNwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 09:52:16 -0400
Date: Tue, 25 Aug 2015 09:51:46 -0400
From: Chris Mason <clm@fb.com>
To: Christoph Hellwig <hch@lst.de>
CC: Stefan Priebe <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
Message-ID: <20150825135146.GE7176@ret.masoncoding.com>
References: <55D8B193.8010906@profihost.ag>
 <20150825090030.GF31630@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150825090030.GF31630@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 11:00:30AM +0200, Christoph Hellwig wrote:
> I think this is btrfs using a struct block_device that doesn't have
> a valid queue pointer in it's gendisk for ->s_bdev.  And there are
> some fishy looking ->s_bdev assignments in the code which I suspect
> are related to it:
> 
> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev == src_device->bdev)
> fs/btrfs/dev-replace.c:         fs_info->sb->s_bdev = tgt_device->bdev;
> fs/btrfs/volumes.c:     if (device->bdev == root->fs_info->sb->s_bdev)
> fs/btrfs/volumes.c:             root->fs_info->sb->s_bdev = next_device->bdev;
> fs/btrfs/volumes.c:     if (tgtdev->bdev == fs_info->sb->s_bdev)
> fs/btrfs/volumes.c:             fs_info->sb->s_bdev = next_device->bdev;

We've had trouble with this in the past, I'll take a look.

-chris

