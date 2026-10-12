Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747AA4BA1C9
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822535; cv=none; b=FrMBxT2OEloBka5xk4z1ESaEwNwUIgACF7B58gLSJdEswNBrJAR/qqDe/xO9qkwYoN5YuR+pxXwM00RWW/rp25WeVpOsNQ0zasF4XZ3C+UFYDbUkDhJjGxknStd6z+DrmzeaUiIjM02MIONcTRsbMRptr9+Cr3uHzU9alzRJTns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822535; c=relaxed/simple;
	bh=4jfueo1KRT+VSIydQk/kkJuNFgop/gPHtRCFmdEUFMg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i1PtIa7a6RmAizb9Gj7wI0QU8VJui8+BGErJpjvX5m32bd9cfCpFLLdykOOhqMvzwR5+IVWbXRqAXXYG6e8RWVdBq+ePv9x0tXdgr9nyAO/Rc9y39OwAN6QQh2bKps0hycYV3II9yveHInZiXX0CcS3tb/kIsW2SC8Ef3lWtYlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Sd4RqKOM; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=BcNi33ut; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Sd4RqKOM";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="BcNi33ut"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgVPX076334
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5gB+
	ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=; b=Sd4RqKOM7WW5PKVca91P
	lkXwZJYYp3TusUklcKSrW5Meyi/cVoGQlJ4SNWyGvV5FSy7ApBHzLn2ZCeOToNxf
	Rz3tdQPVzl2lEQsuE+CHVJmUMvbqtJWehVvaMgUjr6tcSR5tKEqfimqzWeqIAfQJ
	BjUuPzOIH3g2PRS+9PzWOTdIjWMA55tgyr3p7Hn/Uu3tGLXfPjMHoLSxbkB2wkKk
	OubwP2m7+dcXgxzcAoblM5luaecEXWpSMzlwdmoeEAsHsjDnrIjmy7dikFzBmGxM
	rTcTeEfV2N5j9xBgmoA3mvlqUdszpTQs3CXf1v3EGBIHsZSmY6gn16V0bmbhHkJU
	Hw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h902c283r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:51 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9197553d398so52410386d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822530; x=1792427330; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5gB+ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=;
        b=BcNi33uto0P4Ny91IIHoxB8jnRPS1FGniZ0i4BqUa+gvTewbWEUOSmoPyM7JeFn7S0
         7ppH56xMPnlsm0xWq8lNQbzZagdBDMy69QE/EnoM99D9lB4O0UeRXMjVn5gP2IvH0u0a
         ssVmYa29RsOgX12ySmFwbyH4x51QiZUIL5UnGY9lhHhaunlKNxrzBVlt6NwOqbDf9j92
         Az0FAvTf3owFera5gDPCfqIgxaVVE3fFtXuvw3MpHVd3MNzivPlZ29vSPBp+JpfkUaMJ
         vOMM1rdgtf7KqeVf7PkZSHYmf6kWafMMe5EVZoQgliFMf+TF2EVo9yPtL+RqbczhWSxI
         zqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822530; x=1792427330;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5gB+ZqwfjG4r0XBpuTzegxUAaW9Dt8o+O2PoEEbjMe0=;
        b=zJ9XIuN3z0oq6RfITuAkHa4excO9O7yAMhpuTBBpF7Ep3zvSA0hqRXxKiq5sMRk7Qk
         Jomv5zRjuB0Tsh7vZsG2nJkQFyGk3M+ijOmWBEjJjriFH/Gb2/yrV4axOz5CB60nrMhm
         z33pFZFkG4IBpNXsJi187ABRGKDY7aL5XHQ71rM2xJeV7+PKX2u9lYOFPWglTiJMMVne
         JU80WbqEAOYgmPmc9ZTMQeBMz0YRhm+jOD1hQxryJ6B/uSD0G01/EV9qnRqmG/faQcet
         Fvq12+V/0o7ucbf2kuRybQa1mWj31AOI0htnI8TabghYnwXjsRzGsWZXq8RyHi72U5ML
         U5Vg==
X-Gm-Message-State: AFq9FYIiE/mvfxG/gBP49sUqGVImS9/8DJAL401ZZP3xKvPnyXFgX87b
	+SWq9XUgq2fgeokoKLpgxGtARdSK1yX/ibRdL+4eEV7kE7QML5xuxqzyezjSBkejVZmF3PQtGET
	X/M6UHinhqkrBu1q6tYzj8jnKEStTVa2jQ7oEKnAfhjSVgt3ngxrEMTL4kLyH
