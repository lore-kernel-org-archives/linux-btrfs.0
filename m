Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915265;
	b=Xx6MEEJ3m9EFIb+GkNwJs1FwBXeJDS4VbVODXnLgg5hCzIbcofxpk8QSfMDIQnpcAIL3
	 2cQCCDC9bH2h6QMnOA3zD/hptyaB1p6IEP6T0ckNa1NxAZ02ISijmDmj5VFMoBKZ6rj5Z
	 OxcrXnVh4k8A594Rjsr2eKEGaTUrdTDw5IGtuKgeJCaPQdIJ5akuZUbFNjSOWtCPfNcyH
	 /yYEKWK9On0SiXD1ZVNn4HKmHdT86ATpwpoLIj/irlJVYzcbUnVEP/2TMa2OyHOgS+cTM
	 IRXtxUFBsUhFpk4QWNX1u3fontsVW2v4xwJR/NWA5qRbTpCDCY3BqJCEb8sJbby8xLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915265;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+K9CkvCA3OlKWwDUexCGkgRgdQU4VGZAviFEBkAbsLE=;
	b=scyoUo5kAI080F4QLU1q8Qx4b0VlPkALhuj2xKTcP2fTgJ4MCSZtjq1+PAqDAlMKkmG+
	 3Rf0rdILNN67BRYWWAhz/WVd8nTxPEQiNKyBcEgEJQ3E1hZ4Ih/ki/fnE4MOWIWfmmMW5
	 sOXNGy7o9EEfEY7pL1GO3ORyInLyVQex9EtVFFkntcRSRrNiFo19Ot8MnbX7wDMnc2DAK
	 mHn2fwPNPo9Gt2KCTx7WutRdTYo/Idhal5N6QYhuhflg25Z1uDdyqUlHNfgFw/QwOSboc
	 oTLSkS5rgM6KcXdIojzVpeRRK046k9yfdHggyqNs//EKC/u8fP7AN34/1umYTFP215w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=asu.edu;
	spf=pass smtp.mailfrom=asu.edu;
	dkim=pass header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b="Z9a1I/jm";
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A925606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 21:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A925606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=asu.edu header.i=@asu.edu header.a=rsa-sha256 header.s=google header.b=Z9a1I/jm
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3514b90bb89so4588992eec.1
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 13:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1793915263; x=1794520063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+K9CkvCA3OlKWwDUexCGkgRgdQU4VGZAviFEBkAbsLE=;
        b=Z9a1I/jmFxNeUeUMG5LUHf/SWNFUaPxyJpqZGpvhk0TR5g3UJxn35EnGJaVT9sbauG
         2bMbPnmCUqUZM7T8IICk1hMr2xn/Cgabulq89zLANoNiM48w01W0pk1kWYX6p2iwB0bS
         uVNrPvPXYdMeqvqnXrn2DpjfTIFyX+CfanC0djo7yHmMnD0unVt1fjMJDokKHHJV9nHS
         aLHs5rEtcO0GeUWXRgon0hfoxXO7mGtsIB7d5Nw5jfrX9oHHL2koD9v/3i6VpHqzPznG
         0WCAJkjrqegQmmruJSMAgxzLp7KPZsmYfcYY/IPsoFusGhcvYoGsVD5uwxvPNSIA86oD
         VEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915263; x=1794520063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+K9CkvCA3OlKWwDUexCGkgRgdQU4VGZAviFEBkAbsLE=;
        b=SVS3B4Gmd12JH1kcrKCLxAE36NZgo23ovOoZyB8Pd0hqRLPSyDbyMPODsIMA0rKhUg
         GMwApZ6Y1LQUzC5pWYTZIj5gaRoxr/YVyA8I5Um5SDQ32il238j+CRT18vVbiar6TJlJ
         Ozk1crALuhj672Gw4dsrHFOmuMYRedSlf7QqtWC8E0SGnC82t6T0WVPbjDK6Ot3vNB8A
         ockMxgc38CtVQv/wfANvUE8bysgP1q7PLbBED7wK23nNNNCGSRgVmUIb8NDG2OYoyr5C
         ahoMVPKyuI69xaqSk3kxunYpzQBj+IGJ/+6xPPHSeJ9HDiOuJId9yAcMbN++E723t5NA
         0ChA==
X-Forwarded-Encrypted: i=1; AKwUvBxL1UFWcS6MBBFVtweUGZXRhF9gsXcygu9gXK/tEaaX6/KD/aYpBd8ZwMWrREhSP4CvPHPmPXt8BtBkxQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8RGg/DwHgc9+UuJhCP66tfruJHX1j9/AzfShjPj9KWxWgpWCeo
	DlzsJI52gU5fPvrNz9E4CENKfGewS4R/nBqxMSVriCH2i5wg1K76Np2zDbelsERCiQ==
X-Gm-Gg: AYBFou3Z/oClCWNrBRWumkapig65PwGwfN5PKYwppaEJUsyPi4yWNzp681etf3i/2Y6
	Y1sD6GBoc15ajILuXycGdSf1oo5B1iIQxQXrCRfl2xhaSX61kIFNwibfP3XAi7SinHLM4/yRaPY
	qTdorfBprlGyzi8ExSa2jLaLyn/oC70kd7oey4zLzPGWnr8ph4W/JMpYC4/vdRt2C7Qvqyd0qq+
	qQAFfdMxlaypKtpv9N8qe0082KqEAyu9FUSNLpFTXahKaHk3EhbOF5Xsa6eNelG5QUUyF72utkv
	kDrKaBpKzcbvbpqciNufknuwtK1n0/xpq43NG3V8BsA00hWaqEe38OuMYw71WZuD4hMlwdh6AnY
	QrzNwmOYwgI5819grFaxNNM49wWRZRKXVjHKkWe6aZhFofVrn/ERucmoSyeTv2Qf5zisoYLcWYX
	S67AbzAtlfvTtZVv1+zcrCf2MbNKwXye2QuY0qNPgIZ+1ymc4y2G2BSjrYNruBKB5p7dg5zRbrK
	UZkC6Oc3KLLYd4aRdrakc1k1Yyw0NJqo24dRU0YokfNtpYMC2JITGqrnQn0Bb2+bqVWPLObEVWo
	6Zyv5wAhE20XI4ZJ3YW3zF51puL/Xxtnm9no
