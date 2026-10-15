Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005283C343A
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075430; cv=none; b=W3k7lJfi1SI5cTn/F/2dnP8jp3uZHzi2ksB3Uo4wvb6fxCg7kKQHUY5svyKgfpd2HIkYwY2fOOiozfNq/qRj4MczAKOFyaYC/KbA5POFicJfn5/QuaAtw2q29kOBYps85aVF11AzCAMCzHkvM8tpYWHLIoonkpnlC8RpPtQBZNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075430; c=relaxed/simple;
	bh=4jfueo1KRT+VSIydQk/kkJuNFgop/gPHtRCFmdEUFMg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i44mw8mWIH7sSEh9Jlz1HE+86+J1TryEswPPnHPtK05k1fZlhIaCDm2CE12AydPLgzpAeUTrwTMzAKesV+/QvBp2NIH60ZfWwlRcCqkfXgNwytCp3dxR36bXC8eUxzhcJfL3Bv8Kw9CIYYwXT/KLEhf7Bf+DzFnUAykfqZpRRv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=huzXDH+D; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eI4aEA5b; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="huzXDH+D";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eI4aEA5b"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYCYR2220715
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5gB+
	ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=; b=huzXDH+Du7y64TqAVPdI
	xZatt1ZhX7j7jDgcl9ltcuD3V8nNbLZuzgNaxJpRXpyISCwMXBg35aUVoi0x8B9w
	UKl0+BZav8mz3gTZKVQTuMzfjYcB6hZT/OZHDFQ4mvnPPZkVnHfYFWhTZPYaddji
	fakSvaz0Ws0aCZD8nIlQstHIo0A2d6KY7vwOGbo999MgaIsDC9dR8pruvw2j3P71
	lDaOPtJoB8iqZf4nJaI4HEtJKYmPvU9pY/IAmUmSlmFqBktpOw71uOl+yjp42qQE
	rHos9ScUWsdN3jpUyVhliVt/qxFwNqNU54dDUlX8pNy36zEGpGlvaakNh5611BjG
	sg==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4havrsjafm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:46 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a510b22fso114601406d6.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075425; x=1792680225; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5gB+ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=;
        b=eI4aEA5b8ssTNEdqc+NRJOvemYYEFVbGPlRSRqNE0RmwmXm2Vhggkd2aUMF37tXBCK
         d+jvX59xiAlhqJhBOF5yP/71H+3g6x2sAkqajArQBftXYgr3O5WRbRs/dZZfuyZzDqrm
         hmLL097AtSUvOkPRNtZVm++F8hPRro5cujWiioi+HA8RM+wHvp5uCqrhAoV+qudcwqr1
         /za/XMWHqVfiDrNjIUxpdIao1i0mdQU5tpLxRmRmtp9PwLxTawMACYHaKPBNEfJTq1jb
         RjwiD/88g9cLorXs4u/reiDdLvHMZ+H1oOaDxrKiH4SNaUjYpTq7XmKnBKYdGEYoYd+Q
         4SDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075425; x=1792680225;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5gB+ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=;
        b=lYKgWzGgVNGVPsOUbxKTK+i1l/HpYX3PtAo9lHVf9VQ7F6tquhTGPy0oZlw1fR/ThH
         QB+IlyMSGvsfVNIQ+93BTTR9/aXDJwYEcXUzk0EjdQKzSegZF5e51UKP8anC2u5Ctdw1
         /Q5W8zbHX1icvzTg3iVUyuC46GNFDax+DXcUg5q74ygGhoxRZiZssFYIAOC2MZKvzhHL
         uPMa9hXY4KZL8JkXo7emWHK9X/luUcF6fizqBMK64bDHCyKMan1zViJXbZp8n+vxh7nj
         SB1DwQES248igDTLxCkVTzpCA9ib1b33S7/o4dfvlPmgRMSMNW3Jnewy0OgzOXIjIXyv
         KoNw==
X-Gm-Message-State: AFq9FYIk6clEXQL9jQh0xZdscSQa1R9NTbN44bCFX5VnUk6OIY8esF5L
	wL5zk5r3Qb3zYZOxhg+GIRQBFQPnWCj+pix50/Az7xBeSe4MtICulV8bZXCvQVqToDRrpOQ/gqd
	y2Pw1z2eYg4wU9quxt0T2DBweRlk5K8UfjjwLhUg+DIqbMH4OP9Bpy1+O/HZL
