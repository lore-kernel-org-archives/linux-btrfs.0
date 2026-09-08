Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CF02DCBE3
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830408; cv=none; b=tXWbhWrD83GUmGSo/hX31oc2M7f2ocRzNP/o+20oTK4LlqbGISaNoKAcPbXNfytEc3+s9RtDesNDdY5EnpsxDMAxbVeKIwXFzfcA/aJprlzpwTthWoDfHA7kwXmtDBMK9fk3f3vMzPGRs3qhMiKGhgW85idfiWw4LF5MB2tunH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830408; c=relaxed/simple;
	bh=lp6N7P6uRAwF4k80VrSyckftlj/cB8cKUNVuGaugFXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X+yJeZi9VY/Nsqs7OjWhjjASIoc4BZ/ObHmzktro3ubGlABKYWDibKyqe3Ek/pmHTcbSdzuYHwfPZQ9bxVNgmO0z+yF+23JW+083lMzuynToEYCfLJSp0SJhXlACaR/3kmOeVtWL04ewWYLhmrvIeBolN/Z3GQIjORXSM8wwvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GGFNQ8el; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=zr3hgV89; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GGFNQ8el";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="zr3hgV89"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uaNx3867258
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=vZNh
	osrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=; b=GGFNQ8elMGqtaso+GdcV
	MSlVH9DB7bUvhPZQM1gfOKOEsz1GyCGtQlkBpMmLcLXTitWeTCaXjOwn4vwknp5f
	lWOF94QgsdzigPrYDDOu8jOK6AqgYyj0Hw0Mk6CYK/NpdrAiO/xXnyT63Pm3lnhH
	hbj1368ToS7sIjv7ycqdRHZGbmNYTTVRTfnRsuJenl2/gs3Ot2wDH3sE18lZNw9r
	n9UO/L9ePPaT2WLG5fJ3YyWWt3+Fzh3QKfYlNX1g4h8SxjBfjD6qO3RRwAErMEyI
	qnvHrafHslKMJAOe365xcRsUHLRBvu05OfJbeGJHsm2MC5Nwpart8+hZjLYBjDBz
	wQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4y3gys9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:19:51 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-53000c06184so103472601cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830391; x=1789435191; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZNhosrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=;
        b=zr3hgV89CkdmLVlqco3AR7TavtMprbUU6g6P1v6RTj/AB5MrIGBJSzr8nEfeEnSaew
         sRw/ME6QZmd1ImOSznXi0jJZ8B8tjGVy97kIBhkiufPrY8qgx1QUEXsfXNpOWBJHYcj/
         j3kZwTaIi7l41vRxeMg0pLGbngBTkh4fRYFU7PTsMtzrFYj4Nrv0uY6xp13EI+YA9qT9
         quUtpgFes2bXEi1S6Ou9LCwwe5E1NzaQg8x0qDPlPHvO3RhfyIUtXTLP5BnDUz+fLYK6
         qxYAMTfScBBIBlNbuHz7hWonioxq+dJbzVptud22jER3bkg6f4knXUbxKlIgpRVG8hxJ
         2WHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830391; x=1789435191;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZNhosrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=;
        b=mmEkw1lVMMLsRljE+A7fiuNADXYueKqYulDW4J/g9uvSzaIVey27u2fzo7U0+eSLPm
         syUSdoqUWVNfbTqZBZk/AePn2aQ8nDRsY/OZQ8EZBhn4FJRXdnXVlYAgz552auzXWRL1
         sTNLl0mkPNd0KgPk8jKc3Kdor0Nm49D+TW4xI0vzJqyKv+DYuPDzy4x7crrfk6+awksD
         yy8oNcfB0MxNLmNrUU0V3Y1jK+XPyNWgJ/BA/GWNxiJhx8KFGElJo4syhleclDTBBZK4
         bsrQVmLHY0J526N81CnmJLxo9YhiO08dKxZif2zykva/go1/BTgHOBcydb5BiQtbqbDU
         c4Zw==
X-Gm-Message-State: AFuF++kIfoEzrRGUuc//t0DE8LWrnMX7NVTD6LeKUua1JsaIoE3Nx4Ay
	sLEp1CH7e9XFXPUgfX7v1UN4wxKlW3InYHZicXiUonbFP2JOYLX2rSZ6slm3PcOxVSVFnTtRBDZ
	yxQWxya+aW/uFJlMxzc6OVUkG/7J9xIsncsnvNLq1QtQeASek2J0ArT/xtdis
X-Gm-Gg: AYBFou3yxH2o2W60rt4NIYR1jqAaOhMrnVDFgKSG6yxHQte4tWyJ7HH7WNQj8ei5wtz
	/9yNZNdM+KEOA3TuzKqO6Q+Cqp4nATuseFDag3Xj55oqCv9n8WTCqmoWgrk/3yQ7yQyb2WMjDi3
	4u3VYNnMQxmN0oLEEgBEgwYr6KmSbrzgXiXF8izwf5NU0BSCNEeRXSlt9NzhAtr5k4/aw+7UbVH
	RpANDhSbZZ/6p2febIyUkuHiA3APvLMNct8tAs5Q/mmOfBTRQE+5URunazR5g3xv4IIEOn2i4bI
	0lX/bch2QDAsx0+Ly8Cx+TofnM0q2Nwt6gp4QMldP90vEGtOdN4f+LytvFBB3k/vLd12ar5dEvi
	XEHoWlh/0y0yhQ07Dcm+jPEInlPKd2qxAz4hrXIqMiC/d461/XE4=
