Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641925B0A2
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2026 06:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784960681; cv=none; b=MsO6i/8t9/lioR7ZU6TxobO+o0zjGcLw1QEZwN1S9nkjn+dJqQH2SqVxS38wCUYRsNJUx7eaVYEF8b3QBDB4iS3NC1vawkL8OFfgMdx1qudP++RgQTVKDHhxsmIZ6i9BqAyEwrgl4b4BNk0F2IvCV7cwmT2kh06yKt8McvQadCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784960681; c=relaxed/simple;
	bh=eH8hQ75UL9YbkLhyHd/PHRl94KsSH64UAcxOioanZPM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=K2WPUf6W0cGXqScwHMYC7canFT/YrnmGjuEXKLtxAHXur61tRwKY5MtiUdpS5Bc9/CnWfEBPSFvfy3wE0e3IBCUPF2olhvphP31gHA6XUOHa1NzmRyJ8UmMLQmx8mP+7DmLEeUgy7TSzsSbYmRFFg37lVT5VbNGNOX0KWTzs6Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ichtC/tg; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L2kjK2kL; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ichtC/tg";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L2kjK2kL"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 8FE8F1D0022A;
	Sat, 25 Jul 2026 02:24:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Sat, 25 Jul 2026 02:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1784960677; x=1785047077; bh=9gqk0oiZw/guUG0+vf1Tb
	UFBKNnp3IPoYjmo77cp6tc=; b=ichtC/tgs8814e9NlfQUJCbh7dJ48lavD0S53
	4rlwvfyRmUjhgdFtdiKydQZOK7eQtOvU6cea7p0wh+6E6UEggBDAO1O4VZ0SEtll
	w6/kDoOaqgLPEOedJ0FUcW+5N2kfJr6BVRlTG3bzSvOanzcf65QVCZcpYc8iKGRR
	EYnTKjncyWqsAN7SXYIC54Z6gc3jmB4AITAqJ9950rFXyaBtiM2otRCOhu1Q9FD+
	aG0Ls9mhuK6aqn2RzJuRcTNCj7EhfCHDg8oM+jrbxZ6rCmu6Wb6Vitrj4VDbO8x0
	GBPv9laKelRfCHZ6UgMoTMw3LtS03U7ZOEc+bvk3VkaIPmgcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784960677; x=1785047077; bh=9gqk0oiZw/guUG0+vf1TbUFBKNnp3IPoYjm
	o77cp6tc=; b=L2kjK2kL3ecuMmGlPVxy2GXUcpjuWGubqON+yH/KX3t43fblVNr
	UjgbFbMh4Z3Crcv8PPo+3dU7aoS8NLTZtgWTZq0EPJlJzxxPbdPTUzJkDh8wbd5S
	b+RZDwj6OAdr4VTcTsFcr6F7qf64CVbtbEit2/LHUoleWex9vYkTCF/UrFTaOlRO
	pztdTU3sN8T61B8cwY0I3hJ8PD0qcla5Ejy0/nsBFO7CVp3zdnwF7vqQqT2mJ7T1
	FHWphBFS/t0Y30WVOYTWNEaawmJEp4RGRZGZL3C1nzyRValsrxhEOZA92FlNfn6B
	dMZVTDPADP+7zVnB2hjzpxMUztpT55GnLdQ==
X-ME-Sender: <xms:pVZkajtW3rWV0fl-6aeSmtihMQ6K3klu9lPHQMtnyq8BZdSTXrYZ8A>
    <xme:pVZkaqdYG7LLNV_l3LxPRbTgjKxLxDqXCITcJve-hXFmub9V5G3jmTR31UhV3QKbU
    K_c_XFaF5qCk_gEraJuutzEsKAvDdWM8UDcfogNYdrdJPJfsLQw9A>
X-ME-Received: <xmr:pVZkaka_hycbgkIXjx0w9YAeILuaBBT66S9SjaHNTdix65QNfoAsunERnVCp6G7nb8B76yL20flxQiN95BvTDDXmv60>
X-ME-Proxy-Cause: dmFkZTFYFy9fRNMLDxwbDLu0m8/qME58jArZxaPHXHnqsbr+ZjQSX2e5p4cn7ZSRYmjxy0
    kUOC9rQGF/maI7NwqAS8w5lX0GBhBtNZCwA5Emd7x24E8F9cET2EkPXtT7KZMi+D/N2i6I
    TEHJP6QcSafPUKk6jIhKq4uiHvp72wA/Lc0C7jc/ZBkOxSZrcajGd3m3uE/ogFp9rVLri6
    v5/q5ncnewoLJ2qO0xM1Xk3v0iodRP1yMEF9Yd396oe8Jo8zzMpoQhTEVtmxdwiFDNnx81
    Ls1Mw2EIxgXIcgKHkgmi7sB/GefK0IhKsW4zGsM2LOw3AKIpDpXCXu4QzP51sCqZPqIWs5
    Z9xyEL37/zEYfk1WEx1ZLauYDgGof/VlmakmRnbRaiN6r9NFaMV/I2dgZwKPpBoRwbGQv1
    v5nJsbNZHvunSg6w8NT4zSkyn96SxDOTCt2PecKDJ8S+CYvQJhj5JBls7lnLUMun6YuOGt
    PgrWY0aqpX2od6AKRBKTlDoVy44NbRS4Dbf9MBChy2Yje/tik5SXMXK7tbOc3RjWpMXYky
    Ab/07Zgb7K/4EAAjgICcULc7mTww/uZ/PqxnQKi/bfLJ+H/6D6zsOTMTLtqrXPjllhNLIA
    6xvJWRn9MsIGEsUjJadp1t+gdevyj8PB6loV5613OYsFdBzWIRE9IA2pp4Kw
