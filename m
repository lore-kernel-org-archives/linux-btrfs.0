Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CFF4B8DE2
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822534; cv=none; b=PiAwEKGwQJqDiN5Fbqj47qiTGnWy+fPChkEcBe2YQ1gfTUgrKvvkOrneU/S52MUagvRoFa6q0QA2WexXobHqM0ALOJHutd3p8/TTR1cu+gi1HLcbUGgkaFRVHMM2eUtLnUQ7jn+5HML2Atmq+vwr6U8wRhZDg1hry9IHEUp0lx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822534; c=relaxed/simple;
	bh=+aFKY6ev53ekguncmgsPFKkABu2t4CJWoJbkmGiHMzY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gL1RYx5r0+afNk0KtKoYi2IjBmQdXZ3wCtebVbtKbtZ98zrUMLcqMh4zmsmbFe7eZech8/UT88kyqxfRvBqip6YBOZykwQaHaw6h+dRgc0w9mi9VG8cRxicvh/MPpFpOFD32aNpzyfQUgYu/6uYeaNhTHhkP3TBPWwEtZnwW1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Gbf7E0i0; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=DY5qPwiX; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Gbf7E0i0";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="DY5qPwiX"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CEgWBw1408491
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=R/pH
	C67rxwTgdlm0VMocfsqxLigRDQk5uu+4HACv1XE=; b=Gbf7E0i0uidoppNM4VxH
	VAE347opdrtRO0Q8vjGzof1bvF7IgzTsR5ucsFLzDSOhkrKF+MfggwZS068HGdiV
	t5pJwLFzMecxLx5VgOvU+KKAi7CsqVhuXFjIPrJLkCV3rR6+TPggBQGyOoUPl4y2
	Word/fae6QuEjVeCtTCBjIqdu5FhtX0+oIk8z9qR8ZN/oNN42891fgSOaDY2/HfW
	DLezVjZECWAJMEeGpQPYobhHyHno0rPi2sJvvonGgBBlGLIR15c7rXfVgeE+fLzX
	r5vlhJwRY2GVWWZr0EgkEFiOB7FNY+7UDVJmZ49wn8xxJYWAOlaSA5ic/Ev9lZ2s
	hw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4h91hc974m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:50 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9196b477c4cso55475386d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822529; x=1792427329; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/pHC67rxwTgdlm0VMocfsqxLigRDQk5uu+4HACv1XE=;
        b=DY5qPwiXklbZuqssNWxrmgv29bmCE9zkkD522N/aiUAQQkvxy9d+wgLbMTTAOKAcqM
         9ZmMDzUblMhDOLT5k54M4ykYj361AvxcbMnZMmicwugiRqZlowSA1OSnxcvvPIdC7SqG
         5fQKrwO1Du0DfiLjZHaYb4BWGvbj9rythDcerHz5KgAFxjrj/wzlidYHUrmhHnZ/o+Hy
         SKVK4OXb7K1hwdc0GockgpZB/XkFALZyi98xyqS8Vf2OJ2R3eGsIMx739yDYQ9S475XS
         d7LgUP4nN+eySvC6RjAKGZqKRt7QllbMaC7dnL7GEhH5aKMxMhVquVSIyFJrSgOJvLB1
         ALCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822529; x=1792427329;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R/pHC67rxwTgdlm0VMocfsqxLigRDQk5uu+4HACv1XE=;
        b=PeTp/DzxdsbornxA8jth0lGaat/4IWTdb7jb03vbDxjVrr0ZusOihv7WBWfUORLqJg
         2sGiKBuzlGG7fiv/VF5CcU6RPkWNYi8bnOZDw1D6lupVWw7B/iWNMRn3muOU1anyO66P
         fQ8zab6akvqmUvcZHbCXjMD79Wt7iW5m8CgYfDFnK63U/mlM6KDiDbPXxp936T3Po9X0
         0LsOkynU/WowWYUo6gJNyu9i4+86syLyNMQOr/gRXQwAW60WbBp418/hpwzZ/LfC8etT
         ttAa9XanQGuB/XZxQ/EEDarGjKmjxqJBu0vsiG7rEhWYPSkrx9efvfSbuYPUuekQWpXB
         4arQ==
