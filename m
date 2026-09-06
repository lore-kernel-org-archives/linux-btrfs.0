Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CE9378833
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733796; cv=none; b=jS3L5CpwwaU1LAmWHjXcL8X22SSvhWA0HiOSK+I+Zpkss12VegRbzQHAluojwal5MNOksVBVk3yUiFltGJ9vOSzuAALTjSf7oa/GO1oo0shZOI88FX2HwLWlP9n8IzyKnczuR3NPAETzCNkNhhvToRlybsYq4+StN8PTmwz/S5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733796; c=relaxed/simple;
	bh=pAju7TI5+xdoiqfY+xnpahZErsKUQ9RZaydgKBB+99o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WG4p8gQWQsNxP2VUDHMNPYnIVeT42pX7aTu90ipHYrzf4LPLgP0p3cuR2y3opYJSXWfBZoA/bhC7zk9M+Ljs6lGsJZ8Tsh8I9m1/SkBN+Jq43LhH7pMHyFjVGZftkF0op2/hPPkku1kKShnEz0hIlwtlpzVo+wqkWtNYGzS97EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iovmnKIm; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KACPj6sU; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iovmnKIm";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KACPj6sU"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686JpAHK227858
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=li2bXN5TDm4JSY+08ek5hlL7Ae
	vTby2HYb2VklMTt7Y=; b=iovmnKImSt3w4ZsIgF6ktdxFhk26IHMO4MqwK9+qLZ
	FgwtwOONbmD9vII/zIcZMQlSEXbDlu6q/LjxXxhoI/gVwnegkHuVAulQlxbCeNWi
	ASv1b26Rfh62tURlHai5YQykRHN7gYA32389QbMde66p85wpWtgTLsojJPKpYTgf
	Zhoy3B/BQuaqfuO3zAOg3gzHdBTztr7GYJNkbmxef84KkZ4UbDAw/W/4ynpU0ZfZ
	Uq91NSIZJsHIiZ5/3+JlEG75RU9FNwR9rNJK+hJ3T0tksCWK3AbqVInaQEEsbhyT
	KCr4vfI37HDLmeKfmbLYwrBh068N4ggPt8ZNKwlHGWzA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghepk0gf0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:53 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52fa5c5a4a6so72218071cf.0
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733793; x=1789338593; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=li2bXN5TDm4JSY+08ek5hlL7AevTby2HYb2VklMTt7Y=;
        b=KACPj6sUOWvl3re6TiuewGN0gsfABKxwcyxTibHSd519nlK7FRuYQDbgm4dqzhtxpb
         cTdLb7hUoIfe7ZEiTbzzzr/D0GIzzTRRG+rXz10FpOqzi4SxYAwp+JVaZ4fOUUDvjxTl
         IaygxGAMK89ikUzGe78+dvekjlhN4OOHZN3fW3XEThEBNUSrdJazI2n+w3js7RGiPOnh
         7t4KwKRB1CB7hmKVS1F6OfxTQJPlHg/4lmKjpa10VvvrDe8XdySlp/k3XAySzT3RJg0o
         b8qD1b1NwVAK8iYC3J21MC4mMs3xJLhf/T6OlnET2ulZDI7QiwDLzCPakqyqBIM5vNRY
         ZoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733793; x=1789338593;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=li2bXN5TDm4JSY+08ek5hlL7AevTby2HYb2VklMTt7Y=;
        b=PvmrnHi9tTCPDf2eBvqMEJT2HOitsb7soNq8a6Z1vjGU2p2xxJot922eV+QqWv18fx
         gqUNUtg+88hnk77RJSg9Wj27CKg6bZzA9rMwKYLe/q/a+Ikdi1UBMaP4s8HPz/dMyL6G
         e/pLJFDSWA6qV6jOrffdpsIp1s4LKpwfm5oV1ylaD2UFhPBiSgta2xMNJbdKNRnL5grG
         uGGaCNSzhh8SmucmQhLD16kLp1jAbeJg4CratyrolAj+qCo8Igmq+ZRH+ke1ys25FrRv
         xp5Kzl1peyl/NV8HrS0bwcbShUosktBVey68uXQFzRF+ybQN0db+hI22yGAYzIIimmJ1
         cQxA==
