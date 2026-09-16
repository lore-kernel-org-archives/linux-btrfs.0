Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8304F3B14C0;
	Wed, 16 Sep 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579006; cv=none; b=NRwndYjBf/hZ241agdX3wkNbILW/bRpB2QgvtK6uEv+WAaW08/8wwjajS3NbPLN5HuYtJ8RQwi1ez196y0sa9KIuXh1KONWOFKLMtvYAFkftbV7YigsHM42WJYNxjKJLeY6iJ2XoiEj9usOKfEz8zm5sue3E+Oxae2JVU1PyOEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579006; c=relaxed/simple;
	bh=dZ2NlflOAKixetBziPerlIM/rAPQCPji6P3Tum8iW9g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lGZ3eE1WO1NBKzpx+ajRjaL85pwWs+ymRl14Yb30xsIXghwKf42bZrJ8s3RzvawuVlH+uLHLL9jPIDm67tNSSiJ9GDdDRwds/XgtRyxfj85gFiqCdoCvsLsroAHtiYL0argzqheSG4R5SwnUyPWrshm0fQcrEBTd+Vj0HR4D41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABXwz32zqpqVnFuCA--.23275S2;
	Thu, 17 Sep 2026 01:16:38 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: clm@fb.com
Cc: dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	list.btrfs@jan-o-sch.net,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: Fix local_root reference leak in scrub_print_warning_inode()
Date: Wed, 16 Sep 2026 17:16:10 +0000
Message-Id: <20260916171610.2086918-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXwz32zqpqVnFuCA--.23275S2
X-Coremail-Antispam: 1UD129KBjvdXoWrurWkGFy8Aw48XF43KFyUJrb_yoWDurgEkF
	y8ArWqqw47Zwn29r42y3sxGrZaqa1q9FyIq3y8KF13KFWUtrn8AF97twsxJrn7W3yUXF9r
	Gas7Xr43Aw17GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj
	ZNVPUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRMMA2qqozVkqQABsP

When paths_from_inode() fails, scrub_print_warning_inode() jumps to
err without dropping the reference taken by btrfs_get_fs_root(),
leaking a reference to the root every time path resolution fails while
printing scrub warnings.  Every other error and success path of the
function drops the reference.

Drop the reference on the paths_from_inode() failure path too.

Fixes: 558540c17771 ("btrfs scrub: print paths of corrupted files")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/btrfs/scrub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1ac609239cbe..570828ec780b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -549,8 +549,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 num_bytes,
 	}
 	ret = paths_from_inode(inum, ipath);
 
-	if (ret < 0)
+	if (ret < 0) {
+		btrfs_put_root(local_root);
 		goto err;
+	}
 
 	/*
 	 * we deliberately ignore the bit ipath might have been too small to
-- 
2.34.1

