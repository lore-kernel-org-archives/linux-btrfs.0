Return-Path: <SRS0=SsiO=NT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641ACECDE4B
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C5E92081D
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Nov 2018 14:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="poi4oseV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C5E92081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbeKIANK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbeKIANK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Nov 2018 19:13:10 -0500
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F20812081D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Nov 2018 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541687843;
        bh=9RG1+zLPi7SPma6ln2KSk0e3LnN4/Nn1YxuF+tKi57A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=poi4oseVTatY2kbkbuq45MdTHBzQiNtcqgbC7iBI4w6I6LBzW4kjWGwSNi9Gcj0Xo
         vseTC5duyiUO9e40kIBgbaiMPhI5g4PoU++HAW+JXamvkzr/hs6aGy1NuUYRLh9gao
         mPPdVRc/HInSPo8ZNsV4TPuhvCcKeFOxGR/0Jwoc=
Received: by mail-ua1-f51.google.com with SMTP id d19so5971107uaq.11
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Nov 2018 06:37:22 -0800 (PST)
X-Gm-Message-State: AGRZ1gLGPIhKytJ3uDaySLTubgrqIaKhG+vAfdYsKdV3XPoKnxqBcur+
        u+o4TnL6bsHwR8Ft79tfEFdddRvXtiEzniZHeu8=
X-Google-Smtp-Source: AJdET5d0gYDQN5ER32A6tpF2dK42QJOwDfXeT7ytEVqij4Z5Bz8GPEOTeu70AI4HRShyLuY6uCDToQ3Hp5h0+35Flno=
X-Received: by 2002:ab0:621a:: with SMTP id m26mr1965096uao.36.1541687841983;
 Thu, 08 Nov 2018 06:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20181108131750.27833-1-fdmanana@kernel.org> <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
In-Reply-To: <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Nov 2018 14:37:10 +0000
X-Gmail-Original-Message-ID: <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
Message-ID: <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
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

On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When creating a block group we don't need to set the log for full commi=
t
> > if the new block group is not used for data. Logged items can only poin=
t
> > to logical addresses of data block groups (through file extent items) s=
o
> > there is no need to for the next fsync to fallback to a transaction com=
mit
> > if the new block group is for metadata.
>
> Is it possible for the log tree blocks to be allocated in that new block
> group?

Yes.

>
> Thanks,
> Qu
>
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/extent-tree.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 577878324799..588fbd1606fb 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_trans_h=
andle *trans, u64 bytes_used,
> >       struct btrfs_block_group_cache *cache;
> >       int ret;
> >
> > -     btrfs_set_log_full_commit(fs_info, trans);
> > +     if (type & BTRFS_BLOCK_GROUP_DATA)
> > +             btrfs_set_log_full_commit(fs_info, trans);
> >
> >       cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset, s=
ize);
> >       if (!cache)
> >
>
