From: Ilya Shestopalov <yast4ik@yahoo.com>
Subject: Segmentation fault on partition mount
Date: Fri, 30 Apr 2010 11:26:16 -0700 (PDT)
Message-ID: <185920.66632.qm@web58307.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

My distro: Archlinux
Kernel: 2.6.34-rc5, 2.6.33.3
I has 522 Gib btrfs partition and. While I was checking out chromium source, free space on my /home btrfs partition was about 20 Gib. Then I received message "not enough free space" (but there was enough of it). And even after btrfsck I always get segmentation fault. Even btrfs-debug-tree can't be done successfully.
How can this bug be fixed?

P.S. 

I can't find btrfs-image in btrfs-progs-unstable from the Archlinux repo.




