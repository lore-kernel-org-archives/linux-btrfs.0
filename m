Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C67ECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 17:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C19D2084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 17:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJUCip/y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C19D2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbeJ0CSh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 22:18:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37059 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbeJ0CSh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 22:18:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id d14-v6so2154173qto.4
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 10:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=80hQRr96wbEt73o8LtbaV4syVNwjFfQTWTg0pq1B2KQ=;
        b=QJUCip/yzeBZwJi5MCqfD0zRR+H/Y2aKsrNqu0J0k0ORo1Slv4l6oU3WcnetHqOUlX
         4LulJVNkD/+7AjszWutu7OzLjMcz1bPr+qTbkXxHn9UdiarRbQZLmmBGwTGYgEq+cYEw
         KPQG+A38bMNbNVcBlC6OhSzHxXHVHK7qoJVGEmtdUjeiXiDwIhUs7WZPEChy8tF1vz6k
         NAHFOtbDo2c4cq+t7aAOiKOVHJHFJIxM7q8jrGZrSqJDyH1TQvw67BI5psbk2pvF6pqw
         vjNZTOstnbE3xlSgdDpvPXYpE7CorFKVKtzvXjqqB/WxmT2VAYIIvNR4rsHFbfck4y4R
         aV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=80hQRr96wbEt73o8LtbaV4syVNwjFfQTWTg0pq1B2KQ=;
        b=KBmEpbvjnOGVygjqfjx4TFj+uTzJoe15vUByXwEI/QJbJ/Tq6AO+prMpC0gif+UlqO
         RsxNaKJjqDHaWbCcTq2HroweEgszTv3gf7i//hdVz6mUZCvVDC2/eOnqP3dq+8o1F/lE
         124eW+swK/+VktZSpvlKAcjERVaMrcyANVJdLUk95vDUXghKRAcTPnRV9GdcOqzeugib
         0qQHaywdiUAkhWFVu1s3QrRaMsy76SA9aUGc0O+3FX+42oY0dCWTVftoKIzKwIpPzsit
         uFZq5PwIe0qy16dD8pSkyyAnaj/JpyudLgmARadIdMaM/GXwf4nqO959FZQIV6/sY0cs
         8j7g==
X-Gm-Message-State: AGRZ1gKACAPOJBEzTvmUjW4JBEulwCKKwpVyZbn0sgyGeQDYwufWI3xk
        Jkngq9Ak3jcbwA8xkxwPdxdyC2pBWYlvOrc8suQ=
X-Google-Smtp-Source: AJdET5fIQcOQHQdC4ebjIft5QByrtyQNgQUzqzcwd1MCimO2nZ/n60PU6rQtQ/iOUctJ0RURzDxMIwD7+qyV/xXXv5E=
X-Received: by 2002:ac8:687:: with SMTP id f7-v6mr4062173qth.348.1540575642339;
 Fri, 26 Oct 2018 10:40:42 -0700 (PDT)
