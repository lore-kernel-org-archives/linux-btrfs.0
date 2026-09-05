Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD733168E6
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 11:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788606447; cv=none; b=neC4gk7TctC7ESd7XuagW8w5TKQWoc673WdOyN7O/8GuUWbLBEGCx8L5Tc/cOOjEkAXRibE1J+bHenrY2lVW67ChRCgtgEKfhrieglS3r+XowNFfO+9nYrUaUb8i98Ac6hhG8Wwg2rno0jG9SVpWsIbU47aunIa0JGL/oexP0XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788606447; c=relaxed/simple;
	bh=ypaOgYr8SkldlyI5CBUa4bdeiCX+pOmT+GE7aoozdv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hl4dEQuDYcn0dWyc6gFD/9GwqxvY3gtAGOH4effjxjb9bsPPPhV/FTRCnXH+/O6YnFuc2qMU8GmB0UYk5LZX31w9Dh5iOJjw5J5LNRS5Jq/l4b2lbl/VPqdVoQjfnvE+SqELTZKpDjOd5AqDiZY5M0sCACGijqAb4BTfUA04SiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9jtBriI; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9jtBriI"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso1240076a12.0
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Sep 2026 04:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788606445; x=1789211245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yl+A1TCnMoj0CT3g6Nbon3RjU8W/dyxhnmvmd3XUicE=;
        b=d9jtBriILpJ2Cg15vd1gY7x2PNblfmEbt3Aj2fc44QJkyev+f3XCNG6POCOwCtmD1k
         PMe4ZkJf6s2kDaOYSWX5IM/Y+nLNtLS0XoeuEn30JRomdKP/bqn6JufhS/d9UlPxHekB
         16RrUBP6zgOUXTmqosV7kM2BpY/kENNAl7yJuOVD2MYsHbBFtoeOfYDgbbK2po2RR7tN
         Tpx/gI/4BOMIG7qcget7HPNRRx5fZCnaOu1dXueJyhnKWGQkvOrz/cJVWK08/I7rYIDS
         DhpiRcPSNQ3PMaTgBE84Z9ifLYNhGC2E/4JVaQfLy0KZ8r1N2y1VMR2zDmVZ1C+Bx4CW
         MrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788606445; x=1789211245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yl+A1TCnMoj0CT3g6Nbon3RjU8W/dyxhnmvmd3XUicE=;
        b=sm85PtkgfR6yDAY9hC+ve62xxAHB9RsUcnxWIIl7Ykun8UnLkccjEQPZqRO06HAWKw
         B4EjD/+uM9g3TY/Q9clJkzjfIycEcleSDTnRHO0pPXlQxgl7r6VtwzOZJXCuzfVlK8VV
         /CNGGOiFcmejllkdTKQzKY0aF0A+kMl86aYqJEH25iN5Y67TjeBrUQe6QwWGnmAjivCJ
         kYaNv9EgoigWclt3bKifnSMz2ly46+SzXMtKZpBhE/MIxagMexRPYJsbH1U3IhUZGu/j
         Y333eDMQoFG3A5boAan8Ex3RXUrYjs+QHkFAfurDjUL3WevP1nDnbt2FSCNqtoU6eZas
         QCqg==
X-Forwarded-Encrypted: i=1; AKwUvBykhhUbL9zrQ+hICojH29YlN10XbA3KxygqZZqb8HcyYoh5C+95XU+uhVG3DHz3pcwBv3TX1BHycMd8lw==@vger.kernel.org
X-Gm-Message-State: AFuF++mO7lGG1XuEbTvLdFBObGEUKEKuPSdGb9vwpzliSDblX9+GnXjG
	dghF6Ri9jSB7zx5/wtl4QaD4QFX4WBYPrfC9GhR8hF7LTai0Fl6PcHst
X-Gm-Gg: AYBFou0Yoi0YvS8B+fvGs54V9wVUL/noO5cwntB7zmp/zbacytAI+UqlrRbKYTW47BC
	ue0h4G6aGhESInLcIF5okUnqopkZ6PyILJ88jSeSSPR7eiVWyOtJ3uABF131SI8yE7f9TUbRi5F
	3Upa1ZJ85HsG8prVsSPwxOrlwJrgG03UIHsvom86qBU1Wa2bxRh11qKhfoOYEznQboNbKdUieS8
	dPR4QI3CuUHRBxMNn9Ks0sRFQbooZEnEDcWzzi0SJ5iwTJqn44zZz6omzTWg8z9wBUFm7b+VuGy
	f3vem9sxbYLzWgP1+f09Wnoh3O70GZPoAvSfm0HP1gwB49Ta/GUfZOrAGeyvFfpqh+nL/xsImYL
	b5UvWgx0T0Fjkds9CkWRakLCtmZ6rMxu1endAUhWmRwgg7P1wPJvhngbU9cml6eHtWkcikixIFd
	chsDmD88/rnEHBCPkO/M1n7VnRtKQjIH/j1frAAsiUqemYQrMA6tDU1Ohb7z8RsZjo9ogKzooJA
	/Q9cJUybQ==
X-Received: by 2002:a17:90b:2687:b0:398:9c0c:7c71 with SMTP id 98e67ed59e1d1-39b26277b88mr17422556a91.24.1788606445325;
        Sat, 05 Sep 2026 04:07:25 -0700 (PDT)
Received: from fedora.tail24a085.ts.net ([14.241.170.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b083e4fafsm15614755a91.1.2026.09.05.04.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 04:07:24 -0700 (PDT)
From: Mai Hai Son <haison120404@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Mai Hai Son <haison120404@gmail.com>
Subject: [PATCH] btrfs: wait for RCU readers before freeing a new device
Date: Sat,  5 Sep 2026 18:06:40 +0700
Message-ID: <20260905110640.152156-1-haison120404@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() adds the new device to the RCU-protected
fs_devices->devices list before completing the device-add operation. If a
later step fails, error_sysfs removes the device with list_del_rcu() and
then frees it without waiting for an RCU grace period.

A concurrent reader such as btrfs_ioctl_dev_info() may still hold the
device pointer it obtained under rcu_read_lock() and dereference it
after btrfs_free_device() has already freed it, triggering a KASAN
slab-use-after-free report:

  BUG: KASAN: slab-use-after-free in btrfs_ioctl+0x58e4/0x5d40
  Read of size 8 at addr ffff8881176fa870 by task poc/84
  Call Trace:
   kasan_report+0xe4/0x1a0
   btrfs_ioctl+0x58e4/0x5d40
   __x64_sys_ioctl+0x121/0x1a0
   do_syscall_64+0xf7/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Allocated by task 81:
   btrfs_alloc_device+0xb0/0x3e0
   btrfs_init_new_device+0x4b2/0x3660
   btrfs_ioctl_add_dev+0x179/0x430
   btrfs_ioctl+0x11e0/0x5d40

  Freed by task 81:
   kfree+0x1b8/0x550
   btrfs_init_new_device+0x56b/0x3660
   btrfs_ioctl_add_dev+0x179/0x430
   btrfs_ioctl+0x11e0/0x5d40

Wait for an RCU grace period after removing the device from the list and
before freeing it.

Fixes: 39379faaad79 ("btrfs: revert fs_devices state on error of btrfs_init_new_device")
Assisted-by: Codex:gpt-5.6
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mai Hai Son <haison120404@gmail.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9b66eb584..af59291b7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3133,6 +3133,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	btrfs_update_per_profile_avail(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	synchronize_rcu();
 error_trans:
 	if (trans)
 		btrfs_end_transaction(trans);

base-commit: 4d7d9486c04d917265f64c55bd23b2cc4fe7749c
