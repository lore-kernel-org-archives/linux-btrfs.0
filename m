Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gabriel-2.zfn.uni-bremen.de ([134.102.20.37]:51692 "EHLO
	smtp.uni-bremen.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311Ab3FDVMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 17:12:07 -0400
Date: Tue, 4 Jun 2013 22:58:02 +0200
From: Robin Kreis <r.kreis@uni-bremen.de>
To: linux-btrfs@vger.kernel.org
Subject: Recovering from btrfsck --init-csum-tree
Message-ID: <20130604225802.0feb0367@quip>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

how can I recover from running btrfsck --init-csum-tree on my 2TB
btrfs?  Every attempt to read a file results in no checksum being
found, followed by a checksum mismatch which leads to the data block
being zeroed out (see label zeroit in inode.c).  My current fix is
simply skipping the whole checksum validation, which enables me to
read my files again.  I still think at least one of the following
should happen:

1. Add a warning that --init-csum-tree is pretty desctructive.
2. Make --init-csum-tree mark all inodes with INODE_NODATASUM.
3. Have some global flag or mount option to disable CRC checks.

What do you think?
