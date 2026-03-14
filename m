Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE7F4A3C
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491872; cv=none; b=E2AT7t1aR1l4XQqP9X6Tzbt8HmdCxHr7pYX+2gw3nhWrw6fDc/Xv6T8rwYXOeUVNfJBYpEIf/L7gg+h4aENAc7AEkP9Hw44NK2PXqt24dDel4s9QEJy/jT2ESVONhWEkdL/yUWUqjQAR199kNHTWEh44gef7lpGCWSvLQyRMmXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491872; c=relaxed/simple;
	bh=1EttMn2WyrlAL7EiN8TRNM+MsBSVVAgFeIpbT3Ge0Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oTF/2QoX9P4TLjI/8eKftE8ZOkFtZvun+zUbNF1kvyIjPGB171bZtR0PsVMzK1b2pBKPGxYuarKAAS6oOiAPBpDCkx39qX3vOhoAMiAuoCyXJgsMRZNbFDy/CdsrDrcN0dPm9cBgTsFYkpb1Mqd0ooRHdWKNmXa0wjtsZGDXmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mPuX9/8Z; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mPuX9/8Z"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ad21f437eeso24432175ad.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 05:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491871; x=1774096671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cI9qA3YsUWUIm5OkTAeFYumy4qZ7WkJ6k0zEBLCN0zU=;
        b=mPuX9/8ZVD0JY8xcwjhWNTCeKEHCU1I2nS1IQkKgwAqaKcQ3hFcBjZHDXcYTSaY30X
         XaUJzLc3EubtA2ZsZBLVl5rWQP/HGoCo54IAdNTJqyZR0gBJXpXGL6nAt75OTJ4tsjsq
         LxsrBYl6oZMEsGtEJCTNstyrNCjxmk+B8BPoOiKTg2nViVAVs/mOf87HyFW0k1xVMbEH
         luniAFEZT7MChODdvz+2ASrX8QwuJ87FnojutswLvUuVa20ecC9lv8SgKPoUVGPNOuRZ
         77Z4YlEMBoM2T7F+cVoOLIR7wJ+rSC7QV2YZKFuyr5ry9GjlH6n334wuEnoQvLhwz1Sd
         e6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491871; x=1774096671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cI9qA3YsUWUIm5OkTAeFYumy4qZ7WkJ6k0zEBLCN0zU=;
        b=GntD/hYh/da+Ra0xK6XuCaXmLnBIjzhvYbGYlpO05q+IGFgWKotU/JcMECfZO83Gjb
         nP+tjyRmygrIr7JcOxKZ3Zd6pUUVCAXL8daaxnQRFGk+xrERinRYMryQaw1SB0SyI2et
         illFMANg9ByIwziwegBuxN27hRWA3h+TO19J0tLEE7jJJwf2MzQEaryG9hHB/5RwLI+a
         RiVVGRxaC6FzE/YkiPozeOZrKn+8SY/Zx8l5CACY0BeFTmcH44RTIKyiuwknXuSqQjzq
         bOQvoYNFsAXUvrCDmv96dcSQ71DdTQ74zkCPkoQqzidf3wbyaCpg2Gl9zi27LwHidl+w
         IH9Q==
X-Gm-Message-State: AOJu0YwnUb6FXKxD0AdJFsTIiFWYf48bn923+OgBHF/fstiF/erLMPhc
	rT91zV3Lz7al2nioPFn3zuHxZLLECNnkejvIoifXBHU2IcHQHN1VI/in
