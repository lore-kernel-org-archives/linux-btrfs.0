Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A85AC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 07:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E29A20832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 07:21:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvAJ9BYJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E29A20832
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbeK1SVt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 13:21:49 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:37971 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbeK1SVt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 13:21:49 -0500
Received: by mail-ot1-f47.google.com with SMTP id e12so18351461otl.5
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 23:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WyEk3zGzL50KiCgQQP1bOC5ekjwh5TbppKnfJycJkqs=;
        b=kvAJ9BYJc7vPryVsrlPRBtxGD0zqIEG7iKhwLcENPEtAganH3FQSnj29f4vsk5tWio
         YUXargyJ04fiMsRWEDyHv77hWCzXn+jiHfR0pXPXg3i2FafUb/ySuApzH6O/Emuk0/+i
         KZYx2KzM+9C9ucXLCP1pmCoiHNScBpQQFWtPpxaDMKzhN68g1SVKvVRCoHLfhgl0nGMK
         QVDAjG86eWJI8jFtGfHvZIM+ED3x2kD735avT0CmLKuao2i6Nv4ho/inA01EzVivzfL+
         52dAZDOOYxV5j5Myk+KNiAnYk+eA2Fno0gIgB4jZLfQWncRJvPrVmL8c2aEVKxHJ4+sQ
         jCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WyEk3zGzL50KiCgQQP1bOC5ekjwh5TbppKnfJycJkqs=;
        b=pQruUEkYgyMUSJeuu1Vy/wOmnSJOWfKDHp0flaEpSECKIhPL1OGSAGToVU58/vpvI6
         3OvMJ5e6GLMcBj2Yx0CiwSAjnGqctf3Yz/SKZqHCSaioadVB1hawOjJoigR786S68/4k
         Kl1QzWU0jer+zZ0NosYTu38L1MAfc+Sakj4wblLPapZF6FpEs3JsgPMCDKDQUsN2wIuE
         TryvQZXbEgJH0WcQbUG1QDzqIV4OUff5C3ki2ZsCPmGrN6iysXd4ZcLrJc3az2odnMNu
         5Pv14m7dFU7MAK8jdcqU1lq8gsONk5RWOPWqwXPTlmpL9YYjkPPEdgjcusB3ynLGSkIt
         XzKQ==
X-Gm-Message-State: AA+aEWaTRACmCY0emIDiTpCpVbvWfhCE+yj8jKL4ic/iLFnR88VjMcNt
        hpfQQWjDk56CFjp8hCqXZ9h2+jG8eqmcBB/zjg==
X-Google-Smtp-Source: AFSGD/VmSiSz0JQbzd3VCHLdLIx7PTh1Lr5pMh93yDIiXgZkhxrFWCZDj5cioi/s+R0mDqioNFV9MxmeIdx6aRclEBA=
X-Received: by 2002:a9d:51c2:: with SMTP id d2mr21176993oth.0.1543389669486;
 Tue, 27 Nov 2018 23:21:09 -0800 (PST)
MIME-Version: 1.0
References: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
 <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
In-Reply-To: <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
From:   Mikko Merikivi <mikkommm@gmail.com>
Date:   Wed, 28 Nov 2018 09:20:57 +0200
Message-ID: <CAFmqBACW=tf5ATAr7vNvtQ0ZLMEaJOw7-vEifbuc2CKKaQa7HA@mail.gmail.com>
Subject: Re: Balance: invalid convert data profile raid10
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Well, excuse me for thinking it wouldn't since in md-raid it worked.
https://wiki.archlinux.org/index.php/RAID#RAID_level_comparison

Anyway, the error message is truly confusing for someone who doesn't
know about btrfs's implementation. I suppose in md-raid the near
layout is actually RAID 1 and far2 uses twice as much space.
https://en.wikipedia.org/wiki/Non-standard_RAID_levels#LINUX-MD-RAID-10

