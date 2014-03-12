Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbaCLQVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 12:21:54 -0400
Date: Wed, 12 Mar 2014 17:21:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: mkfs: make sure we can deal with hard
 links with -r option
Message-ID: <20140312162151.GB6782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394533749-3138-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1394533749-3138-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394533749-3138-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 11, 2014 at 06:29:09PM +0800, Wang Shilong wrote:
> @@ -840,6 +833,10 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
>  					      cur_file->d_name, cur_inum,
>  					      parent_inum, dir_index_cnt,
>  					      &cur_inode);
> +			if (ret == -EEXIST) {
> +				BUG_ON(st.st_nlink <= 1);

As the mkfs operation is restartable, can we handle the error?

Otherwise, good fix, thanks.

> +				continue;
> +			}
>  			if (ret) {
>  				fprintf(stderr, "add_inode_items failed\n");
>  				goto fail;
