Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D000DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 809092243E
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:28:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t88sD5MZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 809092243E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbeKNVba (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:31:30 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35000 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbeKNVb3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 16:31:29 -0500
Received: by mail-vs1-f68.google.com with SMTP id e7so9286845vsc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 03:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=xFGyRvgLYO38G20lmTVV2Ndpd7F6ekexR56UXI2ZU/Q=;
        b=t88sD5MZTAx2qqW7c+7q1R9EWyKebHaLVhwBFjtUoxIPLldyUoGP6VmYkhpm0U3s6h
         qdu1BT0BfoUntCElb11EZ8uGZP2ONUpB5rj71x9JseB32CrTQXhsfpwx/r/C2avPxt9f
         wJJbbbmyRTdHXTEFrcS4ULuyuX5b+9WQDTdmjZmLvMBsId3O1TXTJweokPf+LNEbnp2r
         QLaeQKsS9Zec2/eaIKVVaeXwbpCQ1GRmrs8VXJodWR9CYIKKu1c35ERHREmlNFAqmApO
         JjozcT9kyzXPNOECFeyhIK2goLuVR3aNFnTku4dxcBKkTTsNbyJQDDbvzqDiuBPmblHN
         VpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=xFGyRvgLYO38G20lmTVV2Ndpd7F6ekexR56UXI2ZU/Q=;
        b=fU629N6c9+fB2ByzTG8dMmEfmoSuESuu9JxSLogA7VHcKcsCWK+IKvFAcWrvoFN/jG
         gQrgIXxe1ffAB97ALBr1odD8EFMqOxfqNBhGWrb6ru1CRDOrb2CcEbFTzX7cJ4Z89lw9
         21yvDz4/8xnxTZ3vnR1y2tzzO7L+9jBKeWh/pG+NTAiD5NT0YbWRUt4KL182C8b4KHDO
         j7DMi1Ii93I3WYeTRP90XWw8PqujeyB2RquReWvfvcVlpyqYDB3ZgFDL3b/MIYl/Skt2
         Hk6w/AGe9yW3SKKF3NJhrziSGA9bany049XKt4pcg/zHTF/zcp5Diemy409khVZ8Awmn
         /9hg==
X-Gm-Message-State: AGRZ1gITJLbLMNiAsVFEnMbJQdS6iPtgl8cYjlNV6aqNNQX09WSma8vJ
        BD2DNeY7Uya3HnTislfY/oL4liqNnuw4WRHLeRDdHQ==
X-Google-Smtp-Source: AJdET5fq2XA74UydZGu6MV46BxsASlik7aXzLGR2jlONCwR6v6N7J7Fp7hMfWBE16kaRTp0uxFIWzVq/D2Dci5SAR1k=
X-Received: by 2002:a67:f114:: with SMTP id n20mr615432vsk.90.1542194917727;
 Wed, 14 Nov 2018 03:28:37 -0800 (PST)
MIME-Version: 1.0
References: <1542186768-22956-1-git-send-email-anand.jain@oracle.com>
 <1542186768-22956-2-git-send-email-anand.jain@oracle.com> <CAL3q7H5TuOHx+=-S+ieMBo7TKTUdHVjcjeo3u7SeicwfKnJp+w@mail.gmail.com>
In-Reply-To: <CAL3q7H5TuOHx+=-S+ieMBo7TKTUdHVjcjeo3u7SeicwfKnJp+w@mail.gmail.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 14 Nov 2018 11:28:26 +0000
Message-ID: <CAL3q7H7UYwz8GKqQ2DVXhZOG19Vq67QTMZrrWg1=gA+FeBNhcg@mail.gmail.com>
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 11:15 AM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Wed, Nov 14, 2018 at 9:14 AM Anand Jain <anand.jain@oracle.com> wrote:
> >
> > Support for a new command 'btrfs dev forget [dev]' is proposed here
> > to undo the effects of 'btrfs dev scan [dev]'. For this purpose
> > this patch proposes to use ioctl #5 as it was empty.
> >         IOW(BTRFS_IOCTL_MAGIC, 5, ..)
> > This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
> > the /dev/btrfs-control to forget one or all devices, (devices which are
> > not mounted) from the btrfs kernel.
> >
> > The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
> > set to specify the device path. And all unmounted devices can be remove=
d
> > from the kernel if no device path is provided.
> >
> > Again, the devices are removed only if the relevant fsid aren't mounted=
.
> >
> > This new cli can provide..
> >  . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
> >    device is not going to be mounted.
> >  . Ability to mount the device in degraded mode when one of the other
> >    device is corrupted like in split brain raid1.
> >  . Running test cases which requires btrfs.ko-reload if the rootfs
> >    is btrfs.
> >
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >  fs/btrfs/super.c           | 3 +++
> >  fs/btrfs/volumes.c         | 9 +++++++++
> >  fs/btrfs/volumes.h         | 1 +
> >  include/uapi/linux/btrfs.h | 2 ++
> >  4 files changed, 15 insertions(+)
> >
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index 345c64d810d4..f99db6899004 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -2246,6 +2246,9 @@ static long btrfs_control_ioctl(struct file *file=
, unsigned int cmd,
> >                 ret =3D PTR_ERR_OR_ZERO(device);
> >                 mutex_unlock(&uuid_mutex);
> >                 break;
> > +       case BTRFS_IOC_FORGET_DEV:
> > +               ret =3D btrfs_forget_devices(vol->name);
> > +               break;
> >         case BTRFS_IOC_DEVICES_READY:
> >                 mutex_lock(&uuid_mutex);
> >                 device =3D btrfs_scan_one_device(vol->name, FMODE_READ,
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index f435d397019e..e1365a122657 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_de=
vice *bdev, u64 bytenr,
> >         return 0;
> >  }
> >
> > +int btrfs_forget_devices(const char *path)
> > +{
> > +       mutex_lock(&uuid_mutex);
> > +       btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);
>
> One space before : and another one after it please.
>
> Now the more important: don't use strlen, use strnlen. Some malicious
> or sloppy user might have passed a non-null terminated string, you
> don't want strlen to go past the limits of btrfs_ioctl_vol_args for
> obvious reasons.

In fact that's a problem for the entire use of vol->name in
btrfs_control_ioctl. The name's last byte should be set to '\0' to
avoid issues.
I'll send a fix for that, so if David fixes the white spaces on commit
there's no need for a v12.

>
> Also, please, not just to make a maintainer's life easier, but current
> and future reviewers, add the patch version to each patch's subject
> and not just the cover letter. Also list (after ---) what changes
> between each patch version in the patch itself and not the cover
> letter.
>
> V12, here we go.
>
> > +       mutex_unlock(&uuid_mutex);
> > +
> > +       return 0;
> > +}
> > +
> >  /*
> >   * Look for a btrfs signature on a device. This may be called out of t=
he mount path
> >   * and we are not allowed to call set_blocksize during the scan. The s=
uperblock
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index aefce895e994..180297d04938 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_=
devices,
> >                        fmode_t flags, void *holder);
> >  struct btrfs_device *btrfs_scan_one_device(const char *path,
> >                                            fmode_t flags, void *holder)=
;
> > +int btrfs_forget_devices(const char *path);
> >  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
> >  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int =
step);
> >  void btrfs_assign_next_active_device(struct btrfs_device *device,
> > diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> > index 5ca1d21fc4a7..b1be7f828cb4 100644
> > --- a/include/uapi/linux/btrfs.h
> > +++ b/include/uapi/linux/btrfs.h
> > @@ -836,6 +836,8 @@ enum btrfs_err_code {
> >                                    struct btrfs_ioctl_vol_args)
> >  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
> >                                    struct btrfs_ioctl_vol_args)
> > +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> > +                                  struct btrfs_ioctl_vol_args)
> >  /* trans start and trans end are dangerous, and only for
> >   * use by applications that know how to avoid the
> >   * resulting deadlocks
> > --
> > 1.8.3.1
> >
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
