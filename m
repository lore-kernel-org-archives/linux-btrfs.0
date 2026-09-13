Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2087363C6F
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334502; cv=none; b=EBUHtEf7GR9XMfvcSIpnP87avc1HCsaTr9rmmC0M2ZDKL2vBrTYol5amdimy4GY9IUIE6klVEvlcHzqPb5z98xRQCz/HuiIau9zs8X/Xg7ftZNZC/T80xD5B22ISnKrLGtxJFhYmEK03wzbVEQUzaYIvBCCY7DXDTptDG1GTMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334502; c=relaxed/simple;
	bh=f7QP8rjkTL/hFBjwJZZfAUG7xOyxTCYpKox4iSRIc30=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jA39B9IDfRU2DXM++TJXRSglRbmaI1xL6Sbd05GWt83YKUegQ3Jzyp0VRXetkbphIlwSGqPsWtEofaYnfaWIbwwZcbTr1i2XUr8cDH2gdSFUCSHHP02KBWXpvz0PZl01sgfYEXb1Mxe0R9e/UYjDmUmc0B/f0jiuilKLbAgQLBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=UJDB89TV; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=eNDdgQA/; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="UJDB89TV";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="eNDdgQA/"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXd4U646652
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=L5P9
	pth53AeiU9Aso0fVLD2mVQiBr0GVZfhtL06tuN4=; b=UJDB89TVwt6uvHfyvH1K
	tToQt2DNqBGHFfZOHeO+Gv1VGPONEI9YpZcKSygjh7XIZ/YhQv2vbxpaaVJijAhm
	x0twoubcRRPHm5P7rcABxHMf5x2W3QoTC6flYjsSinfuawzb5THMTtufXf3HKTAP
	mce7MFEk5CU/QO7QZbpY9PdzY4ijdfftI8Z4Uh1Fnp61uZCMzMhV8MP/pjS1r7jw
	BhR1dIx3TWHFTGub5oQgbBlkgXba9BRBieZFw+qpCseKn4G0XA1dDKdgQyDXr7jD
	LuikjVq6zD/BdWIvRKCOAAQAfdQXPCuJlB4nFX3/K4L1nf0DZsbe3yadr7qEMs5W
	6g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp0qmgpwd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:36 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-936708f129aso395588685a.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334496; x=1789939296; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L5P9pth53AeiU9Aso0fVLD2mVQiBr0GVZfhtL06tuN4=;
        b=eNDdgQA/rVlIy3YCU1BeDI12gNxWfTIu6LIoWFLPMCCl+2lLneN5vkYTOCX36b1I2e
         H8aywG1Dm2lDj0M7iAspRVQNrrQ72LdhEJgSSwzQ2pv3ctp4WPBVW2RBxBOAl8LIWkrQ
         sG9GHkjmjj4lR9lpjWDgw5zMM13TUbno8TokdtsB+p2wpWt2LbL6bPfGJgIBa29CgrZx
         KHKRaH1HYgBVMdPtmdZUoydKtf3gevwsgeNxTpBFC1e17KCLNlSCgU2NMScTBttdmkao
         zdoHRPu5jHkX/cGM57dGwECSeiiGd0/Eo8KOAdb/qXT0cIh6jJzneMfI8S5LsVS5rQKC
         YeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334496; x=1789939296;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L5P9pth53AeiU9Aso0fVLD2mVQiBr0GVZfhtL06tuN4=;
        b=qbQu/7luKiEd+XqLFuaNFM/CM4Fpth7HooUvu2Sugv37yIljBBblJ8Yu6g8M02Jipk
         Hs8cuwQzdyNfrQZsZoBuUF5j9E4Ab5pq2YusDAEuwdUP6XR2TR4RmBcwAOs8WVpMNEoP
         7Xf4iC8luYymsFdJuyQ8McQL91lCZMnspdk8obwrDdyMXyPQIPWgu8vrCO6p80W0kxOK
         uEvFMP2RQuZlHBLBFX2HQC5JagW1TaN7AoV3ULaCXVdBClASu8ocKLct+n1cjD3wljai
         zJ9QHkbWTGjVhD0Bd+1awaGrHQkQXlr+y8aEOWjcxEFnaGj66SYWe5LP3YZFeuxAkcqa
         celA==
