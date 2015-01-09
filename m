Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36051 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbbAIUgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 15:36:11 -0500
Received: by mail-pd0-f178.google.com with SMTP id r10so19312115pdi.9
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 12:36:11 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH RESEND v8 0/3] Introduce RCU string API
Date: Fri,  9 Jan 2015 12:35:57 -0800
Message-Id: <cover.1420834567.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone,

Now that the merge window and the holidays are over, I've rebased this on
v3.19-rc3 for the next merge window.

This patch series introduces the RCU string API and cleans up the wreckage of
sparse warnings which follow from it (shown here from when the patch was
briefly in the btrfs integration tree):

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
[snip]

Version 8 combines the original patch with another patch series I posted to fix
these warnings, which fixes the botched __rcu annotations that caused some of
the warnings and refactors the existing uses of rcustring to get rid of the
rest. There's also a patch to fix an RCU misuse.

Thanks!

v8: Get the __rcu annotations right, clean up RCU string-related sparse noise
v7: Add arguments to kernel doc for printk wrappers, use ##__VA_ARGS
v6: Add header dependencies to rcustring.h
v5: Rebase against v3.18-rc3
v4: Don't return anything from the printk wrappers on the assumption that
printk will return void someday
v3: Add __rcu annotation to relevant functions, add Paul's ack and Josh's
review

Omar Sandoval (3):
  Move BTRFS RCU string to common library
  btrfs: refactor btrfs_device->name updates
  btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO

 fs/btrfs/check-integrity.c |   6 +--
 fs/btrfs/dev-replace.c     |  19 ++++----
 fs/btrfs/disk-io.c         |   6 +--
 fs/btrfs/extent_io.c       |   4 +-
 fs/btrfs/ioctl.c           |  14 +++---
 fs/btrfs/raid56.c          |   2 +-
 fs/btrfs/rcu-string.h      |  56 ------------------------
 fs/btrfs/scrub.c           |  15 ++++---
 fs/btrfs/super.c           |   2 +-
 fs/btrfs/volumes.c         | 107 ++++++++++++++++++++++++++++++---------------
 fs/btrfs/volumes.h         |   2 +-
 include/linux/rcustring.h  |  97 ++++++++++++++++++++++++++++++++++++++++
 12 files changed, 204 insertions(+), 126 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

-- 
2.2.1

