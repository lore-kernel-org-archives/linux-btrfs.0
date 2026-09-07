Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5350D41834B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788812433; cv=none; b=WAW1POZJHGDgGb4Z13eK/yk2tiiEk76I1c1v31ETJCfcsZfjTpVXN5oX5AeoMqKFF7AhOD34Rx2rCALoPb72ysdPAYle7GpYZ02L1LeVwNL7rmGfHclraZGSqsl/8R2UOhdof6zb0pc3TPN+MJx36CM2aIwfpJLgOdYw37TfWaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788812433; c=relaxed/simple;
	bh=JibSQGdAEYY3mJm8Xkps8m6r7Q0UFNwNv9ID7AtRvVU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Cn+ciU5CNzmNIjfQOvYB8UCBKRVLRQilej40KaJRyp4f4UYoKDcbU7pCsJMX0t9RQ1DQV+cf1aQpFBIPv6u0bj+BKiOFZZvRhiFNVweSXap5RCHDESqSYTytEhc5KaWblDZqQFpTMFpfj9ZxC5Wp0FR0siw6+wkMX4lxuvxolfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=K9prNAHN; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=5JGp4shA; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="K9prNAHN";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="5JGp4shA"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687IYKNr3111274
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 16:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=QiGtUshKZxylmfjVR4DIvzvifN
	mZrFAeh+Ui6UZX1lU=; b=K9prNAHNtrZnkjJMLA+8HU3Q+5fjLNfYujvWL99tdG
	gPmP/V3Jy2aWvHgBIXIkxYpUw1uB+YC8eT2FqmW6I+8J2IXz1O3zzDpdEnoZyviT
	TTfvRL1yqMfBq2F92L/2z9BRucX0aHi4q17Qgx4nyGqRydsVkDMB0PABBXu+38/l
	+CrKZ8v2iE0/izEG9J1Se1MWZ/n+2PB62msWOe5gPhRHzkB4QdhimcLPp8ltZsFg
	BRlTS/wt5q9acON/MBoHOJZ4C4nDSYyJm7zWFro6/nLC/zpTD6Hgrepg0pwYRsSq
	lqcfBOZcd+3UUQ4vr7qhrgcD8K9A7bqx05ARtWLUTnTg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7k5but-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 16:20:27 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9102f07f2fdso82628246d6.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 13:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788812427; x=1789417227; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QiGtUshKZxylmfjVR4DIvzvifNmZrFAeh+Ui6UZX1lU=;
        b=5JGp4shARmJqMFsGmSrLPPqSzN5LOtZtSOjHAtSdpNPquYntIbZ5M8NNicnhHPKBhW
         UsLNLCoVkBKJ/t8KWqRIOPG+jIOSCPND94v9FCgvfwTeH56XcOOeRLEKRu7CCaHSVvTY
         nrWODT46BkEWsPHc+bM149uETzlWuGbPP1lAC28WzZV+O1iJtNcRMirp8n8PzMtrmGyv
         tUZAvt9bTpn9Ggumd3eTgyUmUoyylBr8OcWu4i8Xm8awV9XxrHlNrayLPPq4WxVqE46m
         rs+tLnOH3tA8puqSQV6iBMZxxuHPyFBBnRfUyXtx8rjaHvqi/HauzG09ogzLd8hsxpub
         Mx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788812427; x=1789417227;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QiGtUshKZxylmfjVR4DIvzvifNmZrFAeh+Ui6UZX1lU=;
        b=i8Nl/NeJpx/VW2sdb/0sLpV2jIJv8yMqKNPQD3N0TeJ/TwdNwKOrNRUqZQyAYMcfaK
         mXGonkczAp382vzlk+trPR3bx8aq8QbiwIDBIF/ui+abf1DgZCMiyBQDyA6mvX4ZgmXK
         xPYbne9i7/8liFPa9Xs/WURyQZEqwV21S1eXx70+6hnHtFFu8ARjWmFpP1lbBmowVv6t
         djqbr6nF4nIubLvjqtg34s0Sc+KGd5R+xexVeg+WW2gfI6NameAazz1n7XBRo6Y19kCw
         ofWkpXgGIdJIc/MBzb3gmlAdRsIM4QoIc8qaeeSPg1+ucjIVkBqJAIHjnFqTdqaq4wOS
         7JVg==
