Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765845;
	b=Mrqi4bu5jLHjUZntqkozcfxKotYN0WrML4ZKOYcKh7XFlzoOhJZS9TnYn5Jx2Ne1+IyB
	 Oxteq9N9bG4PZeUu9BRfISh3wf6OrhyfAgE64rdMkA28pIBr7FEFgHAKYzG+3LbjcJ41v
	 tmHrgWJxZ4HWsUapEP69SIBlpEFQTkaOjk9ztNqKVTaKd+Pb9lKgcp85mwn3nyoAdYm5O
	 X36o7Ujl4vmiBNrPLu/L06W6hcQ/OiogLizOjhAjkMNHFeL0aPbEujdFD/H/Uvy6+h6zp
	 4yYhk+rvTSiE7Lx+l5eOOq3ZLTa9emMmsZFLxaJg3nB4083CswUBOpQnRC9AVugb/Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765845;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
	b=kciDl+F8EsuVf4kA4wragzUXpk5rH1g4A5dDlCXLH4SOEGDuLT9gah2RPoan2Xba7H/B
	 BT/mZ7Qvja783+C9TOyp+yTxl+YDhnOgjBP2RdCp/85aAk157G2hzC6P5CE0Bqu9w/8Va
	 LZzescZ5QOV0361GqzAy0PHAA7/w7VQ+wxjuu6zypDma7Ao242s0XatGI518jGKr3Y6Gh
	 9tPOcYgQc7zicz53RAuyfGj3sxtky0pUdmNBEgMAWLKF38IxNXypyej2rz3knBqfvLDnJ
	 6u5VQUwwg+/zrNEz7MryyNzMnohmPOItZjsfGxx3hrmI2/jkWm8wrbY0TgDAyzinqlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IBD9fQPZ;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFE5606A8A5
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 18:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BFE5606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IBD9fQPZ
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1278851f8f.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 10:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765844; x=1795370644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
        b=IBD9fQPZzDEKg2bdACsPtBrqMrB7RpYNzqy1KmrygLKNqfGgfMBRaPWVmtSMny9Uyo
         zZZXZUcxGun91msLJSPue4OSf8KXgtednCc0ci+LHlwiRCT7BYfwj6SD9fUlUIoUNNdM
         HjfCIWv0XLZodUGxpASoDy920nowWC6vgr7iHYUYL+7eC7K2ekWYt+yxN8xnL5lTbX+/
         iPXMXBJgcRIoFjYblNIEP9XDiGpFeZaYRykIxOLk9q0/b6fE1AF+H2k0K17e9FL8HjA/
         bPcXWcQ7jEc4YWkcaZbecSnNezqq4f/KgXnLXzb11BA99Sp4jVEommfOUsdvdRwp16i1
         ptAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765844; x=1795370644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
        b=PkvUHan2EqtOIE9rJ3zXHUadpx9fpvu9ShngBJ8bSnJhFeBoeYVihUe65t5zhKLllK
         UZb78lttPCBhZBbyeDk4KzkH2+z5B/2se0dDUfE0Szs7ac8DXlBIClSsI24bD8FGHJDO
         QwInPJPcqUj0kMUmLtTYANeUYgN013neSrqDUnUn4rqQO9JeBomuqv7vD10cVwwMXkF6
         OsDxwWOQVn613Pqp+nVWagAWhsOGJWSqlZWYnxoM4+aW23v3YZ1BE+I+P3yPVkr3Fz2R
         JS2Q1Azawe8Y8bsqtFwE4QluIVZrjtYlCP4QhaywMs9iib4IeXULJQJjBOjGn9Me90Ix
         Cl1w==
X-Forwarded-Encrypted: i=1; AL+hErE9U26kbRQcvS0JQNDESylLluL1FtkvgVNum8ZzOI3RzEczVq+nL+ObkoZrt4tUC3Q/mDWpwoCzwbkKfg==@vger.kernel.org
X-Gm-Message-State: APuU4Z9dU/OJlgEIa+nXFBGcq4GdUs2Tlta24iEW4DVSa+qZU8PMPvNr
	RXV5r9n8xe0vtpKcUcJtnu0KGLWN50PX0FbuDaa+tfzl/c/i6hyEEIGn