X-Gm-Gg: ATEYQzy76DtE86Fm8D7vy5TsWNls0D8tQKbDmwuDKXWZphthp+b+QrdBgbWXKg3QYik
	f4LmRGg76kvb/D6sqd8+YDgAMF/vjA25rPqg3dGZ7cuEIx6CY9/DQToPDtwykUpog74eYGWopzd
	0MB5o32WhSagTi4kHCSes30MbuJdhD50LxsvooEYIftuT6az16r0DEAsXfz64Yfy/YIWjMovNNB
	I31frmQfyBBjuKGHM/DnMMcYIkPxkBHDzxfknZsjQAqxm8CNyeKASPrKIHqF+xWNzEj4rvzaGtD
	JH9xHvVDERdiZuRsLLf+LWAkSjaDIAu2Flcc9nZoZ1kW0pA6F58GyEX/Pgc+qAFOdP+gnCuvVE2
	3GnYzv5c+ygZ0dAhUNgp17MC+bHyL603Hy0qtaO1ifpM+nxHvJNW7HBkgLnQI/+TKHvnjzDbsFH
	5uJkywRcsdoH7B0fIrYWRYXsNUMpvvPF16VZHd7fF4RPRFWjQjJIvpc8t0kXlOpkWFjdtDK58=
X-Received: by 2002:a17:902:da81:b0:2b0:4c68:283a with SMTP id d9443c01a7336-2b04c6829b2mr616735ad.6.1773491870733;
        Sat, 14 Mar 2026 05:37:50 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.183.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56e0b8sm63561935ad.16.2026.03.14.05.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:37:50 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2 0/3] btrfs: fix balance NULL derefs and chunk/bg mapping verification
Date: Sat, 14 Mar 2026 20:37:38 +0800
Message-ID: <20260314123741.1439792-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two NULL dereferences in btrfs balance usage filters and
the underlying mount-time verification bug that lets the corresponding
chunk/block-group inconsistency go undetected.

The balance crashes happen when metadata corruption leaves a chunk present
in the chunk tree but without a corresponding block group in the in-memory
block group cache. In that case, the usage filters call
btrfs_lookup_block_group() and dereference the returned pointer without
checking for NULL.

The first two patches add the missing NULL checks and propagate -EUCLEAN
back to userspace instead of crashing. They are split because the usage
and usage-range filters were introduced by different commits, which should
also make backporting easier, as suggested by Qu Wenruo.

The third patch fixes the root cause on the mount-time verification side.
check_chunk_block_group_mappings() is supposed to verify that every chunk
has a matching block group, but its current iteration starts with
btrfs_find_chunk_map(fs_info, 0, 1). If no chunk contains logical address
0, the lookup returns NULL immediately and the loop exits without checking
any chunk at all. As a result, the corrupted mapping can survive mount and
only crash later when balance reaches it.

This series makes btrfs reject the inconsistency earlier at mount time,
and also hardens the balance filters so the corruption is reported as
-EUCLEAN instead of triggering a NULL dereference.

Changes since v1:
- split the two balance filter fixes into separate patches
- reworked the third patch to fix the case where
  check_chunk_block_group_mappings() does not actually check all chunk
  mappings

[NOTE]
Some of the changelogs may repeat parts of the bug analysis, which can
make the series somewhat verbose. I did that intentionally because I was
trying to follow the usual expectation that each patch should be able to
stand on its own and explain the specific issue it fixes. In particular,
I wanted each patch to describe its own immediate cause clearly, even
where the overall trigger path overlaps with the others. If that is not
the preferred style here, I would be happy to rework the changelogs and
resend the series in a different form.

Also, in a previous reply, Qu Wenruo suggested adding a separate
chunk/block-group consistency check. After looking into that, I found
that btrfs already has a function intended for this purpose,
check_chunk_block_group_mappings(). Patch 3 is based on the observation
that this check exists, but due to its current iteration logic it can
exit without checking any chunk mappings at all.

Since I am not very familiar with all the details of btrfs internals, if
my analysis of patch 3 is flawed, or if the fix is not the right one, I
would greatly appreciate any correction or guidance, and I will revise
and resend the patch accordingly.

ZhengYuan Huang (3):
  btrfs: balance: handle missing block groups in usage filter
  btrfs: balance: handle missing block groups in usage range filter
  btrfs: fix check_chunk_block_group_mappings() to iterate all chunk maps

 fs/btrfs/block-group.c | 21 ++++++------------
 fs/btrfs/volumes.c     | 48 +++++++++++++++++++++++++++++++-----------
 2 files changed, 42 insertions(+), 27 deletions(-)

-- 
2.43.0

