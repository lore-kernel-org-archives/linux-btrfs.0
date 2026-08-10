Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E545D396562
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786355229; cv=none; b=uQElgnsNvNT9UV2Hlb1xEQU+vJrI+48G9T25LOIN5E6QSUUY1XC+Eb9h+Ie6cA+r5AqlVjScHkNeZgY8GMLP0z+idH928KMMIeJUm6mGUURunHg7XGOGmF+jPh0a87gekPsUMND9/ig2TCjRQozs/CYF+Y5fMmK4KJYP2DHSRfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786355229; c=relaxed/simple;
	bh=xoG69CcLj1RffYuQvFhXEqg3Ihe85zezuVpz629o4DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGwClVeqNbi3VcrALOOWdiyExwws0jzhLw0Gu6kGpyc208Z2duKN80vCjYPevmTn+x9GVsnU30d41w6gnAHheNYctEXO4J/BQtHNR/zZtUxUlZLs8tgz0VLd1k5KYhZ4jTi8Wq5UO8WmdhWPpXvAZeL0l6w/kgAvRfsRxwag5Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fVfjBaBq; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVfjBaBq"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47fde295992so1276548f8f.0
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 02:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786355226; x=1786960026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h82Mzmw0iUFB8+VfIJrhKcrh1YoeZ/U7bPv3oW3DrCw=;
        b=fVfjBaBqvy7awAuzZ0RfcPlOOeijCH9RgD0X6yxweGQRo2sUPmkX+ieOMg3VihmCpD
         A8eSY1UXGY1juVmsRf/VYOSn64PnTLM66BNQVeY40+zHSTlIX30kgevJQo/bgD/QfhSH
         Zs4UuCkNZnjecARJ1PiCKnTJWo9TxM2SVdG4qMChOHS062kf3YYjDgRO4K8NeaY9VMqy
         2EI6/H9+4mcxSKs2XB6p+T1DD4Vo2vZdQJ+U1xnk0dIapRDhw8e2V8CI8AzPPC8PGXB0
         XA/Nrh4LwuNmHLUzzbWnzXWwIEZJebH9HbNuF3PZBgs6rSZEzY8nzLMZnqo4ZLhQ77SA
         hZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786355226; x=1786960026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h82Mzmw0iUFB8+VfIJrhKcrh1YoeZ/U7bPv3oW3DrCw=;
        b=EFtLVMBApv+RPMEDtbE8P4nvcpnE5u4pR1HWG578x4PdZbVZKRChutczQ+6FgGTphG
         LUbsKUjFKr/33U22Snh9SWpYcSjIf8Crq90O0X8ghUSi1uJLcXUQdN8ZJs61sCvL7hIv
         9BCLvGkOKogBU4OlGRelEmj3skKIGNF/LlvrVdLNq0mNq3yb9p/YLg1a4ljAwkC06m/G
         tLxGlKe1rKZi8eqPp/ocTAQA4+aLTVtswKgUBj3nnrr6AW0kYcgiNWlZcopaxIl79sPb
         LLaC22c795g4cplMuDWOjU/gcy+EyRSWoXXmouPT+s3VOKgow/WFkRUvxeYvGk84DAJl
         T3HQ==
X-Forwarded-Encrypted: i=1; AHgh+RojinFmPfg3ZpeBraVFYnbepZstBvRnXs91/q9+LQo8BgD3iVC5NCMe4/9DHhPU6Q4hS2bizRt+a3ZJlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTZthuDvOKcojsF6LwGtlzaqY24lvIr7TrVfKHOtzljujSLulq
	XVbS+DEZeu+qEBZS09MTe6+kxdOy1ahNqwoF2os+XggG00iut8iG3vCv
X-Gm-Gg: AR+sD12LuMjGo9EYJKiT1zunrXfl5hKdr4xjaBvLXhKUddQEIqaBZmabi3ePPzvl2Bj
	nwn5K1MywidYJR2a4lnE9QcQVKsX4x6vHBh2SmqGDduEdGpHS1cD4uu+/+XkoKmsUoDmZ2o1ImP
	OLkWmo0laqb2oFNG8DQSSCaAHGu6HOrCENgmv0keo4z77OqPXIDlrNSSdPd59Coe2Gdu/pnIPU4
	McjBTyg1L+1gqdQ7aYVs6rmAbSAL0XmFLoKmOnzFeSI1olKI/UQLyLJDXtlRgXBV6xb1bFWzaZd
	GNGPVixgtV+ESOZeXuaTjslD0qmfKNf04SCvpQCO8aVAMXJosWQWoLfSFuOOHfqRhDW61NKqrVv
	aYvijpmi9DfOCmCN0tQ4w5tqaZRrXeXcNsKx7xoih8YsLU0gzhdvbWAXT5UPYUjxiOQwX3V45FX
	0N+0mdQBpEstL309gH7jW/GSymne47WPt/NyHp4H8IR6Btgq1Q2Nmm3Up3hsulch2ak4fJAG5YX
	qOXzRlEvduh
X-Received: by 2002:a05:6000:2889:b0:47f:90f1:68c8 with SMTP id ffacd0b85a97d-48131915e4cmr23775011f8f.1.1786355225923;
        Mon, 10 Aug 2026 02:47:05 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:9845:412b:2e1:ab73])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4813ccea399sm17174580f8f.13.2026.08.10.02.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 02:47:05 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>,
	Filipe Manana <fdmanana@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] btrfs: send: propagate errors from is_inode_existent()
Date: Mon, 10 Aug 2026 12:47:01 +0300
Message-ID: <20260810094701.1349706-1-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The direct-return refactor in commit b3047a42f55d ("btrfs: send:
directly return from will_overwrite_ref() and simplify it") changed
will_overwrite_ref() to return directly instead of going through the
common out label.

That resulted in a negative return value from is_inode_existent()
to start being converted to 0, making lookup errors unable to be
distinguished from the inode not existing.

process_recorded_refs() expects negative errors from
will_overwrite_ref() and aborts processing when it receives one.

Return the value from is_inode_existent() to restore the previous error
propagation behavior as it was before the refactor.

Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_ref() and simplify it")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 3ae480c7474b..a888202397ed 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2066,7 +2066,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
 
 	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
 	if (ret <= 0)
-		return 0;
+		return ret;
 
 	/*
 	 * If we have a parent root we need to verify that the parent dir was

base-commit: af5534fe2fbc006e83d75d6283dfc5ec75d5d780
-- 
2.43.0

