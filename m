Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24607 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbaCGXyk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 18:54:40 -0500
Message-ID: <531A5C33.9090003@fb.com>
Date: Fri, 7 Mar 2014 18:54:27 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] Btrfs: use bitfield instead of integer data type
 for the some variants in btrfs_root
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com> <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/20/2014 05:08 AM, Miao Xie wrote:
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com> --- fs/btrfs/ctree.c
> | 25 ++++++++++++++----------- fs/btrfs/ctree.h       | 39
> +++++++++++++++++++++------------------ fs/btrfs/disk-io.c     | 33
> +++++++++++++++------------------ fs/btrfs/extent-tree.c |  6
> +++--- fs/btrfs/file.c        |  4 +++- fs/btrfs/inode.c       | 29
> ++++++++++++++++++----------- fs/btrfs/ioctl.c       |  4 ++-- 
> fs/btrfs/relocation.c  | 17 +++++++++-------- fs/btrfs/root-tree.c
> |  2 +- fs/btrfs/transaction.c | 33
> +++++++++++++++++---------------- fs/btrfs/tree-defrag.c |  2 +- 
> fs/btrfs/tree-log.c    |  9 +++++---- 12 files changed, 109
> insertions(+), 94 deletions(-)
> 

This patch causes xfstests to lock up the box.  I could reproduce by
running

./check generic/070 generic/074 generic/075

in a loop.  It blows up at 075 and usually happens right away, but
sometimes doesn't blow up until the second go around.  I'm dropping it
for now.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGlwuAAoJEANb+wAKly3BrE4P+wY0BhYvT1PjMBu6nFSZFxSd
5an4GGW5aoRrQ3G0wZkEpWPJK34exLvuzzaNxHH9FSesz27l1bnibNTUy7BzI7Mv
tj92Dxmckpcvl+z3QI+CcPkI6NpVzBNETRxBpRVtkqxWKioEhk4oOwvctBqbqaI1
lEOxylu6/09k2BjjeehJFLjzhVzq9taTUt7ETAaBaJLsPFdD9/E8S1EO/uJyabSo
yGSWSHEnXUMjRCaXZ1bZJKDowTZ10wviU4rDPyFi99h4h1m6FZe5jNStHojNcNkc
Qt1xv3s2bkuz7yAC9/yJuz4HFiWtiyRHD609vBiIBO93hLCFi5Xc4jXtSRVVC+Xx
891gfD0c8/SVJpviTOFnxewozmIgudcC4y3i2AglRI+IXEkNRr66G6v/H0uZEN+n
lhiNTLQ+/Kd+mxUA7Y3To86Hnb55TqX7G8AL2zdFKBb1LJLBCazcEQZkDDraG2MW
x77H38VvKyQ+pBgv/lZFnKHadPkveFrGJUYCx49SOHAvWDoDVcIx2liayR8WYBMA
reRT6Vd+sH4xkgVXXNhrFcDFsnbJp1R9LkHuk4HW56QASaMcLqwZ/RmwL/3ldX0c
17IyUZkXZx79rbzBwL8EmU9Gb+oDkNeu8nXIzVnBERDBQbDQqSThaLeiPfuJNPjU
mGmvLKc/fXNN3RofWrSx
=N9yr
-----END PGP SIGNATURE-----
