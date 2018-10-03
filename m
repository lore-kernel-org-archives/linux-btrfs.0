Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48750C00449
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 12:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 188AE20835
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 12:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 188AE20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbeJCTPe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 15:15:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:54046 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726619AbeJCTPe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:15:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37FD2AE8B;
        Wed,  3 Oct 2018 12:27:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 78064DABCE; Wed,  3 Oct 2018 14:27:19 +0200 (CEST)
Date:   Wed, 3 Oct 2018 14:27:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 18/42] btrfs: move the dio_sem higher up the callchain
Message-ID: <20181003122718.GZ3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20180928111821.24376-1-josef@toxicpanda.com>
 <20180928111821.24376-19-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180928111821.24376-19-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 07:17:57AM -0400, Josef Bacik wrote:
> We're getting a lockdep splat because we take the dio_sem under the

Can you please add the important bits of the lockdep warning to the
changelog? And possibly reference to the test or workload that triggers
that.

> log_mutex.  What we really need is to protect fsync() from logging an
> extent map for an extent we never waited on higher up, so just guard the
> whole thing with dio_sem.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/file.c     | 12 ++++++++++++
>  fs/btrfs/tree-log.c |  2 --
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 095f0bb86bb7..c07110edb9de 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2079,6 +2079,14 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		goto out;
>  
>  	inode_lock(inode);
> +
> +	/*
> +	 * We take the dio_sem here because the tree log stuff can race with
> +	 * lockless dio writes and get an extent map logged for an extent we
> +	 * never waited on.  We need it this high up for lockdep reasons.
> +	 */
> +	down_write(&BTRFS_I(inode)->dio_sem);
> +
>  	atomic_inc(&root->log_batch);
>  
>  	/*
> @@ -2087,6 +2095,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	 */
>  	ret = btrfs_wait_ordered_range(inode, start, len);
>  	if (ret) {
> +		up_write(&BTRFS_I(inode)->dio_sem);
>  		inode_unlock(inode);
>  		goto out;
>  	}
> @@ -2110,6 +2119,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		 * checked called fsync.
>  		 */
>  		ret = filemap_check_wb_err(inode->i_mapping, file->f_wb_err);
> +		up_write(&BTRFS_I(inode)->dio_sem);
>  		inode_unlock(inode);
>  		goto out;
>  	}
> @@ -2128,6 +2138,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	trans = btrfs_start_transaction(root, 0);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
> +		up_write(&BTRFS_I(inode)->dio_sem);
>  		inode_unlock(inode);
>  		goto out;
>  	}
> @@ -2149,6 +2160,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	 * file again, but that will end up using the synchronization
>  	 * inside btrfs_sync_log to keep things safe.
>  	 */
> +	up_write(&BTRFS_I(inode)->dio_sem);
>  	inode_unlock(inode);
>  
>  	/*
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1650dc44a5e3..66b7e059b765 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>  
>  	INIT_LIST_HEAD(&extents);
>  
> -	down_write(&inode->dio_sem);
>  	write_lock(&tree->lock);
>  	test_gen = root->fs_info->last_trans_committed;
>  	logged_start = start;
> @@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>  	}
>  	WARN_ON(!list_empty(&extents));
>  	write_unlock(&tree->lock);
> -	up_write(&inode->dio_sem);
>  
>  	btrfs_release_path(path);
>  	if (!ret)
> -- 
> 2.14.3
