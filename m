Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97603BFE3A
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617644; cv=none; b=dbqbCL3++snRWjktveWrKy8Go9CSxuTZQWPYA24SdMRjnd40HK2QERCeLpG/+5cxGqYkc6k5mCheY/vmqePBksCAzyOy6E+82Gnj4rHd/0AaWhqZ+fgiSKIgDOMGbPvVVwC1klm9+LsJB7g6UqpgccO0r1xbPZ9hC46ctyxs6dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617644; c=relaxed/simple;
	bh=neT/tzpSIWnOsYxFKC2yUFBG9n1yazxJzFDZgWXyDBs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PnRZsftsDbWMZM7RwytF439WdDFkCms8oLY1fhGZkMeHwtLeX+Jnm4Ds6gGYKWQQWmubYCkAGLWs7Deq8rfJIWfaUjU8QjW/R90GaG1rSJy1obvkBnILstG/WRcC7YX2z6uWFDquebrDWhHzZRPpgGvZ48RwZkRBZsk/H/0i5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=EoF/XLbE; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=472qn231; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="EoF/XLbE";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="472qn231"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H40Oq73680672
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=5q6Q
	29uB2RPNQ2NyxscgzG0RbvLJFOMyV0WxiGVhcCI=; b=EoF/XLbExRdqjdp1C46h
	m8I8p8hqGlrbgLKljdhu7NU3JXY6hmNXGdWmTly2p294cbar9FpZu0j49qx1d+9O
	NQc292OvNuSBk1ONMSP77fPB+z+n3g2/d+t4On//fNIpVuYCLfnAT4LnmAcpQ3Cu
	2TfVP50koOSF+4U/aQUFVmrRd0gmThmXJ/pTj31dxRFkeqf6jSSJmWxKQKZ//Km3
	PtuEhRl+jgM1d5xuPJpAi/O5Fe9QZQsep2LzwpGHTr5aZWXkbxAVRTmH35/z5evL
	iXceec6yn0cukTFzz3Eh6FCEri/8jIB61LFEEW954JyrFmUo2NidxdbRy9MGLee/
	5Q==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr3swhd05-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:39 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90c8da50f4fso6427716d6.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617639; x=1790222439; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5q6Q29uB2RPNQ2NyxscgzG0RbvLJFOMyV0WxiGVhcCI=;
        b=472qn231s3laXSqxvpe/HX4bsaplIOiC0R+vEct9vWlciMgqRneaFmDX2asZHrWhiN
         CmdP/HcA1IXrh6gWAHbx8kXn/h8TAPlDBAdKBQUEqiCV8gBJQDIZo0qo4f5OBgC2rk7r
         dsj/Ar6JV8ewuv1AdmpQhx2q7sRO+8ZWW0w15GOLBmHczju6lTtkLIH4I/vzcH5nIt7+
         byZ/aDkB9OAQqC7foLYtA3tyPgwJN1OkX2Xr166dxc0ZtbfYC/cvhhuINhnpo5/vwJrz
         +Vh0O60fCAVOtiQ7HSBaZV4dDLzDV+Z20FV3guGxyhvwLf5vhr3ToZ0Atgi79VHASy/J
         ANZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617639; x=1790222439;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5q6Q29uB2RPNQ2NyxscgzG0RbvLJFOMyV0WxiGVhcCI=;
        b=jkV2aTx9Q4m4i5zbZcZ+IYvDStD/pJcNtQ3uHHwgLsqoYC49CpQIhRoGcSNwG6jLb9
         nyoYFCmB7HWCzWjbd5gs3XxN9DWlmVgfIMonYv8Fh+YAzvy5LjkHo/qijnxVP4J5N45+
         /i61XbitDkIsjoUt1sUT/lXR4bxbtkjiJPX9HH6B2RZeGz6GlQURIsrwNCd/BmKBuyZs
         a6YVooFwUTpdKqcsOQMUiJdpipRhZWL7CLxjQQPxvR3MybEeWLJpInPp41lmY6/clrnr
         dRKX7xpnAbInCcb1YgC0OB9ayfjXywcWJ+z+MCsJetOSNGFiFdHj8GHsahFfNea+eGTe
         Lh1g==
X-Gm-Message-State: AFuF++kOO8XlosDtq+pE2m4QDY/GPXwM8JL+vrpOjyTNfb5WEFZwv36J
	MBvqLajz0UAEmPKXeWEwk81b6fuF8nCyuh532QgZ0QqMgRsWDimz7vW8gMx8tDVmqvrBwROxEe3
	ngQF+Z02H5Xb7yaKeZFbG7iI/fw+JnwHtY1CYMM+thhuZnZl9P2s2tcHMEbZA
X-Gm-Gg: AYBFou1DhEEay0T7fdXxgpsP2EoA77vBUVhL562FD+OEnPCydbDHFXd5WS/x5qQnfzW
	OaHTFFpHVlvRIEYsBG7gA1UVwqgMinW1nGsaPwMHwdDGErWEPArnQ536YKcMhR8N/Eg/fyriSj8
	dz5mWZfTMZAPW5ruW7giIybE6X3efqdqSg+3DueGaKbZM+yyf4NPOPcKMRFy/QKuMt20vMWyQiF
	y4rWko6nPLA8DwpG5ctHgltxM/gO6gs5/7tXAVveSAv2bF+hnzLbKhYN//XlXP3f5yyqE0CvaVx
	KXZRPXIlgo2faQv216YYEuDfmi4fhBImXr4q4wD2gmHfGid6r/e2+VNpv0261HNjMk7Nm9hH6mW
	5/Gp06IgMn6oRJLM8PC3jp/kRRJA7idDH6RUHMaMsd9oQFw==
