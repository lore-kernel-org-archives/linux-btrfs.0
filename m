Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794614604;
	b=0MFZPXlqm/j83fzGTgdeR5bKvT5GTI9CYCQPAtf1G0Bg0imhFkvF156hRmBCRlBDe4Xh
	 FQmdMnAu1/S7LIJr4JYXXYugtoxag3A7S7yH0r6vFHeII5egMhe7hKKSVSLk214Fs0G2M
	 NcqDekHMQHb35BEF5V5q8PW+iQFcXZoNwe13FUcjMaVItlo0MHLxvCTwcjJYQicRrjAoC
	 3qO0YdWOnhLQY+rA5XJ9N+B5SRTiOkZ78sPHT9h1O7pNbzY5agI4WrVhbP95i/NCowYd0
	 cUc97umQcTLA+LlTdEhq7/k1chlRy4FuZPT44E5xn9/M4e1EAQCMLvY5CquXJ7luoGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794614604;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=a7pGms8TNrWu+CVwBGXtJHMCPJt+xc5iv3A84J/yTJ4=;
	b=qipyTdyD8f+kB4jgCya/FFhGFQuaIzd51Ek5Wq07JvS3nVV17wGsU1MXeEu3vfjTeeO+
	 UITT5LHNP5jLMuqUTa3f/zgGpx1NJQWppZvWmwwdmX0WFR/bpOwJPBaTRTSOjzd/zqiMQ
	 VVQkvNDNWhc9owVRns1bppYRTvv0qXul9eMSMMAxkwCXebtsWh5j5cC4mhJzkfZg/O7uQ
	 HnQ+nChhV7MNZnXCbvN0US3RcM3px9b5VSdvHYngOdnQY1aGwf4LzTU7g+wbQDEGMzJ/T
	 LySv6+zbQqmDZMxOlXB/nb4IljZ159Fv/YyzSNxCmKS9sM5MIyzZHhbQ3al4OrbNqgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhfEWIoD;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92D1606A334
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 00:03:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E92D1606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UhfEWIoD
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so4820711a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 16:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794614602; x=1795219402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7pGms8TNrWu+CVwBGXtJHMCPJt+xc5iv3A84J/yTJ4=;
        b=UhfEWIoDilixDdVKkHXvTSIw6DZGZURqAGbV17x2tGCJz8KDmqoHT2TMAB50W4E9ij
         fB4RQIB/yK0aLcbq5mY9EAnT2yV9svKrtP0pmZ1u9Ob8nUEkAgUe3v2v4XieQycGx0wX
         9p3VeXlUwFgIjUrlkt2wsa2iyapzLBVjyPmnSwwPzmnqDXAk8SU+6EPmo55+070iNMkE
         3wHfSgZhLscB+qL0GuxaLXhgC9Us7Nej9NdZyscfStbP6pK7YlqwLYp5mbVCPBmqx0Ed
         W/VG2KVGmai0G/rHF0kKKafrC/8KIGsQS4aU6SkWezR7ZQHShBD36qUhc9VHto+5T2hI
         IVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794614602; x=1795219402;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7pGms8TNrWu+CVwBGXtJHMCPJt+xc5iv3A84J/yTJ4=;
        b=CRNkP7bLM2F52VTKpvoV+ZCEukyyVOKjwYwYIWFLVtCDB6zUllMUmRkZLCVTPCm9bq
         B1/OAMj7vXTF5svAYEwYV+Ig4EneEe/9FgSiIrv6qBNczWeDy9BfzdPH+B2CLDE+KLmD
         4AC3L4i0B5JB0U9QnuWtoSUvEiLsncA2usvWgAq1l43NifrQbYNY0qCfcohq56laur59
         avsV3rvaFjObXDSKGV7jPaZw2CON2behvI71VOMtFlQ9f/5PlfFn4+VN/tZribmvhega
         Rh0m5c771XtFQJysSpDsrWR9TWeicn0Vq1p/IgQqleBx5FguKD4DQydU/rX04NgkU0yJ
         VCmg==