X-ME-Proxy: <xmx:pVZkatWdB_v7UcBUQOcoszkusNLGcingJUu3fbtbuhzojmQkJThOlA>
    <xmx:pVZkamgPLtoabYq6mbbodkReAdpSkixMXYPlIzm2I0KPkA9oTz2o6w>
    <xmx:pVZkarXq60gnkztl7izop3Wu3Rt-mLjwjL0Lmv574Fi-i9h5T0VwRA>
    <xmx:pVZkatM_wjH7Ro0f48BJ_vmL0EaTMxNNS8tQ_vHzHdCA2wqwdc6fww>
    <xmx:pVZkarQryP5P_mebOesWQ2TtXUJ4Auv5XprzHrKkge4a-cCf6mRgZGtD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 25 Jul 2026 02:24:36 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
Date: Fri, 24 Jul 2026 23:24:18 -0700
Message-ID: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CAVEAT:
This is RFC code mostly authored by an LLM. I spent a lot of time and
effort working on the concepts and invariants so I do personally believe
this is a valid design, and I took a big pass on the writeback and
dirty_folio part, but I only gave the fixup worker part a quick pass.
The intent is to demonstrate roughly the complexity of a proper solution
and the sorts of issues it must deal with.

This has already been discussed quite a bit, but for completeness' sake,
I will re-iterate some of the key points to illustrate the design of the
proposed fix Qu and I have come up with after Matthew pointed us at
using btrfs_dirty_folio().

The problem scenario:
If we have a folio mmapped shared and then somebody does a dio read with
that folio as the read destination, then it is possible that the dio
will see a dirty destination page when it starts (and thus skip
dirtying and just gup pin it) but then while it is doing the read, btrfs
finishes writing it back and by the endio, the folio is clean. In that
case, the dio read must re-dirty the folio with aops->dirty_folio():

btrfs_check_read_bio()
|- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
   |- bio_check_pages_dirty()
      |- bio_dirty_fn()
         |- bio_release_pages(bio, true)
            |- __bio_release_pages(bio, mark_dirty == true)
               |- folio_lock()
               |- folio_mark_dirty()
                  |- aops->dirty_folio()
               |- folio_unlock()

A data block normally moves through writeback as follows:
TASK
  folio_lock
  write              clean -> dirty bit + delalloc
  folio_unlock
WRITEBACK
  for-each-dirty-folio:
    folio_lock
    run_delalloc     delalloc consumed  -> dirty bit + OE
    submission       dirty bit consumed -> writeback bit + OE
    folio_unlock
ENDIO
  endio              OE bytes accounted
  OE finish          writeback -> clean; destroy OE

Three critical invariants that this path maintains are:
I1. Any dirty block is covered by delalloc xor an ordered extent
I2. Any dirty block covered by an OE will be submitted into that OE
I3. Any dirty block already submitted into an OE will not be submitted
    again into the same OE.

These ensure that the block will be written exactly once. It is clear
that not reserving delalloc for the re-dirty case violates I1.

This situation, even without bs < folio_size, has long required btrfs to
fixup such dirty pages during writeback with an asynchronous worker that
is allowed to do this expensive work and writeback does not proceed for
a folio while it is doing this work.

Commit 247e743cbe6e ("Btrfs: Use async helpers to deal with pages that have been improperly dirtied")
introduced the COW fixup to catch exactly this class at writeback, way
back in 2008.

Since then, there have been many advances to prevent most of the causes
of such re-dirtying and we thought we could get away with removing the
annoying cow-fixup in the hope of simplifying writeback for large folio
support.

Commit b2a9f217ad3f ("btrfs: remove the COW fixup mechanism")
Commit 4927b141877c ("btrfs: remove folio ordered flag and subpage bitmap")

Since it turns out this assumption was incorrect, as evidenced by the
report and attendant reproducers, we must reintroduce the fixup concept.

This is of course critically further complicated by bs < folio_size. In
that case, rather than just a folio dirty bit, we have a bitmap for the
dirty blocks in the folio. And the (also broken) invariant is:
I4. folio dirty IFF at least one block bitmap dirty.

The original report of a stall on a misinterpreted empty bitmap is
exactly evidence of a violation of I4.

It is exactly because of bs < folio_size we don't want to simply revert the
removal patches. The original fixup was not properly bs < folio_size
aware, which motivated removal in the first place. So we wish to build a
bs < folio_size aware fixup.

One other important detail from the old design, any normal write that
happens after a re-dirty but before a fixup is racing with the cow fixup
to do the delalloc reservation, therefore it must cancel the fixup state.
If it arrives after the reservation exists, it will be a normal dirty
overwrite. This critically informs the design in a pretty clear way.
fixup requiring re-dirty has folio granularity, while cancellation has
delalloc (block) granularity so while we only ever produce fixup in
chunks of folios, we must be able to clear it in blocks. Therefore we
must track the blocks needing fixup at block granularity.

The obvious way to do this is with a new bitmap in btrfs_folio_state,
but it is desirable to avoid that if possible. Unfortunately, I don't
think it is possible and the reason is subtle and leans on a sort of
extreme reproducer, but I think can be explained relatively succinctly.

Consider a folio whose two halves will land in different ordered extents
(can be accomplished with tricks using nodatasum) and a dio read is
running with it as the shared mmap estimation.

1. The front half:
   a. folio comes clean on a normal write
   b. dio read completes into the folio marking it fixup.
   c. a write comes for the previous folio for a range extending into
      this folio, this is a cancellation of the fixup which reserves
      space.
   d. writeback runs on the range *not* overlapping the folio. This half
      remains dirty but is now covered by an OE and is awaiting
      writeback running on its range to be submitted and finish the OE.
