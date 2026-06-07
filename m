Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBB83A1A38
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Jun 2026 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780834478; cv=none; b=gGfPkb+Tq0rulrfVxBUu8jSHOcoX9m8vGFwO4vcTw8N/EkybI9IdFBdMF1949SZHKHgL105Q5bUW+qkbyFOiaQ8YjWrk0fGRrzziGtZ5NN4KRD9VPGQIxqBsccbWd8GZeln5wXpUPtK4hW+GsOUcNomPfO/E2htd6I7/QXu4PgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780834478; c=relaxed/simple;
	bh=FiE6UWmKTj4zkFa0fuWnezhxPqqYo73daPdQOiRNOc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfPHQdKrIq5HIrQtafQk6pi6Ivy1zlh/hPh7ZWqDaQW5GVqRQcSjia6GMYmb3vr6b/DmiR/hkaq7fv2p9oqdi9+bMvpc9RkxKzD4r0aBiOQsUv+05hQKvwdzLzc6g3nPcV75mxFsjBgd1gNGoXQjaMeUrLYDzMTU3YgGxwcc5us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sU5TIZtX; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sU5TIZtX"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-304f0039c02so6201143eec.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Jun 2026 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780834476; x=1781439276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SlT7mBtwTeVnsGmRF2Ag5t3pcGEyEFo+Ag6NZ+eIYwQ=;
        b=sU5TIZtXSXlm6AfGniAdmi1GagkrG3wp4HvX8Kiv/87Lco7RzszoO116VKyBuTQXnr
         ORgTle4bu6+YMB724YcQjwgT6vMbPTN94f1TgtyPjAGQ7X41QXtd0SA4iHfZ2GRDWj8x
         1NpAfsfYpHa3c0WpzxKAbwIzpnfp7y3A9fK2ABmLdamRuoewGfRg74hi9B8iF1ZFvpuk
         FyB6gaxnaGrc2UqhCVj1c1nQgH/8ObOSXgmFucieR4xqB8qxbPG1Oa/FjURW99HmUXUq
         uSZcR6tkISvt39joWtv49uHObb5lWOq5Z+OtY8HQ/kGjBeEJusHbi8HvBeXHAEX3b9yz
         lBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780834476; x=1781439276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlT7mBtwTeVnsGmRF2Ag5t3pcGEyEFo+Ag6NZ+eIYwQ=;
        b=f5om+J9Xc9MUhEuIHTJ/6VlnaDQO+MHc0gJf15Lxg+nqDf6NVs6DmimSHgPy7UFQwH
         +RwvVao1M4uHvLU0N+5ZkaGRuMYOWmqT5aNuL8ShYmTMRQaTJkw2H3jOSPEf5+lSL0Dh
         pK3+DQpO+iWUqjwkS1wCW0OReVcEQRX3Dj+dZT09ZpEDZGOcQkvSxZhtC9CtzPSCMhVf
         dYGUs0666vtfDI7uqF16pBiTKPaBk3KRm1g8ydYLJz0Bw8azb2He2eJsi9A0zmFFDQmS
         V3tVX6wTM7g+5rH6iRk/C0wJL5ZXVFdd9SrT82+ebe2QEqT411O7N/RJR1CfB2XT2yZ8
         IWxQ==
X-Gm-Message-State: AOJu0YzWqhbX3e6A9EGJwBP5iikA/jpFCfwyJ+Pap7MuFXmj8DmqWpgE
	8OwXK5v71yK0TIQTxfuMPKmCNl4Vs18J3vWwxvS/q5KuM1zMFttJA44u26dEqokii1E=
X-Gm-Gg: Acq92OGXH+9VyuX4x8AkNJPTFJr2bddvMzlY7DFFW1+i8uk3zwIdK0uBN6BkmQ44n4u
	Olc/0CKJBTCkp3vwP/NTPziokv+4MSywPyPrQjOKybB0NaM41tSYdC4H6rKKeiJYlG0z5g5WbWQ
	jNFbaoa0N8wKGX26OY8zZRFZXvzbqcd19U4VY0FV+4R9vzwMEdneJYl9ilR9ZKclB3rzK0yh5HW
	is0s8R2FxhXTz0CkTZCYksdR7v5mJdMMR0vZPhjAHtbyocglSa8jxst5KYHq9tm87d0L+10EQtj
	0ZlLwsJc0BYMjPJMRjxcK9hLDpimFGPYL81DCPZqXeHmiIdhzqRutHHeEWDyZJx9chn3MVWtwvR
	SmcpXoEqvmvqoPqCTaziIvcIlTGUcSKqU59pVq4GT+sv9U6FA/Ut+Z92jYB+a/DJwAmmx1uJnMi
	IJDpltGqfrVyBCRCIMDGg1f+2siVguYTGDqOtBafIQ9KjgcUK3OdJpOEir8bnTpeMPU5VY/dtL8
	9rMEis=
X-Received: by 2002:a05:7300:8c09:b0:304:e2a5:689e with SMTP id 5a478bee46e88-3077b27044amr6633492eec.2.1780834475999;
        Sun, 07 Jun 2026 05:14:35 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db56697sm13837786eec.2.2026.06.07.05.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 05:14:35 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com,
	josef@toxicpanda.com,
	clm@fb.com,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] btrfs: reject names longer than BTRFS_NAME_LEN in btrfs_get_name()
Date: Sun,  7 Jun 2026 05:14:29 -0700
Message-ID: <20260607121429.2091845-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_get_name() reads the name length straight from the on-disk
inode_ref (or root_ref) and copies that many bytes into the caller's
buffer with no upper bound. The caller (exportfs_get_name()) supplies a
fixed NAME_MAX + 1 byte stack buffer, but name_len is a __le16 read from
the leaf and the tree-checker only bounds it to the item size, not to
BTRFS_NAME_LEN. A crafted leaf with name_len = 4096 therefore overflows
the 256-byte buffer with attacker-controlled bytes. It is reachable from
a mounted untrusted btrfs image via open_by_handle_at(), and on btrfs
filesystems exported over NFS.

 BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent_io.c:3742)
 Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
  read_extent_buffer (fs/btrfs/extent_io.c:3742)
  btrfs_get_name (fs/btrfs/export.c:289)
  reconnect_path (fs/exportfs/expfs.c:222)
  exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
  do_handle_open (fs/fhandle.c:230)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
 Kernel panic - not syncing: stack-protector: Kernel stack is corrupted

Reject any name_len greater than BTRFS_NAME_LEN before the copy. Such a
name is never valid on disk, so this only rejects corrupted leaves and
leaves valid names unchanged.

Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/btrfs/export.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index c403117ac..a54c6e8b3 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -285,6 +285,16 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		name_len = btrfs_inode_ref_name_len(leaf, iref);
 	}
 
+	/* The caller's buffer is only NAME_MAX + 1 bytes. */
+	if (name_len > BTRFS_NAME_LEN) {
+		btrfs_err(fs_info,
+			  "corrupt name length %d for inode %llu in root %llu, max %d",
+			  name_len, btrfs_ino(BTRFS_I(inode)),
+			  btrfs_root_id(BTRFS_I(inode)->root), BTRFS_NAME_LEN);
+		btrfs_free_path(path);
+		return -EUCLEAN;
+	}
+
 	read_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_free_path(path);
 
-- 
2.43.0

