Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.47.207.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794961201;
	b=EW1QB14cyaWAi4Q+Ay4+9r5amrgO9hAbsvkVHLwQ7dBGKxkG6LGcWccXMCCFrdJVhLTx
	 NcUzg0z7SoB6basn5xV70zgIWl0CqtolZwXNZIdXiUzdsjoeIxUhC1JrWv7jTPzQ7QI3Z
	 WFeC5JZUqHNngO2MUjQ9XLC0BaA7ExjuEPIQIR5rBT45odk4LNg3lXaK36Jhozdl5s+H1
	 ytGrJ070aToL+8M1NbTn8hvDQjM1R59eRSak5Om3A9J88DI0RVGSWqps85/L2tUCPa8Pz
	 a63P2R1UDrWo1U7HE7H0ighrtnYAc6l64jr4Xi5YU3fV6qUCr9D4DmJ+uAenprnu+Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794961201;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Smtpcorp-Track:
	 Feedback-ID:X-Report-Abuse;
	bh=USKdBjYrxqVZYB0f2My75v8RblWnzuK2UH3k+CvxVbY=;
	b=DoewGyD45frDEAQdjFdFxCYVANijcePpgwZW0VKO9NvnVEqT/w3dfV3xROn6/lbn6aIj
	 Srr2am/7fy4Mz/lh6mKmNyLyXMsWuCbBw2PW4PhByaZd9HuiRHNTijjqe0uEYm8q2hwju
	 d/m90+1DBuN5yZXY/hGgYdjm0IOvDShMes4Y3Aqf6gGnG3v4Gjo/TdZeFXp+ds0RoXHvC
	 7kRJVcWlygNc8vBEK9HjBCPjw9NvGoLx9fu+gwmcaaJsiN4gjxT3Vpq0k7GDhPV0foBUa
	 4AQ1rf62KKd+BARkIDIY4vFAJ97BWAXTgl+yqlc0AJZzS2OiwnWzSdpP24xwYtgx8qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shangen.org;
	spf=pass smtp.mailfrom=em879706.shangen.org;
	dkim=fail reason="unknown key version" header.d=smtpservice.net header.i=@smtpservice.net header.a=rsa-sha256 header.s=miusa0.a1-4.dyn header.b=ERqyRPXF;
	dkim=pass header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=s879706 header.b=gxHB8rra;
	arc=none smtp.remote-ip=103.47.207.181
Received: from a2i949.smtp2go.com (a2i949.smtp2go.com [103.47.207.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F142A606A32F
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 00:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F142A606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shangen.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em879706.shangen.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="unknown key version" header.d=smtpservice.net header.i=@smtpservice.net header.a=rsa-sha256 header.s=miusa0.a1-4.dyn header.b=ERqyRPXF;
	dkim=pass (2048-bit key, unprotected) header.d=shangen.org header.i=@shangen.org header.a=rsa-sha256 header.s=s879706 header.b=gxHB8rra
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=smtpservice.net; s=miusa0.a1-4.dyn; x=1794962099; h=Feedback-ID:
	X-Smtpcorp-Track:To:Message-Id:Subject:Date:From:Reply-To:Sender:
	List-Unsubscribe:List-Unsubscribe-Post;
	bh=USKdBjYrxqVZYB0f2My75v8RblWnzuK2UH3k+CvxVbY=; b=ERqyRPXFeKJgTYf7zW/U0CtCKr
	OebE8nndAMozYS7XSeY3aGuby8J2w3CmRXEfgKLd9NN5eDfPDxk/qHXnOdf0SAwdwmD7s2pOOqZn8
	WP2O+APMHg9QshurFYH1V9FTrXvQFnBwhtroSBnWOiBAC+aO2XqMCdjahKdxb9VPOozo/4lCWFzzq
	LxZ0t0dF7Axvxh8dW47OOnhWxbRPcxEHg8e6PWyLIS+W0UnPWVfa/NlCuDXaA0o72EcsERlPQkOpz
	LneLku7zWQm8s9YhktC1ApMswd3yW51AvhfGmbcNfYxeJDzIml0cQcmkFH0v4K/utcjxWc77SS2YP
	iWqPd3yg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shangen.org;
 i=@shangen.org; q=dns/txt; s=s879706; t=1794961199; h=from : subject :
 to : message-id : date;
 bh=USKdBjYrxqVZYB0f2My75v8RblWnzuK2UH3k+CvxVbY=;
 b=gxHB8rrab3+96YVGqbTn+6tbHBOweiZXi6NWB1ewRPO072jVzfipnUylczk5RVzsU+74+
 r/qYwC9O2d4iX48gche8tnTSSmrrgTtj7T4BMuEiThQGNM4eDHeGuozbfgXR67xDE1djnVK
 SO4swWDVWiN2ittjYdPL7V7ur0cYANh49PYP8ovuYEUojmbjdvi3J7dudq6zZFP07N9kTUF
 9JH5KDf0CtEDjD175dN22aPAkuRUsiq4t/D/bRU3iSwJLs9rr6KvcxvYuFJThPJMcu28pxe
 4RzXmBPCs+sQIyu+fhDiyDbrzlBhuHguMikp7G0QIOSNUzEDdzPxlZ8Yj27A==
Received: from [10.66.228.43] (helo=SmtpCorp) by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2-S2G) (envelope-from <sim@shangen.org>)
 id 1xTTOn-gL4Pbf-0R; Wed, 18 Nov 2026 00:19:41 +0000
Received: from [10.195.244.224] (helo=[172.16.53.128])
 by smtpcorp.com with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256:X25519)
 (Exim 4.100.1) (envelope-from <sim@shangen.org>)
 id 1xTTOm-4o5NDgriGLf-hsR5; Wed, 18 Nov 2026 00:19:40 +0000
