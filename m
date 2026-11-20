Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.47.207.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795212375;
	b=gGkaphHw3GJkslROl72XLpxCSN4NDh/6DnxG0AzPJDQzRF878Dq1cJ0lymwRTUDNcGYh
	 x3iJkVfW+/652N3O3P4hFaMGsGgZHW+0obeuZioQudb0Go+xlNqAScaO7Qs7kji2lHkHU
	 y6TKvPkqj1t/3/7334xwrpTQIJ5vXXY8ra99UGeamfoqBwmxLlkia8wFN2/jv5b7uRm8v
	 qCxwsC941CzO/9CJnl6ESU9S0CBh/AIO54bu/kUtLlkm6y2fjaCzyAsbAcoJLFSZOqRU8
	 r3Of6LVKREigBm1FYbh+qMvPexCztVdFI31SByGLCtMZhuPQ55oimw6fgEIRTeiQ1EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795212375;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Smtpcorp-Track:
	 Feedback-ID:X-Report-Abuse;
	bh=TNt3BulTTXgrFLeQVTwxwH9NPt2/tvYOhim0qdzYvU0=;
	b=0jYd/tXm5WDiUw8hBwg/6ACOH7eEa4dg4fAuKb7TP4qrt1G20i51Ol2VqnHk0f2zrIPO
	 YtxiAJa+rgBVpmcNyIcMAk9e5zRdi/9FbJd2E4+n3ttLH91fKBHDGID2K6SagI//phqMg
	 vOVgbebt24Jyrcanhb5oFYiLTtPCTL9OkBpsEYa7HfdUYvN64WaEN3fEWntOXXX0OK+V0
	 gEYADjnibeN+8KR9vky19d1dhLd3JX1EAWsLarjfUsvyljtnlCMqVv/Fq7vrWvNwMAreL
	 VHMZ9+qylFLLYEhCSXOXIZ2PaPKpVPAyZCBs8ejIKkJyNmgTkhF70X6yBXq+GFzBozQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shangen.org;
	spf=pass smtp.mailfrom=em879706.shangen.org;
	dkim=fail reason="unknown key version" header.d=smtpservice.net header.i=@smtpservice.net header.a=rsa-sha256 header.s=miusa0.a1-4.dyn header.b=z0ZF9rhp;
	dkim=pass header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=s879706 header.b=iUemQKYF;
	arc=none smtp.remote-ip=103.47.207.181
Received: from a2i949.smtp2go.com (a2i949.smtp2go.com [103.47.207.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABC606A6B4
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 22:06:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5ABC606A6B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shangen.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em879706.shangen.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="unknown key version" header.d=smtpservice.net header.i=@smtpservice.net header.a=rsa-sha256 header.s=miusa0.a1-4.dyn header.b=z0ZF9rhp;
	dkim=pass (2048-bit key, unprotected) header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=s879706 header.b=iUemQKYF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=miusa0.a1-4.dyn; x=1795213263; h=Feedback-ID:
	X-Smtpcorp-Track:To:Message-Id:Subject:Date:From:Reply-To:Sender:
	List-Unsubscribe:List-Unsubscribe-Post;
	bh=TNt3BulTTXgrFLeQVTwxwH9NPt2/tvYOhim0qdzYvU0=; b=z0ZF9rhp1pAWXxJCKwk27FpRGd
	OKCMVygEBhtezcrTX0z/J1LuBFUpskC3RuAQr0w1uG8ccXhXNj+TYZmm4uQmrrw2vQk4GEFV/JAiG
	45NsN7tMASbUAdHtTkKAf0P2XdxpspBX61Zh/SU1EFP4cB3RgpvFyayRw3/uEhFE8Fp/aimgTJME/
	egbfSiGG6YPjx1J7BBnHoKHpQVdEnOZTGYe7R8l/4klPDWLKrT0F8vFGfM0OmpzxG3rF5XrWApRES
	Xzh6hyqtz0KwSFgkWGxWOGEI+OCgnB2MWijeCAv2sLUdkI3YmWfcW2INxGAfeXF+KYZ3UKnGDHs4h
	2m48OGhA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shangen.org;
 i=@shangen.org; q=dns/txt; s=s879706; t=1795212363; h=from : subject :
 to : message-id : date;
 bh=TNt3BulTTXgrFLeQVTwxwH9NPt2/tvYOhim0qdzYvU0=;
 b=iUemQKYFB20gMChSivodEJr4Gfe1tTsQyyfkZVSjf8DttZEmwgOPd6ms5wbi9a/ZEHSSx
 UqIr/qbtm3SN/1+sJXwWY51wVyaO0mtZVoj8+Kn5HzLOpiTsdpGDaFEFapvL2IbAAzjgdfl
 TslcwZ0pxClvYmIER48Tule44ypwXKTQ12tfJ6hSZxXvgxeyoMi8SC+PIJRlt9oiaxED9gf
 M3PUU8gMrdL4hO24UqdY6l93uyPsaWS3G/tqhIXeBKcumGjPENGTK7L913nPGahKTmq7ROA
 xtgKdFgh2UWy0N0EOuVsXTyk9t9Jrdt9Ouoqzoaun7W6NsHLLFta5itO3AQw==
Received: from [10.45.56.87] (helo=SmtpCorp) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2-S2G) (envelope-from <sim@shangen.org>)
 id 1xUWjI-gL4WR1-9f; Fri, 20 Nov 2026 22:05:12 +0000
Received: from [10.195.244.224] (helo=sse-laptop.intranet.snuglucks.com)
 by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256:X25519)
 (Exim 4.100.1) (envelope-from <sim@shangen.org>)
 id 1xUWjG-FnQW0hPlCC3-eK1O; Fri, 20 Nov 2026 22:05:11 +0000
