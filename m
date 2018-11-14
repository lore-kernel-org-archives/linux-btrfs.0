Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C83C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39C422507
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Qyk3BzcZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B39C422507
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbeKOFhz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 00:37:55 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45893 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbeKOFhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 00:37:55 -0500
Received: by mail-pl1-f193.google.com with SMTP id a14so3650892plm.12
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 11:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kP+s10L8AqQWaiBMi4c28V8chHUoZBL9WsS7tKPnE3o=;
        b=Qyk3BzcZFpODJc/Q3e6sRY5TJTioqWwSbz3pePw4H0RBKXZkF5c7X5X8wrTet14k5v
         tApjp4zuVhecrCbARxeXPu/zf9YVO9eP0Rw5eC5E778fHZ3gDbPncz/kZKPg+NN66/oy
         XaOq3KVg0GZG+nIQ8elBpv3VGZ3MOeyEo1NAo4dO4CLQN5xD5OAyRqpYOEscJha0t5Vf
         Y/vtrUZZhEweFEtrho3LbwUo5hsyG+OBOLds3QKNdbqEa8SB5aBdkro+J34NEY36uQRY
         QsSVHYptb5sxL5ifF9fRb0e6RTPJHbUOb9qy5Eb2B8pEwD//FGL6gLfLa882KMhCWL4D
         yxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kP+s10L8AqQWaiBMi4c28V8chHUoZBL9WsS7tKPnE3o=;
        b=lkcFg3XgQgxooSdxoODJz3fA/C5AJmSPAYXMrFj9bRd08o2X5DDg3kd9uy39D/UtWn
         D3mcaZZDO7baFje4ndFNFgoLEaUYgeMLWdzGRonuZQ2hhGMDnKKBj45e9UeD7/h+QIg1
         PdQDiC4eqFhfKg5H1N44t9N9N8OHy1ri3nT+k/nEG60L6TWVPxjINRvwl8biyVkAFilM
         kWBJVcuHZejmtKs9IRpXJb/pFYUqu9vJbq0y3zvLm2tqLCiXKkBnDURsZ3JBzILzM8HF
         UfP7NkNfRYvjSkYwm40DbpC0tfmRzuPWsN99xt2iryDw7O0hbozRcyqD3JoCdmexXRtd
         zg2Q==
X-Gm-Message-State: AGRZ1gJVCDOcDO0FWkRQNWqSoxNXVclIylrnopLTBxjGLY7/smfSMD7J
        OsoyzcuVYgtPJzeJ16a94S8VYw==
X-Google-Smtp-Source: AJdET5dXrcz3x6JjKyRrmfxnUmb4Q8W6LWCOhsw8qbMGOs2rJG83FHSTDfh2bMBcso76XkSCx38iWA==
X-Received: by 2002:a17:902:b903:: with SMTP id bf3mr3107015plb.289.1542224003148;
        Wed, 14 Nov 2018 11:33:23 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:2a61])
        by smtp.gmail.com with ESMTPSA id l64-v6sm4023840pfj.179.2018.11.14.11.33.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 11:33:22 -0800 (PST)
Date:   Wed, 14 Nov 2018 11:33:21 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/6] btrfs: remove unused variable tree in
 end_compressed_bio_write()
Message-ID: <20181114193321.GD4173@vader>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-6-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114133520.16069-6-jthumshirn@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:35:19PM +0100, Johannes Thumshirn wrote:
> Commit 2922040236f9 (btrfs: Remove extent_io_ops::writepage_end_io_hook)
> removed the indirection to extent_io_ops::writepage_end_io_hook but didn't
> remove the tree variable which then became unused.
> 
> Remove 'tree' as well to silence the warning when -Wunused-but-set-variable
> is used to compile btrfs.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/compression.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index bde8d0487bbb..088570c5dfb8 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -229,7 +229,6 @@ static noinline void end_compressed_writeback(struct inode *inode,
>   */
>  static void end_compressed_bio_write(struct bio *bio)
>  {
> -	struct extent_io_tree *tree;
>  	struct compressed_bio *cb = bio->bi_private;
>  	struct inode *inode;
>  	struct page *page;
> @@ -248,7 +247,6 @@ static void end_compressed_bio_write(struct bio *bio)
>  	 * call back into the FS and do all the end_io operations
>  	 */
>  	inode = cb->inode;
> -	tree = &BTRFS_I(inode)->io_tree;
>  	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
>  	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
>  			cb->start, cb->start + cb->len - 1, NULL,
> -- 
> 2.16.4
> 