MIME-Version: 1.0
References: <20181026161521.7336-1-fdmanana@kernel.org>
In-Reply-To: <20181026161521.7336-1-fdmanana@kernel.org>
From:   Liu Bo <obuil.liubo@gmail.com>
Date:   Fri, 26 Oct 2018 10:40:31 -0700
Message-ID: <CANQeFDCCDRjyyj8sOM_b=HCWb5NRm5cNyj+Pnn9CSDyPchiivw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: remove no longer used stuff for tracking pending
 ordered extents
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 26, 2018 at 9:16 AM <fdmanana@kernel.org> wrote:
>
> From: Filipe Manana <fdmanana@suse.com>
>
> Tracking pending ordered extents per transaction was introduced in commit
> 50d9aa99bd35 ("Btrfs: make sure logged extents complete in the current
> transaction V3") and later updated in commit 161c3549b45a ("Btrfs: change
> how we wait for pending ordered extents").
>
> However now that on fsync we always wait for ordered extents to complete
> before logging, done in commit 5636cf7d6dc8 ("btrfs: remove the logged
> extents infrastructure"), we no longer need the stuff to track for pending
> ordered extents, which was not completely removed in the mentioned commit.
> So remove the remaining of the pending ordered extents infrastructure.
>

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ordered-data.c | 30 ------------------------------
>  fs/btrfs/ordered-data.h |  2 --
>  fs/btrfs/transaction.c  | 11 -----------
>  fs/btrfs/transaction.h  |  2 --
>  4 files changed, 45 deletions(-)
>
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 0c4ef208b8b9..6fde2b2741ef 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -460,7 +460,6 @@ void btrfs_remove_ordered_extent(struct inode *inode,
>         struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
>         struct btrfs_root *root = btrfs_inode->root;
>         struct rb_node *node;
> -       bool dec_pending_ordered = false;
>
>         /* This is paired with btrfs_add_ordered_extent. */
>         spin_lock(&btrfs_inode->lock);
> @@ -477,37 +476,8 @@ void btrfs_remove_ordered_extent(struct inode *inode,
>         if (tree->last == node)
>                 tree->last = NULL;
>         set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
> -       if (test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags))
> -               dec_pending_ordered = true;
>         spin_unlock_irq(&tree->lock);
>
> -       /*
> -        * The current running transaction is waiting on us, we need to let it
> -        * know that we're complete and wake it up.
> -        */
> -       if (dec_pending_ordered) {
> -               struct btrfs_transaction *trans;
> -
> -               /*
> -                * The checks for trans are just a formality, it should be set,
> -                * but if it isn't we don't want to deref/assert under the spin
> -                * lock, so be nice and check if trans is set, but ASSERT() so
> -                * if it isn't set a developer will notice.
> -                */
> -               spin_lock(&fs_info->trans_lock);
> -               trans = fs_info->running_transaction;
> -               if (trans)
> -                       refcount_inc(&trans->use_count);
> -               spin_unlock(&fs_info->trans_lock);
> -
> -               ASSERT(trans);
> -               if (trans) {
> -                       if (atomic_dec_and_test(&trans->pending_ordered))
> -                               wake_up(&trans->pending_wait);
> -                       btrfs_put_transaction(trans);
> -               }
> -       }
> -
>         spin_lock(&root->ordered_extent_lock);
>         list_del_init(&entry->root_extent_list);
>         root->nr_ordered_extents--;
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 02d813aaa261..b10e6765d88f 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -56,8 +56,6 @@ struct btrfs_ordered_sum {
>                                        * the isize. */
>  #define BTRFS_ORDERED_TRUNCATED 8 /* Set when we have to truncate an extent */
>
> -#define BTRFS_ORDERED_PENDING 9 /* We are waiting for this ordered extent to
> -                                 * complete in the current transaction. */
>  #define BTRFS_ORDERED_REGULAR 10 /* Regular IO for COW */
>
>  struct btrfs_ordered_extent {
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 3b84f5015029..2fe6c2b1d94b 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -232,14 +232,12 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
>         extwriter_counter_init(cur_trans, type);
>         init_waitqueue_head(&cur_trans->writer_wait);
>         init_waitqueue_head(&cur_trans->commit_wait);
> -       init_waitqueue_head(&cur_trans->pending_wait);
>         cur_trans->state = TRANS_STATE_RUNNING;
>         /*
>          * One for this trans handle, one so it will live on until we
>          * commit the transaction.
>          */
>         refcount_set(&cur_trans->use_count, 2);
> -       atomic_set(&cur_trans->pending_ordered, 0);
>         cur_trans->flags = 0;
>         cur_trans->start_time = ktime_get_seconds();
>
> @@ -1908,13 +1906,6 @@ static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
>                 btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  }
>
> -static inline void
> -btrfs_wait_pending_ordered(struct btrfs_transaction *cur_trans)
> -{
> -       wait_event(cur_trans->pending_wait,
> -                  atomic_read(&cur_trans->pending_ordered) == 0);
> -}
> -
>  int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>  {
>         struct btrfs_fs_info *fs_info = trans->fs_info;
> @@ -2049,8 +2040,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>
>         btrfs_wait_delalloc_flush(fs_info);
>
> -       btrfs_wait_pending_ordered(cur_trans);
> -
>         btrfs_scrub_pause(fs_info);
>         /*
>          * Ok now we need to make sure to block out any other joins while we
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 4cbb1b55387d..703d5116a2fc 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -39,7 +39,6 @@ struct btrfs_transaction {
>          */
>         atomic_t num_writers;
>         refcount_t use_count;
> -       atomic_t pending_ordered;
>
>         unsigned long flags;
>
> @@ -51,7 +50,6 @@ struct btrfs_transaction {
>         time64_t start_time;
>         wait_queue_head_t writer_wait;
>         wait_queue_head_t commit_wait;
> -       wait_queue_head_t pending_wait;
>         struct list_head pending_snapshots;
>         struct list_head pending_chunks;
>         struct list_head switch_commits;
> --
> 2.11.0
>
