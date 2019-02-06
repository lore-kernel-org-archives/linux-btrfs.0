Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E66DC169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42D6F2081B
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 15:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="170apggN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfBFPdc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 10:33:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42025 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfBFPdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 10:33:32 -0500
Received: by mail-pg1-f193.google.com with SMTP id d72so3029872pga.9
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2019 07:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FEvXgkpirVZ+HZcF0RGCb7gEhzKhKdADTh7beSAyVkg=;
        b=170apggNjb1rBqJCICuydM5UIIPwgMMLEgbkqNFs00xqqr69lrSko25EUBufPp13M8
         mlhW0gFLf+KbzEaEWh6+179cxirv47jGZUZzsptgcEz+NyNyAKfwrUTDLm6KPwbL4tJ2
         M2NhSYUvVMGrTfKElTdl30VpqtMMC7KNidVSFJP3Bm9cDWlrRasrkuhj+OKql1JpyeHC
         bzd6LAygBXwKLgWBg3AvrHClcoKkaWPdFT/I2rTlB6EpgoCgBrWr/JFxibxT54v376GV
         fZ6SJEhAkG9h0GrsWFYX2ZmjeMfZNBVw/PBA22cVbxb+qqaVK5+sV+hyp8ZfFaSRiRTh
         355Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FEvXgkpirVZ+HZcF0RGCb7gEhzKhKdADTh7beSAyVkg=;
        b=t4zSp93CvnVpZUjTxAFLu5YMWa4fW15KhDnL5xhAlCrmHXW0GKP0YNjhWCcLG9AqTp
         RHktS13hnt5RO9Y8/8kx7GffNoesT9RFsZUvICrUOAy8xQ3Cb88zwT58NU3+nfxSeBMC
         858ovVJuAF7q19zTNC8ZzHB5MRPDK7buMM2hcI/cOrTZgWAqUf+Lg1ydvGqRk3Ilf4lA
         Uj37+s3RmD//EyEpLpK4D/q0xfNzoSMPcDavdv9C69aq26yZnYmzFfFOnVIvPahnaPOU
         bLu/4RgZkAlaESbC4V1fXKd8lMEcebMajWPTSAJrBNA3uebsJ9sT3JJtZfPMSHNDhGR8
         1ogw==
X-Gm-Message-State: AHQUAubujxksbHZX9Dnogy909lX1XSZLeiU37ZhInN5RTM2uoy/L553a
        0S7t5DmfP0awSToAJDM+34xjjwjbrHJu0qdy1AQrAA==
X-Google-Smtp-Source: AHgI3IZ1mY/kDxvhHGT0nl1NoXEJG5dNCLq5VlL2nVJLWAH0dDrWOsQ3/QauSkJsSPGqNPflBvL7/dHYuCphoEH5zwE=
X-Received: by 2002:a62:104a:: with SMTP id y71mr10991095pfi.34.1549467211534;
 Wed, 06 Feb 2019 07:33:31 -0800 (PST)
MIME-Version: 1.0
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
 <20181106143024.GC24115@twin.jikos.cz> <CAOcd+r3CzY2w94Y--9Nb+Fawv_JGFLnK3AgZdYWjNOsKth_aeQ@mail.gmail.com>
 <96ad4db8-024a-2c38-8a4a-8e997bd8b9c8@suse.com>
In-Reply-To: <96ad4db8-024a-2c38-8a4a-8e997bd8b9c8@suse.com>
From:   Alex Lyakas <alex@zadara.com>
Date:   Wed, 6 Feb 2019 17:33:19 +0200
Message-ID: <CAOcd+r1goAEi9yLXJq1x6brJnSbD-r_rpXkAJc_hPiUKhkf0Lw@mail.gmail.com>
Subject: Re: [PATCH 0/7] eb reference count cleanups
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     David Sterba <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, robbieko@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nikolay,

In my kernel (4.14.x) the flag is called EXTENT_BUFFER_DUMMY, and
indeed I see that there is an extra dec-ref for them in
free_extent_buffer().

Thanks for clearing that up,
Alex.



On Wed, Feb 6, 2019 at 4:36 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
>
>
> On 6.02.19 =D0=B3. 16:26 =D1=87., Alex Lyakas wrote:
> > Hi Nikolay, David,
> >
> > Isn't patch 5 (btrfs: Remove extra reference count bumps in
> > btrfs_compare_trees) fixing a memory leak, and hence should be tagged
> > as "stable"? I am specifically interested in 4.14.x.
> >
> > The comment says "remove redundant calls to extent_buffer_get since
> > they don't really add any value". But with the extra ref-count, the
> > extent buffer will not be properly freed and will cause a memory leak,
> > won't it?
>
> No, take a look into the logic of free_extent_buffer and see there is
> special handling for cloned buffers. And in fact, the series this patch
> was part of exactly removed this special handling since it's rather
> non-intuitive, your email being case in point.
>
> >
> > Thanks,
> > Alex.
> >
> >
> >
> > On Tue, Nov 6, 2018 at 4:30 PM David Sterba <dsterba@suse.cz> wrote:
> >>
> >> On Wed, Aug 15, 2018 at 06:26:50PM +0300, Nikolay Borisov wrote:
> >>> Here is a series which simplifies the way eb are used in EXTENT_BUFFE=
R_UNMAPPED
> >>> context. The end goal was to remove the special "if we have ref count=
 of 2 and
> >>> EXTENT_BUFFER_UNMAPPED flag then act as if this is the last ref and f=
ree the
> >>> buffer" case. To enable this the first 6 patches modify call sites wh=
ich
> >>> needlessly bump the reference count.
> >>>
> >>> Patch 1 & 2 remove some btree locking when we are operating on unmapp=
ed extent
> >>> buffers. Each patch's changelog explains why this is safe to do .
> >>>
> >>> Patch 3,4,5 and 6 remove redundant calls to extent_buffer_get since t=
hey don't
> >>> really add any value. In all 3 cases having a reference count of 1 is=
 sufficient
> >>> for the eb to be freed via btrfs_release_path.
> >>>
> >>> Patch 7 removes the special handling of EXTENT_BUFFER_UNMAPPED flag i=
n
> >>> free_extent_buffer. Also adjust the selftest code to account for this=
 change
> >>> by calling one extra time free_extent_buffer. Also document which ref=
erences
> >>> are being dropped. All in all this shouldn't have any functional bear=
ing.
> >>>
> >>> This was tested with multiple full xfstest runs as well as unloading =
the btrfs
> >>> module after each one to trigger the leak check and ensure no eb's ar=
e leaked.
> >>> I've also run it through btrfs' selftests multiple times with no prob=
lems.
> >>>
> >>> With this set applied EXTENT_BUFFER_UNMAPPED seems to be relevant onl=
y for
> >>> selftest which leads me to believe it can be removed altogether. I wi=
ll
> >>> investigate this next but in the meantime this series should be good =
to go.
> >>
> >> Besides the 8/7 patch, the rest was in for-next for a long time so I'm
> >> merging that to misc-next, targeting 4.21. I'll do one last pass
> >> thhrough fstests with the full set and then upddate and push the branc=
h
> >> so there might be some delay before it appears in the public repo.
> >> Thanks for the cleanup.
> >
