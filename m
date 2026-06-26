Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C7B3EFFD2;
	Fri, 26 Jun 2026 11:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782472883; cv=none; b=SafmUutjMjCDyygyg7SQuEwuHFeVhezE5V0eADVqBdS/GnEIWtPnbR8WZHvGKhgWiStlko7WMqKGFYGU2ZLN88eKvPawKWgmha6JIrjOFZ8L6nxw85ltbc3Ss8A2MosHdRoPiiqZqzD9nYBxf/h8m1boJ2mDwBHoC/ffcuqzoz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782472883; c=relaxed/simple;
	bh=5/vHK6smVAo4K0fOyGVx5MarSc9aDmJrNwEGTdE/aW4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jsC+499DpUUlWO21zJWE78WFiWaZkB0P2VbszspLROdnWTIIoBMWATDBW0fDZA27WqzJF8ua6zxxp37ek5FUp1WsD3CRpk4pBgx5mgFSW+GugQaNYVVx3OAryOWg1OMBHlC/5bme6m4RS0aIERPcVd/Z88AGP/ZybiUBiIzFse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sne5ExHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sne5ExHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C461F000E9;
	Fri, 26 Jun 2026 11:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782472881;
	bh=xWcM9mNBvMsc9PHycbLAuu17G/xM5QiL8WhgXegdwHo=;
	h=From:Date:Subject:To:Cc;
	b=Sne5ExHxqDY+E4bwsmVPrUBJiqxGN/TcpC5Yx98tUT7G3cSm5fDMzqL0oEBvo0q5B
	 ksdmxYrPRDLuQqi9DEjdo10R9iKBVaNqQFXavpAq/PrNafs1oAabdHe/FY9JpB0pZr
	 Qx3/VwPo+nul0GB0+aauAvBjh1ey22czQ33QzvIiDR5ChEXhl6zGVDktrfAt/jhb9R
	 5UV0JVTRQs32sRflh7imaP4yzdpV8oF6yqQRwZBxaIypvslkBOB1PANbQmMZXUkOyf
	 TRno+Hbj+p9Zgvjj1eLPoL3diH4T6gGV2Tt8QXozmrsJ3nBP2OqF2/8ryfy3SXYZty
	 2+7qp9x8xn8og==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 26 Jun 2026 07:21:03 -0400
Subject: [PATCH] btrfs: add EM_WARN_ON_ONCE() to dump the extent map on a
 warning
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260626-em-warn-on-dump-v1-1-365600d9473c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MTQqAIBBA4avIrBuwgaS6SrSIHGsWaij9QHj3p
 OW3eO+FzEk4w6heSHxJlhgq2kbBui9hYxRbDaTJaEMG2eO9pIAxoD39gdzTQERmcNRBrY7ETp7
 /OM2lfFOJdp1hAAAA
X-Change-ID: 20260626-em-warn-on-dump-e82922269f25
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5092; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=5/vHK6smVAo4K0fOyGVx5MarSc9aDmJrNwEGTdE/aW4=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqPmCrnELLRguq62DIL3PpbY5EVx0wsbKpOFY6Z
 3IHKCKcBmmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaj5gqwAKCRAADmhBGVaC
 FWVpD/98a+lNWiniCZRKD//9ITGR6iE7nSgAujiD+8bCvBIwIvqVbnIw2LD0CjE+e6GGemuj6az
 z/RbArF88uAoxdg/B11Sdb6DUlZCQUDsIZKt0IR2ESNnA3a09OaObYSoN2K6N/tiRfzz23/MpIL
 64AA9rc9/7DxW4+kL/rWv7he6ZV6gvFyK59CWzquVkTbFe+evtZqaE/NzfxSi3XLZO3cYpvCdMI
 9Yeg6X6WNfOmo+PT4LBUtD4t9mZSUa5fPFYa+4cBcK9C+Os20cWlKCTCbBM+eX4QYN79lbKaruT
 C5SCy6yvSkbg78g6upKqxf/4Yn51isA7AP3FtnF9mi3n6QGt/py9JF4+pYkK+4B4odcdkIfrl1w
 vx7mflI8uwiURNy+GtegrleeYD7bz7Um94piJKpl7TnQ0ZYSo5LOiO2BVJ6paFVobl+S77bA554
 udl5+QIxzHDP6/9twcJ8VDc1jQ6fcd/yBlo7Ly38vL7pawFmjoeoHott72wecjCLC5LEYJUstbj
 J9/G2uUCvJF7qfFlOP2GMN+djwAlSjf91SnQdbNTkR8wJcu3LEyRbnr6K2Tz3DXBksyffR+opmg
 MdcZPBoocBYxi4ElP53cutNg+8OzdYU7YXZCCMU3xT949taIzIsLTjAnnfiJyH49xIgxO+DwGuy
 0Dh6O394AVBWuFQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

