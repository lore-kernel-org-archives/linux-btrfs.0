Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbaAFRTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 12:19:09 -0500
Date: Mon, 6 Jan 2014 18:19:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] Btrfs: fix protection between send and root deletion
Message-ID: <20140106171908.GZ6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389000339-15388-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389000339-15388-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 05:25:37PM +0800, Wang Shilong wrote:
> We should gurantee that parent and clone root can not be destroyed
> during send, for this we have two ideas.
> 
> 1.by holding @subvol_sem, this might be a nightmare, because it will
> block all subvolumes deletion for a long time.
> 
> 2.Miao pointed out we can reuse @send_in_progress, that mean we will
> skip snapshot deletion if root sending is in progress.
> 
> Here we adopt the second approach since it won't block other subvolumes
> deletion for a long time.

Agreed, good idea protecting against the deletion during send.

>  static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
>  {
> +	spin_lock(&root->root_item_lock);
> +	if (root->send_in_progress) {
> +		spin_unlock(&root->root_item_lock);
> +		return 1;
> +	}
> +	spin_unlock(&root->root_item_lock);

Whi is this needed? btrfs_need_cleaner_sleep needs only fs_info.

* when called from cleaner_kthread it gets the tree_root
* when called from btrfs_drop_snapshot it's a reloc_root

neither of which is ever subject to send.


david
