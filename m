Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294EB3B059D
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075418; cv=none; b=sJDAHkuZRqR9uD+OJhxUdy/NIS0388YWlv6PiGAuQttxTRoLUmA6RggOYT/yNYB49IXpX7sX/5iKYf0oupPW6e1Rx84FGq5pEMy7dRcZ/5kkIZeSMN1RRh/Yxm+zK+/aOwB8edLw+Wl2BplN386fE5i0/Jynz8nq0y7CWYgX1/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075418; c=relaxed/simple;
	bh=7N0boFm4UgABe/w22qf1vHvkOKH3/KVQts/XUigHtYM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FFd4iuB+/INA4Jfmsm+UzMCTf9lxEgz6mppP3F60rMIJx6CatTy3xWXbsIqmbJTstlVHy73cislZ43J2B+7OND8kkMxZIzAK8BRD1NBBzkTPlsDxGyJdBvU19iyZgXWt1SmaGaT3X3TqHgbHdNAPjzjZtOQuLziVS3P88Vr/6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=YPGIALys; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=dOJ2WnGv; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="YPGIALys";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="dOJ2WnGv"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYO7t2221202
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=3Rf8
	JnmeRK93mEgyVPUqenEJOl6UTxjmJdOdcJbWSSo=; b=YPGIALyskNxKRzjenaww
	1NQnsj9X7KNfcP8qrkCP84g3qyJ6PR0jbBb8ctvImaMBtzPJch3JIr/ADnxpzbn2
	egYaqPBsIuORMSyYyxGnypIZmcz8Hm42ZAoWUFPAKsztlpx6Gqo/tSd90cRz5x/3
	zBT/ygXJe1m9vmTbWAiiPMI3KWPS5gsZdWcaoclG5nVGk/SDMPdb9d09vrFGk36L
	XlL6yuQXPlK+PzilhpTV7PfrNAQ4klCbXdO7wcBk8AlKzkonz90vQAvQfENO2r/f
	hNRL3Vm1GcdE4Pcv6vWhEaY22IDusNKCOCJKtDPE0DuapKnWWg+A3woun5+4K+P9
	MQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4havrsjabu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:34 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917bab67568so157094636d6.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075413; x=1792680213; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Rf8JnmeRK93mEgyVPUqenEJOl6UTxjmJdOdcJbWSSo=;
        b=dOJ2WnGvIycM759yGIPsBvTcMZQ63aOSKecOh86a5tFluEV64H09CpM5ACNh2sa5vL
         01cEtiCYuThbyjH+XxW1gPnoyIHI7kK3KW2QmQEXwKiYFU19v1sJqjE/H/tZb20o7Dwf
         4qMVOuGcai0rVxR3aR6AIHi1IWA2o1zucy0yiR0Gfhl4eGID9RQfByz5GFFonvGsUcix
         c/mpUH73YLli0/AdPSJ0nEDwfKdZvH6HbjbhNDEUn7EcwaeVVkZjPSUhKT6WOjnO/0pb
         jgb6QDc6gB+OWXDSZ16wn+rk23Rd/RQdrLbGHRqBNFMTGkx5o7lh7pUq3HKdbWMWbinC
         P9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075413; x=1792680213;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Rf8JnmeRK93mEgyVPUqenEJOl6UTxjmJdOdcJbWSSo=;
        b=e12zNibqYcSj4h2dVsy8AfcbbKYVvVqvOT2oWZBdx9SMQV+hYBbEpnJSlCCns/BCqS
         /GXNknNzipS/5QnT5z9IvIy/ZNSLN3sWr0HU9x/uhUTL66D1wDx747/nXjyaDQrV7rzz
         jo5/+AqEBHzAlaOP5bpZ7smRA41lfECRyiiRavPuunQNybV+B220Jvkym9l5n15wcylj
         pyLwpd50RvRYOtNLAyik3pvBnyv2vUPkbRWxMg5IhN6Fj5tM8MGwjOwoD9Q6e33Vf8zR
         vNFxJYXMSSqyAkyvFkqmPSYNwDxpCbVW4/ikELRIRu+Gh4VpfORCj/Q/h3xMumjb0KwQ
         kGiw==
X-Gm-Message-State: AFq9FYK9XN6c9OXTIRDvkYMyIUyUPHhWjA8CPVAao3AU0LD8jWFfE/0b
	PD3PvHElV1zPttnxKZUVym9WTzh80UTntAHNLLmEpBBzKGVn7QhC7j655TBbdcRvE8BYqZCGPMC
	YFW/hO738m0AImxxfguh4slBpU1TINhJZdM3o8MKD1xHceWex4YqVq50yDUh9
