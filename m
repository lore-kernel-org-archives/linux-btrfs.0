Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581FA4ABBC6
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822522; cv=none; b=ami90yTxqPaA+ZcsvIN+TQysfw8EBsQyvdTTTrll+bCq97zafxWgxHOzSAuqo4H38jNaOBx5OIJkjGfQysNfZj8VLko/EqaKMsnkGRjYFEOCq162JTkgro67OiCqG+mGn5kwSSQW2KR7GyGaHyB5haABdUckcWg6gnHSmk6NgMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822522; c=relaxed/simple;
	bh=rWestsCiIX2Fj/4B+8qcDwLwe776nNegF/NodMo6NVU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WMy5AzdQ15Sa94+mwjh9LCjCcXuJqlCwTQ6BXhydccIWyYcMONcdJSSqHixWm6uL+d2Rnn9kxVuMZ0TEyW4RhQBxmJH9oTv6XqovAVVSzXxr27RspAMVmBo4hI1hk5eWH+EZI54ujmICW9tREKggtBB7MKotHheZCOlGiwjwEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ohsZ952a; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Eybuitd0; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ohsZ952a";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Eybuitd0"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CF4nBq2696002
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=EzWB
	AyDpEL0Dg87J5ARNV2uIZfnZ63fg1n5Pv1AXuZM=; b=ohsZ952aqmtOgUYlbJQn
	yr2OOP/xO+0FikiyDLD2d0vx47uJii/Fn3Ruy3cCaxGwSIA4HautGCJLK0m8S48O
	SPg8Lyt1wY2Nyp9lSdCmCOrCzdjHmduFZOZBfgk/NL6nGqJFhqxRwm09nVMX5NMk
	JCHDUJ2GCn58tNLwTojx00XWCoxlXjCCGfBs9k8gy3vjxrvIK8agIt/R8ltvI/fc
	kzG5txb5WuG4enV/yJkz3gSONbFPqFSAeHeCo4VKBLH879VTJCJ7WXY54zdvFjmR
	J4VZk1ZKHfYZmcL39d64PYr9Qsk5ZG631U1a3aMJNyST3QVBVwqpryv9rAKB/5zT
	qg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h91vd91mx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:39 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91b92acedd9so11217016d6.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822518; x=1792427318; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EzWBAyDpEL0Dg87J5ARNV2uIZfnZ63fg1n5Pv1AXuZM=;
        b=Eybuitd0Tl/siApPCeX4oEVYUJ/RRPuf6+3DURZc5ZZIq0QnLRzMFhy64ImuIEASyx
         vNRZ2pudyAD0vvNB+EkOqg0f5sEdnFO5MNg2N5QJR8Exv5QwrCMg7uzGnOdAS7FU0odR
         d2GdNU6tp+tx10c1TC9aoZkW+Ttd9bz3jzIicZqh5FJN+FuExA1N6Jp4SWV6KvhkzRqJ
         XRR0236037I60xb8nvavxInoCVAxNgSwd1dh2bRQvve70DqT41HTpgUSYS/EIDHUAbPo
         LGPlVdWiuegEIkq8TUCkb/8g8ApUK6dvfhgyAGj5plgO/N2OS3DvqFUr/7/iiiiHilRz
         z0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822518; x=1792427318;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EzWBAyDpEL0Dg87J5ARNV2uIZfnZ63fg1n5Pv1AXuZM=;
        b=pEawwS2U5sehntb8KIypz+gBEjqKGa1hemyI8JsgvUgZlxx6fPUzHzverkBbtEmt0Q
         t6v9WaUg16A0ZQsXyUdLwtszRfO8hqcvt9ZTQDwfraqq1tl7ZBZgN/pOCQmngR2rE4S/
         n+2Ne3nQVoiSlMk16war5QWPHPEHn/lzOU1va7AoatKzptSxvtNj+t1Lq6KGeSvLoXMa
         W5cb/cHdb0dsswwLqA5YCgkJtqTTNjWxMamPEKNyfwgLa18ZKaFczJZCXBseW7XRec4q
         O3b98y/XGs7XFVS0YyeZ+kV31Z9hOrHUCODA1EB7akAdYBKdn49cKyR3U2YKsn7QvYDO
         ajGw==
X-Gm-Message-State: AFq9FYINYHTnZbzZG0HneAK+fLkDWMzsRa7arx84GjxdOZNdVdEuD/mm
	ZlVy0ZOltR+ZaT0zv9tBecmdMs6cNycGlL0syifo98MtjQyNgy1Lly3KiPC96+xXxsrL5lH0F+r
	6+H0NC+mTU/RlQfPahRc+tXvD6at/DDpTlHBrQWilss9rkKCVyGzPsgdaf4Lp
X-Gm-Gg: AYBFou1P6wLLJDT9x9qiDxxP2VnU5wxm8VgTD/WELyeha20XJ29E25X9vG1dbY4kzs5
	1M6T3lSGnL8/bFWxuYkQ0xxdESOEzdzc1iqJfn6QA1Wj4MNvzsVQ55SE8vR63McNKrgddJoWy7U
	Yp1O+MOH2xP9UIXuzmuNmteQXDP7E8cNnGDKJMWp+me6ZjBq9+3fA+jEsr+RM7GnX/pgmHBDDgg
	JcYOqzP9fbx5lYRZT+TulEM3Kr/oF1im7p9f96Cvb2+mnO0cnTpiN4Rsynaw+5m3Hp8SLuRBMa5
	z7UIech+MaFZtq7TltQP+qGo/yFuZozGBb4PbeFNqIaSKdeKsvdD/r1tKVcxZeFSYDdKt1t+obv
	bVM1FlFopyrr6gzatHfk2rG1/LXeidXjpX+WvuDckY9MYpcg=