Well, I guess I'll go with RAID 1, then. Thanks for clearing up the confusi=
on.
ke 28. marrask. 2018 klo 3.14 Qu Wenruo (quwenruo.btrfs@gmx.com) kirjoitti:
>
>
>
> On 2018/11/28 =E4=B8=8A=E5=8D=885:16, Mikko Merikivi wrote:
> > I seem unable to convert an existing btrfs device array to RAID 10.
> > Since it's pretty much RAID 0 and 1 combined, and 5 and 6 are
> > unstable, it's what I would like to use.
> >
> > After I did tried this with 4.19.2-arch1-1-ARCH and btrfs-progs v4.19,
> > I updated my system and tried btrfs balance again with this system
> > information:
> > [mikko@localhost lvdata]$ uname -a
> > Linux localhost 4.19.4-arch1-1-ARCH #1 SMP PREEMPT Fri Nov 23 09:06:58
> > UTC 2018 x86_64 GNU/Linux
> > [mikko@localhost lvdata]$ btrfs --version
> > btrfs-progs v4.19
> > [mikko@localhost lvdata]$ sudo btrfs fi show
> > Label: 'main1'  uuid: c7cbb9c3-8c55-45f1-b03c-48992efe2f11
> >         Total devices 1 FS bytes used 2.90TiB
> >         devid    1 size 3.64TiB used 2.91TiB path /dev/mapper/main
> >
> > Label: 'red'  uuid: f3c781a8-0f3e-4019-acbf-0b783cf566d0
> >         Total devices 2 FS bytes used 640.00KiB
> >         devid    1 size 931.51GiB used 2.03GiB path /dev/mapper/red1
> >         devid    2 size 931.51GiB used 2.03GiB path /dev/mapper/red2
>
> RAID10 needs at least 4 devices.
>
> Thanks,
> Qu
>
> > [mikko@localhost lvdata]$ btrfs fi df /mnt/red/
> > Data, RAID1: total=3D1.00GiB, used=3D512.00KiB
> > System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> > Metadata, RAID1: total=3D1.00GiB, used=3D112.00KiB
> > GlobalReserve, single: total=3D16.00MiB, used=3D0.00B
> >
> > ---
> >
> > Here are the steps I originally used:
> >
> > [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
> > --use-random /dev/sdc
> > [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
> > --use-random /dev/sdd
> > [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdc red1
> > [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdd red2
> > [mikko@localhost lvdata]$ sudo mkfs.btrfs -L red /dev/mapper/red1
> > btrfs-progs v4.19
> > See http://btrfs.wiki.kernel.org for more information.
> >
> > Label:              red
> > UUID:               f3c781a8-0f3e-4019-acbf-0b783cf566d0
> > Node size:          16384
> > Sector size:        4096
> > Filesystem size:    931.51GiB
> > Block group profiles:
> >   Data:             single            8.00MiB
> >   Metadata:         DUP               1.00GiB
> >   System:           DUP               8.00MiB
> > SSD detected:       no
> > Incompat features:  extref, skinny-metadata
> > Number of devices:  1
> > Devices:
> >    ID        SIZE  PATH
> >     1   931.51GiB  /dev/mapper/red1
> >
> > [mikko@localhost lvdata]$ sudo mount -t btrfs -o
> > defaults,noatime,nodiratime,autodefrag,compress=3Dlzo /dev/mapper/red1
> > /mnt/red
> > [mikko@localhost lvdata]$ sudo btrfs device add /dev/mapper/red2 /mnt/r=
ed
> > [mikko@localhost lvdata]$ sudo btrfs balance start -dconvert=3Draid10
> > -mconvert=3Draid10 /mnt/red
> > ERROR: error during balancing '/mnt/red': Invalid argument
> > There may be more info in syslog - try dmesg | tail
> > code 1
> >
> > [mikko@localhost lvdata]$ dmesg | tail
> > [12026.263243] BTRFS info (device dm-1): disk space caching is enabled
> > [12026.263244] BTRFS info (device dm-1): has skinny extents
> > [12026.263245] BTRFS info (device dm-1): flagging fs with big metadata =
feature
> > [12026.275153] BTRFS info (device dm-1): checking UUID tree
> > [12195.431766] BTRFS info (device dm-1): enabling auto defrag
> > [12195.431769] BTRFS info (device dm-1): use lzo compression, level 0
> > [12195.431770] BTRFS info (device dm-1): disk space caching is enabled
> > [12195.431771] BTRFS info (device dm-1): has skinny extents
> > [12205.815941] BTRFS info (device dm-1): disk added /dev/mapper/red2
> > [12744.788747] BTRFS error (device dm-1): balance: invalid convert
> > data profile raid10
> >
> > Converting to RAID 1 did work but what can I do to make it RAID 10?
> > With the up-to-date system it still says "invalid convert data profile
> > raid10".
> >
>