X-Gm-Gg: AYBFou3G4PZPV08GYoZR+J4HnnfAjUS8d/RADSoXH/K9B7J2U5OXUgLgAtAQZFEED/V
	9SvK8QMlCl5vSGjFPaZZmkXXTfZce8CBKdP5xuU8ODHyHko8SfG7s5D5TjT+Twx68EHGGIL8LVU
	HNj3z4znM/YChi2xsbSb8Zpyzi0Dj7SJCGra45xUncKsP520FHl6UaaFmqXUVLa1eL21YjZYWdb
	Ye/++ta10qJIJIgNrMm31N5QtFLG2SnvtrWOO78JRXmmzGM3T3K0Iv6dEpM5So352rdkD/oxdJA
	HnynD7Syse7RsbxTQvdtgWYIo9ZFTwvgcrOePmhG6VTFQmnRQ92gI+mGuRjLdVjd3DMErqZnqvr
	UgUrVq5sJga1Ic0sUzWtDGkR0KQ3A1/NK1nWpJCMDGL0OH7A=
X-Received: by 2002:a05:6214:21c8:b0:917:a80b:b910 with SMTP id 6a1803df08f44-91b557bcb89mr189577356d6.39.1791822530368;
        Mon, 12 Oct 2026 09:28:50 -0700 (PDT)
X-Received: by 2002:a05:6214:21c8:b0:917:a80b:b910 with SMTP id 6a1803df08f44-91b557bcb89mr189576966d6.39.1791822529909;
        Mon, 12 Oct 2026 09:28:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:49 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:24 -0400
Subject: [PATCH v4 12/18] btrfs: remove the free space cache trimming
 ranges
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-12-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=7161;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4jfueo1KRT+VSIydQk/kkJuNFgop/gPHtRCFmdEUFMg=;
 b=id41IFkKv0P3FXaiEbr/RuQkj/pvKNnMy18gCMnbGCeOl2S00nA8I4ttJayDm/xBvU7vA7Ppq
 pjaKbGkKZn1B0ZpPbCMAOmodch79gLHy4irNGdcBdoHRITBKXyBw5mk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=E8xYNqdl c=1 sm=1 tr=0 ts=6acd0ac3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=qCNzSPQ7UVaF4CatvjwA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-ORIG-GUID: 5sdn35Ddy_4kbFjwnob5HqUP9Fo-nhjF
X-Proofpoint-GUID: 5sdn35Ddy_4kbFjwnob5HqUP9Fo-nhjF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX1cpHr4On69ez
 dK7GceTOdkyxDHaib7bqADzQOB1GEY2R00Y4w1u2+iNgP+XmKUJXI3RuxUEslJ+kY27rJQXUq14
 ZVXcacoX2o3DBIu/czJvqRnzawedw+kxMSTDCZ0Hk7fC0OUzgxnIAYw9tT/nRKu/noUmqlucA7g
 2hvC770qdg5nSt6LRXIwBsnsFc14iT5yo1BQchPNJxCGIZrIthzL1rsn7SR/zXrtgK3RjfCOK7S
 YcdPtR0ik4H1cVQ1K5dd2a1wTXJHMheGgfbLqA0NpVBKT15MvtNqKUNzAkwJ46Z9/zqOaXGutgF
 PEDdw2jnTukO21MIErHYZuiEQ3GG0DpZeaDLMRte3h1efMCJU47a5ovEFfqkvbNY5mE2+GB8mUx
 vMgsOEJ/as7vnPkiDfyJWbXNVMjEiqGXMNXS95acLSs1WMsnc6z3coPNnS4M5jqcL5TfL6jZIHZ
 +6lZqA53gTwqbHXdBrQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX0FjBaqyaLOGI
 U1GLOoXbf2mt5mBlZQ88baN55oDDqqF1W58ReTPQBMM2u8kxqAHYL6dXYFTQ4zjs0S9WwqlXr/9
 Ug6hnAXMBec7J2TPNftZd5/leBlhTZvKuwW6eDFi5jaTQNwRaj21
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 clxscore=1015 phishscore=0 spamscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

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

