Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32407 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2I2KQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 06:16:02 -0400
Date: Sat, 29 Sep 2012 18:15:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [josef-btrfs:master 81/82] fs/btrfs/disk-io.c:34:28: fatal error:
 asm/cpufeature.h: No such file or directory
Message-ID: <20120929101555.GA5278@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

FYI, kernel build failed on

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   5aeafaaac9c84f3e2297914c748243bb34b0c5c5
commit: 5aeafaaac9c84f3e2297914c748243bb34b0c5c5 [81/82] Btrfs: do not async metadata csumming in certain situations
config: mips-allmodconfig

All error/warnings:

fs/btrfs/disk-io.c:34:28: fatal error: asm/cpufeature.h: No such file or directory
compilation terminated.

vim +34 fs/btrfs/disk-io.c

4b4e25f2 (Chris Mason     2008-11-20  28) #include <linux/freezer.h>
163e783e (David Woodhouse 2009-04-19  29) #include <linux/crc32c.h>
5a0e3ad6 (Tejun Heo       2010-03-24  30) #include <linux/slab.h>
784b4e29 (Chris Mason     2010-11-21  31) #include <linux/migrate.h>
7a36ddec (David Sterba    2011-05-06  32) #include <linux/ratelimit.h>
7e75bf3f (David Sterba    2011-03-18  33) #include <asm/unaligned.h>
5aeafaaa (Josef Bacik     2012-09-25 @34) #include <asm/cpufeature.h>
4b4e25f2 (Chris Mason     2008-11-20  35) #include "compat.h"
eb60ceac (Chris Mason     2007-02-02  36) #include "ctree.h"
eb60ceac (Chris Mason     2007-02-02  37) #include "disk-io.h"

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