X-Gm-Gg: AYBFou1pi2aIylg9VQcg72XtN/bwTZAYDN+len8HpaV8xjnAHGF3z7rmmOW3XHCfe09
	dxaG2o1pKhU1W4Y1wMd9brw32D7+lPjpxRG20RqrbytGy1u3vr55FxD72jdWcyxV76r5B66gJB0
	yX7gTutlxjnwHVyhvJa2WTzUT7o94FPTkWPHRnFW8j292fyi1aST3mA3hnhuFhqGiDU+YY8Hnsv
	ouJ8n78YLzuEIqzuotbIYRvksqZ8dvxut3UTpBQ3lUXjKZ2+AaPY2F4GjfIvcJ/FlqqVgpR2IT7
	9yav/StY2lVHM2p4i7fOeIPnX26mawg0AW/1mRNMkIl3/Sb9ps0+EDdkg9YhOCMfuBUM1RnZsXX
	AajqEs/qGqy5zp5KHlrQp1uBQmkfoxK+4jy0b3Xa1sCw6
X-Received: by 2002:a05:620a:4693:b0:93c:771e:b672 with SMTP id af79cd13be357-93ebd2955d7mr3274780885a.54.1792075424579;
        Thu, 15 Oct 2026 07:43:44 -0700 (PDT)
X-Received: by 2002:a05:620a:4693:b0:93c:771e:b672 with SMTP id af79cd13be357-93ebd2955d7mr3274775585a.54.1792075424035;
        Thu, 15 Oct 2026 07:43:44 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:26 -0400
Subject: [PATCH v5 13/19] btrfs: remove the free space cache trimming
 ranges
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-13-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=7161;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4jfueo1KRT+VSIydQk/kkJuNFgop/gPHtRCFmdEUFMg=;
 b=i7GX2sa7SGXswYILoH7Wj+SBc6u8wcFVDBfoBE+NokgxUcEQm8I6to5LUIN4EhFFHywrJNPuQ
 KTg1KK9auj8D9xDmscba3+s2IxPBMp488VELK5UqQzuZl0sd4rVUUcA
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: NqfFBJhsqtgzELZGL6ZRXmK-YX0SyyCR
X-Authority-Analysis: v=2.4 cv=L/KI0OT8 c=1 sm=1 tr=0 ts=6ad0e6a2 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=qCNzSPQ7UVaF4CatvjwA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: NqfFBJhsqtgzELZGL6ZRXmK-YX0SyyCR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX24cIFleJ+BeN
 1HbZWxuRPk+kzdGy0tqgu7dF80dvBZoLODrML3ZVBccf1m60SieVwwv4k3N69fjKhviVhrxCfWc
 hzF2UGPe8eP5j6ddUfMXLo7d8tVd4GS776pIHYB4g7BiK4XrFhtubNm3mr0kjVnmPXK/jp/4S4k
 B8Ayr5hLebkzdI9ZhrQ521nGlBfzZ7675sBaz2P9dXvJ3K15YMsiER/Us8cWklaBufhYrT3MRia
 zRihoWZUDoTLFoChsNi/Z1hUQopnkUa3X/MyCGsfA4T4IOuE+CPDb/SaYDqU4G+RWEQlLbbD08B
 GkTiqg17Q+QGgwWUp0EOJlfpcQJssD5KdiCQ5F25nq2wIv+vVIBwJcgRXs+XAQ7QOpXZ++yGRi1
 yLh8uB8f4KXCQQTADjMyIFeJYSBs34HvewaPhO97Ib7TeHmEcJclaQ7ANm2LESXak3RxZGsLJK1
 YUz0IkGzY+v6LnA/9rQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX1DwR5EITKioS
 OQV06V24cSQoMkxjj7xe+Lo6FNzwv/WTQhVk91aW2nxRB1jXrbyFg3OBJQX3u3lVWsrka2xiHwG
 DyDXyPd7JdJx16Exs0/+cSiB/5AUMq5kQ6rtiARIkF2qrdKHp6Da
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=10 adultscore=0
 spamscore=0 bulkscore=10 lowpriorityscore=10 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

cache_writeout_mutex and trimming_ranges let the v1 cache writer see
ranges that were unlinked from the free space tree while being
discarded. Nothing consumes the list anymore, and the tree itself is
protected by tree_lock, so remove them.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/free-space-cache.c | 41 +++--------------------------------------
 fs/btrfs/free-space-cache.h |  2 --
 2 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4dcbefb0bfed..bff6e5b372d6 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -36,12 +36,6 @@
 static struct kmem_cache *btrfs_free_space_cachep;
 static struct kmem_cache *btrfs_free_space_bitmap_cachep;
 
