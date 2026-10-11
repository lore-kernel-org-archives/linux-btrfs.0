Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1831D362
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791734309; cv=none; b=QaBSwAYMs+r7aNjzFkfb0g1xJbaXYKClWtYhsacQIXpkCsNZrMh222MORa1MP8O4uI0jWK3vUs89jJzL3lJpN5sQ9ktgi0+kjY5WHY3E+1y3i2fRPPaGZY9N7Ru3aNvCwOk1pjnzfBjBXPs9X4p8ohe0pGh8wGU9FWt4Eekd+Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791734309; c=relaxed/simple;
	bh=IvIXragyDbXsVrZjUB1QpSAn+NSlJROmmj4LKC38QJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csZc2T/w3eTJT5RZsymiXlY6PQibyAePXB0exavguxuKDGQWnOFqrMpFj2rJ9qvD7IqLg2yEUr2VmXr5hautzH4RNp63JiQPWv43qIcjxyYflVyZMTVfEv3Xqb/scdjUnvnZT8JCFXVff78Oxl1zgUt0a2vnxOH1qNzu2Dj7Byc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu; spf=pass smtp.mailfrom=cs.unc.edu; dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b=QmR8G/g2; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.unc.edu header.i=@cs.unc.edu header.b="QmR8G/g2"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93d92abf38dso114707385a.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1791734306; x=1792339106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ossy4ZlqAnnaACaITPaVVTxzs5zkLFNVTZN6qPcgS+c=;
        b=QmR8G/g20zJzKEgVvQnPGkK8JAEEBp3Px0hdefHXYLj1iDgR5q/Y0IOSRm7ZrqiL9g
         JF+U2kpsJ7My/xHNF7QGC3PN3aPRHP/77b4KMW1vhU2Q/zuOUJ5ZWpg4v2liVg9R7V+b
         +aA5CM+7jV0ViVup3ryqUKbYw942PjWy++MbDde4axbCg7NUV2L8ancUD5dWXc6wxMIL
         VXbwsAA+o0xCxIk39O/R0IUWA7SW3hX6uLv4oW22PgbEfpBpxudaPsq41k5gt3C4LCte
         nmNetlZuJhpDMwJGqbJHuFhpcIf63hyHfZrAZR1dsPSlHwR6RKffnMqIu/6D9dx7MHUf
         ZQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791734306; x=1792339106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ossy4ZlqAnnaACaITPaVVTxzs5zkLFNVTZN6qPcgS+c=;
        b=Mhu8FRs5iyfTUx9b7RXzGuFwtgqz8xVk03nkvzdDmDdKsPNhalb+pHE8NluQnX8JdY
         qlD636AYewOryP2gbx+6h07K55Al/S1vLT1x5etwTaRZKJ6EuD8lUKKgwB2yy/3RrSCz
         BobxbsGgzmJ+Grn0/qXY8AmSF6GrWXzQu39AEXCTlRTrVtpeFKdaucfryJmEO4Ose9os
         ps+eTxSaKgK0DFqlYzzaR1j7rnjk5kkHKo9MuQXIxQcmcJTDylmDHJRG7+vmHMbx8JGS
         rDLkM4QLLNUj81Dto7ER1A7iogztPesRdYywjrsuB5SZ4AXP4ffOQGvL8Sct8sjDfn+9
         XiYw==
X-Forwarded-Encrypted: i=1; AKwUvBwLMUxeATeALyPE8CGiWQqxzGWFOzXZj2RRHXp1XEWdQd9IggGs/CKRspUShZA0Bt59ri5rQm7fQcggRg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIMdUzpJEVLJJQ4Blo1bDlQLs3xGDrWLjWj8b0oLCDtrYBJEMbv
	MuG7FY5x8VXPbEPO9XXplIGcbEbM0NSaVRg8R0wapFth/0g0wbJhn9YaVY7jt763Uw==
