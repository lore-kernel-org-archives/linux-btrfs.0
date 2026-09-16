Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF534DD3B2;
	Wed, 16 Sep 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789578837; cv=none; b=aTyEbt4riIpPPddpXLEcwsd2yiR2y8fm7mWBYRSWuwjSZQz3FxNn81GRSmQn9+IkQsW8sbXB7Tgv+GTjdtvqQw1Xa4uNo03wjPlyyRwNMmjrX5jndGTk+GX/NmhAOYpsduA4oRj1QNa77F+cqjyQ6fJuEgsQpYThFkMvonPZ0xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789578837; c=relaxed/simple;
	bh=o+bs2Uka+leCxw+K/4mbYOPdHuXTq+5fJ940yyyKMNM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aHWv3BYzTXbljEqsHGywc0wmujdtSk8BY9MgyMKSyN5zPx16lTLfMMIKgCdveKME8PD5Z6HGH1mSvONm6MLTss2M0em/qeh2JGgwXcdJUHwsoBLnaqdaJjyeEmIHJnio304nhmJl5IFMKeDZkK6QdIndvV5lX5Z30W54gI/gZWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADnUDtLzqpqZWRuCA--.22559S2;
	Thu, 17 Sep 2026 01:13:47 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: clm@fb.com
Cc: dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wqu@suse.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: Fix root reference leak in handle_indirect_tree_backref()
Date: Wed, 16 Sep 2026 17:13:19 +0000
Message-Id: <20260916171319.2086756-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnUDtLzqpqZWRuCA--.22559S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Jr1DXFWDuw15Cr4kKFW7Arb_yoW8JF4rpr
	W3CrZ8Gr4kCr1xtFWxWw4UtryS9rZ8G3y5Ca4kCayS9w4rJw1fZFy2kwn0gw43trZ5Gry5
	WF4YqFyYyasFyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	USLvNUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgIMA2qqok9l6gABso

handle_indirect_tree_backref() walks up the tree from @cur, storing the
reference returned by btrfs_get_fs_root() in lower->root when the top
of the searched path is reached, and dropping it once a node already in
the backref cache is found.  If the walk instead reaches
BTRFS_MAX_LEVEL without hitting either of those two exits, the
reference is neither stored nor dropped and is leaked on return.

Drop the reference and return -EUCLEAN if the walk reaches
BTRFS_MAX_LEVEL without finding the root of the tree.

Fixes: 1b60d2ec982a ("btrfs: backref: rename and move handle_one_tree_block()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/btrfs/backref.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 273924ca912c..e889fbec4fe1 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -3426,6 +3426,12 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
 		lower = upper;
 		upper = NULL;
 	}
+	/* We walked up to BTRFS_MAX_LEVEL without reaching the tree root. */
+	if (level == BTRFS_MAX_LEVEL) {
+		btrfs_put_root(root);
+		ret = -EUCLEAN;
+		goto out;
+	}
 out:
 	btrfs_release_path(path);
 	return ret;
-- 
2.34.1

