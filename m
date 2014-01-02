Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaABRt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 12:49:57 -0500
Date: Thu, 2 Jan 2014 18:49:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Btrfs: use flags instead of the bool variants in
 delayed node
Message-ID: <20140102174955.GO6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388034426-4935-1-git-send-email-miaox@cn.fujitsu.com>
 <1388034426-4935-5-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388034426-4935-5-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 26, 2013 at 01:07:05PM +0800, Miao Xie wrote:
> +#define BTRFS_DELAYED_NODE_IN_LIST	0
> +#define BTRFS_DELAYED_NODE_INODE_DIRTY	1
> +
>  struct btrfs_delayed_node {
>  	u64 inode_id;
>  	u64 bytes_reserved;
> @@ -65,8 +68,7 @@ struct btrfs_delayed_node {
>  	struct btrfs_inode_item inode_item;
>  	atomic_t refs;
>  	u64 index_cnt;
> -	bool in_list;
> -	bool inode_dirty;
> +	unsigned long flags;
>  	int count;
>  };

What's the reason to do that? Replacing 2 bools with a bitfield
does not seem justified, not from saving memory, nor from a performance
gain side.  Also some of the bit operations imply the lock instruction
prefix so this affects the surrounding items as well.

I don't think this is needed, unless you have further plans with the
flags item.


david
