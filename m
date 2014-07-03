Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbaGCRs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jul 2014 13:48:58 -0400
Date: Thu, 3 Jul 2014 19:48:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs-progs: Allow btrfs_read_dev_super() to read
 all 3 super for super_recover.
Message-ID: <20140703174856.GI1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404380198-25948-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404380198-25948-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 03, 2014 at 05:36:36PM +0800, Qu Wenruo wrote:
> @@ -1182,7 +1183,8 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
>  	return info->fs_root;
>  }
>  
> -int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr)
> +int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
> +			 int recover_super)

> +	int max_super = recover_super ? BTRFS_SUPER_MIRROR_MAX : 1;

Minor tweak, I've renamed it to super_recover as this is used everywhere
else. No need to resend the patch.
