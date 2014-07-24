Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308AbaGXL1S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 07:27:18 -0400
Date: Thu, 24 Jul 2014 13:27:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] Btrfs: fix wrong max inline data size limit
Message-ID: <20140724112716.GT1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1405568654-22120-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1405568654-22120-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405568654-22120-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:44:12AM +0800, Wang Shilong wrote:
> inline data is stored from offset of @disk_bytenr in
> struct btrfs_file_extent_item. So substracting total
> size of struct btrfs_file_extent_item is wrong, fix it.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

>  #define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
>  					sizeof(struct btrfs_item) - \
> -					sizeof(struct btrfs_file_extent_item))
> +					offsetof(struct btrfs_file_extent_item, disk_bytenr))

This increases the limit of inline data by 24 bytes but fortunatelly
does not break existing filesystems because the
BTRFS_MAX_INLINE_DATA_SIZE is used at the time the inlining is decided.
IOW it is a bit pessimistic, the rest of the code uses the offsetof
value.
