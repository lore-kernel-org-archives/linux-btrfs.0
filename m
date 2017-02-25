Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:35836 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdBYTai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Feb 2017 14:30:38 -0500
Received: by mail-ot0-f174.google.com with SMTP id w44so32416452otw.2
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Feb 2017 11:30:37 -0800 (PST)
MIME-Version: 1.0
From: Bhasker C V <bhasker@unixindia.com>
Date: Sun, 26 Feb 2017 01:00:36 +0530
Message-ID: <CAPLCSGCeD5KaFmMZWCKQ8nEbMEYTeDsb4ksgxQiU7-6P7dR=3w@mail.gmail.com>
Subject: BTRFS hybrid system setup issues
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

  I have an x86_64 kernel running with i386 userland rootfs.
 Long back I believe there were some fixes for btrfs-tools which ran
smoothly in this setup but after several dist-upgrades(debian) and
long forgotten command, the btrfs-tools commands have started to fail

for instance

$ sudo btrfs fi sync  .
ERROR: sync ioctl failed on '.': Inappropriate ioctl for device
$

Is there any fix for this ? I downloaded the git master branch and it
too seems to suffer from this issue.


--
Bhasker C V
