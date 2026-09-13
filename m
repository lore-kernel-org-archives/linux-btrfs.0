Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213136BCED
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334499; cv=none; b=kVxB9K0c8XDYiWeLlHsoVNKBN/U7bUik0I9YzNXsWmzor0ZMxPX8TvwTAQ/AkFKYj/KDa2BMk26uQrYFBmUg/y1Z3hXG0NrhA7EZLDMCUkvdnkd5KfxSk1Nz+SdZvYi8wA6J8aH5asvPQeQzwLnLdM4C+1DiYlyRNKJ+OxH1Ch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334499; c=relaxed/simple;
	bh=7i0VfcvZQmUCFhFA/RzvqDGIG2nYJzqXUsp52XcxgEQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fxj6nUfqVd+Oyi8T1jGawofAfB2OZtWXncaB91jKvTNu8BJqu4KFYFxzYfDA85ydC4Zz9453V68+WtFGcFkPvLdB4peivMPrhueXDNnZqOUKty971LqGPnvKs3N22/R7Whxo7q6JHHapqQqPVazEuBUfOgrr1ML8coNUfU8zab0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=PTZ6vMsP; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fH5l5Ger; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="PTZ6vMsP";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fH5l5Ger"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKY8LB648416
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Gn9n
	qykr0SdSJPm6wutmUZGM7NDQjVOE6T87Ys4ezfc=; b=PTZ6vMsPFiG68hPI5ZqK
	qooEJTJCdIbjCrK6HTUNJRNcabEzqCP5WqdTpGGcemQ+3vtLml6jepdyy9/eokP8
	XcL4lmuN4/MvV1rOz+j3yZZ1RMIVwoDzp8aIRRlZ34Mmrv6zGdgWzCECljmBptMv
	A7S1mz8d91NkqUYiWUlV6b/jWBy7z+VY9hrtRt4GoHQaZqkrKk0f8LUGOZuZwOTV
	JpeBhEdblKfwc8uSmz5a1+to9KgliLRWCL+QGqCPjNmJkgnoaJ3DVFo9H4y5JQ8c
	NZBBbPdyzid4mZG2JN7Jt/ZZBiI5avgVmbtHpCdkFyFW08s/aggOXvDTHu6MEUAR
	Bg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp0qmgpw7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:34 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9104215fbdbso75614176d6.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334494; x=1789939294; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gn9nqykr0SdSJPm6wutmUZGM7NDQjVOE6T87Ys4ezfc=;
        b=fH5l5Gerei9LID6sARTpcTvfQDWwe1P9JrlBL4FrfaNzVJxg1BJbt39XgGRDw96V7M
         h0dZ9Pe1fHAFcHLEnDO79egya8rf7LBN4B0NBUMcnZJTqQH3ukUeqt5EUAvxyKPxlIKd
         rHJ48jHzXftY8eF15ig+F71HBTpiJMqiMVL8FHes4I7OWl6Zl9XZWou253qCs+IJcyS8
         coQxUbWfDm3X5EAD/md4305veNAGTC3OpoTdl9CK2IrnkQpr9kezgNWQEIWJYKjz6bnD
         F9FmYq1YQYpVxZ2zdf0c3owzqyXQ6bqZ6Hzfb/RmrkRDWX0TxXodpwymDF+Tb4Ajhbe2
         JTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334494; x=1789939294;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gn9nqykr0SdSJPm6wutmUZGM7NDQjVOE6T87Ys4ezfc=;
        b=RZq/alkY89R63oJLMrCWwPl0WsJ2z1akLENzF6Ugr6pT1b7KP1LuASMc6gBJ9Pbulz
         vZgJhTptbGuszSlHD9fuJDIc/JeyqwRAFqkSygbE+rhc6GHWGGJroLBDkDe8COxOSTlI
         yX3EqHpnHWkNSgc9ecNdwBFJB2DXuCzEV/tEd0P4i3nfDg3pFcbHveKrIJYNxlXTTlZm
         0BqndxcnK3WDKfNtXO/pjLCv2UEmqQt0numHaBuc0251En9SQ1LycWhxJV1O0fV6K9gt
         coZHLxzGU/hmtay23FELHmXBXkPF4utoRo4yDJkL1gBoTi5ZEx6DYcKkn3OWLoEtwwiP
         uaVA==
