Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gourmet.spamgourmet.com ([216.75.62.102]:59028 "EHLO
	gourmet8.spamgourmet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754954AbbKRSxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 13:53:07 -0500
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <linux-btrfs.tebulin@xoxy.net>)
	id 1Zz7qt-00058i-10
	for linux-btrfs@vger.kernel.org; Wed, 18 Nov 2015 18:53:07 +0000
To: linux-btrfs@vger.kernel.org
From: linux-btrfs.tebulin@xoxy.net
Subject: Kernel 3.19 and still "disk full" even though 'btrfs fi df" reports
 enough room left?
Message-ID: <564CC90F.3060703@gmail.com>
Date: Wed, 18 Nov 2015 19:53:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there!

I'm stumbling over this regularly. I explicitly upgraded the kernel to
avoid this, but it still occurs me every few months:

  $ touch foo
  touch: »foo“ kann nicht berührt werden: Auf dem Gerät ist kein
Speicherplatz mehr verfügbar
  $ sudo btrfs fi df /
  Data, single: total=101.14GiB, used=78.99GiB
  System, DUP: total=32.00MiB, used=16.00KiB
  Metadata, DUP: total=9.00GiB, used=8.48GiB
  unknown, single: total=512.00MiB, used=832.00KiB

Whut? Why? WTF?

  $ uname -a
  Linux neptun 3.19.0-31-generic #36~14.04.1-Ubuntu SMP Thu Oct 8
10:21:08 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

dmesg is empty. Resolution is to delete a whole bunch of btrfs
subvolumes which are produced by apt-btrfs-snapshot. I run a
   sudo btrfs balance start -dusage=5 /
afterwards as part of my regular "i have no clue what the heck is wrong
with this; maybe it will help & mend my problem" process.

This is annoying. Why is even btrfs own "disk free" utility lying to me?

How to fix this? How to avoid this? How to get notified about this?

- Ben

P.S.: Just as user feedback: For /srv I'm using on the very same system
ZFS since the very first day. With snapshots & all the fancy stuff like
ZRAID-1, lz4, ... My number of Issues there: 0