2. The back half:
   a. the folio is part of an OE that gets far enough along to clear
      writeback.
   b. dio read completes into the folio marking it fixup.

After this, the folio's front half is dirty in the "normal" sense, it
needs to be submitted to the OE waiting for it. It's a cancelled fixup.
Meanwhile, the second half is a true fresh fixup. So at this point if we
run writeback on this folio, we genuinely can't know what to do without
block level information. If we submit it, we submit unreserved dirty
from the back half. If we don't, we will never finish the OE waiting for
it. So it's either a corruption or a deadlock.

Thus, the full high level design picture:

- btrfs_data_dirty_folio(): For out of band non-reserving dirties,
  mark still-clean blocks inside EOF dirty and set their fixup bits
  (the event carries no range, so every clean block is suspect).
  Already-dirty blocks are covered or pending and are left alone.

- Writeback: skip fixup blocks and enqueue work for them

- writepage_fixup(): for each fixup block do the fixup reservation in a
  worker, after which the blocks can be written back normally.

- Typical reserving write paths cancel fixup state for the ranges they
  cover with btrfs_folio_cancel_fixup()

Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-borntraeger@linux.ibm.com/
Signed-off-by: Boris Burkov <boris@bur.io>
Assisted-by: LLM
---
 fs/btrfs/btrfs_inode.h       |   1 +
 fs/btrfs/defrag.c            |   1 +
 fs/btrfs/disk-io.c           |   6 +-
 fs/btrfs/extent_io.c         | 127 +++++++++++++++++
 fs/btrfs/file.c              |   2 +
 fs/btrfs/fs.h                |  20 +++
 fs/btrfs/inode.c             | 262 ++++++++++++++++++++++++++++++++++-
 fs/btrfs/reflink.c           |   1 +
 fs/btrfs/relocation.c        |   1 +
 fs/btrfs/subpage.c           |  93 +++++++++++++
 fs/btrfs/subpage.h           |  43 +++++-
 include/trace/events/btrfs.h |  35 +++++
 12 files changed, 585 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 7fdc6c3fd066..037445586b31 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -600,6 +600,7 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    loff_t actual_len, u64 *alloc_hint);
 int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_folio,
 			     u64 start, u64 end, struct writeback_control *wbc);
+int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio);
 int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
 					     int compress_type);
 int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 6ec5dd760d42..7de5febee9d1 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -1158,6 +1158,7 @@ static void defrag_one_locked_target(struct btrfs_inode *inode,
 		    start + len <= folio_pos(folio))
 			continue;
 		btrfs_folio_clamp_set_dirty(fs_info, folio, start, len);
+		btrfs_folio_cancel_fixup(fs_info, folio, start, len);
 	}
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 467075a0ebcb..98cfc8febddd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1757,6 +1757,7 @@ static int read_backup_root(struct btrfs_fs_info *fs_info, u8 priority)
 /* helper to cleanup workers */
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
+	btrfs_destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
@@ -1964,6 +1965,9 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->caching_workers =
 		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
 
+	fs_info->fixup_workers =
+		btrfs_alloc_ordered_workqueue(fs_info, "fixup", ordered_flags);
+
 	fs_info->endio_workers =
 		alloc_workqueue("btrfs-endio", flags, max_active);
 	fs_info->endio_meta_workers =