X-Gm-Message-State: AFuF++ncYETXrUMlzEE6zGAcuCmwlIpxZh1xn6obXfaRv7m8Dq5AH6UA
	0DoqVcoSJjP8kwL9EBOPaTDhJbAMy2SSMGAoKuB+oAUiATOW85aNcmc7DxYrLGkKaZ8kRUPWJtU
	9+iBf4pXVXQsBORM6qPMgKfCHqSe5aXopnZZMTjpTGDGB+XiWk6W4zpprgDUu
X-Gm-Gg: AYBFou346fTVLH1TciEX4DXDEG3mMm4ys19Aj7KfYpHisv5o7tnFZR+dK3BnzUyXEck
	os14kKjnfDU1NYZKaIHY8el6UmyZO+qV4BOFULymD8sCqOXvdgg/uQtaAznDUbU7gxTIpBpt5am
	4qHlHBfJGSjyGFyZvkztv/DuGN3VgiopFasnPrAYa8GDki+CGVio3aJdtNAf7VG+YuptQUqePRu
	UOSLHDqHNxKgC5gBPfSMCn1fRWirBl7MWkZh/1Gm2hkP/PWvRe9uSduEgACZ3h2sgGwgHLJbSOb
	AIP2MYinJ6tE1ZOmpqPToFUxZ2SnwNHwYQttQF7FbC6hpvuo2CNsraqz9l8sA1UyE69Q6nNsT6S
	Y9BTn1DRlZWp3RKzlLZiYM6ZIEKhSMvb+kHVVbsfHeQ3lBMJ7lJeIVw==
X-Received: by 2002:a05:6214:5989:b0:90e:98b2:f594 with SMTP id 6a1803df08f44-9121daa7fc9mr148447976d6.17.1789334494308;
        Sun, 13 Sep 2026 14:21:34 -0700 (PDT)
X-Received: by 2002:a05:6214:5989:b0:90e:98b2:f594 with SMTP id 6a1803df08f44-9121daa7fc9mr148447796d6.17.1789334493817;
        Sun, 13 Sep 2026 14:21:33 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:33 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:20 -0400
Subject: [PATCH v2 08/16] btrfs: remove the SPACE_CACHE mount option flag
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-8-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=8891;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7i0VfcvZQmUCFhFA/RzvqDGIG2nYJzqXUsp52XcxgEQ=;
 b=V8WLEMGXxSyT054qn7V2D2sYeybpWrBQ8VXD89O2kh8m4lEtxLr+GO/CrMJE6QdNWbkePPJ4C
 593K8OzG+dRCDM3ERJKI9m4XE3O5eNPYYsrqvGg1yquvexTzjvcM25x
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX/hS/nDhy4xWx
 lkufrmoDY/DKGjTOLyljh/UHUKN4RqISiBmI3e077eu/ezorKG5U5IBHwl2jSh9h7LWISdieorv
 y2rDP7MJvCyfXuauvgmEvWpeA3+gbOJAbcVM+8acReWsx//8x0cE
X-Proofpoint-ORIG-GUID: CFIsaMvYn-RIWWEZf5MHoZWOjAKKuCce
X-Authority-Analysis: v=2.4 cv=EJ6TQFZC c=1 sm=1 tr=0 ts=6aa713df cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=iLG6Hs8F1K9pulr5F7gA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX/zTXN3cAlzdr
 6IaDSBRl1yauIrN+gPvqasgUzYkbpOhAnL6aXhjoy43ro3jJzSw2bpnS3FXIhDiOiJy494V3dNu
 60Jsyps4bWVoo1HonylumYFOlGQul6cVvmEwTWuZ2+4k+H7zF4kyXqYxghGXu99sSqsX8ZpIGfN
 t4y2C4rXpj3JKVDMBr+6h4Mou5mAbP2bwj/aU5GZT8fHrjcwefjv4Rri6PBKwAG9wIdhuQKD9oF
 zaoqot6pOi1ujAtiXuzZS70dFH92PVj3zzn1ckO1RmyK38cw03T8Ngdj1SmzOlm86aHNzcejrjk
 YKkmYAaRfhVgIwHhNNYYMsD2mMdnXrBf/1fN+J3NoFTk6/3Z1FLr7J/d84qE+ZuaJ8Jar5NXylr
 ijqtuw2etHTmCkQXEqaOmy0pScMmHSvLl24K4yyqgO3zq8MWkHx7A1WFrCtD+A0D3TNKk3dF8ho
 9bQ6RhhjD+f9ei2fw0g==
