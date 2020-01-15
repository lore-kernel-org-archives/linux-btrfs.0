Return-Path: <SRS0=+Z9o=3E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC370C33CB1
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 09:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA264207FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 09:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgyrdtdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgAOJdZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 04:33:25 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:41055 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbgAOJdY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jan 2020 04:33:24 -0500
Received: by mail-vk1-f194.google.com with SMTP id p191so4497475vkf.8
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2020 01:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=CLofogBMXsD6QZJ1mYQiOr7xgNYRGVRetyX2FX7kCeE=;
        b=cgyrdtdz9Qmf+FLCEcs4XcxgGg/t6xij4wg0diVbhYX8nXr4WhbA/QhTQ2FqIr/36m
         vNGL4X28JxqhcBL3aS/PsBAqeD3mGeYyqDJeTCjdMz4uGdpBJnJ/cxqz7JQAWnHImsc7
         EyqfzDT9e2LyPJaL5esT11pYW4ia58QOvdxbwyJck5/nJbIpwOzX2OxweEaBdEpybnNK
         ozKWTxn+LDfMdJ10Xf16U8g0ERxM42ol9kkflAfhbBpixYLXnLS8D7kLz2AzT0eOxuky
         odko0qtlzQ+mXGMozpoZ4Qzr+3NLV42zcfk0mQLJCZUiNjMYDGtb9LKyhLB9Wz78+s7f
         5ncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=CLofogBMXsD6QZJ1mYQiOr7xgNYRGVRetyX2FX7kCeE=;
        b=ErQbSxTYJ3TVxgGxniPseVpBWEfxzHrKCOvfoIwm8ATHV07Mjj+RmBYNTe8Q7OeJ4A
         LBVuHauL9MK0hd4ZuCQCB+uVW2U9agb3Qxh5l/IgYWtWYbOq/lH9+3SIzLKK5u3CPauN
         4cGJ2MVadu8Z/eEf0HC+eKmiV6p40Vwm9vSxhVoGeo6TfETcuoLgCvafQvbcKMYfXaRE
         wzhm1x3qg0TPM0JJMxPSXUQL3M9Qaovj2PgdR6awBrh6nbXLIoSGjsZ8u1NEttUh04i1
         DGoYUXONJVsRncDkRHLgZOSjZ7kuTjSlbazKrNsrOGir2QtTdNAtNWIZNhQuiAxtsw6u
         5QtA==
X-Gm-Message-State: APjAAAUg5sweJOmQGX9gE0u65qFRx/jKKN1PiBB3Msd7PVUFLSqa/0dd
        MNM3NGr2dUJqLzB2/n3VfKWFcvhbm7bx3yd7r1U=
X-Google-Smtp-Source: APXvYqyiy2K5c06cXiNUuCmRykYuQNYRi3Vs9+BIMpDAUiPiCOgNRS8TGkmkybhuGJVkVbI9ze0HZVqqzVOaFo9kj+A=
X-Received: by 2002:a1f:f283:: with SMTP id q125mr13412156vkh.69.1579080803731;
 Wed, 15 Jan 2020 01:33:23 -0800 (PST)
MIME-Version: 1.0
References: <d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net>
In-Reply-To: <d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 15 Jan 2020 09:33:12 +0000
Message-ID: <CAL3q7H7ERYHeKPsQcyT05A=rgY7QJcgDhhnSFjmFfbKMfam_hg@mail.gmail.com>
Subject: Re: Scrub resume regression
To:     Graham Cobb <g.btrfs@cobb.uk.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        =?UTF-8?Q?Sebastian_D=C3=B6ring?= <moralapostel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 15, 2020 at 9:04 AM Graham Cobb <g.btrfs@cobb.uk.net> wrote:
>
> OK, I have bisected the problem with scrub resume being broken by the
> scrub ioctl ABI being changed.
>
> The bad commit is:
>
> Fail
> 06fe39ab15a6a47d4979460fcc17d33b1d72ccf9 is the first bad commit
> commit 06fe39ab15a6a47d4979460fcc17d33b1d72ccf9
> Author: Filipe Manana <fdmanana@suse.com>
> Date:   Fri Dec 14 19:50:17 2018 +0000
>
>     Btrfs: do not overwrite scrub error with fault error in scrub ioctl
>
>     If scrub returned an error and then the copy_to_user() call did not
>     succeed, we would overwrite the error returned by scrub with -EFAULT.
>     Fix that by calling copy_to_user() only if btrfs_scrub_dev() returned
>     success.
>
>     Signed-off-by: Filipe Manana <fdmanana@suse.com>
>     Reviewed-by: David Sterba <dsterba@suse.com>
>     Signed-off-by: David Sterba <dsterba@suse.com>
>
>  fs/btrfs/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> bisect run success
>
> It is important that scrub always returns the stats, even when it
> returns an error. This is critical for cancel, as that is how
> cancel/resume works, but it should also apply in case of other errors so
> that the user can see how much of the scrub was done before the fatal err=
or.
>
> I am not sure in which kernel release this commit appeared but as this
> breaks the "scrub resume" command completely, I think the fix for this
> needs to be backported and may want to be considered by distro kernel
> maintainers.
>
> I will reply later with the simple reproducer program I created for the
> bisection in case it is useful for testing.

No need to, it is simple to understand why it happens and the not
copying that stats in error case was not intentional.

Try this:

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a4bd5cd67fa..611dfe8cdbb1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4253,8 +4253,10 @@ static long btrfs_ioctl_scrub(struct file
*file, void __user *arg)
                              &sa->progress, sa->flags & BTRFS_SCRUB_READON=
LY,
                              0);

-       if (ret =3D=3D 0 && copy_to_user(arg, sa, sizeof(*sa)))
-               ret =3D -EFAULT;
+       if (copy_to_user(arg, sa, sizeof(*sa))) {
+               if (!ret)
+                       ret =3D -EFAULT;
+       }

        if (!(sa->flags & BTRFS_SCRUB_READONLY))
                mnt_drop_write_file(file);

I'll later send a patch with a changelog to the list.
Thanks.



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
