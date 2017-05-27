Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34834 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdE0Sxp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 14:53:45 -0400
Received: by mail-yw0-f171.google.com with SMTP id l74so16024561ywe.2
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 11:53:44 -0700 (PDT)
MIME-Version: 1.0
From: Ivan P <chrnosphered@gmail.com>
Date: Sat, 27 May 2017 20:53:23 +0200
Message-ID: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
Subject: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

for a while now, btrfs-cleaner has been molesting my system's btrfs partition,
as well as my CPU. The behavior is as following:

After booting, nothing relevant is happening. After about 5-30 minutes,
a btrfs-cleaner process is spawned, which is constantly using one CPU core.
The btrfs-cleaner process never seems to finish (I've let it waste CPU cycles
for 9 hours) and also cannot be stopped or killed.

Rebooting again usually resolves the issue for some time.
But on next boot, the issue usually reappears.

I'm running linux 4.11.2, but the issue is also present on current LTS 4.9.29.
I am using newest btrfs-tools, as far as I can tell (4.11). The system is an
arch linux x64 installed on a Transcend 120GB mSATA drive.

No other disks are present, but the root volume contains several subvolumes
(@arch<date> snapshots, @home, @data).

The logs don't contain anything related to btrfs, beside the usual diag output
on mounting the root partition.

I am mounting the btrfs partition with the following options:

subvol=@arch_current,compress=lzo,ssd,noatime,autodefrag

What information should I provide so we could debug this?
Please add me to CC when replying, as I am not subscribed to the mailing list.

Thank you in advance,
Ivan.
