Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:37185 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdHPWZ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 18:25:56 -0400
Received: by mail-wr0-f173.google.com with SMTP id z91so18582577wrc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 15:25:55 -0700 (PDT)
MIME-Version: 1.0
From: Zirconium Hacker <jared.e.vb@gmail.com>
Date: Wed, 16 Aug 2017 18:25:54 -0400
Message-ID: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
Subject: BTRFS error (device sda4): failed to read chunk tree: -5
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
This is my first time using a mailing list, and I hope I'm doing this right.

$ uname -a
Linux thinkpad 4.12.6-1-ARCH #1 SMP PREEMPT Sat Aug 12 09:16:22 CEST
2017 x86_64 GNU/Linux
$ btrfs --version
btrfs-progs v4.12
$ sudo mount -o ro,recovery /dev/sda4 /mnt
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/sda4,
missing codepage or helper program, or other error.
$ dmesg | tail
<snip>
[ 1289.087439] BTRFS warning (device sda4): 'recovery' is deprecated,
use 'usebackuproot' instead
[ 1289.087440] BTRFS info (device sda4): trying to use backup root at mount time
[ 1289.087442] BTRFS info (device sda4): disk space caching is enabled
[ 1289.097757] BTRFS error (device sda4): failed to read chunk tree: -5
[ 1289.135222] BTRFS error (device sda4): open_ctree failed
<snip>
$ sudo btrfs check /dev/sda4
bytenr mismatch, want=61809344512, have=0
Couldn't read tree root
ERROR: cannot open file system
$ sudo btrfs restore -vvvv -D /dev/sda4 .
bytenr mismatch, want=61809344512, have=0
Couldn't read tree root
Could not open root, trying backup super
bytenr mismatch, want=61809344512, have=0
Couldn't read tree root
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 58056507392
Could not open root, trying backup super

A script called btrfs-undelete
(https://gist.github.com/Changaco/45f8d171027ea2655d74) also fails
with similar errors.

I'd like to recover at least one folder, my desktop -- everything else
was backed up.
I'm using PhotoRec to try and recover some files, but I'd like a
better solution that keeps filenames and at least some folder
structure.

Thanks in advance!
