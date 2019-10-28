Return-Path: <SRS0=wtRv=YV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE91CA9EBC
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Oct 2019 10:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7DD208C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Oct 2019 10:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sCGkd/XW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbfJ1KW4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 06:22:56 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37484 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732818AbfJ1KW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Oct 2019 06:22:56 -0400
Received: by mail-lf1-f66.google.com with SMTP id b20so7363319lfp.4
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2019 03:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RjcdF2o+dnlHbSjozipmAlyiuOntUw4F9PaHstQ80N0=;
        b=sCGkd/XWplQt3wj3eLp8s7VJy3uadqADNOWMHLRRfyR+E67sHXQfW7/lbVVWW9hCuk
         RMxNkfYsFi7OYTviZGlx0jf6BkYY0YEHv3of7pPIdaVgS41/2Yxup32BAh1iudAjA+uy
         mjNP5aKKvH4Tv91G5Zqavb7KZCNv+glldr3OWc3BGHTn6/K23POiGaP9IYKBLnq2zUFm
         75yccdN7OFagboWVOE9I1nidaueJjLQy2FYIBnZE6Wg41nda248q79eq2du8RquPGfe4
         5JGv8hjle/HNGQAmY9wGXFJAbbD8SYXLe4mPohq4O24EuUcT3fDfX/2fmvaAFsTI+e3D
         i0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RjcdF2o+dnlHbSjozipmAlyiuOntUw4F9PaHstQ80N0=;
        b=L4cVPkmkIYzzfgxhO/rtqxYNkJTpFy4L9DisW9HaR8K5K5dD1j1ro/XC4ddEZ4aYVH
         q7XxbZEpJ13BMDCL6VBvKk/e11WQhVKpFqcl1gO/7ItGhdJIgL7TTHMeZULDYKx+q0fR
         fQbjL+NYkebgYLHr03RSvwgygO4s01qmxTuU7x84HX7XfE4D/blSnLq0eRsw431RfKDF
         k1GZISgIHZpo0WCDFGb45mK+Q63b7K4jFNqCGVGkB7xlsEVXrmuIzepgSAdE9XT/xGW0
         M4gk/eK0PSXPoagTkgqcupT+/7tXEVHfVwG0pZTiukehPgjvWA88g5y4cK0EcrpJ6wCs
         P4OA==
X-Gm-Message-State: APjAAAXYx0J7a0Nlp2pxrB4JAjhyXEldWe9q/ZYt28kB+yyFzFYshltE
        UqnuyMW5IM3fYM9gwLoAtvKn3wbQxhXQPmamqkU=
X-Google-Smtp-Source: APXvYqzVL7mHXclala03Bs7VaqOCvpUtlOvgCpIoy1KM0gkwN8oZrWBLH2ZH9otD0onZISGj7dK4evYcYlhlYyWdrFw=
X-Received: by 2002:a05:6512:40e:: with SMTP id u14mr11055409lfk.73.1572258172547;
 Mon, 28 Oct 2019 03:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <CALpSwpjVz=F_hb9DbVanECsfWOYog2B7SLY=Dy0NvQx=w9voDA@mail.gmail.com>
 <f4037f43-97fb-5a25-52db-2d69ec69f6ee@suse.de> <3acc15f7-fe1e-6672-8a89-fba9a09561d4@suse.de>
 <29cae854-b5e2-73d6-fc83-51cf1f162e30@gmx.com> <d1816326-f7e7-3ab5-347d-bb84764e8efb@suse.de>
In-Reply-To: <d1816326-f7e7-3ab5-347d-bb84764e8efb@suse.de>
From:   Peter Hjalmarsson <kanelxake@gmail.com>
Date:   Mon, 28 Oct 2019 11:22:41 +0100
Message-ID: <CALpSwpheGWtjOL8631ne+5TXkPmoud6BrBLcsVRs7moydhbnkQ@mail.gmail.com>
Subject: Re: "BUG: kernel NULL pointer dereference," when unmounting
 filesystem hitted by enospc error
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks!

5.3.7 hit my system from the Fedora repos just a day or two after my
last mail, and spent last evening trying to reproduce both the problem
the scripts shows, but also the problem I tried to track down when
making the script. Both seems to be gone after upgrading on the
systems I have been able to run the test on so far.

Best Regards,
Peter hjalmarsson

Den m=C3=A5n 28 okt. 2019 kl 08:50 skrev Johannes Thumshirn <jthumshirn@sus=
e.de>:
>
> On 27/10/2019 14:24, Su Yue wrote:
> [...]
> >
> > Interesting thing I met too. That's not reproducible on my VM but
> > host (Archlinux v5.3.6 same kernel config).
> >
> > What's more interesting is that v5.3.7 seems to have fixed the bug.
> > After some bisect. The commit is
> >
> > commit 417d26300214f7b593a99c6bc8badb66492ae322
> > Author: Qu Wenruo <wqu@suse.com>
> > Date:   Mon Sep 23 14:56:14 2019 +0800
> >
> >     btrfs: relocation: fix use-after-free on dead relocation roots
> >
> >     commit 1fac4a54374f7ef385938f3c6cf7649c0fe4f6cd upstream.
> >
>
> Good catch, cherry-picking this commit on top of v5.3.5 resolves the
> issue in my setup.
>
> --
> Johannes Thumshirn                            SUSE Labs Filesystems
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5
> 90409 N=C3=BCrnberg
> Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
