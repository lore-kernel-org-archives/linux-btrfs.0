Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:51994 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIPNL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2012 10:13:11 -0500
Message-ID: <509D1D72.4050307@giantdisaster.de>
Date: Fri, 09 Nov 2012 16:12:50 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in
 comparison expression (different address spaces)
References: <20121108073541.GA30285@localhost>
In-Reply-To: <20121108073541.GA30285@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 8 Nov 2012 15:35:41 +0800, Fengguang Wu wrote:
> Hi Stefan,
> 
> FYI, there are new sparse warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
> head:   c1014be59ba93855c31fda9d9cf4319cc6f9eeb1
> commit: d8e784f51e2e1d1c57f091fdb49456c4e7fb62d2 Btrfs: add a new source file with device replace code
> date:   21 hours ago
> 
> + fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in comparison expression (different address spaces)
> + fs/btrfs/dev-replace.c:486:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:745:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:745:17: sparse: incompatible types in comparison expression (different address spaces)
> fs/btrfs/dev-replace.c:766:30: sparse: too many arguments for function btrfs_scrub_dev
> fs/btrfs/dev-replace.c:407:30: sparse: too many arguments for function btrfs_scrub_dev
> fs/btrfs/dev-replace.c: In function 'btrfs_init_dev_replace':
> fs/btrfs/dev-replace.c:141:8: error: 'BTRFS_DEV_REPLACE_DEVID' undeclared (first use in this function)
> fs/btrfs/dev-replace.c:141:8: note: each undeclared identifier is reported only once for each function it appears in
> fs/btrfs/dev-replace.c:168:23: error: 'struct btrfs_device' has no member named 'is_tgtdev_for_dev_replace'
> fs/btrfs/dev-replace.c:169:4: error: implicit declaration of function 'btrfs_init_dev_replace_tgtdev_for_resume' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_start':
> fs/btrfs/dev-replace.c:331:2: error: implicit declaration of function 'btrfs_init_dev_replace_tgtdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c:409:10: error: too many arguments to function 'btrfs_scrub_dev'
> In file included from fs/btrfs/dev-replace.c:30:0:
> fs/btrfs/ctree.h:3648:5: note: declared here
> fs/btrfs/dev-replace.c:422:3: error: implicit declaration of function 'btrfs_destroy_dev_replace_tgtdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_finishing':
> fs/btrfs/dev-replace.c:500:12: error: 'struct btrfs_device' has no member named 'is_tgtdev_for_dev_replace'
> fs/btrfs/dev-replace.c:502:22: error: 'BTRFS_DEV_REPLACE_DEVID' undeclared (first use in this function)
> fs/btrfs/dev-replace.c:516:2: error: implicit declaration of function 'btrfs_rm_dev_replace_srcdev' [-Werror=implicit-function-declaration]
> fs/btrfs/dev-replace.c: In function 'btrfs_resume_dev_replace_async':
> fs/btrfs/dev-replace.c:726:2: error: 'struct btrfs_fs_info' has no member named 'mutually_exclusive_operation_running'
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_kthread':
> fs/btrfs/dev-replace.c:756:21: error: 'struct btrfs_fs_info' has no member named 'mutually_exclusive_operation_running'
> fs/btrfs/dev-replace.c: In function 'btrfs_dev_replace_continue_on_mount':
> fs/btrfs/dev-replace.c:769:10: error: too many arguments to function 'btrfs_scrub_dev'
[...]

My fault.

After reading, how the 0-day kernel build testing is working, it is
clear, what the error is.

This problematic commit adds a source file with full C code contents,
but does not add the file to the Makefile yet. The sparse tool checks it
anyway since it seems to be invoked for every *.c file ignoring that the
file is not yet included in the build.

This behavior of the kernel build testing is fine. There are pros and
cons, but finally I think that it is not a good idea to create such a
commit as I did it.

The goal was to avoid huge commits that nobody would ever review, and
that nobody could ever review. Therefore I thought it would simplify
reading the patches and understanding the purpose of the modifications,
if I make it a step of its own to add all these new dev-replace.c
functions. This allows to keep the commit "change core code of btrfs to
support the device replace operation" small and contain only the changes
to the legacy files.

I now changed it to add the new source file to the Makefile in the same
commit that added the C source file, and made it build without errors.
This meant to move the commit upwards in the list of commits, and to
also move some changes from one commit to the other. At the end, the
commit "change core code of btrfs to support the device replace
operation" is even smaller, and the changed commits are even more
readable. For me, this is a proof that this is the better way :)

Thanks for the 0-day kernel build testing!