When an extent_map trips a consistency check in the free path, the bare
WARN_ON() only gives a stack trace.  For the checks in
btrfs_free_extent_map():

	WARN_ON(btrfs_extent_map_in_tree(em));
	WARN_ON(!list_empty(&em->list));

that means the report tells us an extent map was freed while still in the
tree, or while still linked onto a list (e.g. an inode's modified_extents
list), but nothing about the map itself: its flags, refcount, or its
geometry.

Borrow the pattern the mm code uses with VM_WARN_ON_ONCE_FOLIO() and
friends, which dump the offending object via dump_page() before the
warning.  Add btrfs_dump_extent_map(), a helper that prints an extent
map's geometry, flags, refcount and list/tree membership, and an
EM_WARN_ON_ONCE(cond, em) macro that dumps the map before triggering the
warning and stack trace.  As with the VM_*_ONCE helpers it fires only
once, which keeps these checks from spamming the log on a filesystem
that is repeatedly hitting them.

Unlike the existing dump_extent_map() helper (which is gated behind
CONFIG_BTRFS_DEBUG and calls ASSERT(0)) and unlike the VM_* helpers
(gated behind CONFIG_DEBUG_VM), EM_WARN_ON_ONCE() is always compiled in,
since the conditions it guards can be hit on production kernels and the
extra context is what makes those reports actionable.  No btrfs_fs_info
is available at the call site, so the helper uses the plain printk helpers
rather than the device-aware btrfs_*() ones.

Convert both checks in btrfs_free_extent_map() to use it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
We've seen a number of crashes in our fleet that have shown WARN_ON()
pops from the list_empty() check here. I'm hoping this might give us a
bit more info.
---
 fs/btrfs/extent_map.c | 20 ++++++++++++++++++--
 fs/btrfs/extent_map.h | 22 ++++++++++++++++++++++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6b79bff241f2..670143f7d473 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -63,8 +63,8 @@ void btrfs_free_extent_map(struct extent_map *em)
 	if (!em)
 		return;
 	if (refcount_dec_and_test(&em->refs)) {
-		WARN_ON(btrfs_extent_map_in_tree(em));
-		WARN_ON(!list_empty(&em->list));
+		EM_WARN_ON_ONCE(btrfs_extent_map_in_tree(em), em);
+		EM_WARN_ON_ONCE(!list_empty(&em->list), em);
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
@@ -316,6 +316,22 @@ static void dump_extent_map(struct btrfs_fs_info *fs_info, const char *prefix,
 	ASSERT(0);
 }
 
+/*
+ * Dump the contents of an extent map to the kernel log.  Used by
+ * EM_WARN_ON_ONCE() to print context about the offending map before its
+ * warning and stack trace.
+ */
+void btrfs_dump_extent_map(const struct extent_map *em, const char *prefix)
+{
+	pr_crit(
+"BTRFS: %s: em=%p start=%llu len=%llu disk_bytenr=%llu disk_num_bytes=%llu offset=%llu ram_bytes=%llu generation=%llu flags=0x%x refs=%u in_tree=%d list_empty=%d list=(next=%p prev=%p)\n",
+		prefix, em, em->start, em->len, em->disk_bytenr,
+		em->disk_num_bytes, em->offset, em->ram_bytes, em->generation,
+		em->flags, refcount_read(&em->refs),
+		btrfs_extent_map_in_tree(em), list_empty(&em->list),
+		em->list.next, em->list.prev);
+}
+
 /* Internal sanity checks for btrfs debug builds. */
 static void validate_extent_map(struct btrfs_fs_info *fs_info, struct extent_map *em)
 {
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6f685f3c9327..1d2efd4a5665 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -8,6 +8,8 @@
 #include <linux/rbtree.h>
 #include <linux/list.h>
 #include <linux/refcount.h>
+#include <linux/bug.h>
+#include <linux/stringify.h>
 #include "fs.h"
 
 struct btrfs_inode;
@@ -175,6 +177,26 @@ int btrfs_split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pr
 
 struct extent_map *btrfs_alloc_extent_map(void);
 void btrfs_free_extent_map(struct extent_map *em);
+void btrfs_dump_extent_map(const struct extent_map *em, const char *prefix);
+
+/*
+ * Warn once about a condition involving an extent map, dumping the offending
+ * map's contents (geometry, flags, refcount and list/tree membership) before
+ * the warning and stack trace, much like VM_WARN_ON_ONCE_FOLIO() does for
+ * folios.
+ */
+#define EM_WARN_ON_ONCE(cond, em) ({					\
+	static bool __section(".data..once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(__ret_warn_once && !__warned)) {			\
+		btrfs_dump_extent_map((em),				\
+			"EM_WARN_ON_ONCE(" __stringify(cond) ")");	\
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
 int __init btrfs_extent_map_init(void);
 void __cold btrfs_extent_map_exit(void);
 int btrfs_unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen);

---
base-commit: eae9071be4d8d386e6530120bdaee42f6da1f70f
change-id: 20260626-em-warn-on-dump-e82922269f25

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

