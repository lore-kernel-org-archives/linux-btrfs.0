Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36037 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753673AbcJ3QSl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 12:18:41 -0400
Received: by mail-wm0-f46.google.com with SMTP id p190so105859285wmp.1
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Oct 2016 09:18:40 -0700 (PDT)
MIME-Version: 1.0
From: Thomas Bauffe <lafferx@gmail.com>
Date: Sun, 30 Oct 2016 18:18:38 +0200
Message-ID: <CAPE97m4z=V6oVKc+gw6=KkJzuapf5tSQWuaVfHS-L3zsEtzoHQ@mail.gmail.com>
Subject: Btrfs root partition forced readonly during boot
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I seem to have run into trouble with btrfs filesystem on my OpenSuse
Tumbleweed installation. The root filesystem (sdb3) which is in btrfs
is mounted readonly during boot.

The filesystem is on a WD hard drive. I did an extended check on the
drive using WD's Data Lifeguard Diagnostic tool which passed the drive
as healthy.

I found the following errors in the logs:
================================
# journalctl -xb
BTRFS: error (device sdb3): unable to find ref byte nr 12967161856
parent 557531136 root 5 owner 2659226 offset 0
..
BTRFS: error (device sdb3) in __btrfs_free_extent:6951: errno=-2 No such entry
BTRFS info (device sdb3): forced readonly
BTRFS: error (device sdb3) in btrfs_run_delayed_refs:2690: errno=-2 No
such entry
================================

Does this indicate the root filesystem is corrupt?
Should I try running 'btrfs check --repair' or perhaps 'btrfs rescue'?

Thank you in advance for your help and have a pleasant day!

Thomas
