Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3H1R3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 13:29:39 -0400
Date: Wed, 28 Aug 2013 19:29:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, pth@suse.de, sf@suse.de, jeff.liu@oracle.com
Subject: Re: [RFC PATCH] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130828172938.GF23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376641648-25015-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376641648-25015-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 16, 2013 at 04:27:28PM +0800, Liu Bo wrote:
> Similar to ocfs2, btrfs also supports that extents can be shared by
> different inodes, and there are some userspace tools requesting
> for this kind of 'space shared infomation'.[1]
> 
> ocfs2 uses flag FIEMAP_EXTENT_SHARED, so does btrfs.

Looks ok to me.

> +			int ref_cnt = 0;

I think using long is cleaner here, it always fits into (void*), int
does not.

> +			/*
> +			 * As btrfs supports shared space, this information
> +			 * can be exported to userspace tools via
> +			 * flag FIEMAP_EXTENT_SHARED.
> +			 */
> +			ret = iterate_inodes_from_logical(
> +					em->block_start,
> +					BTRFS_I(inode)->root->fs_info,
> +					path, count_ext_ref, &ref_cnt);
> +			if (ret < 0)
> +				goto out_free;
> +
> +			if (ref_cnt > 1)
> +				flags |= FIEMAP_EXTENT_SHARED;

AFAICS, e2fsprogs filefrag does not yet know about FIEMAP_EXTENT_SHARED.

david
