Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:36894 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaIYVoU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 17:44:20 -0400
Date: Thu, 25 Sep 2014 14:44:19 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: let btrfs-image actually work on a balanced
 fs
Message-ID: <20140925214419.GO920@lenny.home.zabbo.net>
References: <1411678015-5928-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411678015-5928-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> --- a/btrfs-image.c
> +++ b/btrfs-image.c
> @@ -1020,6 +1020,9 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
>  	int i = 0;
>  	int ret;
>  
> +	if (btrfs_header_bytenr(eb) == 65536)
> +		printf("We have bytenr 65536, belongs to %llu, level %d\n",
> +		       btrfs_header_owner(eb), btrfs_header_level(eb));
>  	ret = add_extent(btrfs_header_bytenr(eb), root->leafsize, metadump, 0);
>  	if (ret) {
>  		fprintf(stderr, "Error adding metadata block\n");

Did you mean to leave that in?  The raw super offset sure makes it look
like debugging output.

- z