X-Forwarded-Encrypted: i=1; AKwUvBxKUZDq3hnDsLWsID8vOiW66a9st21HsYaewdZ9tcamJ36CZZHcC/JEPt1knpa2Tqs9df0MyoWNprRRKA==@vger.kernel.org
X-Gm-Message-State: AFuF++mySYug3uk5vyAk69mOnwf6D2jf1xc4MyIvrIkOVQeo9J/63MKP
	PENfNK0K6LZoszmZIKj5t1DfotAP7Xg8OvHAK8FzYAze6L/14BErMklAFmRl5DYes1gBulQbM44
	Z6eWC4s5bA1qBafkBr+dvrJW89eC/aKPB11+DDrJ6iMC7X91AQ8d+xiKltDyZ
X-Gm-Gg: AYBFou0LhXgxrRJGAmF0eRLHdrY/HoGWLkrkJpcMdD8RYHtf+L83aSt99sYOhXw+0ig
	o1VDAruL9wbQT2P0cxTim9SraftsfsNVHEXtFGaB20I6iRUlubFQxw8xUA0vTB84y7tbedCaqC/
	z+NBipMFEZVSM9kVv6h7Wq9JX4zpPe8Xuk6Kgue+DA/9Eumjg0mr7j1k2/A6G4i/U5sjczCdJ6M
	Wpn0FTs/HL5ITOqwzs7ezJYw1KVKXm3LD0Hm4ONaITjubHhRYAKDAvYePkyU85ex2j4L64kvbnR
	AvCxKQsIwM0sJMYPlOW991S3ikLdzHSCTzm4SqvWqCytkHhji1FDdj5BYwy/HsPCbygmdWQzuBE
	EWFtpdEvtrvrlOJNpfxb5A2dCEpglCGbmM3gxGHs3sUc=
X-Received: by 2002:ac8:5fd4:0:b0:530:4773:113c with SMTP id d75a77b69052e-530477313e5mr235126331cf.26.1788812422364;
        Mon, 07 Sep 2026 13:20:22 -0700 (PDT)
X-Received: by 2002:ac8:5fd4:0:b0:530:4773:113c with SMTP id d75a77b69052e-530477313e5mr235125891cf.26.1788812421885;
        Mon, 07 Sep 2026 13:20:21 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-3.net.columbia.edu. [128.59.176.3])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413ce9dsm95062351cf.11.2026.09.07.13.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 13:20:21 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 0/7] btrfs: convert some struct page users to folios
Date: Mon, 07 Sep 2026 16:19:54 -0400
Message-Id: <20260907-btrfs-folio-conversions-v2-0-b5fe79f7607b@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGocn2oC/3WNyw6CMBBFf4V0bU1BHsLK/zAs2mEqY5CaDjQaw
 r9LMS5dnuTecxbB6AlZNMkiPAZicuMG2SER0OvxhpK6jUWmslLVqpBm8paldQM5CW4M6OOFZV7
 VhQJIrQYttvfTo6XXbr62X+bZ3BGmqIuLnnhy/r2nQxp3v0r5txJSqeT5lJu6q4wqbXEBN8wPQ
 /qI3SzadV0/JjF+09MAAAA=
X-Change-ID: 20260905-btrfs-folio-conversions-47950cc1faca
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788812420; l=1970;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JibSQGdAEYY3mJm8Xkps8m6r7Q0UFNwNv9ID7AtRvVU=;
 b=8osdwXZDjj6YE5G9b482rUbacFI0PDcoPP6GGCobKDiiYr/Tzmc6OEboHZZYwGReopZAK0BY+
 /y91BEgM3RaB+J9NrQ8ABTr1XxO0MUHLHzAEFGQ9e7afqmW7cnG5Xf1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: iaxYrQYvavCCqn1cptvAq9VeAwuhNqfc
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX6RJA2K8G1I3o
 yXARnVVwpcU6rpLSQwJ0A/3+WFLNeRwnVILITo75sE+1Xg/yAKFzZ295j5KfS6ZW008WDarZbX3
 5iVZPuEp6+wTqmCqg30RcsHD2hehfXqQAcNUit3JTb8qDlQtgy9K
