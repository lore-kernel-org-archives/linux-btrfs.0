Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794256164;
	b=Vfm+ZljiNdJcW2/vVu486iDhw8BH28wJ48NivAB9OzziOFpktSRzeRStcDgB5gJjC7on
	 4OhVXE89Z/wkbcIUycfwrRY6RnnpFzsN3wewT8ZdH78UV0aDL0tLXyd3S8w7E4RZDLXch
	 tuvDpoHdlwfJ05BGWUrCO6Zve1AW70uU2xx5lm55LW0ta1f9DrwW0CXq3ODXwpUxv2QsP
	 EqbMSIWAb+pvIwqKpIoKp1wndDwWa7KV388hpnb1QyO12CihmYVsLKbJ5vv7TRvv079QI
	 +hQS4Cmy/pImAV6J0sKRvQIVpF7e2GtxzVDw8WLK43bf6+atch6glYLkFVlOOR0gG6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Q9kT3fz3vzDuXqjcm0DKy/dEcUDkUtFVvLm4k11ssrI=;
	b=RwLCR3XFy3Nq2H+XzqV7pZLALLUvJDOmxvvz9pLRcsnMXlGdMwXOtollNzHyAb2h5zGn
	 FGLGqU73oR4mEmfGTpQcIoVbUGU8P/A7L460Uc/99eAV3NeK03bwAxKEV25xIx3vFe3Mw
	 VgMHB/+CSqYOC3dqpokQYH4pEZC9N/fBOaoELzXruhydftdGfRDDH+LX/I0nDN02Yu/ch
	 VqOPNicduMZ060kA9AgpdQAygtAofQnP+MsVOwefIdzP9Oux0O26XAh8gHA9Ocg9j4H0F
	 GPUAAW5EcqPGmkCghVFUvKEUpcO7clSnbniLU3uo72atGp+mkuuGVOb7VA+T737IMLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="d6cJ/SBd";
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A4960A2607
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 20:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59A4960A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d6cJ/SBd
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3704d30b84fso1669901eec.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 12:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794256163; x=1794860963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q9kT3fz3vzDuXqjcm0DKy/dEcUDkUtFVvLm4k11ssrI=;
        b=d6cJ/SBdX6/ehEp7fUvEZQHyH4npkIz/bk620SpXxhNeU4ycWM9MQ7rBM67z/By/Dy
         un2hBXuepA6rMAHdc5OXzIoutG2ABVr2M0UXeyOLKYsb6+N853l5qDZNMGXEzRNGoU8J
         /bdTYVTfKBBdFMa994el7JpOeeOhWsFBxd+Tna7800XYUgbuwpbSrQbAPZSuZxEN0u5w
         K0DT3JvVtGACO0jis1Ga0DQWyndLoVZANqJ5fpDcFQoJeciCN5Z2aeY7E4or6k/jm3wv
         zl9ZGBtWgVFtiNAuaDGxy1buvoon0G/2JKuFxYEbBnJlSFjEPOv6ny1uzT9KEnS1gZR4
         ZT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794256163; x=1794860963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q9kT3fz3vzDuXqjcm0DKy/dEcUDkUtFVvLm4k11ssrI=;
        b=TKrIg8HIFbgOArsHf2HDIBuT1Zl7nf4HxWhP8+dz8RuwTEVKrla3BtZoRx453Ry++J
         DwgimBazyN+IaR7rISi+WHVORbGz+Z23phQYzLREXPEZpxTLkkMjXnqhr2JhcGDxbZrV
         UIt2/QjSbMfVfGYU9Y5CdAgtTar4CUQ8LgGd2N4nWbshZwoZ90OmU73a+mWiJzzqPAmC
         aS5acfp0e4EGsdkn7qHYWvSwHsdy6woB+OAFhsfwDzrAr/qMr7siLtzEZ5tw0AJl6KPK
         mD4QXLa7gaAg9QBs5v976DgjuCH4l0HKsINqkB8ylTQBlknJQLTPAKQmP7BSApwYIDxE
         9nJw==
