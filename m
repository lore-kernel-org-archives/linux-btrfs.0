Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC417A586
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334490; cv=none; b=UGsfR/MibFp6a8zRypYkXo6cxGW2F76EgzmlRVNKNqCYow0ZVNSwMk2zzOfxea6lSAXg8y2XuLdIzHWTapdzukcPXlZnAIxC9EEqeMsnBdtJR0qcVTaIrDxEFhNZofzK1hGMgHYl8X1rdVkyI+21xKA4VExc6z0vpUeygdxoW8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334490; c=relaxed/simple;
	bh=YUwqKXRVO6ne1LKlYOwUs/QSfP1dqPFMWzTGGWffy3M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=RWVjVSpza57Bcl3/uSWu7Aqh+gLua0xErw7xJa2Vbm+/Bi5SPErksjVh/bPY1e2R6hlB3Ojo4SzT/ROgtWJiELhhopcdAUq3oOtRUIkW9tyBAdl/NhmPK48F/zHvKpq6X6pw4KV+h0AYedVvqjE3X8r83e7rCCY43BgyLBarA+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=m6nEUUrc; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=fvECI1m6; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="m6nEUUrc";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="fvECI1m6"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKXjPZ652269
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=sP9aSVh36R4NKXyAt2xFOt4st+
	TewWr2CQVSF4wiG9A=; b=m6nEUUrcydjKMBa0+p7rMRxa9EjouOUVC20zZ9djD+
	Db22EwcO4RGPIlwiZZDOfTcpXUZe4Frir9AJ12N7tR2KZUA/RuRkdGsUPu8xq+kY
	YJQJx88fcsFK94UcQN8mUQliiyogDXEahh70vsmMBW/L3C7/5Cb4wZs48zwmMKCT
	Vy9ZHD6fm50pzm695GZyjUpGd1cjCnz5Et5flGSQGCZQvmQ/fmkqhbTGJajB/MCw
	HFVDuAoFMpIzhc1UtkW8GfYqrwdMwCN62KUmW9eZACy+SAav+9gB4Nn5BKxWmFGG
	jt3bzt1JIWqTQmG0/r6I9qGC9fE9riC6kyedQn8B06ag==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp2mjg7w6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:27 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a0312937eso142670185a.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334486; x=1789939286; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sP9aSVh36R4NKXyAt2xFOt4st+TewWr2CQVSF4wiG9A=;
        b=fvECI1m6eyBJDpTyGj2uuHhLNJqVsonYhkGfw0j7V9aeiIp4mGZKL5w0dSPxGhJoPZ
         x24oq+iuoHLwfbmbcGSXLUZ8uo9btI4nbiXvFSb0ZeCkBCOwQMsNVcdm1KToSW3s2epS
         TKh86d6GS26LySIAkVndh+7zCaqlUkVmvoDeaimyPYMK1iP027kxniFDDMAZOwalQmEX
         YX/l7oWR04KXrkWHkX28VMnCkDS++xZxmZEW0mlX1r4pxcgKLXReZ5mag/zLWtR5EGDO
         P17lL6ghI7A+RmbGr7UJYWRCDoyNa1FyZD6Q+orS4vzv+0zJwQVwp0pQ/TfSeuQpXBur
         YqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334486; x=1789939286;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sP9aSVh36R4NKXyAt2xFOt4st+TewWr2CQVSF4wiG9A=;
        b=arJsHgkBQ+ye2DGwt/B/nMSEu/VbV2A0rzw3ixWVM/t98R2URiMJcZTtG+H6jc3c5F
         kU/dFJ9SeIT9xi+EfZ+n3ja53XHIlPXOFtU23Qq65x1VusLBSBkbtOlc9xAZeejCZ+sU
         QXFJbqx1pMZwFpZzxT25zsFihp2zU1LIil4GccwFRMZ3nZuxeAyaqEcCiRXV6/CLPuhi
         aDc3oDqwUYkVS0aHd80bNPy/J8A5LTYOWO0DG9FKoPz20bF9gmFQELNaphruam2vRlpI
         CBMd6M0lwXGXmp6aFzYMZVXT6i9gzuHawxm9lEQHwQ0lmaEfUe7HJDX4BH//iJw+BEMZ
         1g2Q==
X-Gm-Message-State: AFuF++mQOtDklRny0uqh5k0OrA4G71MziXpapniBgbwTwmKLUwmZpCUm
	vXowGQ191WtD+mjmZm8RIapiDtFCpxQudv+o77fffdI8g0qW+OvsTq8KoE294gGrra+Cxf++qlu
	Ink2+NG5ZxoXoDSbzU5O3Lf9zU7AwBAGIGk70WP8JhycykHJM2O1mGehopnB/
