Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279939;
	b=pS0658NXaH2lsZvFXlpxxh375pXPweywqfiwsC3eP00UCtrMYJz8uUEKXU79Fei5fjld
	 q87K72Aj80sLEytCjY5B1Ro6rspZW2rR1vPQAi270wBS9i+CmsB6zj050fvHsz3z9NTyD
	 IyLcPwRnqN9y/WuCnS7Nm4pKkaXKPdLjnZCgoCF1EwdDGbaLu4IOIcDitjnuGZq7YDCDn
	 LYlGAAUinGL0BO/Vh1ExfbBTkQ9zu3HqvmSg0ERn3p3JQZRiWgst1mt70igX5bvjB7VS0
	 m+MLM9wNqM2HI8UbCLIR8ZHYHZmgq8eOn91BCbM76uf4saMCkY89EDxfEHpPP7vFeDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279939;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 X-Mailer;
	bh=WX8HAKlzGxNN6geVNUiXNfag9XxIX/lb5PTYIBvV6kQ=;
	b=irjvYaZrDRplIsEUTuAQb2o9W+4TSivvMHgsWZIrIe0tdsa2JB9k7ZL/MFRN5F6SFBnk
	 nCBC4ovLZarotpwbT4vvgfTlm8im6oYSA6A1MDkvuQmIy4NnvkhGCdXvO6aXN/zI6/36H
	 Et5d6j0fuqi+7hKD/AhV2c11lu5HVPxsHRfI5+aq9/fdrLELNhyAEXFHhDoV6ysfWa5QY
	 D5TR8gPJFcS/glkpX/ibTnf5pptUddrZQ0szziMH4oR2CAI/2qBL8C4/bHhREetrQziTS
	 4TjSrJ97eLGusZfnk4VZbQt4IPnBa3/A1TvQTM6+zsHr4m6MHqhJw0XNc5XRD0lYjAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A+i0H708;
	arc=none smtp.remote-ip=74.125.227.200
