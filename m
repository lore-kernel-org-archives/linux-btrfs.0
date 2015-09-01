Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12186 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbbIAAGU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 20:06:20 -0400
Date: Mon, 31 Aug 2015 20:06:10 -0400
From: Chris Mason <clm@fb.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
Message-ID: <20150901000610.GC5136@ret.masoncoding.com>
References: <55D8B193.8010906@profihost.ag>
 <20150825090030.GF31630@lst.de>
 <20150825135146.GE7176@ret.masoncoding.com>
 <590FB3C7-8BCA-4B04-BBB0-92863E02A89C@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <590FB3C7-8BCA-4B04-BBB0-92863E02A89C@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 07:32:09PM +0200, Stefan Priebe - Profihost AG wrote:
> > Am 25.08.2015 um 15:51 schrieb Chris Mason <clm@fb.com>:
> > 
> >> On Tue, Aug 25, 2015 at 11:00:30AM +0200, Christoph Hellwig wrote:
> >> I think this is btrfs using a struct block_device that doesn't have
> >> a valid queue pointer in it's gendisk for ->s_bdev.  And there are
> >> some fishy looking ->s_bdev assignments in the code which I suspect
> >> are related to it:
> >> 
> >> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev == src_device->bdev)
> >> fs/btrfs/dev-replace.c:         fs_info->sb->s_bdev = tgt_device->bdev;
> >> fs/btrfs/volumes.c:     if (device->bdev == root->fs_info->sb->s_bdev)
> >> fs/btrfs/volumes.c:             root->fs_info->sb->s_bdev = next_device->bdev;
> >> fs/btrfs/volumes.c:     if (tgtdev->bdev == fs_info->sb->s_bdev)
> >> fs/btrfs/volumes.c:             fs_info->sb->s_bdev = next_device->bdev;
> > 
> > We've had trouble with this in the past, I'll take a look.
> 
> Any news?

Haven't been able to reproduce yet, I'll try again in the morning.

-chris
