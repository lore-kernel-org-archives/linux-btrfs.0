Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbbEKII7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:08:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87Zw0028737
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/13]  Introduce offline fsid/chunk tree uuid change for btrfstune.
Date: Mon, 11 May 2015 16:08:41 +0800
Message-ID: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will introduce offline fsid/chunk tree uuid change
function to 'btrfs property' command, with "fsid" and "chunk_tree_uuid"
respectively.

The implement is in-place btrfs_header modification, without transaction
protection. So the uuid change can be done on any valid image even it is
already full.

Since we don't use transaction to protect the convert, it's possible one
can stop the running convert progress, causing the fs in a inconsistent
status and unable to be mounted.
To avoid such problem, we introduce new btrfs super flags:
BTRFS_SUPER_FLAG_CHANGING_FSID and BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID

Btrfs-progs and kernel will abort open_ctree if these super flags is found.
Btrfs-progs has the exception if OPEN_CTREE_IGNORE_FSID/CHUNK_TREE_ID is
given, allowing user to finished unfinished uuid changing process.

Along with new super_flags, also add human-readable flags output for
btrfs-show-super command.

Qu Wenruo (13):
  btrfs-progs: Add CHANGIND_FSID and CHANGING_CHUNK_TREE_ID super flags.
  btrfs-progs: Use unified function to implement print_readable_*_flag()
        function.
  btrfs-progs: Make btrfs-show-super print human readable flag for super
        flags.
  btrfs-progs: Add open_ctree check for uuid changing.
  btrfs-progs: Export write_tree_block().
  btrfs-progs: Introduce change_header_uuid() function.
  btrfs-progs: Introduce change_extents_uuid() function.
  btrfs-progs: Introduce change_device_uuid() function.
  btrfs-progs: Introduce change_devices_uuid() function.
  btrfs-progs: Introduce change_id_prepare() and change_id_done()    
    functions.
  btrfs-progs: Introduce change_uuid() function.
  btrfs-progs: Add offline type for btrfs property.
  btrfs-progs: Update Doc for btrfs-property

 Documentation/btrfs-property.asciidoc |  17 +-
 btrfs-show-super.c                    |  48 ++++-
 cmds-property.c                       |   5 +-
 ctree.h                               |   6 +
 disk-io.c                             |  23 +-
 disk-io.h                             |   6 +
 props.c                               | 386 ++++++++++++++++++++++++++++++++++
 props.h                               |   1 +
 8 files changed, 483 insertions(+), 9 deletions(-)

-- 
2.4.0

