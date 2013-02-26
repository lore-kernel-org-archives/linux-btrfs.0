Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38039 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab3BZOUq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 09:20:46 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id ADE0D7C0415
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 07:20:45 -0700 (MST)
Date: Tue, 26 Feb 2013 09:20:43 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/inode.c:2165
 btrfs_orphan_commit_root+0xcb/0xdf()
Message-ID: <20130226142043.GD19641@localhost.localdomain>
References: <20130225025546.GC14143@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130225025546.GC14143@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 24, 2013 at 07:55:46PM -0700, Marc MERLIN wrote:
> Is this useful to anyone?
> 
> Got this after a crash/reboot:
> 
> 	if (block_rsv) {
> 		WARN_ON(block_rsv->size > 0);  <<<<<<<<<<<<<<<<<<<<<<
> 		btrfs_free_block_rsv(root, block_rsv);
> 	}
> 

Fixed in btrfs-next, thanks for reporting!

Josef
