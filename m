Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40056 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaISJBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 05:01:45 -0400
Received: by mail-pd0-f174.google.com with SMTP id v10so3232866pde.33
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 02:01:44 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Move BTRFS RCU string to common library
Date: Fri, 19 Sep 2014 02:01:28 -0700
Message-Id: <cover.1411116672.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch series moves the generic RCU string library used internally by BTRFS
to be accessible by anyone. It provides printk_in_rcu and
printk_ratelimited_in_rcu to print these strings. In order to avoid a weird
inconsistency between the two, the first patch fixes printk_ratelimited so it
passes on the return value from printk.

The second patch actually moves the RCU string library. Version 2 passes on the
return values from printk{,_ratelimited} and fixes some style issues.

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
 include/linux/rcustring.h  | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 131 insertions(+), 92 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

-- 
2.1.0

