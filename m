Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6BDC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D2620C01
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551288790;
	bh=sL38BfyKrBotvPYfqOOAgxdjx3/btSYK5F11WjeAIJQ=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=cf8sbh17gt9ZQPhKxTvzOL306N4aRFzJbiHeXgB8DGIrFmUJnPqts1/vg1II3DPhe
	 6kRcb/VYrtd2qyt66Hht0GjBQVB/G1Nn2z0XNGKooVJLcoojVKWzXQgRONEr1Uh88s
	 rBcmnvYPtAmPtBknHOcntZiFwxdVErf+w+uHrzv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfB0RdJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:33:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfB0RdJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 12:33:09 -0500
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF3920C01
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551288788;
        bh=sL38BfyKrBotvPYfqOOAgxdjx3/btSYK5F11WjeAIJQ=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=cHCPeEjLX4fNjk/eHUFcqXQvlm7qJCodXA2cbYhkQ2KqK70ziIYBFsbME21nc6L0p
         j61y0kjz63wogXDFmaWkOO6FWXiTfXu7c7fC6wrexIATlZTQJgxt16vVT8JQdy4dJZ
         ZCbXDoke93au2LoMisu9AlEJq36cQA5ffHLRBfQY=
Received: by mail-vk1-f179.google.com with SMTP id l62so4056521vkh.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 09:33:07 -0800 (PST)
X-Gm-Message-State: AHQUAuZQJMQ6teAgvt7j+LIhPVakVKxqtHOX/MXEzJpVu62TXgkubBbE
        idnLw9itONX6MewxmfZ8kqNuCRvn4N/yZqmc/eY=
X-Google-Smtp-Source: AHgI3IYkG27AR+DsDsvUFcaEGZ6pjCaMHR7bVb26JuQ4pe/pESCWY2ZSIT6EpjJlDy12WWsI4KbyqZZohNVBbTwGsy8=
X-Received: by 2002:a1f:fe8d:: with SMTP id l135mr1356595vki.88.1551288786982;
 Wed, 27 Feb 2019 09:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20190204142810.1800-1-fdmanana@kernel.org> <20190227134230.11860-1-fdmanana@kernel.org>
 <20190227172629.GB24609@twin.jikos.cz>
In-Reply-To: <20190227172629.GB24609@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 27 Feb 2019 17:32:55 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
Message-ID: <CAL3q7H4a6VjrFnxRtZVxdsjt7=bTGJCiXACyYDcEsCif7SHHcw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix file corruption after snapshotting due to
 mix of buffered/DIO writes
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 5:25 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Feb 27, 2019 at 01:42:30PM +0000, fdmanana@kernel.org wrote:
> > @@ -1897,15 +1899,45 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
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
> > +             /*
> > +              * Flush dellaloc for any root that is going to be snapshotted.
> > +              * This is done to avoid a corrupted version of files, in the
> > +              * snapshots, that had both buffered and direct IO writes (even
> > +              * if they were done sequentially) due to an unordered update of
> > +              * the inode's size on disk.
> > +              */
> > +             list_for_each_entry(pending, head, list)
> > +                     btrfs_start_delalloc_snapshot(pending->root);
> > +     }
>
> A diff would be better than words, incremental on top of your patch:

You mean, better than a full 2nd version patch I suppose.

>
> @@ -1912,8 +1912,15 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
>                  * if they were done sequentially) due to an unordered update of
>                  * the inode's size on disk.
>                  */
> -               list_for_each_entry(pending, head, list)
> -                       btrfs_start_delalloc_snapshot(pending->root);
> +               list_for_each_entry(pending, head, list) {
> +                       int ret;
> +
> +                       ret = btrfs_start_delalloc_snapshot(pending->root);
> +                       if (ret < 0) {
> +                               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> +                               break;
> +                       }

What do you expect by falling back to writeback_inodes_sb()?
It all ends up going through the same btrfs writeback path.
And as I left it, if an error happens for one root, it still tries to
flush writeback for all the remaining roots as well, so I don't get it
why you fallback to writeback_inodes_sb().

> +               }
>         }
>         return 0;
>  }
> ---
>
> Making a switch by the exact error is probably not necessary and wouldn't be
> future proof anyway.

Not sure I understood that sentence.

Anyway, it's not clear to me whether as it is it's fine, or do you
want an incremental patch, or something else.

thanks
