Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7671C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 21:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68985208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 21:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ktS9T96g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68985208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbeK1IPl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 03:15:41 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:33605 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeK1IPl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 03:15:41 -0500
Received: by mail-ot1-f41.google.com with SMTP id i20so21580214otl.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 13:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=HGZFoW+QBuMt1alI1b/ThH6BGxRssmc5AA4FvUgcB9Y=;
        b=ktS9T96goGVt1PdClepllvK1Aw+TobTbrku873I5nIJQ3yyzBHq+0fklS9u9dDRWBA
         TTXoF8+4kO1Bhcqu3CpxSbJxPH6FkBSrrSYMFXEIobjyA/RGYaDbUtAMNWl4lV9O4ttG
         M471e7Wdd5CzTSMJtp3prB0B3pA9TIF6yAdqbBweSMxK6sVfAXITAunIeaP1RGsMgLTr
         m5VI+kxCdYB0FOydGLjKJASdiVQJniXSrlUBbYTnl0FQ//RruhMBogxkv9v7JiEqYy2b
         oy2bEKYmdoG/Ia87liKF19ZUkTyeXOxDRhcAZ3u/1pEetnXbBOw+hPVUuZtzqn72rspl
         JcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=HGZFoW+QBuMt1alI1b/ThH6BGxRssmc5AA4FvUgcB9Y=;
        b=hLTV65JJHmuS/Oi/mudQB53q4TZ0f4jHnS9ZvNfOzpdA9C9QN1kRJr4VxIblGh+t8g
         5q/hDFjdLNhilZZTMvbDrlpWQ+0sda91EZ7oqXIvtAtfcv8v6McuOdMTJeIfSp2EqLFp
         4CFYV3UflU6JmJtCfIjFzm4fEHm7bSP1Z66+q4OHnZlKPJ4GtuuMMADQyuXVwZJe6NtG
         FvOgpNcZzuFrrwsgI35WilMCiVXxtg4h/1XVT5hhc35p7rcaTkufsEtmhD1IFDa3tzdP
         ko+3iOWzBpFIrHxrC6pFGcM4w+kn/aB737FqPON52enbUTV31a3xY1KJ9pkJE/Ts9hRf
         d89w==
X-Gm-Message-State: AA+aEWZYDqGR3bDyoQbzXr31jfDqj7FuHOUCl34t/9w78lfypa4uSUJO
        X5QWaP5sH5la91Cvqm9uSm4549XdUBIb3Wpkw0TiBg4=
X-Google-Smtp-Source: AFSGD/VGvyAlCjAWnc0CJ+LDwNc7Ot0CdMUnTIDgjl44j3SVzyKBQZRPUKr85SvLOVmJIsuEzgX1XmFC1UKRAT/xb34=
X-Received: by 2002:a9d:245:: with SMTP id 63mr18388963otb.135.1543353388921;
 Tue, 27 Nov 2018 13:16:28 -0800 (PST)
MIME-Version: 1.0
From:   Mikko Merikivi <mikkommm@gmail.com>
Date:   Tue, 27 Nov 2018 23:16:17 +0200
Message-ID: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
Subject: Balance: invalid convert data profile raid10
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I seem unable to convert an existing btrfs device array to RAID 10.
Since it's pretty much RAID 0 and 1 combined, and 5 and 6 are
unstable, it's what I would like to use.

After I did tried this with 4.19.2-arch1-1-ARCH and btrfs-progs v4.19,
I updated my system and tried btrfs balance again with this system
information:
[mikko@localhost lvdata]$ uname -a
Linux localhost 4.19.4-arch1-1-ARCH #1 SMP PREEMPT Fri Nov 23 09:06:58
UTC 2018 x86_64 GNU/Linux
[mikko@localhost lvdata]$ btrfs --version
btrfs-progs v4.19
[mikko@localhost lvdata]$ sudo btrfs fi show
Label: 'main1'  uuid: c7cbb9c3-8c55-45f1-b03c-48992efe2f11
        Total devices 1 FS bytes used 2.90TiB
        devid    1 size 3.64TiB used 2.91TiB path /dev/mapper/main

Label: 'red'  uuid: f3c781a8-0f3e-4019-acbf-0b783cf566d0
        Total devices 2 FS bytes used 640.00KiB
        devid    1 size 931.51GiB used 2.03GiB path /dev/mapper/red1
        devid    2 size 931.51GiB used 2.03GiB path /dev/mapper/red2
[mikko@localhost lvdata]$ btrfs fi df /mnt/red/
Data, RAID1: total=1.00GiB, used=512.00KiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

---

Here are the steps I originally used:

[mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
--use-random /dev/sdc
[mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
--use-random /dev/sdd
[mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdc red1
[mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdd red2
[mikko@localhost lvdata]$ sudo mkfs.btrfs -L red /dev/mapper/red1
btrfs-progs v4.19
See http://btrfs.wiki.kernel.org for more information.

Label:              red
UUID:               f3c781a8-0f3e-4019-acbf-0b783cf566d0
Node size:          16384
Sector size:        4096
Filesystem size:    931.51GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP               1.00GiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1   931.51GiB  /dev/mapper/red1

[mikko@localhost lvdata]$ sudo mount -t btrfs -o
defaults,noatime,nodiratime,autodefrag,compress=lzo /dev/mapper/red1
/mnt/red
[mikko@localhost lvdata]$ sudo btrfs device add /dev/mapper/red2 /mnt/red
[mikko@localhost lvdata]$ sudo btrfs balance start -dconvert=raid10
-mconvert=raid10 /mnt/red
ERROR: error during balancing '/mnt/red': Invalid argument
There may be more info in syslog - try dmesg | tail
code 1

[mikko@localhost lvdata]$ dmesg | tail
[12026.263243] BTRFS info (device dm-1): disk space caching is enabled
[12026.263244] BTRFS info (device dm-1): has skinny extents
[12026.263245] BTRFS info (device dm-1): flagging fs with big metadata feature
[12026.275153] BTRFS info (device dm-1): checking UUID tree
[12195.431766] BTRFS info (device dm-1): enabling auto defrag
[12195.431769] BTRFS info (device dm-1): use lzo compression, level 0
[12195.431770] BTRFS info (device dm-1): disk space caching is enabled
[12195.431771] BTRFS info (device dm-1): has skinny extents
[12205.815941] BTRFS info (device dm-1): disk added /dev/mapper/red2
[12744.788747] BTRFS error (device dm-1): balance: invalid convert
data profile raid10

Converting to RAID 1 did work but what can I do to make it RAID 10?
With the up-to-date system it still says "invalid convert data profile
raid10".
