Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74244718F9
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 09:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364060; cv=none; b=kMNGnAFOZHr1dMFVjJcNYVQxyefmZmPdfBX1NNuNvAFR87Fuan+uIRo2KxSAvpBOSheTIK/G7rdWYMIv8ancI9MFP24Q5ezWBQlf3AdqbzrObOWjHr3u03iJj6kLpbA9seyq1ObG0eokixswEWLIuht2C6xOuuod73/kWfo5LCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364060; c=relaxed/simple;
	bh=98nEAcT23Pwhe+6Ltvx1hRH911j5IshnPDQKJ0/lQCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SP07LNDgveq/+BE/ZWkak+KHcH1340NDCxsnJet8oOviQRvjd7+IknIufO8o+/tBu4gGof88neHinYSii7CeQQKceG0FpqdsEVBudJkS8jdZDTcLZbE3KlwvQXqWwArmkzMIK/z8iP5Z7Nq+J56CyWvlDerSUsDxqNXgVM2eCgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSO7+6W2; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSO7+6W2"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-156cbe59622so42525c88.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 02:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791364027; x=1791968827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2eXEVtdk6q//d2bGfSFjGQVcCv0Jpcj21oh/jRiX0+I=;
        b=lSO7+6W2QWYUm0G7klsF45em4O8S4pWZrym7hfTPygrMvvsKq3cUuwfFNSHTqDqJw6
         nqNjmNY6QK5ilORftPAhq+5AdUCl20AbqwvR7gkroVwmI9XsSVroKAAVAIZ/2Hl8IDHz
         5N5houd7GUOUE8Jpn9pAVPRb7EUURRpwhJHrdR0PJGgoWjt3lV1knD6lHSouj6j/RPF6
         67sZckEKgbl1yCwGd8rpx1ZfgOSdgjfJ3udAtA7yc5wrUGVsezsJ+GNhbd9AATOC0E0E
         T2Ajc98RU/k8KGO0fVgnyso8rL/wFDV9s/SkupaCP/1Yl6tJC4TGXHPnLSweqks2of7s
         KhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364027; x=1791968827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2eXEVtdk6q//d2bGfSFjGQVcCv0Jpcj21oh/jRiX0+I=;
        b=g1DwvN9X1hfQxLHxb7bWBlxEIIXYKaJZjzP5TmEOuNMuBjG8fj8CxiT14yYnCiJdlS
         /hzCj9wjof8KPglI6pf/ae3X7uDdjY5dWB0rm79NZlH60Ycg8K0nyZTC+2h3Da53HNxW
         hJK6Oe4+3FMbDXPGwAyFwT++CH3nXaQkULRAp/kYRHuP9b8N/yJXva/A+irAznYoZN4d
         6m5HgHZ4zDszymjiY/06fKtv1ZtQSxTu9WhDqfhmUqEI1QHGShPse1439roa4CpArQB6
         497ubnKoCefHPX0nmV4Zr3YbOqLG9Wkf/0CDGol61J/QbMOlgaz0e7HewsfzXK34Tupa
         OzPg==
X-Forwarded-Encrypted: i=1; AKwUvBzz7R9WSLUJ/hPz3AQvyHv5jop6NKgC9NXJAjW2dxBsEK98YkdHSOl/Cdqz7N2qQoJDBzwAj3C3aQZMJw==@vger.kernel.org
X-Gm-Message-State: AFuF++kiA120QRuV/1+NUz1vssLEsecqp5YMdYgxCmBXAcr61TfHPQu3
	GpndhzmWnKFzaxCmtfDb5BllLWkCe9oIl8XvpHXaXd2Y8Uil/0NL5KbM
X-Gm-Gg: AYBFou1J4cotliSq27grX8gndXwZ0l1Kc/cjXhlyNW/CMyHkenOksM6yT3AaskDVOb0
	/VssBCEAh5GwL4bjLcx0wslPSAyrmBWKVa3Ink3H/oZ7hZAZzFy7DOnClU7EH8y26zCMTyAwZFW
	9jNRiAKlQWunwgGIl8+ITB4hUnLi/hU/eEm6fkBvNlwdaBqefuUwEnIe6hIn6N8f2mCmmZD5DFe
	cfRcaX5uuyoCtAHDgEoqJfdLWqjjpjGwypdjrgkF5Xiby5o5JMQSpLW3ZONNaCV88r3CTQfYe/a
	BKCirpdbE/PeZipLJoA+bwDPDh3ilMVWkKiUJrQeNH4odlE7i9W6IX34W2Yn1FyrMEunIywQdSg
	gFQXc7R2mHqdXXFLJTzr+e9cIhZ3zvMa34xMeaVQZSZcIAn5h+tj7mYuLQJ+8a37fn6mYbc6VRB
	q1+M7KxfQNwKNk7R7CtvkTuCJQZvu9emb+o6wRfKwPO+XqbMmmo1ybfKF/MTqcnd1ETTZDL8OOn
	j1ojudGO/pOmo+Mhg==
X-Received: by 2002:a05:7022:7e09:b0:144:eb46:be0 with SMTP id a92af1059eb24-16204a7fe7dmr2141821c88.13.1791364026626;
        Wed, 07 Oct 2026 02:07:06 -0700 (PDT)
Received: from user.. ([2405:201:c052:b00b:b72a:73d0:d61a:b984])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-16168f62a5esm5470119c88.14.2026.10.07.02.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:07:06 -0700 (PDT)
From: pavankumaryalagada@gmail.com
To: dsterba@suse.com
Cc: mason@kernel.org,
	wqu@suse.com,
	fdmanana@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
	syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: fix use-after-free on quota enable allocation failure
Date: Wed,  7 Oct 2026 14:36:56 +0530
Message-ID: <20261007090656.20609-1-pavankumaryalagada@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>

The quota root remains on the transaction's dirty root list when
kzalloc_obj() fails and btrfs_quota_enable() releases it without
aborting the transaction. Later add_root_to_dirty_list() then accesses
the freed dirty_list, causing a slab-use-after-free.

Abort the transaction on allocation failure to clean up the dirty
root before releasing the quota root.

Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to reduce GFP_ATOMIC usage")
Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
---
 fs/btrfs/qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf7..42be06675c90 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1204,6 +1204,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
 	if (!prealloc) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out_free_path;
 	}
 	qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
-- 
2.43.0

