Return-Path: <SRS0=uKjx=X7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7CC4360C
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Oct 2019 23:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15EF92084B
	for <linux-btrfs@archiver.kernel.org>; Sun,  6 Oct 2019 23:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfJFX3O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 6 Oct 2019 19:29:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:46158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbfJFX3O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 6 Oct 2019 19:29:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2924B13A;
        Sun,  6 Oct 2019 23:29:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 57D70DA7FB; Mon,  7 Oct 2019 01:29:28 +0200 (CEST)
Date:   Mon, 7 Oct 2019 01:29:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: using enum to replace macro
Message-ID: <20191006232928.GZ2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chengguang Xu <cgxu519@mykernel.net>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
References: <20191005051736.29857-1-cgxu519@mykernel.net>
 <20191005051736.29857-3-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005051736.29857-3-cgxu519@mykernel.net>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 05, 2019 at 01:17:36PM +0800, Chengguang Xu wrote:
> using enum to replace macro definition for extent
> types.
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/btrfs/tree-checker.c         |  4 ++--
>  include/uapi/linux/btrfs_tree.h | 10 ++++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 2d91c34bbf63..9b0c5fdbe04e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -156,11 +156,11 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>  
>  	fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>  
> -	if (btrfs_file_extent_type(leaf, fi) > BTRFS_FILE_EXTENT_TYPES) {
> +	if (btrfs_file_extent_type(leaf, fi) >= BTRFS_FILE_EXTENT_TYPES) {
>  		file_extent_err(leaf, slot,
>  		"invalid type for file extent, have %u expect range [0, %u]",
>  			btrfs_file_extent_type(leaf, fi),
> -			BTRFS_FILE_EXTENT_TYPES);
> +			BTRFS_FILE_EXTENT_TYPES - 1);
>  		return -EUCLEAN;
>  	}
>  
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index b65c7ee75bc7..34bd09ffc71d 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -737,10 +737,12 @@ struct btrfs_balance_item {
>  	__le64 unused[4];
>  } __attribute__ ((__packed__));
>  
> -#define BTRFS_FILE_EXTENT_INLINE 0
> -#define BTRFS_FILE_EXTENT_REG 1
> -#define BTRFS_FILE_EXTENT_PREALLOC 2
> -#define BTRFS_FILE_EXTENT_TYPES	2
> +enum {
> +	BTRFS_FILE_EXTENT_INLINE,
> +	BTRFS_FILE_EXTENT_REG,
> +	BTRFS_FILE_EXTENT_PREALLOC,
> +	BTRFS_FILE_EXTENT_TYPES
> +};

As stated before, using enums is fine and for on-disk structure,s the
explicit value should be specified as well.

>  struct btrfs_file_extent_item {
>  	/*
> -- 
> 2.21.0
> 
> 
> 
