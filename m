Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715B7C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 454E520869
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549994343;
	bh=MHg3bo0zCS9Kzdcx9fJ8purMewZ9dzNHkBlRJrdG1Co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=z0Ni4bBtpXuOrSMhmonuvIU58JlQa22D7fzeKwiB+oslqDCisupDZ3YV2pGLh/SRO
	 KpCBYi5LmpexpIksDbleXuY7saK4L7axrLl8fgirPjgKOpx3Ac6Dl3/7yDE6Vewkx+
	 HCy5RIzblw6iKxfqE1/9DfwANPAQLHFY3I6O+eKk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfBLR7B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbfBLR7B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 12:59:01 -0500
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1442F20869
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549994340;
        bh=MHg3bo0zCS9Kzdcx9fJ8purMewZ9dzNHkBlRJrdG1Co=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jn4bVpXy/aqHdqulErIfKKM1svGL5yVTz+ATbXX3dxFVaiGhQJ49NrfBm6wha+mHP
         iGrRsz5tuyR+iSC+ypRC5sMud/7p1YvdJQ8/QfRcJWcvUNZD889HIhYrqYeGHcv0vm
         LamS6KOcamACdOjIU7pwBL+yBLUiVELGXZhNATYo=
Received: by mail-vs1-f54.google.com with SMTP id x1so2129371vsc.10
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 09:59:00 -0800 (PST)
X-Gm-Message-State: AHQUAuaE0Hwnwm6zaoDzgXv77LPUSTiP3JAKElYnXc5tdamQTIbFFaEj
        Jy7CIlrX8O1ShAf5tLNt5ma0CDcpQiHImZk9zuA=
X-Google-Smtp-Source: AHgI3IaSwVNnileAATa4gW/ihf+X3MRcBX4k8Kd3Wj2vT2bGgJC6NslBLmbOdpmSVmPUh5Djo+S4I5FPzLOMziJ77Vo=
X-Received: by 2002:a67:8106:: with SMTP id c6mr1704506vsd.99.1549994339188;
 Tue, 12 Feb 2019 09:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-5-fdmanana@kernel.org>
 <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
In-Reply-To: <CAL3q7H55XWqvr2DA_BbqZtva_01iqVD19fkRZFLe14cVTyEY8Q@mail.gmail.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Tue, 12 Feb 2019 17:58:48 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7S_C2PWdYF2b7nLQQMvJjdnNRuJVC4mWW2mun56s-4sQ@mail.gmail.com>
Message-ID: <CAL3q7H7S_C2PWdYF2b7nLQQMvJjdnNRuJVC4mWW2mun56s-4sQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] Btrfs: remove no longer needed range length checks
 for deduplication
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 4:31 PM Filipe Manana <fdmanana@kernel.org> wrote:
>
> On Wed, Dec 12, 2018 at 6:07 PM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Comparing the content of the pages in the range to deduplicate is now done
> > by the generic helper generic_remap_file_range_prep(), which takes care of
> > ensuring we do not compare/deduplicate undefined data beyond a file's eof
> > (range from eof to the next block boundary). So remove these checks which
> > are now redundant.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
>
> Any reason why this was not yet picked?
> Thanks.

Another ping. Thanks.

>
> > ---
> >  fs/btrfs/ioctl.c | 19 ++-----------------
> >  1 file changed, 2 insertions(+), 17 deletions(-)
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 4e9efc93340e..3a27efa2b955 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3206,31 +3206,16 @@ static void btrfs_double_inode_lock(struct inode *inode1, struct inode *inode2)
> >         inode_lock_nested(inode2, I_MUTEX_CHILD);
> >  }
> >
> > -static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 olen,
> > +static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
> >                                    struct inode *dst, u64 dst_loff)
> >  {
> > -       u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> >         int ret;
> > -       u64 len = olen;
> > -
> > -       if (loff + len == src->i_size)
> > -               len = ALIGN(src->i_size, bs) - loff;
> > -       /*
> > -        * For same inode case we don't want our length pushed out past i_size
> > -        * as comparing that data range makes no sense.
> > -        *
> > -        * This effectively means we require aligned extents for the single
> > -        * inode case, whereas the other cases allow an unaligned length so long
> > -        * as it ends at i_size.
> > -        */
> > -       if (dst == src && len != olen)
> > -               return -EINVAL;
> >
> >         /*
> >          * Lock destination range to serialize with concurrent readpages().
> >          */
> >         lock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
> > -       ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> > +       ret = btrfs_clone(src, dst, loff, len, len, dst_loff, 1);
> >         unlock_extent(&BTRFS_I(dst)->io_tree, dst_loff, dst_loff + len - 1);
> >
> >         return ret;
> > --
> > 2.11.0
> >