From: Shang En Sim <sim@shangen.org>
Date: Fri, 20 Nov 2026 16:04:56 -0600
Subject: [PATCH v2] btrfs: pin folios before dropping the last extent
 buffer reference
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-my-btrfs-patch-v2-1-5807593231d4@shangen.org>
X-B4-Tracking: v=1; b=H4sIAAfEAGsC/3WOwQ6CMBBEf4Xs2TW0NiCe/A/DoS1bqIlAupVIC
 P9uqWePL5l5MxswBU8Mt2KDQItnP40J5KkAO+ixJ/RdYpClrIQQNb5WNDE4xllHO2BzVbWS1FX
 KlJBKcyDnP1n4aH/Mb/MkGw/LkRg8xymseXERR+6vfBEoUJnmonTtXNXoO+dP43kKPbT7vn8BW
 w9i8MAAAAA=
X-Change-ID: 20261117-my-btrfs-patch-984742ed64b0
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Boris Burkov <boris@bur.io>, Daniel Vacek <neelx@suse.com>, 
 Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Shang En Sim <sim@shangen.org>
X-Mailer: b4 0.16.0
X-Smtpcorp-Track: rp0BoR1zRzDe.g5F3_lzL6eQn.yDM-LAkOW2S
Feedback-ID: 879706m:879706aL5FzMA:879706syyye6mj71
X-Report-Abuse: Please forward a copy of this message, including all headers,
 to <abuse-report@smtp2go.com>

release_extent_buffer() drops the last reference to an extent buffer (eb)
before detaching its folios. For a mapped eb, alloc_extent_buffer() has
dropped its references to the folios since commit 3649833a58b6 ("btrfs: fix
broken drop_caches on extent buffer folios"). The page cache and the
folio's private attachment hold the remaining references.

Consider the following sequence, starting with an order-0 folio F in
btree_inode->i_mapping with F->private == existing_eb, F refcount == 2
(1 for the page cache, 1 for F->private), and existing_eb->refs == 1:

1) Task A drops the last reference to existing_eb:

     release_extent_buffer(existing_eb)
      refcount_dec_and_test()        # existing_eb->refs: 1 -> 0
      spin_unlock(&existing_eb->refs_lock)
      xa_cmpxchg_irq()               # removes existing_eb from buffer_tree
      <window before btrfs_release_extent_buffer_folios(existing_eb)>

2) Task B allocates new_eb for the same bytenr, takes over folio F, and
   drops its caller reference:

     alloc_extent_buffer()
      find_extent_buffer()           # NULL (existing_eb removed from tree)
      btrfs_init_eb_prealloc()       # allocates new_eb and new folios
      init_extent_buffer()           # new_eb->refs = 1
      attach_eb_folio_to_filemap()
       filemap_add_folio() -> -EEXIST
       filemap_lock_folio() -> F     # locks F; F refcnt: 2 -> 3
       grab_extent_buffer(F)
        folio_get_private(F) -> existing_eb
        refcount_inc_not_zero(&existing_eb->refs) -> false
                                     # existing_eb->refs == 0
        folio_detach_private(F)      # F->private = NULL; refcnt: 3->2
       folio_put(new_eb->folios[i])  # drops new_eb's unused new folio
       new_eb->folios[i] = F         # reuses existing folio F
       attach_extent_buffer_folio(new_eb, F)
        folio_attach_private(F, new_eb) # F->private = new_eb; refcnt: 2->3
      __xa_cmpxchg()                 # inserts new_eb into buffer_tree
      check_buffer_tree_ref(new_eb)  # sets TREE_REF; new_eb->refs: 1 -> 2
      folio_unlock(F)
      folio_put(F)                   # drops lock ref; F refcnt: 3 -> 2
     free_extent_buffer(new_eb)
      free_extent_buffer_clear_reading(new_eb, false)
       release_extent_buffer(new_eb)
        refcount_dec_and_test()      # new_eb->refs: 2 -> 1 (TREE_REF)

