Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A07C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 03:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B182075C
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 03:21:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="gbrPWJSy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfCKDVE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 23:21:04 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:42844 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfCKDVE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 23:21:04 -0400
Received: by mail-lj1-f169.google.com with SMTP id d14so2686521ljl.9
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 20:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DTvuUpxtRh/LhZhMXHCTNULFlEzi9y++B8yPcQL3r4A=;
        b=gbrPWJSysUznTvix67Vl4pHj8sLMghNqlIKskDZ5RgawE8j070aRZ1zfOdA3pSofCv
         Zb9bdTU7M0sjSCOOGscc83XzpmKkhY1jeMHEEoULVYvR0Cx88wp+FL73AaDtUkTytCne
         CmEDPw9zVqfD2ygWYP4EndJ8JYmy+fclVJZy6zT7Sm1dd67JzA0fOhhLyjiFHRLnVGWH
         8Gq3787P2yPwV175twF8kg4yMrgwvHaM/GlgSvEcO0MsLq8xiiGiQuYTphWk9UvEZXxP
         3BJkLNmBH3pOBqfBCnB8PrWO4kIXviptdINpw3imliCRPLEI3onwlHVfILubqM6y25ts
         fc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DTvuUpxtRh/LhZhMXHCTNULFlEzi9y++B8yPcQL3r4A=;
        b=jF58GNeiSiBd/F/7JPTSph+5bwoW7BTGdd9ljdWDeAoctVbeLLcaFCRL+gi/G0VKj1
         wRIlmDohQOfhapHZv2DeapKS5Wv0+pTPWxjoGLr+NTaajEBKV/l9isBcQscclHuxpU3M
         OnX9KBnDS6GCo4paBMRgS8yBX/fhAk1/k+xPbrOQgq8nbTVtujjIc8CXm3qDu6LCCYY+
         P5vNyfbfAHJVLzxqnrd4FgSGcc9AXUm8NSrdneDoPSyC9hfKoImxxcm1jhU7u3PN7rGJ
         nHCp668rFrz8FgTVdQbyCTE/YPQ2n3kh1sCtYKy8TydT3RWhrSLL9KyfZah8cOTAgUU4
         O5NQ==
X-Gm-Message-State: APjAAAVk4HThx8jjSatz3hiAoauJ2papmNzCqaiejtbvdicXMYc1zcZF
        yY1ndau40avmbh4XAO/yAxzOJSEC+IRttdVn1VHSRA==
X-Google-Smtp-Source: APXvYqw/mGzzNFBN97IbvwW7OpbhBrrq9nIqVwPsywUOPVtz/AEhecQhgqGR7Fbhqg/SsJJptZupNW9x4GZ0gx7lAJk=
X-Received: by 2002:a2e:870c:: with SMTP id m12mr14674220lji.24.1552274462181;
 Sun, 10 Mar 2019 20:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQ9nduarOggGv98Oxo6SE9QBKhm7oxYXFE9UsMbVTnwow@mail.gmail.com>
 <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
In-Reply-To: <cf8922ef-b7db-7779-c140-80090efc60d5@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Mar 2019 21:20:50 -0600
Message-ID: <CAJCQCtRVT9Fpy0Knj44m0BN80d-PidUfHPJ0d9VJkag7B-KXTQ@mail.gmail.com>
Subject: Re: confusing behavior when supers mismatch
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 10, 2019 at 7:18 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/3/11 =E4=B8=8A=E5=8D=887:09, Chris Murphy wrote:
> > In the case where superblock 0 at 65536 is valid but stale (older than
> > the others):
>
> Then this means either the fs is fuzzed, or the FUA implementation of
> the disk is completely screwed up.

Fuzzed in this case by me.

(Backstory: On linux-raid@ list, user accidentally zero'd first 1MiB
of an mdadm array which contains Btrfs, but has a backup of this 1MiB.
So I was testing in advance the behavior of restoring this 1MiB
backup; but I'm guessing upon zero the working file system may have
changed as it's not unmount, and in fact probably very soon after
zeroing, wrote a good super replacement anyway. It seems the only
missing thing we need is LVM metadata, maybe.)


> So IMHO always use the primary superblock is the designed behavior.

OK interesting. So in what case are the backup supers used? Only by
`btrfs rescue super` or by explicit request, e.g. I notice even with
an erased primary super signature, a `btrfs check -S1 --repair` does
not cause the S0 super to be fixed up; and `btrfs rescue super` lacks
an -S flag, so fixing accidentally wiped Btrfs super requires manual
intervention.


--=20
Chris Murphy
