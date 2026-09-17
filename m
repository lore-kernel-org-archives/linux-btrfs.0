Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C554386C25
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617635; cv=none; b=qpQxNexHOs1Wf/eUikeu2a8wxqvWMwxfppUPt3V6OVdDh0HYUMpDoloN8q7EXswFm/1HexWiTyyhyvZLlqX8BYeH8v02R/nEp94xeTmgnPWNcPILJwTXDCigU3UZAH0aRuIcCfohHWoOVEGwGk/csMYUrACx4YgMGTZxx3C7TYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617635; c=relaxed/simple;
	bh=l6XWpALI72VvymMl9mmC4aOj3XPdEV6iIH3qiK4vIFo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A4lfyZjhOcf16Rs6x/b7nIETvajHvZMgrvgV5QJ284AbbddExqj54hlM5yBowdXhbM5cYSGq/qovhq+UoTlQvt8QszaY7Z0tRkZ/GpkmTLY8uXkRJJaKcZcgrBg6cDv7Jm494W1Q8Ta54RS1l2K3B8/JWB7Q+mXqzQN7CDQoP5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=djo6c2Qm; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XXme4IAs; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="djo6c2Qm";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XXme4IAs"
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YJe62149687
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Lm40
	yi3MdWTcg2CcVssTHoFmZQKZWN5OucQ+h5hij5E=; b=djo6c2QmjviYTojjf2fH
	uZNjm49IUibUm3ec/lDh8HbeVbI2H7Pz31sHAzYK8esK+3c1kfvIPD8/f3T8ec5T
	Xi9ysRfQv5ZdOkppauCporCl5Jgg3qnxJRHmb3QaS4srPykeAro7AtLa75RDXQzP
	Fzyp1G1tXao5eIpq2//6wF+KRJYviHMehPHOT2EH4sq4CA0B3zuQV2cqKUEvc+Ip
	n6sKJvOtw9GH8ShKpMe0v1iecohplPDm1wXlry+5Ot1hINKio5XOB4RISO+He0IF
	VdRndB49Mm7tgP75bry4hwkEjrmLRc6vfHDPkoKpTeShKpedYhim+czzK86oEkC0
	hg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr0kqb9kj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:26 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-936aa34873bso69254685a.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617626; x=1790222426; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lm40yi3MdWTcg2CcVssTHoFmZQKZWN5OucQ+h5hij5E=;
        b=XXme4IAsRGBQauWuBRmXH1s0qq9PPNLnNl3+rw/4TVZDLw4w0x8DDwePjHSPUWNDak
         UQgypgkkFmQK4wTZ39Mf4BCUbZrO1w8Dz2mWdeKkCAroLQKkxSVpPHTCj/rr6V07Wsuh
         fwC7tE6t/mfPUIufRpgb3cIiVodUzLBJ2MtN2KVm22n6itsh1rzznFb2oD99nmTiaMSt
         GdFhgppn30IV4gCwC30imaT1eClSrSiOfgHTu8nS9YGbtBE+JIYWbE1gDwYb10LF+Knc
         cnch3aRovAomW5oANEMRxbMCais2ACXTgh+ZZg6tPpa9Ml9MdM6eP1CR+OW76N9omtS/
         hwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617626; x=1790222426;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lm40yi3MdWTcg2CcVssTHoFmZQKZWN5OucQ+h5hij5E=;
        b=LSERkho++fPc5fT6dAiiuAPHYIkLgabDKHh/EsWvETlMMcdoRylA6XXnRCpQrSU0Ck
         1JMB6PnoIi4Pry64XZLWa0kNirsQF9M417oXFY8GSLT6C+AISD22705gry8Hh82A6sCp
         WJWDLDpfURubYL0SuhGp7lbikGuOlz8Da82hp20rBA5px9w7VrgWFJJAgAX7ln/6DF6P
         o1Kua0ipf9Z9N5CiFt84u92awRUYTVmS1Of5INPq3teNlyvRxM2cNQcG3//9OucC9FdF
         DdwZ7P3uzmOL6NEGXCNny0iq+wmq+XiUT/MLo24Oo7tBH2osoES94bQKxDY1PmYcPRPm
         6p9Q==
X-Gm-Message-State: AFuF++kGOTiR/i67pQv27Pyoie/dy4C5VnuO6sJq/8iV2bBpR0pOwkxw
	x88bclmpkQB+tLZh0BX28rYn7Qi6+CB1dbon2tOQj/NnjMFFoLbH3T2I/QgUhUIqrrlk1u3Ryx9
	GUXzYgo05p1P39VwQMknNP3KkZeWa+WcLKjAiUkfFPQPIkRnSdAXi+LfWxWMN
