Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8929C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60AE2087B
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550661178;
	bh=mtAtdbGtxCzPvpBxwqmlpGaoiAUZ+GpfvEwSjCCN4cQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=fSgpJ27bHR15j/J4mb2fqL3bCuSmhB24wozaijieOHCaIUa/+hfZY20xQPhFja1OT
	 kFhiJ3LuMDDKipQUc49gWUfSO11BIay4r7ijNIlzuh1utkGDNGJ/N/xkfSjomYxhsv
	 78yaz/iXvU/gQo5FZQpegvFT8ZU8bUGKF8KB6pmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfBTLM5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbfBTLM4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 06:12:56 -0500
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1800B2087B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 11:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550661175;
        bh=mtAtdbGtxCzPvpBxwqmlpGaoiAUZ+GpfvEwSjCCN4cQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uDSMAwPFRXkPE94cBiQvNZm4URMztJoTP3cE9MDeeI9fPNhT8ZsbpP3EQbcsT+t5O
         E8vcvG+lZjghOT9eiuVoFYEek+6TKLej9JFlVaBGjk/F30/jlvbWx+xI9ZO+/jmYzM
         avizLbI3JZUxfTUQ2z5TcbGDUVn+qqA5vJvXu/tY=
Received: by mail-vs1-f42.google.com with SMTP id y19so427579vsc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2019 03:12:55 -0800 (PST)
X-Gm-Message-State: AHQUAuYb5FxCRTuE/BcslLbDGaudWU7xSSxn80spEhEja0dQGEAzYmCD
        Z/59I93ezBWfK/tusXc1+KZwSCyXhBxiX6l8z3w=
X-Google-Smtp-Source: AHgI3Ia+d8kPoQEwO8fId9bdnOcKsSf2EdobG2kcxOqJ25NRtfaDZCmRN0Dyok7lz12fwv4WtQ53+15pTm1ZyLyXgQk=
X-Received: by 2002:a67:8106:: with SMTP id c6mr15224754vsd.99.1550661174190;
 Wed, 20 Feb 2019 03:12:54 -0800 (PST)
MIME-Version: 1.0
References: <20190218165826.23549-1-fdmanana@kernel.org> <a79f6d14-88bd-5a58-a508-8683428ad12f@gmx.com>
 <CAL3q7H4TVnHhd3vjZKt26SyQNxgZO94yfQLoBdWZumhLSQ43qg@mail.gmail.com> <19a9bca8-1861-ba0e-c495-3817ea051877@gmx.com>
In-Reply-To: <19a9bca8-1861-ba0e-c495-3817ea051877@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Wed, 20 Feb 2019 11:12:43 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5BqLpuJNkCHziVPWetFgzLiWiPT4Le5yP9mdFfBefUuQ@mail.gmail.com>
Message-ID: <CAL3q7H5BqLpuJNkCHziVPWetFgzLiWiPT4Le5yP9mdFfBefUuQ@mail.gmail.com>
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

On Tue, Feb 19, 2019 at 12:26 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/2/19 =E4=B8=8B=E5=8D=887:59, Filipe Manana wrote:
> > On Tue, Feb 19, 2019 at 12:54 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
> >>
> >>
> >>
> >> On 2019/2/19 =E4=B8=8A=E5=8D=8812:58, fdmanana@kernel.org wrote:
> >>> From: Filipe Manana <fdmanana@suse.com>
> >>>
> >>> When there is a kind of corruption in an extent buffer such that its =
first
> >>> key does not match the key at the respective parent slot, one of two =
things
> >>> happens:
> >>
> >> Isn't that handled by read_tree_block() already?
> >
> > It is, but only at the time we read a node/leaf from disk.
> > By doing the check here we can actually catch other types of bugs and
> > memory corruption.
>
> Although when memory corruption happens it's more concerning than
> mismatch keys.
>
> >
> > To be honest I missed that since this is motivated by a report on
> > older kernel (SLE12 SP3).
> > So I still find it useful to have due to the reason pointed above,
> > however I'm not against simply removing the check from key_search().
>
> Removing the check looks good to me.
> Especially since we're going to have mandatory write time tree checker,
> it should be mostly fine.