-struct btrfs_trim_range {
-	u64 start;
-	u64 bytes;
-	struct list_head list;
-};
-
 static int link_free_space(struct btrfs_free_space_ctl *ctl,
 			   struct btrfs_free_space *info);
 static void unlink_free_space(struct btrfs_free_space_ctl *ctl,
@@ -1702,8 +1696,6 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 	spin_lock_init(&ctl->tree_lock);
 	ctl->block_group = block_group;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
-	INIT_LIST_HEAD(&ctl->trimming_ranges);
-	mutex_init(&ctl->cache_writeout_mutex);
 
 	/*
 	 * we only want to have 32k of ram per block group for keeping
@@ -2399,12 +2391,10 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
 static int do_trimming(struct btrfs_block_group *block_group,
 		       u64 *total_trimmed, u64 start, u64 bytes,
 		       u64 reserved_start, u64 reserved_bytes,
-		       enum btrfs_trim_state reserved_trim_state,
-		       struct btrfs_trim_range *trim_entry)
+		       enum btrfs_trim_state reserved_trim_state)
 {
 	struct btrfs_space_info *space_info = block_group->space_info;
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
-	struct btrfs_free_space_ctl *ctl = block_group->free_space_ctl;
 	int ret;
 	bool bg_ro;
 	const u64 end = start + bytes;
@@ -2430,7 +2420,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		trim_state = BTRFS_TRIM_STATE_TRIMMED;
 	}
 
-	mutex_lock(&ctl->cache_writeout_mutex);
 	if (reserved_start < start)
 		__btrfs_add_free_space(block_group, reserved_start,
 				       start - reserved_start,
@@ -2439,8 +2428,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		__btrfs_add_free_space(block_group, end, reserved_end - end,
 				       reserved_trim_state);
 	__btrfs_add_free_space(block_group, start, bytes, trim_state);
-	list_del(&trim_entry->list);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	if (!bg_ro) {
 		spin_lock(&space_info->lock);
@@ -2478,9 +2465,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 	const u64 max_discard_size = READ_ONCE(discard_ctl->max_discard_size);
 
 	while (start < end) {
-		struct btrfs_trim_range trim_entry;
-
-		mutex_lock(&ctl->cache_writeout_mutex);
 		spin_lock(&ctl->tree_lock);
 
 		if (ctl->free_space < minlen)
@@ -2511,7 +2495,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = entry->bytes;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 			unlink_free_space(ctl, entry, true);
@@ -2536,7 +2519,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = min(extent_start + extent_bytes, end) - start;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 
@@ -2545,14 +2527,9 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 		}
 
 		spin_unlock(&ctl->tree_lock);
-		trim_entry.start = extent_start;
-		trim_entry.bytes = extent_bytes;
-		list_add_tail(&trim_entry.list, &ctl->trimming_ranges);
-		mutex_unlock(&ctl->cache_writeout_mutex);
 
 		ret = do_trimming(block_group, total_trimmed, start, bytes,
-				  extent_start, extent_bytes, extent_trim_state,
-				  &trim_entry);
+				  extent_start, extent_bytes, extent_trim_state);
 		if (ret) {
 			block_group->discard_cursor = start + bytes;
 			break;
@@ -2576,7 +2553,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 out_unlock:
 	block_group->discard_cursor = btrfs_block_group_end(block_group);
 	spin_unlock(&ctl->tree_lock);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	return ret;
 }
@@ -2687,16 +2663,13 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 
 	while (offset < end) {
 		bool next_bitmap = false;
-		struct btrfs_trim_range trim_entry;
 
-		mutex_lock(&ctl->cache_writeout_mutex);
 		spin_lock(&ctl->tree_lock);
 
 		if (ctl->free_space < minlen) {
 			block_group->discard_cursor =
 				btrfs_block_group_end(block_group);
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			break;
 		}
 
@@ -2712,7 +2685,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 		if (!entry || (async && minlen && start == offset &&
 			       btrfs_free_space_trimmed(entry))) {
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2738,7 +2710,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 			else
 				entry->trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2749,14 +2720,12 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 		 */
 		if (async && *total_trimmed) {
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			return ret;
 		}
 
 		bytes = min(bytes, end - start);
 		if (bytes < minlen || (async && maxlen && bytes > maxlen)) {
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			goto next;
 		}
 
@@ -2776,13 +2745,9 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 			free_bitmap(ctl, entry);
 
 		spin_unlock(&ctl->tree_lock);
-		trim_entry.start = start;
-		trim_entry.bytes = bytes;
-		list_add_tail(&trim_entry.list, &ctl->trimming_ranges);
-		mutex_unlock(&ctl->cache_writeout_mutex);
 
 		ret = do_trimming(block_group, total_trimmed, start, bytes,
-				  start, bytes, 0, &trim_entry);
+				  start, bytes, 0);
 		if (ret) {
 			reset_trimming_bitmap(ctl, offset);
 			block_group->discard_cursor =
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index f5f18e397b13..e22443598b8e 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -83,8 +83,6 @@ struct btrfs_free_space_ctl {
 	s32 discardable_extents[BTRFS_STAT_NR_ENTRIES];
 	s64 discardable_bytes[BTRFS_STAT_NR_ENTRIES];
 	struct btrfs_block_group *block_group;
-	struct mutex cache_writeout_mutex;
-	struct list_head trimming_ranges;
 };
 
 int __init btrfs_free_space_init(void);

-- 
2.39.5

