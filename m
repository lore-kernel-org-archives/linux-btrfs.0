Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794670940;
	b=AJsPXd/BZdOU1Xjnr+zFN0R7XCPlBBFlq2QG4ajQzRtB+ll0++tU2iYGq4pjAeL3+uXj
	 iuamav63+DOooRWySEaXucTfMxBO+RvO80jtKDIfQO8NUY82OVVf8QioDcJ6TlLJF06WM
	 Kz/qz0E+95MESfnunEwD6R4entTWHXyr1YaTGbnkvYz8+0rLsftm7bzSwuq1niWk1BjOO
	 hXzY7YwTTeGeCcxLfRDOCFJN80+WG5LFpwj8hKrLiacA8NeVYlDQAT13T0+Cwt3YjzL0F
	 GIAFtpOyn4F9VDLp984dYZFT3xEH2jpIovRfX7dacZfwUDRAHsSXCN3j0tlVa5NpYwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794670940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D/QDiWJcNeIF083+fu+YVL4kUJSlCNjsA1ag+QXac8Y=;
	b=bo8Gn0Xv5GXsr2IUzQSG8plvLisk6USJ/OZBciwo9geww8IAQfQ8D9delH18qgh3SJew
	 2pBa+Sr/iI3ViQl4GP0qKtx96ZuPFHDM9+bKh2UxrwPRdvc59ZDnG6JOJ0ok6rpxlAIjd
	 2LldgpwjxbuC7mNw+qPW1Pz8n3gAlxYwzamu9AFm5KMntGv+86zNa3fdglhtpwelcFv95
	 XAiW9fTj5bKQC7GYQKDIkVFG3PewMrScuV4A/QcWLZOXCskJzyz8WsQaP4R6IB2NgsbvH
	 Bt5n1mjzcS5Fvvg2jfn8aKNdisxkoprlGpN9B8whWosSOc4MJsjf4OqpKa/EW1EVeow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IcSdNqlU;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1978606A329
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 15:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1978606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IcSdNqlU
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso2537684eec.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 07:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794670939; x=1795275739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D/QDiWJcNeIF083+fu+YVL4kUJSlCNjsA1ag+QXac8Y=;
        b=IcSdNqlUjf0OorbJES0XjlyGT7niWbOtnCZUo8OtZ7MMNlC5PKahUlKpx9dfH+dbO1
         bI5qcsNiDqPqjkf1jreC2o3fRnu9Ml4lfqsl151YLyTpUfS9BePZRolC+1blq1XWe/95
         d52x+e3Nl5M4DmP1ooF4yCxAz7yyEeutCWvlwxqsvc25/f3a8veGdV6oh6o0cutNAA1Z
         uOGw3xpYLHBzAWwrSLo2b9yNKrQcu/5oa7uYMTr+pK0YGMrj43e2SV5fcgsTHGr+cOqU
         jjSdqrbT3cUGOTYxMAx0MjhDMkH49Axzg+xU4gxrgEcHr5P5P3xojYJ6MOCHn36QNvt/
         yceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794670939; x=1795275739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D/QDiWJcNeIF083+fu+YVL4kUJSlCNjsA1ag+QXac8Y=;
        b=NM3oP2Vryicx4z+re2dmbOE06ny/ZyYo8I7+N9rpYJBOe31ct/EzsUnUcdFVEnB8O5
         lKtiLusbk+7743rRwBhqL1QFHssmzJauBl6ytwi4fIf9McJtz9yTMat6wt1F+J98ZzkY
         +aHOHvWSP+2OKmfjNqSrE2Q0nkkBdvOn2s0lx+p4IM4IHCzZYMD2L6ET7vlkKsCXYzLs
         aPIiu4KSsndDkLL7WIljcK+DzIkk2XN6P+Rm1L9GAyqk6G2r1JcZvRLxXU3oJi6rxTUm
         hhaB3i7FRcoUidvMZmjU9XdefIAvSAu+oaaqRD0yt8kvZL3E7lbHo4JPLvda22Obz64S
         QA/w==
X-Forwarded-Encrypted: i=1; AL+hErE1QWSRmypdExMGDOm7hFKZLx0HO3P0T+vNuCL+Jj+voewojYWcxiX/u1Icp1ksKnX+f8Pbdg6jt1cP6Q==@vger.kernel.org
X-Gm-Message-State: APuU4Z+F+/w0HHTzxMs+7l1LwNxL60l2tCIN0Axrc3PW3ojkpChbv+Jg
	VUW82Gp3HanSOuuZ/S5sKmm3wCObhAE0zpc84t4322aK3CXDTkjTodJTHQwnGw==