X-Received: by 2002:a05:622a:5c05:b0:52d:8257:666d with SMTP id d75a77b69052e-5305483acf5mr345357091cf.11.1788830390581;
        Mon, 07 Sep 2026 18:19:50 -0700 (PDT)
X-Received: by 2002:a05:622a:5c05:b0:52d:8257:666d with SMTP id d75a77b69052e-5305483acf5mr345356401cf.11.1788830390069;
        Mon, 07 Sep 2026 18:19:50 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:49 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:16 -0400
Subject: [PATCH 01/15] btrfs: stop enabling the v1 space cache from the
 on-disk state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-1-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=3265;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=lp6N7P6uRAwF4k80VrSyckftlj/cB8cKUNVuGaugFXs=;
 b=IMvkXE5GdPNas7sHyPPQwTAp/61WcaYW99DKn1n6QvUNWjB9tm3SWAY2+9Qii4LHZ5x/oBG96
 ilUy6ok7bUnC6YvNAOF9aNND90b/CoBmBaLGvxMlkFvDQFRzOPmzxDg
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: 32yLNI5Rbj7NyRBhL7i8QJclcYq_G0bA
X-Authority-Analysis: v=2.4 cv=T/68ifKQ c=1 sm=1 tr=0 ts=6a9f62b7 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=6xji9QrKO1GPOBtlZsEA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX3THDZf4J3T/N
 jvSsWAszmag6hY0uzgpLOlWOOe4XUFyGle4KRQLZbfJbQxaNWSICM6R3PvojWXJ+eTK5UbqJ2xT
 5j6KopINiI2Cb/LA2BXjB2ctc1MwUyR4ZVd9sT9odd6pADi2IhBE
X-Proofpoint-GUID: 32yLNI5Rbj7NyRBhL7i8QJclcYq_G0bA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfX6yt0HySMQe6Z
 OjV75FLtqDpfOkVPGUubIRHiuoPemWyLudGmjb6IaLRK4ZhiZ34vlGI0oxOl9bUFX3q9VcUom/f
 khr4OKHgITzALkVvLhY1hCyAVpATAGVNgC6LAb0H8adGsca8E6fjdlHh08XYa/+Cav9Ba+trBNQ
 1T4polbJA7o8UE0EJ+iH9sGbPCcvZLQlxMhtRBCq3LNLOEgTYGDAxx2n7l2ex5VxJZshicMqtbq
 ZL8hJfvraAFiTIpzFU3ING/y8W4V5EPpjJEmcZVK2RIVTlIbBCMb8o8LMQwD/xJRlvMYc/yYsaN
 qK94NxYD0LGwdSp9pTUhiaO2Yyj74C54ZKKuDgsG1UvJc3lMI76WAY/kIuL2+6Nv1Fg8aV9FGQh
 3WstMw5ALE/agiirK+XOwMDoHZx82ULZipldTfIsMBwpKdvKztCkpXOX3FVApQFLufK1yl3MRvm
 Pxsolr/zEIbXHvjHTIA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=10 priorityscore=1501 adultscore=0 impostorscore=10
 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080011

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

The cleanup is now unconditional, and the first read-write mount fails
if it fails, as it did with -o nospace_cache. This also lets an old
filesystem mount without options when the page size is larger than the
sector size, which btrfs_check_features() rejected once SPACE_CACHE was
set from the superblock.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/super.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..77443ded6db3 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -759,12 +759,12 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 
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
@@ -1264,8 +1264,6 @@ static inline void btrfs_remount_begin(struct btrfs_fs_info *fs_info,
 static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
 					 unsigned long long old_opts)
 {
-	const bool cache_opt = btrfs_test_opt(fs_info, SPACE_CACHE);
-
 	/*
 	 * We need to cleanup all defraggable inodes if the autodefragment is
 	 * close or the filesystem is read only.
@@ -1282,10 +1280,6 @@ static inline void btrfs_remount_cleanup(struct btrfs_fs_info *fs_info,
 	else if (btrfs_raw_test_opt(old_opts, DISCARD_ASYNC) &&
 		 !btrfs_test_opt(fs_info, DISCARD_ASYNC))
 		btrfs_discard_cleanup(fs_info);
-
-	/* If we toggled space cache */
-	if (cache_opt != btrfs_free_space_cache_v1_active(fs_info))
-		btrfs_set_free_space_cache_v1_active(fs_info, cache_opt);
 }
 
 static int btrfs_remount_rw(struct btrfs_fs_info *fs_info)
@@ -1535,10 +1529,6 @@ static int btrfs_reconfigure(struct fs_context *fc)
 			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
 			btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
 		}
-		if (btrfs_free_space_cache_v1_active(fs_info)) {
-			btrfs_clear_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-			btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
-		}
 	}
 
 	ret = 0;

-- 
2.39.5