Received: from mail-pi2-f8.google.com (mail-pi2-f8.google.com [74.125.227.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFBF606A325
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 03:05:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CFBF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A+i0H708
Received: by mail-pi2-f8.google.com with SMTP id 41be03b00d2f7-cd8cb23d52eso597726a12.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 19:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794279938; x=1794884738; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WX8HAKlzGxNN6geVNUiXNfag9XxIX/lb5PTYIBvV6kQ=;
        b=A+i0H708U0QhhS/auEv9RXynihAQg5JUK56vhWJuStLBuxsYlHpMBakfVnh6EzLj3b
         Gy9vlMUuqNOnWne61jTAmePg+MOto1QYGb/dtNUzm0g4ptrrxBY39l+jXxVszQDbD/eL
         DOLMiyFNJb7FJ/duLezj0VblqoAeaZnN0PYZMT8oGOeM0svmYHcb45CCUUhwlCV09t/+
         /P8h5qAky1D6pDcpqDzU0NQE8OZCIvBNdFsB/+JujP8Ujv7VWfO1LBxBDvurdxYSdIuX
         zYi9vFydpGS16c/GCkcWZXLtyzTVffpAwRdl1VAX4qd4/u+nw0aJqxJWXN47YPAukMYC
         6MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794279938; x=1794884738;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WX8HAKlzGxNN6geVNUiXNfag9XxIX/lb5PTYIBvV6kQ=;
        b=bhMA95MMmy/+fc9mpQ/gaZi1aXN6svnH2J9jh4X8Hlghk4VlcJeDx4IFuCxDH4y7JK
         xL11LqM9ug3+RNzhhaXZTOkNafmqUujiAOUhhz9tLqXti67WZ8lCaaMZsKgViMcYx3VG
         9+7VFkKtbSUujnvk6CmZ+M9VEc6ENqwRRVSfnGa4f9j30eMK2SX1jijhs2dk4yExrH9r
         jMfj3XA4R5RxiZUmNhf3CaoufG5D8KFPgaOoLRNkr/QmWi+VtM7+wCYLc/C5zKP6/zD7
         08Ki598DcPVPHRJAkIw/CgBAGmFH8XLXRQjKQ3nVtBbFKEIVZz3v85TdbcqJqmjVvFy7
         swuA==
X-Gm-Message-State: APuU4Z9zHrW5BEGSXEFWaDCx1qkx8MYug/V5SiVTNCVRHcCHJAPXbdqs
	C3btvhgIyfweRAhWTURianUWbCvJEY/MnBHvi4S+4Ia2pzmzd1VRiPE1
X-Gm-Gg: AYBFou1jLalhS+KbSBHH55M0yQDYhDAjB7h29FCR9ny/ML9urxWVxr4wiJKiQA21mB+
	4G1+QuOpChIBUb6ON+PM/z7oQnItC3q+veHHSmJ3SfigDgGhsFQGy96u4GMr2ry5dQ3KTVMWnZm
	cUGzahLFo8aHDQmriS2DZe2WI29HCw9aUCPANAtc/U+PKj9Q5EcnBSZBMg+xUo4O73AA/JkJD8w
	csoUmF+3Af0LBNR1uK2HKm0qTdElIvf+3O9pogr4oCCHhfdv8sg6IeMLKbn3tmCboDVkdUxJM7P
	cS2auC+0/yMqebdaPgx3H/94/2FPdj6o9FsV3wZIuX8LL+FdZarmBXRPNY7+FmjxtFI7LIss00+
	Ec2zBUuxyA5HmzQTWJzKcD+Z5OuDSRKzyH4LZNpubOw5WHCMAIy+Gzw0elRr/FpiisCKvVNkddl
	nWne8nukab9pnjr4IGzl1fVVUXqrZ4dqkwI7HiWaNksOXpgg07fkYTaANOvZDWvq30/2CXiwg++
	yuVBe0LDNPP7x8hnO0SEl38uZMcGsmUnU+CZOFuWbATht4gDtMcSNoWYffqXYyWDGmhusXEWc2v
	czEf2koEOm2XUXHy/u8m
X-Received: by 2002:a05:6372:a80c:b0:3de:4976:a0fe with SMTP id adf61e73a8af0-3f190087dfcmr1128599637.64.1794279937902;
        Mon, 09 Nov 2026 19:05:37 -0800 (PST)
Received: from hhost ([120.231.212.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm321901b3a.42.2026.11.09.19.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:05:37 -0800 (PST)
Date: Tue, 10 Nov 2026 11:05:20 +0800
From: Xingyuan Mo <hdthky0@gmail.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH] btrfs: bound free space runs by extent count in remap tree
 setup
Message-ID: <20261110030459.2640203-1-hdthky0@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.43.0

create_remap_tree_entries() sizes the space_runs array with the extent
count read from the FREE_SPACE_INFO item of the block group, then fills
it while walking the free space tree.  Nothing on this path cross-checks
that count against the items that follow, and the only guards in the
walk are two ASSERTs, compiled out unless CONFIG_BTRFS_ASSERT is set:
the FREE_SPACE_BITMAP branch hands the array to parse_bitmap(), which
appends one struct space_run per run of set bits without any bound at
all.

A crafted (or corrupted) filesystem that advertises a smaller extent
count than the number of runs its free space items describe therefore
gets a heap out-of-bounds write with disk-controlled contents during
relocation, e.g. through BTRFS_IOC_BALANCE.  The free space tree load
path validates the same count when it caches a block group, but that
check runs lazily and only leaves the block group in
BTRFS_CACHE_ERROR, which does not stop the remap path from re-reading
and trusting the item.

Bound the writes by the extent count: make parse_bitmap() take the
array size and return -EUCLEAN when a bitmap would overflow it, and
replace the ASSERT in the FREE_SPACE_EXTENT branch with the same
check.  This also covers an extent count of 0 (ZERO_SIZE_PTR) and
keeps the downstream entries array, sized extent_count + 2 and filled
with at most num_space_runs + 1 entries, within bounds.  Consistent
filesystems are unaffected, as merging adjacent runs can only shrink
the number of runs below the recorded extent count.

Validated with a crafted image on a KASAN kernel: an info item
claiming one extent next to a bitmap encoding 40 runs makes an
unpatched kernel write up to 624 bytes past the 16-byte allocation in
parse_bitmap() during balance:

  BUG: KASAN: slab-out-of-bounds in btrfs_relocate_block_group+0x2a46/0x3600
  Write of size 8 at addr ffff88800c992550 by task balance/278
  __asan_store8+0x85/0xb0
  btrfs_relocate_block_group+0x2a46/0x3600
  btrfs_relocate_chunk+0x82/0x320
  btrfs_balance+0x1071/0x2e30
  btrfs_ioctl+0x2943/0x3c60
  __x64_sys_ioctl+0xd1/0x120
  The buggy address is located 0 bytes to the right of
  allocated 16-byte region [ffff88800c992540, ffff88800c992550)

with create_remap_tree_entries() and parse_bitmap() inlined into
btrfs_relocate_block_group, while with this patch the same image fails
balance with -EUCLEAN and an image with a matching count still
relocates cleanly.

Fixes: b56f35560b82 ("btrfs: handle setting up relocation of block group with remap-tree")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
---
 fs/btrfs/relocation.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b2ac5b836b217..d57522cc7f386 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4013,16 +4013,16 @@ struct space_run {
 	u64 end;
 };
 
-static void parse_bitmap(u64 block_size, const unsigned long *bitmap,
-			 unsigned long size, u64 address, struct space_run *space_runs,
-			 unsigned int *num_space_runs)
+static int parse_bitmap(u64 block_size, const unsigned long *bitmap,
+			unsigned long size, u64 address, struct space_run *space_runs,
+			unsigned int *num_space_runs, u32 max_space_runs)
 {
 	unsigned long pos, end;
 	u64 run_start, run_length;
 
 	pos = find_first_bit(bitmap, size);
 	if (pos == size)
-		return;
+		return 0;
 
 	while (true) {
 		end = find_next_zero_bit(bitmap, size, pos);
@@ -4034,6 +4034,9 @@ static void parse_bitmap(u64 block_size, const unsigned long *bitmap,
 		    space_runs[*num_space_runs - 1].end == run_start) {
 			space_runs[*num_space_runs - 1].end += run_length;
 		} else {
+			if (*num_space_runs >= max_space_runs)
+				return -EUCLEAN;
+
 			space_runs[*num_space_runs].start = run_start;
 			space_runs[*num_space_runs].end = run_start + run_length;
 
@@ -4047,6 +4050,8 @@ static void parse_bitmap(u64 block_size, const unsigned long *bitmap,
 		if (pos == size)
 			break;
 	}
+
+	return 0;
 }
 
 static void adjust_block_group_remap_bytes(struct btrfs_trans_handle *trans,
@@ -4608,7 +4613,11 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 				space_runs[num_space_runs - 1].end =
 					found_key.objectid + found_key.offset;
 			} else {
-				ASSERT(num_space_runs < extent_count);
+				if (num_space_runs >= extent_count) {
+					mutex_unlock(&bg->free_space_lock);
+					ret = -EUCLEAN;
+					goto out;
+				}
 
 				space_runs[num_space_runs].start = found_key.objectid;
 				space_runs[num_space_runs].end =
@@ -4634,14 +4643,15 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 
 				read_extent_buffer(leaf, bitmap, offset, data_size);
 
-				parse_bitmap(fs_info->sectorsize, bitmap,
-					     data_size * BITS_PER_BYTE,
-					     found_key.objectid, space_runs,
-					     &num_space_runs);
-
-				ASSERT(num_space_runs <= extent_count);
-
+				ret = parse_bitmap(fs_info->sectorsize, bitmap,
+						   data_size * BITS_PER_BYTE,
+						   found_key.objectid, space_runs,
+						   &num_space_runs, extent_count);
 				kfree(bitmap);
+				if (ret) {
+					mutex_unlock(&bg->free_space_lock);
+					goto out;
+				}
 			}
 		}
 
-- 
2.43.0