X-Gm-Gg: AYBFou2F1Ic4AzmItbPRWNrJd1qoo30LkPyFuWx5JZ7rcttq6+5eJctS8/fOL/M8zqP
	DQ00Z0eAythcQxUL7xceRhEA0qbXhO6FOcjufSJf1ybz7GCelvX1F7JPrx6B87vrK2YDMX8dYy2
	97Si2fmCtd8V6hcY8S4huRFBnL2OeMHSg+P1mz60Z09vfOBgav9S0K0zg60//Xs7VBq604uXarb
	B+zg14ErjQeOhJdDyIAaYSEG3YdxP+w6/sLBR4vmcFHySwXN1OwTHmFxhCZvfuEu46P4v/j6F1g
	4rafNV7uJ6ruKg2qNwUVNp6Igm0/fBaHifKM+dA//XB+97ZTAVM5ItDrtBop+mos92AGuS+Mglx
	iOB1T4HLq6Bqxpk//IEdQwCnSk8oA9g5PvaTF/jYIR2W1VsSxckiwPW6lrTpp/TqhH6yBfB0NeQ
	QyKVjwKRkwe+b1xH8UkanUq7V0wxLFeOmNyPhyBQwszpE/PU3StdnGLUcdDSqqeZgbdl1Oiv8Jy
	BG3m8McYBm8uOn+j26cDmYqHGHUH8G6Y/tnqVepcP6kWa+z5YCVweGwUc3SGAJtvxbAAFjNzh7w
	SOpoIQk/+QyrQ77CmvRurwtKCoMU9c7CWlKJC6Zc7NspyB5tJgKinHFeYA==
X-Received: by 2002:a05:7301:fa3:b0:376:37a2:87f3 with SMTP id 5a478bee46e88-37967dd733dmr5109847eec.31.1794670938852;
        Sat, 14 Nov 2026 07:42:18 -0800 (PST)
Received: from user.. ([2405:201:c052:b00b:9eff:399:c292:54cc])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795591f4f8sm18037395eec.13.2026.11.14.07.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 07:42:18 -0800 (PST)
From: pavankumaryalagada@gmail.com
To: dsterba@suse.com
Cc: mason@kernel.org,
	fdmanana@suse.com,
	josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	quwenruo.btrfs@gmx.com,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
	syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: Clean up delayed inode items on transaction abort
Date: Sat, 14 Nov 2026 21:12:07 +0530
Message-ID: <20261114154207.73644-1-pavankumaryalagada@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>

When a transaction is aborted, btrfs_commit_inode_delayed_inode()
fails because btrfs_join_transaction() returns an error. This makes
btrfs_evict_inode() skip btrfs_kill_delayed_inode_items(), leaving
pending items in the delayed node.

Clean up delayed inode items when the transaction is aborted, even
if btrfs_commit_inode_delayed_inode() returns an error.

Reported-by: syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6af131f2.44d55313.247daf.0001.GAE@google.com/T/
Fixes: 2adc75d61203 ("btrfs: move btrfs_kill_delayed_inode_items into evict")
Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
---
v2:
- Add a condition to call btrfs_kill_delayed_inode_items() when the
  transaction is aborted, even if the inode update fails.

v1: https://lore.kernel.org/linux-btrfs/avMkGGHSH2scfa0t@user/T/#t
---
 fs/btrfs/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa33471456..b3a33541b8c8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5623,16 +5623,21 @@ void btrfs_evict_inode(struct inode *inode)
 	 * the inode update is released.
 	 */
 	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
-	if (ret)
-		goto out;
 
 	/*
 	 * This drops any pending insert or delete operations we have for this
 	 * inode.  We could have a delayed dir index deletion queued up, but
 	 * we're removing the inode completely so that'll be taken care of in
 	 * the truncate.
+	 *
+	 * We must also clean up delayed inode items when the transaction is
+	 * aborted.
 	 */
-	btrfs_kill_delayed_inode_items(BTRFS_I(inode));
+	if (!ret || test_bit(BTRFS_FS_STATE_TRANS_ABORTED, &fs_info->fs_state))
+		btrfs_kill_delayed_inode_items(BTRFS_I(inode));
+
+	if (ret)
+		goto out;
 
 	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
 	rsv.size = btrfs_calc_metadata_size(fs_info, 1);
-- 
2.43.0

