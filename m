Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1EF380FD5
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075426; cv=none; b=exZ4k6I9CACw0KUjTypqgAZUgrwae+32k8Fxp8tiHVu1Ew3sGauTybJsEkqbRIUCOlTSpiUFF/Dw/XyoVQg0GaAfJh0VYV4C8YjIofurD1cKsMSHe0HyEMn3NY2E17AExUWclEBw4HwU13bd7/TFjX64K86K95UBTnzVQfh9vMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075426; c=relaxed/simple;
	bh=8FWf0cIIv4qm0XDzRvagI1KPaP3JNBd8FRknq/GLLvU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZK6Jxap2e2FX0FnXpdNyPwbMKPPis58ietdlqFaBo7QMyIQWjdz1fCwUhxHxTgeylePGixRP135anL9TdVbjpN3b+xPnIvyp6iXUsN/f/Ld3WPC3XAiNnWlf+aE+KczHSy372y+aGoXUxLZ/LYFGL1JG8EqF1fyFvUaumIx1Wzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Ny2H/VS8; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=vQ9HFaYJ; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Ny2H/VS8";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="vQ9HFaYJ"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY8ua1879350
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ws+K
	xW7/AJm6EgTmahG+84vZE3w70Vz9+BhXYTY0zGU=; b=Ny2H/VS8P1EUecOzh55e
	acNx5zwWP3vLKxocI6FJfWGsGPY3WNkQGicnOplfQSz1lV7SII+OqAGzydekXmym
	2OuDw1sj6pFAhP+1fqUQcswxnj02l2BgBOs7jEz/WU02AQ5/6yFvpR9x+aBgrh7z
	MvhI8VRF76Jki83CL3PUPlZAPL6TPlWFuQxFRk2NC3JPx64NOUaA/An6hvr8/lKX
	XK15nNGZY+cg2GQ6zV1FXWDJ2nuecxQBSZlB32d6p7Ixv5PpvAGRQieMFeCAC27i
	ktBmiMG6WLItOsUq+P4XpSMYgIWTfD+LyrT4bMg0c5D7dVA9CBitIuoeQtked/Dn
	2A==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hayffh2br-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:43 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9104eedb5b0so52579886d6.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075422; x=1792680222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ws+KxW7/AJm6EgTmahG+84vZE3w70Vz9+BhXYTY0zGU=;
        b=vQ9HFaYJWQ6wMavoxvVxy9Dp7JCNli7QvcxOZOYDhoIEbs7FkD/hrh/r8/RypuiBH7
         DG9syMNv3gI4gcoLCZyAQLgbbz3QtKUNhNCWlJHTtOdbTaP/etDEVEXffgWhWEQ6Yg9B
         QlfzUw2us/f16jjw5jH5LL92MA2gtIi7G1JLm44cwVZsIr0gJ7HQm0lJJgtFCpyYOISN
         Q2jgYqmB02zsq4ryULOeFQ9uqx62Zh1GvMeEfagjE22yfm7lQe+EH1+GAccZNutQSodH
         gDRJ5Hbu80Ch4I9i4aFtIRCs0yYxCD+NVpvZ+gahXPJLoC/y7ShEStZ7Ld8oNndMTdRi
         TQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075422; x=1792680222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ws+KxW7/AJm6EgTmahG+84vZE3w70Vz9+BhXYTY0zGU=;
        b=vb/1z5U3xOe1Ui/giu9XlVBgQ+46hdvZh648Tb1u8PDZar1Ag63/Tngvm4Edr5SqRn
         FuDJsh4icryx2kj+rXmVT6rTH7vMF5bfBq7GA7BA3TeUVOIsHk3qrUW+0wgijI82Jctv
         Jpv60+Gj3tX5seHYze/niacgDnqo/vrIenc7+TRXLYLmARHhsFR2HmOrDmQ0qLl6/4kK
         oDVy8UNstLU0JxjreDCFu2lKPcrPjaS44WZX1WPB4IGc4wEGSRjH5t992/0+wlPsSiYf
         +7WEj6RAznb+v2HCyoEFuc0gQfATfz9/MWTOE70iSpEySL9bvdnquSmjZGQncmalmYjb
         zXBg==
