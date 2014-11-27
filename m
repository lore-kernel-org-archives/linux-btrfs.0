Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44498 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaK0INM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 03:13:12 -0500
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 27 Nov 2014 13:43:07 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [LSF/MM TOPIC]: Btrfs: Decoupling block-size and page-size in BTRFS.
Date: Thu, 27 Nov 2014 13:43:03 +0630
Message-ID: <4053596.iiH0KJPrOm@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In BTRFS, BLOCK_SIZE, the basic IO size of the filesystem, is equal to the
PAGE_SIZE of the architecture. Some 64-bit architectures, like PPC64 and
ARM64, can/do have a default PAGE_SIZE of 64K, which means the filesystems
handled in these architectures have a BLOCK_SIZE of 64K.

This works fine as long as you create and use the filesystems within
these systems. But users cannot create a filesystem in an architecture
of a specific BLOCK_SIZE and then use that filesystem in another. So a
filesystem created on x86 cannot be used (mounted, read, ...) on a
PPC64 or ARM64 system.

9 versions of the subpagesize-blocksize patchset have been posted until today
(see
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg38862.html). These
patches address only the issues in regular I/O code path of Btrfs and still
needs more work to get it working correctly. Other Btrfs features
(e.g. compression, scrub, etc) also need some work to get them working in
subpagesize-blocksize scenario.

I believe that a face-to-face discussion involving Btrfs
maintainers/developers to address some of the design issues would enable us to
fast track the inclusion of this feature into the mainline kernel tree.

-- 
chandan

