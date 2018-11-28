Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ACCC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C930204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="XeDFiz9j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C930204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbeK1LiM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:38:12 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42532 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1LiM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:38:12 -0500
Received: by mail-pl1-f194.google.com with SMTP id x21-v6so16446539pln.9
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Kby3o6/Wj4XqPRnFZE3mdjmtsn7DBkRp01RuYrib6eI=;
        b=XeDFiz9jvLLniGcyXGZDR/b9K1E/LZ+fpJ76Je8s1ifoECOGgTtN+k7+genwiNGs26
         YllqYt6DUW24voQVL23vS69mxB/ezLjUYax31Ek4TYITCoMGJYoRNr4u0o3LvEKEw/HD
         0COvl2qFt1be4NJnQs7kkma454blpOwDhdVMP+OxvKhHCdWjv8TeP4Ab1oYWSg+GLv7w
         wcY6l+LVS9Upm/8sdFSBc9EB+40Gtb9ds6/JFL8uHnHMLhxQBEaNckg38oEaLW71sGmk
         Zwzb0Tf6NvM5fUa5sCIY+IiPcZ/8nIrJcOxUkwcyvHukAsDcFwbEBrjJ6aWZLdmUkxRy
         UY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Kby3o6/Wj4XqPRnFZE3mdjmtsn7DBkRp01RuYrib6eI=;
        b=sfzK++BDT3wmJF/w7hCbBLt469Y0A/xznbDuNjzQ8z2GV2fjD8Vqcf4CTkaRBtMa/B
         f0qgjby2ThR2eV21tJCTHiwscW86FmTiGLwQOrTERbf7MIuam8QHMiZZ4/4+9LfkBbX9
         qDsNJViSls6KEphOP4oTZMF5rTxKycMq0TY/TAh62HMed+zoufuBmggz1YN2Vhu/i7zl
         gmI4cjsmt40fCRZNzmtn25E+TJtpffoGyjwTXRgP2zJI95EoETxYLX4uIYpXefMxjFrC
         bzoFN76VBbF4EaBVB89eF0Gv1vmYxyye4LeVLDxqNCAXkf7IicaY112Mqdhlo2QQFnbF
         KIPg==
X-Gm-Message-State: AA+aEWZhctMP3e7v8e3cCAYeAsUsv6cS7A1DgF3VXW4mZxLsbn30hj3I
        F1Xcv8yHUeeOKZH3z7nqTufmvZ+2uEs=
X-Google-Smtp-Source: AFSGD/U9cK6rwX21hH8Te9uklROFAQbE8hAJ+o5qon2UJ1yFbUmkpJ5gvSnGCbgvZCrvmH/Lat3Tsg==
X-Received: by 2002:a17:902:9692:: with SMTP id n18mr12447808plp.333.1543365511257;
        Tue, 27 Nov 2018 16:38:31 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id c4sm13333957pfm.151.2018.11.27.16.38.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:38:30 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:38:29 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 9/9] btrfs: drop extra enum initialization where using
 defaults
