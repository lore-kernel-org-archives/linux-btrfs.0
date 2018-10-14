Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21623C71122
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 23:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D0E20652
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 23:38:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="QmUlaMlD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1D0E20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbeJOHVO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 03:21:14 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40850 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbeJOHVO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 03:21:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id t22-v6so12792542lfb.7
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2018 16:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=LUNugbt/1ew1rW0p/524hiCRVZqQBBDUxk/RiJI6Qho=;
        b=QmUlaMlDZOiJ+LbuGPedrHpZMPLBSiSzDBhJzcxwE7y9/qmCAMXbftpYTlVjbDeIQR
         uZtv6Kd+YFoQcoJhVRhZNCJbIwTyGje9sz5ddzYRCs0KkrdEuOM6W1iarEZG8IEkLRV1
         T7usv9cdTzn4IjPlmaWfdUeN9IPJujTWsHFsksnB/DtOwA6Fy5hYfB2FnccU0G33ZEjW
         439U0H3Hp3qPaAcLyYyoKDoBZJUWEY9M2aJvV63+2E0YHIAlIQB7l6mAFPCrgWcBr5C3
         SKLTzIgg3KJvOPv2luBbKjOc2agP9qupjWjrtD7fEIqtttVTTmDilrE+oyFTPb2gjdUW
         yQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=LUNugbt/1ew1rW0p/524hiCRVZqQBBDUxk/RiJI6Qho=;
        b=s7lxcYLFMWQPO1PijGgG6vAhZrC1omdxGMkXCm4n+o2vppGykkBPgLxnXbmRugW/Ix
         PSf7Gj3r0ifsR2i3zLdy0le0SjRIW6Uijqo+GiFgHOQ6Or9Z0ygRgxMmyQ0UGhAQBcrk
         EeQ7tGAbtQHWlJTWpB79pGD6ZEoBQGuaBbmrxjCjDOLN90B6kTAU7Y4tuNb4FCoD5uDR
         qiH1+jDdEpP6CrbIrkTYBhEBaEmu7VfBt3fLHe6D+Fi4PuxJeaGOQ2XUfrnEgkvpesqO
         J9/GMXW4TnutxVgPnggpVbPJa9j4PIE4/zAMHQIasXSUxv+H3HJiRsS7IQYkgnWmgRW+
         J5ow==
X-Gm-Message-State: ABuFfojNW5CpnDUeLbnVC97yJq1RHeC5I5vWMvHw9Ek57QH9d2ySE/pH
        vrJyxR9xdvFLgMsTV70tv614rFJ2J4GBvA8ikfuIsg==
X-Google-Smtp-Source: ACcGV61v1KDQ9nkE+eUmMit3EXvPvOQpAOv88gjVZy+/OcbETMlx/Vbt13A3aVXo6g59ZXTvwM2W3OlnGy6mhcRKyZM=
X-Received: by 2002:a19:e013:: with SMTP id x19-v6mr8100959lfg.89.1539560312459;
 Sun, 14 Oct 2018 16:38:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Sun, 14 Oct 2018 16:38:31
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <CAN4oSBcs=3BgdcREN_ukEFu09v8QxP7-jYX7a0PNW-tctLLk=Q@mail.gmail.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <CAJCQCtT2ackbOo1QPkaj5W+LXnJx5VUMvbxbD0VmcenWz_85pg@mail.gmail.com>
 <CAN4oSBevO04cV+DyGxXg60nBbYB7UANFZzMcWV1M0S6HpHYc-w@mail.gmail.com>
 <CAJCQCtQkY0_2J8HHp8HmoT523nhWr7nFwHhjHZ_cfoSXoWoDWg@mail.gmail.com> <CAN4oSBcs=3BgdcREN_ukEFu09v8QxP7-jYX7a0PNW-tctLLk=Q@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 14 Oct 2018 17:38:31 -0600
X-Google-Sender-Auth: vLP4l2D9cc_X2OPjRmfZWypqeMs
Message-ID: <CAJCQCtR=pJxXN5RWy3H5xEfnbn5eC-gQpV9UWfjXc9YZyfuTMA@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 1:09 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> Thanks for the explanation, I got it now. I still think this is
> related with my needs, so I'll keep an eye on this.
>
> What is the possible use case? I can think of only one scenario: You
> have a rootfs that contains a distro installer and you want to
> generate distro.img files which uses Btrfs under the hood in different
> locations and still have the same hash, so you can publish your
> verified image hash by a single source (https://your-distro.org).

The first step is accepting reproducible builds as a worthy goal in
and of itself independent of Btrfs. Specifically "Why does it matter?"
found here https://reproducible-builds.org/

Btrfs does bring valuable features for installation images: always on
checksumming; seed feature permits a straightforward way to setup a
volatile overlay on zram device; ability to convert it to a
non-volatile overlay, and boot either the seed or overlay; and even
installation by adding the install target and removing both overlay
and seed. And yet it remains compatible with a conventional copy to
another file system if it's not desirable to use Btrfs as root. Win
win.

By subsetting Btrfs features we don't care about in the installation
seed context, can we achieve reproducibility as a consequence, while
retaining some of the more interesting features? Of course once
sprouted, those limitations wouldn't apply.

Basically it's a "btrfs seed device 2.0" idea. But Btrfs is so
complicated it's maybe too much work, hence the question.



-- 
Chris Murphy
