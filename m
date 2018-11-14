Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFD5C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 724AA223DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 11:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jj5wwc0K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 724AA223DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbeKNVSV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:18:21 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:43363 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbeKNVSV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 16:18:21 -0500
Received: by mail-vs1-f66.google.com with SMTP id x1so9230185vsc.10
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 03:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=A0aa7CAgoOKUzPvnj1nBh9s0qomrIpbaFsWee+gUSc4=;
        b=Jj5wwc0K15IETGDTmvzkgjcEhNu8dwtM3lem/p5yrNmjLojjKL8Q11grzlfxRgn4CH
         SaKJi9NLSgVYMwzbIpUyOlBOnqzI71DJNmVfebPciJDzTq3QPma8THVm07gjR0P9l0t3
         4inUhzbBuzX183KYYUD8iaJ1tDAcDClsiNbunHsyi1VY8BVLL79augD/l+Muc2Gh1cln
         XcaD7NMcwgnDfWfU/3Z1VUAUxKElLZqjt0VilRjCpBRFW2HqobT0r5G8b5HKMRmEjKZV
         DuM6A0NtNogU/JTw0B4hwmJlWe7bMbl3LUAhrIWSNVDAhk50VkqUtf81sPdSJ36tsHZB
         3IUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=A0aa7CAgoOKUzPvnj1nBh9s0qomrIpbaFsWee+gUSc4=;
        b=B31E7qarDUjDUByB0kOrj7x5VfNsZ8o8n0b6Uv2gRtjC6UCPfIkbB1FPzRnkXXfte1
         4aRpgMC9b1MwHvVSjudQE6oqNwdMhYNsKupVW0n186sj9m2ZmQLdKQ15Yz7vYfGDdLsH
         wKQs4E+vBvXV62SjqGcN6VfjPh8WMv58CqD87n4uRgd5LwlyeEmXvHDu71H4Md6KPW9Z
         1tBG5hLJJFt3tWpHl1nVyFAoLV28S7lPxQTBeC0hkGjAwqYm2c2ze5wZEa9CCw1C/7dk
         q5/OWIPmYbRPN7rE31VhpKyTSNP15UE2JdlGeYdRZdv8AJinl1u00zHtFSpZFTnoJ1dr
         SfiQ==
X-Gm-Message-State: AGRZ1gJgngRCtNccdqMgwvPuJm7OQzA6zPZgwGIp22KqhJ4BaPEHPPTc
        k/Y7VYbvUvN1ShhGfBDm+NUPI6nGqjvJiYVY5KTyITdo
X-Google-Smtp-Source: AJdET5fGZa8MDA8zysFLmZEySyc9MK9sDiUi4FVE1Tzyj3SLuRXqHvhAVYgDa1nOp2RaQDNN8MP1KaqE0deJazFepI0=
X-Received: by 2002:a67:e34e:: with SMTP id s14mr570622vsm.95.1542194131314;
 Wed, 14 Nov 2018 03:15:31 -0800 (PST)
MIME-Version: 1.0
References: <1542186768-22956-1-git-send-email-anand.jain@oracle.com> <1542186768-22956-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1542186768-22956-2-git-send-email-anand.jain@oracle.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 14 Nov 2018 11:15:19 +0000
Message-ID: <CAL3q7H5TuOHx+=-S+ieMBo7TKTUdHVjcjeo3u7SeicwfKnJp+w@mail.gmail.com>
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 9:14 AM Anand Jain <anand.jain@oracle.com> wrote:
>
> Support for a new command 'btrfs dev forget [dev]' is proposed here
> to undo the effects of 'btrfs dev scan [dev]'. For this purpose
> this patch proposes to use ioctl #5 as it was empty.
>         IOW(BTRFS_IOCTL_MAGIC, 5, ..)
> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
> the /dev/btrfs-control to forget one or all devices, (devices which are
> not mounted) from the btrfs kernel.
>
> The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
> set to specify the device path. And all unmounted devices can be removed
> from the kernel if no device path is provided.
>
> Again, the devices are removed only if the relevant fsid aren't mounted.
>
> This new cli can provide..
>  . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
>    device is not going to be mounted.
>  . Ability to mount the device in degraded mode when one of the other
>    device is corrupted like in split brain raid1.
>  . Running test cases which requires btrfs.ko-reload if the rootfs
>    is btrfs.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/super.c           | 3 +++
>  fs/btrfs/volumes.c         | 9 +++++++++
>  fs/btrfs/volumes.h         | 1 +
>  include/uapi/linux/btrfs.h | 2 ++
>  4 files changed, 15 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 345c64d810d4..f99db6899004 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2246,6 +2246,9 @@ static long btrfs_control_ioctl(struct file *file, =
unsigned int cmd,
>                 ret =3D PTR_ERR_OR_ZERO(device);
>                 mutex_unlock(&uuid_mutex);
>                 break;
> +       case BTRFS_IOC_FORGET_DEV:
> +               ret =3D btrfs_forget_devices(vol->name);
> +               break;
>         case BTRFS_IOC_DEVICES_READY:
>                 mutex_lock(&uuid_mutex);
>                 device =3D btrfs_scan_one_device(vol->name, FMODE_READ,
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f435d397019e..e1365a122657 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_devi=
ce *bdev, u64 bytenr,
>         return 0;
>  }
>
> +int btrfs_forget_devices(const char *path)
> +{
> +       mutex_lock(&uuid_mutex);
> +       btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);

One space before : and another one after it please.

Now the more important: don't use strlen, use strnlen. Some malicious
or sloppy user might have passed a non-null terminated string, you
don't want strlen to go past the limits of btrfs_ioctl_vol_args for
obvious reasons.

Also, please, not just to make a maintainer's life easier, but current
and future reviewers, add the patch version to each patch's subject
and not just the cover letter. Also list (after ---) what changes
between each patch version in the patch itself and not the cover
letter.

V12, here we go.

> +       mutex_unlock(&uuid_mutex);
> +
> +       return 0;
> +}
> +
>  /*
>   * Look for a btrfs signature on a device. This may be called out of the=
 mount path
>   * and we are not allowed to call set_blocksize during the scan. The sup=
erblock
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index aefce895e994..180297d04938 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_de=
vices,
>                        fmode_t flags, void *holder);
>  struct btrfs_device *btrfs_scan_one_device(const char *path,
>                                            fmode_t flags, void *holder);
> +int btrfs_forget_devices(const char *path);
>  int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>  void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int st=
ep);
>  void btrfs_assign_next_active_device(struct btrfs_device *device,
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 5ca1d21fc4a7..b1be7f828cb4 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -836,6 +836,8 @@ enum btrfs_err_code {
>                                    struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>                                    struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +                                  struct btrfs_ioctl_vol_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks
> --
> 1.8.3.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
