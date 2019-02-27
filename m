Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301D9C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9CBD2184A
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551293786;
	bh=PN9aH0WwH7wWyRbwb864pPvoCsSe+HGLm4f1Txv0eAQ=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=cfwHLmdabRF8TYLmEvL3ICPliZyq2d7Qw8ojuSCi4rQieAQbD1RrHRH77/5FqyfUO
	 bykg/A3MWFKLjswSwQRv8lmi8lgMN6nJ2k8OFexoaHgfNgzX5OBmf22pgnA4/v10ua
	 DyOGYgUho/TMQ5uDWuFx/v3MH6iK0EVYmZqxpHuI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfB0S4Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:56:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbfB0S4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 13:56:24 -0500
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D352184A
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 18:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551293782;
        bh=PN9aH0WwH7wWyRbwb864pPvoCsSe+HGLm4f1Txv0eAQ=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=BsVI28vzUYvGt8iij+8MiJPJsZGtQLFxDhpzDtGBCQLedZgHDlLNOdbWeWR6dQH8Q
         /l04YMCdssoCusJssjjJzKTJZaTxw8hN9OTaJgC9xUKjRAjd1bsTvN5G4zplOowa+X
         Zyc6NAd104A16sPVfMKPBcPvwZWzsWDHeI6NQJvk=
Received: by mail-ua1-f41.google.com with SMTP id s26so5733389uao.9
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 10:56:22 -0800 (PST)
X-Gm-Message-State: AHQUAuZG5+7Dm9WNf4aGjf5/H2H4dsT32JXzUOk4mtGR6A10Ca3ZkYZP
        MZ/GF9MmYPMRcnyEag59bGjBX2NEeSfv1NfZAWY=
X-Google-Smtp-Source: AHgI3IacUN4h77S5KR/PsqTXqw5PF38Ko/LZJWlLFE2LTBsdUU0J1YJG05o7o9YA6HGO+Yjj3b87CkOFFJqJHB+g1sw=
X-Received: by 2002:a67:e28e:: with SMTP id g14mr2574416vsf.95.1551293781625;
 Wed, 27 Feb 2019 10:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20190204142810.1800-1-fdmanana@kernel.org> <20190227134230.11860-1-fdmanana@kernel.org>
 <20190227172629.GB24609@twin.jikos.cz> <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
 <20190227183149.GB31119@twin.jikos.cz>
In-Reply-To: <20190227183149.GB31119@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 27 Feb 2019 18:56:10 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4eJr5ymDgYFa0DTxPif=7yrOhqMFhvsByijbKjM+=UUg@mail.gmail.com>
Message-ID: <CAL3q7H4eJr5ymDgYFa0DTxPif=7yrOhqMFhvsByijbKjM+=UUg@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix file corruption after snapshotting due to
 mix of buffered/DIO writes
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 6:30 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Feb 27, 2019 at 05:32:55PM +0000, Filipe Manana wrote:
> > On Wed, Feb 27, 2019 at 5:25 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Wed, Feb 27, 2019 at 01:42:30PM +0000, fdmanana@kernel.org wrote:
> > > > @@ -1897,15 +1899,45 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
> > > >        * from already being in a transaction and our join_transaction doesn't
> > > >        * have to re-take the fs freeze lock.
> > > >        */
> > > > -     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> > > > +     if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
> > > >               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> > > > +     } else {
> > > > +             struct btrfs_pending_snapshot *pending;
> > > > +             struct list_head *head = &trans->transaction->pending_snapshots;
> > > > +
> > > > +             /*
> > > > +              * Flush dellaloc for any root that is going to be snapshotted.
> > > > +              * This is done to avoid a corrupted version of files, in the
> > > > +              * snapshots, that had both buffered and direct IO writes (even
> > > > +              * if they were done sequentially) due to an unordered update of
> > > > +              * the inode's size on disk.
> > > > +              */
> > > > +             list_for_each_entry(pending, head, list)
> > > > +                     btrfs_start_delalloc_snapshot(pending->root);
> > > > +     }
> > >
> > > A diff would be better than words, incremental on top of your patch:
> >
> > You mean, better than a full 2nd version patch I suppose.
>
> I mean better than my attempts to explain by words the error handling
> logic that I was proposing.
>
> > >
> > > @@ -1912,8 +1912,15 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
> > >                  * if they were done sequentially) due to an unordered update of
> > >                  * the inode's size on disk.
> > >                  */
> > > -               list_for_each_entry(pending, head, list)
> > > -                       btrfs_start_delalloc_snapshot(pending->root);
> > > +               list_for_each_entry(pending, head, list) {
> > > +                       int ret;
> > > +
> > > +                       ret = btrfs_start_delalloc_snapshot(pending->root);
> > > +                       if (ret < 0) {
> > > +                               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> > > +                               break;
> > > +                       }
> >
> > What do you expect by falling back to writeback_inodes_sb()?
> > It all ends up going through the same btrfs writeback path.
> > And as I left it, if an error happens for one root, it still tries to
> > flush writeback for all the remaining roots as well, so I don't get it
> > why you fallback to writeback_inodes_sb().
>
> As I read the changelog, you say that the corruption does not happen
> with FLUSHONCOMMIT, which does writeback_inodes_sb. Using that would be
> too heavy, thus you only start the delalloc on snapshotted roots.

It does not happen with flushoncommit because delalloc is flushed for all roots.
If flushoncommit (writeback_inodes_sb()) would flush only for roots
that are about to be snapshotted, the corruption wouldn't happen as
well.

>
> So the idea is to use the same logic of flushoncommit in the unlikely
> case when btrfs_start_delalloc_snapshot would fail. Only at some
> performance cost, unless I'm missing something.

Ok, so I hope the first paragraph above explains why there's no need
to fallback to the "flush all delalloc for all roots" logic
(writeback_inodes_sb()).

>
> As for the v2 as you implement it without any error handling, doesn't
> this allow the corruption to happen? If start_delalloc_inodes has a lot
> of inodes for which it needs to allocate delalloc_work, the failure is
> possible. That the list_for_each continues does not affect that
> particular root.

Yes, it allows for the corruption to happen, that's why I had the
error returned in v1.

writeback_inodes_sb() isn't special in any way - flushing some
delalloc range can fail the same way, it ends up calling the same
btrfs writepages() callback. Yes, it doesn't return any error, because
it's relying on callers either not caring about it, or if they do,
checking the inode's mapping for an error, which btrfs sets through
its writepages() callback if any an error happens (by calling
mapping_set_error()),
or any other fs specific way of storing/checking for writeback errors.

If we get an error when flushing the dealloc range from the example in
the changelog, then the corruption happens, regardless of writeback
being
triggered by writeback_inodes_sb() or btrfs_start_delalloc_snapshot().

>
> > > Making a switch by the exact error is probably not necessary and wouldn't be
> > > future proof anyway.
> >
> > Not sure I understood that sentence.
>
> Under v1 I was suggesting to filter out all possible errors from
> btrfs_start_delalloc_snapshot, EROFS and ENOMEM. So by 'making a switch'
> I meant
>
>         if (ret == -EROFS) {
>                 break;
>         } else {
>                 writeback_inodes_sb();
>                 break;
>         }
>
> > Anyway, it's not clear to me whether as it is it's fine, or do you
> > want an incremental patch, or something else.
>
> I want to continue the discussion about the error handling.  The
> incremental diff was to show actual code behind my idea.
>
> If this weren't a correctness and commit related code I probably would
> not go that far be ok with the errors and abort. So I'm hoping you
> could help me find good options with low impact as the change affects
> the default commit path.
