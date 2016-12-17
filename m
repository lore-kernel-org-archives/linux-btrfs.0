Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:32971 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753560AbcLQKGa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 05:06:30 -0500
Received: by mail-lf0-f68.google.com with SMTP id y21so3287803lfa.0
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Dec 2016 02:06:29 -0800 (PST)
From: =?utf-8?B?SmFyaSBTZXBww6Rsw6Q=?= <lihamakaroonilaatikko@gmail.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Date: Sat, 17 Dec 2016 12:06:26 +0200
Subject: Help please: BTRFS fs crashed due to bad removal of USB drive, no
 help from recovery procedures
Message-Id: <66A9C2C6-028F-466B-9EFF-F06BF3FB4694@gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Syslog tells:
[  135.446222] BTRFS error (device sdb1): system chunk array too small 0 < 97
[  135.446260] BTRFS error (device sdb1): superblock contains fatal errors
[  135.462544] BTRFS error (device sdb1): open_ctree failed

What have been done:
* All "btrfs rescue" options

Info on system
* fs on external SSD via USB
* kernel 4.9.0 (tried with 4.8.13)
* btrfs-tools 4.4
* Mythbuntu (Ubuntu) 16.04.1 LTS with latest fixes 2012-12-16

Any help appreciated. Around 300G of TV recordings on the drive, which of course will eventually come as replays.

Jari
--
*** Jari Seppälä

