Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41414 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351AbaFCGTG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 02:19:06 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s536J4UD013419
	for <linux-btrfs@vger.kernel.org>; Tue, 3 Jun 2014 14:19:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Documentation: Add filter section for btrfs-balance.
Date: Tue, 3 Jun 2014 14:20:08 +0800
Message-ID: <1401776408-32699-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Man page for 'btrfs-balance' mentioned <filters> but does not explain
them, which make end users hard to use '-d', '-m' or '-s options.

This patch will use the explanations from
https://btrfs.wiki.kernel.org/index.php/Balance_Filters to enrich the
man page.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-balance.txt | 60 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index 37d8781..de93c92 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -37,11 +37,11 @@ given balance all chunks in a filesystem.
 `Options`
 +
 -d[<filters>]::::
-act on data chunks
+act on data chunks. See `FILTERS` section for details about <filters>.
 -m[<filters>]::::
-act on metadata chunks
+act on metadata chunks. See `FILTERS` section for details about <filters>.
 -s[<filters>]::::
-act on system chunks (only under -f)
+act on system chunks (only under -f). See `FILTERS` section for details about <filters>.
 -v::::
 be verbose
 -f::::
@@ -61,6 +61,60 @@ Show status of running or paused balance.
 +
 If '-v' option is given, output will be verbose.
 
+FILTERS
+-------
+From kernel 3.3 onwards, btrfs balance can limit its action to a subset of the
+full filesystem, and can be used to change the replication configuration (e.g.
+moving data from single to RAID-1). This functionality is accessed through the
+'-d', '-m' or '-s' options to btrfs balance start, which filter on data,
+metadata and system blocks respectively.
+
+A filter has the following stucture: ::
+'type'[='params'][,'type'=...]
+
+The available types are: ::
+*profiles*::::
+Balances only block groups with the given replication profiles. Parameters
+are a list of profile names separated by |.
+
+*usage*::::
+Balances only block groups with usage under the given percentage. The
+value of 0 is allowed and will clean up completely unused block groups, this
+should not require any new space allocated. You may want to use usage=0 in
+case balance is returnin ENOSPC and your filesystem is not too full.
+
+*devid*::::
+Balances only block groups which have at least one chunk on the given
+device (by btrfs device ID -- use btrfs fi show to list device IDs)
+
+*drange*::::
+Balances only block groups which overlap with the given byte range on any
+device. (Use in conjunction with "devid" to filter on a specific device). The
+parameter is a range specified as <start..end>.
+
+*vrange*::::
+Balances only block groups which overlap with the given byte range in the
+filesystem's internal virtual address space. This is the address space that
+most reports from btrfs in the kernel log use. The parameter is a range
+specified as <start..end>.
+
+*convert*::::
+Convert each selected block group to the given profile name identified by
+parameters.
+
+*soft*::::
+Takes no parameters. Only has meaning when converting between profiles.
+When doing convert from one profile to another and soft mode is on,
+restriper won't touch chunks that already have the target profile. This is
+useful if e.g. half of the FS was converted earlier.
++
+The soft mode switch is (like every other filter) per-type. This means
+that we can convert for example meta chunks the "hard" way while converting
+data chunks selectively with soft switch.
+
+Profile names, used in profiles and convert are one of: 'raid0', 'raid1',
+'raid10', 'raid5', 'raid6', 'dup', 'single'.
+
 EXIT STATUS
 -----------
 *btrfs balance* returns a zero exist status if it succeeds. Non zero is
-- 
1.9.3

