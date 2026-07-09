Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CFC34D4CE
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 07:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783581344; cv=none; b=R960ueH9L4nWld8Ae8fDTqZEHo3Z6w0rs4gl4zb9edtwn+IuJe+fShMUxCw+imri5EN0CmPT/dV7LiB8NjB+6FXw4ZodXdGOMwfiwucNatf0c2EYzwqr+MrTDyM518dUBWsIo5f3dAs4eMPRbBEUqBQSfMAUdazUIcLJ4XwL8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783581344; c=relaxed/simple;
	bh=pmLieMeY9FSZ7N6U5T1Txr6dVRVpW1VGBx60EEegIT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MXRQf6hDJ0EB3Tw/kO7XrSP59ZrqFe9FLGAClrny9qzHCxaguqTweEjIovZxoeHQN0XFH671VIjPQ3n4G9Zu9S4WU3e8nqSe2HLbKPYncOK22sxKpsPDNVVRo99hW0EF7V7WMblyE7CWmEqULLE4Kp8tT6Ln6SckOlcc1Ajaarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pZIdgcSL; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZIdgcSL"
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-383fd2d12f5so163140a91.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 00:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783581342; x=1784186142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z9mC2r+plz2vR6MKnSTtHq6AAkuzhKbk1QsnBUyzutQ=;
        b=pZIdgcSLX4Y4DM0Q9n/rtr05fc+SsgET1FBokVH0UJpOxFt4eCos9fyR0TbO+csFBE
         9hyoE3mRFiQsfvjprAPXFdER7I5VACsKwqQ18JhyDgBgQemXWReBW+hTROu6zpoLKCUp
         1bQ9ZJmw0YbLk0oPClnAi6Vnbju3oGOsciatqbhI/6oKlAwOzzVWP7YLXEiqIxFM2YWs
         QC6vf+PNASGY6OTT8K6lURgYwsBfHPDUPXuU9WZSrkoVjNOp9+s11TRq22N/+u6Klk5F
         IYTjS1iuAkeW24Ct/AVhnpXS6OUlRfNcVVFOgvCJibHLQnDFg1JcHmW+oKb/wmLY2LoQ
         KEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783581342; x=1784186142;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z9mC2r+plz2vR6MKnSTtHq6AAkuzhKbk1QsnBUyzutQ=;
        b=byAcIsxdMbfF09r6eBZuNNU4vSRAZkA5hQuD2e1Al0O4seiNJ66dmxXgQsQUBb8laX
         Y9sxYl0Om3XIScGX1YyVzvaN6c9t9JHEMJR1o76NmVoDy/vvar0FcIUump3pEexC/VGQ
         wopuvpSV0MAoG/GRXfYiJqKJBsW8YR1J9TxJHeU80Erelkrh8RZbnZZZGJglL4yRYhJg
         2GF/yxHj7nVFaDiyno8fqW87XeuDHqnXalZtZScC8yxmDpsi+qOH4jluYR3bP5iJojV4
         vQjkBmczvduZsvQ3kV3TVQYeU3tmV98qaJktKZXWNlMtaj01iOJN9jL+sphcVJJW8VVZ
         gV1Q==
X-Gm-Message-State: AOJu0YxQOTQNElZ6hQhk1HjO2rzHdOlFYD4hnQIELHo9iPYbDal9I+oU
	epJgb0kjQarDNgs57KfOE71+xbeQTJct/jdqU26nuFi7odo8l5CtXptl0ezMu+hGn74=
X-Gm-Gg: AfdE7cl2VqQnab4S+D1BY/3jZqWJPda8mu1tI9CNHYGQrr9bwPQO4rSq/v+2CkF9U0t
	8nWTAqXBlXerMnHKlVhPBZBGwnmVSTvgcieLcNfA4Tcf29XdR13FtEEx2njZ0zdmdWy52JXvyV7
	wUfYW/bMfSSsQRz5nTEwQAjfF45vFRaA/xVc7fhD/hcfJQc3xNY0gpSrZdfF1T1HrP4cOeX4cRb
	CK1AKtT2actswy3gz6EmBMCkpeHIQUml0CHlKF/LiAXB1+J/0HQeJGXqVi1OBdnIP0uIx20YK0f
	GxBNmXmkDQsl74FU+Sx6Xx09FJJ2fapUOvSFxhCsYz/relfzdK+P7fgwVBh+cw9SvM6AC5Qrhvh
	1at1pGg2Ky3mvvDCNSBmSaSwkYkMhWbhPHPi76eDROLJbdwpbXZGuFkul4cioJVtpI3EcyqK9ZS
	EYZDhkz+QZU+Y1Jw+NLL9zQGWZiBzfbSlasWdyuguK
X-Received: by 2002:a17:90b:4a45:b0:36b:3ecd:88d7 with SMTP id 98e67ed59e1d1-3893f97f006mr5131967a91.2.1783581342544;
        Thu, 09 Jul 2026 00:15:42 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a57dc46f4sm682998a91.11.2026.07.09.00.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:15:42 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Sun YangKai <sunyangkai@fnnas.com>
Subject: [PATCH] btrfs: check if root is readonly when setting posix acl
Date: Thu,  9 Jul 2026 15:14:36 +0800
Message-ID: <20260709071529.4033-1-sunk67188@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sun YangKai <sunyangkai@fnnas.com>

For a filesystem which has btrfs read-only property set to true, all
write operations including acl and xattr should be denied. However,
acl can still be set even if btrfs ro property is true.

This happens because no function on the set_acl code path checks the root
is readonly or not. It was checked in btrfs_setxattr_trans() but got
removed in
commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrfs_setxattr_trans")

That commit didn't check if all the callers properly check the root's
read-only flag. A previous fix is
commit b51111271b03("btrfs: check if root is readonly while setting security xattr")

Always check if the root is read-only before performing the set acl
operation.

Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btrfs_setxattr_trans")
Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
---
 fs/btrfs/acl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index e55b686fe1ab..7609eed6f41f 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -107,6 +107,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	umode_t old_mode = inode->i_mode;
 
+	if (btrfs_root_readonly(BTRFS_I(inode)->root))
+		return -EROFS;
+
 	if (type == ACL_TYPE_ACCESS && acl) {
 		ret = posix_acl_update_mode(idmap, inode,
 					    &inode->i_mode, &acl);
-- 
2.54.0

