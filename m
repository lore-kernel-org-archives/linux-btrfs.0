Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B06FC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21D22217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfB0Sab (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:30:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:48684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbfB0Sab (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 13:30:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19F0AAFFB;
        Wed, 27 Feb 2019 18:30:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8444DA83C; Wed, 27 Feb 2019 19:31:49 +0100 (CET)
Date:   Wed, 27 Feb 2019 19:31:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix file corruption after snapshotting due to
 mix of buffered/DIO writes
Message-ID: <20190227183149.GB31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190204142810.1800-1-fdmanana@kernel.org>
 <20190227134230.11860-1-fdmanana@kernel.org>
 <20190227172629.GB24609@twin.jikos.cz>
 <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 05:32:55PM +0000, Filipe Manana wrote:
> On Wed, Feb 27, 2019 at 5:25 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Feb 27, 2019 at 01:42:30PM +0000, fdmanana@kernel.org wrote:
> > > @@ -1897,15 +1899,45 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
> > >        * from already being in a transaction and our join_transaction doesn't
> > >        * have to re-take the fs freeze lock.
> > >        */
> > > -     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> > > +     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
> > >               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> > > +     } else {
> > > +             struct btrfs_pending_snapshot *pending;
> > > +             struct list_head *head = &trans->transaction->pending_snapshots;
> > > +
> > > +             /*
> > > +              * Flush dellaloc for any root that is going to be snapshotted.
> > > +              * This is done to avoid a corrupted version of files, in the
> > > +              * snapshots, that had both buffered and direct IO writes (even
> > > +              * if they were done sequentially) due to an unordered update of
> > > +              * the inode's size on disk.
> > > +              */
> > > +             list_for_each_entry(pending, head, list)
> > > +                     btrfs_start_delalloc_snapshot(pending->root);
> > > +     }
> >
> > A diff would be better than words, incremental on top of your patch:
> 
> You mean, better than a full 2nd version patch I suppose.

I mean better than my attempts to explain by words the error handling
logic that I was proposing.

> >
> > @@ -1912,8 +1912,15 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
> >                  * if they were done sequentially) due to an unordered update of
> >                  * the inode's size on disk.
> >                  */
> > -               list_for_each_entry(pending, head, list)
> > -                       btrfs_start_delalloc_snapshot(pending->root);
> > +               list_for_each_entry(pending, head, list) {
> > +                       int ret;
> > +
> > +                       ret = btrfs_start_delalloc_snapshot(pending->root);
> > +                       if (ret < 0) {
> > +                               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> > +                               break;
> > +                       }
> 
> What do you expect by falling back to writeback_inodes_sb()?
> It all ends up going through the same btrfs writeback path.
> And as I left it, if an error happens for one root, it still tries to
> flush writeback for all the remaining roots as well, so I don't get it
> why you fallback to writeback_inodes_sb().

As I read the changelog, you say that the corruption does not happen
with FLUSHONCOMMIT, which does writeback_inodes_sb. Using that would be
too heavy, thus you only start the delalloc on snapshotted roots.

So the idea is to use the same logic of flushoncommit in the unlikely
case when btrfs_start_delalloc_snapshot would fail. Only at some
performance cost, unless I'm missing something.

As for the v2 as you implement it without any error handling, doesn't
this allow the corruption to happen? If start_delalloc_inodes has a lot
of inodes for which it needs to allocate delalloc_work, the failure is
possible. That the list_for_each continues does not affect that
particular root.

> > Making a switch by the exact error is probably not necessary and wouldn't be
> > future proof anyway.
> 
> Not sure I understood that sentence.

Under v1 I was suggesting to filter out all possible errors from
btrfs_start_delalloc_snapshot, EROFS and ENOMEM. So by 'making a switch'
I meant

	if (ret == -EROFS) {
		break;
	} else {
		writeback_inodes_sb();
		break;
	}

> Anyway, it's not clear to me whether as it is it's fine, or do you
> want an incremental patch, or something else.

I want to continue the discussion about the error handling.  The
incremental diff was to show actual code behind my idea.

If this weren't a correctness and commit related code I probably would
not go that far be ok with the errors and abort. So I'm hoping you
could help me find good options with low impact as the change affects
the default commit path.
