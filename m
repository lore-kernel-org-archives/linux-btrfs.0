From: Dave Jones <davej@redhat.com>
Subject: 3.4rc1 btrfs IO problem ?
Date: Mon, 2 Apr 2012 13:50:52 -0400
Message-ID: <20120402175052.GA8127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed something odd when I booted rc1 on my btrfs test box..

First I tried updating my git tree..

$ gp
error: cannot open .git/FETCH_HEAD: Input/output error
$ gp
remote: Counting objects: 5101, done.
remote: Compressing objects: 100% (546/546), done.
remote: Total 3764 (delta 3233), reused 3738 (delta 3208)
Receiving objects: 100% (3764/3764), 783.19 KiB | 195 KiB/s, done.
Resolving deltas: 100% (3233/3233), completed with 831 local objects.
fatal: fsync error on '.git/objects/pack/tmp_pack_gq3edw': Input/output error
fatal: index-pack failed

uh-oh. I looked in dmesg, nothing out of the ordinary (disks dying etc).

But anything that does IO seems to have serious issues..

$ fsx foo
truncating to largest ever: 0x13e76
truncating to largest ever: 0x2e52c
ftruncate1: 2e52c
dotruncate: ftruncate: Input/output error
Segmentation fault (core dumped)

3.3 is fine.

Thoughts ?

	Dave
