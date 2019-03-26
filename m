Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B2CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357E9206DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbfTDahx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbfCZTgO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:36:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40512 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729693AbfCZTgN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:36:13 -0400
Received: by mail-io1-f66.google.com with SMTP id d201so11925250iof.7
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 12:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FowcaI3nLCJ1clHQwPSs03JoHntqnE2qwoRUW4+U2v8=;
        b=CbfTDahxaZUd2qj2m48nUMFnK8DQgnM/gy7QbvpYQr5IGxM9BuxsXXW5NJPsg/yidJ
         TzDWG8H9quJzT6N5eqo9SK1I/Ih7a1nrwX3q53F/mR74TKyTcNhqE/w3/nNqIqcfC+gz
         t9WT1L/l+Q9Ljx+NqTtrbnC21aDa53/sPaXdxl4xTYawyV5pa53P8K+Q4FWGvwXKK3Wx
         QnFwi1SBf7mBMklmkU9MN1BEmd1p3yCpBU0Ja40BGXooB3sPR9+WGoOmap3+MYDXBst+
         70AOHbr6QFu4Mpa9jvEuOo//dT9O6vnYVuY8MTjUqIy7Tq5lleU3A/ui5PvGGOdhni8M
         L7Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FowcaI3nLCJ1clHQwPSs03JoHntqnE2qwoRUW4+U2v8=;
        b=qMy81afJ28Btu7P9bM1KSX9LZ0/aCC4uYBRtJ9GOIrhXc386uH4VOCf0kSqLr4/wZU
         6+Og9AIIKOEgyWYu7yn8dC+V7Zd7lZInpNjBcdAE1wNuv86zGfvdJ08stZ/Ow/jlcdHo
         pxemv7dykz2DJ66UBmUVDlzcH2KFxbXOtI0b5ALzrimpNpz4b+6fjVtbiPhVz1EHye99
         IkrEWeGTtTtK/3ChYv29k1HNhpXoSIXnixzG/HtMqtc0twctvxG5JOjnu2oiX2rwFI7o
         pNQtvrpN3UIxHDBmem0Z0b8pcXHGe7FIuZBqPPghl8skoOFcyutR2HvgH58KOfosYAD3
         gt6g==
X-Gm-Message-State: APjAAAXfqkrslpcI6fyGtvIR6PMUjO0gU2XbiH5PWS8S/0AsFcMwdzWZ
        KDQC7xOaVAZazW67vdNIeLodf6di9mqWwJfoMgI=
X-Google-Smtp-Source: APXvYqz61ppm2kOfaEprDaoPE6DkFNCAnzu56HelK1LBLIAUKuCkHvoJ+HrFierfS3PGnCjoWQGN4lXKr/WrSpxRQPs=
X-Received: by 2002:a6b:660e:: with SMTP id a14mr21420284ioc.136.1553628972795;
 Tue, 26 Mar 2019 12:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20181205122835.19290-1-rgoldwyn@suse.de> <20181205122835.19290-8-rgoldwyn@suse.de>
In-Reply-To: <20181205122835.19290-8-rgoldwyn@suse.de>
From:   Dan Williams <dan.j.williams@gmail.com>
Date:   Tue, 26 Mar 2019 12:36:01 -0700
Message-ID: <CAA9_cmcEDc6E=zvC1m=jKXMZ7Wy+GCF91SZK5Nu5FidN6boW4w@mail.gmail.com>
Subject: Re: [PATCH 07/10] dax: export functions for use with btrfs
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 5, 2018 at 4:29 AM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> These functions are required for btrfs dax support.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/dax.c            | 35 ++++++++++++++++++++++++-----------
>  include/linux/dax.h | 16 ++++++++++++++++
>  2 files changed, 40 insertions(+), 11 deletions(-)

Per MAINTAINERS, please copy the filesystem-dax developers on dax
patches please.
