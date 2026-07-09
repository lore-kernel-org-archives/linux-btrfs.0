Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B73EBF3D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783585590; cv=none; b=ZVSlzR31zDeG3BR+byR5Ol9Tw0ohz4+ZzPw33JwYdLpxvVplSZuBzIPXEFkA/a3Cw9zl/G2LQQEWlO+q7sVK1zESSUYQ92UdBxYMcK79k2XGx5qvMm+6F+zNlPMJCb4gc4VtH3e6/Baba9srBwax1YcsmSFCh3zYAoX7LxALBn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783585590; c=relaxed/simple;
	bh=kVtPRnjiILkOIhsj2B699gHt7TuJOd3mg+1QieHIhdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=egMU7BWouIt7Rasgea46xRgw6LJzBXaKbjX///Xg3OyIAy9U75O9Jryp43SRl70lzcGx+ePCJgiAFNiRf9L7N1SggYYGJUjoFTe6F2A9K7IoTwAWWIObSNe58iX3jFImPj6025djukT0jH32RHb16EWbmRdaJoooJYjpbAwtBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k7HRH01b; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k7HRH01b"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2cad22567a0so2060805ad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 01:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783585586; x=1784190386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F3MiXy0rzTUVB5DNSHKN+7GjYLZuQ0M4g9asrCkPzeI=;
        b=k7HRH01bPeSCMDfuv1xA1TjD5K/jw1DsxccdS5BUWf8gh9FwxzFtdle/ot/BH5nxZg
         b11ShxdUbnyo9QhXTR9I13zhsF6R8Z/BAzowAXJhD7zkoIlLrv4bWz73yPaiNmdjcc5z
         IHJUQFdvcwIHd18eo+03olLKypeBv6BqyrfOnGj1GF+od6PlFqGts257S2zll9vc9FhB
         rRvFb+CxlsIU0PS4uEREtV6Z36a9e4lxyTaTmn0/dAYOSNeCqgdPWgz6ZMjLZq8PpGp7
         cUxNwqb//mwOlkvrKskwV9Vy5X1EJ5QVivuv+yYzWVWDy/arKXsdIdiZcTHIWAwFP2Ii
         eJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783585586; x=1784190386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F3MiXy0rzTUVB5DNSHKN+7GjYLZuQ0M4g9asrCkPzeI=;
        b=NVCQuPSA/qhhoz5l9G7r0SDeur51qNRPFq5v8uFg76fOfptwFbyddmb1QrR3jZdAdZ
         DKA0zxkZV/ZvFCxmo7H3+VTKi4FHFUJLbqbJyhsCNYpTBDggKRMPODMuVXM13t4byXQK
         AEN5j/FpkPRZ2jC2N/Ibb/9IRgJ0lDcQ6bNTNCmIehZRvijxolY+fNqY8v10/VyH5/AE
         UfHfvu5KDFeUL17J1/09rBKQnCZokEEZ4BhYSkZ38nGJCMVpgRzrCA5T1R2DLzdZglz9
         byS0xNQeI7qwvklNvGdwvBs/gjX6u6HUaz+E8FjrcKFnvEsxfBj3sMQldlyD8OJ5P8yQ
         0X7Q==
X-Gm-Message-State: AOJu0Yy+WEMNI+MlcIgPNrj57+xBIIOKtFdNU3jUFxLlWsZ53uxSehlx
	zRt/V3cHvdNINzl2dOp/x/daMrUcFgSpwAj/2ZIEWgGSKW29qZhjG42S4LHXdCfmGUE=
X-Gm-Gg: AfdE7clW9ibMdIOh5Iq29s1UWf9ucgsEx4mu8awaHYr/03duyG7YGdVLhKMxUxE2rZu
	3T0TaDOnUlOyDCfVAP78lQeaRGO03vSr3Hhu/STgnGLMH2Xm120xgF8T+Rs7DKxawMECcDvdiUp
	qyd0GUqmYksIRVB6BLFbw6PIZRY5O7SZJgev1eCDdjRjjUCQ7KOJ8uX7PGPznRC26Ica8vgdbqm
	rcbHuqYoPb9ulyQITUrl5TmUqwmwBK6o3HmoGqvt5/lfJ9W2/HT3LdzkyPnc34UtEZmbOrKhUEM
	iGBd0fDsg63EeUbssl9A+Dj78waF9+gq+W1MW0lOm0MCYwZh+AWJoZ1oO/do8ca4P4vCdMh7xEu
	AGzwUkVBpDcSxzlvfMeDvY2Op2mMgQs7Wl1zBJzjyLtNuA8W5jZAiaLaGVIJ8HyU/ifj9oDwRru
	1g56LKF5paXlz9U3QC9sFI8ddNIorcwcXtjz00NkdM80LoHg9s4Bw=
X-Received: by 2002:a17:903:90c:b0:2ca:6885:8a06 with SMTP id d9443c01a7336-2ccff1cb1b7mr27553075ad.5.1783585586433;
        Thu, 09 Jul 2026 01:26:26 -0700 (PDT)
Received: from SaltyKitkat ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d3d2efsm39859545ad.64.2026.07.09.01.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 01:26:26 -0700 (PDT)
From: Sun YangKai <sunk67188@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Sun YangKai <sunyangkai@fnnas.com>
Subject: [PATCH v2] btrfs: check if root is readonly when setting posix acl
Date: Thu,  9 Jul 2026 16:23:35 +0800
Message-ID: <20260709082500.17907-2-sunk67188@gmail.com>
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
Changes to v1:
- add the missing header file

---
 fs/btrfs/acl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index e55b686fe1ab..662cdd1cbdef 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -15,6 +15,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "misc.h"
+#include "btrfs_inode.h"
 
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rcu)
 {
@@ -107,6 +108,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
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

