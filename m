Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D076C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67A96217F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545038698;
	bh=Mnb3rVPlVfEcy/1J4SFXmCZHhF+CYLy0ocoVp/1RDMM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=c4NpIm+Ve3OqyCkjgcz8/Z8r6oUqjFxYwGb6d33t38JOivgYuIb8QZNZEXshidVpc
	 6h7WZrf6ig7u/9X/74IgeeZcJlYmLymptd/Lhn6nTGod6Ufd7GfB/tsDfkT8w9oWhU
	 4oLuYwK0u89AQDS3NcYps9bpYlJNfsvPupoNKiBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbeLQJY5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbeLQJY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 04:24:57 -0500
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DE5217F4
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 09:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545038696;
        bh=Mnb3rVPlVfEcy/1J4SFXmCZHhF+CYLy0ocoVp/1RDMM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0/4HZTza/uUxNNpXlTORvLUP6Z1xkX29R69Rbq5C7IITyQdz9DTcKl4/kS3uAJTEB
         NbIdeEvfrz5JMj8qJmPzvjHvtbrF9brOBqlm49Byzr+RIeBES1G0SH3Pf2p9IgaY/k
         ZzgezTiWNcsZrfA9QFVS9vzNoJogE0uzst1gtOjU=
Received: by mail-ua1-f53.google.com with SMTP id z11so4168260uaa.10
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 01:24:55 -0800 (PST)
X-Gm-Message-State: AA+aEWY7vmz2e2Gg2RmBhnqv4L3r9DS4Sm+LgVnZyj4tiL+LYVnfg/QZ
        JYhxAEHlRaWy88WT9MzwriejjX/DzZgEuadReT4=
X-Google-Smtp-Source: AFSGD/VXFNsc7BWrrWDw52xuCqUwodYWv1TuYsuwmdRC7WLbRs7XdyqPoNv4YB/x4JyBO8F7FFdls/ed1oCPtrFIOo0=
X-Received: by 2002:ab0:3259:: with SMTP id r25mr5587362uan.108.1545038695114;
 Mon, 17 Dec 2018 01:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20181214194541.21891-1-fdmanana@kernel.org> <9c378108-591d-e275-8898-3c67d97156fa@oracle.com>
In-Reply-To: <9c378108-591d-e275-8898-3c67d97156fa@oracle.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 17 Dec 2018 09:24:43 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6NEJiAW8RYRdt8f3svhE3wZg92FoQH+bzFo2aE9ozKPA@mail.gmail.com>
Message-ID: <CAL3q7H6NEJiAW8RYRdt8f3svhE3wZg92FoQH+bzFo2aE9ozKPA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not overwrite error return value in the balance ioctl
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 17, 2018 at 8:25 AM Anand Jain <anand.jain@oracle.com> wrote:
>
>
>
> On 12/15/2018 03:45 AM, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > If the call to btrfs_balance() failed we would overwrite the error
> > returned to user space with -EFAULT if the call to copy_to_user() failed
> > as well. Fix that by calling copy_to_user() only if btrfs_balance()
> > returned success.
> >
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >   fs/btrfs/ioctl.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index abe45fd97ab5..4ad7288f77d0 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -4707,7 +4707,7 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
> >       ret = btrfs_balance(fs_info, bctl, bargs);
> >       bctl = NULL;
> >
> > -     if (arg) {
> > +     if (ret == 0 && arg) {
> >               if (copy_to_user(arg, bargs, sizeof(*bargs)))
> >                       ret = -EFAULT;
> >       }
> >
>
> This changes the BTRFS_IOC_BALANCE_V2 semantics.
>
> Originally, if BTRFS_IOC_BALANCE_V2 is failed/canceled we do update
> bargs [1] and copy to user land, but after this patch we copy only
> if the ioctl is successful. I doubt if David is OK with that.

I thought about that. But that logic, if it's really in use by someone
(something) out there then they must be treating -EFAULT differently
from any other error.
Because if copy_to_user() fails it means it didn't copy all bytes it
was so supposed to (its return value is number of bytes not copied),
so the arguments structure ends up in an inconsistent state.


>
> [1]
> ----------
> 3717 int btrfs_balance(struct btrfs_fs_info *fs_info,
> 3718                   struct btrfs_balance_control *bctl,
> 3719                   struct btrfs_ioctl_balance_args *bargs)
> 3720 {
> ::
>
> 3855         ret = __btrfs_balance(fs_info);
> 3856
> 3857         mutex_lock(&fs_info->balance_mutex);
> 3858         clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
> 3859
> 3860         if (bargs) {
> 3861                 memset(bargs, 0, sizeof(*bargs));
> 3862                 btrfs_update_ioctl_balance_args(fs_info, bargs);
> 3863         }
>