X-Authority-Analysis: v=2.4 cv=QeBWeMbv c=1 sm=1 tr=0 ts=6a9f1c8b cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=92j1mJcILCjWExuphHMrQw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=bC-a23v3AAAA:8 a=O0ZaTJuHp4YmI9DrRTEA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDIyNCBTYWx0ZWRfX3F4pzPlYXk+2
 RUwcWLiw8tzzzSvVxB0pGb+rtFUBQ00+WmRMxK8E2LkG1179OeV05Q7y0EDY7ClQ4cpwKTSWSiT
 5oCIScACRPTDLfKoKk7TVA6ahVC7uUjz8qw13ofQg4UybZ8V5wnzMMIwZTazhLl4Rbxi+eNbqZj
 VPvy6ClCmm6OL/pKX3zPFUWn343EGK7fAv0UbVajVP/uegXehsO7agOycM43nxTd2qDCAaPhg6c
 apLgyMVD1xJqH6MzU43Q7sLudM3WjuALIm9M+IIub5zdUz7l7BZbgbhCenPTzKLUwefz78WC0Z3
 VxU/KwjREhHWqk9isdUaEUAqPsfKjFJP28dmmYJKXZDFPHluAY7Sm7jPmtE3LW5VwHOpKNkg74T
 rHpSKz7+kK+k4yO45+NXJX9CWIhIZ7aTlKrKz5K3bcUcK53dNWY4x1rPgh4tYE2KfesPjzyqw18
 zvgjTpdcLCkirengL8g==
X-Proofpoint-ORIG-GUID: iaxYrQYvavCCqn1cptvAq9VeAwuhNqfc
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=10 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=10 clxscore=1015 impostorscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070224

This series converts three areas of btrfs that still use struct page:

1. The extent-io tests. test_find_delalloc() uses the page APIs, and the
   extent buffer memory checks assume one page per folio.

2. Compression. btrfs_compr_pool_scan() walks the folio pool as struct
   page, the last use of page->lru in btrfs, and the heuristic sampler
   is the last caller of find_get_page().

3. Super block reads. btrfs_read_disk_super() and the zoned super block
   log comparison are the last page cache lookups by page in btrfs.

Tested with KASAN, lockdep, DEBUG_VM and the btrfs selftests enabled.
xfstests' compress group under compress=zstd and the btrfs group both
pass.

---
Changes in v2:
- Add tags (Thanks Qu!)
- Patch 2: Assert that test_find_delalloc()'s folios are order-0, per Qu
- Drop the v1 free space cache patches (8-10), per Qu. The v1 space
  cache will be removed instead
- Link to v1: https://patch.msgid.link/20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu

---
Tal Zussman (7):
      btrfs: tests: rename process_page_range() to process_folio_range()
      btrfs: tests: convert test_find_delalloc() to use folios
      btrfs: tests: use eb folio helpers in extent buffer memory checks
      btrfs: convert btrfs_compr_pool_scan() to use folios
      btrfs: convert heuristic_collect_sample() to use folios
      btrfs: fix stale function references in compression comments
      btrfs: use folios for reading super blocks from the block device

 fs/btrfs/compression.c           |  20 +++---
 fs/btrfs/tests/extent-io-tests.c | 131 +++++++++++++++++++++------------------
 fs/btrfs/volumes.c               |  16 +++--
 fs/btrfs/zoned.c                 |  12 ++--
 4 files changed, 93 insertions(+), 86 deletions(-)
---
base-commit: 69b26c13e520480d1869171e2c2b8a59f0c857ec
change-id: 20260905-btrfs-folio-conversions-47950cc1faca

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

