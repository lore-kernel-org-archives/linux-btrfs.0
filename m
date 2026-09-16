Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09657376A08;
	Wed, 16 Sep 2026 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579146; cv=none; b=ABRaxpn5dxclQ9EMhFKLeqaARuuX0YR+QJnOsd1XCgBj6Db/V3ZEH4q4Qd+tJMgRW4LzQAUjI6HJfytMQ1KFuoQJBaq2+8eltUrNV/CDKKBMGypLUJrpu2YYUKbZnKdhc7yjFlwy5c/SczM2G9iGhWLamkgIVysGXmWusE6pZiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579146; c=relaxed/simple;
	bh=Qar29yejwWClSb2mHOSazC7p6Zt1CO3buRhcdR/CyPI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FuSiONMSF8y3+pb4eKdeAYhieDgou/3nx1wR2tVQFyL8rv2EIqx80xPzdgT2ZWt8M/QprOavB5Yp+a8nshzMPuxUKqcYSH37HVVGf1Gy7G9ZN1iMMJkKV1oy6ty+Vhsd48nKo6lankUEF/z0YAeUoM57M4BVQ1LVXr33UNItQt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACX_zmBz6pq93puCA--.23225S2;
	Thu, 17 Sep 2026 01:18:57 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: clm@fb.com
Cc: dsterba@suse.com,
	fdmanana@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wqu@suse.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: Fix root reference leak in merge_reloc_roots()
Date: Wed, 16 Sep 2026 17:18:29 +0000
Message-Id: <20260916171829.2087132-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACX_zmBz6pq93puCA--.23225S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr45Kry7Wr43KF4kAr4Dtwb_yoWDXFX_JF
	yxtr93ZF47tr4093Z2y397ZFZ3tw1rKF18W3y3KFs8tayjyr90vrn3JwsYvF43Gw1DGr13
	Cws5u34UAw12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj
	ZNVPUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgUMA2qqok9ougABsy

When the fs root read back for a reloc root does not have the expected
reloc_root backref, merge_reloc_roots() warns, sets ret = -EINVAL and
jumps to out without dropping the reference returned by
btrfs_get_fs_root(), leaking it on this error path.

Drop the reference before jumping to out, matching what
merge_reloc_root() already does for the same mismatch condition.

Fixes: 05d7ce504545 ("btrfs: exit gracefully if reloc roots don't match")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3ebaf5880125..6c826be41749 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1850,6 +1850,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 				 * corruption, e.g. bad reloc tree key offset.
 				 */
 				ret = -EINVAL;
+				btrfs_put_root(root);
 				goto out;
 			}
 			ret = merge_reloc_root(rc, root);
-- 
2.34.1

