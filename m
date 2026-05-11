Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB793A4508
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778507455; cv=none; b=EIKbkhD+d4gALz9FLZC0vAYvWGXYcHfgMF9JXf2jEkc0sEGoTNhoENMydrYdv+WhEh2d4Si1NuDJPR4rLmzwaZRYCsQ1f91zAJwjPaAw6Sdetw7G828LRQVFKn4nvJuX/Wgz2QwPcN8SAH6vOR2w3EEjjHZcq3Lq6/5dq4QRScc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778507455; c=relaxed/simple;
	bh=VU7dovewEuq7+18DyhSwuy9wBjF4GEUHEUo/7194ffY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YTRdeTQ5bOa49oOALcm9c0imEN+oz4N7Y/L4p1ok929OfAuN5bjDnJRllkFre19gsPYyKgLUUy8XEUjNGlAdvb4cEqb7D3otv7GENXsNNgcPUjXf3eiKq96UcyO/ejty2G6x68aX3GzSirGQBgFcuKnJaBi65JhJ822PqCAgSWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pGGTyPaM; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pGGTyPaM"
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-8367df48711so1949334b3a.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 06:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778507454; x=1779112254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mb6EMph4s+bgHUrbnXBexgBGiQjwhyIsJ4J1dKda6tE=;
        b=pGGTyPaMSygHez/Hxt3W7MtF5NyS40KbSQ9S5H+Zq0/YDUT3Sxd3Xmy4H1P4Z9fZo2
         pF5AGE6ThlIBZHw/dxILNg9fQ5ww6GgK+PeH+tfK8vCWp0G0d1W1wPFKNntkmDDbxyJZ
         Dh93VjeWSa9uTzktqJD2RZThcc4nuxIE5m6F0tbYpoJIWKNn64QIevXbRCtRFjbDAWZw
         30Kw6aM9zJznEvQ6tYWq1EC8Zzk5cgo+YtF3xysybqaOq8Cj3a+P1/x5nall/rzVMEeU
         aU1dSJteQ8YgAXgn4nn/v/kQ351+O/7LhLkCukP2Sxd/Z65ztwwou4ApqkKufyiOR5Bz
         VejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778507454; x=1779112254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mb6EMph4s+bgHUrbnXBexgBGiQjwhyIsJ4J1dKda6tE=;
        b=dSMrV9RcBMXNjRSUB+mlrbda5nBW38Q9qig/UMdZtNYrPjrM99/NPRx6Wmvt+5Lcq4
         Do1E4Gsy/5zL7eejbsY3qtITxeqpPviyY7rmNR7qF0Q2YxnZpec7ZaI/KR8qpg0GAvli
         1ID066Aod0Q7+ZD+G7Vqq2u5FoHq7vhy0KWx6BWFs9IjdKTJUASFmuKKWwj1vpIIugHV
         O6rPg/bdgucF8CULHXYw7KlJiHaGxMVK5hgi6HXt1AgU++4FFIpMHAFD02nMKA90dLMi
         X4esz71kN9UDw2ND0ZjGOqfu657ruT8F3RrP3+ozyLZs9b3QGOs6S3bDfsPiYao0JaRM
         AmxQ==
X-Gm-Message-State: AOJu0YxnCDyAaDHgdxeYN9opYW3ja0/PvWBz+n+A9XB4Webn1k4Y6omK
	jMzjbRRXRmAi99pQdmADlB97RloUYEAkYFdFGIVUpnBfhbeJTpnRAKLQ
X-Gm-Gg: Acq92OE4oluKWjPaorZh12/qVwnPxGYWOruvYkyvTEwv1mvGY1bj+E3JdwvRMFBDwB1
	X7H/NEvSSHhVX17YGeREsF4RTh1XzQenZbyt7OxSWtwz7xPTS8esFs2DIna+MOBBCXNGy7W0vL8
	T/h5qfoX+ue0/wkpfqGGBa8iLQ/uTN4QZs0/vlDHupbrcU4dBo8glIaZbAe1dqukx1ardFv9Gsj
	/sNxVXSiIoo6hNTukzObW0EsNIHqJ/gjtDDcpwNDzzvpPbnl/0QcqGtD2O3ewlbk+0f8hAkZLyQ
	E84iardIhzOvBBJsiCQZXp7VXYVle3tGZSZ0LNKQedbbwfGenyYV3nGNHi4VMMBfkd1hK2eiwQS
	rflJGx9kMaDsa9kcbHifMSLa4HYNt+WEUpgzKLs3Foh/WFpZ3xHuaDssqVN+ulb//xWWRegnNJq
	eJYnMEI0sBccmtxcPbMm6uQUEQLgyxInQ=