X-Gm-Message-State: APuU4Z/17CiF/ImST5tlCDGKj/Ggls/qJw3eMMQ4oRBuJsF3iQ0/x+jc
	hEyOCb7FUQshIRwrh9VoE5mCwLI08PGVFMcUsQspsxnmCfPMV7Ps56RBPASV3OzV1a8=
X-Gm-Gg: AYBFou32eV2pKfLE9F5yCmHtRtDzz0FAY86PZzwe+eSDqZhZFu/5/o++A0S7gpH8FkO
	DePmVwehCCsvyoRZcCOoBF1qov5GARbU/UZLR3vy1eZCk4IuHohUb0NQRLOTWY5wdfcNCWVHTyQ
	Nenny7x2+05Pg8g60TuOY8/bfBWDdUX5oVek3cI7qO+C4o4rOjIQfTJWh6cKg96SXiZqBvBBZJG
	H4LTk+twUv8PjvObPVJGi4Mo9Ydxcaep8TZeFExE0DJ+UQEaGYSWoeHdaY2tvm8ONxC2SZgTeXQ
	zGgWXfGOnGWoaekShP1aK+UL+s9shfBdReVbn+wGnAz7RYY5r0QCz6V8gUHRorhKHRrfn4bdGok
	SHAFCivJYjT73Fr9gB5OeX7+2+B5eIgh5FxkJ3RJWUvP4T+WLouiSD6iz3CQgYX/j45GmUtk6bA
	+e1NKSeZw0QmR1sMb3xrVOcycNO7t4+lZDaqGMq7GPhgvL95Vyqm6ewkekSt3qXzojr/RIVC6jR
	oxSsd5vqYLUY5p7FvVcfseNUQN+3YK82AGUyRLmvW8LLbV3/gKs3ZAbGQXHIG2QTiqOE8qGekrU
	01XkRqYjDVVSg1a8U0m26Pq0ilVjbD3ha7cHwwUQNUMVVlPRsVzi2aMBxwVCYElAtJaqiQfTppp
	hncUERJzpwhxt8+gLqHO7BRQXFhseuhABqAfbLPNmqC4gwhjMH6KihETqKKaaUFkhESqRgJpTV8
	REqh0s
X-Received: by 2002:a17:907:3f23:b0:c46:7de7:e41d with SMTP id a640c23a62f3a-c507c3f5d4fmr655113666b.18.1794614602043;
        Fri, 13 Nov 2026 16:03:22 -0800 (PST)
