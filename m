Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41460C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 10:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0F720834
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 10:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biGGMo+r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB0F720834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbeK2Vlg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 16:41:36 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44545 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbeK2Vlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 16:41:35 -0500
Received: by mail-vs1-f65.google.com with SMTP id g68so816885vsd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 02:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=aTQ5FQWml0JvRYZ5aZPvq5QJKmXFr/mUstaHCbLLjQ8=;
        b=biGGMo+rgRbvqRFLkpHhUpn/CWBjasGA5//CQXPWsQN4gPgKBjdEiGqSexUCgc7BJg
         ZrrBl2eJ+KqkosrIB6m4FiCHp/CwDglBARN+zCYHpV4rDGCIVCj2K4Teq+67QuJwVvZl
         gvzQvTBLVfLgCyzxqVzuNmo0S9NziPUVF0N3+CjsNRDsQffU4SH8kXwgqI0p1B7tbdDy
         wlvFpOfFaLJ8lTppG2k2odk7MD7Tg2FySL5/GwvxV+tq5egWt8Mpqia8qjVy+/EuN0aP
         Pbz+sqkwKmy72Jn3lfFgxhZjyaQc988uKuBhz8BVylUUVnEFjVTrpz/XJZlDNQbUSlmD
         9mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=aTQ5FQWml0JvRYZ5aZPvq5QJKmXFr/mUstaHCbLLjQ8=;
        b=iOaRLjMqE7WgFixS09p+ZyphlXIWMwjsX0NdL0VNSLGZxE2A8T4F18X7/Q+T083Xon
         HllU7+1i0eUw/teP+B0PqYyiD00ixRZe4olArEidO3DvR5p8Uu+lOOBd0NHbKDm+BRGB
         ETmhnWMJEJ8WuhSn2o/IapAnx1AN997jCJeIxigSSEDofCWx/gMD2JK6sCYTMn9a+XI+
         3APdoMYFnsuhzbf/ptxn1+MuuGv5ledFORD1gtkbolaQ1l/o3y1ZEj2bzd1CiYxQSyWQ
         F9xNLi2ZBTMprKuopyyaWgyJ0iRrIPauFkuhLreZdClEV+K4FsMCUU3Z56/QEldFNvbW
         ouYg==
X-Gm-Message-State: AA+aEWZaA8XxnOFBoELVC4oFfOfKbXOl3tmcn9cKWxIgUpkEqz8PZtXK
        xaEARmRN9Rje8Yb97tScgLkQvx0UNa5B7FVwJeA=
X-Google-Smtp-Source: AFSGD/VR7jQuomwPbL32gPf4NrvCJJoe9/pbYfZdS7GhslELd8XR/Lbk5uwFxouqbbJqt4HaILK2BRoOZ1LX8OTDJ9Q=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr306058vsa.99.1543487801146;
 Thu, 29 Nov 2018 02:36:41 -0800 (PST)
MIME-Version: 1.0
References: <1543483513-16724-1-git-send-email-anand.jain@oracle.com> <1543483513-16724-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1543483513-16724-2-git-send-email-anand.jain@oracle.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 29 Nov 2018 10:36:29 +0000
Message-ID: <CAL3q7H667aumMBiyOQrcULVVNpiCP3FJ5W7FPjf_8-udSMn0Qg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: scrub: maintain the unlock order in scrub thread
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 9:27 AM Anand Jain <anand.jain@oracle.com> wrote:
>
> The device_list_mutex and scrub_lock creates a nested locks in
> btrfs_scrub_dev().
>
> During lock the order is device_list_mutex and then scrub_lock, and durin=
g
> unlock, the order is device_list_mutex and then scrub_lock.
> Fix this to the lock order of scrub_lock and then device_list_mutex.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1->v2: change the order of lock acquire first scrub_lock and then
>         device_list_mutex, which matches with the order of unlock.
>         The extra line which are now in the scrub_lock are ok to be
>         under the scrub_lock.

I don't get it.
What problem does this patch fixes?
Doesn't seem any functional fix to me, nor performance gain (by the
contrary, the scrub_lock is now held for a longer time than needed),
nor makes anything more readable or "beautiful".

>  fs/btrfs/scrub.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 902819d3cf41..a9d6fc3b01d4 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3813,28 +3813,29 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info=
, u64 devid, u64 start,
>                 return -EINVAL;
>         }
>
> -
> +       mutex_lock(&fs_info->scrub_lock);
>         mutex_lock(&fs_info->fs_devices->device_list_mutex);
>         dev =3D btrfs_find_device(fs_info, devid, NULL, NULL);
>         if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &=
&
>                      !is_dev_replace)) {
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 return -ENODEV;
>         }
>
>         if (!is_dev_replace && !readonly &&
>             !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 btrfs_err_in_rcu(fs_info, "scrub: device %s is not writab=
le",
>                                 rcu_str_deref(dev->name));
>                 return -EROFS;
>         }
>
> -       mutex_lock(&fs_info->scrub_lock);
>         if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
>             test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
> -               mutex_unlock(&fs_info->scrub_lock);
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 return -EIO;
>         }
>
> @@ -3843,23 +3844,23 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info=
, u64 devid, u64 start,
>             (!is_dev_replace &&
>              btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
>                 btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> -               mutex_unlock(&fs_info->scrub_lock);
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 return -EINPROGRESS;
>         }
>         btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
>
>         ret =3D scrub_workers_get(fs_info, is_dev_replace);
>         if (ret) {
> -               mutex_unlock(&fs_info->scrub_lock);
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 return ret;
>         }
>
>         sctx =3D scrub_setup_ctx(dev, is_dev_replace);
>         if (IS_ERR(sctx)) {
> -               mutex_unlock(&fs_info->scrub_lock);
>                 mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +               mutex_unlock(&fs_info->scrub_lock);
>                 scrub_workers_put(fs_info);
>                 return PTR_ERR(sctx);
>         }
> --
> 1.8.3.1



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
