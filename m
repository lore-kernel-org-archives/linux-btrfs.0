Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F203F0761
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778507407; cv=none; b=VtJ7xUM6467GOnqINfuuz7E1vhFx0V2JDEH9P0RFarvFl+LptvXolklNmdRjRVtHa6ncKZ34lSxK48f5IJvXI5nq35reVbHYayOVl+gf1JL5J+6rkIx7WC8I5jugRQRTLJDei9y2X3jipVJkGrzXra6laJQtnRXS6hCecbEfl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778507407; c=relaxed/simple;
	bh=sNQgaQIUiAXMi4y0CvZLBVy7GOa9CEHzLQL8+h08rbY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zvkua45dsrbJfY5ZqNg+JHd0xz40LoQb3zhO3lLjEQTQyFVsiKVswB61uXyaXr+Si1tmhZEaOe5kPloR7IwuYFrFSKvhY/yPLLO2BdfKwGb1Q2AzjLAitm4H/u285nB5Wj+eB/V+UMWObhEmFl4CjnFpMhUFEfZZi42C7m3n4AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3EQYAVW; arc=none smtp.client-ip=209.85.216.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3EQYAVW"
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-3665a90bcd3so2668339a91.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 06:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778507405; x=1779112205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cV9nMNIV3AZO9G4zMYTfSRCe1SSpkNULBh7zmpYG6s0=;
        b=e3EQYAVWud+nwd5+Ed8KF6Fs3ngxzZz61KO/WkLkcroSs41TncLzMD/ktfLwhXfWdB
         wTSxMeRxbQjbphDM0mg8ZdNK075o+V98DzsAmtoiqUxJeGmcrJ2WocTRuyHbfdIXFdyp
         QqAE5D5r0AtW8Y7xt1tCEHLL6In2oinEM8cChwKlH3UhHMY7XKv+HlJZiljrsQ/+XK+D
         YY59YxH3bYdqTN9FlYpH6LxQ+N/RUlvzZp0wXoj6TVJ6e3rIyFYqcU3zv4oF8yW6k7D2
         TqMJ20iOc/1blU8Lg6FvqPE3v4PK1Hu3NCGagom961IEtFcmhOdBuw0XCmCsUGGwTYgC
         KSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778507405; x=1779112205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cV9nMNIV3AZO9G4zMYTfSRCe1SSpkNULBh7zmpYG6s0=;
        b=p1CCO9DnFbW6w4gcpOmwxyt5J7/57rl+sXSPPZNFktJUW+QOHx2b4IU2zZW/DB2TKy
         jNucqaQaPK0BnKB1+qMSBd6zLVrOf/47x3BllUE3brLaJQz+Vng+LSxgec1BfWhvJneQ
         T6WQvcDFcRM7+0MMPj5vXbPZES65XZBvTNIHHkI40yLb3QKpPY5UgL/DTsgH4qLC4e9/
         phUrwePzMMn7L6XNdutnz+zFBfPVoE5AN+zezgT1qvm2fzMzxcJmyhlCs9AM2tDODfH7
         dehyVHLH9z3JWqAb3PkMOyYh+vURhNEt4pv18TGr6tulF8lpAc+CzahZab+YFlmu+DwF
         oIsg==
X-Gm-Message-State: AOJu0Yz2cW6Fbt4kMJd1iAhDZih1qstuY4R3IesMKS9SwL7/kVNgdfPz
	1MTv4iNbL0kpCEkTMh6qvNAmaOkzj3HrIUMTgux6sjS1gul2ynPH2fdE
X-Gm-Gg: Acq92OGPSET41pF/eVnalkR8zNS5Rjfn3Ce04q4+uwN4qJ5q5EJDewYiEDDjTIbfr+L
	ksY87ZEw85w355qV7QxQ7T6mOT28CMTxhuUOL5LurDWeYuN8SAQbPQ7XNIyIA3TrW6O0d3+RnyB
	TbeRo69+pwdhWoNDDSCIYX/aRcBL1cjKZhKXoEl6iu825Zg8EHoBrBIQaAkGdEpf/R78aieWiJt
	0USvasWzDSZTAZqPG1CPygElyiOH69pTzhwStG9Jz4/09VhbtdQc2LrxWdng2ETUYCYBMhEUMiw
	MvpWK6dY5aYo+LQIhjiFBRIOiuQn+iw15d1fEse2nELJ8vLN0eWTSl41foVbUVh+9XMMvHXvqcP
	/UDE0/JoaEuGcQsJV+GAuiHatgIGAHIOnp7zHUKZjHYxPpTx5i9K59iQGj0NewXa6lQcI2+ce0V
	iJvW9pi6BFho43x0qcCzbGLQNaUDErrMY=