X-Gm-Gg: AYBFou3tD0LvHoLVlD5dNsVgiJl+5vE7iX9l/QjCSABDAM/2QuOlukSHwFVu90NKm7V
	qqQjcAd24FwC26cJhWFed4rCDbQjeKfjXB0pkIgP87TCWvvikBOb59MAxKdsmofKk0BMmFi4l71
	c8UX6UrhnV5OX3aU7jdUyVt8JGb+kIaFD/yqD6WZOmg7A2B0safb0d2FSdQWRYI3ZNVoPLOTgsS
	jSx9WkpVdWAsAEAU2Ln6AYU6kzmsZw1U1GNW0XyPsYqVIVBTfxPF+UswbG6oreb09BqC1rGB9dy
	LLS/0gef6Km2tTWPaS3gDtMUNY9l/Wr5k8I22rKN1l1buWMjWu/lzeyzduvh5H83VdVHDAdgfPQ
	1hWF8jC77HGb9+2TBBovuvqdv7baB4cmngXWmXTwbQWVGMljogp5BNA==
X-Received: by 2002:a05:620a:d96:b0:939:6de7:8765 with SMTP id af79cd13be357-939ea280838mr2190198385a.44.1789334486584;
        Sun, 13 Sep 2026 14:21:26 -0700 (PDT)
X-Received: by 2002:a05:620a:d96:b0:939:6de7:8765 with SMTP id af79cd13be357-939ea280838mr2190194685a.44.1789334486013;
        Sun, 13 Sep 2026 14:21:26 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:25 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 00/16] btrfs: remove the v1 space cache
Date: Sun, 13 Sep 2026 17:21:12 -0400
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMgTp2oC/32NQQ6CMBAAv0J6dk2plgZP/sNwaJet1AglLTQaw
 t8tGK8eJ5nMLCxScBTZpVhYoOSi80MGcSgYdnq4E7g2MxNcVLzmFZgp2AiBep8IUglx1EiAGju
 Cs0QrFdZSacFyYQxk3Wuv35ovx9k8CKctuRmdi5MP732fys37ndTfU0YO0tZaGn2SQqsr+ufcG
 6eP1M6sWdf1Az62WXvbAAAA
X-Change-ID: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=5050;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YUwqKXRVO6ne1LKlYOwUs/QSfP1dqPFMWzTGGWffy3M=;
 b=/wAa6N4p3FWnP3kg3Bcs4e1DcKNEf6V7H9oeL/EzbT22/GXJnfU4gLMyPQhEK90h7KQoEP/uD
 wc9FXskVlsNBJ32Jebbxj6e+x4g/1nDiYMaHfLfHDr+/WM923Tv+4QL
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=NfpzRGD4 c=1 sm=1 tr=0 ts=6aa713d7 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=bC-a23v3AAAA:8 a=9ly2DDOFe41V05N6iNUA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX5dvp0GUd8cGQ
 Jz+Af2iF+ly+19AoBx3KjEfiwXbaufZDb5PtkqGopzBtWIqRd25G+qPs95cuYrDOITjkSGAmM6d
 aNuzyPpreVxXbtaigoPD0hort15057/pYHujGA1lSZ+QIuAN6x/1MTSV2fLJHiiG32JpcCxg9cP
 s6zGCy6CjuWFnuhwPnR+rpAR0lqirTNVdgQf1dsCUBF1brWnEiD1BESXJjA+JuqlzUfPxQmdISC
 D0Udppql+z6yHPs4ihNR8Abfbl1lXvprdn5MODtIoKA9/NDunpyZcdrnG0fv4lK6PQhAXAVSWJy
 h/t4IaUKwJOvZc1t7aqC9+uHUMOuw1lZyyLFH80pIQr07dv1q+q7XGeGPdSz4E5wzefcPhinuEo
 TeVXXahAhBiOQAB/n3U1Gp6BM6jm1b7ZpLY3Xgs/TNSomsXV5X2WXBR6+WhSfCUpw547FWts2vt
 s/+V+qEZtJC/LTPpkaQ==
X-Proofpoint-GUID: 1lBMQW_xrVmjavFm_bSmVAT2hIqlcrR5
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX9DYP5mG26v6T
 o/r63GAE9WpHRXKvxr/y2tw14oEgJHT9zvI5xeep3G3ODlo/tVWfrvFd5NcTb7YpKS27wDLqy9m
 qYVol4rAV1qGNvRXmSPHdSda8JzUxDEsmhOHcaJa04dv2GlOhgol
