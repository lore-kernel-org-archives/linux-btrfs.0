Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794962289;
	b=bxBsrhCS7rLTw2U60lRVW2yLBpcHTOd3uywe0M3wAB13zDLq6wjVvOlMLjGtbFdAWtp5
	 nrxcFsiBNtVbyDQkXEN6GldX3cbkyP8eTuUurW6pQiYPNmyXH0draj0Obq/ivPgAzzkKL
	 pNVhKGwayGkeOnfyd6QwZJFcAyzCXnsHLBRl+eHM5u5EdcpFLvR3KqK4M6jAWLS/43Xrs
	 /8OkmNKpt7ssivCx0a0UjtbpORPJ/N58/r65FcjOwW9+S0M6YkRc5z19LwptUa/y06JxA
	 C5EpPh4G6kZF9bR2RVkhb5xxJ0LVB2/05MOS+ck0L+NwuIBZC2Steu3zv1eHYiWmbWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962289;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GGx8OzdzqapfevoWWRMRNGEIpX1i/hNz58ZqC4Nkm8E=;
	b=APBoUBk6g0mMAedtJlvHHz5gpgaQVysENaCCC+/hlRBfAG0pC9PuJL0KkBNHslUTaCBc
	 HtBiIy311KcQOto605tlAvpQArbmag3Yjp+Vfvz/Ns4Ixes+7E/E7W7qMNc5eup4qDi79
	 eZiff4yWKh1k+kBzkm7Yvzdrx7bOPzgJvj5EofpDmGLQk6yKMPbvToqudw/s4utVhqVyM
	 jvyE7hPZsUan6eAnCiQ5c8ITlYoYSKjZH/ODlM5Iz9jiV7iIwO6yjhyMoSXXkbEeKYdS3
	 zjRVRZvqM/JBaqY0uzHB3QFedryi2tDT3JeGrIImjds2Wf3PxIYttnjd+1qPZ1fmdwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mV9be3mc;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEBE606A897
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 00:38:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCEBE606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mV9be3mc
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so4342515e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 16:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794962284; x=1795567084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GGx8OzdzqapfevoWWRMRNGEIpX1i/hNz58ZqC4Nkm8E=;
        b=mV9be3mcMTKxVPK4czv5jUUSyCo8ztvwir1wZfprO0UV2FifRWMguzaYEUw0keTJS9
         aa7+u6pIIdhYauoDM4+P5IpOPAxhXlHZ/G7hA8z7AoCWR2tblnaL4/pE7hntTZ9ulzkA
         PH4kRz00AHDBDmNauKrGtrktCmS3qDBpi7gPBAcMcp0rKuSdBaTE1PVAptjMY06uxesg
         Ln5hNyWQN3haPIc0M4L2dJeOm2dJzQWrIaRS8q4ydog+z+MbdGk1VTHFvwzA7+Vr8lxx
         yzO/pQ3Bt/wsmscivSrnyN7Qxmet29wIL573Bzhm2XBUX4aWJTPi0KEFxvG5qYo3yFNW
         K+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794962284; x=1795567084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GGx8OzdzqapfevoWWRMRNGEIpX1i/hNz58ZqC4Nkm8E=;
        b=EF7QFd06lQaYEr1a+tmHlkcetmu0RSDX0Y4+P6cB6Hzb47Kg1e2MlHoPYNcxPCG+Ik
         St4K3A+RobQ9uNElXd9kGe5nXzJk2GpeREPdpumV6lKQyOmhXjk68PwaMcspzE+V+jJz
         nLEXrvnkzyqby1Duce/G6kd1uWqc85u8gr1ozmEU3zFY2KgWX5hR/IoLp3EnaFjdDOn1
         k6ajlVPWzdN31G93gx1qvFjTDCxtdcRbnT0P9EEhp7lZrwD6CZlngj+UH1/uhF0He9B9
         3n6daRy/AbYzQUx/hgKh23EpdFvn15bSy94hFAHQZAo80OWCq55KPxjZpSPqyjyoiJGk
         itHw==
X-Gm-Message-State: APuU4Z97CXdhcvxvj7H+XRoSL70qKaUCX8rNz0fkH/1T9g4qUzKhjRcc
	4DhrmnIIqhG6u63Q/o/jrm/zipTcxGUkTfUrWlas16XsNjxr8IjkV/gA8tiLnrvNdYU=