X-Received: by 2002:a05:6214:404:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9123d754226mr100463246d6.11.1789617638610;
        Wed, 16 Sep 2026 21:00:38 -0700 (PDT)
X-Received: by 2002:a05:6214:404:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9123d754226mr100462716d6.11.1789617637983;
        Wed, 16 Sep 2026 21:00:37 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:37 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:07 -0400
Subject: [PATCH v3 11/17] btrfs: remove the free space cache trimming
 ranges
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-11-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=7181;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=neT/tzpSIWnOsYxFKC2yUFBG9n1yazxJzFDZgWXyDBs=;
 b=S5JfT1WYgC07tpTNfrCv/4rGpeI2qoVcApImDnfJd4jCv3TSC2cpsgyxysHGkFg4L1q6JhPgH
 MsqJW/MEDEcC5suGNw3hhldgo4orHFO8+R7GcZgZNLJEqQ4k5xlP9Tt
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: TvXgLuLE_NFV7qv3QRWuCxTJ30V-yhTm
X-Proofpoint-ORIG-GUID: TvXgLuLE_NFV7qv3QRWuCxTJ30V-yhTm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfXwO9pC/x3jJ47
 xRxqaMcpuddP/MSn0Y1DmLur2GOkP6G1RAZpMceK0Tl5tJ3Fk38J+z9IimRi4b0L4J4FgE6kh+O
 y137wNPKR6DyP+gyFePzA+UX6/Ar2drH7FKDTihxJ3TKZuG/lnT3
X-Authority-Analysis: v=2.4 cv=ac30Dhot c=1 sm=1 tr=0 ts=6aab65e7 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=qCNzSPQ7UVaF4CatvjwA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfXweI4UF9UrMgz
 fyyFzq2HEx/oW+kdwQAyi0fKervdioxBptIuio25zD1+gaBkIjnFOQN/ITrtYnFe5JIpLJokL54
 XbgCZlUwxcrI+D8IS7uLcnOj6xH2hHEOfyDLGR9timnSzMziErIVB9GcuuUTKrVvgGrh7hXTby8
 jSByeDt+3ITp8B3Qi07bFIpFvCJ0IC+kfMCqxa6gIQKYK77shDUU2fyOtAMlB08JozltogVKvj0
 dejkmbJ8dnDdWpKXkf9Nau57lug+esdXgDSsny4d3HnHBGSByr0xQvCurkCnfNYz9uXwrudTfz3
 icpQ3R8QLInaKfpRqFuDUFnbm53VzQSo0WTrGSjbisZL5DK/32QRSd2vEXPO1XlmtjzBUQpyZkB
 whg2oK+9vn9bVaqgU6P++oGLxHdPDLdZdB2Bl1CQmOF3dj7p1usauAw7Z526TY9rj0AH/IGm4m4
 mu0QAeSP5t7o4ylpXpg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 clxscore=1015 adultscore=0
 lowpriorityscore=10 phishscore=0 impostorscore=10 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

cache_writeout_mutex and trimming_ranges let the v1 cache writer see
ranges that were unlinked from the free space tree while being
discarded. Nothing consumes the list anymore, and the tree itself is
protected by tree_lock, so remove them.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/free-space-cache.c | 41 +++--------------------------------------
 fs/btrfs/free-space-cache.h |  2 --
 2 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fb6ff3db1241..2a40167c3fb6 100644
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
@@ -1692,8 +1686,6 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 	spin_lock_init(&ctl->tree_lock);
 	ctl->block_group = block_group;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
-	INIT_LIST_HEAD(&ctl->trimming_ranges);
-	mutex_init(&ctl->cache_writeout_mutex);
 
 	/*
 	 * we only want to have 32k of ram per block group for keeping
@@ -2389,12 +2381,10 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
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
@@ -2420,7 +2410,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		trim_state = BTRFS_TRIM_STATE_TRIMMED;
 	}
 
-	mutex_lock(&ctl->cache_writeout_mutex);
 	if (reserved_start < start)
 		__btrfs_add_free_space(block_group, reserved_start,
 				       start - reserved_start,
@@ -2429,8 +2418,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		__btrfs_add_free_space(block_group, end, reserved_end - end,
 				       reserved_trim_state);
 	__btrfs_add_free_space(block_group, start, bytes, trim_state);
-	list_del(&trim_entry->list);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	if (!bg_ro) {
 		spin_lock(&space_info->lock);
@@ -2468,9 +2455,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 	const u64 max_discard_size = READ_ONCE(discard_ctl->max_discard_size);
 
 	while (start < end) {
-		struct btrfs_trim_range trim_entry;
-
-		mutex_lock(&ctl->cache_writeout_mutex);
 		spin_lock(&ctl->tree_lock);
 
 		if (ctl->free_space < minlen)
@@ -2501,7 +2485,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = entry->bytes;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 			unlink_free_space(ctl, entry, true);
@@ -2526,7 +2509,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = min(extent_start + extent_bytes, end) - start;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 
@@ -2535,14 +2517,9 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
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
@@ -2566,7 +2543,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 out_unlock:
 	block_group->discard_cursor = btrfs_block_group_end(block_group);
 	spin_unlock(&ctl->tree_lock);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	return ret;
 }
@@ -2677,16 +2653,13 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 
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
 
@@ -2702,7 +2675,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 		if (!entry || (async && minlen && start == offset &&
 			       btrfs_free_space_trimmed(entry))) {
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2728,7 +2700,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 			else
 				entry->trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2739,14 +2710,12 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
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
 
@@ -2766,13 +2735,9 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
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