X-Gm-Gg: AYBFou1nmoyb7bO4aDAAeVUFN18bUG2SYYLEOXKM5/ZrC1bH8/Ig+HclabCsK7JZM6H
	hBBuwBMxqDa86S3O5G24J1iBHjmnR5jSeyFIGw/EK+uEHQdor0fn60FvTPqOYmHLEyhJVEdYyPe
	F0qTWAvhJozNq8uAHjH77/jWV+TRredOj+HMkHXcDvXVNigeqjFgjopgUhFcPPTnLcS7V9FTeSx
	7v1/lkYb2GDLGcdJ8JtVbSBxmfDz6vNqyVftVXOYAoln1Z4NHpQxPKDD5Ex5sHpn7+GOQSETPpr
	60S4ZlG5qQuaPjVh1XJRvs37wjCr4lVNLQnmSJgaXI+eqo2qbKPktkt4pv/pGZa+jO4hL5Rscjn
	yufX6Ni4cxyneT7xueTxPqQ8X+sOS0vS+3JNwrmZ8/Jft2bLT2IlkkIkvqZLeFtEpQz5cqX99N2
	tAifNH1V2VkEIuIQMUAlTT7xpqEY1HOiLt+queRnD2MVcqlXidU7QQV7B6Pn4J5CcgxSnx3nAR6
	u8CONbnblJqgtxOCHMwsXwnHjhkKMH7
X-Received: by 2002:a05:620a:2681:b0:93b:d79b:9a5c with SMTP id af79cd13be357-93ebd28bb9emr1226124585a.61.1791734306512;
        Sun, 11 Oct 2026 08:58:26 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb984889fsm666517185a.13.2026.10.11.08.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 08:58:26 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] btrfs: fix chattr failing on nodatasum files that have the compress flag
Date: Sun, 11 Oct 2026 11:58:15 -0400
Message-ID: <20261011155815.1563812-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit cf1afec09e9f ("btrfs: validate properties before setting them")
made btrfs_set_prop() validate a property before setting it. For the
compression property, the validation fails with -EINVAL when the inode
has NODATASUM.

However, chattr writes back all the flags it read from the file, and
btrfs_fileattr_set() sets the compression property whenever the new
flags include FS_COMPR_FL, even when the compression flags do not
change. A file created on a filesystem mounted with nodatasum has
NODATASUM and still inherits the compress flag from its directory. As
of now, chattr fails on such a file when it changes any other flag.

The issue can be reproduced with:

    mkfs.btrfs -f /dev/sdb
    mount -o nodatasum /dev/sdb /mnt
    mkdir /mnt/dir
    chattr +c /mnt/dir
    touch /mnt/dir/file
    chattr +A /mnt/dir/file

Before commit cf1afec09e9f ("btrfs: validate properties before setting
them"), the last command succeeds.

After that commit, it fails with EINVAL.

This patch will make btrfs_fileattr_set() leave the compression flags
and the compression property alone when the call changes neither
FS_COMPR_FL nor FS_NOCOMP_FL.

Fixes: cf1afec09e9f ("btrfs: validate properties before setting them")
Cc: stable@vger.kernel.org # 7.2+
Suggested-by: Qu Wenruo <wqu@suse.com>
Assisted-by: LLM
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Changelog
v2:
- Do not test whether the inode can be compressed. Leave the compression
  flags and the property alone when the call does not change them, as
  suggested by Qu Wenruo. Setting the compress flag on a NODATASUM inode
  still fails with -EINVAL.

- In the failing call FS_COMPR_FL is set, because chattr writes back the
  flags it read. A test for "neither FS_NOCOMP_FL nor FS_COMPR_FL is
  set" does not catch it and would stop chattr -c from removing the
  flag, so the check compares the old and the new flags.

- Explain why the call fails.

v1:
https://lore.kernel.org/linux-btrfs/20261010105425.165104-1-hengyul@cs.unc.edu/

 fs/btrfs/ioctl.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 52aab510aea0..43a945345cbe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -375,6 +375,19 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
 		}
 	}
 
+	/*
+	 * Callers write back the whole flag set, so only touch the compression
+	 * flags and the compression property if FS_COMPR_FL or FS_NOCOMP_FL
+	 * changes.
+	 */
+	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
+		/* 1 item for the inode */
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
+		goto update_flags;
+	}
+
 	/*
 	 * The COMPRESS flag can only be changed by users, while the NOCOMPRESS
 	 * flag may be changed automatically if compression code won't make
-- 
2.53.0