Looks reasonable.
Sent as https://patchwork.kernel.org/patch/10821851/ and replaces the
patch from this thread.

>
> Thanks,
> Qu
>
> >
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> 1) When assertions are enabled, we effectively hit a BUG_ON() which
> >>>    requires rebooting the machine later. This also does not tell any
> >>>    information about which extent buffer is affected, from which root=
,
> >>>    the expected and found keys, etc.
> >>>
> >>> 2) When assertions are disabled, we just ignore the mismatch and assu=
me
> >>>    everything is ok, which can potentially lead to all sorts of unexp=
ected
> >>>    problems later after a tree search (in the worst case, could lead =
to
> >>>    further silent corruption).
> >>>
> >>> So improve this by always checking if the first key of an extent buff=
er is
> >>> what it's supposed to be, when doing a key search at key_search(), an=
d
> >>> report and return an appropriate error. The overhead is just comparin=
g one
> >>> key, which is minimal and is anyway just done in a special case where=
 we
> >>> skip the more expensive binary search (the binary search in the paren=
t
> >>> node returned 0, exact key match).
> >>>
> >>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >>> ---
> >>>  fs/btrfs/ctree.c | 38 +++++++++++++++++---------------------
> >>>  1 file changed, 17 insertions(+), 21 deletions(-)
> >>>
> >>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> >>> index 5b9f602fb9e2..a0bd0278208d 100644
> >>> --- a/fs/btrfs/ctree.c
> >>> +++ b/fs/btrfs/ctree.c
> >>> @@ -2529,35 +2529,31 @@ setup_nodes_for_search(struct btrfs_trans_han=
dle *trans,
> >>>       return ret;
> >>>  }
> >>>
> >>> -static void key_search_validate(struct extent_buffer *b,
> >>> -                             const struct btrfs_key *key,
> >>> -                             int level)
> >>> -{
> >>> -#ifdef CONFIG_BTRFS_ASSERT
> >>> -     struct btrfs_disk_key disk_key;
> >>> -
> >>> -     btrfs_cpu_key_to_disk(&disk_key, key);
> >>> -
> >>> -     if (level =3D=3D 0)
> >>> -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
> >>> -                 offsetof(struct btrfs_leaf, items[0].key),
> >>> -                 sizeof(disk_key)));
> >>> -     else
> >>> -             ASSERT(!memcmp_extent_buffer(b, &disk_key,
> >>> -                 offsetof(struct btrfs_node, ptrs[0].key),
> >>> -                 sizeof(disk_key)));
> >>> -#endif
> >>> -}
> >>> -
> >>>  static int key_search(struct extent_buffer *b, const struct btrfs_ke=
y *key,
> >>>                     int level, int *prev_cmp, int *slot)
> >>>  {
> >>> +     struct btrfs_key found_key;
> >>> +
> >>>       if (*prev_cmp !=3D 0) {
> >>>               *prev_cmp =3D btrfs_bin_search(b, key, level, slot);
> >>>               return *prev_cmp;
> >>>       }
> >>>
> >>> -     key_search_validate(b, key, level);
> >>> +     if (level =3D=3D 0)
> >>> +             btrfs_item_key_to_cpu(b, &found_key, 0);
> >>> +     else
> >>> +             btrfs_node_key_to_cpu(b, &found_key, 0);
> >>> +
> >>> +     if (btrfs_comp_cpu_keys(&found_key, key) !=3D 0) {
> >>> +             btrfs_crit(b->fs_info,
> >>> +"unexpected first key for extent buffer: bytenr=3D%llu level=3D%d ro=
ot=3D%llu expected key=3D(%llu %u %llu) found key=3D(%llu %u %llu)",
> >>> +                        btrfs_header_bytenr(b), level, btrfs_header_=
owner(b),
> >>> +                        key->objectid, key->type, key->offset,
> >>> +                        found_key.objectid, found_key.type,
> >>> +                        found_key.offset);
> >>> +             return -EUCLEAN;
> >>> +     }
> >>> +
> >>>       *slot =3D 0;
> >>>
> >>>       return 0;
> >>>
> >>
>
