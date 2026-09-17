Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3553C2785
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617644; cv=none; b=ecskCKQJdb35vD1qU2cVzloKLr3rMZJgioV3nRb/J7s7reA5pfq1va7R+ggYRP8NmpqRp6XKeOIzyvqD7/XnMflEMxGd4CF2KvHbgjrQclqmlhk6WQrpbSA/vZm06/OVy8K2uY4B9A4m+AZqX58dCt7hookC/iFHOl2A5P/x9d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617644; c=relaxed/simple;
	bh=OtZkkOA+g2bKFcJKKjfPsmrKC//tMdxiksjKSConr3A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XVbsmdWpFxOXu9RLB+TWCEy3q+2Cq3AkMACvawZ+KG1VH1Yfba3g93lpYQ5xorFHwpL03zTzMOxYjUBoUavYtkbf3kt0LmluYFNG3EkF0sJApL9FTU+H/mAvYYTcVKrKVESinORfkenXSEpnzmuPv+j0ZRA1WLA6OdsiwhUBrk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ptjdq83M; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=FULdvy3a; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ptjdq83M";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="FULdvy3a"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H40Oq63680672
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=IBYG
	O6c0J62o2PqiRsQrkj8EYLmNxxruC2umkrM2quM=; b=ptjdq83MPOaeXDtVaxD1
	rfzwiLkXaEQ1Aia6k9WxbfWlNnVYkLTlV/8d/vxE6To2JyRFNFRrQJ9v28QTvNxq
	f3QNcojIWkdlOHRyNxLLV5Pke+VRMi8jyYHzUJhPzViGhoRRI+VRTxJCz/EnlhU2
	+DWiigx15XFiN8IOy/7wCCS6PU/7OPVNI/6/dNzb77ANPI4QpxVZc14uok7Q7Ppi
	tzPRQHuFHiKx+RscFVetbc2y7WY3GXil6uTJmDyqx4Ayim72hpfKDiJrusycpR1S
	RG0K0FOOUNzyqa38AjzMTxutotXFFVUZAFfXL8xfhsWEK8JDPjMHAc0ChAPLWfp5
	Kw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr3swhcyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:37 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91043af01d9so8883986d6.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617636; x=1790222436; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IBYGO6c0J62o2PqiRsQrkj8EYLmNxxruC2umkrM2quM=;
        b=FULdvy3ajGckpe8dZ6V1hLp5l158aRLqK6k37W3b0Oj32V9iEq3OoVyp2w7iqBnzi6
         cYkVb2l6LGXFcDvpRiBdUEx7p9et0iyObTmaTlnM/ZEiNXuNxdFuIiWsYE28ClFyWcBC
         hKDNUGCEVFHlVx0eI2r/i1C/G1iIaAbejhrvwHjxVviPfeG63OEyCcrsae8qvCplnfHa
         wQxWp8sggiaib1wqfffcYsNgXJ8fsHq3gqxVmp4AswJ2apkjqpYepjZxOdsIWT/io0bv
         vHI1Lv63gRIR6tIR2PJldLQ/bfBFFyZVocMlbxYtFPpdF1di9h3Xngt20Q19jEyuycbs
         WMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617636; x=1790222436;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IBYGO6c0J62o2PqiRsQrkj8EYLmNxxruC2umkrM2quM=;
        b=tjeCHDou8LRsqcfS3hysfh4k2rSFbmvFLUYQq3OXVzxFOZnqxzTXc/aJZLCIsTtVx/
         821kYUpVHUgIYU2PHRcLKZzkVurpypezG9cmxsFphdKpLQh5UF4zHtnrTYJebOPfmszi
         T2oKBsVrEo3cjD5QPkwbe9DBwJ+opWWo+tmE4WYDN33vui1DK8oFdX2vX/zIq+crYPCs
         /RHolJ325yl5brOwDOgHfpw3pO2/pVYOT3aBZzEb2SXUiSvyMeOjt45IYyU4NLc6er+i
         lZRZmdzOPUKVE3+bSouWXhs5Y8/wi4FmZd6pUB3GkaC9PyN8MazCp0N90JUDKlIm9gno
         qoqA==
X-Gm-Message-State: AFuF++ljyCLjeodPFwSdYHXt/j92+al+wHCKfvTQAFaJ0UEPeaotmt5S
	YKUsaYokAv4yCG5HgOIvClu49yhNBmKaLOdXj1tlHoPTWNjWP/X2C9M1dftEoQ9bVcxZ20n+VKP
	Fmmkk/QCCkgBxl00xuj9dsaaz7IAsxxkbipmat2MqzlAbb+kAlaJbAIr3JPtG
