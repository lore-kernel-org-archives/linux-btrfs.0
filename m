Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:40867 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbbHYJoP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 05:44:15 -0400
Message-ID: <55DC38ED.9060502@profihost.ag>
Date: Tue, 25 Aug 2015 11:44:13 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
References: <55D8B193.8010906@profihost.ag> <20150825090030.GF31630@lst.de>
In-Reply-To: <20150825090030.GF31630@lst.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 25.08.2015 um 11:00 schrieb Christoph Hellwig:
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
> 

Would be very nice if anyone from btrfs can pick this up.

Stefan