X-Received: by 2002:a17:902:da86:b0:2b4:5931:bc4c with SMTP id d9443c01a7336-2bc7a9a5ec7mr104280505ad.15.1778507405325;
        Mon, 11 May 2026 06:50:05 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35bcfsm103268315ad.38.2026.05.11.06.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 06:50:04 -0700 (PDT)
From: Zhang Cen <rollkingzzc@gmail.com>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zerocling0077@gmail.com,
	2045gemini@gmail.com,
	Zhang Cen <rollkingzzc@gmail.com>
Subject: [PATCH] btrfs: validate free space cache page 0 header size on read
Date: Mon, 11 May 2026 21:49:26 +0800
Message-Id: <20260511134926.3163189-1-rollkingzzc@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_ctl_init() derives num_pages from i_size_read(inode), and
__load_free_space_cache() at fs/btrfs/free-space-cache.c:793 calls it
before verifying the first cache page. The write path already rejected
layouts where num_pages * sizeof(u32) + sizeof(u64) does not fit in page
0, but the read path bypassed that check because io_ctl_init() only
enforced it for writers.

That lets a malformed v1 free space cache inode reach
io_ctl_check_generation() and io_ctl_check_crc() with a page 0 header
that does not fit. io_ctl_check_generation() advances to the generation
field at fs/btrfs/free-space-cache.c:519, and io_ctl_check_crc() hashes
from io_ctl->orig + offset at fs/btrfs/free-space-cache.c:565, so
oversized num_pages values can access beyond page 0 before the cache is
rejected.

Validate the page 0 header size for every io_ctl_init() caller and use a
u64 page count while checking the bound. Malformed free space cache
inodes now fail fast and fall back to rebuilding the cache instead of
parsing past the first page.

Sanitizer validation reported:
KASAN slab-out-of-bounds in io_ctl_check_generation()
Read of size 8
Call trace:
  dump_stack_lvl() (?:?)
  print_address_description() (mm/kasan/report.c:373)
  io_ctl_check_generation() (fs/btrfs/free-space-cache.c:512)
  print_report() (?:?)
  __virt_addr_valid() (?:?)
  srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
  kasan_addr_to_slab() (mm/kasan/common.c:45)
  kasan_report() (?:?)
  btrfs_test_fscache_page0_header_overflow() (fs/btrfs/free-space-cache.c:?)
  btrfs_free_dummy_fs_info() (fs/btrfs/tests/btrfs-tests.c:155)
  kfree() (?:?)
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

Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>

---
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ab22e4f9ffdd..c8d240b555fe 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -375,15 +375,14 @@ static void readahead_cache(struct inode *inode)
 	page_cache_sync_readahead(inode->i_mapping, &ra, NULL, 0, last_index);
 }
 
-static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
-		       int write)
+static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode)
 {
-	int num_pages;
+	u64 num_pages;
 
 	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 
 	/* Make sure we can fit our crcs and generation into the first page */
-	if (write && (num_pages * sizeof(u32) + sizeof(u64)) > PAGE_SIZE)
+	if (num_pages * sizeof(u32) + sizeof(u64) > PAGE_SIZE)
 		return -ENOSPC;
 
 	memset(io_ctl, 0, sizeof(struct btrfs_io_ctl));
@@ -791,7 +790,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	if (!num_entries)
 		return 0;
 
-	ret = io_ctl_init(&io_ctl, inode, 0);
+	ret = io_ctl_init(&io_ctl, inode);
 	if (ret)
 		return ret;
 
@@ -1384,7 +1383,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 		return -EIO;
 
 	WARN_ON(io_ctl->pages);
-	ret = io_ctl_init(io_ctl, inode, 1);
+	ret = io_ctl_init(io_ctl, inode);
 	if (ret)
 		return ret;
 
