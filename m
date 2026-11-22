Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306156;
	b=AmKTXrr8jtRnb7MpkMcK/1bWhYLu2tsmI4/n0PdfXAspLRWhI+Z0t++ZUVRv+4xxgPds
	 O5SMNLGhUsgZ1ovSTwAD/9uhlaZUrhtG80J8u/tEW4UMyWKHegDUZ2czQLVC7nIduFVYR
	 eD7ugaQRlD+5m00m2RurYzsRvFi0+PZbBRIWq8qkN6DzXfDYhL4fcDHJ7E00tT/JgP8J5
	 Dkd1CDXOIz/LcvkW/3JSGSvcmE9wQu10EzmFbummBY/G/0vnZ/y0dupbjc5Q7k/W2jf/d
	 jG466ATgGvzQcrmh11rgLCv25yhL+AYFJ7+tTarW2fwtYNoGplaNSGR8JQsWnwjTeVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
	b=BM83jLjgJetxE22Qz1HOddsRkABHXF20MeXrJVuumY8e31vIlNJHLi+MS8F1ze/fFDyS
	 OBKsHc36wbUFXaIgQzSehz0ta4ZTAKiZRNiNvXGvUyHtUit3yfb7Z+4L/WM4gvA8szPW9
	 8WB5sagcEW85Sqh1iBc2EcrEdyPbGaJGIl8AAX08K0ITZesS+41RVFc99aY1gXu9WeR66
	 ZmQE0wTwNjAIGFCiknMGDxZ2avKeiN5ufiC5EXMt3uZCVETJXZ/BgRpFSL/3sE2fmGSi2
	 v25xNKYvjyTLzb/ldEsbaLz5NzrH5vlEnVLnY/mYjYoVBLUTrVG7tM9dw16Q+9dSVsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7B1606A690
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 00:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B7B1606A690
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pxx4MEVM
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso1855023f8f.2
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 16:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306155; x=1795910955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=pxx4MEVM3F9ewoA+cmrYZ5iJ7GG66cT5YEMw/9bSw+32AQdbNaeyaZM+3JoC/dwApz
         UTXTyt2hP1yxywMm4hNVJePOeGz0MGnOqeDT59BoZmGM0iHtv3qvQDqcKJ75ZctYftXA
         kPEmslanb0UMiXCiyaAj65FLQcg9cH55lzNF2rhCJTB0VVD4RlJR8bfx34szlVVEKDaC
         /SQf4GCr0GacL1gTvq3QehD9mb/pXaJT0DU0oIq9fiin+wEYVcS/rJt2xmbLSEz1RYGY
         zZWz6FecCb/clp9mCPrinCaau+nYvOhVOjDICs76X+KNwZWPsk1GaY5WrM54lZtPqKFa
         teuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306155; x=1795910955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I3/a3+7dsQvjvECUWVZ/SwOHlfbc32z4n2+Zae+M7DI=;
        b=j+/rMUs0WskOg4mjkcR80DNKCzG852xMwIkIYyOpy1zKuIl/5GFmJUp0g/gS5kwA63
         pMZrizh2Iot7zvSrL5yk+sBHi4aEPns3ZxByEhds5WA5CgPl9tdjMZLdMMu0PI202lUb
         9HBn/0rLe6Ywh+LFZEnWmIPJ0yyCGel87yh9brNRwMdBHUwAPEUSZRmYCFQsp616zhp0
         KNUxAfHkMIW+MaLE32ooYRN1PFek2ZI05zbcSUOCBmuQEIfx0VMZX8Hw0ezbcSPtELsI
         pamPhJBOAxwHStzpItw16keIw/iGACir+Mqb2Vq8+zOOczNqUWtfd1ZAi+I9DnK4lzL4
         RC8Q==
X-Forwarded-Encrypted: i=1; AL+hErEho6btSQIGjUHSxMAuDk4F5wX1coaR5tEzNnX6XmnZ+Z3+IAwFkqpFs5lN96+VZHrOgmW54KMaF9jotw==@vger.kernel.org
X-Gm-Message-State: APuU4Z95F1hGMvvjPJc6CBnn3LroYlDPhk77cAQDhQyi//H6TkpVzEmy
	ly3ImbOIKTbq2Jq8DXxqHtPQqSvoVW5t/begrpXV/GL3Ynq2NJQ3pvQ4