X-Gm-Gg: AYBFou20cPkEm2tEAOQD2Vc+PIQrkkmIda7+8xFmfireoILalzBIMVoSXPpfrT0GAeh
	2uKQ3vs67gPC3MUYK3Brj1e+6pMDR0sgP6M9gL9EjBnC39bV//goZcZ2tQeGs8CuaU1cS67ZZLB
	CepJJ6LXaFNdXk7k8XrXmCUn7ecKBabLb+jsMCAR8qQ7LZnTUGdqxfq2pHNzPFZJ9mywM8KMFzg
	aPuNHfwttm9+nj0LUlwCQM5nODzEg7LOZTGUagao+rWmu9/krKFQAFKTvf02OqbSHWKo23fZSZv
	7SKfUUlQ72aM+IBrD41mn110bc+A6jrrRZn/7CdKql7geXoRko0sKUjWnzqHockkle6Tn7kCUu3
	SdpZamIvYI86ZkqGkyMl9DKjfLKjl3P1fxcdiYcD5NAYZ
X-Received: by 2002:a05:6214:2b8b:b0:917:924a:d4eb with SMTP id 6a1803df08f44-91b55575e40mr325475086d6.36.1792075413344;
        Thu, 15 Oct 2026 07:43:33 -0700 (PDT)
X-Received: by 2002:a05:6214:2b8b:b0:917:924a:d4eb with SMTP id 6a1803df08f44-91b55575e40mr325474606d6.36.1792075412885;
        Thu, 15 Oct 2026 07:43:32 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:31 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:16 -0400
Subject: [PATCH v5 03/19] btrfs: stop enabling the v1 space cache from the
 on-disk state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-3-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=3785;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7N0boFm4UgABe/w22qf1vHvkOKH3/KVQts/XUigHtYM=;
 b=/diXBcaswzDmvJGVMEtWFaCDCvpMABrBOsVAmGdUVyguAyyjnlpvGQjhvEc2ooqGCuhiNcA4A
 1o+bxmgaa8RBPoohwfm2t6Ce8OCg0ojfNOwsRSIn21WfU77KTaypQyI
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ELlf4zc05LOlW_LKC4d5ztkHZ3sWhKrK
X-Authority-Analysis: v=2.4 cv=L/KI0OT8 c=1 sm=1 tr=0 ts=6ad0e696 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=6xji9QrKO1GPOBtlZsEA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-ORIG-GUID: ELlf4zc05LOlW_LKC4d5ztkHZ3sWhKrK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX9EwMBuNtOVeZ
 pxz/BYJiYc3BaxZjHxHrDsWEcbKFC/e+OGHObQL+BaZPBciExr6BBBT+InTE5A6l6cTfO+FGDtN
 xzvKnLA0jpYSlpJ2eHy94RyVu3wDeevAA6z2/43OvnR6LbLfNNr4tWM9xFDQVjEatns1/8sCX+o
 ucpgca88Vh6VpQGH2FJYk9YBWdm7zdkSV2F+9ialrngyfY8sy0pe6Bbj9gu1KjzIjwLbrNEPFm1
 zAHOmnZS3wdrL8w4IeLYnEQaL7giCU9OFYXyyR6rIKSPQfu0ToiIWvQlQkJ/epjEIH6uWbTHxVt
 KbvDus9ixXgkdeETqGEkDleUxdDGrKMNPrAX7+ycR/12EvLuqIUX+jReVJbBszC6y4/YJAoiigg
 HdxrO+0Ca1XdZUATuIRTArORaOWjfy0soruibOhHLglxZBCjJmx1phx2h7grpEEN4ohNN7jJgRW
 v7rx02HXsIu0G7DO6ZA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX+NR4yIr7TIEL
 bwmsuu3IELsll2pXFfGQ9dEdqcel2nyHxheZIbiVCEE43gncsUv9ctBg94hNXXQReWdNp2zmqqz
 o28BGdPOvrLIL0X00COFQ4wsm/WzGBFTx+AlNWuGGiL4fjXfHDb+
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=10 adultscore=0
 spamscore=0 bulkscore=10 lowpriorityscore=10 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

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
index 7fabb775d4e3..af7aa9adbfc3 100644
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

