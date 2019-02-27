Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E589C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 15:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 284362184A
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 15:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfB0Ppq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 10:45:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:48336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726122AbfB0Ppp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 10:45:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD96BAD56
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 15:45:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C09BBDA83C; Wed, 27 Feb 2019 16:47:05 +0100 (CET)
Date:   Wed, 27 Feb 2019 16:47:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/3] btrfs: Initialize btrfs_io_ctl instead of memsetting
 it
Message-ID: <20190227154705.GR24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20190225190744.21664-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225190744.21664-1-rgoldwyn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 01:07:42PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> io_ctl_init() memsets it to zero anyways. However, I presume the
> memset was added to avoid the WARN_ON in io_ctl_init().

I don't see any WARN_ON in io_ctl_init, you probably mean
__btrfs_write_out_cache.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/free-space-cache.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 74aa552f4793..c813378ebf08 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -3544,13 +3544,12 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	struct btrfs_free_space_ctl *ctl = root->free_ino_ctl;
>  	int ret;
> -	struct btrfs_io_ctl io_ctl;
> +	struct btrfs_io_ctl io_ctl = {0};

Doesn't this zero the bytes unconditionally? The memset below happens
only when the inode cache is on.

>  	bool release_metadata = true;
>  
>  	if (!btrfs_test_opt(fs_info, INODE_MAP_CACHE))
>  		return 0;
>  
> -	memset(&io_ctl, 0, sizeof(io_ctl));
>  	ret = __btrfs_write_out_cache(root, inode, ctl, NULL, &io_ctl, trans);
>  	if (!ret) {
>  		/*
> -- 
> 2.16.4
