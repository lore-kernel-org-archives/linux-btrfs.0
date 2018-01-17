Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753033AbeAQNkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 08:40:06 -0500
Subject: Re: [PATCH 1/3] btrfs-progs: lowmem fsck: Remove corupted link before
 re-add correct link
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
References: <20180117051710.16853-1-wqu@suse.com>
 <20180117051710.16853-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e3366a31-1f52-6e71-73c9-6a1415b075c0@suse.com>
Date: Wed, 17 Jan 2018 15:40:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180117051710.16853-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.01.2018 07:17, Qu Wenruo wrote:
> For repair_ternary_lowmem() used in lowmem mode, if it found 1 of
> DIR_INDEX/DIR_ITEM/INODE_REF missing, it will try to insert correct
> link.
> 
> However for case like invalid type in DIR_INDEX, we should delete the
> corrupted DIR_INDEX first before inserting the correct link.
> 
> This patch will remove the corrupted link before re-insert.
> This should solve the duplicated DIR_INDEX problem in old lowmem mode
> repair.
> 
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  cmds-check.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 7fc30da83ea1..f302724dd840 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -4997,6 +4997,10 @@ int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
>  		goto out;
>  	}
>  	if (stage == 1) {
> +		ret = btrfs_unlink(trans, root, ino, dir_ino, index, name,
> +				   name_len, 0);
> +		if (ret)
> +			goto out;
>  		ret = btrfs_add_link(trans, root, ino, dir_ino, name, name_len,
>  			       filetype, &index, 1, 1);
>  		goto out;
> 