@@ -1989,7 +1993,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_write_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
-	      fs_info->caching_workers &&
+	      fs_info->caching_workers && fs_info->fixup_workers &&
 	      fs_info->delayed_workers && fs_info->qgroup_rescan_workers &&
 	      fs_info->discard_ctl.discard_workers)) {
 		return -ENOMEM;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d119dcf9e34b..02c161c61c36 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -36,6 +36,7 @@
 #include "dev-replace.h"
 #include "super.h"
 #include "transaction.h"
+#include "delalloc-space.h"
 
 static struct kmem_cache *extent_buffer_cache;
 
@@ -1462,6 +1463,128 @@ static bool find_next_delalloc_bitmap(struct folio *folio,
 	return true;
 }
 
+/*
+ * Fix up folios dirtied without delalloc reservations, e.g.
+ * set_page_dirty_lock() on a GUP pin after a clean writeback cycle
+ * (O_DIRECT reads into a MAP_SHARED mapping, KVM writing guest structures).
+ *
+ * Such writes notify the filesystem via dirty_folio, btrfs_data_dirty_folio()
+ * in our case.
+ *
+ * Our goal is to filter out of the submit_bitmap for blocks which need fixup
+ * before they can be submitted and if we find any such blocks, to queue
+ * fixup work in the fixup worker.
+ *
+ * btrfs_data_dirty_folio() flags such folios at dirtying time and records
+ * the affected blocks in the fixup bitmap.  That record is authoritative -
+ * every reserving path sets its block dirty bits under the folio lock
+ * before folio_mark_dirty(), and cancels the fixup state of blocks it
+ * takes over - so here, under the folio lock, each dirty block classifies
+ * three ways:
+ *
+ *   - EXTENT_DELALLOC: funded by a reserving write; submits this pass.
+ *   - covered by a live ordered extent, no fixup bit: pending its own
+ *     submission into that ordered extent; submits this pass.
+ *   - anything else: punted to the fixup worker, which reserves space
+ *     and sets delalloc for it like any reserving dirtier.
+ *
+ * Reservation cannot happen here: a reservation may flush for space, and we
+ * are the writeback path holding the folio lock - a flushing reservation
+ * can both wait on the async reclaim worker (whose flushing itself runs
+ * writeback) and start delalloc on this very inode.
+ *
+ * Return 0 to continue writeback of this folio, 1 if the folio was
+ * redirtied and unlocked (the caller must no longer touch it), or a
+ * negative error if the folio's dirty state is invalid (folio left
+ * locked, nothing submitted).
+ */
+static noinline_for_stack int writepage_fixup(struct btrfs_inode *inode,
+					      struct folio *folio,
+					      struct btrfs_bio_ctrl *bio_ctrl)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(&inode->vfs_inode);
+	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+	const u32 sectorsize = fs_info->sectorsize;
+	const u64 page_start = folio_pos(folio);
+	bool punt = false;
+	unsigned int bit;
+
+	/*
+	 * A folio was dirtied without calling aops->dirty_folio() which we
+	 * explicitly assert is not allowed.
+	 */
+	if (unlikely(bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio))) {
+		DEBUG_WARN();
+		btrfs_err_rl(fs_info,
+	"root %lld ino %llu folio %llu is dirty with an empty dirty bitmap",
+			     btrfs_root_id(inode->root), btrfs_ino(inode),
+			     folio_pos(folio));
+		return -EUCLEAN;
+	}
+
+	if (!folio_test_fixup_pending(folio))
+		return 0;
+
+	for_each_set_bit(bit, bio_ctrl->submit_bitmap, blocks_per_folio) {
+		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
+
+		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
+						start + sectorsize - 1,
+						EXTENT_DELALLOC))
+			continue;
+		if (btrfs_is_subpage(fs_info, folio) &&
+		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize)) {
+			struct btrfs_ordered_extent *ordered;
+
+			/*
+			 * Not a suspect: the only legal explanation for a
+			 * dirty, unfunded block is that it is pending its own
+			 * submission into a covering ordered extent - punting
+			 * it would starve that ordered extent forever, and
+			 * the worker could not see it anyway (its work list
+			 * is the fixup bits). Verify the ordered extent
+			 * exists; if not, the invariant is broken - leave the
+			 * block in the bitmap so submission fails loudly
+			 * (EUCLEAN) instead of silently repairing.
+			 */
+			ordered = btrfs_lookup_ordered_range(inode, start,
+							     sectorsize);
+			if (unlikely(!ordered))
+				DEBUG_WARN();
+			else
+				btrfs_put_ordered_extent(ordered);
+			continue;
+		}
+		/*
+		 * Block re-dirtied via dirty_folio(), requires async fixup.
+		 * All other blocks in the folio should proceed as normal so
+		 * that their OEs can make progress and complete.
+		 */
+		bitmap_clear(bio_ctrl->submit_bitmap, bit, 1);
+		punt = true;
+	}
+	if (punt) {
+		btrfs_queue_writepage_fixup(inode, folio);
+		/*
+		 * Keep the folio dirty for the punted blocks.  If nothing
+		 * is left to submit this pass, the folio is done and we own
+		 * the unlock, matching the async-submission contract.
+		 */
+		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
+		if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
+			folio_unlock(folio);
+			return 1;
+		}
+		return 0;
+	}
+	/* Every dirty block is now covered; the folio is ordinary again. */
+	if (btrfs_is_subpage(fs_info, folio))
+		btrfs_subpage_clear_fixup(fs_info, folio, page_start,
+					  folio_size(folio));
+	folio_clear_fixup_pending(folio);
+	return 0;
+}
+
 /*
  * Do all of the delayed allocation setup.
  *
@@ -1514,6 +1637,10 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
 	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
 
+	ret = writepage_fixup(inode, folio, bio_ctrl);
+	if (ret)
+		return ret;
+
 	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
 		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20e15dc30bfb..4ea0c0438fcb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -92,6 +92,7 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
 
 	btrfs_folio_clamp_set_uptodate(fs_info, folio, start_pos, num_bytes);
 	btrfs_folio_clamp_set_dirty(fs_info, folio, start_pos, num_bytes);
+	btrfs_folio_cancel_fixup(fs_info, folio, start_pos, num_bytes);
 
 	/*
 	 * we've only changed i_size in ram, and we haven't updated
@@ -1942,6 +1943,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	btrfs_folio_set_dirty(fs_info, folio, page_start, end + 1 - page_start);
 	btrfs_folio_set_uptodate(fs_info, folio, page_start, end + 1 - page_start);
+	btrfs_folio_cancel_fixup(fs_info, folio, page_start, end + 1 - page_start);
 
 	btrfs_set_inode_last_sub_trans(inode);
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 06b5884a9bcd..166f4c85b8cf 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -714,6 +714,13 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *endio_write_workers;
 	struct btrfs_workqueue *endio_freespace_worker;
 	struct btrfs_workqueue *caching_workers;
+
+	/*
+	 * Fixup workers reserve space for and fund dirty blocks that entered
+	 * the dirty state without notifying the filesystem (folios dirtied
+	 * through a GUP pin), making them safe to write.
+	 */
+	struct btrfs_workqueue *fixup_workers;
 	struct btrfs_workqueue *delayed_workers;
 
 	struct task_struct *transaction_kthread;
@@ -1198,6 +1205,19 @@ static inline void btrfs_wake_unfinished_drop(struct btrfs_fs_info *fs_info)
 	clear_and_wake_up_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags);
 }
 
