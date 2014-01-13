Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaAMSez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 13:34:55 -0500
Date: Mon, 13 Jan 2014 19:27:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 2/4] Btrfs: fix protection between send and root
 deletion
Message-ID: <20140113182745.GS6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389086721-19624-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389086721-19624-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 05:25:19PM +0800, Wang Shilong wrote:
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1971,6 +1971,19 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
>  	}
>  	root = list_first_entry(&fs_info->dead_roots,
>  			struct btrfs_root, root_list);

You're pulling the root from dead_roots here ...

> +	/*
> +	 * Make sure root is not involved in send,

... and there's no way to send such a thing.

> +	 * if we fail with first root, we return
> +	 * directly rather than continue.
> +	 */
> +	spin_lock(&root->root_item_lock);
> +	if (root->send_in_progress) {
> +		spin_unlock(&fs_info->trans_lock);
> +		spin_unlock(&root->root_item_lock);
> +		return 0;
> +	}
> +	spin_unlock(&root->root_item_lock);
> +
>  	list_del_init(&root->root_list);
>  	spin_unlock(&fs_info->trans_lock);