X-Gm-Gg: AYBFou0CrxX+03TtXMXv4Pa0khyFZIPJsJsTfZkGuS2NGnpSrndg7GZtu+A8Eq8cQcb
	4Ti7hBot89kfKLzdhBjSgzAra5er5wZgowQi31rwHCkHv1NqIIJ3Z7ji3/JY/IdnxH04xwAaOrk
	dogXl0HYPwXO86RofaRyoIRc630uGHZUiI76mELkmxzbKHDJVMOKGlt/P4zNL0hr/HmQxFkEsvq
	RavAYOe0bTFEHsoWEhSmXgEyVkc/nBN+FJtiExz6sNdgYpVAJxrFJEWTiNjVqLUtyUUvNokSZXV
	HVra6ixbwYpv9u36tWeZarLM26FDpKHrXouP7OYx6r5CbtHDx68rMmxPuALjIr20/wr6UWAjinN
	2IlMtRkJYVfczQV94ewh4MIxyuSR8g3+GzlzbBWMO9ZQ1Iw==
X-Received: by 2002:a05:620a:4808:b0:939:b559:1e82 with SMTP id af79cd13be357-93bb7952a4amr883431485a.41.1789617625885;
        Wed, 16 Sep 2026 21:00:25 -0700 (PDT)
X-Received: by 2002:a05:620a:4808:b0:939:b559:1e82 with SMTP id af79cd13be357-93bb7952a4amr883425685a.41.1789617625373;
        Wed, 16 Sep 2026 21:00:25 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:24 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 16 Sep 2026 23:59:57 -0400
Subject: [PATCH v3 01/17] btrfs: stop enabling the v1 space cache from the
 on-disk state
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-1-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=3304;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=l6XWpALI72VvymMl9mmC4aOj3XPdEV6iIH3qiK4vIFo=;
 b=+gZz8ji3CO1LENYqTcqk5swb7OcivxHRRxtMbC5ZvcAtoeGscN6erXJJ4Kt7MCY8l1Pn6xAaD
 GfCg9+fjxMSCMCb8p0GCafas3l6XWzWJoa6dBVFjC+zHCmMVtinDRY/
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX1Ek5hoVKh3wc
 CTv2VNy00D88iTdVzkeLiBfExUintxt/mI7LEwvy/19dtrKqZ2l0E3X9EH/tIiRvsBkcQ5uXg6/
 DW7/45rrT4Z4iCfHNG9LjqglPqMlKGojooXiX19m8LPQEZoc36WY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX2ig/S9elSAA6
 hBYCdi1Xv6DOsS0ASOwppl8Hu2jR/1I0sKTLrX/6xjKWPQaHllWVzY1VRpNEo2IgxO2gZmynh5U
 d5+vvKAhHTNXCTKLtJqNStGhw1PdiCFZ9GnCBQd/xmy+l/8BFtWLXGrWqzCOOktvskUCKgGchOk
 JXvYYg7Q9K7QivoFg5OAWxx9XtmNTf5OwaLGwh74m22n/2S7JAre/IJ0pLT2ovyI32+Yt3CzUlz
 aUHY9HzybeOt5qqinCXnNWf0/pdDbOfvqSbWTf/0qwMJZZ5gq1lAYcUeZOQkhIYRUwo86+xmK58
 EyfqK9cUS7RFJHP6A8NYS03qc/wgqi5zr0SkPUAdONRzbu/c5qYHNs4nnK25YAiFE6B+rImVU2p
 rXzbCsK/S6aqE0WwcbkszCK9SM45BDtFWgpXABJMsVyUvnolAAn0V6KaEKTmMGpapVVen2RC17Z
 Fjo+hrAJkPSesaTOnJw==
X-Proofpoint-GUID: ET58F2fEOUBGz8o-TGqumFV51U8hExFu
X-Authority-Analysis: v=2.4 cv=ZbqIpcVA c=1 sm=1 tr=0 ts=6aab65da cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=iox4zFpeAAAA:8 a=6xji9QrKO1GPOBtlZsEA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: ET58F2fEOUBGz8o-TGqumFV51U8hExFu
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=10 malwarescore=0
 clxscore=1015 impostorscore=10 lowpriorityscore=10 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609170047

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
Reviewed-by: Qu Wenruo <wqu@suse.com>
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

