Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A73C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F05520663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 20:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ooKX2USP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F05520663
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbeK1HAj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 02:00:39 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46351 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725752AbeK1HAj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 02:00:39 -0500
Received: by mail-qk1-f193.google.com with SMTP id q1so15333768qkf.13
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 12:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cXuKdeKAE34k8vEP+esGWWkQB5Whk4JZNDS1sEQGiTU=;
        b=ooKX2USPAQ5VdC7J17OLeuTsZ0scB6N/I46DvYAk2izQJ9m2Mm9xwdZTZ0izQ9GozB
         BB1Pc3Rz54HXnEIu2ZIrManRnSvQgFJFqXHOmSpsghzzh6GBwBkkfQ2kmkeyLu6/YGhs
         R2lrUml/T07YuV4vkVaC0lrNhdecXEj2sZ0dK1UWyDTiExtOQs+T3E95QNzm5gGMT4eB
         9BqfeCoRbAsyewfx36l/u5zviVAhDtfzpCLONBpk3QaGpf7SQ8VPM38GuGxOAa6dV2zD
         KOJ4O9ymbrWjOHjRG3JLvzEh/FFdbYblgyLXrB9ylkYX16WZp272Jl3n9uGjova4vBr5
         DPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cXuKdeKAE34k8vEP+esGWWkQB5Whk4JZNDS1sEQGiTU=;
        b=oqU8U/EP5wkYDisVdmUrcZa8tB8an51JGXvZPTJuIDsL2S5lIR9dUphH7iaWXoJ9SX
         +0v9aHDmAH5FzLP1yBO54/nKeZRd7jd+Ah2H7pi48KISkchW1z7vYrNeh4YoZ3doA8GV
         asrH2mdSHkpEv/VdV7URmYR1RlgKCuU2X8qkTfgSWje0zq53umWIjSWkZ15ZHlPO5V8J
         z7BzwhuKCKVrRH8WvJTjuc3mK1pTALwU4favCkRuto1wuCRpUhrCND98Lysjz7OQz1hW
         4fzu8ev3HDmQd5Bi4p9GqIIkbgfr1n71Uy8TlsN2eccNgHbZK2lo/jm1CQr5enEJnekr
         opPA==
X-Gm-Message-State: AA+aEWY4kdoxvvMAEvfTBTqO6jf9jyhH0TXZXTw9k2MR58VbqG3ts7Zo
        RSpX2Q541xRc5bJcu/0L113OcQ==
X-Google-Smtp-Source: AFSGD/WwGs9HTscMYIpICQNWC4sW/SfmQl9cXpLkcbwgOM6iVkwStXUxQFHIwNNOgoDy1LMqxbac7g==
X-Received: by 2002:a37:af85:: with SMTP id y127mr29859217qke.352.1543348897187;
        Tue, 27 Nov 2018 12:01:37 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:4c40])
        by smtp.gmail.com with ESMTPSA id l13sm2957523qkh.45.2018.11.27.12.01.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Nov 2018 12:01:36 -0800 (PST)
Date:   Tue, 27 Nov 2018 15:01:35 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a
 waitqueue
Message-ID: <20181127200134.kmnu3zubgl7n4d4j@macbook-pro-91.dhcp.thefacebook.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-4-josef@toxicpanda.com>
 <34807ceb-525c-2552-b2c0-a850da135f74@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34807ceb-525c-2552-b2c0-a850da135f74@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 10:29:57AM +0200, Nikolay Borisov wrote:
> 
> 
> On 21.11.18 г. 21:09 ч., Josef Bacik wrote:
> > The throttle path doesn't take cleaner_delayed_iput_mutex, which means
> 
> Which one is the throttle path? btrfs_end_transaction_throttle is only
> called during snapshot drop and relocation? What scenario triggered your
> observation and prompted this fix?
> 

One of my enospc tests runs snapshot creation/deletion in the background.