X-Proofpoint-GUID: CFIsaMvYn-RIWWEZf5MHoZWOjAKKuCce
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 malwarescore=0 phishscore=0 clxscore=1015
 impostorscore=10 adultscore=0 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

Nothing sets BTRFS_MOUNT_SPACE_CACHE anymore, so every test of it is
false. Remove the flag, the checks rejecting the v1 cache on zoned
filesystems and for sector sizes other than the page size, and the
deprecation warning. Show a read-only filesystem that still has an old
cache as nospace_cache, since that's what's in effect. space_cache and
space_cache=v1 keep falling back to no space cache with a warning.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/disk-io.c     | 19 ++-----------------
 fs/btrfs/fs.h          |  1 -
 fs/btrfs/super.c       | 31 ++-----------------------------
 fs/btrfs/transaction.c |  4 +---
 fs/btrfs/zoned.c       |  9 ---------
 5 files changed, 5 insertions(+), 59 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 881d95080709..2ac0e7c2f1e4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3054,7 +3054,6 @@ static int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 {
 	int ret;
-	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
 	bool rebuild_free_space_tree = false;
 
 	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
@@ -3149,8 +3148,8 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		}
 	}
 
-	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info)) {
-		ret = btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
+	if (btrfs_free_space_cache_v1_active(fs_info)) {
+		ret = btrfs_set_free_space_cache_v1_active(fs_info, false);
 		if (ret)
 			return ret;
 	}
@@ -3266,20 +3265,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 		return -EINVAL;
 	}
 
-	/*
-	 * Subpage/bs > ps runtime limitation on v1 cache.
-	 *
-	 * V1 space cache still has some hard coded PAGE_SIZE usage, while
-	 * we're already defaulting to v2 cache, no need to bother v1 as it's
-	 * going to be deprecated anyway.
-	 */
-	if (fs_info->sectorsize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
-		btrfs_warn(fs_info,
-	"v1 space cache is not supported for page size %lu with sectorsize %u",
-			   PAGE_SIZE, fs_info->sectorsize);
-		return -EINVAL;
-	}
-
 	/* This can be called by remount, we need to protect the super block. */
 	spin_lock(&fs_info->super_lock);
 	btrfs_set_super_incompat_flags(disk_super, incompat);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 96cc8c50af82..ad4b2cbf64b7 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -259,7 +259,6 @@ enum {
 	BTRFS_MOUNT_NOSSD			= (1ULL << 9),
 	BTRFS_MOUNT_DISCARD_SYNC		= (1ULL << 10),
 	BTRFS_MOUNT_FORCE_COMPRESS		= (1ULL << 11),
-	BTRFS_MOUNT_SPACE_CACHE			= (1ULL << 12),
 	BTRFS_MOUNT_CLEAR_CACHE			= (1ULL << 13),
 	BTRFS_MOUNT_USER_SUBVOL_RM_ALLOWED	= (1ULL << 14),
 	BTRFS_MOUNT_ENOSPC_DEBUG		= (1ULL << 15),
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b44b16970a62..6ddb7b352166 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -515,7 +515,6 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_warn(NULL,
 			"v1 space cache is deprecated, falling back to no space cache");
 		btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
-		btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
 		btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
 		break;
 	case Opt_space_cache_version:
@@ -524,11 +523,9 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_warn(NULL,
 			"v1 space cache is deprecated, falling back to no space cache");
 			btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
-			btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
 			btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
 			break;
 		case Opt_space_cache_v2:
-			btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
 			btrfs_set_opt(ctx->mount_opt, FREE_SPACE_TREE);
 			break;
 		default:
@@ -705,13 +702,6 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
 	if (btrfs_check_mountopts_zoned(info, mount_opt))
 		ret = false;
 
-	if (!test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state)) {
-		if (btrfs_raw_test_opt(*mount_opt, SPACE_CACHE)) {
-			btrfs_warn(info,
-"space cache v1 is being deprecated and will be removed in a future release, please use -o space_cache=v2");
-		}
-	}
-
 	return ret;
 }
 
