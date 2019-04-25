Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DBDC43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415F62081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7rl2M2G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfDYOnR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:43:17 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33429 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfDYOnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:43:16 -0400
Received: by mail-vs1-f68.google.com with SMTP id s11so36748vsn.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Fapv+7qlLfunEHLr7B9kDxfp5XLaE5FloEObJrw6kDg=;
        b=B7rl2M2GzAo2riESrrADcbTLlqROx3OXydV+AWvh3muakqhtr2sCaFO+ZwaoIewFSV
         7GW9+ZBqjW8dKEgq4g4tuxYL71roKKqowQfqkymk2Oz3Uxj1hP9chea7205rYF+/kS9Q
         UKuPkgiiAvYuJr2fZhZl5y5UlFt7F7a4ntyfjUNXuYPaaWl/xGWk2J0bZly7PLxtf3j3
         h1RVOFbFInpl8Fb+KeiCXn4D6huK+w1mnHASyaUIA0Szzz9FQKK93UPKHzshyA7GzRas
         S3aVlWtrtC5ici/GJfPnS+3yBsL4YN0/7YelsklhnUJy4yEKdS0H3obVJF3AW3ABCaGG
         6Yfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=Fapv+7qlLfunEHLr7B9kDxfp5XLaE5FloEObJrw6kDg=;
        b=oWRSKoPwkRvhjqoYS0jTTTtpg2eZAbC+lRRRtX12zTQ06w+ml2HSS0Wwke33Wp455U
         6e/ZKv/PIZtnn5GetbbbuPVH2sCZdxyiSmCZiGRuCQBIFTNlPBJnjLHbUQESBsGSnYmE
         XtjHz+j3tW0daKP5aOdpnglYW0vneFnc4knBh1RQTVH++K26VO9OwoCzt8TOKvFmuznU
         Fnh9yBKrP7L9qo9ia6tg5Fg4rKtPK9uEQmlmvLRPkR45lg9WXyyg5nbigvCDKwy91S8b
         3DspUapLkwKg1yC9GpDC5VWX7ty1KozUrkmyxhNbK8MZOnNOc0mwwr35ttT7ZxNVATh0
         taqw==
X-Gm-Message-State: APjAAAVaR/4V7Bym7uG/JRkH9zOdkYXzdDL1ChSNUxTC74tsP+H2D6vB
        LQSxNUoN+xjpAJ9FIJXSD0AvINm21ErBgUaj128=
X-Google-Smtp-Source: APXvYqxbpG6WmjjTSbuoBmYFYB3TVbVM4UBoLiM3hHbyh/I52Q4VsFqsiOvcz83If2MsJUiPrfm+t7eIqyZL7VF6MxQ=
X-Received: by 2002:a67:6847:: with SMTP id d68mr20859325vsc.90.1556203395958;
 Thu, 25 Apr 2019 07:43:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com> <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
 <6ce51e68-c120-ee5d-1ca3-4a6ae0727670@gmx.com> <20190425140957.oajm7seece2wfniz@macbook-pro-91.dhcp.thefacebook.com>
 <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
In-Reply-To: <45eb63d3-affc-b4c1-d2ca-aad0ab55661c@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 25 Apr 2019 15:43:04 +0100
Message-ID: <CAL3q7H6stfupF+npJLmukqfj8yZ0MRMf9Y4BkS1GLWjN1NPPTQ@mail.gmail.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, dsterba@suse.cz,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 3:28 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/25 =E4=B8=8B=E5=8D=8810:09, Josef Bacik wrote:
> > On Thu, Apr 25, 2019 at 09:50:25PM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/4/25 =E4=B8=8B=E5=8D=889:25, Josef Bacik wrote:
> >> [snip]
> >>>>>
> >>>>> What if the commit is reverted, if the problem is otherwise hard to=
 fix?
> >>>>> This seems to break the semantics of fallocate so the performance s=
hould
> >>>>> not the main concern here.
> >>>>
> >>>
> >>> Are we sure the ENOSPC is coming from the data reservation?  That cha=
nge makes
> >>> us fall back on the old behavior, which means we should still succeed=
 at making
> >>> the data reservation.
> >>>
> >>> However it fallocate() _does not_ guarantee you won't fail the metada=
ta
> >>> reservation, I suspect that may be what you are running into.
> >>
> >> For this script, we only needs 4 file extents at most.
> >> Even the initial 8M metadata should be pretty enough, thus I don't thi=
nk
> >> it's metadata causing the problem.
> >> ---
> >> #!/bin/bash
> >>
> >> dev=3D/dev/test/test
> >> mnt=3D/mnt/btrfs
> >>
> >> mkfs.btrfs -f $dev -b 512M
> >>
> >> mount $dev $mnt
> >>
> >> fallocate -l 384M $mnt/file1
> >> echo "fallocate success"
> >> sync
> >> dd if=3D/dev/zero bs=3D512K  oflag=3Ddirect conv=3Dnotrunc count=3D768=
 of=3D$mnt/file2
> >>
> >
> > Wellll we don't do the nocow check _at all_ for O_DIRECT, so mystery so=
lved
> > there.
>
> Oh, wrong flag, remove that oflag and we still get the same problem.
>
> fallocate success
> dd: error writing '/mnt/btrfs/file2': No space left on device

I don't get it. Why is this unexpected error?
You created a fs with 512Mb, fallocated 384Mb for a file named file1,
and then tried to write 384Mb 512K * 768 to a file named file2 (i.e. a
different file).
Wasn't the test supposed to write to file1 instead?

> 95+0 records in
> 94+0 records out
> 49283072 bytes (49 MB, 47 MiB) copied, 0.0807034 s, 611 MB/s
>
> Thanks,
> Qu
>
> >
> > Josef
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