> > we could think we're done flushing iputs in the data space reservation
> > path when we could have a throttler doing an iput.  There's no real
> > reason to serialize the delayed iput flushing, so instead of taking the
> > cleaner_delayed_iput_mutex whenever we flush the delayed iputs just
> > replace it with an atomic counter and a waitqueue.  This removes the
> > short (or long depending on how big the inode is) window where we think
> > there are no more pending iputs when there really are some.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/ctree.h       |  4 +++-
> >  fs/btrfs/disk-io.c     |  5 ++---
> >  fs/btrfs/extent-tree.c |  9 +++++----
> >  fs/btrfs/inode.c       | 21 +++++++++++++++++++++
> >  4 files changed, 31 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 709de7471d86..a835fe7076eb 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -912,7 +912,8 @@ struct btrfs_fs_info {
> >  
> >  	spinlock_t delayed_iput_lock;
> >  	struct list_head delayed_iputs;
> > -	struct mutex cleaner_delayed_iput_mutex;
> > +	atomic_t nr_delayed_iputs;
> > +	wait_queue_head_t delayed_iputs_wait;
> >  
> >  	/* this protects tree_mod_seq_list */
> >  	spinlock_t tree_mod_seq_lock;
> > @@ -3237,6 +3238,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
> >  int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
> >  void btrfs_add_delayed_iput(struct inode *inode);
> >  void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
> > +int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info);
> >  int btrfs_prealloc_file_range(struct inode *inode, int mode,
> >  			      u64 start, u64 num_bytes, u64 min_size,
> >  			      loff_t actual_len, u64 *alloc_hint);
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index c5918ff8241b..3f81dfaefa32 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1692,9 +1692,7 @@ static int cleaner_kthread(void *arg)
> >  			goto sleep;
> >  		}
> >  
> > -		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> >  		btrfs_run_delayed_iputs(fs_info);
> > -		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> >  
> >  		again = btrfs_clean_one_deleted_snapshot(root);
> >  		mutex_unlock(&fs_info->cleaner_mutex);
> > @@ -2651,7 +2649,6 @@ int open_ctree(struct super_block *sb,
> >  	mutex_init(&fs_info->delete_unused_bgs_mutex);
> >  	mutex_init(&fs_info->reloc_mutex);
> >  	mutex_init(&fs_info->delalloc_root_mutex);
> > -	mutex_init(&fs_info->cleaner_delayed_iput_mutex);
> >  	seqlock_init(&fs_info->profiles_lock);
> >  
> >  	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
> > @@ -2673,6 +2670,7 @@ int open_ctree(struct super_block *sb,
> >  	atomic_set(&fs_info->defrag_running, 0);
> >  	atomic_set(&fs_info->qgroup_op_seq, 0);
> >  	atomic_set(&fs_info->reada_works_cnt, 0);
> > +	atomic_set(&fs_info->nr_delayed_iputs, 0);
> >  	atomic64_set(&fs_info->tree_mod_seq, 0);
> >  	fs_info->sb = sb;
> >  	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
> > @@ -2750,6 +2748,7 @@ int open_ctree(struct super_block *sb,
> >  	init_waitqueue_head(&fs_info->transaction_wait);
> >  	init_waitqueue_head(&fs_info->transaction_blocked_wait);
> >  	init_waitqueue_head(&fs_info->async_submit_wait);
> > +	init_waitqueue_head(&fs_info->delayed_iputs_wait);
> >  
> >  	INIT_LIST_HEAD(&fs_info->pinned_chunks);
> >  
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 3a90dc1d6b31..36f43876be22 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4272,8 +4272,9 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
> >  				 * operations. Wait for it to finish so that
> >  				 * more space is released.
> >  				 */
> > -				mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> > -				mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> > +				ret = btrfs_wait_on_delayed_iputs(fs_info);
> > +				if (ret)
> > +					return ret;
> >  				goto again;
> >  			} else {
> >  				btrfs_end_transaction(trans);
> > @@ -4838,9 +4839,9 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> >  	 * pinned space, so make sure we run the iputs before we do our pinned
> >  	 * bytes check below.
> >  	 */
> > -	mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
> >  	btrfs_run_delayed_iputs(fs_info);
> > -	mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> > +	wait_event(fs_info->delayed_iputs_wait,
> > +		   atomic_read(&fs_info->nr_delayed_iputs) == 0);
> 
> Why open code btrfs_wait_on_delayed_iputs(fs_info)? Just make it use
> wait_event instead of the killable version and use the function
> uniformally across the code base.

I don't want the flusher thread to be killable, but now that I've said that out
loud I realize that's not possible, so I'll just use the helper.  Thanks,

Josef