From: Shang En Sim <sim@shangen.org>
Date: Tue, 17 Nov 2026 18:18:21 -0600
Subject: [PATCH] btrfs: pin folios before dropping the last extent buffer
 reference
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
Message-Id: <20261117-my-btrfs-patch-v1-1-4b934a7ff69a@shangen.org>
X-B4-Tracking: v=1; b=H4sIAMzu/GoC/yXMQQqDMBBA0avIrDtgQojaq5QuTDLqCLWSSYsi3
 t2oy7f4fwOhyCTwLDaI9Gfh75ShHgX4oZ16Qg7ZoEttlVIVflZ0KXaCc5v8gE1tKqMpWONKyNE
 cqePlGr7et+XnRvLpvMC+H+OWmmdyAAAA
X-Change-ID: 20261117-my-btrfs-patch-984742ed64b0
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Boris Burkov <boris@bur.io>, Daniel Vacek <neelx@suse.com>, 
 Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Shang En Sim <sim@shangen.org>
X-Mailer: b4 0.16.0
X-Smtpcorp-Track: F44wdUM9C3Ic.jvF-znkuPu8h.g3OhKQfCvV7
Feedback-ID: 879706m:879706aL5FzMA:879706sCdNuySRWC
X-Report-Abuse: Please forward a copy of this message, including all headers,
 to <abuse-report@smtp2go.com>

release_extent_buffer() drops the last reference to a mapped extent
buffer (eb) before detaching its folios. The eb holds no reference to
the folios themselves.

