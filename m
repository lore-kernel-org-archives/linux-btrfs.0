Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B732FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE3F2084B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VjWuJOCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfCZKvA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:51:00 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34956 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfCZKvA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 06:51:00 -0400
Received: by mail-ua1-f67.google.com with SMTP id f88so396781uaf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 03:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=tEdnjM72ToSQRGxbXkVgoCkqbPkVYt0tUYR7l7q1vfc=;
        b=VjWuJOCir9W3Wufv2NDWdbl8vEel9AmcW9xCc/mJneofU9tBdyVy9BduWHTvvfNtiz
         WeHwFX96nzD+1aggG0geS+Fiyt79NFK3VJDaSX1zai1jryivM9YJc33R+zPtJ8JAtxwn
         gl0mETb419Jzqzh4s1LJVkp2D+IbcGEs/w8yTaNQXn0P+oKwWsZE1wQN33OAcI2g1O/I
         ydj9oRZcr99yWInD17FZsV4P3N9xzHepYopeTCKPiTN9PyTcrWti1IRWhDozL7fA1OrR
         hQhfY2+TH4vMFNyoHJ6O90uc+ejNqC4uDK0MSFUcTwcXoQ/P6XYoHOXEVNMwkDF8uBPB
         OhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=tEdnjM72ToSQRGxbXkVgoCkqbPkVYt0tUYR7l7q1vfc=;
        b=YhphWV1iUpSndH0mFRUkqtZ8Upz27dn0dxtB7zKF6FqHb9XX2pNQ2OEq0jvYhnDp6Y
         KESnl1tSZCQc2ak2eFNoEXbSnb/bXh2/f8M5hUXV1bAppOSOsGqIwdvvPLa9M9SE9OFw
         UiSKBvtAWcqkfjtIdXLZkm1aSeuUhRqjQd26P4Gn5xmSlTkHocHq8C2iYnyWf2WSTbyq
         TSj6p7B0lCx89AGpSxLO54GfdtD8swQsS3KyJoFMvI0sTtx2ZBQOguNlEldwosYvwc+x
         zVzHQjfPk2IwXph1xSSyCI1Wof79IZCXqqcmlwVEGlLf6gDek8BqFP+8Yhr/Zbs7wzu3
         z5Sw==
X-Gm-Message-State: APjAAAVeuJ+GiP62pQL4Gis5whgJDTOIZyDrwn/rtgwENPu4ySpTMaF1
        oIVQaFa/G0UMeauQ0kic8d2qLr8hwiRAiVnp+pU=
X-Google-Smtp-Source: APXvYqwVEIsY9h6TeTuz9Y3dHuEPmjIS3Awg03MAu6Am0MSML7VTgNmaTCvT0S6eK9P37tgRw8gD9y6kCOwL3FMdSis=
X-Received: by 2002:ab0:156b:: with SMTP id p40mr16887965uae.83.1553597458821;
 Tue, 26 Mar 2019 03:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190325123132.27835-1-nborisov@suse.com> <20190325184456.GA1172@magnolia>
 <cf0fa4fe-52a6-3b7d-a381-a7b371a7de36@suse.com>
In-Reply-To: <cf0fa4fe-52a6-3b7d-a381-a7b371a7de36@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 26 Mar 2019 10:50:47 +0000
Message-ID: <CAL3q7H4oN0yFZaFcGHo4NEwyZp0z8+XnevHCbowGXZXE8CEddA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] FITRIM improvements
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>,
        Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 8:10 AM Nikolay Borisov <nborisov@suse.com> wrote:
>
> [CC'ing Filipe as he should now better ]
>
> On 25.03.19 =D0=B3. 20:44 =D1=87., Darrick J. Wong wrote:
> > On Mon, Mar 25, 2019 at 02:31:20PM +0200, Nikolay Borisov wrote:
> >> Here is v3 of the fitrim patches. Change since v2 [0]:
> >>
> >>  * Replaced BUG_ON with WARN_ON in patch 2
> >>
> >>  * Added RB to patches 04/05/06/09
> >>
> >>  * Squashed "btrfs: Transpose btrfs_close_devices/btrfs_mapping_tree_f=
ree in close_ctree"
> >>  into patch 07. It was only sent to the mailing list as a followup.
> >>
> >>  * Rebased all patches on latest misc-next.
> >>
> >>  This has undergone multiple xfstest runs and I think is ready to be m=
erged.
> >>
> >> [0] https://lore.kernel.org/linux-btrfs/20190211083510.27591-1-nboriso=
v@suse.com/
> >>
> >>
> >> Jeff Mahoney (1):
> >>   btrfs: replace pending/pinned chunks lists with io tree
> >>
> >> Nikolay Borisov (11):
> >>   btrfs: Honour FITRIM range constraints during free space trim
> >
> > This is vaguely off-topic, but I noticed that you can FITRIM a btrfs
> > filesystem mounted nologreplay.  Assuming the fitrim code uses the free
> > space information to drive the discard calls, is it safe to do that wit=
h
> > unreplayed metadata?

Nop, not safe, neither with this patchset nor without it.
I've just sent a patch to do the same you did in your fixes for xfs and ext=
4:

https://patchwork.kernel.org/patch/10870871/

Thanks for reporting it!

>
> Pertinent question, indeed. But I'd defer to Filipe since he knows the
> log tree code. Filipe, FITRIM uses the freespace_ctl struct from block
> group to trim the freespace inside block groups, as well as the free
> device space to trim unallocated space. If we have a dirty log tree are
> those coherent with the dirty data i.e is it reflected in the BG's
> freespace cache that the data in the logs tree is actually allocated? If
> the answer is 'no' then it will be prudent to disallow trim in this case.
>
>
> >
> > (And no, I don't really know what nologreplay does, so please excuse my
> > ignorance...)
>
> Log replay means the content of the log tree (which is something like a
> WAL) must be copied back into the main btree.
>
> >
> > --D
> >
> >>   btrfs: combine device update operations during transaction commit
> >>   btrfs: Handle pending/pinned chunks before blockgroup relocation
> >>     during device shrink
> >>   btrfs: Rename and export clear_btree_io_tree
> >>   btrfs: Populate ->orig_block_len during read_one_chunk
> >>   btrfs: Introduce new bits for device allocation tree
> >>   btrfs: Remove 'trans' argument from find_free_dev_extent(_start)
> >>   btrfs: Factor out in_range macro
> >>   btrfs: Optimize unallocated chunks discard
> >>   btrfs: Implement find_first_clear_extent_bit
> >>   btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit
> >>
> >>  fs/btrfs/ctree.h            |   8 +-
> >>  fs/btrfs/dev-replace.c      |   2 +-
> >>  fs/btrfs/disk-io.c          |  20 ++-
> >>  fs/btrfs/extent-tree.c      | 102 +++++--------
> >>  fs/btrfs/extent_io.c        | 103 +++++++++++++-
> >>  fs/btrfs/extent_io.h        |  19 ++-
> >>  fs/btrfs/extent_map.c       |  38 +++++
> >>  fs/btrfs/extent_map.h       |   1 -
> >>  fs/btrfs/free-space-cache.c |   4 -
> >>  fs/btrfs/transaction.c      |  51 +------
> >>  fs/btrfs/transaction.h      |   2 +-
> >>  fs/btrfs/volumes.c          | 277 ++++++++++++++---------------------=
-
> >>  fs/btrfs/volumes.h          |  23 ++-
> >>  13 files changed, 332 insertions(+), 318 deletions(-)
> >>
> >> --
> >> 2.17.1
> >>
> >



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
