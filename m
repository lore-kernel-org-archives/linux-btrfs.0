Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8ACC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2DA20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQzlR2Ih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfAVQDz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:03:55 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39754 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfAVQDz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 11:03:55 -0500
Received: by mail-yb1-f195.google.com with SMTP id s17so8755909ybp.6
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 08:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xf+CB5dO7OqXt2u11HinB7Y/P9acjgCESHKTELPDDNU=;
        b=GQzlR2IhoMJfIPiA+Uv7P24yAv8/PHxJcMAYIAr3Y24Q6+Mzg0n6xhuIlVFnBFlgkY
         vUaJx4h8b6wV0zcKDf1WH9m21/C20cN/csZdpfh4tkRQqYvPypKD/9sJdutNIb8qJK0z
         C+4BFTAzMUy0NoNkrQEylkme/hJ/B2ZvEohBz6oSZlLNL7PU6zmcnEWDJCV7S/tsG1Sk
         vHpIpEXmwUW87Y9e7j1KS2Su9a282z5ZztOoieh00QaO/7vkQObGCaxmW1q1ByQ6J+dO
         86TMYA+IAVoNIjXVz5R5KEXBIhd4YwhWBhxSGCuQUcRZajS9V7C6w4x+wsfdzbYlXUWq
         Ty3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xf+CB5dO7OqXt2u11HinB7Y/P9acjgCESHKTELPDDNU=;
        b=a7pJ9V8kyhPJgMfzIQZa66nLIVDD5yhCa60HfA3VAfo9RXgGDrTH4tgymxrAnZJRm4
         qMQUHck+FfEdb3nRHzqumrL8Z0yspysiH59O478QwD/iK1iuTxTo+8UMDCufdxyg+ZzF
         P01x67IqA16YIp2LpSJmAM5/hTb+bb6dDS2O4N9AoRdfXTwdnE+EU7eRREqcbwHSJlnu
         3NliPMbicJqr05HuLwlvSSdIGPEhu4RT1Qy437jf2z6t7Ru8zEW8KFXkIhLcIqj+jpUA
         ibXJdk+e46j94W6BP+hWy/cVtY528jIxwdAXaZq2d/gz4AwukzcSuCXNUKXS610HO71D
         MZBw==
X-Gm-Message-State: AJcUukf2G4EfYxUal3DqKaA+uUYEJzxa/W/FMCr2Q6ZUrmg5KjLMnCOd
        VC/HdU6+e7Fr2et1XThWTSRDNpwKdFmntvT3q9Kssw==
X-Google-Smtp-Source: ALg8bN5fR0Pk6vbBziyQcA1KjdkARkEp1s3iCO4VZh7ZPvBYI16W2FHuNtKvJqlHriV5tMxo3yfWyJeXSIL5S3/flRw=
X-Received: by 2002:a25:ba0e:: with SMTP id t14mr21146647ybg.206.1548173034171;
 Tue, 22 Jan 2019 08:03:54 -0800 (PST)
MIME-Version: 1.0
References: <CAJtFHURMDnM9EMAeLE4yr-UbWHa=o8M0=Yvm-MZp8ixWykfxFw@mail.gmail.com>
 <CAL3q7H4HsGMLS5mjTLSugQ-YoF-M24Fy6eCEAF9=04g_=A=jFA@mail.gmail.com>
In-Reply-To: <CAL3q7H4HsGMLS5mjTLSugQ-YoF-M24Fy6eCEAF9=04g_=A=jFA@mail.gmail.com>
From:   Eli V <eliventer@gmail.com>
Date:   Tue, 22 Jan 2019 11:03:42 -0500
Message-ID: <CAJtFHUR8G927m1bx3UEgps9-dxPbZh+j4JTvzAn-yqcKRMLfTg@mail.gmail.com>
Subject: Re: btrfs receive deadlock and questions
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 22, 2019 at 10:42 AM Filipe Manana <fdmanana@gmail.com> wrote:
>
> On Tue, Jan 22, 2019 at 3:26 PM Eli V <eliventer@gmail.com> wrote:
> >
> > I seem to have it a deadlock trying out btrfs send & receive. Now I
> > haven't used btrfs send & receive much, so don't have much experience
> > with them. Anyways, bug report and stack traces:
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D202383
>
> This is the same you reported at:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D199753
>
> It just happens through a different path, unrelated to send/receive.
> You are running a 4.19.16 kernel, which doesn't have the fix [1]:
>
> $ git tag --contains 5ce555578e0919237fa4bda92b4670e2dd176f85
> v4.20
> v4.20-rc1
> v4.20-rc2
> v4.20-rc3
> v4.20-rc4
> v4.20-rc5
> v4.20-rc6
> v4.20-rc7
> v4.20.1
> v4.20.2
> v4.20.3
> v5.0-rc1
> v5.0-rc2
> v5.0-rc3
>
> All the deadlock problems you reported are fixed by [1] and [2].
> The second, related to the free space tree, is very recent and only on 5.=
0-rcs:
>
> $ git tag --contains a6d8654d885d7d79a3fb82da64eaa489ca332a82
> v5.0-rc2
> v5.0-rc3
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D5ce555578e0919237fa4bda92b4670e2dd176f85
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Da6d8654d885d7d79a3fb82da64eaa489ca332a82
>
>

Sounds good, thanks for the links. I thought the stack traces looked
different, thus the 2 different reports. I guess no further info is
needed from the hung tasks and I can start killing it and figuring out
how to resume the process.


> >
> > Seems like the receive is hung as well as several kworkers. It's about
> > 1.2TB into a 9TB or so transfer onto a brand new pretty empty fs. This
> > is just a btrfs send snapshot, not an incremental. That was supposed
> > to come next. If this was an rsync based backup I'd just kill the
> > rsync process and restart it, not sure if there's a way to restart a
> > btrfs send receive, or if I'd have to delete the partially created
> > snapshot on the destination and restart the send. I guess I could just
> > use rsync to finish the copy of the initial snapshot as well before
> > using send | receive for the incrementals. Thoughts and options would
> > be appreciated, thanks.
> >
> > -Eli
>
>
>
> --
> Filipe David Manana,
>
> =E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you'=
re right.=E2=80=9D
