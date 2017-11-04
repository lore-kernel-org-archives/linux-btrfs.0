Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:11465 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756718AbdKDOVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 10:21:06 -0400
Date: Sat, 4 Nov 2017 22:20:15 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH 3/8] btrfs-progs: qgroup-verify: Move qgroup
 classification out of report_qgroups
Message-ID: <20171104142015.GB513@fnst.localdomain>
References: <20171027072936.4697-1-wqu@suse.com>
 <20171027072936.4697-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171027072936.4697-4-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 03:29:31PM +0800, Qu Wenruo wrote:
>The original qgroup-verify integrates qgroup classification into
>report_qgroups().
>This behavior makes silent qgroup repair (or offline rescan) impossible.
>
>To repair qgroup, we must call report_qgroups() to trigger bad qgroup
>classification, which will output error message.
>
>This patch moves bad qgroup classification from report_qgroups() to
>qgroup_verify_all().
>The functionality is not changed, but provides the basis for later
>silent qgroup repair.
>
>Signed-off-by: Qu Wenruo <wqu@suse.com>
>---
> qgroup-verify.c | 28 ++++++++++++++++++++++++++--
> 1 file changed, 26 insertions(+), 2 deletions(-)
>
>diff --git a/qgroup-verify.c b/qgroup-verify.c
>index f509cdb9317a..67bd8b96ddd3 100644
>--- a/qgroup-verify.c
>+++ b/qgroup-verify.c
>@@ -1319,8 +1319,7 @@ void report_qgroups(int all)
> 	while (node) {
> 		c = rb_entry(node, struct qgroup_count, rb_node);
> 
>-		if (report_qgroup_difference(c, all))
>-			list_add_tail(&c->bad_list, &bad_qgroups);
>+		report_qgroup_difference(c, all);
> 
> 		node = rb_next(node);
> 	}
>@@ -1358,9 +1357,20 @@ void free_qgroup_counts(void)
> 	}
> }
> 
>+static bool is_bad_qgroup(struct qgroup_count *count)
>+{
>+	struct qgroup_info *info = &count->info;
>+	struct qgroup_info *disk = &count->diskinfo;
>+	s64 excl_diff = info->exclusive - disk->exclusive;
>+	s64 ref_diff = info->referenced - disk->referenced;
>+
>+	return (excl_diff || ref_diff);
>+}
>+

The function is_bad_qgroup can be reused in report_qgroup_difference.


> int qgroup_verify_all(struct btrfs_fs_info *info)
> {
> 	int ret;
>+	struct rb_node *node;
> 
> 	if (!info->quota_enabled)
> 		return 0;
>@@ -1395,6 +1405,20 @@ int qgroup_verify_all(struct btrfs_fs_info *info)
> 
> 	ret = account_all_refs(1, 0);
> 
>+	/*
>+	 * Do the correctness check here, so for callers who don't want
>+	 * verbose report can skip calling report_qgroups()
>+	 */
>+	node = rb_first(&counts.root);
>+	while (node) {
>+		struct qgroup_count *c;
>+
>+		c = rb_entry(node, struct qgroup_count, rb_node);
>+		if (is_bad_qgroup(c))
>+			list_add_tail(&c->bad_list, &bad_qgroups);
>+		node = rb_next(node);
>+	}
>+
> out:
> 	/*
> 	 * Don't free the qgroup count records as they will be walked
>-- 
>2.14.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-- 
Thanks,
Lu


