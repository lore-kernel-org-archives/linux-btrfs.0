Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FAA29E0E5
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830411; cv=none; b=Ttv9/lkxpJJ9VGv0ioTb/7mcfFOL7/QvBOihHVY9IKNly+Aj3WvIrBIdANTxQ+b6tqH2J4/cWtoca9LAuEAFIwmviarwctl+cf5MBzfZn3+MyNIsC4mHMzTvvdrgQyMFBDaUGX/HRXbvSs7kU2VMmmu+ZEaCBH9oVGim5ayBdKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830411; c=relaxed/simple;
	bh=7nh4biHdKafOppeHUfXQJVAnPGIK2T15pqeSqDobbTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a55dgVSt9RORN96DlMyCcVU9us2Rhv/uURTXaThgn7Vd+3UvYRQBWoL3SmdEaVrKYMjELqEU9mBCnT1qPUxmJHW5wUIltKvfU8jUa5MCTU89/Y5IcxoyEO1KTCueDVmgi+jlj9VWlomKClOV/o/FZs6HaOq8Bahpbf0DfCzeotI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=b5oAAz0G; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sP5nkJUH; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="b5oAAz0G";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sP5nkJUH"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880vaiS3580662
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3oj5
	ANPCnZj1InlzPWs8KGdUp1fdiscPMzbj0TS8iyw=; b=b5oAAz0GVDTRpz1lbHx2
	V2Pgr/Oyh7DLFCNhXx07ueoLJP72iXze9QzcH03JSfR/sR8CwTo3g07F/yEmpKmM
	ss6wEn1vdSjWbnn5N9kRMJuDDo3p9pwoopjm4USYYSUmQkz+wtKyM666g+F9vwXz
	LHhCucX95G3oO7ZPuYUlvDp8rI7SDIHFuhExqyh0sppwDvQOZnb5sFiq0rvizoxC
	fazuT0HLR2ALN/2xOE5zyaUxb+PZIQkdy44sEuIV7hrCapkUKgoCZG+nvZVUWuei
	OmT/1ZVxgbi9OYkqdSULfcDYBHwLO/czKYwds6N3EgU5Hk/4nwQw4mmO20zDMvs5
	0Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ghwvrbqha-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:19:58 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e98e74535so68061986d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830398; x=1789435198; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3oj5ANPCnZj1InlzPWs8KGdUp1fdiscPMzbj0TS8iyw=;
        b=sP5nkJUHhqkqV+WF8u3xTKEw0pfc6RPZk00xUlgTcHzZYqKjFWc+oLQ7cYyWiOQsJI
         QZNmhJN4gxqvI60lQQmMdjvGTLjY17jndIUi41KQc1tVwvb/+sFur6WXHHFQaT/6xYtA
         JRDsH/oRdYJKT1XiBo5oliMUJlbReFOcTpPmmlV3+RwMyPkFucPCEaDi3u2bA564zmjD
         fv+kGl1NosZdZ/7pwNoA4mw89ZTSxrAPQzOt4k4RsUH5eul7EnSdmy2gp5kZqAPwfiYo
         7172Aj3XqTfl5zQijCbf4r7BQJJZtQ4REHc8pAQqeep80UWgsvyUk3Hvhw+nNL+gFXB4
         FR6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830398; x=1789435198;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3oj5ANPCnZj1InlzPWs8KGdUp1fdiscPMzbj0TS8iyw=;
        b=Cbdes9LjG9n2wjCQFFpQjUdZwCDIOlUuVQFDqo945XqDNCgyNjoTqxl/ZMhP5/+Hib
         CH6EBuYUxlS25gQwmAWDu/7H8fBzYGnmA1NRSkDymG+wZlzxB1ZdvQJ3QmRvbN/8zb6A
         h52w/zHGl6lNERfVFknfJe9vY1xPRJxGFlDsNGWkHf6ryt8Y+0cUwfEnUbpPCXlsVpyW
         hialrEgsVoX+K8YxaqQKFG3heHYOhHL+S3RkO3gMbKE0G8hl/b8nRYC2zr+0cHxLG2AU
         zdGHP1tDbJbh51nR81MEGdS3s9Zj1DKrWBbZ7VOSkmb1ydR7+VMnCqNiI/vPgnXKlkO7
         pfog==
X-Gm-Message-State: AFuF++lM27Ay/eeAYHqQg9F5yHmcUiliMU3XGx+WPoYVZM7JfKrrdPbV
	MrAN8X3+kWAWEyPvfCyT1SXUUvni/Y1jnYA+21Xt6RpFKYKGiCOTJVwp4ioi2rpRpmNSOJxQ4SC
	eAVNKbpQiqgJPmf1l7/IKYSbrtnVNa5Tp/7T15zO7RDFQxMtFEIwPFsI4GPec
