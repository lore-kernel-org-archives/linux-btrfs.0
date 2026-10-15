Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605304AA402;
	Thu, 15 Oct 2026 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058361; cv=none; b=SniFI5f3yVpXc5EgzFqwZ//LVqTw+4PzWUt5JZKiCYyE2i1DyP9PdAnaahDmT7hpao/5LkHeHURidG1do18xTmyGJ3O5FOCwOwzeX+M5SiH2e/l4jYzgYDWUhIdPs0KWNnNwPf1hITllbXQHZNJI89ll9WE1ZKAdlp/vW23+KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058361; c=relaxed/simple;
	bh=krQsggzCqEG/D6oeKhnaepZTcpTlj/qt+kPm2FfA4m4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mNwO9evQ4TD5L5L9h/o4tAM+LPgyLXhx2JWox0ftYp1Pl1o9hkQWFCWopg9cMl783OqtRiEVD6shxaj7eJo8Ah+PeNFSRfcgG/ShFyeFh/5qCftCHbzutjDAAR6QV6LOuwTByQsxGhf/xmELEqfiMzuxzauT+Kf4cDcVTTZsCWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=fbE7U33U; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="fbE7U33U"
Received: from localhost (gyproxy-mailtls0-entmail-virt215.gy.ntes [IPV6:2409:8d28:39:f54:403e:4083:f623:91af])
	by smtp.qiye.163.com (Hmail) with ESMTP id 512956982;
	Thu, 15 Oct 2026 17:59:05 +0800 (GMT+08:00)
From: guolingxing <guolingxing@tju.edu.cn>
To: Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Chris Mason <clm@fb.com>,
	Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guolingxing <guolingxing@tju.edu.cn>
Subject: [PATCH v2] btrfs: verity: propagate orphan insertion errors when enabling verity
Date: Thu, 15 Oct 2026 09:59:01 +0000
Message-Id: <20261015095901.4140409-1-guolingxing@tju.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <e3321d2d-d8dc-43e5-8501-31b2d5ae1146@suse.com>
References: <e3321d2d-d8dc-43e5-8501-31b2d5ae1146@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa13f00466803a2kunm61a746776ecc6
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQh4YVh9PGUtNTkNOT0JDS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMfSUNBSEJBHU5PQU9LSB5BT0tDSEEdTUlIQUJKGh
	1ZV1kWGg8SFR0UWUFZT0tIVUJCSU5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=fbE7U33UG3qnYh05GnJ3x+LODC8ESQQcNfeqemOerQ0tbcPqDqV9fpDj2FnwC0KgptTF+0PRiVsZ4278jhMz0ZD8c51FVlJkUBIyf6DBgLyoRyQUfoKF+pDP34rH38a8LAQIbhGqpiPLmFdktKVFBC8kulUCTpipvS3WvEzofTA=; s=default; c=relaxed/relaxed; d=tju.edu.cn; v=1;
	bh=BcfeZSTk49w+VaockmmkNFOszvZxZBrEsLCMNT0iovg=;
	h=date:mime-version:subject:message-id:from;

btrfs_begin_enable_verity() ignores the return value of
btrfs_orphan_add() and unconditionally returns 0. If orphan insertion
fails, btrfs_orphan_add() aborts the transaction, but the generic
fs-verity code still proceeds with Merkle tree construction because
the begin_enable_verity callback reported success.

Return the error so that fs-verity stops immediately instead of
continuing after the initialization failure.

The transaction is already aborted by btrfs_orphan_add() and the
handle is released by btrfs_end_transaction(), so no additional
cleanup is needed.

Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
---
Hi Qu, you are right. The claim about leaving the on-disk state
inconsistent was incorrect.

btrfs_orphan_add() aborts the transaction on failure, so I do not
have evidence that ignoring its return value can cause on-disk
inconsistency. The real issue is that btrfs_begin_enable_verity()
reports success despite the initialization failure, letting the
generic fs-verity code proceed with Merkle tree construction only to
encounter an error later, instead of returning the original error
immediately. This revision removes the on-disk inconsistency claim and
describes the error propagation issue instead.

Thanks for pointing this out.

Changes in v2:
- Remove the incorrect claim about on-disk inconsistency.
- Clarify that the fix propagates the initialization error immediately.

 fs/btrfs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 600337a84fbe..d92c9dab0293 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -615,7 +615,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.34.1