X-Received: by 2002:a05:6a00:4391:b0:82f:48e:241c with SMTP id d2e1a72fcca58-83a5d68123dmr24106383b3a.23.1778507453718;
        Mon, 11 May 2026 06:50:53 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396594645csm21302937b3a.14.2026.05.11.06.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:50:53 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] btrfs: validate legacy free space cache entry types
Date: Mon, 11 May 2026 21:50:16 +0800
Message-Id: <20260511135016.3165392-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy free-space cache v1 stores each entry type as a raw u8, but
__load_free_space_cache() only special-cases EXTENT and treats every other
value as a bitmap entry. In normal builds the remaining bitmap count is
guarded only by ASSERT(), so a malformed cache can consume bitmap pages past
the header budget.

Reject unknown entry types and fail the cache load when a bitmap entry exceeds
the header's num_bitmaps count. The existing error path already discards a
bogus cache and rebuilds it, so valid caches keep their current behavior while
malformed ones are stopped before bitmap loading.

Sanitizer validation reported:
KASAN slab-out-of-bounds in io_ctl_check_crc()
Read of size 8
Call trace:
  dump_stack_lvl() (?:?)
  print_address_description() (mm/kasan/report.c:373)
  io_ctl_check_crc() (fs/btrfs/free-space-cache.c:552)
  print_report() (?:?)
  __virt_addr_valid() (?:?)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  kasan_addr_to_slab() (mm/kasan/common.c:45)
  kasan_report() (?:?)
  find_held_lock() (kernel/locking/lockdep.c:5340)
  __lock_release() (kernel/locking/lockdep.c:5511)
  _raw_spin_unlock() (kernel/locking/spinlock.c:188)
  btrfs_alloc_root() (fs/btrfs/disk-io.c:606)
  btrfs_test_fscache_unknown_entry_type() (fs/btrfs/free-space-cache.c:?)
  btrfs_run_sanity_tests() (fs/btrfs/free-space-cache.c:?)
  init_btrfs_fs() (fs/btrfs/super.c:2690)
  do_one_initcall() (init/main.c:1382)
  __kasan_kmalloc() (?:?)
  rcu_is_watching() (?:?)
  do_initcalls() (init/main.c:1457)
  kernel_init_freeable() (init/main.c:1674)
  kernel_init() (init/main.c:1584)
  ret_from_fork() (?:?)
  __switch_to() (?:?)
  ret_from_fork_asm() (?:?)
  kasan_save_stack() (mm/kasan/common.c:52)
  kasan_save_track() (mm/kasan/common.c:74)
  __kmalloc_noprof() (?:?)
  io_ctl_init() (fs/btrfs/free-space-cache.c:378)

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
 fs/btrfs/free-space-cache.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..71797c647f8a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -839,8 +839,14 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
-		} else {
-			ASSERT(num_bitmaps);
+		} else if (type == BTRFS_FREE_SPACE_BITMAP) {
+			if (!num_bitmaps) {
+				ret = -EUCLEAN;
+				btrfs_err(fs_info,
+					  "free space cache has more bitmap entries than bitmaps");
+				kmem_cache_free(btrfs_free_space_cachep, e);
+				goto free_cache;
+			}
 			num_bitmaps--;
 			e->bitmap = kmem_cache_zalloc(
 					btrfs_free_space_bitmap_cachep, GFP_NOFS);
@@ -864,6 +870,12 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			recalculate_thresholds(ctl);
 			spin_unlock(&ctl->tree_lock);
 			list_add_tail(&e->list, &bitmaps);
+		} else {
+			ret = -EUCLEAN;
+			btrfs_err(fs_info,
+				  "unknown free space cache entry type %u", type);
+			kmem_cache_free(btrfs_free_space_cachep, e);
+			goto free_cache;
 		}
 
 		num_entries--;
-- 
2.43.0