3) Task C runs drop_caches, releases new_eb, and evicts folio F:

     drop_caches_sysctl_handler()
      iterate_supers()
       __iterate_supers()
        drop_pagecache_sb()
         invalidate_mapping_pages()
          mapping_try_invalidate()
           find_lock_entries()        # locks F, fbatch ref: F refcnt 2->3
           mapping_evict_folio(mapping, F)
            folio_ref_count check     # 3 <= 1 + 1 + 1 (passes)
            filemap_release_folio(F, 0)
             btree_release_folio(F, 0)
              try_release_extent_buffer(F)
               folio_get_private(F) -> new_eb
               new_eb->refs == 1      # check passes
               test_and_clear_bit(EXTENT_BUFFER_TREE_REF) -> true
               release_extent_buffer(new_eb)
                refcount_dec_and_test() # new_eb->refs: 1 -> 0
                spin_unlock(&new_eb->refs_lock)
                xa_cmpxchg_irq()      # removes new_eb from buffer_tree
                btrfs_release_extent_buffer_folios(new_eb)
                 detach_extent_buffer_folio(new_eb, F)
                  folio_detach_private(F) # F->private=NULL; refcnt 3->2
                returns 1
            remove_mapping(mapping, F)
             __remove_mapping_unfreeze()
              __remove_mapping()
               folio_ref_freeze(F, 2) # F refcnt: 2 -> 0
                                      # (existing_eb holds no ref)
               __filemap_remove_folio(F, NULL)
                page_cache_delete()
                 xas_store(NULL)      # removes F from i_pages
                 F->mapping = NULL
               returns 1
              folio_ref_unfreeze(F, 1) # drops page cache ref; refcnt 0->1
           folio_unlock(F)
           folio_batch_release()      # drops fbatch ref; refcnt 1->0, free

4) Task A resumes and detaches existing_eb's folios:

     btrfs_release_extent_buffer_folios(existing_eb)
      detach_extent_buffer_folio(existing_eb, F)
       mapping = F->mapping           # NULL (F refcnt is 0, freed/reused)
       spin_lock(&mapping->i_private_lock) # NULL dereference

If new_eb was already fully freed and detached before task C runs, e.g.
via free_extent_buffer_stale(), F has no private attachment and
filemap_release_folio() returns true immediately, with the same result.

With a delay added in the window, this reproduces as:

  BUG: kernel NULL pointer dereference, address: 0000000000000074
  RIP: 0010:_raw_spin_lock+0x18/0x30
  Call Trace:
   detach_extent_buffer_folio+0x68/0x140
   release_extent_buffer+0xac/0x120
   btrfs_release_path+0x17/0x80
   btrfs_free_path+0x17/0x30
   btrfs_getxattr+0xe2/0x110
   ...

Compaction can also hit this window, since it calls
release_extent_buffer() through btree_migrate_folio() ->
filemap_release_folio() -> btree_release_folio().

Even without the NULL mapping, the folio can already be freed and
reused when detach_extent_buffer_folio() looks at it.

This race requires nodesize >= PAGE_SIZE. With subpage metadata,
grab_extent_buffer() never takes over folios, and a shared folio keeps
folio->private set until every eb on it is detached, so
try_release_subpage_extent_buffer() does not release it while an eb is
in this window.

Fix this in two parts:

- In release_extent_buffer(), when refs is 1 and the eb is mapped, take
  a reference on each folio before dropping the eb reference, and drop
  those references after the folios are detached. This keeps the folios
  alive across the window, as the eb's own folio reference did before
  the commit above.
  Checking refs == 1 under refs_lock is enough: free_extent_buffer()
  only decrements a mapped eb's refs without refs_lock while refs is
  above 3, so no one else can drop it to 0 under us.

- In detach_extent_buffer_folio(), take i_private_lock from the btree
  inode instead of from folio->mapping. A pinned folio can still be
  removed from the page cache. All folios of a mapped eb belong to the
  btree inode, so this is the same lock in every other case.

