Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331BFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC4992177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550510891;
	bh=6ffBh9Rmhis1bpO1ksT0x6ZKOIb41LvrMEkzTwDyFYU=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=isCU08M1Ri/s6XZDIC/GhEv9P1ex66f/CCL3P+aTfWPXq4tusn9hhkxfdHQL2rS2e
	 COXuQPDiMkf3dAwRng4SP3u3IP5wRI6z/Y1I3A5JUa9KjMZ9UNJa+Fbvj3h+3yDrMw
	 beRsAlg1ZK13dK6IxEVQzc8f6X0foay5UQMrISwM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfBRR2K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730010AbfBRR2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 12:28:07 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F682177E
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550510886;
        bh=6ffBh9Rmhis1bpO1ksT0x6ZKOIb41LvrMEkzTwDyFYU=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=gL11eCvPvqslCa+BVe3fHk/ZK80Du6lnG+piB2m8+I/okGj4v50QRErMPqRhTDxRw
         5s0VJLKmjTQJ+s7uS9IEb22vzKLcFe0lqHPv+rBCD0cd4okREgRMlz5NZklP5I03EL
         /td1QmChT5oPrEYL0V45YtRLYem7OVfFPP0NEruc=
Received: by mail-vs1-f48.google.com with SMTP id t7so10100291vsq.5
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 09:28:05 -0800 (PST)
X-Gm-Message-State: AHQUAuYYcGb3fbgJD1RFNuNzuP/XNX8Se4QqSqwe5pkKkbM4fnLo575v
        PJ3y0Qaz3QAEcJwsQQNStT2zEpUKHhJy5biXeJQ=
X-Google-Smtp-Source: AHgI3IZEY30bee/9UeZr1swEGpgwMq5hdlG7bcKRahbqRVng4PRiXkuydPXr1I4/La9AMLDeAhUK+YUF1B9X/r1OTBo=
X-Received: by 2002:a67:5e86:: with SMTP id s128mr12867029vsb.90.1550510884982;
 Mon, 18 Feb 2019 09:28:04 -0800 (PST)
MIME-Version: 1.0
References: <20190204142810.1800-1-fdmanana@kernel.org> <20190218171109.GO9874@twin.jikos.cz>
In-Reply-To: <20190218171109.GO9874@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 18 Feb 2019 17:27:54 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7LAxa0qKarywvRk3YmRS_86G2uyN1rfW0iAPZ9KqTtJQ@mail.gmail.com>
Message-ID: <CAL3q7H7LAxa0qKarywvRk3YmRS_86G2uyN1rfW0iAPZ9KqTtJQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix file corruption after snapshotting
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 5:09 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Mon, Feb 04, 2019 at 02:28:10PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When we are mixing buffered writes with direct IO writes against the same
> > file and snapshotting is happening concurrently, we can end up with a
> > corrupt file content in the snapshot. Example:
>
> The patch subject sounds like it's a corruption in generic snapshot
> behaviour. But it's when mixing buffered and direct io, which is a
> potential corruption scenario on itself, so snapshotting does make it
> that much worse. I'd like to see that somhow reflected in the subject.

It's a kind of corruption created by snapshotting.
I tried to come up with a better subject that wasn't too long to fit
in the 74-75 characters limit, but couldn't come up with any.
So I left the explanation and example in the remainder of the change log.

If you have a better suggestion... I'm open to it.

