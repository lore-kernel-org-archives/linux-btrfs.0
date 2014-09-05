Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbaIEJtQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Sep 2014 05:49:16 -0400
Date: Fri, 5 Sep 2014 11:49:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: print btrfs specific info for some fatal error
 cases
Message-ID: <20140905094914.GE5636@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53B645D4.1060003@cn.fujitsu.com>
 <1404467946-4429-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404467946-4429-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 05:59:06PM +0800, Wang Shilong wrote:
> @@ -351,9 +351,9 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
> -	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
> -		       "found %llu\n",
> -		       eb->start, parent_transid, btrfs_header_generation(eb));
> +	printk_ratelimited("BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",

Missing KERN_ message level, probably ERROR

> +			eb->fs_info->sb->s_id, eb->start,
> +			parent_transid, btrfs_header_generation(eb));
