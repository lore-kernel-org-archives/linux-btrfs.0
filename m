Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:45963 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaI0Ff5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 01:35:57 -0400
Received: by mail-pd0-f178.google.com with SMTP id ft15so14061658pdb.9
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 22:35:56 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] Move BTRFS RCU string to common library
Date: Fri, 26 Sep 2014 22:36:47 -0700
Message-Id: <cover.1411796033.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series makes the generic RCU string library used internally by BTRFS
accessible by anyone.

The first patch makes printk_ratelimited pass on the return value from printk.
Version 3 gives the temporary return variable a unique name to avoid name
clashes.

The second patch moves the RCU string header and updates the BTRFS code that
depends on it. Version 3 adds the __rcu annotation to the relevant functions.

Version 3 also adds Paul's ack and Josh's review.

Omar Sandoval (2):
  Return a value from printk_ratelimited
  Move BTRFS RCU string to common library

 fs/btrfs/check-integrity.c |  6 +--
 fs/btrfs/dev-replace.c     | 19 +++++-----
 fs/btrfs/disk-io.c         |  6 +--
 fs/btrfs/extent_io.c       |  4 +-
 fs/btrfs/ioctl.c           |  4 +-
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/rcu-string.h      | 56 ----------------------------
 fs/btrfs/scrub.c           | 15 ++++----
 fs/btrfs/super.c           |  2 +-
 fs/btrfs/volumes.c         | 14 +++----
 include/linux/printk.h     |  4 +-
 include/linux/rcustring.h  | 92 ++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 132 insertions(+), 92 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

-- 
2.1.1

