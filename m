Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42452 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbaK3I05 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 03:26:57 -0500
Received: by mail-pd0-f177.google.com with SMTP id ft15so8886804pdb.22
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 00:26:57 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 0/3] btrfs: fix RCU string sparse noise
Date: Sun, 30 Nov 2014 00:26:46 -0800
Message-Id: <cover.1417335583.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

These patches clean up the big stack of sparse RCU errors I introduced into the
integration tree as reported by the kbuild test robot:

On Thu, Nov 27, 2014 at 06:45:20AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git integration
> head:   c7a37618b60026121255c69e042d74ae5631470c
> commit: 37aad79d90a0cbf82a5eda62dfe3af4241f5aca3 [38/39] Move BTRFS RCU string to common library
> reproduce:
>   # apt-get install sparse
>   git checkout 37aad79d90a0cbf82a5eda62dfe3af4241f5aca3
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
> >> fs/btrfs/check-integrity.c:848:25: sparse: incorrect type in argument 1 (different address spaces)
>    fs/btrfs/check-integrity.c:848:25:    expected struct rcu_string [noderef] <asn:4>*rcu_str
>    fs/btrfs/check-integrity.c:848:25:    got struct rcu_string *name
[snip, there's a lot of these]

As payment for my transgressions, this also clean ups the existing rcu_string
usage to get rid of the preexisting noise.

The first patch fixes the __rcu annotations which I got wrong on the first go.
The second fixes an incorrect use of RCU in the BTRFS_IOC_DEV_INFO ioctl. The
third refactors the volume code's usage of rcu_string, fixing a questionable
RCU or two in the process.

This patch series applies to Chris' integration branch.

Thanks!

Omar Sandoval (3):
  rcustring: clean up botched __rcu annotations
  btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
  btrfs: refactor btrfs_device->name updates

 fs/btrfs/ioctl.c          | 10 ++---
 fs/btrfs/volumes.c        | 93 ++++++++++++++++++++++++++++++++---------------
 fs/btrfs/volumes.h        |  2 +-
 include/linux/rcustring.h |  5 +--
 4 files changed, 72 insertions(+), 38 deletions(-)

-- 
2.1.3