Message-ID: <20181128003829.GQ846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <932e555ce5dff2ec978bf1d21a4ef1d8d5e7ccfd.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:59PM +0100, David Sterba wrote:
> The first auto-assigned value to enum is 0, we can use that and not
> initialize all members where the auto-increment does the same. This is
> used for values that are not part of on-disk format.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/btrfs_inode.h |  2 +-
>  fs/btrfs/ctree.h       | 28 ++++++++++++++--------------
>  fs/btrfs/disk-io.h     | 10 +++++-----
>  fs/btrfs/qgroup.h      |  2 +-
>  fs/btrfs/sysfs.h       |  2 +-
>  fs/btrfs/transaction.h | 14 +++++++-------
>  6 files changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 4de321aee7a5..fc25607304f2 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -20,7 +20,7 @@
>   * new data the application may have written before commit.
>   */
>  enum {
> -	BTRFS_INODE_ORDERED_DATA_CLOSE = 0,
> +	BTRFS_INODE_ORDERED_DATA_CLOSE,
>  	BTRFS_INODE_DUMMY,
>  	BTRFS_INODE_IN_DEFRAG,
>  	BTRFS_INODE_HAS_ASYNC_EXTENT,
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4bb0ac3050ff..f1d1c6ba3aa1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -334,7 +334,7 @@ struct btrfs_node {
>   * The slots array records the index of the item or block pointer
>   * used while walking the tree.
>   */
> -enum { READA_NONE = 0, READA_BACK, READA_FORWARD };
> +enum { READA_NONE, READA_BACK, READA_FORWARD };
>  struct btrfs_path {
>  	struct extent_buffer *nodes[BTRFS_MAX_LEVEL];
>  	int slots[BTRFS_MAX_LEVEL];
> @@ -532,18 +532,18 @@ struct btrfs_free_cluster {
>  };
>  
>  enum btrfs_caching_type {
> -	BTRFS_CACHE_NO		= 0,
> -	BTRFS_CACHE_STARTED	= 1,
> -	BTRFS_CACHE_FAST	= 2,
> -	BTRFS_CACHE_FINISHED	= 3,
> -	BTRFS_CACHE_ERROR	= 4,
> +	BTRFS_CACHE_NO,
> +	BTRFS_CACHE_STARTED,
> +	BTRFS_CACHE_FAST,
> +	BTRFS_CACHE_FINISHED,
> +	BTRFS_CACHE_ERROR,
>  };
>  
>  enum btrfs_disk_cache_state {
> -	BTRFS_DC_WRITTEN	= 0,
> -	BTRFS_DC_ERROR		= 1,
> -	BTRFS_DC_CLEAR		= 2,
> -	BTRFS_DC_SETUP		= 3,
> +	BTRFS_DC_WRITTEN,
> +	BTRFS_DC_ERROR,
> +	BTRFS_DC_CLEAR,
> +	BTRFS_DC_SETUP,
>  };
>  
>  struct btrfs_caching_control {
> @@ -2621,10 +2621,10 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
>  /* extent-tree.c */
>  
>  enum btrfs_inline_ref_type {
> -	BTRFS_REF_TYPE_INVALID =	 0,
> -	BTRFS_REF_TYPE_BLOCK =		 1,
> -	BTRFS_REF_TYPE_DATA =		 2,
> -	BTRFS_REF_TYPE_ANY =		 3,
> +	BTRFS_REF_TYPE_INVALID,
> +	BTRFS_REF_TYPE_BLOCK,
> +	BTRFS_REF_TYPE_DATA,
> +	BTRFS_REF_TYPE_ANY,
>  };
>  
>  int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index 4cccba22640f..987a64bc0c66 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -21,11 +21,11 @@
>  #define BTRFS_BDEV_BLOCKSIZE	(4096)
>  
>  enum btrfs_wq_endio_type {
> -	BTRFS_WQ_ENDIO_DATA = 0,
> -	BTRFS_WQ_ENDIO_METADATA = 1,
> -	BTRFS_WQ_ENDIO_FREE_SPACE = 2,
> -	BTRFS_WQ_ENDIO_RAID56 = 3,
> -	BTRFS_WQ_ENDIO_DIO_REPAIR = 4,
> +	BTRFS_WQ_ENDIO_DATA,
> +	BTRFS_WQ_ENDIO_METADATA,
> +	BTRFS_WQ_ENDIO_FREE_SPACE,
> +	BTRFS_WQ_ENDIO_RAID56,
> +	BTRFS_WQ_ENDIO_DIO_REPAIR,
>  };
>  
>  static inline u64 btrfs_sb_offset(int mirror)
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index d8f78f5ab854..e4e6ee44073a 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -70,7 +70,7 @@ struct btrfs_qgroup_extent_record {
>   *	be converted into META_PERTRANS.
>   */
>  enum btrfs_qgroup_rsv_type {
> -	BTRFS_QGROUP_RSV_DATA = 0,
> +	BTRFS_QGROUP_RSV_DATA,
>  	BTRFS_QGROUP_RSV_META_PERTRANS,
>  	BTRFS_QGROUP_RSV_META_PREALLOC,
>  	BTRFS_QGROUP_RSV_LAST,
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index c6ee600aff89..40716b357c1d 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -9,7 +9,7 @@
>  extern u64 btrfs_debugfs_test;
>  
>  enum btrfs_feature_set {
> -	FEAT_COMPAT = 0,
> +	FEAT_COMPAT,
>  	FEAT_COMPAT_RO,
>  	FEAT_INCOMPAT,
>  	FEAT_MAX
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 703d5116a2fc..f1ba78949d1b 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -12,13 +12,13 @@
>  #include "ctree.h"
>  
>  enum btrfs_trans_state {
> -	TRANS_STATE_RUNNING		= 0,
> -	TRANS_STATE_BLOCKED		= 1,
> -	TRANS_STATE_COMMIT_START	= 2,
> -	TRANS_STATE_COMMIT_DOING	= 3,
> -	TRANS_STATE_UNBLOCKED		= 4,
> -	TRANS_STATE_COMPLETED		= 5,
> -	TRANS_STATE_MAX			= 6,
> +	TRANS_STATE_RUNNING,
> +	TRANS_STATE_BLOCKED,
> +	TRANS_STATE_COMMIT_START,
> +	TRANS_STATE_COMMIT_DOING,
> +	TRANS_STATE_UNBLOCKED,
> +	TRANS_STATE_COMPLETED,
> +	TRANS_STATE_MAX,
>  };
>  
>  #define BTRFS_TRANS_HAVE_FREE_BGS	0
> -- 
> 2.19.1
> 
