Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2IYAzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 20:55:37 -0400
Date: Tue, 25 Sep 2012 08:52:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: fs/btrfs/disk-io.c:34:28: fatal error: asm/cpufeature.h: No such
 file or directory
Message-ID: <20120925005214.GA5678@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

FYI, kernel build failed on

Commit: d5b04fb3bbb6fce0a834e43f51b6a5251867fcb7 Btrfs: do not async metadata csums if we have hardware crc32c
Date: Mon Sep 24 14:40:24 2012 -0400
config: m68k-allmodconfig

All related error/warning messages:

fs/btrfs/disk-io.c:34:28: fatal error: asm/cpufeature.h: No such file or directory
compilation terminated.

vim +34 fs/btrfs/disk-io.c
    28	#include <linux/freezer.h>
    29	#include <linux/crc32c.h>
    30	#include <linux/slab.h>
    31	#include <linux/migrate.h>
    32	#include <linux/ratelimit.h>
    33	#include <asm/unaligned.h>
  > 34	#include <asm/cpufeature.h>
    35	#include "compat.h"
    36	#include "ctree.h"
    37	#include "disk-io.h"

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
