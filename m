From: Hu Ruihuan <specter118@gmail.com>
Subject: <BUG>can't read superblock
Date: Sun, 29 Nov 2009 17:45:45 +0800
Message-ID: <713d0d430911290145r3a1d4a77uf5e13e0863416689@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?GB2312?B?uvrI8Lu4?= <specter118@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi,sir
   I creat the filesystem with command mkfs.btrfs /dev/sda2, and it returns
fs created label (null) on /dev/sda2  nodesize 4096 leafsize 4096
sectorsize 4096 size 2.93GB

then I mount the /dev/sda2 with command mount -t btrfs /dev/sda2
/btrfs/, it returns
mount: /dev/sda2: can't read superblock.

Why?