X-Gm-Gg: AYBFou2zHUaTdLMW4lr1ZW0G1RVZtw5lUtzNW6bM8bxDZlLHw8a1ZFh56TFdDdiMILY
	zZjBw0co/PUlnYyffnk7sLB+q9B2s/4vz5RG7pn8Jvb6941J8ILg6Nk9ZFUrDHxprFjeDlPiVid
	nMQV2e0alvg6FyiLGJDXwwJNRXuUHrISR9Jd+Ygu2dRH25bW52uF83uLnZCt5IWFAHBbEKPS/P9
	Zkbn8BQojW/jAQoyC8bQ0D+sO8w2AFhQnWiSTwy1aR80IdI/XLrjTCE1LHpXZX7vBWzm6iK3qmn
	QTCooYBvqd+DjXHd06gzQg9Bi+5vqJBQD/rioDr1rl2oCMYZ8ZLeQ0iL1RKS0toQXfjHp74UHMf
	IFybH93oxxv27w4ptSb193lPNHDEV5G9AUiwMv5FxoCFPjo1zPjg=
X-Received: by 2002:ad4:5dcd:0:b0:910:4080:dc4f with SMTP id 6a1803df08f44-9104080f964mr326648296d6.4.1788830397576;
        Mon, 07 Sep 2026 18:19:57 -0700 (PDT)
X-Received: by 2002:ad4:5dcd:0:b0:910:4080:dc4f with SMTP id 6a1803df08f44-9104080f964mr326647856d6.4.1788830397059;
        Mon, 07 Sep 2026 18:19:57 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:56 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:23 -0400
Subject: [PATCH 08/15] btrfs: remove the SPACE_CACHE mount option flag
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-8-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=8891;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7nh4biHdKafOppeHUfXQJVAnPGIK2T15pqeSqDobbTc=;
 b=qAkvAWnOheCP815pnhf9wcdUMFupSBg8pQwF8uwlnkQkLITNhLI5LBKdoJmi/F7e+kYJsGVwc
 aD4KeHYzaiKDEjhz0KhGrNBelOOWkmCkwHx5FwhdBS5rRvfNT/N3Ck5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: JhFwuCBhNuDt9mUkOjv4mR8fe86VsTUl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfXzxHY+4a5rIpw
 Vxijthf20nYPS+GTtjKvATOl0cbfHDKmcmioFidfJ4wiQ6axUpfga65jSvpBav+0CvMMI7y9gds
 RrJpTdupV1ZQokPr/PHt1WeMeAf9POXNjHnfXAhwSH5k3YNDWlr4DSeydjBCXod3BfHgkWk3yn1
 NIVIneyEZ2StqKTVFQox3+iI9kBhaPt3CFPEU4jzdvnTH//AEX4O/4gqPvgWnC2hwSmDBOgUgsy
 MgKkowcZQo90oosJyCdEnivdRBaTb16dipRr+n94ecUK2995M6W6CmyhNfQ1cEiQeRd7nSog6bs
 c0m6n0gs5np5/DJ9j0EoLtBt/0oC2xF3xkT+LWT6/PNIvcidqrCjB+OmqF1eqS+ONt6ATWO3dUS
 pCsmqq2qna/KSNb+Py2Lm/K/a+naXcqpwtHN5wuCpUIXTfYKk+NPPFS8q3XyHPYedjCzMUh0imu
 U5E7PZxTrjzwDMxxLUQ==
X-Authority-Analysis: v=2.4 cv=RP2D2Yi+ c=1 sm=1 tr=0 ts=6a9f62be cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=iLG6Hs8F1K9pulr5F7gA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: JhFwuCBhNuDt9mUkOjv4mR8fe86VsTUl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX71HalCKPK1/w
 wPnkv7kLp0hx1EDCf2Te1Wq0UCaht3Lyy1fSLBsuKqJvFo0rallq2NBJWCpz07HhpfNLq1fUIki
 BLEv3rfwGrClle5dCUpgIHm9vFyEX/B4lgGvs2YNtDA1LHJt+f9y
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0 impostorscore=10
 bulkscore=10 spamscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080011

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
index 4ce07657d2ab..99824a25057c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3067,7 +3067,6 @@ static int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 {
 	int ret;
-	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
 	bool rebuild_free_space_tree = false;
 
 	if (btrfs_test_opt(fs_info, CLEAR_CACHE) &&
@@ -3162,8 +3161,8 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
 		}
 	}
 
-	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info)) {
-		ret = btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
+	if (btrfs_free_space_cache_v1_active(fs_info)) {
+		ret = btrfs_set_free_space_cache_v1_active(fs_info, false);
 		if (ret)
 			return ret;
 	}
@@ -3279,20 +3278,6 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
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
index 441b315e8a98..79d0828c51c7 100644
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
index 1230da51fdfb..d2ff3b568eed 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1982,9 +1982,7 @@ static void update_super_roots(struct btrfs_fs_info *fs_info)
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
index 08a15465a087..c2100e6e267b 100644
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

