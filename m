Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3KEK0N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 05:26:13 -0500
Date: Tue, 5 Nov 2013 11:26:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Valentina Giusti <valentina.giusti@microon.de>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9] btrfs: remove unused variables
Message-ID: <20131105102608.GB16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383600869-10085-1-git-send-email-valentina.giusti@microon.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 04, 2013 at 10:34:20PM +0100, Valentina Giusti wrote:
> With this patchset I removed the unused variables found with 
> 	make W=1 fs/btrfs/
> 
> Valentina Giusti (9):
>   btrfs: remove unused variable from btrfs_search_forward
>   btrfs: remove unused variable from btrfs_new_inode
>   btrfs: remove unused variables from disk-io.c
>   btrfs: remove unused variable from find_free_extent
>   btrfs: remove unused variables from extent_io.c
>   btrfs: remove unused variable from setup_cluster_no_bitmap
>   btrfs: remove unused variable from scrub_fixup_nodatasum
>   btrfs: replace path->slots[0] with otherwise unused variable 'slot'
>   btrfs: fix unused variables in qgroup.c

All of them look OK to me, thanks!

Reviewed-by: David Sterba <dsterba@suse.cz>

david
