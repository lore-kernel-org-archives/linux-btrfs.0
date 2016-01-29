Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31409 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbcA2FSE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 00:18:04 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 00/22] Btrfs-convert rework to support separate chunk type
Date: Fri, 29 Jan 2016 13:03:10 +0800
Message-Id: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here comes the 2st version of btrfs-convert rework.
This time, it is rebased to co-operate with David new abstraction work
for incoming reiserfs support.
(Sorry David, your reiserfs support will need more modification as the
abstraction facility is also modified in this patchset)

Any test is welcomed, and it can already pass the convert test from
btrfs-progs. (Since the test doesn't test rollback function)

I also did some tests like create ext4 and fill it with fsstress to test
convert, at least no bug spotted yet.

The new btrfs-convert has the following bugfix/feature:
1. True separate meta/data chunk
   The converted filesystem will has correct chunk layout, and all ext*
   data will be covered by data chunk and metadata will be covered by
   metadata chunk.
   Allowing converted filesystem to pass latest btrfs check.

2. Structurized make_btrfs_v2()
   Unlike old make_btrfs() which is a mess of hand written codes, new
   make_btrfs_v2() is all structurized and should be easy for later
   expansion.

But it still has something to do:
1) Ability to handle 10+ TB level filesystem.
   Current implement rely on the initial system chunk to contain all
   chunks until we inserted all data chunks.
   However the initial system chunk are only 32M, in simple calculation,
   it can only hold at most 400K chunks.
   If every chunk is in the smallest size (16M), it can only handle
   less than 6T size in its worst case.
   Better calculate the initial system chunk size according to the
   filesystem size

   But now, I'll focus on current implement to ensure it's safe and
   stable.

2) Ability to create DUP metadata chunk without using balance
   Now the data and metadata chunk are all in SINGLE profile.
   User needs to convert metadata to DUP if they want DUP metadata
   profile.

   This is a little hard, as we must do it at make_btrfs() time, where
   we don't have full btrfs facilities to modify the metadata tree.

   But should be easy to add DUP support since the make_btrfs() is much
   clearer than ever.

The core idea of new btrfs-convert is quite simple:
Do reserve at *CHUNK* level.

Instead of old extent level reserve, we just insert a big enough SYS/META
chunks at make_btrfs() time, then insert all data chunks to cover old fs
data.
Then things will get very clear. No custom extent allocation function,
all chunk/extent allocation facility can be used without modification
and won't screw up chunk layout.

For rollback function, as old and new convert has completely different
chunk type (ANY vs DATA), so make rollback a little less restricted to
handle both old and new behavior.

Changelog:
v1:
  Add rollback support
  Make btrfs-convert more safe on chunk type

v2:
  Rebased to latest devel branch.

v3:
  Rebased to latest devel branch.
  Fix a btrfs patch leak.

Qu Wenruo (22):
  btrfs-progs: convert: Introduce functions to read used space
  btrfs-progs: convert: Introduce new function to remove reserved ranges
  btrfs-progs: convert: Introduce function to calculate the available
    space
  btrfs-progs: utils: Introduce new function for convert
  btrfs-progs: Introduce function to setup temporary superblock
  btrfs-progs: Introduce function to setup temporary tree root
  btrfs-progs: Introduce function to setup temporary chunk root
  btrfs-progs: Introduce function to initialize device tree
  btrfs-progs: Introduce function to initialize fs tree
  btrfs-progs: Introduce function to initialize csum tree
  btrfs-progs: Introduce function to setup temporary extent tree
  btrfs-progs: Introduce function to create convert data chunks
  btrfs-progs: extent-tree: Introduce function to find the first overlap
    extent.
  btrfs-progs: extent-tree: Enhance btrfs_record_file_extent
  btrfs-progs: convert: Introduce new function to create converted image
  btrfs-progs: convert: Introduce function to migrate reserved ranges
  btrfs-progs: convert: Enhance record_file_blocks to handle reserved
    ranges
  btrfs-progs: convert: Introduce init_btrfs_v2 function.
  btrfs-progs: Introduce do_convert_v2 function
  btrfs-progs: Convert: Add support for rollback new convert behavior
  btrfs-progs: convert: Strictly avoid meta or system chunk allocation
  btrfs-progs: Cleanup old btrfs-convert

 btrfs-convert.c | 1873 ++++++++++++++++++++++---------------------------------
 ctree.c         |   24 +
 ctree.h         |   14 +-
 extent-tree.c   |  251 ++++++--
 mkfs.c          |    4 +-
 utils.c         |  828 +++++++++++++++++++++++-
 utils.h         |   26 +-
 volumes.c       |   46 +-
 volumes.h       |    2 +-
 9 files changed, 1858 insertions(+), 1210 deletions(-)

-- 
2.7.0



