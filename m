Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FD9C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B5F2184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 22:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxHVC9Bp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfCNWj3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 18:39:29 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36992 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfCNWj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 18:39:28 -0400
Received: by mail-vs1-f68.google.com with SMTP id y19so4280804vsc.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 15:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=VabwMTic9kYSsjR3cPGScMMVGcHlyWOCROPvYX1O34s=;
        b=cxHVC9Bpou+rImba6KQ5EB5WtvLOshGI3eBUaEAfeY5qM6zYBHo2/XKwTYV7FslU3K
         lQSThekfhKNoBjTavqBJvSJQC2v8RCoIa5Q9kY/glRcdKt2FrQiE0mY5/qd1aKPqBu0u
         MWjzPCgwGHxwRPRmsl8evY2B78EgFPXwLzSFKdW14EqBZZ+X/gvYgkZEXa7ajJX6lNhU
         sg5Cd2RrAU2LDfTcuWDnpPqIq6ErfQwQLhBAqnNhABn+LrfH3qUUOczVum/LUob0re6N
         c0msmxVt2/9hYtbg55LiZ3EPzHTQGctQes/FrT9aZXv2YICEJWrV7tyThWaLG/dlMHGX
         ZTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=VabwMTic9kYSsjR3cPGScMMVGcHlyWOCROPvYX1O34s=;
        b=PQZNG/iYXH4ikXR13VW2Znfj6fNKWVB1qmL+TRR4LRAaoos6Q1FotZUBUD4M3zpDS/
         OaC53K5adCPboIYI3tovPFD+7CxfDwaQs1d161KATwhaDbl7gO7fWHP1LW9KIxIdDvKQ
         rqhiUs+B5vpQ5LnadUBxGCF5a4fw5T4gcNAtKT5tvi5g0Nk4qNtvVAo1J3f8ZEENAEEP
         w0tziXA58AG7an0K1UKfPGBk3/H+9HbEZ38kb+O9N6tGiSb8Q5IR9dkGnKPgdVzdohfO
         8ru72Rnwd/Qsiu/MkYwNl0b72RKq15bYkbitCYJMB9W4QMdio8Ncu9mr/wOLUzLqqCf8
         jhRA==
X-Gm-Message-State: APjAAAVrdNvhfuf9sGMPnrna8N/TNE66WFB2OJgIPU18+4BI8JpGZX1y
        EFRlxrowRcckPVI9sjCnSc7awafyJGNKNzaqk1obIA==
X-Google-Smtp-Source: APXvYqyXjArDjx2Z3PHdR0OGnCJ54MmxzMda7QnuTINV7Y3Dfd3nf1/Q0ojcptDASNsPmJTG6mh0i2q2eCHCSrHEdco=
X-Received: by 2002:a67:de09:: with SMTP id q9mr347399vsk.95.1552603167973;
 Thu, 14 Mar 2019 15:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org> <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org> <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
 <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
 <20190215054031.GC9995@hungrycats.org> <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
 <20190307200712.GG23918@hungrycats.org> <CAL3q7H599_kDPDFHMRqSwNLXKtANC7aaqBe+Hm6JjpR37uS1Vg@mail.gmail.com>
 <f1d3b79ac3496fc9bdeac2b0a863f6124365713a.camel@scientia.net>
In-Reply-To: <f1d3b79ac3496fc9bdeac2b0a863f6124365713a.camel@scientia.net>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 14 Mar 2019 22:39:16 +0000
Message-ID: <CAL3q7H72TrwRv2__qZEGc_Mt7X6XZ4ahwGy4+dRK=J7wUEOk0g@mail.gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 8:22 PM Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
>
> Oh and just for double checking:
>
> In the original patch you've posted and which Zygo tested, AFAIU, you
> had one line replaced.
> ( https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3 )
>
> In the one submitted there were two occasions of replacing
> em->orig_start with em->start.
> ( https://lore.kernel.org/linux-btrfs/20190214151720.23563-1-fdmanana@ker=
nel.org/ )
>
> I assume that's on purpose?

Yes.

>
> Cheers,
> Chris.
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
