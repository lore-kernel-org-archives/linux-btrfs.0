Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18112 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbcFQBqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:46:12 -0400
Subject: [PATCH v6 00/20] xfstests: minor fixes for the reflink/dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:46:02 -0700
Message-ID: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

This is the sixth revision of a patchset that adds to xfstests
support for testing reverse-mappings of physical blocks to file and
metadata (rmap); support for testing multiple file logical blocks to
the same physical block (reflink); and implements the beginnings of
online metadata scrubbing.

The first eight patches are in Eryu Guan's pull request on 2016-06-15.
Those patches haven't changed, but they're not yet in the upstream
repo.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4].  The kernel patches should
apply to dchinner's for-next; xfsprogs patches to for-next; and
xfstest to master.  The kernel git tree already has for-next included.

The patches have been xfstested with x64, i386, and armv7l--arm64,
ppc64, and ppc64le no longer boot in qemu.  All three architectures
pass all 'clone' group tests except xfs/128 (which is the swapext
test), and AFAICT don't cause any new failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel
