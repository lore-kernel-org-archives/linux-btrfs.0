From: Daniel Witzel <dannyboy48888@gmail.com>
Subject: Re: New btrfsck status
Date: Mon, 13 Jun 2011 18:56:42 +0000 (UTC)
Message-ID: <loom.20110613T205625-686@post.gmane.org>
References: <20110606164109.7b032c17@io.vpn.lugor.de> <BANLkTimzVU6_dqYOWVJ1sdio2akOKT3ghQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Same here, got 5TB in "suspense", running btfs-progs-unstable, also tried the
new hugo patches. Kernel 2.6.39-r1 gentoo box

error from mount /dev/sdf1 /server, or btrfsck -s 0,1,2,etc /dev/sdd1:

parent transid verify failed on 2206281838592 wanted 2135 found 1545
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
Aborted


