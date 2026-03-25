Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C031F4634
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399432; cv=none; b=PuZP5F/PdFnOsLENhsNXSfuZ6pxNv0Y5xbkd26zQNijkMTZzNZ2D4iwvjRJ2rgzLbfY4V0wsSpf/jQ64VscPr+BccrrKhETRDts6SZUoCDjYGzjP+ZFFp84L0mPJrnQk0VVnsBkliiFBZfq2QYpUFvfZlctaPNuHDOIUNiZYbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399432; c=relaxed/simple;
	bh=2ht9qQDNfdrLHS1FvPgF2fZP+ton6311epPWZ2Vj6zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tDppKEmj4zrmRBkFo1laWVH8IKQ9w6G4+NpPZ8KoeqfghgNYq9eDIQD7NpqUg60GRF5SlmQCMueMHSbYTJGEbNNUFF0cG/JL1kM0g0UhMqu/WbU7nasOioVAyVLHL3qoKNOWTBE0PAkvb88htoHR2ikvhYyGtaVMkcX/pDErseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nw9Ef1DA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nw9Ef1DA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2aecefc7503so44944825ad.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 17:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774399430; x=1775004230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4U9wgFx4r1OB3Oda4Pvq16N+UuKhewRZ0htJHghmz4o=;
        b=Nw9Ef1DAZcAlxzXgw8RBOOnDEap7VzMJoao3/VfqyfQdxKEJg7vaRN2NPOndVWa8nU
         HXP/I3e1RXPEx2YnFt2GZS54UF/N0HEnjs3vvjlA/oNVSxzrL53IFSw+r6lUJV3kIysH
         StQd8GpY0FdDujp/wAAL4N0aHyeEhH4FuTAhh9OY43VeEvi4VVOWzY7g58o5PPcUc+iE
         CbuQv80pUXlmnK4w+XN7FJZqNDwk4sRqs324aPzOu3PhCLnsbWT2GGRoRMuQyNlD2xID
         QrCdYhMYr55dnLCiLF5fQhdZ8WGy0pZu/NcoCl3G+IuwNYEeiDMnQVMDPglSS8rGwSn4
         eZ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774399430; x=1775004230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4U9wgFx4r1OB3Oda4Pvq16N+UuKhewRZ0htJHghmz4o=;
        b=qnlqIynY5cMUmsxyxmJfDxugYDu+V9iCO47WejnfOfFy7eocu346pT8lOsEvo++cWS
         rq0M1BmuuuHJzwAHKbIsAv9Ouejx1K5zWcXb1cCyKyxgPvT6313X6SD63xJ8lUxizJ/a
         LAKwR+vwGq4t/C0ajGaDsflVYHUzL3NklRsh84eNwy3wRuVGqwpac/buCYmyqJUL27N0
         74NgFIwEaGxXnPW9Gm+1IIOOH9wciso9HSlwvAd8wynopaONHcr/KLMmnX9KVp2E2hfj
         wXujZxcCqxteYjeoEEwj7sxkwSgyIfScLOJ1t9eFeCFvUHsJvdibhQBCVXATKzOfsMZe
         1bAQ==
X-Gm-Message-State: AOJu0YwXPph6DsvEtaHs4MD4TnS5YYSVUNiNnIskPH0YGyD3nmpWSPGo
	IAxfVMp5PoWcQzBE562ubH0qxnVM43rQCBrPE9C3akST5w/s9E3kvylV