+/*
+ * The folio has (or, for single-block folios, is) dirty blocks that were
+ * dirtied without notifying the filesystem (e.g. set_page_dirty_lock() on a
+ * GUP pin) and carry no reservation.  Set by btrfs_data_dirty_folio(), which
+ * records the affected blocks in the subpage fixup bitmap; cleared when the
+ * writepage fixup has covered every dirty block, or by a reserving write
+ * that covers the whole folio.  Reuses the PG_owner_2 bit that the folio
+ * ordered flag occupied before it was removed.
+ */
+#define folio_test_fixup_pending(folio)	folio_test_owner_2(folio)
+#define folio_set_fixup_pending(folio)	folio_set_owner_2(folio)
+#define folio_clear_fixup_pending(folio)	folio_clear_owner_2(folio)
+
 #define BTRFS_FS_ERROR(fs_info)	(READ_ONCE((fs_info)->fs_error))
 
 #define BTRFS_FS_LOG_CLEANUP_ERROR(fs_info)				\
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bbcbd9c44a47..3721d4c6b59e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2824,6 +2824,204 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				    EXTENT_DELALLOC | extra_bits, cached_state);
 }
 
+struct btrfs_writepage_fixup {
+	struct folio *folio;
+	struct btrfs_inode *inode;
+	struct btrfs_work work;
+};
+
+/*
+ * Fund the blocks of a folio that were dirtied without notifying the
+ * filesystem, queued by writepage_fixup() when writeback found them.
+ *
+ * The work item carries no range: the fixup bitmap (the folio flag on
+ * single-block folios) is the record of which blocks need funding, and it is
+ * the record the in-band paths can still cancel while this item waits to
+ * run.  Everything is re-derived under the folio lock.
+ *
+ * Unlike writeback, this context may block: the reservation may flush for
+ * space, and a covering ordered extent is waited out.  The latter cannot
+ * deadlock precisely because of the fixup bit - it means the block was clean
+ * when the unnotified dirtying hit, so any ordered extent covering it has
+ * already accounted it and needs nothing more from this folio's data.
+ */
+static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
+{
+	struct btrfs_writepage_fixup *fixup =
+		container_of(work, struct btrfs_writepage_fixup, work);
+	struct extent_state *cached_state = NULL;
+	struct extent_changeset *data_reserved = NULL;
+	unsigned long funded[BITS_TO_LONGS(BTRFS_MAX_BLOCKS_PER_FOLIO)] = { 0 };
+	struct folio *folio = fixup->folio;
+	struct btrfs_inode *inode = fixup->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const unsigned int blocks_per_folio = btrfs_blocks_per_folio(fs_info, folio);
+	const u32 sectorsize = fs_info->sectorsize;
+	const u64 page_start = folio_pos(folio);
+	const u64 page_end = folio_next_pos(folio) - 1;
+	unsigned int start_bit;
+	unsigned int end_bit;
+	unsigned int bit;
+	bool reserved;
+	int ret;
+
+	/*
+	 * Reserve for the whole folio before taking the folio lock, like
+	 * page_mkwrite: the reservation may flush, and flushing writeback
+	 * takes folio locks.  Which blocks actually need funding is only
+	 * knowable under the lock, so reserve the worst case and release
+	 * the unused ranges once the funded set is known.
+	 */
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
+					   folio_size(folio));
+	reserved = (ret == 0);
+again:
+	folio_lock(folio);
+
+	/*
+	 * The queueing writeback pass took references on the folio and the
+	 * inode, but nothing else is stable: an in-band write may have funded
+	 * the blocks and cancelled the fixup state, or the folio may have
+	 * been invalidated.  Then there is nothing left to do - and a failed
+	 * reservation against a folio that no longer needs one is no error.
+	 */
+	if (!folio->mapping || !folio_test_dirty(folio) ||
+	    !folio_test_fixup_pending(folio)) {
+		ret = 0;
+		goto out;
+	}
+
+	/* The folio still needs funding we could not get. */
+	if (ret)
+		goto out_error;
+
+	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state);
+
+	for (bit = 0; bit < blocks_per_folio; bit++) {
+		struct btrfs_ordered_extent *ordered;
+		const u64 start = page_start + (bit << fs_info->sectorsize_bits);
+
+		if (test_bit(bit, funded))
+			continue;
+		if (btrfs_is_subpage(fs_info, folio) &&
+		    !btrfs_subpage_test_fixup(fs_info, folio, start, sectorsize))
+			continue;
+		/* An in-band write may have funded the block while we waited. */
+		if (btrfs_test_range_bit_exists(&inode->io_tree, start,
+						start + sectorsize - 1,
+						EXTENT_DELALLOC))
+			continue;
+		ordered = btrfs_lookup_ordered_range(inode, start, sectorsize);
+		if (ordered) {
+			trace_btrfs_writepage_fixup_defer(inode, ordered);
+			btrfs_unlock_extent(&inode->io_tree, page_start,
+					    page_end, &cached_state);
+			folio_unlock(folio);
+			btrfs_start_ordered_extent(ordered);
+			btrfs_put_ordered_extent(ordered);
+			goto again;
+		}
+		ret = btrfs_set_extent_delalloc(inode, start,
+						start + sectorsize - 1, 0,
+						&cached_state);
+		if (ret) {
+			btrfs_unlock_extent(&inode->io_tree, page_start,
+					    page_end, &cached_state);
+			goto out_error;
+		}
+		trace_btrfs_writepage_fixup_reserve(inode, start, sectorsize);
+		if (btrfs_is_subpage(fs_info, folio))
+			btrfs_subpage_clear_fixup(fs_info, folio, start,
+						  sectorsize);
+		__set_bit(bit, funded);
+	}
+
+	/* Every fixup block is funded; the folio is ordinary again. */
+	folio_clear_fixup_pending(folio);
+	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_state);
+	goto out;
+
+out_error:
+	/*
+	 * The remaining unnotified blocks cannot be funded.  There is no
+	 * syscall to return this through, so surface it the way a failed
+	 * writeback would - record the error on the mapping - and drop the
+	 * blocks, or writeback would find and requeue them forever.
+	 */
+	mapping_set_error(folio->mapping, ret);
+	if (btrfs_is_subpage(fs_info, folio)) {
+		bool last = false;
+
+		for (bit = 0; bit < blocks_per_folio; bit++) {
+			const u64 start = page_start +
+					  (bit << fs_info->sectorsize_bits);
+
+			if (!btrfs_subpage_test_fixup(fs_info, folio, start,
+						      sectorsize))
+				continue;
+			last = btrfs_subpage_clear_and_test_dirty(fs_info,
+							folio, start,
+							sectorsize);
+		}
+		btrfs_folio_cancel_fixup(fs_info, folio, page_start,
+					 folio_size(folio));
+		if (last)
+			folio_clear_dirty_for_io(folio);
+	} else {
+		folio_clear_dirty_for_io(folio);
+	}
+	folio_clear_fixup_pending(folio);
+out:
+	if (reserved) {
+		btrfs_delalloc_release_extents(inode, folio_size(folio));
+		for_each_clear_bitrange(start_bit, end_bit, funded,
+					blocks_per_folio)
+			btrfs_delalloc_release_space(inode, data_reserved,
+				page_start + (start_bit << fs_info->sectorsize_bits),
+				(end_bit - start_bit) << fs_info->sectorsize_bits,
+				true);
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+	kfree(fixup);
+	extent_changeset_free(data_reserved);
+	/*
+	 * As a precaution, do a delayed iput in case it would be the last
+	 * iput that could need flushing space. Recursing back to the fixup
+	 * worker would deadlock.
+	 */
+	btrfs_add_delayed_iput(inode);
+}
+
+/*
+ * Queue funding of a folio's unnotified dirty blocks to the fixup worker.
+ * Called by writeback with the folio locked; the punted blocks stay dirty
+ * and the folio is redirtied, so writeback returns for them once the worker
+ * has funded them.
+ */
+int btrfs_queue_writepage_fixup(struct btrfs_inode *inode, struct folio *folio)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_writepage_fixup *fixup;
+
+	fixup = kzalloc_obj(*fixup, GFP_NOFS);
+	if (!fixup)
+		return -ENOMEM;
+
+	/*
+	 * The worker's space reservation happens outside the folio lock, and
+	 * folio->mapping cannot be trusted outside of it. Pin the inode
+	 * alongside the folio.
+	 */
+	ihold(&inode->vfs_inode);
+	folio_get(folio);
+	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL);
+	fixup->folio = folio;
+	fixup->inode = inode;
+	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
+	return 0;
+}
+
 /*
  * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
  *
@@ -5043,6 +5241,8 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
 
 	btrfs_folio_set_dirty(fs_info, folio, block_start,
 			      block_end + 1 - block_start);
+	btrfs_folio_cancel_fixup(fs_info, folio, block_start,
+				 block_end + 1 - block_start);
 
 	if (only_release_metadata)
 		btrfs_set_extent_bit(&inode->io_tree, block_start, block_end,
@@ -7519,6 +7719,9 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	folio_wait_writeback(folio);
 	wait_subpage_spinlock(folio);
 
+	/* The invalidated blocks no longer need fixup. */
+	btrfs_folio_cancel_fixup(fs_info, folio, page_start + offset, length);
+
 	/*
 	 * For subpage case, we have call sites like
 	 * btrfs_punch_hole_lock_range() which passes range not aligned to
@@ -10584,6 +10787,63 @@ static const struct file_operations btrfs_dir_file_operations = {
 	.setlease	= generic_setlease,
 };
 
+/*
+ *
+ * The folio is going dirty without going through a btrfs delalloc space
+ * reservation. This requires a fixup before writeback, so note that fact
+ * here.
+ * 
+ * This must not block and cannot fail: it can be called under the page
+ * table lock.  All the work is under spinlocks.
+ *
+ * For bs < folio_size, we require reserving callers to self-identify via
+ * bfs->reserving_dirty and use bitmaps to determine the blocks which are
+ * clean and need fixup.
+ *
+ * For bs == folio_size, we don't need self identification because we are
+ * guaranteed to already be covered by delalloc in the extent-io-tree.
+ *
+ * Note that this has no block level granularity and always marks all clean
+ * blocks for fixup.
+ *
+ * The record made here is authoritative: writepage_fixup() trusts it as-is
+ * rather than re-deriving it, and a dirty folio reaching writeback with no
+ * dirty blocks recorded at all is treated as a filesystem bug (EUCLEAN).
+ * If the record cannot be made (the folio is not fully uptodate, so clean
+ * blocks may hold never-read content that must not be marked dirty), the
+ * data keeps the long-standing semantics of unnotified writes.
+ */
+static bool btrfs_data_dirty_folio(struct address_space *mapping,
+				   struct folio *folio)
+{
+	struct btrfs_inode *inode = BTRFS_I(mapping->host);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	bool marked = false;
+
+	if (btrfs_is_subpage(fs_info, folio)) {
+		const struct btrfs_folio_state *bfs = folio_get_private(folio);
+		const u64 page_start = folio_pos(folio);
+		const u64 range_end = min_t(u64, page_start + folio_size(folio),
+					    round_up(i_size_read(&inode->vfs_inode),
+						     fs_info->sectorsize));
+
+		if (!READ_ONCE(bfs->reserving_dirty) &&
+		    folio_test_uptodate(folio) && range_end > page_start)
+			marked = btrfs_subpage_set_fixup_dirty(fs_info, folio,
+							       page_start,
+							       range_end - page_start);
+	} else if (!folio_test_dirty(folio) &&
+		   !btrfs_test_range_bit_exists(&inode->io_tree,
+						folio_pos(folio),
+						folio_next_pos(folio) - 1,
+						EXTENT_DELALLOC)) {
+		marked = true;
+	}
+	if (marked)
+		folio_set_fixup_pending(folio);
+	return filemap_dirty_folio(mapping, folio);
+}
+
 /*
  * btrfs doesn't support the bmap operation because swapfiles
  * use bmap to make a mapping of extents in the file.  They assume
@@ -10604,7 +10864,7 @@ static const struct address_space_operations btrfs_aops = {
 	.launder_folio	= btrfs_launder_folio,
 	.release_folio	= btrfs_release_folio,
 	.migrate_folio	= btrfs_migrate_folio,
-	.dirty_folio	= filemap_dirty_folio,
+	.dirty_folio	= btrfs_data_dirty_folio,
 	.error_remove_folio = generic_error_remove_folio,
 	.swap_activate	= btrfs_swap_activate,
 	.swap_deactivate = btrfs_swap_deactivate,
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 28bb05a92106..0c9e9081f589 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -141,6 +141,7 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 
 	btrfs_folio_set_uptodate(fs_info, folio, file_offset, block_size);
 	btrfs_folio_set_dirty(fs_info, folio, file_offset, block_size);
+	btrfs_folio_cancel_fixup(fs_info, folio, file_offset, block_size);
 out_unlock:
 	if (!IS_ERR(folio)) {
 		folio_unlock(folio);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index da54db75e7a9..936b32be14a3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3011,6 +3011,7 @@ static int relocate_one_folio(struct reloc_control *rc,
 			goto release_folio;
 		}
 		btrfs_folio_set_dirty(fs_info, folio, clamped_start, clamped_len);
+		btrfs_folio_cancel_fixup(fs_info, folio, clamped_start, clamped_len);
 
 		/*
 		 * Set the boundary if it's inside the folio.
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 2a9397be8116..44038fbf5f91 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -356,7 +356,17 @@ void btrfs_subpage_set_dirty(const struct btrfs_fs_info *fs_info,
 	spin_lock_irqsave(&bfs->lock, flags);
 	bitmap_set(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
 	spin_unlock_irqrestore(&bfs->lock, flags);
+	/*
+	 * Every caller of this helper is a reserving write path dirtying
+	 * exactly the range it reserved; the dirty_folio callback must not
+	 * treat it as potentially unnotified and drag the folio's clean
+	 * sibling blocks into COW (that breaks reflink sharing of the
+	 * untouched blocks, among other things).  Unnotified dirtiers call
+	 * folio_mark_dirty() directly and never pass through here.
+	 */
+	WRITE_ONCE(bfs->reserving_dirty, true);
 	folio_mark_dirty(folio);