X-Received: by 2002:a05:7300:f195:b0:369:f420:8679 with SMTP id 5a478bee46e88-36f784c065cmr803770eec.38.1793915263163;
        Thu, 05 Nov 2026 13:47:43 -0800 (PST)
Received: from localhost.localdomain ([206.206.222.26])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f71a25c1asm2036943eec.27.2026.11.05.13.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 13:47:42 -0800 (PST)
From: Siddharth Mishra <smish149@asu.edu>
To: dsterba@suse.com
Cc: mason@kernel.org,
	josef@toxicpanda.com,
	wqu@suse.com,
	fdmanana@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddharth Mishra <smish149@asu.edu>,
	syzbot+dc9291cf132691aeb478@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] btrfs: overwrite a leftover balance item instead of BUG_ON()
Date: Thu,  5 Nov 2026 14:47:37 -0700
Message-ID: <20261105214738.111967-2-smish149@asu.edu>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105214738.111967-1-smish149@asu.edu>
References: <20261105214738.111967-1-smish149@asu.edu>
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

[BUG]
A balance ioctl can hit this BUG_ON():

  kernel BUG at fs/btrfs/volumes.c:5088!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  RIP: 0010:btrfs_balance (fs/btrfs/volumes.c:5088)
  Call Trace:
   <TASK>
   btrfs_ioctl (fs/btrfs/ioctl.c:3523 fs/btrfs/ioctl.c:5650)
   __x64_sys_ioctl
   do_syscall_64
   entry_SYSCALL_64_after_hwframe
   </TASK>

[CAUSE]
btrfs_balance() expects insert_balance_item() to return -EEXIST only
when a balance item is on disk, and a balance item to be on disk only
when fs_info->balance_ctl is set (a paused balance, or one recovered
at mount). So for a new balance it uses BUG_ON(ret == -EEXIST).

Both assumptions can be wrong:

- insert_balance_item() inserts the item, then commits the transaction.
  btrfs_commit_transaction() can fail without aborting the
  transaction, for example when btrfs_start_dirty_block_groups() fails
  to allocate a path. Then balance fails with -ENOMEM and
  balance_ctl is freed, but the item stays in the running transaction.
  The next balance ioctl finds the item and gets -EEXIST.

- When the transaction was aborted with -EEXIST, for example after
  "failed to run delayed ref ... -17" on a corrupted extent tree,
  btrfs_commit_transaction() returns the abort error, -EEXIST, and
  there is no balance item at all.

[FIX]
Mount turns any balance item on disk into a paused balance, so a new
balance can only find an item left by a balance of the same mount that
failed after inserting it.  No balance owns that item, so let a new
balance overwrite it, run, and delete it at the end as usual, as Filipe
suggested in [1].

For a resumed balance -EEXIST is the normal result.  Any other error,
including the -EEXIST of an aborted transaction for a new balance, now
goes to the existing error path.

The BUG_ON() checks on the return value go away, and the one on
fs_info->balance_ctl becomes an ASSERT().

Reported-by: syzbot+dc9291cf132691aeb478@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc9291cf132691aeb478
Link: https://lore.kernel.org/linux-btrfs/ZNzE6CFOzu9kDG+G@debian0.Home/ [1]
Fixes: 1bbc621ef284 ("Btrfs: allow block group cache writeout outside critical section in commit")
Cc: stable@vger.kernel.org # 4.1+
Suggested-by: Filipe Manana <fdmanana@kernel.org>
Signed-off-by: Siddharth Mishra <smish149@asu.edu>
---
 fs/btrfs/volumes.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3d4ef6725..4a8e5078b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3998,6 +3998,8 @@ static int insert_balance_item(struct btrfs_fs_info *fs_info,
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*item));
+	if (ret == -EEXIST && !(bctl->flags & BTRFS_BALANCE_RESUME))
+		ret = 0;
 	if (ret)
 		goto out;
 
@@ -5081,17 +5083,17 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = insert_balance_item(fs_info, bctl);
-	if (ret && ret != -EEXIST)
+	if (ret == -EEXIST && (bctl->flags & BTRFS_BALANCE_RESUME))
+		ret = 0;
+	if (ret)
 		goto out;
 
 	if (!(bctl->flags & BTRFS_BALANCE_RESUME)) {
-		BUG_ON(ret == -EEXIST);
-		BUG_ON(fs_info->balance_ctl);
+		ASSERT(!fs_info->balance_ctl);
 		spin_lock(&fs_info->balance_lock);
 		fs_info->balance_ctl = bctl;
 		spin_unlock(&fs_info->balance_lock);
 	} else {
-		BUG_ON(ret != -EEXIST);
 		spin_lock(&fs_info->balance_lock);
 		update_balance_args(bctl);
 		spin_unlock(&fs_info->balance_lock);
-- 
2.54.0

