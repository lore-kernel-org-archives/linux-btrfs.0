Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99923C7112A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 19:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59F0C2064E
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 19:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ceremcem-net.20150623.gappssmtp.com header.i=@ceremcem-net.20150623.gappssmtp.com header.b="cPVU8Kta"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59F0C2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ceremcem.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbeJOCvz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 22:51:55 -0400
Received: from mail-vk1-f177.google.com ([209.85.221.177]:46157 "EHLO
        mail-vk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbeJOCvz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 22:51:55 -0400
Received: by mail-vk1-f177.google.com with SMTP id h186so2625863vkh.13
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2018 12:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ceremcem-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H+vJwuhmqCrNMleUBQYgLgf3Vmac7IUKrgx2SZJVzVY=;
        b=cPVU8KtaxbU64BDauppO0rLU/fRjiqXL1UX6h5XDMB68iNHl3ptHACyrY+sK9SkAsF
         iPyLNQUt7opP9JUDtEO5clb1gm++isDvSYg7y0VH9p6rnjAuVuS9F8TY/oVQItTX02bi
         8bSW/mQH/ochMi7jvfMhqXrcvG3d0ktR2lbe9fGSH3aRxlS9CK2hVitIXFvrdHzyXhkt
         G6BmPyf1ksnw/2PXuhmX7NKK7pCc+MX3LegZ5dI5/76s5bKsd4cr4BVFw3io5sGFfhr3
         Ww+fMNkUD4I+UBHpKYZy3oPPAb98obxAO9Qk/XGqgp67Hk12tz3My43RvDGe3EVx6MXR
         Vx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H+vJwuhmqCrNMleUBQYgLgf3Vmac7IUKrgx2SZJVzVY=;
        b=Plo7BgslwGpYJ80Rc1ends81NANRjmtzKSRRtHgBRuKAbJhdjkTZ2VHiyYska5FnkI
         3O0tkA97QIvX8AivmRKsyaGZ9EScisPN38u+Pb/xDlDCPoauDvmm9/9Afx0RGleND3yB
         UGa/mRqw44hbpjPWedHFfseLZnx+xJsUeQgqFpMPv+nvqihb7x5q8D82uGcdFhlX7TiC
         QP4L5wPBvIe3rd+2UrFW2j6c+wRGHkfEQObUSDQdx12nYW6lx4gOtAiPWCk1iPRYPjMc
         fCagKlPGvSHJ91vye4tOwpslB4Hhtu7Vfp4SEinLP5nW3P+5tKSGlbfXqonMLke83HoW
         CZUw==
X-Gm-Message-State: ABuFfoi4oHhHfvoJnzmfuwMXfA8jQBIweNWolQ2WER9fFUJFmOF4OEw6
        rv57DzsFQgC5/sn/QF62vGGw6OspS5JsNsavmSYC93Lq
X-Google-Smtp-Source: ACcGV615gPLxiTW2qHfDsf6P83UFIIgjGy83P9k5t6Os6q9FtrgOucPJX1EXXj+hyZ6chZ6CCJBf1SWCBnFbWH3/w5w=
X-Received: by 2002:a1f:c08e:: with SMTP id q136mr1999496vkf.84.1539544194739;
 Sun, 14 Oct 2018 12:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com>
 <CAN4oSBevO04cV+DyGxXg60nBbYB7UANFZzMcWV1M0S6HpHYc-w@mail.gmail.com> <CAJCQCtQkY0_2J8HHp8HmoT523nhWr7nFwHhjHZ_cfoSXoWoDWg@mail.gmail.com>
In-Reply-To: <CAJCQCtQkY0_2J8HHp8HmoT523nhWr7nFwHhjHZ_cfoSXoWoDWg@mail.gmail.com>
From:   Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date:   Sun, 14 Oct 2018 22:09:43 +0300
Message-ID: <CAN4oSBcs=3BgdcREN_ukEFu09v8QxP7-jYX7a0PNW-tctLLk=Q@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>, anand.jain@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the explanation, I got it now. I still think this is
related with my needs, so I'll keep an eye on this.

What is the possible use case? I can think of only one scenario: You
have a rootfs that contains a distro installer and you want to
generate distro.img files which uses Btrfs under the hood in different
locations and still have the same hash, so you can publish your
verified image hash by a single source (https://your-distro.org).
You'll sync next release files with the remote servers by using diffs
(btrfs send/receive) and they will generate distro.img independently,
still having the same hash that you'll later verify by
https://your-distro.org.
Chris Murphy <lists@colorremedies.com>, 14 Eki 2018 Paz, 21:10
tarihinde =C5=9Funu yazd=C4=B1:
>
> On Sun, Oct 14, 2018 at 6:20 AM, Cerem Cem ASLAN <ceremcem@ceremcem.net> =
wrote:
> > I'm not sure I could fully understand the desired achievement but it
> > sounds like (or this would be an example of selective perception) it's
> > somehow related with "creating reproducible snapshots"
> > (https://unix.stackexchange.com/q/462451/65781), no?
>
> No the idea is to be able to consistently reproduce a distro installer
> image (like an ISO file) with the same hash. Inside the ISO image, is
> typically a root.img or squash.img which itself contains a file system
> like ext4 or squashfs, to act as the system root. And that root.img is
> the main thing I'm talking about here. There is work to make squashfs
> deterministic, as well as ext4. And I'm wondering if there are sane
> ways to constrain Btrfs features to make it likewise deterministic.
>
> For example:
>
> fallocate -l 5G btrfsroot.img
> losetup /dev/loop0 btrfsroot.img
> mkfs.btrfs -m single -d single -rseed --rootdir /tmp/ -T
> "20181010T1200" --uuidv $X --uuidc $Y --uuidd $Z ...
> shasum btrfsroot.img
>
> And then do it again, and the shasum's should be the same. I realize
> today it's not that way. And that inode assignment, extent allocation
> (number, size, locality) are all factors in making Btrfs quickly
> non-determinstic, and also why I'm assuming this needs to be done in
> user space. That would be the point of the -rseed flag: set the seed
> flag, possibly set a compat_ro flag, fix generation/transid to 1,
> require the use of -T (similar to make_ext4) to set all timestamps to
> this value, and configurable uuid's for everything that uses uuids,
> and whatever other constraints are necessary.
>
>
> --
> Chris Murphy
