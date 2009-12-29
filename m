From: Hans van den Bogert <gandalf@unit-westland.nl>
Subject: l2arc-like ability in btrfs
Date: Tue, 29 Dec 2009 23:56:01 +0100
Message-ID: <1262127361.3705.9.camel@gandalfpc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Will btrfs in the future implement a read cache like zfs has with l2arc,
following it's hybrid storage concept.
This would take away the hassle of choosing what and what not should be
on your SSD, it would speed up the things you do most. And not what you
did a lot a week ago. It should be persistent between boots so your boot
sequence would benefit too.

I'm sorry if this question has come along in the maillist, but the
keywords are very ambiguous in searches.

Thanks!


