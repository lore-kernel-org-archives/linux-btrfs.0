Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758162AbaDBI3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:01 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Sieq014950
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 13/27] btrfs-progs: Convert and enhance the man page of btrfs-qgroup.
Date: Wed, 2 Apr 2014 16:29:24 +0800
Message-ID: <1396427378-10487-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert and enhance the man page of btrfs-qgroup.

The original man page for btrfs-qgroup subcommand is almost useless for
new user(like me), so adds more information on it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile         |   1 +
 Documentation/btrfs-qgroup.txt | 110 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)
 create mode 100644 Documentation/btrfs-qgroup.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 645a8e4..84a4859 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -27,6 +27,7 @@ MAN8_TXT += btrfs-inspect-internal.txt
 MAN8_TXT += btrfs-send.txt
 MAN8_TXT += btrfs-receive.txt
 MAN8_TXT += btrfs-quota.txt
+MAN8_TXT += btrfs-qgroup.txt
 #MAN8_TXT += btrfs-replace.txt
 #MAN8_TXT += btrfs-dedup.txt
 
diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
new file mode 100644
index 0000000..d054423
--- /dev/null
+++ b/Documentation/btrfs-qgroup.txt
@@ -0,0 +1,110 @@
+btrfs-qgroup(8)
+===============
+
+NAME
+----
+btrfs-qgroup - control the quota group of a btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs qgroup' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs qgroup' is used to control quota group(qgroup) of a btrfs filesystem.
+
+NOTE: To use qgroup, it needs to enable quota first using 'btrfs quota'
+command.
+
+WARNING: Qgroup is not stable yet and will impact performance in current mainline
+kernel(v3.14 so far).
+
+QGROUP
+------
+Quota group or qgroup in btrfs has its hierarchy like subvolume.
+One subvolume/snapshot can reach its quota limits if it consumes all the quota
+assigned to it or any of the parent qgroup(s).
+
+Also for snapshot, it consumes no quota initially since all its data
+shares with its parent, so only modification in snapshot consumes quota.
+
+Every subvolume/snapshot will have its own qgroup with id '0/<subvolume id>'
+upon creating, but can be later destroyed by 'btrfs qgroup destroy' command.
+
+NOTE: If the qgroup of a subvolume is destroyed, quota about the subvolume
+will not be functional until qgroup '0/<subvolume id>' is created again.
+
+SUBCOMMAND
+----------
+'assign' <src> <dst> <path>::
+Assign qgroup <src> as the child qgroup of <dst> in the btrfs filesystem
+identified by <path>.
+
+'remove' <src> <dst> <path>::
+Remove the relationship between child qgroup <src> and parent qgroup <dst> in
+the btrfs filesystem identified by <path>.
+
+'create' <qgroupid> <path>::
+Create a subvolume quota group.
++
+For the '0/<subvolume id>' qgroup, a qgroup can be created even before the
+subvolume created.
+
+'destroy' <qgroupid> <path>::
+Destroy a qgroup.
++
+If a qgroup is no isolated,which means it is a parent or child qgroup, it
+can't be destroyed.
+
+'show' [options] <path>::
+Show all qgroups in the btrfs filesystem identified by <path>.
++
+`Options`
++
+-p::::
+print parent qgroup id.
+-c::::
+print child qgroup id.
+-r::::
+print max referenced size of qgroup.
+-e::::
+print max exclusive size of qgroup.
+-F::::
+list all qgroups which impact the given path(include ancestral qgroups)
+-f::::
+list all qgroups which impact the given path(exclude ancestral qgroups)
+--sort=[\+/-]ATTR[,[+/-]ATTR]...::::
+list qgroups in order of ATTR.
++
+ATTR can be one or more of qgroupid,rfer,excl,max_rfer,max_excl.
++
+Prefix \'+' means ascending order and \'-' means descending order of ATTR.
+If no prefix is given, use ascending order by default.
++
+If multiple ATTRs is given, use comma to separate.
+
+'limit' [options] <size>|none [<qgroupid>] <path>::
+Limit the size of a qgroup to <size> or no limit in the btrfs filesystem
+identified by <path>.
++
+If <qgroupid> is not given, qgroup of the subvolume identified by <path>
+is used if possible.
+
+EXIT STATUS
+-----------
+'btrfs qgroup' returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
+`btrfs-subvolume`(8),
+`btrfs-quota`(8),
-- 
1.9.1