Since commit 3649833a58b6 ("btrfs: fix broken drop_caches on extent
buffer folios"), the page cache owns the allocation reference. Once the
eb's reference count reaches zero, another eb can take over the folios.
They can then be evicted before the original eb detaches them:

  task A                         task B                    task C
  release_extent_buffer(eb)
   refs: 1 -> 0
   remove eb from buffer_tree
                                 alloc_extent_buffer()
                                  attach_eb_folio_to_filemap()
                                   grab_extent_buffer()
                                    refs is 0, take over
                                    the folios
                                 ... new eb released ...
                                                           drop_caches
                                                            folio->mapping
                                                            = NULL
   btrfs_release_extent_buffer_folios()
    detach_extent_buffer_folio()
     mapping = folio->mapping (NULL)
     spin_lock(&mapping->i_private_lock)

The result is a NULL pointer dereference. With a delay added in the
window (not part of this patch), it reproduces as:

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
btree_release_folio().

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
I reproduced the oops with the test-only delay below.

Testing, on btrfs for-next 6f4bbde7e036, 8 vCPUs, 2 NUMA nodes, 120 s
per run of the reproducer below:

- delay only: oops in 3 of 4 runs (at 61 s, 83 s, 46 s), trace as in
  the commit message
- delay + this patch: no oops in 3 runs

Subpage, arm64 with 64K pages, nodesize 16K, emulated in QEMU:

- delay only: no oops in 3 runs (expected: grab_extent_buffer() does
  not take over folios for subpage)
- delay + this patch: no oops in 3 runs

Builds with W=1 with no new warnings in fs/btrfs/.

Test-only delay patch:

  @@ -4037,6 +4038,10 @@ static int release_extent_buffer(struct extent_buffer *eb)
                               GFP_ATOMIC);

                btrfs_leak_debug_del_eb(eb);
  +             /* TEST ONLY: widen the window between last ref drop and folio detach. */
  +             if (!test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) &&
  +                 ((eb->start >> 14) & 7) == 0 && (jiffies & 3) == 0)
  +                     mdelay(20);
                /* Should be safe to release folios at this point. */
                btrfs_release_extent_buffer_folios(eb);
   #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
  (plus #include <linux/delay.h>)

Reproducer, run on a 128M loop btrfs with -n 16384, mounted -o commit=1:

  ./repro-xattr 120 /mnt

  // SPDX-License-Identifier: GPL-2.0
  /*
   * btrfs: release_extent_buffer() vs. folio reuse and eviction.
   *
   *   task A                         task B                    task C
   *   release_extent_buffer(eb)
   *    refs -> 0, removed from tree
   *                                  alloc_extent_buffer()
   *                                   grab_extent_buffer()
   *                                    takes over eb's folios
   *                                  ... new eb released ...
   *                                                            drop_caches
   *                                                             folio->mapping = NULL
   *    detach_extent_buffer_folio()
   *     spin_lock(&folio->mapping->i_private_lock)   <-- NULL deref
   *
   * I have only seen this program crash a kernel that has the TEST ONLY
   * delay patch applied.
   *
   * Usage: repro-xattr <seconds> <btrfs mountpoint>
   */
  #define _GNU_SOURCE
  #include <fcntl.h>
  #include <pthread.h>
  #include <sched.h>
  #include <stdint.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/stat.h>
  #include <sys/types.h>
  #include <sys/xattr.h>
  #include <unistd.h>

  #define NFILES 64

  static volatile int stop_flag;
  static int fds[NFILES];
  static int root_fd = -1;

  static void pin_cpu(int cpu)
  {
        cpu_set_t set;

        CPU_ZERO(&set);
        CPU_SET(cpu % 8, &set);
        sched_setaffinity(0, sizeof(set), &set);
  }

  /* Readers take and drop references on the leaves that hold the xattrs. */
  static void *xattr_reader(void *arg)
  {
        char buf[256];

        pin_cpu((int)(intptr_t)arg);
        while (!stop_flag) {
                for (int i = 0; i < NFILES && !stop_flag; i++) {
                        fgetxattr(fds[i], "user.a", buf, sizeof(buf));
                        fgetxattr(fds[i], "user.miss", buf, sizeof(buf));
                }
        }
        return NULL;
  }

  /* Writers COW the leaves and commit, so old leaves become clean and stale. */
  static void *xattr_cow_writer(void *arg)
  {
        char val[128];
        int tick = 0;

        pin_cpu((int)(intptr_t)arg);
        memset(val, 'X', sizeof(val));
        while (!stop_flag) {
                val[0] = (char)('A' + (tick & 15));
                fsetxattr(fds[tick & (NFILES - 1)], "user.b", val, sizeof(val), 0);
                if ((tick & 7) == 0)
                        syncfs(root_fd);
                tick++;
        }
        return NULL;
  }

  /* Evict clean btree folios from the page cache and migrate the rest. */
  static void *evict_and_compact(void *arg)
  {
        int cfd = open("/proc/sys/vm/compact_memory", O_WRONLY);
        int dfd = open("/proc/sys/vm/drop_caches", O_WRONLY);
        int iter = 0;

        pin_cpu((int)(intptr_t)arg);
        while (!stop_flag) {
                if ((iter & 1) == 0 && dfd >= 0)
                        (void)!write(dfd, "1\n", 2);
                if (cfd >= 0)
                        (void)!write(cfd, "1\n", 2);
                iter++;
        }
        return NULL;
  }

  int main(int argc, char **argv)
  {
        int duration = (argc > 1) ? atoi(argv[1]) : 60;
        const char *mnt = (argc > 2) ? argv[2] : "/mnt";
        char init_val[180];
        pthread_t tids[10];
        int nt = 0;

        root_fd = open(mnt, O_RDONLY | O_DIRECTORY);
        if (root_fd < 0) {
                perror("open mountpoint");
                return 2;
        }
        memset(init_val, 'Z', sizeof(init_val));
        for (int i = 0; i < NFILES; i++) {
                char path[256];

                snprintf(path, sizeof(path), "%s/file_%03d", mnt, i);
                fds[i] = open(path, O_CREAT | O_RDWR | O_TRUNC, 0644);
                if (fds[i] < 0) {
                        perror("open file");
                        return 2;
                }
                fsetxattr(fds[i], "user.a", init_val, sizeof(init_val), 0);
                fsetxattr(fds[i], "user.b", init_val, 128, 0);
        }
        syncfs(root_fd);

        for (int i = 0; i < 4; i++)
                pthread_create(&tids[nt++], NULL, xattr_reader, (void *)(intptr_t)i);
        for (int i = 0; i < 2; i++)
                pthread_create(&tids[nt++], NULL, xattr_cow_writer, (void *)(intptr_t)(4 + i));
        for (int i = 0; i < 4; i++)
                pthread_create(&tids[nt++], NULL, evict_and_compact, (void *)(intptr_t)(4 + i));

printf("[repro-xattr] %d threads on %d files for %ds\n", nt, NFILES, duration);
        fflush(stdout);
        for (int s = 0; s < duration; s++) {
                sleep(1);
                if ((s + 1) % 10 == 0) {
                        printf("[repro-xattr] %d/%ds\n", s + 1, duration);
                        fflush(stdout);
                }
        }
        stop_flag = 1;
        for (int i = 0; i < nt; i++)
                pthread_join(tids[i], NULL);
        printf("[repro-xattr] finished %ds, no panic\n", duration);
        return 0;
  }
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
base-commit: 6f4bbde7e0364b3676d7644af2d4be386f512b0e
change-id: 20261117-my-btrfs-patch-984742ed64b0

Best regards,
--  
Shang En Sim <sim@shangen.org>

