Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40883 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2GJT36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 15:29:58 -0400
Date: Tue, 10 Jul 2012 15:29:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Li Zefan <lizefan@huawei.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: kill free_space pointer from inode structure
Message-ID: <20120710192953.GF7529@localhost.localdomain>
References: <4FFB9193.6040306@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFB9193.6040306@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2012 at 08:21:07PM -0600, Li Zefan wrote:
> Inodes always allocate free space with BTRFS_BLOCK_GROUP_DATA type,
> which means every inode has the same BTRFS_I(inode)->free_space pointer.
> 
> This shrinks struct btrfs_inode by 4 bytes (or 8 bytes on 64 bits).
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Li I can't apply any of your patches because they are all in base64 format and
I'm having a hell of a time pulling them out to apply them, can you resend with
git send-email or something so I can apply them properly?  Thanks,

Josef
