Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:55076 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731793AbeHIRlW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 13:41:22 -0400
Received: by mail-wm0-f53.google.com with SMTP id c14-v6so555641wmb.4
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Aug 2018 08:15:59 -0700 (PDT)
Received: from exnet.gdb.it ([151.34.56.2])
        by smtp.gmail.com with ESMTPSA id y11-v6sm7311419wrr.84.2018.08.09.08.15.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 Aug 2018 08:15:57 -0700 (PDT)
From: Giuseppe Della Bianca <giusdbg@gmail.com>
To: linux-btrfs@vger.kernel.org
Reply-To: bepi@adria.it
Subject: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date: Thu, 09 Aug 2018 17:15:24 +0200
Message-ID: <2543962.HIiRWmuHEy@exnet.gdb.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

My system: 
- Fedora 28 x86_64
- kernel-4.17.7-200
- btrfs-progs-4.15.1-1

The command 'btrfs subvolume sync -s 2 xyz' hangs in this case:

- Run command 'btrfs subvolume sync -s 2 xyz' .
- After some time the kernel reports an error on the filesystem.
  (error that existed before the command was launched.)
- The filesystem goes in read-only mode.
- The command hangs.


Best regards.

gdb



