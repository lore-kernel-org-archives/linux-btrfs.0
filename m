Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03FB2ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 16:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFA220869
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 16:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVZSgBou"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAFA220869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbeJTAsr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 20:48:47 -0400
Received: from mail-yw1-f52.google.com ([209.85.161.52]:34052 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbeJTAsr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 20:48:47 -0400
Received: by mail-yw1-f52.google.com with SMTP id m129-v6so13446282ywc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 09:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2unvdekOyInqnrn00Yh8VBNwZ6n2tuq1DF5yWUXkCkE=;
        b=PVZSgBouwHwKhd0aP8ghtDFyn2OKdka5yp57ZGllFDnSQJY+TxjyISO1KTWcyPm10V
         Kj4Sulz3ZFAwExgAs0RdnUMf49O4Qz++NeBNUjFvHjzvJM4g+Y5FDs+s5bDnMOHy/bZA
         2LWabXiS3yWp/6xlNiTGxskHdBP6Z5mnBu5vUOrkVEGHIoZki8D+smp9xnpuPHVJWAeN
         jIJHU/3lBDdr9rm++cBdVEm52ZkTEKQWkiGQlrrvD/bQ9VMuJ7tmbxPtnc7Mm+uV+EWP
         o9vwol9lRRh4fjjNrqahc1i9ldzDT4MrRSCaucG3Ue0Fm9ZChe5Ia1dlV4hEzZf7QJ8r
         IeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2unvdekOyInqnrn00Yh8VBNwZ6n2tuq1DF5yWUXkCkE=;
        b=GbPTmrz0M4wIm0W3tAhZP9avTTr99TmhH437IPcU/87L1+nFLm/jyGjl8Hq69hOko0
         FXMbpuujf8LXiygocFIZonDFrHESJ1228IOa6+h9Tg3CK/hiLk3Mn705t3AslCBnMAac
         u29uOU+74sNzKC1rDYosDv74Ao9hxCv/6IngJ1fM5n2x7PARte+25LyTdrs6FgbNX3tJ
         PF9DL/f5QHCg4BLq3/HCP4qpt+0BEWQehwOh+FpZguEVFZUzIzkKwj2SQAuvKmx0Dbb4
         9911W/JHjSthl+Yg0JxHcu77oE2OwZfhHrfxSKchmlWqbf/+bOM0eSrSj19hKtgt0vz7
         8fkQ==
X-Gm-Message-State: ABuFfoiRpANHGUV0X6kD4zMKDU5nWUIfkIstAm2rDG9wBhHaKzDVYX6n
        W+e9jduhg/wAsxcY+wSwFIRlkeBlXiqJpxHHXYneQmBe
X-Google-Smtp-Source: ACcGV61xoAfI0FPnWE3nShcjU6pRAgOBc1LxpjKG6TPEh2ekhoYE7ix1b/wRn1Vdxx/K7S8/nCLZ+C0mzpT/O4yABP8=
X-Received: by 2002:a81:32d3:: with SMTP id y202-v6mr1372891ywy.55.1539967314468;
 Fri, 19 Oct 2018 09:41:54 -0700 (PDT)
MIME-Version: 1.0
From:   "Marco L. Crociani" <marco.crociani@gmail.com>
Date:   Fri, 19 Oct 2018 18:41:42 +0200
Message-ID: <CADy=jfV+rOf9MJ2iF2OcGOLpA+o8Q2235FjoOpyMCGEP1aRbLA@mail.gmail.com>
Subject: I messed up disk replace of RAID5
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,
I have a copy of this data online and a backup offline but I would
like to find out if we can recover this.
A drive broke and I made a mess while replacing it.

each of sda,sdb,sdc,sdd is a 2 disk hardware RAID0.
one disk of sda died and.
I replaced it.
Made a new raid0 array: sde

This was my mistake right?
With btrfs filesystem still mounted I replicated GUID partition using
gdisk /dev/sdd
u
/dev/sde
w
q

then to randomize GUID (but it was already too late right? )
gdisk /dev/sde
g
w
q

btrfs already took the new partion in.
Infact btrfs fi show showed 4 drives and no missing drives.

Here I made some more mistakes like a btrfs de remove than stopped and
some other command.

Then I umounted the filesystem. wipefs on /dev/sde5 and then zero to
all /dev/sde5 to be sure
Rebooted the machine.

mount -o degraded
btrfs device add /dev/sda5 (after reboot sde-> sda)
btrfs device remove missing /data/btrfs
ERROR: error removing device 'missing': Input/output error

btrfs balance start /data/btrfs
[...]
Input/output error

btrfs fi show
Label: 'btrfs-data'  uuid: dee27729-64b0-45e0-af2b-97557357c021
        Total devices 5 FS bytes used 12.86TiB
        devid    2 size 7.12TiB used 4.29TiB path /dev/sdb5
        devid    3 size 7.12TiB used 4.29TiB path /dev/sdc5
        devid    4 size 7.12TiB used 4.29TiB path /dev/sdd5
        devid    5 size 7.12TiB used 60.34GiB path /dev/sda5
        *** Some devices missing

uname -a
Linux kvm4.prisma 4.18.13-1.el7.elrepo.x86_64 #1 SMP Wed Oct 10
15:37:55 EDT 2018 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.15.1

btrfs fi show
Label: 'btrfs-data'  uuid: dee27729-64b0-45e0-af2b-97557357c021
        Total devices 5 FS bytes used 12.86TiB
        devid    2 size 7.12TiB used 4.29TiB path /dev/sdb5
        devid    3 size 7.12TiB used 4.29TiB path /dev/sdc5
        devid    4 size 7.12TiB used 4.29TiB path /dev/sdd5
        devid    5 size 7.12TiB used 60.34GiB path /dev/sda5
        *** Some devices missing

btrfs fi df /data/btrfs/
Data, RAID5: total=12.83TiB, used=12.83TiB
System, RAID5: total=12.00MiB, used=912.00KiB
Metadata, RAID5: total=31.88GiB, used=30.94GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

[ 3011.971936] BTRFS info (device sdb5): found 66028 extents
[ 3012.489634] BTRFS info (device sdb5): relocating block group
14141113761792 flags data|raid5
[ 3020.107263] BTRFS info (device sdb5): found 5057 extents
[ 3024.248896] BTRFS info (device sdb5): found 5057 extents
[ 3024.341585] BTRFS info (device sdb5): relocating block group
13945625640960 flags data|raid5
[ 3041.911748] BTRFS info (device sdb5): found 95400 extents
[ 3043.288820] BTRFS error (device sdb5): bad tree block start 0 13851980791808


Data is readable and seem also writeable but is this array recoverable
or should I make a new filesystem?

Regards,

Marco