X-Gm-Gg: ATEYQzxYtIqpDNLEkfQFiZQlVaYAM6TVyavs7b3oSbat5m4vzuk2spsOY9FJ9cOKYuZ
	2vMFIU3jMu/X5uMtRhLvik507XNAokCdRw6+6KiUj5BLBr8zDdNNx8uSt/1rWPC/PdRq4J33KYy
	CIuWXdoURAKcvS3rPrkgOgDF9SqENHsaOVZPMY49wRFztdilPOLEU0oKxz7kerbBH7MhJIV1Aup
	PsZA0gWOSg3PeUpPp7KTJJZkB7FTsmWw0hFiRpmRB7hUuXj2qKVhMBweRz9sJMH4dwjQjUiGsx+
	xov56Y6WnAC2z9vAR6aaWRFRiyQq5lKjbpvuUxKdg1OVkogsxp8DyYewuuNBapteB5mrPYbG4Ay
	4wqcLsdNHOeiNYCpcWMB1KJbNULnqMV7Wx/ZAF9a9ayH3xVrAlWtbH34yqqm65xHZD9ay3Pqdv1
	a397bd1waKPrVHShnKL3UbLyYYXzj5oL25pafvbg+s+SG20gHjXRVH//48kLk6AxnUQfPoBRk=
X-Received: by 2002:a17:903:2344:b0:2b0:9a6f:c3b with SMTP id d9443c01a7336-2b0b0b270f1mr17192125ad.37.1774399430424;
        Tue, 24 Mar 2026 17:43:50 -0700 (PDT)
Received: from kernel-fuzz.. ([103.172.182.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836554acsm207457015ad.51.2026.03.24.17.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 17:43:49 -0700 (PDT)
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
Subject: [PATCH v3 0/4] btrfs: fix balance NULL derefs and chunk/bg mapping verification
Date: Wed, 25 Mar 2026 08:43:35 +0800
Message-ID: <20260325004339.2323838-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes three NULL dereferences in btrfs balance paths and the
underlying mount-time verification bug that lets the corresponding
chunk/block-group inconsistency go undetected.

The balance crashes happen when metadata corruption leaves a chunk present
in the chunk tree but without a corresponding block group in the in-memory
block group cache. In that case, balance reaches code paths that call
btrfs_lookup_block_group() and dereference the returned pointer without
checking for NULL.

The first three patches harden the affected balance paths:
- patch 1 fixes chunk_usage_filter()
- patch 2 fixes chunk_usage_range_filter()
- patch 3 fixes btrfs_may_alloc_data_chunk()

They are kept separate because the affected code was introduced by
different commits, which should also make backporting easier, as
suggested by Qu Wenruo.

The fourth patch fixes the mount-time verification side. Based on David
Sterba's feedback, it now explicitly relies on the mount-time context and
uses a lockless traversal of mapping_tree. check_chunk_block_group_mappings()
is supposed to verify that every chunk has a matching block group, but its
current iteration starts with btrfs_find_chunk_map(fs_info, 0, 1). If no
chunk contains logical address 0, the lookup returns NULL immediately and
the loop exits without checking any chunk at all. As a result, the
corrupted mapping can survive mount and only crash later when balance
reaches it.

This series makes btrfs reject the inconsistency earlier at mount time,
and also hardens the balance paths so the corruption is reported as
-EUCLEAN instead of triggering NULL dereferences.

[CHANGELOG]
v3:
- added a new patch to fix the same missing-block-group NULL dereference
  in btrfs_may_alloc_data_chunk()
- patch 1 and 2:
  - changed the bool return flow to explicit int error propagation
  - used ret2 for the nested filter return value in should_balance_chunk()
- patch 4:
  - reworked the changelog based on David Sterba's feedback
  - clarified the mount-time context for the lockless mapping_tree traversal

v2:
- split the two balance filter fixes into separate patches
- reworked the chunk/block-group verification fix so the last patch
  addresses the case where check_chunk_block_group_mappings() does not
  actually iterate all chunk mappings

ZhengYuan Huang (4):
  btrfs: balance: fix null-ptr-deref in chunk_usage_filter
  btrfs: balance: fix null-ptr-deref in chunk_usage_range_filter
  btrfs: balance: fix null-ptr-deref in btrfs_may_alloc_data_chunk
  btrfs: fix check_chunk_block_group_mappings() to iterate all chunk maps

 fs/btrfs/block-group.c | 24 ++++++----------
 fs/btrfs/volumes.c     | 63 ++++++++++++++++++++++++++++++------------
 2 files changed, 55 insertions(+), 32 deletions(-)

-- 
2.43.0