X-Forwarded-Encrypted: i=1; AKwUvBwblm2YQcZknF9exA8//zGLcuPiS8CJpR52cFuszvEwvbHvK9W4bfi/Vi3oEwOoLY05+2IUkZwmovfAvg==@vger.kernel.org
X-Gm-Message-State: AFuF++kNOMVanSNAZNRCKi/KXWMlmxVyyY2uPGUTSJdrzfdfQkpMfCyL
	xnFCTT3eB2TIiKnNQc4gxH1RrLgt1IyW32bPPPoPuX4HXrQKkdHAe9BfSVXZZgXCSIetRYzz1qi
	QOYNG+STVE/ozbUTieLRatLsgTa4Y45U/Fu2pxYBSNl2RuZStDDssTkxxGRKL
X-Gm-Gg: AYBFou2lZ2WgzD/GnkyMtLh77usQrnSneeaGOqhH2M8PvNdrXZPFYV49EqYwClo4oZF
	H4tsbRW6zYanpLDITqfp+Z97L3dk8QjyaJqN16qYCNLQbp5kIsirJZVz+NLgfCWiVG6WkXnUktr
	zy8lTlE0RaEU0g6vdglVSeudDqdMjviWyGc3F2rjktC2eIcJzLslZeFNquc/GF+NKEYcrD9zC4C
	UnjEoAXEp01vKkPASUuOVKDJP/9elB/HlrkETvSGyUWvjlZ6N0UiI0ghsPkT1xsD3adIHwUeeWW
	rJ+ce2pCJyM57/8022s2O2O6X7pnB+YurNV5LHm5D1H6nyT8RYz2bxOkYKoBxQFp0D28cXR2q+F
	yOpRslXVBh+zC96BRZPSE9gmnBdPJfnGo6aRG8n6x4XlSxhss
X-Received: by 2002:a05:622a:38b:b0:50d:e471:2d1e with SMTP id d75a77b69052e-530549edc57mr217549811cf.35.1788733792758;
        Sun, 06 Sep 2026 15:29:52 -0700 (PDT)
X-Received: by 2002:a05:622a:38b:b0:50d:e471:2d1e with SMTP id d75a77b69052e-530549edc57mr217549571cf.35.1788733792319;
        Sun, 06 Sep 2026 15:29:52 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 00/10] btrfs: convert some struct page users to folios
Date: Sun, 06 Sep 2026 18:29:27 -0400
Message-Id: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEfpnWoC/yXMQQqDQAxA0atI1g2MUiv2KtLFGDMaKTOSWCmId
 +9ol2/x/w7GKmzwLHZQ3sQkxYzyVgBNPo6MMmRD5aqHa12N/arBMKS3JKQUN9YzMbw3be2IyuD
 JQ64X5SDf69y9/rZPPzOt5w6O4wcnh4O2ewAAAA==
X-Change-ID: 20260905-btrfs-folio-conversions-47950cc1faca
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=2537;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=pAju7TI5+xdoiqfY+xnpahZErsKUQ9RZaydgKBB+99o=;
 b=m9O6YZTKaMkoLhwgnca592SFDIz+V6ExsQ+u2srnglyFEP3uH208UIvPp5DOX8VAysrTJfo65
 RHEtAxA+bE9AkzUbxrHKLK42LbKsqjoOs+v77nh9MQwa15sZXkoJW3q
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Wc48rUhX c=1 sm=1 tr=0 ts=6a9de961 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=HURFG2p2B0PVTFy6EJsA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: fQo-j4pzRArPCkkL_eNT1O0rIbfnDCeP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX42BWhqx/F9Yy
 0Uso7P9ZwpK4bjkDT5Mt1R+V0VREGpAK1hqBmyDlJWXnohjUd4zXdrD15SJrH+PR2UazprNOasG
 +fSQMQxkCEBRatSd4Xw5JRhOjiW/ASsYzXvrALxAGfWFs8/2k7Tb
