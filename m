Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:33093 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754709AbcIACCF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 22:02:05 -0400
Received: by mail-ua0-f178.google.com with SMTP id l94so121130647ual.0
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 19:02:05 -0700 (PDT)
MIME-Version: 1.0
From: Fennec Fox <fennectech@gmail.com>
Date: Wed, 31 Aug 2016 21:02:04 -0500
Message-ID: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
Subject: 
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37 UTC
2016 x86_64 GNU/Linux
btrfs-progs v4.7

Data, single: total=30.01GiB, used=18.95GiB
System, single: total=4.00MiB, used=16.00KiB
Metadata, single: total=1.01GiB, used=422.17MiB
GlobalReserve, single: total=144.00MiB, used=0.00B

{02:50} Wed Aug 31
[fennectech@Titanium ~]$  sudo fstrim -v /
[sudo] password for fennectech:
Sorry, try again.
[sudo] password for fennectech:
/: 99.8 GiB (107167244288 bytes) trimmed

{03:08} Wed Aug 31
[fennectech@Titanium ~]$  sudo fstrim -v /
[sudo] password for fennectech:
/: 99.9 GiB (107262181376 bytes) trimmed

  I ran these commands minutes after echother ane each time it is
trimming the entire free space

Anyone else seen this?   the filesystem is the root FS and is compressed

-- 
Fennec
