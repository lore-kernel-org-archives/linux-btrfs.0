From: Arne Jansen <sensille@gmx.net>
Subject: [GIT PULL] scrub fix for -rc2
Date: Wed, 01 Jun 2011 16:36:16 +0200
Message-ID: <4DE64E60.4090502@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
for-chris

the bio-reuse fix. I also included the small fix for the false BUG_ON
in volumes.c. Here's the shortlog:

Arne Jansen (2):
      btrfs: scrub: don't reuse bios and pages
      btrfs: false BUG_ON when degraded

Thanks,
Arne
