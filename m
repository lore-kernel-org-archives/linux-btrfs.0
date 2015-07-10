Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377AbbGJNDv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 09:03:51 -0400
Date: Fri, 10 Jul 2015 14:46:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/7] mkfs: Remove temporary chunks
Message-ID: <20150710124603.GF726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436256928-23812-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 07, 2015 at 04:15:21PM +0800, Qu Wenruo wrote:
[...]
> So I took current fix even it's not perfect, but most practice one.

Thanks for working on the mkfs bug. Agreed on the approach.

> Qu Wenruo (7):
>   btrfs-progs: disk-io: Support commit transaction on chunk tree.
>   btrfs-progs: extent-tree: Introduce free_block_group_item function.
>   btrfs-progs: extent-tree: Introduce functions to free dev extents in a
>     chunk
>   btrfs-progs: extent-tree: Introduce functions to free chunk items
>   btrfs-progs: extent-tree: Introduce functions to free in-memory block 
>        group cache
>   btrfs-progs: extent-tree: Introduce btrfs_free_block_group function.

All of the above merged as they're only preparatory.

>   btrfs-progs: mkfs: Cleanup temporary chunk to avoid strange balance
>     behavior.

Looks good.