X-Gm-Message-State: AFuF++kycHQoq7UdnCFB1b3MURnxjUhH9Wjic99B4h3cPRBUchNjmX9v
	nup1mXx4wNqPjBByAxCmuro5cRbR2tKbwlVP3PEf3GsgNS38yrPiclCFDLIKhHx77dzjl3R6Xjg
	BjteCdDBWv2CIfV6fXhvVoqZZYD2HsDZAmwicgH4xtkImXoSUgrQGX8hX2ehI
X-Gm-Gg: AYBFou3uhO5TqJM1nUxoYimWAhgKt0uuwRx9uafg8ThKZblzaIXSKe7tZT3+Becep4+
	cS5lRyXbG1OSBOetITxtlhv9WRrwWkOgTKO+yX9gWJ3fhoNuZ5CtD0WGWae0wCt9Osa/QjfdpOy
	wGPU5Xa3kkto6F8xI8PufEJWdvrS5G64db8QXNI+YdhVHmQlhSdxyfbPOHx3Jru+AVZp+jKmP9V
	PlTzyD5c4JuGf3B3u4J5qXJG+D+/Q7f2OtnzLLo8GOaEdbmduoCVer7Xh7Oyu8RbB3Rv/jcP/nF
	cCue4KdEIUSr/UZ+t4fG/FZyiNBWFqFwmhr7+/X1uUwjbS1yx9WWxNrcbtjC4CiEWcDl+Kjchgh
	7VkpLomVXTa3eVpfUNerTZN4dRdr7XQieZbeUJrYpHTEMly4v9Csj3w==
X-Received: by 2002:a05:620a:468b:b0:930:9585:e08e with SMTP id af79cd13be357-939ea037950mr2081633085a.10.1789334496393;
        Sun, 13 Sep 2026 14:21:36 -0700 (PDT)
X-Received: by 2002:a05:620a:468b:b0:930:9585:e08e with SMTP id af79cd13be357-939ea037950mr2081629785a.10.1789334495883;
        Sun, 13 Sep 2026 14:21:35 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:22 -0400
Subject: [PATCH v2 10/16] btrfs: remove the free space cache trimming
 ranges
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-10-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=7181;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=f7QP8rjkTL/hFBjwJZZfAUG7xOyxTCYpKox4iSRIc30=;
 b=MAgnTbCS0pwIMf78vilctT03yYx45aNf1mhvlopyN1t8opGmaoCx4RLY43InsXG37uPYA05A+
 Iew0FURXcG9CtIUUMuuyj/w7rb9FsgdkPwzeVjQX/tOOTUUqLzsqP7o
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX2yaoCgRsfxu1
 gbhlgnozoXf7lxM2rv9R8jy3z34FqjAywYE8pCUujb23PibngQQikH9L39oYLkN1Fas8dm09k/b
 lLZg3uc6PjMTj2UF1EHKUiGnJchNl8qlkDmgs8kjL58JguHZ8aTA
