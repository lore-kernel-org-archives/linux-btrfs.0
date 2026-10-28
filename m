Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793189705;
	b=H5jp7og83YfU7Q8deFyBOl0wZYXr08VSN0c3eCkPz0FwklOrRTfOQ0eUjaamFYNVSykY
	 dFnzP1G17lWHeC6YFpNwfFPRmZ0fusCCE/nG71y0awo/iZWcU4gTEbukhOqd0bjLl0IgV
	 8BYGsDrchF2MO3rA1vIGczBa4jwIbEUsqGlbgkcvto/0/y8p5yIT5Rek3iWRn4XXEx8bH
	 8yTjYbWyhURhjkfTITbx17IJ/2rfSuTE4UCMhzbzaOmW8HaMnHoLCc76JIhg8LuSpoc2A
	 1fhcJmygTw8BZpSzNbMnKKIvkIDvjxNWzBiWr+FgAADjv3XvITSwuL5pNoc2d/d69Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793189705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=8KxBRO5Re9XYDN/KL2CHYqXPi9yMnF5dDqV6a6oJZqs=;
	b=ROA42wBdz8fYVwQXzYYhr6GnFLna9T0dlgbOQZkSCnhN+sGMLF8B5mtcQ+ctGWIxkuE1
	 f5IfpAH0AIJewTdlL0lhEqcynBfQPMIUB2LlnB7QblKDq2XNymrm7MMWxlyV+zk831wkm
	 Dq8KqMx3jqe7Si9ktDruHsMJ7HfFXUPZKLpa9qfSGOlIKEgiPyXhI7aI5+wGp7U6dj0cF
	 5NcvptcOGVsyT8tpcyitucCnGcqHIJlWh0GmBEyF9pK4GOqgq5CQFgVywQAhnZvUSQfwx
	 Xm4njZGPS5ShTBP2GZ5N/HYgn4GaOfhRjGi5H85zDPpwunQc1bZ6WBT1b/KcLVecq3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Or/Q+STa";
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8AE606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 12:15:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C8AE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Or/Q+STa
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-89d6bd67045so388850b3a.0
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 05:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793189704; x=1793794504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8KxBRO5Re9XYDN/KL2CHYqXPi9yMnF5dDqV6a6oJZqs=;
        b=Or/Q+STazFsIo3FjcUyTOqi4KYvUXfDAp3gKR73iETChiV+q8+UFsXQRTjisYjcDfZ
         jm8wJ3ngrmT7XfAgURNjMLUTyPtXqcdfHwiTmm9WbqzN0rIQ9+kvz8zrW3/tgaurd4RW
         M1wlqUuz8GguK0CQgop6WfPDvfWWRuZ0m+ym31YTFD/t/CScvFdYtxQs5LhVWJEnnq6F
         xg9Ssj2M3YqBgamOtKhuAXwFw5hEzPgkJgsqNYFNJ81/7xuxTgb3hW2R5IW20ihxa2Fn
         BCEtHQ+CJ479Lwk+z5QS4cWbyB9M0+jxgBwSJa6/zeEYgcYO35iVQ9RXyG2ae1wgpvWS
         H5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793189704; x=1793794504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8KxBRO5Re9XYDN/KL2CHYqXPi9yMnF5dDqV6a6oJZqs=;
        b=gXTvG3WXIfZf0fOvWze3vqfCiuGlC9zXsSNl45GbDfqzetdPYPATIzyCrUY44gsXgA
         LhHl+PFtvOWeYPTuB3T/PlEFunQBNrVykYsgUUH3xpihO2uLj5m+iOJZcsnT/DEYTQtY
         a2sY3qjGeWDCHnshL4QZ+u9WdwjROVNLA1lD3FtQA05u8xeY2RlaiskMhYSjlA0rIZLo
         /WfZkzI1IFZdc+b0BgJOpxeRZxcT9aEnSKBC+lccjR9qw+pZYr9NYLJ/k3SuhovIDbNc
         YIPpgmkMJQdhdfxUOiSZEKuKePftbub3o5Eq6DFYKqHD/vVmtgr8O0updBKA7E+qc/Uf
         pWhQ==
