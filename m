Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8FDC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 13:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DD6F20827
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 13:25:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M6qgUr+c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DD6F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbeJ3WS3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 18:18:29 -0400
Received: from mail-yb1-f174.google.com ([209.85.219.174]:38552 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJ3WS3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 18:18:29 -0400
Received: by mail-yb1-f174.google.com with SMTP id v92-v6so4995184ybi.5
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 06:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=MCDb9mAmE6zhaT01TkHKHPdZ5naNjIraGOrifuR0s8U=;
        b=M6qgUr+c9xpnhMziDI08SMrsM02eGAPDpHsVa934i8semb9dKduoycjluNy1Kz4dVo
         1Lfxh7aHOH6Aq06y2EZYUZLM3STKYUMcVsx9x9SFeqRp5ICmO2no4coM7aP7gMfteJsG
         o2P93X4t7OqwQrJ82cpm7JcO66DrkWRp7r58ZNQL7TaR8oADh9d/Hhs56tUpRUr89ljr
         CMF7jqJe0aPOaVq2DoKTlFEHur4ki+Mnw6wrdZF3nliw4mBSk1KqBtzYxSWT9fAr8S2+
         7s4x5UzDDr7uihyz8lKReahsXNTrdCzen1iuptjRYtpUmSADyDAe3A+27Yf9ZkHD1Xjj
         JgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=MCDb9mAmE6zhaT01TkHKHPdZ5naNjIraGOrifuR0s8U=;
        b=hPN1eDJSo9pktd8CRa4euMfAQqDTYvmEtiLWUP/AhlK85ad9HUPP1UPDhpoEdhnSth
         xC9J5hZlayc08TRkYm5UCDJ1yOzaS+l65F0RkWAbNFumRi1YYB3aXtzGMXtcxg+ERH5y
         /6Lyqu6ffmNenPrKUrjareirOts/XvLHzBK13bSbSzJpfnALfkaAP+LjWpVLoqyqRcDC
         HZJt8/6LVGX44Bv4P9mXERksydM5iAi2f4aU7zcl7V39HuT25sRgCqB3I7EvyMMg3LVU
         ClGXJTGcwrQIFTB+uU63L/IpRTLhJOKY7kKWHb2r92V/UrCRDThU9S31R6QVIDYYMppt
         ckxQ==
X-Gm-Message-State: AGRZ1gLttBOYgpkPZzdrBwnw40I6KtgY6RoHDTs81/nVyHzrVoytqAfU
        jccqc//BInCKw0jRaqfE54OAJeZ5CGkcxt8ErME=
X-Google-Smtp-Source: AJdET5eRtyhD60zD7KnyAuyXLMeuk5mR2RTUJdszU2tE93D6196mxRKpL8d4Mxn5jujs3MOIofxia2ojLHfuodJrFBg=
X-Received: by 2002:a5b:80e:: with SMTP id x14-v6mr18037612ybp.514.1540905901887;
 Tue, 30 Oct 2018 06:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20181029181141.GA31256@rus.uni-stuttgart.de> <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
 <20181029224558.GE21649@carfax.org.uk>
In-Reply-To: <20181029224558.GE21649@carfax.org.uk>
From:   Eli V <eliventer@gmail.com>
Date:   Tue, 30 Oct 2018 09:24:50 -0400
Message-ID: <CAJtFHURt83LMNoV2U+d-puvfCOmOKfDkt6vQjiUQnVX4NPcWnw@mail.gmail.com>
Subject: Re: Understanding "btrfs filesystem usage"
To:     hugo@carfax.org.uk, remi@georgianit.com,
        framstag@rus.uni-stuttgart.de,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 29, 2018 at 6:46 PM Hugo Mills <hugo@carfax.org.uk> wrote:
>
> On Mon, Oct 29, 2018 at 05:57:10PM -0400, Remi Gauvin wrote:
> > On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
> > > I want to know how many free space is left and have problems in
> > > interpreting the output of:
> > >
> > > btrfs filesystem usage
> > > btrfs filesystem df
> > > btrfs filesystem show
> > >
> > >
> >
> > In my not so humble opinion, the filesystem usage command has the
> > easiest to understand output.  It' lays out all the pertinent information.
>
>    Opinions are divided. I find it almost impossible to read, and
> always use btrfs fi df and btrfs fi show together.

I find the tabular output via -T makes btrfs file usage much easier to
read, and it's now the only command I use to look at it space usage on
btrfs.

>
>    There's short tutorials of how to read the output in both cases in
> the FAQ, which is where I start out by directing people in this
> instance.
>
>    Hugo.
>
> > You can clearly see 825GiB is allocated, with 494GiB used, therefore,
> > filesystem show is actually using the "Allocated" value as "Used".
> > Allocated can be thought of "Reserved For".  As the output of the Usage
> > command and df command clearly show, you have almost 400GiB space available.
> >
> > Note that the btrfs commands are clearly and explicitly displaying
> > values in Binary units, (Mi, and Gi prefix, respectively).  If you want
> > df command to match, use -h instead of -H (see man df)
> >
> > An observation:
> >
> > The disparity between 498GiB used and 823Gib is pretty high.  This is
> > probably the result of using an SSD with an older kernel.  If your
> > kernel is not very recent, (sorry, I forget where this was fixed,
> > somewhere around 4.14 or 4.15), then consider mounting with the nossd
> > option.  You can improve this by running a balance.
> >
> > Something like:
> > btrfs balance start -dusage=55
> >
> > You do *not* want to end up with all your space allocated to Data, but
> > not actually used by data.  Bad things can happen if you run out of
> > Unallocated space for more metadata. (not catastrophic, but awkward and
> > unexpected downtime that can be a little tricky to sort out.)
> >
> >
>
> > begin:vcard
> > fn:Remi Gauvin
> > n:Gauvin;Remi
> > org:Georgian Infotech
> > adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
> > email;internet:remi@georgianit.com
> > tel;work:226-256-1545
> > version:2.1
> > end:vcard
> >
>
>
> --
> Hugo Mills             | Great oxymorons of the world, no. 8:
> hugo@... carfax.org.uk | The Latest In Proven Technology
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