X-Proofpoint-GUID: fQo-j4pzRArPCkkL_eNT1O0rIbfnDCeP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX/alGBF9++/mt
 kEGTemGNJvj/WN6q+3gQY8SNVwmcIeMGPcs+eMBhkO7JNWurXQSQ1OgaOVUSSSMyBV2/nwowmAH
 zQVNf7zAg2rmW7dCMRZzZs0iQgkqwZ4ggV2VhP6FIXQGTexOUylsWrapVlGUsjpTwBLPvs+iCx+
 WzD1XjiQQbPLPuArHka7TQLOpGk3jLeNUbEHTpHvEAAbFyu4e04tLetkQ8xpFQ3BmbwvCdBzZjR
 4NjlSwAsbw5uuqr0MX42xCbCCEBpm4zOofuU0a6pDfRyaTzKcXDG+tNkvrsPplJztbKQhsWmQPw
 PpsfIDN/nnlE2k3A8YI0zXLa1UxoV9gAWyuP/YKbOQGtXM6N3r5xyoA3Aaj1ym5tVFt0zYCVgtn
 CsyGt0p9N5J2ikvJ1RJ/CQQPECC1CnkG69iLz6ftNKnJ7Evn/dtQmiNKD9aiS7U038G5Y0WZDag
 Mh6cU2wtnf8g8MSjaTg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=10 bulkscore=10 suspectscore=0 clxscore=1011 adultscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609060252

This series converts four areas of btrfs that still use struct page:

1. The extent-io tests. test_find_delalloc() uses the page APIs, and the
   extent buffer memory checks assume one page per folio.

2. Compression. btrfs_compr_pool_scan() walks the folio pool as struct
   page, the last use of page->lru in btrfs, and the heuristic sampler
   is the last caller of find_get_page().

3. Super block reads. btrfs_read_disk_super() and the zoned super block
   log comparison are the last page cache lookups by page in btrfs.

4. The v1 free space cache. struct btrfs_io_ctl stores pages that
   io_ctl_prepare_pages() has just converted from folios. Its mapping
   allows large folios, which the io_ctl code can't handle, so the first
   patch keeps it at order 0 to match the v1 format. While this is
   deprecated, it uses page APIs that we would like to remove, so it is
   still worth converting in the meantime.

Tested with KASAN, lockdep, DEBUG_VM and the btrfs selftests enabled.
The v1 space cache paths were tested by mounting a filesystem whose
cache was written by an older kernel. xfstests' compress group under
compress=zstd and the btrfs group both pass.

---
Tal Zussman (10):
      btrfs: tests: rename process_page_range() to process_folio_range()
      btrfs: tests: convert test_find_delalloc() to use folios
      btrfs: tests: use eb folio helpers in extent buffer memory checks
      btrfs: convert btrfs_compr_pool_scan() to use folios
      btrfs: convert heuristic_collect_sample() to use folios
      btrfs: fix stale function references in compression comments
      btrfs: use folios for reading super blocks from the block device
      btrfs: keep the free space cache inode mapping at order 0
      btrfs: convert struct btrfs_io_ctl to use folios
      btrfs: rename io_ctl page helpers to folio helpers

 fs/btrfs/btrfs_inode.h           |   7 ++
 fs/btrfs/compression.c           |  20 +++---
 fs/btrfs/disk-io.c               |   2 +-
 fs/btrfs/free-space-cache.c      | 146 +++++++++++++++++++--------------------
 fs/btrfs/free-space-cache.h      |   8 +--
 fs/btrfs/tests/extent-io-tests.c | 126 ++++++++++++++++-----------------
 fs/btrfs/volumes.c               |  16 ++---
 fs/btrfs/zoned.c                 |  12 ++--
 8 files changed, 173 insertions(+), 164 deletions(-)
---
base-commit: 966bb86e7420c64f20edaac5ea096da9b16dc458
change-id: 20260905-btrfs-folio-conversions-47950cc1faca

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