X-Gm-Message-State: AFq9FYJfms0V2qGGq0Y9/cTrGn7rXtQS7KZYRVQmnLt/5pxNb9Iaxg2s
	7tBK0t6fe+x84kxxVT3B28CIzdDYwomIhxAW3VUwAndTz+3ja022Q4Cr5zIl+V6U
X-Gm-Gg: AYBFou0KdFzwT4xGSwzGjjoYB/JrUfzRFPXuBCS4z8opASPj8aILZsYxqGKcd2U0DXq
	DvEbRBE/1mivLotkcnz1k+gRr+oXU235PZhnXq7kUoYzp2ZdGxU+YYOz69cAq4uR64mF9CiGg7e
	84D1eAhoyN9Kv0INU8w12f6XaY0sxWPOAliLxCb7XC9XUWS6ktoB6WMgxuAUhdc5tsKtZ2EpgWP
	s9cmgnpqZtDyml5BmnuBze/y+CK/PcN7Pf/kJDUFTQLn2sAGo40ierO1ya+X5Ikn+q85b04UL9W
	GwdDl0JtvUOZKwSUBfTk+6mJOgHbpyTfFefwIxlmWu0llW5zDtHRogOqcJkRLv3W2kOx4Eo8Riv
	NJ5FWfeA5qSLN0NHIDkPkppppIVhk3ALCP2LpNa4Rc1K8pnYQqZvCKVw/VKq684HG0fE5eK3Wt+
	pPhW9PAWM5OYF/uqZYMAfIaMzXQLckDvB1x/hbxJkbWXU2XLVBM6zWao1zMetY7G0ryo174NZ1a
	RaYgxBnACZgAhJiMWPTL+BuMaLKFUAcXSRtSHNnKJch0QrfCTXzQfV08FKtwfkA6wK3OSYj6nGr
	UUFdh2lJ9yO9Eqzr39PxkLEAdRUnEZmJfvuSsDGTcqgkme4ufQ==
X-Received: by 2002:a05:6a00:3d0f:b0:89e:7bfa:f86d with SMTP id d2e1a72fcca58-8a75a02536fmr776911b3a.9.1793189703875;
        Wed, 28 Oct 2026 05:15:03 -0700 (PDT)
Received: from localhost.localdomain ([152.136.45.109])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6df0b5dsm1068172b3a.44.2026.10.28.05.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 05:15:03 -0700 (PDT)
From: Qing Zhang <diasyzhangqing@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com,
	linux-kernel@vger.kernel.org,
	diasyzhang@tencent.com
Subject: [PATCH] btrfs: set the block size before starting a transaction
Date: Wed, 28 Oct 2026 20:14:58 +0800
Message-ID: <20261028121458.23499-1-diasyzhangqing@gmail.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qing Zhang <diasyzhang@tencent.com>

When adding a device, btrfs_init_new_device() calls set_blocksize()
with a transaction handle held. If the block size changes, this takes
the bdev inode's i_rwsem and triggers a lockdep dependency cycle:

  bdev i_rwsem -> mmap_lock -> trans_num_writers
              -> trans_num_extwriters -> bdev i_rwsem

The buffered read path nests mmap_lock under the bdev i_rwsem, while
mmapping a btrfs file can join a transaction through atime updates.
Since commit c0e473a0d226 ("block: fix race between set_blocksize and
read paths"), set_blocksize() takes the bdev inode's i_rwsem when
changing the block size.

Move set_blocksize() before btrfs_start_transaction() to break the
cycle. Also check its return value to reject devices whose logical
block size exceeds BTRFS_BDEV_BLOCKSIZE.

Fixes: c0e473a0d226 ("block: fix race between set_blocksize and read paths")
Reported-by: syzbot+5c01398781fb51df783a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c01398781fb51df783a
Signed-off-by: Qing Zhang <diasyzhang@tencent.com>
---
#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3e6a9b429dd..a7f0607a5b86 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3019,6 +3019,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (ret)
 		goto error_free_device;
 
+	ret = set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
+	if (ret)
+		goto error_free_zone;
+
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
@@ -3043,7 +3047,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	 */
 	atomic_inc(&device->dev_stats_ccnt);
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev_file, BTRFS_BDEV_BLOCKSIZE);
 
 	if (seeding_dev) {
 		/* GFP_KERNEL allocation must not be under device_list_mutex */
-- 
2.43.7

