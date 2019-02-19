Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038F0C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 11:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8866208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 11:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550577582;
	bh=xpXSuD3cygbzWTyMu6mr5AFzniPniYJqO/VQJQ+Ruac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WHuVEtXO954dlHCs2BrU5+Zr4LQOeGJ59Q1xAVNSUG2bFkRla9ba65JS6Oa8O3RtR
	 ShEadyy85u3tcQS8unxAVTEFcLEAdItaL2REUnYKE9lXtBQgyhlHFwxP/GcuML+2e/
	 HKU/hyM07U9a2vkZgAWPKzP4ZBt/Vmw9AwaPKNro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfBSL7l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 06:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfBSL7l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 06:59:41 -0500
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E60E7208E4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 11:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550577580;
        bh=xpXSuD3cygbzWTyMu6mr5AFzniPniYJqO/VQJQ+Ruac=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NMk82NqzBiIzUDrx30rPsIHiYZ1wY2ddHRmltf4bvGzO0y7sSUZuNc0+flzy239l+
         RTAy4XuV+VYtASRTf7LfL9AStoxWB/BnCBtnEZ79/nIhnZBfHdZzSWF4CvRoZIA6i1
         B8rZVHn4FPfGVE9+6eUHpOBrJVi8fHHazTKzyOgY=
Received: by mail-vs1-f43.google.com with SMTP id t13so11521756vsk.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 03:59:39 -0800 (PST)
X-Gm-Message-State: AHQUAuYCUJBr7lBvbg00lE+v5e2DwKM6IMzE/cMm4wk2RZF4+LMT/w6H
        H59GR1VVvximLOo0aA2Mkq4fmfqK580PxWFAwNc=
X-Google-Smtp-Source: AHgI3IYL7JqAhhryUyATqSRd2SKxydbP45iQD3YvMWbqYCWwm8iwcKwcL0Dbp9B6orny5Ye7BMIwy8nkO4SGB+MM/ow=
X-Received: by 2002:a67:8106:: with SMTP id c6mr12650387vsd.99.1550577579014;
 Tue, 19 Feb 2019 03:59:39 -0800 (PST)
MIME-Version: 1.0
References: <20190218165826.23549-1-fdmanana@kernel.org> <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
In-Reply-To: <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 19 Feb 2019 11:59:28 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>
Message-ID: <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: report and handle error on unexpected first
 key on extent buffer
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 12:54 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/2/19 =E4=B8=8A=E5=8D=8812:58, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When there is a kind of corruption in an extent buffer such that its fi=
rst
> > key does not match the key at the respective parent slot, one of two th=
ings
> > happens:
>
> Isn't that handled by read_tree_block() already?

It is, but only at the time we read a node/leaf from disk.
By doing the check here we can actually catch other types of bugs and
memory corruption.

To be honest I missed that since this is motivated by a report on
older kernel (SLE12 SP3).
So I still find it useful to have due to the reason pointed above,
however I'm not against simply removing the check from key_search().

> Thanks,
> Qu
>
> >
> > 1) When assertions are enabled, we effectively hit a BUG_ON() which
> >    requires rebooting the machine later. This also does not tell any
> >    information about which extent buffer is affected, from which root,
> >    the expected and found keys, etc.
> >
> > 2) When assertions are disabled, we just ignore the mismatch and assume
> >    everything is ok, which can potentially lead to all sorts of unexpec=
ted
> >    problems later after a tree search (in the worst case, could lead to
> >    further silent corruption).
> >
> > So improve this by always checking if the first key of an extent buffer=
 is
> > what it's supposed to be, when doing a key search at key_search(), and
> > report and return an appropriate error. The overhead is just comparing =
one
> > key, which is minimal and is anyway just done in a special case where w=
e
> > skip the more expensive binary search (the binary search in the parent
> > node returned 0, exact key match).
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/ctree.c | 38 +++++++++++++++++---------------------
> >  1 file changed, 17 insertions(+), 21 deletions(-)
> >
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 5b9f602fb9e2..a0bd0278208d 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -2529,35 +2529,31 @@ setup_nodes_for_search(struct btrfs_trans_handl=
e *trans,
> >       return ret;
> >  }
> >
> > -static void key_search_validate(struct extent_buffer *b,
> > -                             const struct btrfs_key *key,
> > -                             int level)
> > -{
> > -#ifdef CONFIG_BTRFS_ASSERT
> > -     struct btrfs_disk_key disk_key;
> > -
> > -     btrfs_cpu_key_to_disk(&disk_key, key);
> > -
> > -     if (level =3D=3D 0)
> > -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
> > -                 offsetof(struct btrfs_leaf, items[0].key),
> > -                 sizeof(disk_key)));
> > -     else
> > -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
> > -                 offsetof(struct btrfs_node, ptrs[0].key),
> > -                 sizeof(disk_key)));
> > -#endif
> > -}
> > -
> >  static int key_search(struct extent_buffer *b, const struct btrfs_key =
*key,
> >                     int level, int *prev_cmp, int *slot)
> >  {
> > +     struct btrfs_key found_key;
> > +
> >       if (*prev_cmp !=3D 0) {
> >               *prev_cmp =3D btrfs_bin_search(b, key, level, slot);
> >               return *prev_cmp;
> >       }
> >
> > -     key_search_validate(b, key, level);
> > +     if (level =3D=3D 0)
> > +             btrfs_item_key_to_cpu(b, &found_key, 0);
> > +     else
> > +             btrfs_node_key_to_cpu(b, &found_key, 0);
> > +
> > +     if (btrfs_comp_cpu_keys(&found_key, key) !=3D 0) {
> > +             btrfs_crit(b->fs_info,
> > +"unexpected first key for extent buffer: bytenr=3D%llu level=3D%d root=
=3D%llu expected key=3D(%llu %u %llu) found key=3D(%llu %u %llu)",
> > +                        btrfs_header_bytenr(b), level, btrfs_header_ow=
ner(b),
> > +                        key->objectid, key->type, key->offset,
> > +                        found_key.objectid, found_key.type,
> > +                        found_key.offset);
> > +             return -EUCLEAN;
> > +     }
> > +
> >       *slot =3D 0;
> >
> >       return 0;
> >
>
