Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbbCYRk6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 13:40:58 -0400
Date: Wed, 25 Mar 2015 18:40:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove empty block groups automatically V3
Message-ID: <20150325174056.GJ20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

On Thu, Sep 18, 2014 at 11:20:02AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1764,6 +1764,7 @@ static int cleaner_kthread(void *arg)
>  		}
>  
>  		btrfs_run_delayed_iputs(root);
> +		btrfs_delete_unused_bgs(root->fs_info);
>  		again = btrfs_clean_one_deleted_snapshot(root);
>  		mutex_unlock(&root->fs_info->cleaner_mutex);

any reason to put the dirty bg deletion before snapshot cleaning? If the
snapshot unpins some old data there is higher chance to remove some bgs
after that.

This is not a problem as the cleaner loop may be triggered for other
reasons (iputs, autodefrag, more than one snapshot in the queue) but
still would make more sense to do it after the deletion. Thanks.