+	WRITE_ONCE(bfs->reserving_dirty, false);
 }
 
 static void folio_clear_tags(struct folio *folio)
@@ -457,6 +467,88 @@ void btrfs_subpage_clear_writeback(const struct btrfs_fs_info *fs_info,
 	spin_unlock_irqrestore(&bfs->lock, flags);
 }
 
+void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
+			       struct folio *folio, u64 start, u32 len)
+{
+	struct btrfs_folio_state *bfs = folio_get_private(folio);
+	unsigned int start_bit = subpage_calc_start_bit(fs_info, folio,
+							fixup, start, len);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bfs->lock, flags);
+	bitmap_clear(bfs->bitmaps, start_bit, len >> fs_info->sectorsize_bits);
+	spin_unlock_irqrestore(&bfs->lock, flags);
+}
+
+/*
+ * In one pass under bfs->lock, mark every block with a clear dirty bit in the
+ * range both dirty and needing fixup.  Returns true if any block was marked.
+ *
+ * Only called from the dirty_folio callback, which owns the folio-level
+ * dirty flag; calling folio_mark_dirty() here would recurse.
+ */
+bool btrfs_subpage_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
+				   struct folio *folio, u64 start, u32 len)
+{
+	struct btrfs_folio_state *bfs = folio_get_private(folio);
+	unsigned int dirty_bit = subpage_calc_start_bit(fs_info, folio,
+							dirty, start, len);
+	unsigned int fixup_bit = subpage_calc_start_bit(fs_info, folio,
+							fixup, start, len);
+	const unsigned int nbits = len >> fs_info->sectorsize_bits;
+	unsigned long flags;
+	bool marked = false;
+
+	spin_lock_irqsave(&bfs->lock, flags);
+	for (unsigned int i = 0; i < nbits; i++) {
+		if (test_bit(dirty_bit + i, bfs->bitmaps))
+			continue;
+		set_bit(dirty_bit + i, bfs->bitmaps);
+		set_bit(fixup_bit + i, bfs->bitmaps);
+		marked = true;
+	}
+	spin_unlock_irqrestore(&bfs->lock, flags);
+	return marked;
+}
+
+/*
+ * A reserving write path establishing coverage for [start, start + len)
+ * cancels the fixup state of those blocks.  This is required for
+ * correctness, not an optimization: a stale fixup bit makes writepage_fixup()
+ * defer a block that its own ordered extent is waiting for, starving the
+ * ordered extent forever.  Only the writer can cancel reliably - by the time
+ * writeback samples the block, a neighboring folio may already have
+ * converted its delalloc into that ordered extent.
+ *
+ * For single-block folios the folio-level flag is the fixup state, so it is
+ * cleared only when the write covers the whole folio.
+ */
+void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
+			      struct folio *folio, u64 start, u32 len)
+{
+	u64 aligned_start;
+	u64 aligned_end;
+
+	if (!btrfs_is_subpage(fs_info, folio)) {
+		if (start <= folio_pos(folio) &&
+		    start + len >= folio_next_pos(folio))
+			folio_clear_fixup_pending(folio);
+		return;
+	}
+	btrfs_subpage_clamp_range(folio, &start, &len);
+	/*
+	 * Callers like btrfs_invalidate_folio() pass byte-granular ranges
+	 * (an unaligned truncate).  Only blocks fully inside the range lose
+	 * their fixup state: a partially covered block still holds live
+	 * data outside the range.
+	 */
+	aligned_start = round_up(start, fs_info->sectorsize);
+	aligned_end = round_down(start + len, fs_info->sectorsize);
+	if (aligned_end > aligned_start)
+		btrfs_subpage_clear_fixup(fs_info, folio, aligned_start,
+					  aligned_end - aligned_start);
+}
+
 /*
  * Unlike set/clear which is dependent on each page status, for test all bits
  * are tested in the same way.
@@ -480,6 +572,7 @@ bool btrfs_subpage_test_##name(const struct btrfs_fs_info *fs_info,	\
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(uptodate);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
+IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(fixup);
 
 /*
  * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index c6d7394e6418..19ee2aa68a6a 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -14,15 +14,15 @@ struct folio;
 /*
  * Extra info for subpage bitmap.
  *
- * For subpage we pack all uptodate/dirty/writeback bitmaps into
+ * For subpage we pack all uptodate/dirty/writeback/fixup bitmaps into
  * one larger bitmap.
  *
  * This structure records how they are organized in the bitmap:
  *
- * /- uptodate          /- dirty        /- writeback
- * |			|		|
- * v			v		v
- * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.......|w|w|
+ * /- uptodate          /- dirty        /- writeback       /- fixup
+ * |			|		|		   |
+ * v			v		v		   v
+ * |u|u|u|u|........|u|u|d|d|.......|d|d|w|w|.....|w|w|f|f|.....|f|f|
  * |< sectors_per_page >|
  *
  * Unlike regular macro-like enums, here we do not go upper-case names, as
@@ -40,6 +40,21 @@ enum {
 	 */
 	btrfs_bitmap_nr_writeback,
 
