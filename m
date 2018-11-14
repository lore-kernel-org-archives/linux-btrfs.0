Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6C0C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A647A22360
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 19:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="RsjzWD2N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A647A22360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbeKOFdm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 00:33:42 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41965 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725756AbeKOFdm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 00:33:42 -0500
Received: by mail-pg1-f195.google.com with SMTP id 70so7807197pgh.8
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 11:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UMw/8WlGv3dev2bwyCB2qgsQGNxKtWc1OZEMNqPcau4=;
        b=RsjzWD2NgWABXdYrA56ul7u5FfyHM+D0J5v1u+/tfVippRhGrbbpwz9PZBrECL90Ng
         d35OzErYV2kYTBtFt3FafY0LBv9MrR+aY88gI9UNlRebSOjjNQSAkJsNPt/gnyWl9m0A
         hdsZzsf4GnU8+2CEqwgRK/+jnP8cHzvMlcQ0Qv7UPGb8Y9EQ4aokFMPN7AGdIuuCr3Dz
         C76Pd5cd0wSv9HMMCkNSFDCmSwOuTR2T9zb0NKcKb5ybPVD8DbjlLffvTSf6ZVNITWY1
         75NL0aVO8UX+MEUD3nxtjEC7D0OIJ4gT33Y1NLHC9KmxVoJhCl/XxbjQhugZiwqVr4X1
         HFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UMw/8WlGv3dev2bwyCB2qgsQGNxKtWc1OZEMNqPcau4=;
        b=PvSJEMQ/hNRrM1skZCfZ2OtQKtbGRuE48vJhi+ZTKcaEoyV1yF7fkyfOIXgMRnLAKr
         vDe3UsMCjLPQERyaoxWFT5GMeNbeuHoy78aM71RE55wLFmxUGyURl8C5xI+nbC3FxysR
         4x8HdEjrAX8voHBEu5kDPwmWOLEoNhNfMQWHZovRIARaumnLHbDG+gEW53US87lBjdtk
         5aLC7gJ4mdexBHxkf0IH7yU/LaFLRUPOq8OnICU53ISFb1l89eSn6gsUnoP8VyXwPBms
         f/CKRW7ie/chhzZ3JZEuT+tRFMlLuq6tsSfEjF+xGiwF5ybqklTSKES3XG0I+PsaV990
         layw==
X-Gm-Message-State: AGRZ1gL+b+8J4/fde+yJbjM7w2mQHxXfvpgmjhUZKG9T+nq7g4eeVagB
        kwuVb5Ytj6B7g2r4+TduIJmRCg==
X-Google-Smtp-Source: AJdET5fnzlCw9Yb6/DWe4uG1Ue3TXc/PXGEhxVWePdARiaS+Q7OJO4YScveQunATdKj7RlBoFpYnVw==
X-Received: by 2002:a63:cf56:: with SMTP id b22mr2793479pgj.336.1542223750568;
        Wed, 14 Nov 2018 11:29:10 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:2a61])
        by smtp.gmail.com with ESMTPSA id o12-v6sm32596443pfh.20.2018.11.14.11.29.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 11:29:10 -0800 (PST)
Date:   Wed, 14 Nov 2018 11:29:08 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] btrfs: remove unused drop_on_err in btrfs_mkdir()
Message-ID: <20181114192908.GA4173@vader>
References: <20181114133520.16069-1-jthumshirn@suse.de>
 <20181114133520.16069-2-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114133520.16069-2-jthumshirn@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 02:35:15PM +0100, Johannes Thumshirn wrote:
> Up to commit 32955c5422a8 (btrfs: switch to discard_new_inode()) the
> drop_on_err variable in btrfs_mkdir() was used to check whether the inode had
> to be dropped via iput().
> 
> After commit 32955c5422a8 (btrfs: switch to discard_new_inode())
> discard_new_inode() is called when err is set and inode is non NULL. Therefore
> drop_on_err is not used anymore and thus causes a warning when building with
> -Wunused-but-set-variable.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  fs/btrfs/inode.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 4a2f9f7fd96e..7d17b0a654e6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6677,7 +6677,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_root *root = BTRFS_I(dir)->root;
>  	int err = 0;
> -	int drop_on_err = 0;
>  	u64 objectid = 0;
>  	u64 index = 0;
>  
> @@ -6703,7 +6702,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  		goto out_fail;
>  	}
>  
> -	drop_on_err = 1;
>  	/* these must be set before we unlock the inode */
>  	inode->i_op = &btrfs_dir_inode_operations;
>  	inode->i_fop = &btrfs_dir_file_operations;
> @@ -6724,7 +6722,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  		goto out_fail;
>  
>  	d_instantiate_new(dentry, inode);
> -	drop_on_err = 0;
>  
>  out_fail:
>  	btrfs_end_transaction(trans);
> -- 
> 2.16.4
> 