Fixes: 3649833a58b6 ("btrfs: fix broken drop_caches on extent buffer folios")
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Shang En Sim <sim@shangen.org>
---
I reproduced the oops with a test-only delay.

v1 testing on btrfs for-next 6f4bbde7e036, 8 vCPUs, 2 NUMA nodes, 120 s
per run of the reproducer:

- delay only: oops in 3 of 4 runs (at 61 s, 83 s, 46 s), trace as in
  the commit message
- delay + this patch: no oops in 3 runs

Subpage, arm64 with 64K pages, nodesize 16K, emulated in QEMU:

- delay only: no oops in 3 runs (expected: grab_extent_buffer() does
  not take over folios for subpage)
- delay + this patch: no oops in 3 runs

v1 built with W=1 with no new warnings in fs/btrfs/.
On the v2 base, fs/btrfs/extent_io.o built with W=1 on x86-64.
---
Changes in v2:
- Drop "mapped" from the first sentence, release_extent_buffer() handles
  both mapped and unmapped buffers (Filipe).
- Replace the race diagram with the full step-by-step sequence from the
  v1 discussion, using existing_eb and new_eb (Filipe).
- Rebase onto btrfs for-next.
- Link to v1: https://patch.msgid.link/20261117-my-btrfs-patch-v1-1-4b934a7ff69a@shangen.org
---
 fs/btrfs/extent_io.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..ce6880b1d64e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3155,15 +3155,18 @@ static bool folio_range_has_eb(struct folio *folio)
 static void detach_extent_buffer_folio(const struct extent_buffer *eb, struct folio *folio)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	struct address_space *mapping = folio->mapping;
+	struct address_space *mapping = NULL;
 	const bool mapped = !test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags);
 
 	/*
 	 * For mapped eb, we're going to change the folio private, which should
-	 * be done under the i_private_lock.
+	 * be done under the i_private_lock. Do not use folio->mapping, the
+	 * folio may have left the page cache, see release_extent_buffer().
 	 */
-	if (mapped)
+	if (mapped) {
+		mapping = fs_info->btree_inode->i_mapping;
 		spin_lock(&mapping->i_private_lock);
+	}
 
 	if (!folio_test_private(folio)) {
 		if (mapped)
@@ -4011,8 +4014,27 @@ static inline void btrfs_release_extent_buffer_rcu(struct rcu_head *head)
 static int release_extent_buffer(struct extent_buffer *eb)
 	__releases(&eb->refs_lock)
 {
+	struct folio *pinned[INLINE_EXTENT_BUFFER_PAGES];
+	int nr_pinned = 0;
+
 	lockdep_assert_held(&eb->refs_lock);
 
+	/*
+	 * Once refs drops to 0 our folios can be taken over and freed, so pin
+	 * them until they are detached. refs only drops below 3 under
+	 * refs_lock, so checking for 1 is enough. Keep the folios in a local
+	 * array: if refs does not hit 0, another holder may free the eb.
+	 */
+	if (refcount_read(&eb->refs) == 1 &&
+	    !test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags)) {
+		for (int i = 0; i < INLINE_EXTENT_BUFFER_PAGES; i++) {
+			if (!eb->folios[i])
+				continue;
+			folio_get(eb->folios[i]);
+			pinned[nr_pinned++] = eb->folios[i];
+		}
+	}
+
 	if (refcount_dec_and_test(&eb->refs)) {
 		struct btrfs_fs_info *fs_info = eb->fs_info;
 
@@ -4039,6 +4061,8 @@ static int release_extent_buffer(struct extent_buffer *eb)
 		btrfs_leak_debug_del_eb(eb);
 		/* Should be safe to release folios at this point. */
 		btrfs_release_extent_buffer_folios(eb);
+		for (int i = 0; i < nr_pinned; i++)
+			folio_put(pinned[i]);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 		if (unlikely(test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags))) {
 			kmem_cache_free(extent_buffer_cache, eb);
@@ -4050,6 +4074,9 @@ static int release_extent_buffer(struct extent_buffer *eb)
 	}
 	spin_unlock(&eb->refs_lock);
 
+	for (int i = 0; i < nr_pinned; i++)
+		folio_put(pinned[i]);
+
 	return 0;
 }
 

---
base-commit: 184fa2c40f5c50afb1d8bf900eafadf450db392e
change-id: 20261117-my-btrfs-patch-984742ed64b0

Best regards,
--  
Shang En Sim <sim@shangen.org>