X-Proofpoint-ORIG-GUID: 1lBMQW_xrVmjavFm_bSmVAT2hIqlcrR5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=10
 clxscore=1015 adultscore=0 lowpriorityscore=10 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130304

Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
options can't select the v1 space cache anymore, but the code is all
still there, and a filesystem with an old cache and no free space tree
still enabled it from the superblock. Qu suggested removing it rather
than converting its page handling to folios [1].

Patch 1 stops enabling the cache from the on-disk state, so an existing
cache is cleaned up on the next read-write mount, as -o nospace_cache
already did. This is the one user-visible change: the cleanup is now
unconditional, and a read-write mount fails if it fails. There are two
ways to fix this failure:

1. Convert to the free space tree during mount (the recommended
   conversion), but this could fail for the same reason.

2. Run 'btrfs rescue clear-space-cache v1' on an unmounted filesystem.

Patches 2-5 remove the write path, 6 and 7 the load path and
disk_cache_state, and 8 and 9 the SPACE_CACHE flag and the unused half
of the cleanup helper.  Patches 10-15 remove the trimming ranges and the
free space inode special cases in the write path, which only the v1
writer used. Patch 16 removes TRANS_JOIN_NOLOCK, which the space cache
was the only user of.

What's left is what's needed to find and delete the cache inodes of an
existing filesystem:

1. lookup_free_space_inode(), btrfs_remove_free_space_inode(), and
   btrfs_cleanup_free_space_cache_v1(), which runs on the first
   read-write mount and zeroes cache_generation in the super block.

2. btrfs_truncate_free_space_cache() and delete_v1_space_cache(), which
   relocation uses to get a cache inode's extents out of a block group.

3. btrfs_is_free_space_inode(), for the evict and inode update paths.

4. The on-disk definitions: cache_generation in the super block,
   BTRFS_FREE_SPACE_OBJECTID, and the free space header and entry
   items.

space_cache and space_cache=v1 still fall back to nospace_cache with a
warning.

This also removes the page-based I/O in the free space code.
btrfs_io_ctl used a struct page array and was one of the last users
of clear_page_dirty_for_io().

Tested with fstests (btrfs and generic quick groups), with and without
the free space tree, with no regressions against the base kernel.
Upgrading from a filesystem with an existing v1 cache written by a 6.8
kernel was also tested. The cache is removed on the first read-write
mount and on remount from read-only, and the resulting filesystem is
clean under btrfs check and still mountable by the old kernel.

Based on for-7.3-rc2.

[1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/

---
Changes in v2:
- Split the TRANS_JOIN_NOLOCK removal out of the ordered extent patch
  into its own patch at the end of the series, per David
- Add recovery information for a mount failure due to patch 1 to the
  cover letter.
- Link to v1: https://patch.msgid.link/20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu

---
Tal Zussman (16):
      btrfs: stop enabling the v1 space cache from the on-disk state
      btrfs: remove the v1 space cache writeout from the transaction commit
      btrfs: remove the free space cache endio workqueue
      btrfs: remove the v1 space cache write path
      btrfs: drop the transaction handle from the prealloc helpers
      btrfs: remove the v1 space cache load path
      btrfs: remove btrfs_disk_cache_state
      btrfs: remove the SPACE_CACHE mount option flag
      btrfs: replace btrfs_set_free_space_cache_v1_active() with a cleanup helper
      btrfs: remove the free space cache trimming ranges
      btrfs: remove BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
      btrfs: remove the free space inode ordered extent special cases
      btrfs: remove the free space inode special cases from the COW paths
      btrfs: stop special-casing free space inodes in the delalloc accounting
      btrfs: stop reading free space inodes from the commit root
      btrfs: remove TRANS_JOIN_NOLOCK

 fs/btrfs/block-group.c      |  461 +------------
 fs/btrfs/block-group.h      |   14 -
 fs/btrfs/btrfs_inode.h      |    6 -
 fs/btrfs/delalloc-space.c   |   13 +-
 fs/btrfs/disk-io.c          |   81 +--
 fs/btrfs/file-item.c        |   11 -
 fs/btrfs/free-space-cache.c | 1603 ++++---------------------------------------
 fs/btrfs/free-space-cache.h |   29 +-
 fs/btrfs/fs.h               |    2 -
 fs/btrfs/inode.c            |  149 +---
 fs/btrfs/ordered-data.c     |   27 +-
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/space-info.c       |    2 -
 fs/btrfs/space-info.h       |    4 -
 fs/btrfs/super.c            |   48 +-
 fs/btrfs/transaction.c      |   37 +-
 fs/btrfs/transaction.h      |   27 -
 fs/btrfs/zoned.c            |    9 -
 18 files changed, 226 insertions(+), 2299 deletions(-)
---
base-commit: 09f1294ee2abee7fe1c2d600671498b7642e0fe0
change-id: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

