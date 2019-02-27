Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A99C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A522147C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 11:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="SCMG6sYW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfB0LWV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:22:21 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45090 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LWV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 06:22:21 -0500
Received: by mail-yw1-f66.google.com with SMTP id r188so7641270ywb.12
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2019 03:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovfBI19e8LiVXKQDNKFKjhDtNobeMq/9sRx74g33jZs=;
        b=SCMG6sYWHPQEpM9A/kicKLMo/yLPaLqT+hiScu03cXC7ZwruN+kYP/pfVTO7VdCmt8
         sv8Y9FtDubwM/t+Ko11I34TdL67yxWvyoI3FRRMCQghRpkUH0eCJmcaKYVHvwYbkPMbh
         Bzsn1MB3bf+L/PpBOoPMA8P98xLfZjzCLPUIqfzhbGfLeFYVdGLZuA6RDvW5ZY2zuktb
         rKp4/10yvbdm4C6Xh2TbU2JviFGgpvspQ5tWtyFi5AFEGMUBoEJPkAb2W+4CEKBGRB8P
         XdZHm0mHgEcVx31E90Ozn2+oOFgCS6Gd0YdTJCTxsqBDllu76SY9M1DeGex2IdlCT5xi
         DUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovfBI19e8LiVXKQDNKFKjhDtNobeMq/9sRx74g33jZs=;
        b=oF9VnpoBRu0HgVbq98rg+7ATecHUyvtfE7O3QAQdlcukIBLCrAk/Blt2aSgURBqu1x
         QP+sMdLLXcibdf0K219+lJ3g0DYTiA8/fkoge2hu0ZNJQMswL0PE8fKaoaM9JPeaWExJ
         2cW+w/PFUbiB9oZWtfhjO5KqDmsSRp8t5cKvpS/MQfNYS6GbwRjeB7wSvv7JFwk0SVb9
         fV56yaq2yV7VvHvo0cZ6FHfEdZhAvC5cwHYYtKjO8Fi6ha+rN6t4apNbWnkJJ5WeikqU
         aZPCeyAg6t+zG2tXtXtrSlly3MVIrO/nvEEKgZdGkygZArI0oj62KcseXk8jQKnGQh/K
         Bu7w==
X-Gm-Message-State: AHQUAuZRu1Og9HZFud60wlSWGGjv3k0Dp5G+Iba/QbaiFayD1oQv7JuR
        ER3Dh/ATNXqdYmmKJIzpVnnpx6WVP7l2xMtAoUwrxw==
X-Google-Smtp-Source: AHgI3IaqyR9cNq4xmj/d1I/e5p56rOq7DSvlDkCvAB4xuceSj1tYAGh7IkuOC+oCmd/KZR1UjhJwsSkniV9fQyb6I04=
X-Received: by 2002:a25:7ec5:: with SMTP id z188mr1469525ybc.282.1551266540862;
 Wed, 27 Feb 2019 03:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20190227051602.28987-1-wqu@suse.com>
In-Reply-To: <20190227051602.28987-1-wqu@suse.com>
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Wed, 27 Feb 2019 11:22:09 +0000
Message-ID: <CAMU1PDi9GD9TC6B8kN4iGbeddOxkPH7B+UxeiVbC_KOwJvxnzQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: gitignore: Ignore hidden files
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 27 Feb 2019 at 05:16, Qu Wenruo <wqu@suse.com> wrote:
>
> A lot of editor/IDE related config files are hidden files, like .vimrc
> or .clang_complete.
>
> Instead of adding gitignore entry for each editor/IDE, just ignore all
> hidden files like what kernel does.
I think you mean:
files starting with ".", like ls does by default without the -a flag.

Mike

>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  .gitignore | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/.gitignore b/.gitignore
> index d9f022c48c7d..aadf9ae77d41 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -64,7 +64,7 @@
>  /cscope.files
>  /cscope.in.out
>  /cscope.po.out
> -.clang_complete
> +.*
>
>  /Documentation/Makefile
>  /Documentation/*.html
> --
> 2.21.0
>
