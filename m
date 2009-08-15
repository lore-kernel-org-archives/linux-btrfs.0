From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Integrity problem when cloning git tree onto new btrfs filesystem
Date: Fri, 14 Aug 2009 17:32:00 -0700
Message-ID: <4A860200.5020407@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I created a shiny new 10G btrfs filesystem on a 2.6.31-rc5 (x86-64
running as Xen domU), and tried cloning a fresh copy of linux-2.6 onto it:

    [jeremy@f11-64 git]$ git clone
    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    Initialized empty Git repository in /mnt/jeremy/git/linux-2.6/.git/
    remote: Counting objects: 1270263, done.
    remote: Compressing objects: 100% (204288/204288), done.
    Receiving objects: 100% (1270263/1270263), 313.23 MiB | 4485 KiB/s,
    done.
    remote: Total 1270263 (delta 1060042), reused 1268033 (delta 1057934)
    error: inflate: data stream error (incorrect header check)
    fatal: serious inflate inconsistency
    fatal: index-pack failed

Running the same command a second time on the same filesystem completed
successfully, as did the same command on an ext3 filesystem.  There were
no unexpected messages on the console (well, I was a bit surprised it
decided to go into SSD mode, but I guess virtual disks are marked as
being non-seeking as well).

    J