+	/*
+	 * Blocks whose dirty bit was set by the dirty_folio callback because
+	 * the folio was dirtied without notifying the filesystem (e.g.
+	 * set_page_dirty_lock() on a GUP pin), as opposed to by a reserving
+	 * write path.  Such blocks have no space reservation and need the
+	 * writepage fixup before they can be submitted.
+	 *
+	 * The bit also disambiguates a dirty block that a live ordered
+	 * extent covers: without the fixup bit the block is pending its own
+	 * submission into that ordered extent and must be submitted
+	 * normally; with it, the block was already accounted and must wait
+	 * the ordered extent out before it can be reserved again.
+	 */
+	btrfs_bitmap_nr_fixup,
+
 	btrfs_bitmap_nr_max
 };
 
@@ -50,6 +65,14 @@ enum {
 struct btrfs_folio_state {
 	/* Common members for both data and metadata pages */
 	spinlock_t lock;
+	/*
+	 * Set across the folio_mark_dirty() that a reserving write path
+	 * issues from btrfs_subpage_set_dirty(), so that the dirty_folio
+	 * callback does not treat the dirtying as potentially unnotified
+	 * and mark the folio's still-clean sibling blocks.  Written under
+	 * the folio lock, which every reserving path holds.
+	 */
+	bool reserving_dirty;
 	union {
 		/*
 		 * Structures only used by metadata
@@ -165,6 +188,16 @@ DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
 DECLARE_BTRFS_SUBPAGE_OPS(dirty);
 DECLARE_BTRFS_SUBPAGE_OPS(writeback);
 
+/* Fixup bits: subpage-only ops plus the reserving-write cancellation hook. */
+void btrfs_subpage_clear_fixup(const struct btrfs_fs_info *fs_info,
+			       struct folio *folio, u64 start, u32 len);
+bool btrfs_subpage_test_fixup(const struct btrfs_fs_info *fs_info,
+			      struct folio *folio, u64 start, u32 len);
+bool btrfs_subpage_set_fixup_dirty(const struct btrfs_fs_info *fs_info,
+				   struct folio *folio, u64 start, u32 len);
+void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
+			      struct folio *folio, u64 start, u32 len);
+
 /*
  * Helper for error cleanup, where a folio will have its dirty flag cleared,
  * with writeback started and finished.
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f9d22cd71768..8fe23672529c 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -689,6 +689,41 @@ DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_lookup_first,
 	     TP_ARGS(inode, ordered)
 );
 
+/*
+ * The writepage fixup deferred a block dirtied without notifying the fs
+ * because this still-running ordered extent covers it.
+ */
+DEFINE_EVENT(btrfs__ordered_extent, btrfs_writepage_fixup_defer,
+
+	     TP_PROTO(const struct btrfs_inode *inode,
+		      const struct btrfs_ordered_extent *ordered),
+
+	     TP_ARGS(inode, ordered)
+);
+
+/* The writepage fixup reserved space for a block dirtied without notifying the fs. */
+TRACE_EVENT(btrfs_writepage_fixup_reserve,
+
+	TP_PROTO(const struct btrfs_inode *inode, u64 start, u32 len),
+
+	TP_ARGS(inode, start, len),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	u64,	start		)
+		__field(	u32,	len		)
+	),
+
+	TP_fast_assign_btrfs(inode->root->fs_info,
+		__entry->ino	= btrfs_ino(inode);
+		__entry->start	= start;
+		__entry->len	= len;
+	),
+
+	TP_printk_btrfs("ino=%llu start=%llu len=%u",
+			__entry->ino, __entry->start, __entry->len)
+);
+
 DEFINE_EVENT(btrfs__ordered_extent, btrfs_ordered_extent_split,
 
 	     TP_PROTO(const struct btrfs_inode *inode,
-- 
2.55.0

