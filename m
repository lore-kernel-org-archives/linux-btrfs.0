Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309B1ECDE47
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC0D12081D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0VqagxQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC0D12081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbeKIAYd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbeKIAYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 19:24:32 -0500
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3A92081D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541688522;
        bh=v5Q5dPQHjoq4z118H65mi7hmGAktKk2ygr5EBz1tZ1c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O0VqagxQnTgyBjbGSJ+RA5Q0rFrvfxRkrgvuDuCp4tJdXwBuTjU/+uoNiFIFkdab1
         Mylga3k2kqLQ8qYX8HhwwAngHevG0M9q5Te8ih+8QCytw5+IUSC+VA+ELrvTzTVtlO
         6ZvXhXI6Mp4eMa93fOWRYGvUpDy6Dtc0KiUekywo=
Received: by mail-vs1-f53.google.com with SMTP id t17so11711050vsc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 06:48:42 -0800 (PST)
X-Gm-Message-State: AGRZ1gI1crNEf755Z21rg6HtckOTw5wwW7SoTLrLSaRmKLHneDRg6dHb
        svgczGSXXkklShhffzEu71zraD3NCc510sQI9p8=
X-Google-Smtp-Source: AJdET5dyUOZ8S5T0GJdRFGvR8JBYsbbAbhoe22mPidsrGLs9t72XOfypBcL2TfKBpUbUyqF22qxUhqtc2hT04/tnMEE=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr2024386vsa.14.1541688521092;
 Thu, 08 Nov 2018 06:48:41 -0800 (PST)
MIME-Version: 1.0
References: <20181108131750.27833-1-fdmanana@kernel.org> <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
In-Reply-To: <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Nov 2018 14:48:29 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
Message-ID: <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> >
> >
> > On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > When creating a block group we don't need to set the log for full com=
mit
> > > if the new block group is not used for data. Logged items can only po=
int
> > > to logical addresses of data block groups (through file extent items)=
 so
> > > there is no need to for the next fsync to fallback to a transaction c=
ommit
> > > if the new block group is for metadata.
> >
> > Is it possible for the log tree blocks to be allocated in that new bloc=
k
> > group?
>
> Yes.

Now I realize what might be your concern, and this would cause trouble.
Surprised this didn't trigger any problem and I had this (together
with other changes) running tests for some weeks already.

>
> >
> > Thanks,
> > Qu
> >
> > >
> > > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index 577878324799..588fbd1606fb 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_trans=
_handle *trans, u64 bytes_used,
> > >       struct btrfs_block_group_cache *cache;
> > >       int ret;
> > >
> > > -     btrfs_set_log_full_commit(fs_info, trans);
> > > +     if (type & BTRFS_BLOCK_GROUP_DATA)
> > > +             btrfs_set_log_full_commit(fs_info, trans);
> > >
> > >       cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset,=
 size);
> > >       if (!cache)
> > >
> >
