Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48837 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753500AbdLDKWB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 05:22:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CD8FB48AE759
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Dec 2017 18:21:57 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 4/4] btrfs-progs: qgroup: allow show qgroup in order of subvol path
Date: Mon, 4 Dec 2017 18:20:44 +0800
Message-ID: <20171204102044.25702-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20171204102044.25702-1-lufq.fnst@cn.fujitsu.com>
References: <20171204102044.25702-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You may want to sort qgroup with the subvol path, now you can use
--sort=path.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
Changelog:
v2:
rebase on the qgroup cleanup

 Documentation/btrfs-qgroup.asciidoc |  2 +-
 cmds-qgroup.c                       |  2 +-
 qgroup.c                            | 22 +++++++++++++++++++++-
 qgroup.h                            |  1 +
 4 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 3053f2e6..72a2004e 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -120,7 +120,7 @@ show sizes in TiB, or TB with --si.
 --sort=[\+/-]<attr>[,[+/-]<attr>]...::::
 list qgroups in order of <attr>.
 +
-<attr> can be one or more of qgroupid,rfer,excl,max_rfer,max_excl.
+<attr> can be one or more of qgroupid,rfer,excl,max_rfer,max_excl,path.
 +
 Prefix \'+' means ascending order and \'-' means descending order of <attr>.
 If no prefix is given, use ascending order by default.
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index d07bb0c0..604a275e 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -284,7 +284,7 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"-f             list all qgroups which impact the given path",
 	"               (excluding ancestral qgroups)",
 	HELPINFO_UNITS_LONG,
-	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
+	"--sort=qgroupid,rfer,excl,max_rfer,max_excl,path",
 	"               list qgroups sorted by specified items",
 	"               you can use '+' or '-' in front of each item.",
 	"               (+:ascending, -:descending, ascending default)",
diff --git a/qgroup.c b/qgroup.c
index cfaed5ba..9b49d6fb 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -415,12 +415,31 @@ static int comp_entry_with_max_excl(struct btrfs_qgroup *entry1,
 	return is_descending ? -ret : ret;
 }
 
+static int comp_entry_with_path(struct btrfs_qgroup *entry1,
+				struct btrfs_qgroup *entry2,
+				int is_descending)
+{
+	int ret;
+
+	if (!entry1->path && !entry2->path)
+		ret = 0;
+	else if (!entry1->path)
+		ret = -1;
+	else if (!entry2->path)
+		ret = 1;
+	else
+		ret = strcmp(entry1->path, entry2->path);
+
+	return is_descending ? -ret : ret;
+}
+
 static btrfs_qgroup_comp_func all_comp_funcs[] = {
 	[BTRFS_QGROUP_COMP_QGROUPID]	= comp_entry_with_qgroupid,
 	[BTRFS_QGROUP_COMP_RFER]	= comp_entry_with_rfer,
 	[BTRFS_QGROUP_COMP_EXCL]	= comp_entry_with_excl,
 	[BTRFS_QGROUP_COMP_MAX_RFER]	= comp_entry_with_max_rfer,
-	[BTRFS_QGROUP_COMP_MAX_EXCL]	= comp_entry_with_max_excl
+	[BTRFS_QGROUP_COMP_MAX_EXCL]	= comp_entry_with_max_excl,
+	[BTRFS_QGROUP_COMP_PATH]	= comp_entry_with_path
 };
 
 static char *all_sort_items[] = {
@@ -429,6 +448,7 @@ static char *all_sort_items[] = {
 	[BTRFS_QGROUP_COMP_EXCL]	= "excl",
 	[BTRFS_QGROUP_COMP_MAX_RFER]	= "max_rfer",
 	[BTRFS_QGROUP_COMP_MAX_EXCL]	= "max_excl",
+	[BTRFS_QGROUP_COMP_PATH]	= "path",
 	[BTRFS_QGROUP_COMP_MAX]		= NULL,
 };
 
diff --git a/qgroup.h b/qgroup.h
index 2003f834..f714d2eb 100644
--- a/qgroup.h
+++ b/qgroup.h
@@ -69,6 +69,7 @@ enum btrfs_qgroup_comp_enum {
 	BTRFS_QGROUP_COMP_EXCL,
 	BTRFS_QGROUP_COMP_MAX_RFER,
 	BTRFS_QGROUP_COMP_MAX_EXCL,
+	BTRFS_QGROUP_COMP_PATH,
 	BTRFS_QGROUP_COMP_MAX
 };
 
-- 
2.14.3