X-Gm-Message-State: AFq9FYJ0JAj0zcr0k6X+Sh4Myko70IIY5gsf2BCd/na4zLLczOe9TgSI
	It8JGjkwE/wvlbQeD1wSDKMeL0H6n/ap7JTvs/j7VneBFvUr1CvQMyfxP4kcFayb+XS9foBVaRh
	vJeaHMWApuAIp5dzsmH/Cjsz03KPa7kbVrouFoBMwr6B2/nkmciydYzFPKgYnhzsaSf/A
X-Gm-Gg: AYBFou1fdDS2ILpPf3fX35p13f882Q4pYWgJsGvTzJs4HEne4DewEkQQnuMFEaIGvf3
	d6IaYqEMz7ZM6oFHWWN5BxSW6JesGXE4yisUEXei6C+MMlF/Nol0QjzsvPf9ua7k3pmiGvY1Q+o
	XJg2mz9T5OSkro6wXoxUeTUgelFTiK5Rhwzh0zdSgqxdQDJK0Uq4M77KdoxCwNZ+d1itzOmGM/h
	TYWMdmDV+D4o9N6BSyK2DhmEJDapFSWengi4uqKc+XZbzIcrdbWVJyF6i32KUVzASJauIaobhuV
	LpnOvUle1Ak5GCgNzF5VF9hCZJGLwj/fR94mmkmTdXcxjOnpiXkFhH01SUEQs85jSF7pjUdvdvJ
	/ufLl2FuggCsXYDPduT85jqukWrHiK1RCDJ8q3afA3Eqr
X-Received: by 2002:ad4:5c83:0:b0:912:517b:974f with SMTP id 6a1803df08f44-91b5567ee18mr351753266d6.41.1792075422558;
        Thu, 15 Oct 2026 07:43:42 -0700 (PDT)
X-Received: by 2002:ad4:5c83:0:b0:912:517b:974f with SMTP id 6a1803df08f44-91b5567ee18mr351752706d6.41.1792075421871;
        Thu, 15 Oct 2026 07:43:41 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:24 -0400
Subject: [PATCH v5 11/19] btrfs: remove the SPACE_CACHE mount option flag
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-11-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=8955;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=8FWf0cIIv4qm0XDzRvagI1KPaP3JNBd8FRknq/GLLvU=;
 b=c3zfX0nF+I5e2zjkS8gURd81vg41pHXBTG19vSvLDsm30DjCQl6PLreEk4Bf61Gd2q1qP8zsE
 1KB70hvdAMrAcRUk2wkiWlde/uiDzuFPmAQXuyCOiznYXpn/jRgHPak
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXy7FM3yc1B9Je
 1AsO4XlcWJBPhdhnPSVK628bdI3yePu0vRU9/7g59QDR9sM6KAOgOgW3hImZWeatv/1s2LH9BGO
 Ffc8iHBcdwRknG0z0Wb54C7ILsSKauBs6iJ10vJtG+Ho3UkB4PO9
X-Authority-Analysis: v=2.4 cv=eJ2GH3p1 c=1 sm=1 tr=0 ts=6ad0e69f cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=iLG6Hs8F1K9pulr5F7gA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6kMwhCuIJopV
 eNS0lQxE8X7/gQexS0QkX5b2sG3F9ubm1mn79bde8YWUgQJIWsBEpCKWYpl7gwOozyhtOX2hOPu
 eeCvbXyTA9Cz5YjbIpoXPtGt1dx122byCCE/a7QkkgvXn4rO9juTFVxBB2oB2Nuq832i5dO+LzC
 yPRmtKh7ZapWpgLW/omx85y4OGUGTaV264t2Vw0mfRxKlz075b9U6NcSdoS572OGvsjWbY++laX
 IdGtZNDeUSe1tQsqX2E6bT6H+uNEXEhF3LZOWU2emACgXtug01ilqGXuuB0wWqOx5n7enyF0uUQ
 KY7RDRnmNUZ2RKMTJr+udqmwXN3H0+aYvrghRjejb/9TOeZEaO18M9eEJVU+qi4DJoD0OVA90Yg
 uqf39/xlDqATT7k7NEGgh6MTZfwW3vVBYxh7DZevLk3LUUlW51NcRqcFhJ8OEjVMkXhRaAUT/GG
 Uq6gM8THMgBVEaL//Xw==