X-Gm-Gg: AYBFou2zu9qWd98slJYhKFexC3wmwbdSpyzQjhD8zY26YTrOv0A708Mxt/JZvo1jpY2
	HHomj/mY7gmvgkiV1hbEylrj7golkUz8vAds0cuesNHpyQ1IEku5Vw6THIQTirPnl2EqNqn7biS
	YD8vMjQAI+FKLtdh3zLcX2jCniKSPTFGaUn3aLZliCMSwbuXSzAV1zdCSj6UkqNJUKFqB4JWR2R
	SRhfZ5kNaMCBj2cpkV+kiOYPbqRzDa2SmQAZcKRiPxzwMlDZspY9n2FHvHBDGccx9gSsaI6xYhh
	GQZZiWr6QNOHZ2D6UfuHHayXXs+4o6y5J03t7CVXBVyJf+kPvanRyiTdV+J5RCYE6kz2kPfGJNK
	HKr+a65fd2dm4qHopQJ85wmb4Ipxb+iBfpmLvm8W5HREC73GUOQ26zVdv2qB+OGhzB4mpMGxKjt
	H4xboWJoob4y6MJoZYoqHFKPINfZmW5VwaO5m99Y0etpox9iEmI9qgoVTFx+1YvkPyHa5fqEkeJ
	Z5Nxu4Vy6StSbYPh9w2BIHrOJeztzBxOipDOzomofWskLaK32dQ7p4LRjYcP6a1Byz6sSD3UDhS
	+9AaHrdcGfeBhAxw/3jI1Q+9Hk2xyxB30yYjOXpguRz3HrtVY4mX7/79vrznEY7Oaa0RI/n20Ml
	JmrCW5rglyHDDbCUyN8HYsoh2AymT5jiAFe+CWx9SOa5Q5h2lxCdnvHBMe0CyVI0KBJPbpdORdO
	EpNWAx
X-Received: by 2002:a05:600c:6208:b0:4a1:da58:1ee with SMTP id 5b1f17b1804b1-4bb7da46178mr16130175e9.31.1794962283957;
        Tue, 17 Nov 2026 16:38:03 -0800 (PST)
Received: from maskinen.tail34f753.ts.net (c-92-34-161-199.bbcust.telenor.se. [92.34.161.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655608733sm1552901f8f.22.2026.11.17.16.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:38:03 -0800 (PST)
From: Elias Jernberg <eliasjernberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@kernel.org,
	wqu@suse.com,
	dsterba@suse.com,
	mason@kernel.org,
	Elias Jernberg <eliasjernberg@gmail.com>
Subject: [PATCH v2] btrfs: speed up steal_from_bitmap_to_front() with a backward word scan
Date: Wed, 18 Nov 2026 01:37:19 +0100
Message-ID: <20261118003719.1789633-1-eliasjernberg@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114000234.339513-1-eliasjernberg@gmail.com>
References: <20261114000234.339513-1-eliasjernberg@gmail.com>
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

Scan backwards from the bit below the entry one word at a time instead,
so the cost follows the run of free sectors that ends there and not the
number of allocated sectors below it. The result is the same for every
index: a userspace copy of both versions agreed in about 11 million
cases (bitmaps of 256, 32768 and 131072 bits, empty, full, random and
long runs, word boundaries and the last bit). The index is still
limited to BITS_PER_BITMAP - 1, as the old loop was.

The workload that triggers the stall is the following fio sequence,
run in a directory on the btrfs filesystem under test. Here
"end_fsync=1" is the fio option that makes fio call fsync() once on the
file, after the job's last write, before the job ends. Nothing is
deleted while the file is open.

  # 1. Write a 4 GiB file with 1 MiB direct writes.
  fio --name=a --filename=f --rw=write --bs=1M --direct=1 --size=4G \
      --end_fsync=1
  # 2. Rewrite it with random 4K direct writes for 15 seconds, to
  #    fragment it into about one million 4K extents.
  fio --name=r --filename=f --rw=randwrite --bs=4k --ioengine=libaio \
      --iodepth=32 --direct=1 --size=4G --time_based --runtime=15 \
      --end_fsync=1
  # 3. Sequential 4K direct writes for 15 seconds with an fsync() after
  #    every write.
  fio --name=s --filename=f --rw=write --bs=4k --direct=1 --size=4G \
      --time_based --runtime=15 --fsync=1
  # 4. Delete the file. No fd is open on it any more.
  rm f
  # 5. Write a new 4 GiB file with buffered 1 MiB writes and one fsync()
  #    at the end. This fsync() commits the transaction that frees the
  #    extents of the deleted file, which is where the time goes.
  fio --name=b --filename=f --rw=write --bs=1M --size=4G --end_fsync=1

Only the last job is timed. Without this patch it ran at 119-147 MB/s
(29-36 s for the 4 GiB). With the patch the same sequence ran it in
0.8-0.9 s (4613 and 5238 MB/s).

Fixes: 200055239604 ("Btrfs: improve free space cache management and space allocation")
Signed-off-by: Elias Jernberg <eliasjernberg@gmail.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---

Changes in v2:
- Expanded the changelog as requested by Filipe: explained end_fsync,
  moved the reproducer and the measurements from below the --- line
  into the changelog.
- Added Qu's Reviewed-by.
- No code changes.

Notes:
- The numbers above come from a 7.3-based tree (aurora-silicon/linux,
  Apple M5 MacBook Pro, 16K pages) carrying this change in an
  equivalent form. This version was build-tested on btrfs for-next
  (3aefd67f08f8) as x86_64 UML with W=1, no new warnings, and the btrfs
  self-tests pass (CONFIG_BTRFS_FS_RUN_SANITY_TESTS, including the
  bitmap stealing tests).
- On x86_64 with 4K pages I could not reproduce a clear stall with the
  similar fragmenting workload (sync after the delete took 0.4-1.9 s),
  so the effect looks tied to the larger bitmaps of 16K and 64K pages.
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
2.56.0

