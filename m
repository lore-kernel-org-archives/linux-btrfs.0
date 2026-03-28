Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2905619CD1D
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 05:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675329; cv=none; b=ZYlPqRoCY+Ws6Jew0cMPt3vGss8CzKC4ENB4EawVhl8miWR1dmgzRpqhJWVrYv2u2YGcRwQFCIJpoRoFa2PGdjArK+j9Y+aROrgL5RNFeO3tSgvtElBmHkz9CH3RzALxEviLkRCl9hQnI/8DNdwSCj/WJJzKQblJu34RXiTpDFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675329; c=relaxed/simple;
	bh=dcQeKDkYGVVmMnx24hx4TZCli0RvFfCeSDGoaf+vPLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bzr7PBpJqnkdVfZ3rcc0BqlCoktkGFhJNZwvhgJh8E+X60zrh/cJAF7RXIyeu+D+9T4N+o1BhR6sovbEa76V0zx9RtRet/H2p+BhOLxRg1VUgc1YKreacX0l6lw0aEQptYmI2tePRdZMBd5bHXei0YC4XjRBMXCtTlr9WCyf/+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YaLNuCnE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YaLNuCnE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486fb112c09so27792955e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 22:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774675326; x=1775280126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I+Mius0+XGLyMG2uc3pkWTqFMXSmcabvcpYYTosMp80=;
        b=YaLNuCnEywZLVPAjmTnmKnhonBZJzi6JoOcZYxLXr4fWKi1gT5RYk4HKA2ScZsZm7X
         piDdZHXsKshcGdZ2IvygddYUSawa/fOoXRFep1LklDg7fwDFeqdPAT3ULomVk4jazenb
         Kzn3TAg5TMPVyF9Q45f/gEaBwYY/XTwTAxJPuKqvpvgWtBuWtVHFa3GHFkftL6RoayQk
         9VlldmUrIfz4iCuFLyonU16k48TI9T0iknLab3bUOvF6GHi+bMB4/SJinsvvfjGbFr7H
         c2t39tRt55OKcg0xs4PI6NlzPGcB5s8IXA7q1PuswwRYE9l/blaqeWJ34YNcSmvlIYV3
         4BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774675326; x=1775280126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+Mius0+XGLyMG2uc3pkWTqFMXSmcabvcpYYTosMp80=;
        b=XviS9/8e+zRiQaUKIzQh/mj2fZWOvQmF2ek+vAlg9v3pR2ErGbk/XS9unerWjDyjwy
         JfkrmtqKoas4OaAdugn47Sg+mvMsGwFGbry9+ZxSuARtMUhwPE9VRKpstz4VwpR8P7hb
         L/o1PD2Q6JuE58YYIvE7+CQAy0qf8bjJrddRQ3+XDL6Xg9l4/WyZILsHgyV3LY0nJmca
         wbV6Miy5D3A0lbkUDwAsqYkqCegX3MCQcF+sQclmX0cFfpzAQdih9h+x9IxfXqksFslz
         DNMkfbGMopIHu0E2dk2UhDmTAxLEIDXslQ2U8JGCpuqCZ4TbGTxU0Q7ZMAs3LVpAJV5L
         iM2Q==
X-Gm-Message-State: AOJu0YyopEPnr9rZ9w8XlsBOztdEzfteBQkrfn+kAzLdJxHElxf1rhL3
	Z+5g3XW4arv3IO8IjO3qCxAP+CjYWXvUjzab9J1SwECwcwxvwMcn6KsjiM0jYf+DAhE=
X-Gm-Gg: ATEYQzztTVoUL3wAk03Gd2QihKmg3zbOmZporQPdmltFJEphWKVInn3jvkxpSURHnet
	7w5aelMpUHSUEylX11O6u3ecXO+jRnw6qDvpQJYGAG1aDCJX1o7vlpEEJRP+Runs/d4/M6LHlYz
	xM0gRbIB+uZ+7B/O2h5+w6fld/IfNdlBlnzdD5tLuX69RdLrTnaqXaj0zhKlCJaaGOdvGnkTAXp
	v0F5fPrJ8JwEGZgTideg/N428UAAGAlvWgvZ/GrOlEbzO/TYzf14lj4RkO5SMPfRl8aIwqwCNYr
	2WU2ynimQxSU31mEiNaSB183CIvRrXth/YL6Io7igFfJo5pUnGApoc8JHpRfTsKX0KPC7iqJYln
	iR5Z6CvAASxY0qfQj3VVHjV4kQdQvPWm3ZmB/Y41uqyE7CuQ/Hq07iFunypbHrw17DHWHs08jKU
	pp4NjrkbSlcJIo4NJaND15Rg==
X-Received: by 2002:a05:600c:4f53:b0:485:45fb:3472 with SMTP id 5b1f17b1804b1-48727ee9872mr83895815e9.7.1774675326014;
        Fri, 27 Mar 2026 22:22:06 -0700 (PDT)
Received: from localhost ([145.40.214.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d23679sm251237445e9.9.2026.03.27.22.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 22:22:05 -0700 (PDT)
From: Teng Liu <27rabbitlt@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	clm@fb.com,
	linux-kernel@vger.kernel.org,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH] btrfs: replace BUG_ON() with error return in cache_save_setup()
Date: Sat, 28 Mar 2026 06:22:00 +0100
Message-ID: <20260328052200.2838989-1-27rabbitlt@gmail.com>
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

Replace the BUG_ON with proper error handling that returns -EIO through
the existing cleanup path. The callers already handle this gracefully:
disk_cache_state defaults to BTRFS_DC_ERROR, so the space cache simply
won't be written for that block group.

Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
---
 fs/btrfs/block-group.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ebf507909..9f71362ba 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3343,7 +3343,13 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
 	}
 
 	if (IS_ERR(inode)) {
-		BUG_ON(retries);
+		if (retries) {
+			btrfs_debug(fs_info,
+				    "free space inode not found after creation for block group %llu",
+				    block_group->start);
+			ret = -EIO;
+			goto out_free;
+		}
 		retries++;
 
 		if (block_group->ro)
-- 
2.53.0

