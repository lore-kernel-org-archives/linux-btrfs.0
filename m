Return-Path: <SRS0=krxf=BK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7398C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 03:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94C96208E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 03:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iovPxdu8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731266AbgGaDlB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 23:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730820AbgGaDlB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Jul 2020 23:41:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C748C061574
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2020 20:41:01 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id t15so21499570iob.3
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2020 20:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L7wI4BTBtbyT11LS7cJ29rQLTo0gUtR79YRgbxjfJuk=;
        b=iovPxdu8tUGySGpBbIk4I1aAbNdtg6eLiwkhn+IZUjOu+vA11xeDPCNh8tkfmm3FHK
         4L+f/QBZaR7b26uFsKS8Hc8NUvfRTQGec4zinPN8Mx2S3qvucJbTaBJdW0U9KSDkLwax
         CIb8JRUOuxjngiLms1UVI7EQ4cpk5v3H22N1KolhmPvypCXAyfEhiYYkOX0KojOUhDKq
         fbldfGSnsPT8IZlU+yLTHSswKuYrsy2Dniy2Dv0zXllLLcZcEt9vFHrIi3f/aN0PBHHb
         Lr1LzC4cyb/w7CBPpxG49nhYlLP04dSu7frYw2UrRnUDk/orSOYYUUQEFE0LKtOdtaad
         CR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L7wI4BTBtbyT11LS7cJ29rQLTo0gUtR79YRgbxjfJuk=;
        b=jnbmm+DAA47AOTcyKXJDH6a8n1bjwNp10IYvefc4D1lv2mQmseYPJyvR7BXc1WWE3v
         6XYW8b3/qOv9+jMkJ0Fmh2wiKTCYGElUUhSi3SURbJ2cZCjp/ML2X21wdmB0Q0K9MXQa
         qwQLV+bK/2Pp4DdzH/7XtUhtjSv1ardVouDC4wT2xzGqwARnZR1S8H+opETvIUkQr6j8
         CpRmAKWvNISVIrL7Ew87gRNhJ2rIBWtX7bS8paX7qOws7L/TouCZ2UM0OlhfhiLVRlO2
         EG0lxDluHkWb4++rirLxTWtbAEepjBWq4tt69OqzYrS6/+wo0Qmpggx2YXcGVbNK2Ep0
         8d1A==
X-Gm-Message-State: AOAM530p36vUHktuxj/WliXbTGzKYPUL8Jzi4Owf0nedo0ceO7zSpttD
        JNIYec3+urBeENI7NVqsVrsnxpaooFdkPeNBaE8=
X-Google-Smtp-Source: ABdhPJwdiYb0cXma/fbEBNMyf8N271eACmQK2NkRv1qoO7CsA80ip6Ygb1BzaCTn6sJM/wKaL/Wc+CCk8ck/2m6LUqA=
X-Received: by 2002:a05:6638:2692:: with SMTP id o18mr2731266jat.2.1596166860656;
 Thu, 30 Jul 2020 20:41:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200731010334.47406-1-dxu@dxuuu.xyz>
In-Reply-To: <20200731010334.47406-1-dxu@dxuuu.xyz>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Thu, 30 Jul 2020 23:40:24 -0400
Message-ID: <CAEg-Je84RLtJCnjt7e_tVqeW4DJZ0rk=vj-QT+x-b2mxT9yVOQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Update README.md with editorconfig hint
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 30, 2020 at 9:05 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Add a helpful hint in the README to encourage contributors to install an
> editorconfig plugin. This should help maintain source file consistency
> in the long term (eg tabs instead of spaces).
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  README.md | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/README.md b/README.md
> index 537c77c5..2d5f360f 100644
> --- a/README.md
> +++ b/README.md
> @@ -82,6 +82,10 @@ the patches meet some criteria (often lacking in githu=
b contributions):
>      substitute in order to allow contributions without much bothering wi=
th
>      formalities
>
> +btrfs-progs is configured with an `.editorconfig`. Please consider insta=
lling an
> +[EditorConfig](https://editorconfig.org/) plugin for your text editor to=
 help
> +maintain source file format consistency.
> +
>  Documentation updates
>  ---------------------
>
> --
> 2.27.0
>

LGTM.

Reviewed-by: Neal Gompa <ngompa13@gmail.com>

--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
