Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFBEC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 04:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0457D2070C
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 04:52:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="RmpuIaHu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfACEwS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 23:52:18 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35286 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfACEwS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jan 2019 23:52:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id x85-v6so28743733ljb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jan 2019 20:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DtvpNFrt6O5Pw6dussjOXvFAMWms5u448XokiI+K6G8=;
        b=RmpuIaHu0hvNtoQmFCLkOVaT46ChTEZqfn3eNMDoZO6ugJNbatIfUlRbsKTsRzOGII
         5Dv9WKDAbts1rmmf/q5nFKJ+5iDyZMq8dxoX2/FGfLYr3sj4Cv9E+zqanLhNohvuIzM4
         qdOuQQudAXlZQTyTnO29aepwZi0iXxVcAymlZrTOiD+Rfo7PhaR9hpeYw4CSFAM0MHT9
         8Hv/2Sz3Gs4FIGLTjS/f1yve4aLiOjFzdLUu6AghNZ2C/vMi4QiBsX9FH6q5WKE78xnL
         whagZqm0n6+SBzEPgZLrhIoLh4JQoOyaa2TANR7J77PbnmVGyazb6UkgCunplc0jdd1Y
         dLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DtvpNFrt6O5Pw6dussjOXvFAMWms5u448XokiI+K6G8=;
        b=iIse1rUIcSRQrhQracIS4sy9MzYHTrwG5F2vS7953y+oGIw00VL29Xe11tYrpVfn5d
         1HH3J1+hcJ9W9zaC8c5ti7ToxKMfJDiV1RyDHnh9bfT7tOjvzkvCMzzWSCp1Pi6tgRhv
         gyzsSpBJ8R//9s8wVvU9Aphlu/hbfQ1Xc+3/B7j8HjBjKfUGLy1i1DoTdkIe8CMZ1gjq
         u93qBejR2qDdh6DwKOygSPo837r8kqub/XyxhlM8hOslpe9Z5/IvcFukoVNCksdFjY2l
         pzck67MhofyEsBPJuwENdTeJD5nlZLsNZlSGC582opT91f3RCGbS0cKYviHx6Imr2xEU
         Yf5g==
X-Gm-Message-State: AA+aEWZ8lQ9wVA8uIVVUwc26/1pVXoEbE35B15melXY3ssboFIOe/Lnq
        CSqeNx+TO+MrfycEMhl3I6EBBKbDs91MqVTgl1soBA==
X-Google-Smtp-Source: ALg8bN6+njAGnONdgOZcwtg4x/TV2F47v2CkMHmSNU6VeS15U6mkVCNWBHiJYh2AKksFP0nt8W5QJnjwhKRtoSfdDH8=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr28166591ljh.174.1546491135407;
 Wed, 02 Jan 2019 20:52:15 -0800 (PST)
MIME-Version: 1.0
References: <DID7NmLoqB1WBZ8Vo7rEMlL9cLWv7Bz9F04MkQYOLfZJyl04O44IUiFKdC_Tl4iSvHGLxpbwDwD9cHJ33t-Hkv8PKF0wmm7201RABA2kRAY=@protonmail.com>
In-Reply-To: <DID7NmLoqB1WBZ8Vo7rEMlL9cLWv7Bz9F04MkQYOLfZJyl04O44IUiFKdC_Tl4iSvHGLxpbwDwD9cHJ33t-Hkv8PKF0wmm7201RABA2kRAY=@protonmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 2 Jan 2019 21:52:02 -0700
Message-ID: <CAJCQCtR8qEyw51Ox2jU1E4nWBVfV4j8_nEcMgz2gTJa=yhv=Tw@mail.gmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
To:     b11g <b11g@protonmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 2, 2019 at 5:26 PM b11g <b11g@protonmail.com> wrote:
>
> Hi all,
>
> I have several BTRFS success-stories, and I've been an happy user for qui=
te a long time now. I was therefore surprised to face a BTRFS corruption on=
 a system I'd just installed.
>
> I use NixOS, unstable branch (linux kernel 4.19.12). The system runs on a=
 SSD with an ext4 boot partition, a simple btrfs root with some subvolumes,=
 and some swap space only used for hibernation. I was working on my server =
as normal when I noticed all of my BTRFS subvolumes had been remounted ro. =
After a short time, I started getting various IO errors ("bus error" by jou=
rnalctl, "I/O error" by ls etc.). I halted the system (hard reboot), at the=
 reboot the BTRFS partition would not mount. I suspected the corruption to =
be disk-related, but smartctl does not show any warning for the disk, and t=
he ext4 partition seems healthy.
>
> Those are the kernel messages logged when I attempt to mount the partitio=
n:
> Jan 02 23:39:38 nixos kernel: BTRFS warning (device sdd2): sdd2 checksum =
verify failed on <L> wanted <A> found <B> level 0
> Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): failed to read b=
lock groups: -5
> Jan 02 23:39:38 nixos systemd[1]: Started Cleanup of Temporary Directorie=
s.
> Jan 02 23:39:38 nixos kernel: BTRFS error (device sdd2): open_ctree faile=
d

Do you have the entire kernel message from the previous boot when the
problem started, including I/O errors? We kinda need to see what was
going on leading up to the read only mount, and the bus and I/O
errors. journalctl -b-1 -k should do it, or using journalctl
--list-boots to find it. You can redirect to a file with > and then
attach to the reply if it's small enough, or put it up somewhere like
Dropbox or Google Drive if it's too big.

btrfs rescue super -v /dev/sdd2
btrfs insp dump-s -f /dev/sdd2

Those are reader only. And also try to mount with -o usebackuproot and
if that fails -o ro,usebackuproot is often more tolerant. But that's
for getting data off the volume, it's more useful to know why the file
system broke. And also why btrfs check is failing, given that it's a
current version.

If you get a chance you can take an image, maybe a Btrfs developer
will find it useful to  understand why the Btrfs check is failing.

btrfs-image -c9 -t4 -ss <dev> /path/to/fileoutput.image

That is usually around 1/2 the size of file system metadata. It
contains no data and filenames will be hashed.



--=20
Chris Murphy
