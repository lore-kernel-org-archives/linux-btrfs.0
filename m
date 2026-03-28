Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DBE3081D6
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 06:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774680200; cv=none; b=CZZIxPqlJmpMiXTFmLJ2uc0AMgL5UP9DwqDHOK11TOXLLUOsqbdisiS5mRfYK/cG4cbviVly2uRpi79D1x6P0By74xetgNuNbOaepWURErfF/lzkynTImqMcmpVaLbCCRbzFhyGTrr8RqVYWsGJcsz6xoNk//5W1i+OigMD4IRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774680200; c=relaxed/simple;
	bh=1MYwq7bz0OCL9OlG1OI2LZ8cBZ1/ORlZG7IEavHnNSk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sWhShEWa9GZdC9laffTunkq/nYuuLFUGiygoi/La4dhMuMQXlHlk//jcpn6gyRpu59zXDWQC09EcZR9Mvt8vu/b/qlQTpOHtt1NoVBeCl9CRl5PNmisv+km6wihBexGgmzqwTC5wjJDrP1qZHJIWFJSac11nopRhhtZbwfgS6rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NWMHipfU; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NWMHipfU"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so26264815e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 23:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774680197; x=1775284997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5FQB/XEvfVTZ5AFJg/genH5wPdnxS6mYQVlhCcxPoYU=;
        b=NWMHipfUiBSxIFzJnpZ8cpKm8FHGkkgx6S2YqZSq1djBtjyx8Syt9BqCaq1AyGX9d7
         RVhrCajAiURDiUlqnWtJwGzoAvqw8FFb7Zw8lfeqjGaklEAuHJGS65RKj0+HVBjrl9Rz
         kVR6So6EvRTj3ex4G9emWcQhtT9kQODRR829Yxiwc0SVFzMUrgX9fYmfby7UXPa72YkA
         WfCNh1XGnyejUHXmvZ7HochfT4U3Im2D++fhxKM26+Qir7DyZ2AyjLkwL7sClthRWkiD
         3yWSE5nxyGUYQO0du2/OAWB2w0EshbvlbSg9MWP0233ADzGeYQazFFQ01h2cCy4YVOD2
         mjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774680197; x=1775284997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FQB/XEvfVTZ5AFJg/genH5wPdnxS6mYQVlhCcxPoYU=;
        b=TYtopvJBkCSG/vx2rrhvdPG3lz7CntRt9vBOTW7KNwZhYcMAqpY7VRIhi9TUux6AgS
         oAOmfbayWsSTw5XdOXdF5JLkvKnbhFuRZ5VllIqKXIWbmbmzivbx5jCInhk13N3tLzt2
         6m3RC1vcQQNP3n3XI5DUWjX/gjRQbEjhA5IS4odSvcwdSsaUOavEkrHmfc7K14Ofz0a4
         S/fP+NHV2Sudd2+3DBIwWMkO3nw9d0YCmmh4QHyj/mfBL025+Z86++c9BDdFAxz5qrbO
         flJ6c0qKOKBkB5nu9+CgKJLJlw9J+ZbifiRdmfy5uyVevGNT2Xm7eE1cQ5w9zfoopd+j
         mgqg==
X-Gm-Message-State: AOJu0YwuUVHEG3Uyh4mKBHh3igx0ufBR8at3NTAxevJ4sLh4L4raOVNr
	Tf9oCiGYaUEfB3/xMFNeSbejcVqborJlk9rybqJIsAxPnKjSG4aSh4SXqf64bimQuBA=
X-Gm-Gg: ATEYQzzdCMd6LMulRaEMAbwVO4kxpfqN74heUTACu+0CJWV6MImjm6Qt9JymY7GCBSk
	H8YPZ/xJ9EQ7TDoqhXWP+Ksn4K8DV5gRaq6LHow0V8bUrV6heMG3oeFYhZGzH/sqPgT25XatTw5
	JZWTmk68fp8YXJbk38V0LSMUFVEQFE+N/YwzVC8izJNl1SUYjsZbqJmjdh4b5dA2EBYKxugSl1f
	W5Bdldohe8+aG+h5fCKjuFvI3YnJd3Q3d7VYBNZpduq2LC4TEY0A6u73GnHv9UZQ2Ds+lan42s0
	1hrQefEGE2TM1fH0oPWLebJMyIbSytCibDDFFBHCsI9I+MvxfxjLx8j6MZN2ZBMn4JaN5IN4xmn
	f6qEfmyjIKulMy0jGXcV4Gw0a4eYk7OI84qdC8CIL0PPpSdqumErBMGts486vEM0Hgddf6HT/E0
	rkQ98EkvYAiYCx8yTnjYU+V+Q4Kgj3YN/B
X-Received: by 2002:a05:600d:17:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-4872911c031mr56791325e9.12.1774680196939;
        Fri, 27 Mar 2026 23:43:16 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c6b495sm270210865e9.2.2026.03.27.23.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 23:43:16 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com,
	linux-kernel@vger.kernel.org,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH v2] btrfs: replace BUG_ON() with error return in cache_save_setup()
Date: Sat, 28 Mar 2026 07:40:59 +0100
Message-ID: <20260328064306.2854437-1-27rabbitlt@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In cache_save_setup(), if create_free_space_inode() succeeds but the
subsequent lookup_free_space_inode() still fails on retry, the
BUG_ON(retries) will crash the kernel. This can happen due to I/O
errors or transient failures, not just programming bugs.

Replace the BUG_ON with proper error handling that returns the original
error code through the existing cleanup path. The callers already handle
this gracefully: disk_cache_state defaults to BTRFS_DC_ERROR, so the
space cache simply won't be written for that block group.

Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
Changes in v2:
  - Use btrfs_err() instead of btrfs_debug() (Qu Wenruo)
  - Use PTR_ERR(inode) instead of hardcoded -EIO (Qu Wenruo)
  - Include error code in the log message (Qu Wenruo)

 fs/btrfs/block-group.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ebf507909..89bfc9db0 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3343,7 +3343,13 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
 	}
 
 	if (IS_ERR(inode)) {
-		BUG_ON(retries);
+		if (retries) {
+			ret = PTR_ERR(inode);
+			btrfs_err(fs_info,
+				  "failed to lookup free space inode after creation for block group %llu: %d",
+				  block_group->start, ret);
+			goto out_free;
+		}
 		retries++;
 
 		if (block_group->ro)
-- 
2.53.0