@@ -729,14 +719,6 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
  */
 void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 {
-	if (fs_info->sectorsize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
-		btrfs_info(fs_info,
-			   "forcing free space tree for sector size %u with page size %lu",
-			   fs_info->sectorsize, PAGE_SIZE);
-		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-	}
-
 	/*
 	 * At this point our mount options are populated, so we only mess with
 	 * these settings if we don't have any settings already.
@@ -751,9 +733,6 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 		return;
 	}
 
-	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		return;
-
 	if (btrfs_test_opt(fs_info, NOSPACECACHE))
 		return;
 
@@ -1107,9 +1086,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",discard=async");
 	if (!(info->sb->s_flags & SB_POSIXACL))
 		seq_puts(seq, ",noacl");
-	if (btrfs_free_space_cache_v1_active(info))
-		seq_puts(seq, ",space_cache");
-	else if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
+	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE))
 		seq_puts(seq, ",space_cache=v2");
 	else
 		seq_puts(seq, ",nospace_cache");
@@ -1441,7 +1418,6 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 	btrfs_info_if_set(info, old, DISCARD_SYNC, "turning on sync discard");
 	btrfs_info_if_set(info, old, DISCARD_ASYNC, "turning on async discard");
 	btrfs_info_if_set(info, old, FREE_SPACE_TREE, "enabling free space tree");
-	btrfs_info_if_set(info, old, SPACE_CACHE, "enabling disk space caching");
 	btrfs_info_if_set(info, old, CLEAR_CACHE, "force clearing of disk cache");
 	btrfs_info_if_set(info, old, AUTO_DEFRAG, "enabling auto defrag");
 	btrfs_info_if_set(info, old, FRAGMENT_DATA, "fragmenting data");
@@ -1459,7 +1435,6 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");
 	btrfs_info_if_unset(info, old, NOBARRIER, "turning on barriers");
 	btrfs_info_if_unset(info, old, NOTREELOG, "enabling tree log");
-	btrfs_info_if_unset(info, old, SPACE_CACHE, "disabling disk space caching");
 	btrfs_info_if_unset(info, old, FREE_SPACE_TREE, "disabling free space tree");
 	btrfs_info_if_unset(info, old, AUTO_DEFRAG, "disabling auto defrag");
 	btrfs_info_if_unset(info, old, COMPRESS, "use no compression");
@@ -1524,10 +1499,8 @@ static int btrfs_reconfigure(struct fs_context *fc)
 		btrfs_warn(fs_info,
 		"remount supports changing free space tree only from RO to RW");
 		/* Make sure free space cache options match the state on disk. */
-		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
 			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		}
 	}
 
 	ret = 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e3ab0f705cb1..e49d83d3148f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1983,9 +1983,7 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
 	super->root = root_item->bytenr;
 	super->generation = root_item->generation;
 	super->root_level = root_item->level;
-	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		super->cache_generation = root_item->generation;
-	else if (test_bit(BTRFS_FS_CLEANUP_SPACE_CACHE_V1, &fs_info->flags))
+	if (test_bit(BTRFS_FS_CLEANUP_SPACE_CACHE_V1, &fs_info->flags))
 		super->cache_generation = 0;
 	if (test_bit(BTRFS_FS_UPDATE_UUID_TREE_GEN, &fs_info->flags))
 		super->uuid_tree_generation = root_item->generation;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9cc2c9c1a606..c916053aefad 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -804,15 +804,6 @@ int btrfs_check_mountopts_zoned(const struct btrfs_fs_info *info,
 	if (!btrfs_is_zoned(info))
 		return 0;
 
-	/*
-	 * Space cache writing is not COWed. Disable that to avoid write errors
-	 * in sequential zones.
-	 */
-	if (btrfs_raw_test_opt(*mount_opt, SPACE_CACHE)) {
-		btrfs_err(info, "zoned: space cache v1 is not supported");
-		return -EINVAL;
-	}
-
 	if (btrfs_raw_test_opt(*mount_opt, NODATACOW)) {
 		btrfs_err(info, "zoned: NODATACOW not supported");
 		return -EINVAL;

-- 
2.39.5