X-Gm-Gg: AYBFou2B7G9SkwjexqUsX7OP7BqA6quy2crgqitZnTyAo4NeSfXxKXhTwuTZLiMWaR2
	t8p8v+kC91jW/nLSBE1hF/pwCrrjg5NF7/42d2/brPZzlmZPaoWTtNfdRQzsomFv7y/oXGnno7/
	6DborgHZvIdpP/z3owNoTDgI5uotinf5yxlKQKPGVKGz4iyJjKvpKkErBhukVU6krYlzdVyQXC2
	qbhD8yrFZS8ljO8qFTkobUAy5ejW+95aUVlY2dBKM1ETj5idAbKMOL8y88wNfXxuHkIFsokU6+L
	Wl/LV/Jxbij/a80HJ+oXOWoZPz3qNqFkKgevGJ6RK+GSTn3qrzjREFBq2t2q4mrW8WT+Ung7nN5
	8++Bg0/YlBWXyt+V6WRESO0zxlBBb4mz7qMAfG4xrp7roOw==
X-Received: by 2002:a05:6214:1cc3:b0:910:4c56:76d8 with SMTP id 6a1803df08f44-9123d724036mr90279516d6.1.1789617636214;
        Wed, 16 Sep 2026 21:00:36 -0700 (PDT)
X-Received: by 2002:a05:6214:1cc3:b0:910:4c56:76d8 with SMTP id 6a1803df08f44-9123d724036mr90279056d6.1.1789617635749;
        Wed, 16 Sep 2026 21:00:35 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:05 -0400
Subject: [PATCH v3 09/17] btrfs: remove the SPACE_CACHE mount option flag
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-9-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=8891;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=OtZkkOA+g2bKFcJKKjfPsmrKC//tMdxiksjKSConr3A=;
 b=wzc099PGBmjR7Li4dcPYn2CvtAu+5GFJoqdOZIT5GXtFsdS0Au17sp8LcIjb+wwTSYnBH2Yz5
 O4OtB+7LxJoC3yczr474Nft2Ji11xkLuxJBUafggzmpSwys4Fm8L4/J
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: aWZLNk8ywodU64aaROEwXz0KSltsvtxW
X-Proofpoint-ORIG-GUID: aWZLNk8ywodU64aaROEwXz0KSltsvtxW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX8i2LgWwSq2YQ
 /gK52apJDfzxyuH5LAdIwyIzlm+9dBzUiYCmrakJRDj3tRsP12eNCz0KVnV8uK3ZCdpEhnANilJ
 E+iAs8yFmgtr6QNzIgOFXtb/33jcw6EcK0ZtEDHFMaB/EhfA2jV2
X-Authority-Analysis: v=2.4 cv=ac30Dhot c=1 sm=1 tr=0 ts=6aab65e5 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=iLG6Hs8F1K9pulr5F7gA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX0Gaf1RQ/ZT/N
 D29r+SNS+uoyvx5VoOt/Cpy2egDN2FxsfDNUb5fWcLwOPn9ZTjQYNdkseZZttUzs7/ojvBxR35J
 90wcx+tBmcbB3i4cHn2bBkgjAnxR0pl2eFfLgYPlySzLpcAsKjbBIfaV7qB1UOEEs6g/ZTyxWFJ
 NlXGPkAkm+9EeUEcvJEdcbFPEGjOfV5sniRvv6KISvIkqQyZamW6dr4FmwH42etoEBn3coWQFig
 J1Vsy0C6m/QlcZUjfTEjDTJ186u8Enm4yJsnFJdHgPEFSKUgr6iYSFZlSh+JK9NyVjTkveO5d5R
 I4aQdpQnzGh7zGjxZhwgDyEGNWzcJ7ApHm2ZoOCxriMrGkkUFzfhm/5q4ON0LyAF5CFV3V0lhwZ
 TMOMotYEqEbuwuSgcSqw5/5qFubyroqNfNbnhAbsgp8F3swHcmNP8S8ZIo3BbxDui2ynScfmPsT
 vtsSXzXWDnH+uFl6Aiw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 clxscore=1015 adultscore=0
 lowpriorityscore=10 phishscore=0 impostorscore=10 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

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
index 6a7f33ac87f2..0ea984d641e0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1984,9 +1984,7 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
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