X-Gm-Gg: AYBFou01X7l3tr8MLRuHzhXmaSlznE/TcMyfBRd3w51ce8t8hA1H01LDLOki75Yz6th
	GTTvDh5kq81qpOb/fmrKX/QZY2HarvvzMPapX0+ldh6wSu1XrolBg3UsfjSBO3pZAvUellxu4cs
	CBvyiD+/4PkaUaQVciVwxWydc6Tkeh8cKRErV+IhY06CTjSecFM4011T7coUNhrY1/LLbAvNloY
	lt52BsCZxj4p906BAdZvFXMIt+Ygu99No6wocQbG1r9tUM+uQT3Jyg7hypmFoVfCTHnMzUzKPv6
	DnDqv/xEt6XoUDdxxqGipBgiQu95T77BdTz/P8fTaNSTmIgR4dGp7K9hmlFr99cfU56Qh0/2SyD
	GorzW8mRfGC+x0wgE+ptquOZjqsXUTeXWQlc0e03oVm9Q7rYXI0tjeHNiwspSrknH9xp7YtXOEE
	YYFkIKUc1Dk4Nj0TsmaqPI9Sq6C1n4gOUFbKtL89pQgYqZ3T61QhczvnC489V5AHw2jY0S99edk
	N4t0JFQphu8rnX9Wu0/DPOSXinT7hkX8GognMfnSgW76Fn6/qKJQqgwdr31kzW1qRpVUHGmjASb
	idZooGyDCCcWnf8MmEVMlUMl
X-Received: by 2002:a05:6000:1841:b0:48f:d7cd:a5ac with SMTP id ffacd0b85a97d-49c6b97336emr21325466f8f.0.1794765843381;
        Sun, 15 Nov 2026 10:04:03 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:02 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Chris Mason <mason@kernel.org>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v4 02/10] vfs: add fileattr_has_fsx_mask()
Date: Sun, 15 Nov 2026 19:03:35 +0100
Message-ID: <20261115180343.576773-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115180343.576773-1-koray.fra@gmail.com>
References: <20261115180343.576773-1-koray.fra@gmail.com>
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

Add fileattr_has_fsx_mask() as a helper to let filesystems check for
unsupported xflags while allowing supported ones. Can be used in the
same way as fileattr_has_fsx().

Also make fileattr_has_fsx() a wrapper around fileattr_has_fsx_mask().

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 include/linux/fileattr.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 42b92ccdc583..ba7ed3b387d8 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -65,6 +65,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __user *ufa
 void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags);
 void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
 
+/**
+ * fileattr_has_fsx_mask - check for extended flags/attributes
+ * @fa:				fileattr pointer
+ * @allowed_xflags_mask:	additional xflags permitted
+ *
+ * Return: true if any attributes are present that are not represented in
+ * ->flags or @allowed_xflags_mask.
+ */
+static inline bool fileattr_has_fsx_mask(const struct file_kattr *fa,
+					 u32 allowed_xflags_mask)
+{
+	return fa->fsx_valid &&
+		((fa->fsx_xflags & ~(FS_XFLAG_COMMON | allowed_xflags_mask)) ||
+		 fa->fsx_extsize != 0 || fa->fsx_projid != 0 ||
+		 fa->fsx_cowextsize != 0);
+}
+
 /**
  * fileattr_has_fsx - check for extended flags/attributes
  * @fa:		fileattr pointer
@@ -74,9 +91,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
  */
 static inline bool fileattr_has_fsx(const struct file_kattr *fa)
 {
-	return fa->fsx_valid &&
-		((fa->fsx_xflags & ~FS_XFLAG_COMMON) || fa->fsx_extsize != 0 ||
-		 fa->fsx_projid != 0 ||	fa->fsx_cowextsize != 0);
+	return fileattr_has_fsx_mask(fa, 0);
 }
 
 int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
-- 
2.56.0

