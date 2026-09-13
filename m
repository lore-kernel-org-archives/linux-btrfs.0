Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD57369D61
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334490; cv=none; b=r/pP9LrKm56aquim4GBwPxMiiGviEGal9TnYjxEzQBCCVwwz5DJ+0lnVdEqW/DONy020hmkbggAGixwN88VUAL4xi/9h0XLXUAbRHhDPmiKApF3YEUqoR3X4Y3AjMUvg9frOzNQftb0vfpcKm6vLlLeFJzpSjTwLsfXfumVgl2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334490; c=relaxed/simple;
	bh=lp6N7P6uRAwF4k80VrSyckftlj/cB8cKUNVuGaugFXs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LZC5XuBcpIyzffV06041/Ku8uKIZe7ZFhfbqOzZBprrO5b3sSCI2lY3Ukr6ucrMzTD94BpiDUKMk1t/vwbnCixi+ZZC1anvZGZMtve8SXa7ByKo7FScCvYsT9pOVsLofQkqJtlVBgDq39qjLkiYEGwa8/TIo7DedtUl36wRbYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=sdeBoYgV; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=quFEc8eo; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="sdeBoYgV";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="quFEc8eo"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKvJf0599690
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=vZNh
	osrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=; b=sdeBoYgVRpwIulIJuJvY
	P60SK33ZvUxJ9ki2fZ6T8Q2iNHQHbcd6Y1updPL48/VhagTpJHqE0/dsQit08Che
	YJwMdufjYHpCnlWo8wmzPo1VREl30dfi5If3iHupWAi9HPOLPW4urbNLr4gIU/Ze
	PctX7Xx3XRpy9GF4yCSdid4RMSPgauHWMfSIqCI4MocSBvOERdq+ZDodqPbOCPnq
	l9Jde5zPNthuZzBJmx2D0bnDJcd2qZxlcjVin2M1byLmVeW4d4lz2WaUpp/f3N9W
	4+FaZTcbTcsEK8i+6Hq2cvW1tBipcMixb8ng/mXUa1mixBuosqwIexuqvComuBsX
	9Q==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp3ah83ff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:27 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91054f537f9so69885666d6.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334487; x=1789939287; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZNhosrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=;
        b=quFEc8eo+Tk/wE3d6xMf24uHWn1H6pdgZ1xyMt/lOqxuUXso/Rbd4w7tFaFn3Avegl
         gwqhR9RjVgFT3e3fbLwHPabk2/1Huyyq2YnnpgPIydKBMFMdS28cIG9c/hohOnsY5Riu
         CI58T6iGafjYjbZFTLOfQ/XTNj+YZ8udqd1mdP9WUSh4+VaHvXOzZo+Set2bpiIo6osK
         TJD9EoEWHYQDZrkY/ioUvW9WTUipInVFNgzm9c0/gq2ipOAx92mS5H7WTIEc51RXI46S
         jSfesU7R/WNvL4BHdjyJRJwoT0+dSzP4D7K/mAWKw8OmBmEELGe0IXTA/5EqXhjuxcrQ
         qM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334487; x=1789939287;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZNhosrukSiX1wNaSmTI+ZUk61C0R//VPNgshZncD6Q=;
        b=I3oRKldHrsIS+baKO2Rc5f5UiZ+z0ymvdd6JL3ZzXbvrMkNWEioHUBCycLNd0MLG5W
         HrXbaoXM9fIPPwmhX3R0yl/majsHGBI126JCaiqzPVZwIkcRUHPSYE9ezyLwWE0LzhKf
         QQU4Gu8EsL5i4Be2JtZLg9yfLtc9BkMU68WB0r/9/8FTYCjLWlwgV8/QdDuZyzkAS80t
         yRor5UxR8972TWCyg2h3zNiH76y1XaYu/kun5D0XYL0/TRQlMhrwQg8OheSnsCg4S+U2
         mnKIlesfV8Wi0+1d6CQoD9u/T62PcZaQhyLG1ahrBCnly+ec/H+uGC364rHFNAchJQ7Z
         RGVg==
X-Gm-Message-State: AFuF++lLKblRE78X5iBLWI0L+Yjl4jgAHIC8w/UkypbbQZBsG2CZ69Xh
	747CIuyYNtw/ZyHJ67cUbs0Gss7k/pmktCgFghMf8cBFSj+x1d2Gbmbzzljth3SdJtpOOL+HDGY
	0FofmJgTnZFZCaJqZEpkZSEKGFMi+rFWjiYh/SJyRMqFJ8X2Ah+TiDmGO1nIhYSL20KmwNt8=
