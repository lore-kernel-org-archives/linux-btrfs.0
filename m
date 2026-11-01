Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498247;
	b=SY4bXgu6bcADRxL9WhrosXYqMfj8oGuccAhc3tmR0GQApANlgbgEovkPVKaI2tMPI+Uk
	 7doUuGM8kzkDRItb5tkKSeOkrBmA93r4pBnEk3awnFTX0jDygvmhusLBKfRCF2Q6Hs/5Y
	 P7AdCeSYQBqR4wMvsatM7pgsJg99KRNRG8bSZVZUScppaXQhWXULCXveD7AgQMjaU6W5z
	 VsLYsAqX7fkwOZ3zE0vH0KWvNpfZYxNOPZZOLRCMCN/3DYEfdv6bIrtMxsltuzzpEd5Lf
	 8NJ1B/Qe6L0/DFJ5WpT/c4flrELdUVrS9qsGeKjjlq1HlXEoqTekWWNUui3NJDrwq+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9AHT+4uPvWe1t1h3zSSbp4rofXCcWo8UcjGq3mTB8UM=;
	b=RPQFDO1XqujNnpQKGHyvT/zoBX3F6RK04JQeuHq5qIhXYuOwcLAub6wl34ex71eFkbRR
	 /NZ+bYQ047ygh4tUhLijC/cE1QhFQ3WPr7tdaJ8U7h4roQcCvi+MoCZd6yXme5KvKHyGk
	 oce57PVcXRWnPmUPvDTxlnKb2Dt9bGy15eWzaVRNxfhCw78RswtdPv8ApTijRi/l/2nUa
	 tC/+zEak2VNZru0dkPbCTclC+YpXqaLgiTxtOoFlEoaJqQV1OwniBKaZlJr1tanqbs9KQ
	 PGZrMtFDaerLo8XkVuExeJo+MPi20q32qoaeNk/2xKJbRdWnWzRthPVPL+8yFfebGEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c6E9zXny;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541A960A2626
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 01:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541A960A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c6E9zXny
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so17480865e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2026 18:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498245; x=1794103045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9AHT+4uPvWe1t1h3zSSbp4rofXCcWo8UcjGq3mTB8UM=;
        b=c6E9zXnyBd1dxj3QVODEevFQOkW9llb0HZ5WHJHiNOiNB9qd6qEdsxAiD88lBYRUhy
         RTD8dwAyeeMQ/P6e4XpBTyYr9CdHq1Z5ZoSjnOcQ43l0sSRRE2SU2bVaKSbP7OFiU5am
         +YnZ3xy+tatzzdG5jV5qTqox0i5Za2dg053/k5zKoz9m5X4KZjO30QPe4vk/Rih8omDj
         kkesHih7L7GwtKXoIlBExVUv6BuqM4MvhmN4pXiSiKn33VEAT1eS/KXlb8GZySTFSi63
         R6NVPFry/yoaz8fuwwf1PLpHwOl3hFTsQpXDci8LWS15HRCyP5IWZVyH9IoPaEqPzTYF
         IT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498245; x=1794103045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9AHT+4uPvWe1t1h3zSSbp4rofXCcWo8UcjGq3mTB8UM=;
        b=HSWrMcGrjWwVgNW97ZLvf81tBU6UdO3RZFjM5VtGFm97XARQHbayJiFIbHF58iEoZP
         1KLDmk8D9rr60Jtq6m8VtmslTKxHALWAlbJYceGl+rL/08IRPUVFbCxpZi4fS6ln0GbS
         18/bBgN6wEBEOB3fNW29Jadz2e9DguKOQhunmdlIjicIo1/T4Rai3W/cAffJiWUStQo1
         0gbmL/VveiVexPk7kkIHgMGHUwcKwPVCdd0Rbm8Wg3lK2gdUa9+JQa/15vBVFGOEp1Yd
         +xp40uKpq2t2ssELtA4AwGsfv5Amn9wZduY6GIR9zZP6wtTB1Kjd3M9nzYHYLo78gmz4
         3V9g==
X-Forwarded-Encrypted: i=1; AKwUvBx2foBdykFnJYOqpNfS7Rz2X4oQoycq+A/mVnfiAomXA+sbeqWJvoiB9Nj7D6JciRCRV44KZIOek4IeYg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLn1r7/QF9ANZNhBZ2AyRgph+g8Njb3N7B3ENsTb627R5X67fWq
	pWjf8adpOZkwgoB2ZfmrDfz+IXf4+m68S8kI97rOhqomFYua3+De7fLy
X-Gm-Gg: AYBFou3Jni8hcNa5vxa0mhA7yb7cbSsIuUL8QoE2tA/sKWgXma9okkLXbMkUQDoYUod
	cCZZH8uAf6Sj8pF0o15iTtnL7JcobCREZRz+fAjV5+PUzu/cbTYLopNBDbAbfx2B30WjaghaDYm
	OvQlL+3chSMsqxat2E0Dnejpd7HNthKjhx1s89+U6mT1dTPRAfxviOyUPks4l0e0TWewPB1bVgX
	NFMPPAnsHVrp0X2x3IBwdM2nkD9dBQaQyJwRNdyFGFHxxQ+0YLyEhjRPz4MG245tysQLnJfh99X
	1XKuINwLUHjYRPIWvpO3RJK+y/ZoxKo7azVBMDLUjBRArQYmWRyjsOhogRoWGHBnCADwkII23S/
	IQGwZ3J+8lbJk3b97Gt2LQpFltcM+GfVFzB/ZyHdvPcUlid9wprbrl7oRJwdhkIFlbERdnIG4Q8
	znrp6xTpBQhgN879WXRaAadcKeNrLW06AifLaK0KnMPWEnlmxq3LRD2/uSE7ztfbQiA5HETn2Wm
	X+tontbhY3QZH78LMEOxyGqU/GoldFKkY4qWs76CghcArqORXGABvD7Oz/zDJt5Aht5Z5+TUlTX
	rn8x6pY+qTpWt/w2zX40bo+o
X-Received: by 2002:a05:600c:3ba0:b0:4a1:e0db:8cf8 with SMTP id 5b1f17b1804b1-4ac151a84f0mr142228025e9.3.1793498244682;
        Sat, 31 Oct 2026 18:57:24 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:23 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v3 2/5] vfs: add fileattr_has_fsx_mask()
Date: Sun,  1 Nov 2026 02:55:48 +0100
Message-ID: <20261101015551.786044-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101015551.786044-1-koray.fra@gmail.com>
References: <20261101015551.786044-1-koray.fra@gmail.com>
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
index 0b93f9609284..16acc61c9af1 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -64,6 +64,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __user *ufa
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
@@ -73,9 +90,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
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

