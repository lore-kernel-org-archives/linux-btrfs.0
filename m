Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbaDBI2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:46 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SW0g014905
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 00/27] Replace the old man page with asciidoc and man page for each btrfs subcommand.
Date: Wed, 2 Apr 2014 16:29:11 +0800
Message-ID: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert the old btrfs man pages to new asciidoc and split the huge
btrfs man page into subcommand man page.

The asciidoc style and Makefile things are mostly simplified from git
Documentation, which only supports man page output and remove html output,
since html output is somewhat overkilled for btrfs.

This huge convert and split will bring the following advantages:
1) More human-readable raw documentations.
  The roff grammar is not so easy to read, especially mixed with a lot
  of special words.

2) Easier to modify man page.
  The old huge btrfs man page makes it hard to maintain.
  It's common that some one adds some new options, but only modifies
  the detailed options but not the 'SYNOPSIS' section.

  Now, there is few duplication since btrfs man page is only a overall man
  page, details are all in its individual man page.

I hope this patchset will be the last huge change to man pages and save later
contributors time to maintain the documentations.

Qu Wenruo (27):
  btrfs-progs: Introduce asciidoc based man page and btrfs man page.
  btrfs-progs: Convert man page for btrfs-subvolume
  btrfs-progs: Convert man page for filesystem subcommand.
  btrfs-progs: Convert man page for btrfs-balance.
  btrfs-progs: Convert man page for btrfs-device subcommand.
  btrfs-progs: Convert man page for btrfs-scrub
  btrfs-progs: Convert man page for btrfs-check.
  btrfs-progs: Convert man page for btrfs-rescue
  btrfs-progs: Convert man page for btrfs-inspect-internal
  btrfs-progs: Convert man page for btrfs-send.
  btrfs-progs: Convert man page for btrfs-receive.
  btrfs-progs: Convert man page for btrfs-quota.
  btrfs-progs: Convert and enhance the man page of btrfs-qgroup.
  btrfs-progs: Convert man page for btrfs-replace.
  btrfs-progs: Convert man page for btrfs-dedup.
  btrfs-progs: Convert man page for btrfsck
  btrfs-progs: Convert man page for btrfs-convert.
  btrfs-progs: Convert man page for btrfs-debug-tree.
  btrfs-progs: Convert man page for btrfs-find-root.
  btrfs-progs: Convert man page for btrfs-image.
  btrfs-progs: Convert man page for btrfs-map-logical.
  btrfs-progs: Convert man page for btrfs-show-super.
  btrfs-progs: Convert man page for btrfstune.
  btrfs-progs: Convert man page for btrfs-zero-log
  btrfs-progs: Convert man page for fsck.btrfs.
  btrfs-progs: Convert man page for mkfs.btrfs.
  btrfs-progs: Switch to the new asciidoc Documentation.

 .gitignore                               |   1 +
 Documentation/Makefile                   |  92 +++
 Documentation/asciidoc.conf              |  42 ++
 Documentation/btrfs-balance.txt          |  77 +++
 Documentation/btrfs-check.txt            |  45 ++
 Documentation/btrfs-convert.txt          |  49 ++
 Documentation/btrfs-debug-tree.txt       |  50 ++
 Documentation/btrfs-dedup.txt            |  51 ++
 Documentation/btrfs-device.txt           |  75 +++
 Documentation/btrfs-filesystem.txt       | 163 ++++++
 Documentation/btrfs-find-root.txt        |  45 ++
 Documentation/btrfs-image.txt            |  70 +++
 Documentation/btrfs-inspect-internal.txt |  69 +++
 Documentation/btrfs-map-logical.txt      |  49 ++
 Documentation/btrfs-qgroup.txt           | 110 ++++
 Documentation/btrfs-quota.txt            |  59 ++
 Documentation/btrfs-receive.txt          |  58 ++
 Documentation/btrfs-replace.txt          |  76 +++
 Documentation/btrfs-rescue.txt           |  60 ++
 Documentation/btrfs-scrub.txt            |  98 ++++
 Documentation/btrfs-send.txt             |  60 ++
 Documentation/btrfs-show-super.txt       |  53 ++
 Documentation/btrfs-subvolume.txt        | 172 ++++++
 Documentation/btrfs-zero-log.txt         |  39 ++
 Documentation/btrfs.txt                  | 117 ++++
 Documentation/btrfsck.txt                |  55 ++
 Documentation/btrfstune.txt              |  47 ++
 Documentation/fsck.btrfs.txt             |  51 ++
 Documentation/manpage-base.xsl           |  35 ++
 Documentation/manpage-bold-literal.xsl   |  17 +
 Documentation/manpage-normal.xsl         |  13 +
 Documentation/mkfs.btrfs.txt             | 133 +++++
 Makefile                                 |   4 +-
 man/Makefile                             |  31 -
 man/btrfs-convert.8.in                   |  33 --
 man/btrfs-debug-tree.8.in                |  35 --
 man/btrfs-find-root.8.in                 |  30 -
 man/btrfs-image.8.in                     |  55 --
 man/btrfs-map-logical.8.in               |  33 --
 man/btrfs-show-super.8.in                |  30 -
 man/btrfs-zero-log.8.in                  |  23 -
 man/btrfs.8.in                           | 932 -------------------------------
 man/btrfsck.8.in                         |  29 -
 man/btrfstune.8.in                       |  31 -
 man/fsck.btrfs.8.in                      |  47 --
 man/mkfs.btrfs.8.in                      | 105 ----
 46 files changed, 2133 insertions(+), 1416 deletions(-)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/btrfs-balance.txt
 create mode 100644 Documentation/btrfs-check.txt
 create mode 100644 Documentation/btrfs-convert.txt
 create mode 100644 Documentation/btrfs-debug-tree.txt
 create mode 100644 Documentation/btrfs-dedup.txt
 create mode 100644 Documentation/btrfs-device.txt
 create mode 100644 Documentation/btrfs-filesystem.txt
 create mode 100644 Documentation/btrfs-find-root.txt
 create mode 100644 Documentation/btrfs-image.txt
 create mode 100644 Documentation/btrfs-inspect-internal.txt
 create mode 100644 Documentation/btrfs-map-logical.txt
 create mode 100644 Documentation/btrfs-qgroup.txt
 create mode 100644 Documentation/btrfs-quota.txt
 create mode 100644 Documentation/btrfs-receive.txt
 create mode 100644 Documentation/btrfs-replace.txt
 create mode 100644 Documentation/btrfs-rescue.txt
 create mode 100644 Documentation/btrfs-scrub.txt
 create mode 100644 Documentation/btrfs-send.txt
 create mode 100644 Documentation/btrfs-show-super.txt
 create mode 100644 Documentation/btrfs-subvolume.txt
 create mode 100644 Documentation/btrfs-zero-log.txt
 create mode 100644 Documentation/btrfs.txt
 create mode 100644 Documentation/btrfsck.txt
 create mode 100644 Documentation/btrfstune.txt
 create mode 100644 Documentation/fsck.btrfs.txt
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/mkfs.btrfs.txt
 delete mode 100644 man/Makefile
 delete mode 100644 man/btrfs-convert.8.in
 delete mode 100644 man/btrfs-debug-tree.8.in
 delete mode 100644 man/btrfs-find-root.8.in
 delete mode 100644 man/btrfs-image.8.in
 delete mode 100644 man/btrfs-map-logical.8.in
 delete mode 100644 man/btrfs-show-super.8.in
 delete mode 100644 man/btrfs-zero-log.8.in
 delete mode 100644 man/btrfs.8.in
 delete mode 100644 man/btrfsck.8.in
 delete mode 100644 man/btrfstune.8.in
 delete mode 100644 man/fsck.btrfs.8.in
 delete mode 100644 man/mkfs.btrfs.8.in

-- 
1.9.1

