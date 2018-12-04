Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2231CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4DF62087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 11:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4DF62087F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbeLDLrF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:47:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:53914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbeLDLrF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 06:47:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC218AF63;
        Tue,  4 Dec 2018 11:46:59 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs: replace cleaner_delayed_iput_mutex with a
 waitqueue
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203160652.25078-1-josef@toxicpanda.com>
 <20181203160652.25078-4-josef@toxicpanda.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <5caa415a-bfd4-2abb-11ca-d247c0d87c2c@suse.com>
Date:   Tue, 4 Dec 2018 13:46:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203160652.25078-4-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 18:06 ч., Josef Bacik wrote:
> The throttle path doesn't take cleaner_delayed_iput_mutex, which means
> we could think we're done flushing iputs in the data space reservation
> path when we could have a throttler doing an iput.  There's no real
> reason to serialize the delayed iput flushing, so instead of taking the
> cleaner_delayed_iput_mutex whenever we flush the delayed iputs just
> replace it with an atomic counter and a waitqueue.  This removes the
> short (or long depending on how big the inode is) window where we think
> there are no more pending iputs when there really are some.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/ctree.h       |  4 +++-
>  fs/btrfs/disk-io.c     |  5 ++---
>  fs/btrfs/extent-tree.c | 13 ++++++++-----
>  fs/btrfs/inode.c       | 21 +++++++++++++++++++++
>  4 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index dc56a4d940c3..20af5d6d81f1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -915,7 +915,8 @@ struct btrfs_fs_info {
>  
>  	spinlock_t delayed_iput_lock;
>  	struct list_head delayed_iputs;
> -	struct mutex cleaner_delayed_iput_mutex;
> +	atomic_t nr_delayed_iputs;
> +	wait_queue_head_t delayed_iputs_wait;
>  

Have you considered whether the same could be achieved with a completion
rather than an open-coded waitqueue? I tried prototyping it and it could
be done but it becomes messy regarding when the completion should be
initialised i.e only when it's not in btrfs_add_delayed_iput


<snip>

> @@ -4958,9 +4962,8 @@ static void flush_space(struct btrfs_fs_info *fs_info,
>  		 * bunch of pinned space, so make sure we run the iputs before
>  		 * we do our pinned bytes check below.
>  		 */
> -		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
>  		btrfs_run_delayed_iputs(fs_info);
> -		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
> +		btrfs_wait_on_delayed_iputs(fs_info);

Waiting on delayed iputs here is pointless since they are run
synchronously form this context.

>  
>  		ret = may_commit_transaction(fs_info, space_info);
>  		break;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0b9f3e482cea..958e30c7c744 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3260,6 +3260,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
>  	if (atomic_add_unless(&inode->i_count, -1, 1))
>  		return;
>  
> +	atomic_inc(&fs_info->nr_delayed_iputs);
>  	spin_lock(&fs_info->delayed_iput_lock);
>  	ASSERT(list_empty(&binode->delayed_iput));
>  	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
> @@ -3280,11 +3281,31 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
>  		list_del_init(&inode->delayed_iput);
>  		spin_unlock(&fs_info->delayed_iput_lock);
>  		iput(&inode->vfs_inode);
> +		if (atomic_dec_and_test(&fs_info->nr_delayed_iputs))
> +			wake_up(&fs_info->delayed_iputs_wait);
>  		spin_lock(&fs_info->delayed_iput_lock);
>  	}
>  	spin_unlock(&fs_info->delayed_iput_lock);
>  }
>  
> +/**
> + * btrfs_wait_on_delayed_iputs - wait on the delayed iputs to be done running
> + * @fs_info - the fs_info for this fs
> + * @return - EINTR if we were killed, 0 if nothing's pending
> + *
> + * This will wait on any delayed iputs that are currently running with KILLABLE
> + * set.  Once they are all done running we will return, unless we are killed in
> + * which case we return EINTR.
> + */
> +int btrfs_wait_on_delayed_iputs(struct btrfs_fs_info *fs_info)
> +{
> +	int ret = wait_event_killable(fs_info->delayed_iputs_wait,
> +			atomic_read(&fs_info->nr_delayed_iputs) == 0);
> +	if (ret)
> +		return -EINTR;
> +	return 0;
> +}
> +
>  /*
>   * This creates an orphan entry for the given inode in case something goes wrong
>   * in the middle of an unlink.
> 