X-Forwarded-Encrypted: i=1; AL+hErHXcx8wHjlWS/socbguX0OIDBPPQA7bhIAzhML+BspIeQuVN6hHNvbYUcyL12mUZwtguv5VkXQ2L5e97w==@vger.kernel.org
X-Gm-Message-State: APuU4Z9leVTsFRa6c6C1OQXhv6IFjOmAlMIyh4YgPgLm56I6FGm+CpBs
	ABHBlbK/u3VTHQ9w6Nl5PlmWLfKovdQ6zaiuFP3RlajzypnRwahgHGlJ
X-Gm-Gg: AYBFou06sMWOdFAJIwnYSp5Rr9SHOiLHtK9xMWCIMmr1KqQFbtiuRb8wz3fmMslqP6L
	seSyd1NrcQ9FFnaI3zNs9Sn8ZtvjdzSOXV2Uy1CfpAuPAVQ+6R06N1nV3PIwxWfSoTc+wgV89El
	WJlMmZwWH0OaKLrQaC7PFtIJFGvkA5lEpgVif0IKyAngA3c5GjOpnBkZ1OK7MWfifDR/rSlj17N
	praudwMMyTQNwO4XNpyzTmaDIPWRVasZritAHwQvkSFnXBBFceOvMnvPt6eL7PFygdDuW+V+eX2
	XLBH9JUXxETEku1bTO6iDwYMRdCjQPD7flLl53fjXlT7brfLG29hCke9GVWKufA9gpy3kNCL1dM
	5PR/E2eClUlw6CZin5DRqP0iyDwQwWNVKKcf9Hj0HGqrdvSVYRUgTLvpMYGMyZuPJGtSN7/FP7Y
	YOEMAcf9WBT9uduKueHWK4Pq1a6sYvSwmUQn+ZtQU7bcY6DO4KC3+O5yRoLiITvERUse6u4I86D
	e0sBvEeUb8hcQ8z86nyP++Os5zrf2aWCfj0I7UqieQLFuY1BcaCDuADVx9bJubtLX4i9EDczGUB
	A27vG+t7NdNvniTtydbSNaKxqLqJI0wdgu36
X-Received: by 2002:a05:693c:8845:b0:366:9f06:3c4c with SMTP id 5a478bee46e88-3751fe3228cmr430632eec.32.1794256163417;
        Mon, 09 Nov 2026 12:29:23 -0800 (PST)
Received: from user.. ([2405:201:c052:b00b:fe08:4a28:dbaf:f2aa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751fe32276sm703045eec.8.2026.11.09.12.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 12:29:22 -0800 (PST)
From: pavankumaryalagada@gmail.com
To: dsterba@suse.com
Cc: mason@kernel.org,
	fdmanana@suse.com,
	josef@toxicpanda.com,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
	syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: Clean up delayed inode items on transaction abort
Date: Tue, 10 Nov 2026 01:59:14 +0530
Message-ID: <20261109202914.64371-1-pavankumaryalagada@gmail.com>
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

Move the error check after btrfs_kill_delayed_inode_items() to
ensure pending items are removed when the transaction is aborted.

Reported-by: syzbot+55d1814e49f1fc0ba542@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6af131f2.44d55313.247daf.0001.GAE@google.com/T/
Fixes: 2adc75d61203 ("btrfs: move btrfs_kill_delayed_inode_items into evict")
Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
---
 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa33471456..397aa64b4816 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5623,8 +5623,6 @@ void btrfs_evict_inode(struct inode *inode)
 	 * the inode update is released.
 	 */
 	ret = btrfs_commit_inode_delayed_inode(BTRFS_I(inode));
-	if (ret)
-		goto out;
 
 	/*
 	 * This drops any pending insert or delete operations we have for this
@@ -5634,6 +5632,9 @@ void btrfs_evict_inode(struct inode *inode)
 	 */
 	btrfs_kill_delayed_inode_items(BTRFS_I(inode));
 
+	if (ret)
+		goto out;
+
 	btrfs_init_metadata_block_rsv(fs_info, &rsv, BTRFS_BLOCK_RSV_TEMP);
 	rsv.size = btrfs_calc_metadata_size(fs_info, 1);
 	rsv.failfast = true;
-- 
2.43.0