X-Gm-Message-State: AFq9FYKxrQOn3jUacW/l2Ookk+Fb94kwxtugt9oR96EMjDP8AZb7U5RT
	/A9o7Sw5rzcHr4gZB2fMhsdRml2Za/ZpvnU+2SwND6AVwts4hTWWvvrWBfRbLvINB55bwdEp/Dl
	ZQZePEsH0F6FbEAdFwuZ4jMY+pl9EltFFnxu+378rrbDV7smtyVrSWdTsugP0XMB28NtA
X-Gm-Gg: AYBFou3CxAXgfxFqgvxp3P+rcJ8WTKhSrJ/lnIV5WNEttRR9/Hztb8LBzq7L7Y7IdV6
	AuAgnourNAA4TFd589QZ5aSnTy7jofmHwhspZu724ybcfjDKCZRVKQgxTebE0XPgLgHQaGM+nER
	iDOvhU8xf3e1OAIxgEJ/HXH3zN2/i28bwI8l92p+H60fqoM4CMZO74TK1lPXct9PDIOWXuZ2Sni
	ojPa575bXibmoZybucLLBkHk8b95weZypz2AkX/rChPPrM+YaOsoY3+C+7+DmQ1p7djVmiL2JAz
	d8MOuJNArhfCK49bu/OC3DE5On4QAZkmaotuPqevCoPg35Ivl4ZVdE0RLBpQZ2VkErYMfXbAJK4
	YWtz0IaT87SytKFOTZno/2mfIovKuuIY4s76LiOhs9XWhH0I=
X-Received: by 2002:ad4:5cc7:0:b0:91b:8a4d:6bd4 with SMTP id 6a1803df08f44-91b8a4d6ee9mr33939176d6.10.1791822529014;
        Mon, 12 Oct 2026 09:28:49 -0700 (PDT)
X-Received: by 2002:ad4:5cc7:0:b0:91b:8a4d:6bd4 with SMTP id 6a1803df08f44-91b8a4d6ee9mr33938566d6.10.1791822528426;
        Mon, 12 Oct 2026 09:28:48 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:47 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:22 -0400
Subject: [PATCH v4 10/18] btrfs: remove the SPACE_CACHE mount option flag
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-10-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=8955;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=+aFKY6ev53ekguncmgsPFKkABu2t4CJWoJbkmGiHMzY=;
 b=S9HWI7VFttRqurvNMNY9+7XdOfbRnAkPd26zLxwGrV7RdwtLLAbnMy8ymH7uzp0j8/5uL8Knw
 QKL+ZTOMipQCb1Yf3YrVYECE0Kv4tevPN3vxcxV+NLnzIEvm8ThJ1rP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: VCJqglB6M-D772scbELKEBog93nZ80S2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX5mtEt3YaTfcs
 eyySV6Yl+OZIusEmlVm3Kh/C0UTclBdY6zrwBzpilDTjjJLxG+uMrgc71aiqTrgFMsZkLsfXR/C
 lSJCviNfhUNwEKAHq7Hpc15xe9XWYxlz3S/pVFrV0GBV86P/N0eJ
X-Authority-Analysis: v=2.4 cv=Wue+otfv c=1 sm=1 tr=0 ts=6acd0ac2 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=iLG6Hs8F1K9pulr5F7gA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: VCJqglB6M-D772scbELKEBog93nZ80S2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXwS9jCJ1YtKly
 UEgEYr35yn9XITYIqXI6y/4PHszRJ5wdv2m/LqkWfV5VKA2Sa7fUnEUSQU9ttEIT28mrE186+Au
 xX2CUkVhuGlxcpsjlMJoU29YV7tHufEjj1EiA38TNjU0/HcYuMxE02nVreY/k4MBUzk8hXRKKyp
 d76tEpdmDKfLD64aaDLywaTHEYlwdXmd1G4P3zf4E+RnH76GZu1zWgc1of7gd3s3CDnJWrrWW0X
 MynATuGP7YD2G7YXaK/GfBrTUqtOQLvStggGwdgARzejGakF0ETV2ZHDDomJwGcogRO48Ec8iqO
 RO9UaDA1BIxzwEMRsuGz3Vugi7KawDXi7DhoFlzGxNkgoes4hC71K+a+yv6srSp4ts69uwAyHyL
 aAJGATF1CYxxCtTDm9hMKRjecacisOYuaf2l6pXdR4or8I2gVeAqaN4uot7V1mHZKyb+rwuyohc
 l+hEQimZVa10Umx3Zgw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=10 priorityscore=1501 lowpriorityscore=10 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

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
index 05ce3c7996fc..760d6c5b6b19 100644
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
index 871747ea5c14..0aa2c5777c96 100644
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

