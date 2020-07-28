Return-Path: <SRS0=QcMt=BH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BB5C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 02:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B8A20672
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 02:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pE6AXsmb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgG1CYL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 22:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgG1CYK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 22:24:10 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5985BC061794
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2020 19:24:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t18so14934430ilh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2020 19:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EFdgxwo/1dEiSfQPf0Bi/mEzNKYud8RYHPe7hzqYsO8=;
        b=pE6AXsmbIH2uyI0Mxdv5tdejaE3nM5j3ryH+Gri74+q/HU4Ypg4PNo8vzgtOlNrzYd
         aAsQMVXcw8nzyMSia3Saivft54mj5qeX4oKG5kPhfwAfk945FuXrTFX2uKg6MJXmQ660
         3TouVRvoPYoN9l0/n3peHUwT8b90DbQXqaPJgeNrnvSXK+NfWq9a5xvBoMeVTSCcROhc
         5Qp3hQFIxik3oVoyho3vWHRR8L/IyH0oedCg5Ih36e7R75lm6YI0+wnex6KaDU3iIVfW
         278sLoxQwY0CqVLyBR/HniyR62vLw4e0g8sLAoF5sU2UAUwjDOgKsOV4DnMp4F5xnrDn
         I80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EFdgxwo/1dEiSfQPf0Bi/mEzNKYud8RYHPe7hzqYsO8=;
        b=XgiecaVKjiGQg+wqUsREBUBrotIOsW5ZL5mdsWJd6SS3gz4FViEYBoyqjRRaNcO/yh
         S+IqDjBORqmSZMn6JdXX+mjqL/8HxRHf2l3N4mknLKuy81mIZ++PWwC3C8J/TeonnyUW
         5+BZB9TaZI0uBlBqvtfoSzftcyici2OiUR7a+cHMmXVhv+iVsKYKner3SNs9vvqVCO8O
         0e7rrN4syzStzEf+ps2A8wfnwK5o6WUE//gDrG1FZhcLNROZNZu18iN6DyLTsGRN9RtS
         TvtdszmHejGI4F4HQtbC4drBdrKo4fQ/xSuNsj4j1nbRdfgVYZ9hk1sBd3qKPfVOUZId
         qvkQ==
X-Gm-Message-State: AOAM531SPyr+N6+7k4VWIbP2R/JSc3cbn2RAHRO2Vu8cMD2VDa0mfLVm
        0y7Un3c9RbeXk9BZKRWIGv0M2xDqhzJMep6fE0g2LTjf
X-Google-Smtp-Source: ABdhPJxHISzvc15DbtKqvLv8jTWwzWcUsyAykORc/n7ws+0LANgDfR+r545OmH6mpp1N2BbS28Axhq0CnqgbDlso9KI=
X-Received: by 2002:a92:5a92:: with SMTP id b18mr21954203ilg.9.1595903049623;
 Mon, 27 Jul 2020 19:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200728015715.142747-1-dxu@dxuuu.xyz>
In-Reply-To: <20200728015715.142747-1-dxu@dxuuu.xyz>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Mon, 27 Jul 2020 22:23:33 -0400
Message-ID: <CAEg-Je8AAYNShdKH1H46nQ-T69O3YyUn9vJUTTFmV1BQmEJM2w@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: Add basic .editorconfig
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 27, 2020 at 9:58 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Not all contributors work on projects that use linux kernel coding
> style. This commit adds a basic editorconfig [0] to assist contributors
> with managing configuration.
>
> [0]: https://editorconfig.org/
>
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
> Changes from V1:
> * use tabs instead of spaces
>
>  .editorconfig | 10 ++++++++++
>  .gitignore    |  1 +
>  2 files changed, 11 insertions(+)
>  create mode 100644 .editorconfig
>
> diff --git a/.editorconfig b/.editorconfig
> new file mode 100644
> index 00000000..7e15c503
> --- /dev/null
> +++ b/.editorconfig
> @@ -0,0 +1,10 @@
> +[*]
> +end_of_line =3D lf
> +insert_final_newline =3D true
> +trim_trailing_whitespace =3D true
> +charset =3D utf-8
> +indent_style =3D tab
> +indent_size =3D 8
> +
> +[*.py]
> +indent_size =3D 4
> diff --git a/.gitignore b/.gitignore
> index aadf9ae7..1c70ec94 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -65,6 +65,7 @@
>  /cscope.in.out
>  /cscope.po.out
>  .*
> +!.editorconfig
>
>  /Documentation/Makefile
>  /Documentation/*.html
> --
> 2.27.0
>

LGTM.

Reviewed-by: Neal Gompa <ngompa13@gmail.com>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
