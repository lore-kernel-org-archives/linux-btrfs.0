Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5801EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 260FC217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550510134;
	bh=F8GQ3/1hbn6GcuqXm62IWllz8mBEsZPR1RX2YB9husQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EdGtXMOJWlRJINv0aUwRnMESKB0lelIQeeD7j//5urlH8SgH3AtCtUcr582x4YSuB
	 8cz3Fr4pC1CLSfcVsC82AIlvdqyWe0eR0noM8jIT0nUP6nwxM2+iPAH12UaS51O9Xu
	 NB1DOE9B71xdHB24YJSe+kPKJMqKU3JZL6IVK500=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbfBRRPc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 12:15:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731396AbfBRRPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 12:15:32 -0500
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0587E217D9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550510131;
        bh=F8GQ3/1hbn6GcuqXm62IWllz8mBEsZPR1RX2YB9husQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xvoPl0ulJL4Wrf10vgoPUSHX+CH5fYjny64QL9/wRCY5RS2mLpQ/fG2DvG8iC5hdH
         OfEC/CokiuOAhE9EUGDv6ld+nnKqWDHy1hh3RUCJwYtkdyrhWmN4tZbB0rBIqh0eIC
         uRrdU0zrljv388ovNQJkMv7rg/RCYAsWz4VpD/78=
Received: by mail-vs1-f54.google.com with SMTP id z18so10081041vso.7
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 09:15:30 -0800 (PST)
X-Gm-Message-State: AHQUAub8NI7MtSJaEjw2fCLMqw3sNYPAeW8GJsTQKUGU4KyMh3WL6on0
        sNYByL2RyNJC25MwvcfvVfE0TaCyoNY+JxQ92/M=
X-Google-Smtp-Source: AHgI3Ib5IZWTmR95bcNQPoUXW2/thn+8OioR46/snnzuYEI/Q+k9qcccepFpVW4/L1Kt6pDd+paOd5ciJOL6lBCjrC4=
X-Received: by 2002:a67:8106:: with SMTP id c6mr10820138vsd.99.1550510130154;
 Mon, 18 Feb 2019 09:15:30 -0800 (PST)
MIME-Version: 1.0
References: <20190218165726.22884-1-fdmanana@kernel.org> <20190218170730.19965-1-fdmanana@kernel.org>
 <58076ee3-c636-698f-9499-7b18d78ab241@suse.com>
In-Reply-To: <58076ee3-c636-698f-9499-7b18d78ab241@suse.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 18 Feb 2019 17:15:19 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5UW8Au2ddp3WLPaQw19aYWnwDbB0jCo1rwtncTtsHKCA@mail.gmail.com>
Message-ID: <CAL3q7H5UW8Au2ddp3WLPaQw19aYWnwDbB0jCo1rwtncTtsHKCA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Btrfs: add missing error handling after doing
 leaf/node binary search
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 5:11 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
>
>
> On 18.02.19 =D0=B3. 19:07 =D1=87., fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > The function map_private_extent_buffer() can return an -EINVAL error, a=
nd
> > it is called by generic_bin_search() which will return back the error. =
The
> > btrfs_bin_search() function in turn calls generic_bin_search() and the
> > key_search() function calls btrfs_bin_search(), so both can return the
> > -EINVAL error coming from the map_private_extent_buffer() function. Som=
e
> > callers of these functions were ignoring that these functions can retur=
n
> > an error, so fix them to deal with error return values.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
> > ---
> >
> > V2: Fixed error handling in relocation, missed assignment of ret to err=
.
> >
> >  fs/btrfs/ctree.c      |  6 ++++++
> >  fs/btrfs/relocation.c | 10 ++++++++++
> >  fs/btrfs/tree-log.c   |  2 ++
> >  3 files changed, 18 insertions(+)
> >
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 5a6c39b44c84..5b9f602fb9e2 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -3005,6 +3005,8 @@ int btrfs_search_old_slot(struct btrfs_root *root=
, const struct btrfs_key *key,
> >                */
> >               prev_cmp =3D -1;
> >               ret =3D key_search(b, key, level, &prev_cmp, &slot);
> > +             if (ret < 0)
> > +                     goto done;
> >
> >               if (level !=3D 0) {
> >                       int dec =3D 0;
> > @@ -5156,6 +5158,10 @@ int btrfs_search_forward(struct btrfs_root *root=
, struct btrfs_key *min_key,
> >               nritems =3D btrfs_header_nritems(cur);
> >               level =3D btrfs_header_level(cur);
> >               sret =3D btrfs_bin_search(cur, min_key, level, &slot);
> > +             if (sret < 0) {
> > +                     ret =3D sret;
> > +                     goto out;
> > +             }>
> >               /* at the lowest level, we're done, setup the path and ex=
it */
> >               if (level =3D=3D path->lowest_level) {
> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> > index 272b287f8cf0..628ba528516d 100644
> > --- a/fs/btrfs/relocation.c
> > +++ b/fs/btrfs/relocation.c
> > @@ -1802,6 +1802,8 @@ int replace_path(struct btrfs_trans_handle *trans=
, struct reloc_control *rc,
> >               BUG_ON(level < lowest_level);
> >
> >               ret =3D btrfs_bin_search(parent, &key, level, &slot);
> > +             if (ret < 0)
> > +                     break;
> >               if (ret && slot > 0)
> >                       slot--;
> >
> > @@ -2685,6 +2687,10 @@ static int do_relocation(struct btrfs_trans_hand=
le *trans,
> >                       if (!lowest) {
> >                               ret =3D btrfs_bin_search(upper->eb, key,
> >                                                      upper->level, &slo=
t);
> > +                             if (ret < 0) {
> > +                                     err =3D ret;
> > +                                     goto next;
> > +                             }
> >                               BUG_ON(ret);
> >                               bytenr =3D btrfs_node_blockptr(upper->eb,=
 slot);
> >                               if (node->eb->start =3D=3D bytenr)
> > @@ -2720,6 +2726,10 @@ static int do_relocation(struct btrfs_trans_hand=
le *trans,
> >               } else {
> >                       ret =3D btrfs_bin_search(upper->eb, key, upper->l=
evel,
> >                                              &slot);
> > +                     if (ret < 0) {
> > +                             err =3D ret;
> > +                             goto next;
> > +                     }
> >                       BUG_ON(ret);
>
> Ideally those BUG_ON should disappear and be replaced with, perhahps
> -EUCLEAN or somesuch?

Different problem. Those assert the impossibility of the search
returning 1 (key not found), which would happen due to a relocation
algorithm flaw.
I'm dealing with missing error handling only, therefore won't do such
thing in this patch.

>
> >               }
> >
> > diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> > index 8c9e87f5ec58..81a357a32837 100644
> > --- a/fs/btrfs/tree-log.c
> > +++ b/fs/btrfs/tree-log.c
> > @@ -3772,6 +3772,8 @@ static int drop_objectid_items(struct btrfs_trans=
_handle *trans,
> >               found_key.type =3D 0;
> >               ret =3D btrfs_bin_search(path->nodes[0], &found_key, 0,
> >                                      &start_slot);
> > +             if (ret < 0)
> > +                     break;
> >
> >               ret =3D btrfs_del_items(trans, log, path, start_slot,
> >                                     path->slots[0] - start_slot + 1);
> >
