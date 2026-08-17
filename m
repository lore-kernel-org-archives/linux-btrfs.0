Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D0E2F12A1
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930065; cv=none; b=SaoZTE3hzcuBZXUdRsl48TyjblYH+29nmY4iEYXW/ty4kmodSUIgLBiDZgyC8yJDXvBMygLYLNtpan8SWnjKtjgV4erPssvXdUlEdWlkEEl45MEFBgkpU7Sh9TmMS5+/AU+QXnkrTUtNX0P96Y5NMjuBM54cHL5FtkpA3PQuUgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930065; c=relaxed/simple;
	bh=gz1xa6XE42BhM+L6sCevqvioIrMnDwgjFYnQ6nyVy2g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XnFymj1N7wzfYqdEK6ODd1wA1qQC2HyopIu0uWOdgzeASu2WZL/+MKyRYe6b58eFpy/RGOcG6UngrWsCs/3l5XG01MViArPYCSC6Y+kITQ8TKbhXenfm4tK/z6jx6Ms9oApYgjQHBGXbdlh/hnxfxDBsblveUUHJ/qMOQyGyFkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvillyJl; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvillyJl"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so16258806d6.3
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 18:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786930063; x=1787534863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPNXN2iZUqAh3E/T0g1Fu1hhmYLYG5QU9GnoWbcO2EE=;
        b=bvillyJluYcb1uRs4di8AaFHs1x8lZxVnNZ3dcqeBGBEJLEqZ8aLD0Qsq+yI1RSz6z
         gOZ6YjiPCGXiVUrYTBQHBeP5T2Lar8OIW+fdPol1zcGa3pVi/OirnMHzXq4YupazdFbV
         GfwmRN9iU4kpo+cr05CwpTlnkCQhv+NQh9bLq7hO4i6tXudhxJCcUgvul8904wO6swuG
         t6bBv7a+w28aR/TNc7wz9yMfPqMnZkh5c2HgjEBtTxuWcIgNzjFDhJ9seM4VY86fjr9s
         rc+04gKUQok5e5YZllMa0hr9SXDejmmmy9OLbJxEv55fKg4/whNmmyM/88c/7006OBgV
         5bcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786930063; x=1787534863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPNXN2iZUqAh3E/T0g1Fu1hhmYLYG5QU9GnoWbcO2EE=;
        b=OHWoLIpDujo8/OdzvqVru3g5R0FVL68zVsMoPKMrLqoW4WBU5hEPtgbChimfl9Z8y/
         7h4JnbF9z+UwMw9AABlaGT3fWUayxr4jgufTWiP5bJK4c7BtI0UtPzgbp9+pzhcG4uz/
         cYZnZd62BoJXYtpJj+fr6PQJ4r4ODIGnI1ErMh7ghjAct56S82wZZUkyHQx67PewGW8c
         AZXl6QtkUu8Kwq2CVxchvI2KnbrPU/xwB2YS3KTMPdCZV4yqx0943eM5aqne0xg4+4Kv
         HCAdUBXHI2xI/Zd2KugRfjAaqpuXKtLx+v1XLEjWCxIpblAWjR0Yc+NNYO51QGRsky8r
         uomQ==
X-Gm-Message-State: AOJu0YxdTgIw2LCLAU3pJ7Wc5pvZQ0EI1V9mqOWtOj3z0smY0ZmpDUZW
	qAmsVgC0s+nbVcNoRI7sMDhS2G08axuPre/ZmecfYUGYrxvxg2eC9uNzYkTVaEHr
X-Gm-Gg: AR+sD13dgc7EhrGMktYN4kGr8pAy3rO9sQPvB4giAjpnEc3WeYWnb/YMMeoT+OzfoUG
	N8I4dLWBvinW5ajuWjse7tDkYx52kJVwyxR9N+L2zJpeIx6gU+hjsSQzuPn3Kn6ExE33feqUe6w
	f2xm1FGyDMdvJxJRbPB0/TdPPGTG8elOn1SAShrsLPJQYbWui7+s2/c57ern1HdS372Y0bPqTyW
	FwkUFMHODe6iktloKDz3dCgSYRFsj3+QooIUAnVpGIwWQqbldn0DPMwdaYdmYQQHoQfg8epcAqV
	sAChf55cykzLtQPx6yq13MhCrwnhP8IvrWFBMqP3hKBQrnB20NfjNZI9JsGCTkiEoQjBH8tsCAl
	UxI1k0a0ul7He7jTZ4fzZn8CeDexcm2md22mab1tD7zx8YWjNQnqRMMerzv/uw6HdXE+fXu+u9Y
	UrWgHsvCWzHfGJvdtXwQWjkdKZdU+xn5IQHS9jESmWHx5xrzPAq/7g7AZgbd1VrZy5ptPO5gw8K
	8pZzty6A1HFJgqqrG/rIwyrjaMl
X-Received: by 2002:a05:6214:262f:b0:8ce:ade5:e8fd with SMTP id 6a1803df08f44-90a91dbc713mr240996986d6.25.1786930063103;
        Sun, 16 Aug 2026 18:27:43 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a93508b13sm72718466d6.28.2026.08.16.18.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 18:27:42 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com
Subject: [PATCH] btrfs: fix transaction use-after-free in raid stripe insertion
Date: Sun, 16 Aug 2026 21:27:33 -0400
Message-ID: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If allocation of a RAID stripe extent fails,
btrfs_insert_one_raid_extent() aborts and ends the transaction before
returning -ENOMEM.

btrfs_finish_one_ordered(), the production caller through
btrfs_insert_raid_extent(), still owns the transaction handle. It handles
the error by aborting the transaction and then reaches the common exit
path, which ends the transaction again.

The premature end can free the handle and drop its transaction reference.
Transaction cleanup can then free the transaction before the caller's
second abort accesses the handle and transaction, resulting in
use-after-free.

Keep the abort at the failure site, but let the caller's common exit path
end the transaction once, after it has finished using both objects.

Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
---
 fs/btrfs/raid-stripe-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index b210371ce91e..89e259a47d8d 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
 	stripe_extent = kzalloc(item_size, GFP_NOFS);
 	if (unlikely(!stripe_extent)) {
 		btrfs_abort_transaction(trans, -ENOMEM);
-		btrfs_end_transaction(trans);
 		return -ENOMEM;
 	}
 
-- 
2.43.0