>
> > 1) Inode/file is empty.
> >
> > 2) Snapshotting starts.
> >
> > 2) Buffered write at offset 0 length 256Kb. This updates the i_size of the
> >    inode to 256Kb, disk_i_size remains zero. This happens after the task
> >    doing the snapshot flushes all existing delalloc.
> >
> > 3) DIO write at offset 256Kb length 768Kb. Once the ordered extent
> >    completes it sets the inode's disk_i_size to 1Mb (256Kb + 768Kb) and
> >    updates the inode item in the fs tree with a size of 1Mb (which is
> >    the value of disk_i_size).
> >
> > 4) The dealloc for the range [0, 256Kb[ did not start yet.
> >
> > 5) The transaction used in the DIO ordered extent completion, which updated
> >    the inode item, is committed by the snapshotting task.
> >
> > 6) Snapshot creation completes.
> >
> > 7) Dealloc for the range [0, 256Kb[ is flushed.
> >
> > After that when reading the file from the snapshot we always get zeroes for
> > the range [0, 256Kb[, the file has a size of 1Mb and the data written by
> > the direct IO write is found. From an application's point of view this is
> > a corruption, since in the source subvolume it could never read a version
> > of the file that included the data from the direct IO write without the
> > data from the buffered write included as well. In the snapshot's tree,
> > file extent items are missing for the range [0, 256Kb[.
> >
> > The issue, obviously, does not happen when using the -o flushoncommit
> > mount option.
> >
> > Fix this by flushing delalloc for all the roots that are about to be
> > snapshotted when committing a transaction. This guarantees total ordering
> > when updating the disk_i_size of an inode since the flush for dealloc is
> > done when a transaction is in the TRANS_STATE_COMMIT_START state and wait
> > is done once no more external writers exist. This is similar to what we
> > do when using the flushoncommit mount option, but we do it only if the
> > transaction has snapshots to create and only for the roots of the
> > subvolumes to be snapshotted. The bulk of the dealloc is flushed in the
> > snapshot creation ioctl, so the flush work we do inside the transaction
> > is minimized.
> >
> > This issue, involving buffered and direct IO writes with snapshotting, is
> > often triggered by fstest btrfs/078, and got reported by fsck when not
> > using the NO_HOLES features, for example:
> >
> >   $ cat results/btrfs/078.full
> >   (...)
> >   _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
> >   *** fsck.btrfs output ***
> >   [1/7] checking root items
> >   [2/7] checking extents
> >   [3/7] checking free space cache
> >   [4/7] checking fs roots
> >   root 258 inode 264 errors 100, file extent discount
> >   Found file extent holes:
> >         start: 524288, len: 65536
> >   ERROR: errors found in fs roots
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/transaction.c | 36 ++++++++++++++++++++++++++++++------
> >  1 file changed, 30 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index 4ec2b660d014..2e8f15eee2e8 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -1886,8 +1886,10 @@ static void btrfs_cleanup_pending_block_groups(struct btrfs_trans_handle *trans)
> >         }
> >  }
> >
> > -static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
> > +static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
> >  {
> > +     struct btrfs_fs_info *fs_info = trans->fs_info;
> > +
> >       /*
> >        * We use writeback_inodes_sb here because if we used
> >        * btrfs_start_delalloc_roots we would deadlock with fs freeze.
> > @@ -1897,15 +1899,37 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
> >        * from already being in a transaction and our join_transaction doesn't
> >        * have to re-take the fs freeze lock.
> >        */
> > -     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> > +     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
> >               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> > +     } else {
> > +             struct btrfs_pending_snapshot *pending;
> > +             struct list_head *head = &trans->transaction->pending_snapshots;
> > +
>
> A comment would be good here as it's not obvious why the sync is done
> here (and similarly the waiting part in btrfs_wait_delalloc_flush).

Intentionally left out due to the changelog explaining it and avoiding
a too long comment explaining why/how the corruption happens.

>
> > +             list_for_each_entry(pending, head, list) {
> > +                     int ret;
> > +
> > +                     ret = btrfs_start_delalloc_snapshot(pending->root);
> > +                     if (ret)
> > +                             return ret;
>
> This adds a potential failure to the middle of transaction commit. I've
> checked the errors, there's EROFS (after a global fs error state) and
> ENOMEM (from start_delalloc_inodes).
>
> The EROFS could be filtered as a non-issue. ENOMEM means that the
> flushing was not possible and skipping it would bring back the problem
> this patch is fixing.
>
> So, how about calling writeback_inodes_sb in that case as a fallback?

Thought about it, but the reason I didn't do it is that if you
fallback to writeback_unodes_sb, you'll never have the error reported
to the user.
It's very unlikely the user will do an fsync on the snapshot version
of the file, specially if it's a RO snapshot, which would be the only
way to report the error.


> I'd really like to avoid returning failure from
> btrfs_start_delalloc_flush so the extra overhead of the writeback (in a
> theoretical error case anyway) should be ok.

Me too, as long as the error is reported (a message in syslog/dmesg is
very likely to be missed).


>
> > +             }
> > +     }
> >       return 0;
> >  }
> >
> > -static inline void btrfs_wait_delalloc_flush(struct btrfs_fs_info *fs_info)
> > +static inline void btrfs_wait_delalloc_flush(struct btrfs_trans_handle *trans)
> >  {
> > -     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> > +     struct btrfs_fs_info *fs_info = trans->fs_info;
> > +
> > +     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
> >               btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
> > +     } else {
> > +             struct btrfs_pending_snapshot *pending;
> > +             struct list_head *head = &trans->transaction->pending_snapshots;
> > +
> > +             list_for_each_entry(pending, head, list)
> > +                     btrfs_wait_ordered_extents(pending->root,
> > +                                                U64_MAX, 0, U64_MAX);
> > +     }
> >  }
> >
> >  int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>
> The patch has been in for-next for some time, I just did not get to
> writing the comments. Though the dio/buffered use is discouraged, the
> errors reported by the test should be fixed. The obvious concern was the
> perf penalty, but from that point I it's ok as you point out above.