X-Proofpoint-ORIG-GUID: TN29hg6zBSinDPz42gNKrRAc9N939YrH
X-Proofpoint-GUID: TN29hg6zBSinDPz42gNKrRAc9N939YrH
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 suspectscore=0 impostorscore=10
 phishscore=0 adultscore=0 bulkscore=10 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Nothing sets BTRFS_MOUNT_SPACE_CACHE anymore, so every test of it is
false. Remove the flag, the checks rejecting the v1 cache on zoned
filesystems and for sector sizes other than the page size, and the
deprecation warning. Show a read-only filesystem that still has an old
cache as nospace_cache, since that's what's in effect. space_cache and
space_cache=v1 keep falling back to no space cache with a warning.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/disk-io.c     | 19 ++-----------------
 fs/btrfs/fs.h          |  1 -
 fs/btrfs/super.c       | 33 +++------------------------------
 fs/btrfs/transaction.c |  4 +---
 fs/btrfs/zoned.c       |  9 ---------
 5 files changed, 6 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 82b3b4579880..23a17b829d98 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3057,7 +3057,6 @@ static int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 {
 	int ret;
-	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
 	bool rebuild_free_space_tree = false;
 
 	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
@@ -3152,8 +3151,8 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		}
 	}
 
-	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info)) {
-		ret = btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
+	if (btrfs_free_space_cache_v1_active(fs_info)) {
+		ret = btrfs_set_free_space_cache_v1_active(fs_info, false);
 		if (ret)
 			return ret;
 	}
@@ -3269,20 +3268,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
index f1bb6c56c76c..2dd167c32d61 100644
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
index 2b99c6400f92..b424cc836bd4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -524,7 +524,6 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_warn(NULL,
 			"v1 space cache is deprecated, falling back to no space cache");
 		btrfs_set_opt(ctx->mount_opt, NOSPACECACHE);
-		btrfs_clear_opt(ctx->mount_opt, SPACE_CACHE);
 		btrfs_clear_opt(ctx->mount_opt, FREE_SPACE_TREE);
 		break;
 	case Opt_space_cache_version:
@@ -533,11 +532,9 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
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
@@ -723,13 +720,6 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
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
 
@@ -747,14 +737,6 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
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
@@ -769,9 +751,6 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 		return;
 	}
 
-	if (btrfs_test_opt(fs_info, SPACE_CACHE))
-		return;
-
 	if (btrfs_test_opt(fs_info, NOSPACECACHE))
 		return;
 
@@ -1128,9 +1107,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
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
@@ -1464,7 +1441,6 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 	btrfs_info_if_set(info, old, DISCARD_SYNC, "turning on sync discard");
 	btrfs_info_if_set(info, old, DISCARD_ASYNC, "turning on async discard");
 	btrfs_info_if_set(info, old, FREE_SPACE_TREE, "enabling free space tree");
-	btrfs_info_if_set(info, old, SPACE_CACHE, "enabling disk space caching");
 	btrfs_info_if_set(info, old, CLEAR_CACHE, "force clearing of disk cache");
 	btrfs_info_if_set(info, old, AUTO_DEFRAG, "enabling auto defrag");
 	btrfs_info_if_set(info, old, FRAGMENT_DATA, "fragmenting data");
@@ -1482,7 +1458,6 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");
 	btrfs_info_if_unset(info, old, NOBARRIER, "turning on barriers");
 	btrfs_info_if_unset(info, old, NOTREELOG, "enabling tree log");
-	btrfs_info_if_unset(info, old, SPACE_CACHE, "disabling disk space caching");
 	btrfs_info_if_unset(info, old, FREE_SPACE_TREE, "disabling free space tree");
 	btrfs_info_if_unset(info, old, AUTO_DEFRAG, "disabling auto defrag");
 	btrfs_info_if_unset(info, old, COMPRESS, "use no compression");
@@ -1547,12 +1522,10 @@ static int btrfs_reconfigure(struct fs_context *fc)
 		btrfs_warn(fs_info,
 		"remount supports changing free space tree only from RO to RW");
 		/* Make sure free space cache options match the state on disk. */
-		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
+		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
 			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		} else {
+		else
 			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-		}
 	}
 
 	ret = 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3d7bc667eb03..93bc829881d1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2030,9 +2030,7 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
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
index 9f562cc34e38..1cda88332284 100644
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