X-Proofpoint-ORIG-GUID: Kq_rkAzaZKcy2Il4VYodVXNWDJHSSz2_
X-Authority-Analysis: v=2.4 cv=EJ6TQFZC c=1 sm=1 tr=0 ts=6aa713e1 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=qCNzSPQ7UVaF4CatvjwA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX+suiSuEMeeSu
 w02DwqIt1gVmGy3tRhXte14veWDp6zlSiYnBsjr8oeie3bSF9myCc9NVD45zVGYaMRrcTIffFZQ
 4rxs84kgBuoW2t0fLdNrK2gShFmup381u4aAqeKSzWoUwHyT49SiY89qWtROZZRy7zllP/uG075
 amZR6+SDgodAuvj7Ta+bErm7A/XOmLi+SLN5tQknx9HF17Zu4eliC91/kZJKMUHzj9iR9RtWjz6
 eFzyqZrWoE2XcRau1LGK/cYModbsS1+PcjC80szAyD1T+q71HqAFpeuO16+0fwHUUwh9AdRVhAA
 hSeika5VA71r3WWo3JC4205Wwzphlx3lIni79nkdGvAXGmsBJoUyG29nlBjgRCwCguOzTm62yD1
 m1DYrBiqG5emCAhMmsCNyjbdwDhoj0G3HUfIGhIZfyoxFORMO0FSwLmQt95l9wJQWyOdj8B7Nn8
 zUqjBui/BKV4w8mH21w==
X-Proofpoint-GUID: Kq_rkAzaZKcy2Il4VYodVXNWDJHSSz2_
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

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
index a36d0465510d..8a6d896b4108 100644
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
@@ -1699,8 +1693,6 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 	spin_lock_init(&ctl->tree_lock);
 	ctl->block_group = block_group;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
-	INIT_LIST_HEAD(&ctl->trimming_ranges);
-	mutex_init(&ctl->cache_writeout_mutex);
 
 	/*
 	 * we only want to have 32k of ram per block group for keeping
@@ -2396,12 +2388,10 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
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
@@ -2427,7 +2417,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		trim_state = BTRFS_TRIM_STATE_TRIMMED;
 	}
 
-	mutex_lock(&ctl->cache_writeout_mutex);
 	if (reserved_start < start)
 		__btrfs_add_free_space(block_group, reserved_start,
 				       start - reserved_start,
@@ -2436,8 +2425,6 @@ static int do_trimming(struct btrfs_block_group *block_group,
 		__btrfs_add_free_space(block_group, end, reserved_end - end,
 				       reserved_trim_state);
 	__btrfs_add_free_space(block_group, start, bytes, trim_state);
-	list_del(&trim_entry->list);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	if (!bg_ro) {
 		spin_lock(&space_info->lock);
@@ -2475,9 +2462,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 	const u64 max_discard_size = READ_ONCE(discard_ctl->max_discard_size);
 
 	while (start < end) {
-		struct btrfs_trim_range trim_entry;
-
-		mutex_lock(&ctl->cache_writeout_mutex);
 		spin_lock(&ctl->tree_lock);
 
 		if (ctl->free_space < minlen)
@@ -2508,7 +2492,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = entry->bytes;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 			unlink_free_space(ctl, entry, true);
@@ -2533,7 +2516,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 			bytes = min(extent_start + extent_bytes, end) - start;
 			if (bytes < minlen) {
 				spin_unlock(&ctl->tree_lock);
-				mutex_unlock(&ctl->cache_writeout_mutex);
 				goto next;
 			}
 
@@ -2542,14 +2524,9 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
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
@@ -2573,7 +2550,6 @@ static int trim_no_bitmap(struct btrfs_block_group *block_group,
 out_unlock:
 	block_group->discard_cursor = btrfs_block_group_end(block_group);
 	spin_unlock(&ctl->tree_lock);
-	mutex_unlock(&ctl->cache_writeout_mutex);
 
 	return ret;
 }
@@ -2684,16 +2660,13 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 
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
 
@@ -2709,7 +2682,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 		if (!entry || (async && minlen && start == offset &&
 			       btrfs_free_space_trimmed(entry))) {
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2735,7 +2707,6 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
 			else
 				entry->trim_state = BTRFS_TRIM_STATE_UNTRIMMED;
 			spin_unlock(&ctl->tree_lock);
-			mutex_unlock(&ctl->cache_writeout_mutex);
 			next_bitmap = true;
 			goto next;
 		}
@@ -2746,14 +2717,12 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
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
 
@@ -2773,13 +2742,9 @@ static int trim_bitmaps(struct btrfs_block_group *block_group,
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