X-Gm-Gg: AZFdTZfPxTZDtkyXJBauYl5lG/fPLESgJOyA/vnW1Jxnr1ARXwhXFhhjE04ue0wVUEl
	CXxJg6fLhs2Jr3FwnlLHwBvo1tlyVhg+AIZIA8Zvr3ifUDKW/U5IbQxYBanD5R9MRadh1KWJAxM
	mrr/AJY4SgxjseNCP5uTMu5vvwRWgCaZBeR1cbzY2wUlSwflYZtrA5yYABCFAwQ9eG17HHj5W7W
	59p04e5BQ8o8STVx6UUZ4eFKvU4FL8rrGDhEo+7/3iQxt3lnPpzDw8EtrKHH/53mY1Vt4aFTPaD
	Lqp46OLYmwkfWyTjPuABbt9nqxg70w2HF+AdtCCupZJ5FsmldWXODWRZmM/nkzPEPmpPLKP+2hA
	PZKSNTChZFlBKF7cYqQy1FGGtN9U/L2T303S46sdkBsUGaaGsd0NVRZwMDBkDXJti7R7JaNZpbe
	1t5c8AxhaDjdYIDkGVc5bSeGc3KN7aEXJKCPw4ud8aJIpFSpZ9DQ8s1w+yngMaui4FtyfggZm7X
	jent8y9KaDTUu0FOkCWkj4tq/hlfm+maj2pkfPi1Sa2NfUupyPoNBW7YiasG4RvcFUjEbnotexq
	yG+5lnXgPFR3cLlnQGXJatmIDx71IbCoHRzMilW5nMVoHA==
X-Received: by 2002:a5d:5f4c:0:b0:48e:5d33:da5c with SMTP id ffacd0b85a97d-4abad5aca65mr14743143f8f.1.1795306154599;
        Sat, 21 Nov 2026 16:09:14 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:13 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
Date: Sun, 22 Nov 2026 01:08:54 +0100
Message-ID: <20261122000856.536902-2-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
References: <20261122000856.536902-1-koray.fra@gmail.com>
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

Switch from using if (!err) { ... } to the cleaner if (err) goto out;
in the main body of vfs_fileattr_set().

Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 833e03810b24..40d6518f1d8e 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -285,30 +285,31 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 
 	inode_lock(inode);
 	err = vfs_fileattr_get(dentry, &old_ma);
-	if (!err) {
-		/* initialize missing bits from old_ma */
-		if (fa->flags_valid) {
-			fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
-			fa->fsx_extsize = old_ma.fsx_extsize;
-			fa->fsx_nextents = old_ma.fsx_nextents;
-			fa->fsx_projid = old_ma.fsx_projid;
-			fa->fsx_cowextsize = old_ma.fsx_cowextsize;
-		} else {
-			fa->flags |= old_ma.flags & ~FS_COMMON_FL;
-		}
-
-		err = fileattr_set_prepare(inode, &old_ma, fa);
-		if (err)
-			goto out;
-		err = security_inode_file_setattr(dentry, fa);
-		if (err)
-			goto out;
-		err = inode->i_op->fileattr_set(idmap, dentry, fa);
-		if (err)
-			goto out;
-		fsnotify_xattr(dentry);
+	if (err)
+		goto out;
+
+	/* initialize missing bits from old_ma */
+	if (fa->flags_valid) {
+		fa->fsx_xflags |= old_ma.fsx_xflags & ~FS_XFLAG_COMMON;
+		fa->fsx_extsize = old_ma.fsx_extsize;
+		fa->fsx_nextents = old_ma.fsx_nextents;
+		fa->fsx_projid = old_ma.fsx_projid;
+		fa->fsx_cowextsize = old_ma.fsx_cowextsize;
+	} else {
+		fa->flags |= old_ma.flags & ~FS_COMMON_FL;
 	}
 
+	err = fileattr_set_prepare(inode, &old_ma, fa);
+	if (err)
+		goto out;
+	err = security_inode_file_setattr(dentry, fa);
+	if (err)
+		goto out;
+	err = inode->i_op->fileattr_set(idmap, dentry, fa);
+	if (err)
+		goto out;
+	fsnotify_xattr(dentry);
+
 out:
 	inode_unlock(inode);
 	return err;
-- 
2.56.0

