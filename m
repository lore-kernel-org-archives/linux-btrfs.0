Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753401AbeGEO3b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 10:29:31 -0400
Date: Thu, 5 Jul 2018 16:29:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com, misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v2] btrfs: qgroups: Move transaction management inside
 btrfs_quota_enable/disable
Message-ID: <20180705142929.GF3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530791448-12743-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530791448-12743-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 02:50:48PM +0300, Nikolay Borisov wrote:
> @@ -921,8 +938,10 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
>  
>  	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
>  				      sizeof(*ptr));
> -	if (ret)
> +	if (ret) {
>  		goto out_free_path;
> +		btrfs_abort_transaction(trans, ret);

Strange that gcc does not warn about that, and there's no warning switch
to detect dead code.

> @@ -3070,7 +3128,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
>  	if (free && reserved)
>  		return qgroup_free_reserved_data(inode, reserved, start, len);
>  	extent_changeset_init(&changeset);
> -	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
> +	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,

So the whitespace hunk still there?

>  			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
>  	if (ret < 0)
>  		goto out;