Received: from maskinen.tail34f753.ts.net (c-92-34-161-199.bbcust.telenor.se. [92.34.161.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23db711sm1535570a12.24.2026.11.13.16.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:03:21 -0800 (PST)
From: Elias Jernberg <eliasjernberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Chris Mason <mason@kernel.org>,
	Elias Jernberg <eliasjernberg@gmail.com>
Subject: [PATCH] btrfs: speed up steal_from_bitmap_to_front() with a backward word scan
Date: Sat, 14 Nov 2026 01:02:34 +0100
Message-ID: <20261114000234.339513-1-eliasjernberg@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

steal_from_bitmap_to_front() looks for the last clear bit below the new
extent entry by walking every clear bit of the bitmap from bit 0 with
for_each_clear_bit_from(). In a bitmap that is mostly allocated that is
one find_next_zero_bit() call per allocated sector below the entry, and
it is done for every free space entry added next to a bitmap.

With 16K pages a bitmap has 131072 bits. On an arm64 machine with 16K
pages (Apple M5, 4K sectorsize, discard=async, compression on),
deleting a 4 GiB file of about one million 4K extents, after scattered
4K rewrites had put the block group's free space into bitmaps, made the
next fsync take 29 to 36 seconds of CPU. Three sysrq-l samples taken
during the stall all showed:

  _find_next_zero_bit
  __btrfs_add_free_space
  unpin_extent_range
  btrfs_finish_extent_commit
  btrfs_commit_transaction
  btrfs_sync_file

A buffered 4 GiB write with end_fsync right after the delete ran at
119-147 MB/s instead of about 4.7 GB/s.

Scan backwards from the bit below the entry one word at a time instead,
so the cost follows the run of free sectors that ends there and not the
number of allocated sectors below it. The result is the same for every
index: a userspace copy of both versions agreed in about 11 million
cases (bitmaps of 256, 32768 and 131072 bits, empty, full, random and
long runs, word boundaries and the last bit). The index is still
limited to BITS_PER_BITMAP - 1, as the old loop was.

With the change the same sequence ran the buffered write in 0.8-0.9 s
(4613 and 5238 MB/s).

Fixes: 200055239604 ("Btrfs: improve free space cache management and space allocation")
Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
---

Notes:
    - The numbers above come from a 7.3-based tree (aurora-silicon/linux,
      Apple M5 MacBook Pro, 16K pages) carrying this change in an
      equivalent form. This version was build-tested on btrfs for-next
      (3aefd67f08f8) as x86_64 UML with W=1, no new warnings, and the btrfs
      self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
      bitmap stealing tests).
    - On x86_64 with 4K pages I could not reproduce a clear stall with the
      similar fragmenting workload (sync after the delete took 0.4-1.9 s), so the
      effect looks tied to the larger bitmaps of 16K and 64K pages.
    - Reproducer (fio, run on the btrfs filesystem under test):
        fio --name=a --filename=f --rw=write --bs=1M --direct=1 --size=4G --end_fsync=1
        fio --name=r --filename=f --rw=randwrite --bs=4k --ioengine=libaio --iodepth=32 \
            --direct=1 --size=4G --time_based --runtime=15 --end_fsync=1
        fio --name=s --filename=f --rw=write --bs=4k --direct=1 --size=4G \
            --time_based --runtime=15 --fsync=1
        rm f
        fio --name=b --filename=f --rw=write --bs=1M --size=4G --end_fsync=1
      The last job takes 29-36 s without this patch and under 1 s with it.
    - Prior art: Yun Levi suggested replacing this loop in December 2020 on
      LKML, as a user of a proposed find_prev_zero_bit()
      (https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2402457.html).
      That helper was never added and the loop is unchanged in for-next.
      This version keeps the backward scan local to free-space-cache.c.
    - Tool use: the stall was profiled, the fix written and the changelog
      drafted with an LLM coding assistant (Claude). I have reviewed the
      change; the equivalence test and the measurements were run on my
      machine.

 fs/btrfs/free-space-cache.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index bff6e5b372d6..c599a8f25821 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1269,6 +1269,26 @@ static bool steal_from_bitmap_to_end(struct btrfs_free_space_ctl *ctl,
 	return true;
 }
 
+/*
+ * Return the index of the last clear bit at or below @bit, or ULONG_MAX if
+ * bits 0 to @bit are all set.  Scan backwards a word at a time, so the cost
+ * follows the length of the run of set bits that ends at @bit rather than the
+ * number of clear bits below it.
+ */
+static unsigned long find_last_clear_bit_upto(const unsigned long *bitmap,
+					      unsigned long bit)
+{
+	unsigned long idx = BIT_WORD(bit);
+	unsigned long word = ~bitmap[idx] & BITMAP_LAST_WORD_MASK(bit + 1);
+
+	while (!word) {
+		if (idx == 0)
+			return ULONG_MAX;
+		word = ~bitmap[--idx];
+	}
+	return idx * BITS_PER_LONG + __fls(word);
+}
+
 static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 				       struct btrfs_free_space *info,
 				       bool update_stat)
@@ -1277,7 +1297,6 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 	struct btrfs_free_space *bitmap;
 	u64 bitmap_offset;
 	unsigned long i;
-	unsigned long j;
 	unsigned long prev_j;
 	u64 bytes;
 
@@ -1294,13 +1313,8 @@ static bool steal_from_bitmap_to_front(struct btrfs_free_space_ctl *ctl,
 		return false;
 
 	i = offset_to_bit(bitmap->offset, unit, info->offset) - 1;
-	j = 0;
-	prev_j = (unsigned long)-1;
-	for_each_clear_bit_from(j, bitmap->bitmap, BITS_PER_BITMAP) {
-		if (j > i)
-			break;
-		prev_j = j;
-	}
+	prev_j = find_last_clear_bit_upto(bitmap->bitmap,
+					  min(i, BITS_PER_BITMAP - 1));
 	if (prev_j == i)
 		return false;
 
-- 
2.56.1

