Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34980 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbbHYJAb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 05:00:31 -0400
Date: Tue, 25 Aug 2015 11:00:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
Message-ID: <20150825090030.GF31630@lst.de>
References: <55D8B193.8010906@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D8B193.8010906@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think this is btrfs using a struct block_device that doesn't have
a valid queue pointer in it's gendisk for ->s_bdev.  And there are
some fishy looking ->s_bdev assignments in the code which I suspect
are related to it:

fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev == src_device->bdev)
fs/btrfs/dev-replace.c:         fs_info->sb->s_bdev = tgt_device->bdev;
fs/btrfs/volumes.c:     if (device->bdev == root->fs_info->sb->s_bdev)
fs/btrfs/volumes.c:             root->fs_info->sb->s_bdev = next_device->bdev;
fs/btrfs/volumes.c:     if (tgtdev->bdev == fs_info->sb->s_bdev)
fs/btrfs/volumes.c:             fs_info->sb->s_bdev = next_device->bdev;
