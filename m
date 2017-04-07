Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933348AbdDGMFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Apr 2017 08:05:11 -0400
Date: Fri, 7 Apr 2017 14:05:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 9/9] btrfs: qgroup: Fix qgroup reserved space
 underflow by only freeing reserved ranges
Message-ID: <20170407120509.GU4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-10-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313075216.5125-10-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 03:52:16PM +0800, Qu Wenruo wrote:
> +		/*
> +		 * TODO: To also modify reserved->ranges_reserved to reflect

No new TODOs in the code please.

> +		 * the modification.
> +		 *
> +		 * However as long as we free qgroup reserved according to
> +		 * EXTENT_QGROUP_RESERVED, we won't double free.
> +		 * So not need to rush.
> +		 */
> +		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_failure_tree,
> +				free_start, free_start + free_len - 1,
> +				EXTENT_QGROUP_RESERVED, &changeset);
> +		if (ret < 0)
> +			goto out;
> +		freed += changeset.bytes_changed;
> +	}
> +	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed);
> +	ret = freed;
> +out:
> +	extent_changeset_release(&changeset);
> +	return ret;
> +}
