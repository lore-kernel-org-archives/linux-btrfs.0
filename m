From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: slow deletion of files
Date: Sun, 11 Jul 2010 14:59:12 +0000 (UTC)
Message-ID: <i1cm80$901$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

during my testing of btrfs I found out, 
that deletion of directory with many files (many millions) takes veeeery 
long (it is running two weeks now and did not finish).

But when instead of directory I create subvolume, it is deleted instantly.

Is it normal behaviour? (gentoo 2.6.34-r1, btrfs-progs-9999).
Why the directory cannot be deleted instantly as well?

Thank you

Lubos