X-Gm-Gg: AYBFou1LYeNTSavBoE5hxS9vC9wr7ahfITP8OCLBrO144pIXqSXKdid5EIIC0ZqGXge
	PKbPG2aOYtvmCjJFw4S+JZvk7gVHdXChrDa9ekmds+4Wz0MGQSbaPBxWHgRtIgSEJ9ovMTkxIET
	KLzgpqhMC4JcKQ4z2/3uKs5u6hAz91W4ApE6LDLtZN2s6ZVldHzur1opUrWEHSxdjsU5tauPgJx
	bnvZycL3qyyjUL72auxm9FSIlqwvsl194xNl9Tn5NbVeR6ipDfFnV4Crreh5aiNn86/kfMZcRBo
	3gmIIYBl76igv3ue/9CwDDScocc/W4Qx62r/kY/EbUdJAmtPo4OyvKFKy7CuJlqf4HiyrAO7pl8
	9OntgnVyyiOs0Xw2D4HucCwUTwjurqRPFN+FD7Z559zCxO+qUmvjAXg==
X-Received: by 2002:ad4:5ae5:0:b0:910:3923:cc70 with SMTP id 6a1803df08f44-91226bd790cmr45849326d6.25.1789334487492;
        Sun, 13 Sep 2026 14:21:27 -0700 (PDT)
X-Received: by 2002:ad4:5ae5:0:b0:910:3923:cc70 with SMTP id 6a1803df08f44-91226bd790cmr45849136d6.25.1789334487059;
        Sun, 13 Sep 2026 14:21:27 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:26 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:13 -0400
Subject: [PATCH v2 01/16] btrfs: stop enabling the v1 space cache from the
 on-disk state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-1-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=3265;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=lp6N7P6uRAwF4k80VrSyckftlj/cB8cKUNVuGaugFXs=;
 b=+qUHL+CECiE9jWYFubqeORtH3yG0dxrY3rleAUZHzWKlOw1jEVvudSG5u74yH/lkqG4KwBhuo
 FYREOF2bf4iBYBis7fBzOq3PsQygc5798bglIOmdYN7ENu3uOLGJYUj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX+99sLZQHOMPG
 HcTdvYEmGzN1Xl7b4BpIlGDxs2H76sxqE4wqcttGXnbGbNpgdqppzyr49Cw03JCCRwz/7AEnHZi
 AoxfFFw4PWSuC78aoPh0RrUI/KdiwUjPwvoJGiZy4eMj0YYdBGof
X-Authority-Analysis: v=2.4 cv=Z4x5j3RA c=1 sm=1 tr=0 ts=6aa713d8 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=6xji9QrKO1GPOBtlZsEA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: cMopFCmpczzvGB0hCKMFOKAYWs9PqRo4
X-Proofpoint-GUID: cMopFCmpczzvGB0hCKMFOKAYWs9PqRo4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX5uRRknsIhb1n
 S1I3VlNhs2GFyOJDwIB70h4j/BEAvDxBR9oQY+muD2VHcRSWClHxHIHsBLne/gPCpui6D1u5D9b
 tKtvAI0YUncKG+DBNhCfeST3Muu91+pFK0z4v7Muu1Ea1P92kAzeJy1Yqc9ajVyE+X+j/oGszRI
 nUAHpd11XQ04aRTcrRFp63uNACCmEtxStc+2DnRVoCrXlNr7OXtNHlwNu8hmWZtNdUsNuiHfbR7
 U5TOLRftmB8E2jq1zDOChYXQ5WuHOmlb0cARXII6kxHN/iJUxKEKvsAQ8W4XhGGfbMeVSldmVX4
 NpftzbXfJsph3h5UnPfRy3pyQeSSvAoqOV2y9mKZM5RoqK3rusT4vDvlHl2B6BhN/Gx3gRp0sg2
 Pbz0sJqV82+x2r+adVyOhpkRlW7O6rCmZMqVv8dlCukvaP/7jzr307mcXLofkntuPL/QzRf0Y6n
 WrgFQCOZzdfQQM910Rg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=10 bulkscore=10 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

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

