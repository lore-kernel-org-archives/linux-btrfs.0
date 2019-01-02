Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103D8C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 02:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7D88208E3
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 02:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jufbhBvq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfABCfY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jan 2019 21:35:24 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44037 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfABCfY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jan 2019 21:35:24 -0500
Received: by mail-ot1-f66.google.com with SMTP id f18so25723690otl.11;
        Tue, 01 Jan 2019 18:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YcNY0b2HTWGPUOJaiu4J+xBqf9iVDONM7xlLy3ItoXY=;
        b=jufbhBvqv034LwPM7+BFmLqvjH68UmirpsvpIE0PNsymFVHtWhBrFMOVcqRG7kLotx
         EDd1RTgnBtjEfkHq6qnnldQU8ir08/qTYncvl3m35utmyDx6lcPWF7nhPgOUJE2qEfFB
         XDXhPVAfiOFKMistQPcCaqI793P1WpjU5j4Txwp8+E6yMWgdZkUNHz8AfN3NGtXIhpid
         UveUw/yvADd6eQ71PJKhGZGqSeMpkTXVMeYi5ZZL5FZLO8+SgsxwbU6OHRHhuw2wGe29
         AWCTESK44nLvdV8y18DzNKR6dpKkpzsf3gfv/Re8MmDBFJsbci3Q9c9+6fZxs8N9TY4C
         MmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YcNY0b2HTWGPUOJaiu4J+xBqf9iVDONM7xlLy3ItoXY=;
        b=BurybnrTIM4pEzq6i0c0c7OcGiF03IuqfKunlRn8FCySfzStQF2rTlCFRkZT7NY7C1
         peGQb5wbE/7hWZldmqHo8ZtANYMm+t3NlxzAJgO5g6JmBwvLFhHxASfTK85hmNsBJkRD
         9J3Q0d8OsPrZoNjLYl/b4rWTXW36viyWerwlQMBOQqDioUTsAmtWohNhZ8NyLrXoevJJ
         c4OUrVs0K5P5Z6Pz6wDpvptPRLCAmkx0/dw2Xam05NJ/iqj4dh5nHPxyN3Crkl7uMm2R
         oc66Z7zqcVRCNciO01jKokA37Vxn3yA6hhxnOEwjzB6DdL+ujaAzllWte8Iu+IcmPGJq
         ymjQ==
X-Gm-Message-State: AJcUukdARwz8zAsaIClr4WykodaE5xLmjZ7hsbnbuR+wGqWLn3C793jY
        zBUAoB96pHnFKmxixw+EEsDUCPdqaR3TvpohOIMCBg==
X-Google-Smtp-Source: ALg8bN7cMSC+FZXcABSEXDrJonltyRLtw5w+0o8rjjU82gcnpylzSyWNBDQNBG8Su94tLoY9+gwShRWI64Ci7MvdR0o=
X-Received: by 2002:a9d:7597:: with SMTP id s23mr27529849otk.370.1546396522310;
 Tue, 01 Jan 2019 18:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20180504001541.2068-1-nefelim4ag@gmail.com>
In-Reply-To: <20180504001541.2068-1-nefelim4ag@gmail.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Wed, 2 Jan 2019 05:34:46 +0300
Message-ID: <CAGqmi74gL=urkvKuSGpDF05f6BpTC0zdf1vDSVDZ-9qr+2q5Tw@mail.gmail.com>
Subject: Re: [RFC PATCH] raid6_pq: Add module options to prefer algorithm
To:     linux-raid@vger.kernel.org
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Gentle ping.

=D0=BF=D1=82, 4 =D0=BC=D0=B0=D1=8F 2018 =D0=B3. =D0=B2 03:15, Timofey Titov=
ets <nefelim4ag@gmail.com>:
>
> Skip testing unnecessary algorithms to speedup module initialization
>
> For my systems:
>   Before: 1.510s (initrd)
>   After:  977ms  (initrd) # I set prefer to fastest algorithm
>
> Dmesg after patch:
> [    1.190042] raid6: avx2x4   gen() 28153 MB/s
> [    1.246683] raid6: avx2x4   xor() 19440 MB/s
> [    1.246684] raid6: using algorithm avx2x4 gen() 28153 MB/s
> [    1.246684] raid6: .... xor() 19440 MB/s, rmw enabled
> [    1.246685] raid6: using avx2x2 recovery algorithm
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> CC: linux-btrfs@vger.kernel.org
> ---
>  lib/raid6/algos.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index 5065b1e7e327..abfcb4107fc3 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -30,6 +30,11 @@ EXPORT_SYMBOL(raid6_empty_zero_page);
>  #endif
>  #endif
>
> +static char *prefer_name;
> +
> +module_param(prefer_name, charp, 0);
> +MODULE_PARM_DESC(prefer_name, "Prefer gen/xor() algorithm");
> +
>  struct raid6_calls raid6_call;
>  EXPORT_SYMBOL_GPL(raid6_call);
>
> @@ -155,10 +160,27 @@ static inline const struct raid6_calls *raid6_choos=
e_gen(
>  {
>         unsigned long perf, bestgenperf, bestxorperf, j0, j1;
>         int start =3D (disks>>1)-1, stop =3D disks-3;       /* work on th=
e second half of the disks */
> -       const struct raid6_calls *const *algo;
> -       const struct raid6_calls *best;
> +       const struct raid6_calls *const *algo =3D NULL;
> +       const struct raid6_calls *best =3D NULL;
> +
> +       if (strlen(prefer_name)) {
> +               for (algo =3D raid6_algos; strlen(prefer_name) && *algo; =
algo++) {
> +                       if (!strncmp(prefer_name, (*algo)->name, 8)) {
> +                               best =3D *algo;
> +                               break;
> +                       }
> +               }
> +               if (!best)
> +                       pr_info("raid6: %-8s prefer not found\n", prefer_=
name);
> +       }
> +
> +
> +
> +       if (!algo) {
> +               algo =3D raid6_algos;
> +       }
>
> -       for (bestgenperf =3D 0, bestxorperf =3D 0, best =3D NULL, algo =
=3D raid6_algos; *algo; algo++) {
> +       for (bestgenperf =3D 0, bestxorperf =3D 0; *algo; algo++) {
>                 if (!best || (*algo)->prefer >=3D best->prefer) {
>                         if ((*algo)->valid && !(*algo)->valid())
>                                 continue;
> --
> 2.17.0



--=20
Have a nice day,
Timofey.
