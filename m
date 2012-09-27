Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50713 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2I0PjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 11:39:21 -0400
Received: by vbbff1 with SMTP id ff1so2039939vbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2012 08:39:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926131143.GC2328@localhost.localdomain>
References: <20120920190306.GG2272@localhost.localdomain>
	<20120925164335.GZ14582@twin.jikos.cz>
	<20120925170239.GA2328@localhost.localdomain>
	<CAFDW0jLuvH9rMisDz-Y=Y_nwxzzO5K64uixd6mAiaQRmja3izA@mail.gmail.com>
	<20120926131143.GC2328@localhost.localdomain>
Date: Thu, 27 Sep 2012 17:39:19 +0200
Message-ID: <CAFDW0jJqHgEU+E68NMumC9s-bG4iExZ3gE8NS856Ye-5JJpv+g@mail.gmail.com>
Subject: Re: ENOSPC design issues
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef,

> Have you actually seen this problem on 3.5 with no compression?
youre right, no problems with no compression.

> problem in the 3.5 timeframe that should have fixed this for no-compression, and
> then I've since fixed the compression part of it in btrfs-next.  Can you retest
i cherry picked on top of 3.5.4 + for-linus all enospc patches
and dependencies from your btrfs-next in that order:

ddabdd663aa819f206aaaf689b12475b1b11d71e
Btrfs: do not allocate chunks as agressively

dd314c3ef057dde30d1c8ae67c98019a71713ea4
Btrfs: turbo charge fsync

4d9f18a35d456c27e81c8e0de29c858f85d35c91
Btrfs: do not needlessly restart the transaction for enospc

82b8aa2bef5c5267d74ad8e5a82572d4fa85bf89
Btrfs: wait on async pages when shrinking delalloc

4af89eb8ce93a1ec64fc698f82f67a0e3bd8cbef
Btrfs: delay block group item insertion

i hope those are the patches you wanted me to test.

> with btrfs-next and see if you still see the problem?
did and got some nice results: no problems and its faster!

these results are from an old i686 Pentium M Notebook
with 30GB HDD and 1.2GB RAM:

3.5.4 + for-linus + lzo: 6x enospc problems at 30% unsquashfs
*snip*
[================|                                         ] 269645/910412  29%
Write on output file failed because No space left on device
writer: failed to write data block 0
Failed to write /mnt/point/something, skipping
*snip*

# df -h /mnt/point/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        28G   12G   16G  43% /mnt/point

one run:
real    28m44.882s
user    7m4.542s
sys     4m18.353s

3.5.4 + for-linus + no compression: no problems
# df -h /mnt/point/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        28G   18G  9.0G  67% /mnt/point

one run:
real    20m57.157s
user    5m37.915s
sys     3m23.913s

3.5.4 + for-linus + enospc patches + lzo: no problems
# df -h /mnt/point/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        28G   12G   17G  42% /mnt/point

first run:
real    19m35.852s
user    4m33.359s
sys     3m2.808s

second run:
real    23m12.371s
user    5m37.398s
sys     3m47.525s

3.5.4 + for-linus + enospc patches + no compression: no problems
# df -h /mnt/point/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        28G   18G  9.5G  66% /mnt/point

one run:
real    22m56.940s
user    4m53.571s
sys     3m4.188s

great work.
im gonna keep those patches and deploy it on my systems here soon
after some more testing.

Ahmet