X-Received: by 2002:ad4:5e85:0:b0:91b:5004:2414 with SMTP id 6a1803df08f44-91b55505fe6mr183651126d6.25.1791822518466;
        Mon, 12 Oct 2026 09:28:38 -0700 (PDT)
X-Received: by 2002:ad4:5e85:0:b0:91b:5004:2414 with SMTP id 6a1803df08f44-91b55505fe6mr183650846d6.25.1791822517980;
        Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:14 -0400
Subject: [PATCH v4 02/18] btrfs: stop enabling the v1 space cache from the
 on-disk state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-2-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=3785;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rWestsCiIX2Fj/4B+8qcDwLwe776nNegF/NodMo6NVU=;
 b=Q5rhu/9UhKDakXOz4EBcStc2hlTqAYbqLWIr5+J18JebJiUigqq4jJTObd2KRG+A5W9ASVgyM
 2W1pyPX7G/3BcPmwYgBwWYvVWha5HWwa/TFwf0459cLzt1pJUnFvcXv
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX6LyJSRvJJ11v
 PuW+9wloVaYKLryKxRHbaiFj5+EgDaZfMKEsz4hdIUgMWg11AAuqCz2O/UoYu+6N/K0KBalV6Bc
 x0pW7JUSQhBMm8rUu43oXWEnNGyZsvJv1ap+ULs0ygtOYTZPrQWN
X-Proofpoint-ORIG-GUID: cyXB_f2lRCQmRR61SkBWUmzcvaIT5w3W
X-Proofpoint-GUID: cyXB_f2lRCQmRR61SkBWUmzcvaIT5w3W
X-Authority-Analysis: v=2.4 cv=QqnLTlyd c=1 sm=1 tr=0 ts=6acd0ab7 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=6xji9QrKO1GPOBtlZsEA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX4aMirwLqLhvZ
 L7t/gv7Cv75ii6F3jz+o5AF4eap3RExBe42mSN60mdU4GvusdZdoMRHB0maYlM10CF6tiGPIYoa
 M0jU57rG8NVAH3zAIJRweocGwPZs1h9PcrA3POoPE7R68ByOVhlxpJohAHQrMWUZf33Ak6rMQ5k
 E2oYHAENo1pNpcxttcrJMa8SIYXVnuAsjRI7AZwR+migavX30Kvzfd+k4M5SXJQ4bAeOsPOfFCh
 YWX7XMySFNzLGxu3z0EfJGimSendlVsTklnGgeQqW3ICSHvDzfK3tiDijjfnfN8zh5CUm0Ns1j7
 s/n5nFBrDr9Ilqyaprt6xxXXg8dTF5hSYdxFDZJFmCQU4z8bqpqdOYn1wDWvjpdgjkLQ4zvwVKb
 o5K2Wl7T/q7YSU9oajnljSpscfq/nxAx3ITX9RwMYUo4vSfcHbfCC7yUZIfV8auxAFhbiIw56fx
 VZgyLrVkTum0Z4reB6Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=10 impostorscore=10 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 malwarescore=0 lowpriorityscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
options can no longer request the v1 space cache, but a filesystem with
an active v1 cache and no free space tree still enables it from
cache_generation, and remount does the same. Drop both, so SPACE_CACHE
can never be set.

btrfs_start_pre_rw_mount() then sees the on-disk cache as active but
unwanted and cleans it up, as -o nospace_cache does today. That covers
the read-only to read-write remount as well, so drop the toggle in
btrfs_remount_cleanup(), which would otherwise start a transaction on
remounts of a read-only filesystem with an old cache.

When a remount that isn't read-only to read-write asks to change the
free space tree, btrfs_reconfigure() warns and keeps the on-disk state,
but the fixup that resets the options only ran for a filesystem with a
free space tree or an active v1 cache. On one with neither, a requested
FREE_SPACE_TREE stayed set and the next read-write remount created the
tree. Clear it whenever the tree is not on disk, which also covers a v1
filesystem once its cache has been cleaned up.

The cleanup is now unconditional, and the first read-write mount fails
if it fails, as it did with -o nospace_cache. This also lets an old
filesystem mount without options when the page size is larger than the
sector size, which btrfs_check_features() rejected once SPACE_CACHE was
set from the superblock.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/super.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d01409ed382..1818b947c528 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -777,12 +777,12 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 
 	/*
 	 * At this point we don't have explicit options set by the user, set
-	 * them ourselves based on the state of the file system.
+	 * them ourselves based on the state of the file system. An existing
+	 * v1 space cache is no longer used and gets cleaned up once the
+	 * filesystem is mounted read-write.
 	 */
 	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
 		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-	else if (btrfs_free_space_cache_v1_active(fs_info))
-		btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
 }
 
 static void set_device_specific_options(struct btrfs_fs_info *fs_info)
@@ -1285,8 +1285,6 @@ static inline void btrfs_remount_begin(struct btrfs_fs_info *fs_info,
 static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
 					 unsigned long long old_opts)
 {
-	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
-
 	/*
 	 * We need to cleanup all defraggable inodes if the autodefragment is
 	 * close or the filesystem is read only.
@@ -1303,10 +1301,6 @@ static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
 	else if (btrfs_raw_test_opt(old_opts, DISCARD_ASYNC) &&
 		 !btrfs_test_opt(fs_info, DISCARD_ASYNC))
 		btrfs_discard_cleanup(fs_info);
-
-	/* If we toggled space cache */
-	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info))
-		btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
 }
 
 static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
@@ -1557,10 +1551,8 @@ static int btrfs_reconfigure(struct fs_context *fc)
 		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
 			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
 			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		}
-		if (btrfs_free_space_cache_v1_active(fs_info)) {
+		} else {
 			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-			btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
 		}
 	}
 

-- 
2.39.5

