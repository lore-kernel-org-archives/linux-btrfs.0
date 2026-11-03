Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793735271;
	b=gmE0MJbCLf13a4eoLxEov/BiXrZhd/g4U/LSKMVwbOTxv4SJThZGlX3DsNQiZTajLCrY
	 GGlX0TLYtc9OklMAShurwEgzOW/yNj3geGT7Yfs41VRk39kBla6OJnSbmOkC/+USm7YXy
	 sfWOePVYBhxsv9nwksD243CphpHVvnfcdTKOxTt5+0ji/eBMiCwXWMl5pDRo385eq121k
	 0N9WvFJPHcjONIiPEciUq4CFaCHqPmB49coPtyjn/L+xzMgZTDhsz8jOP9C3yMLNYw39R
	 iTg+9jbjKnjH6PPHmxdh/uiROZpiDXqq5Wu6+KKCkYyuAa5f6OQ8ZqBU3A2MuYsqczg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735271;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTkEOPsHRDG69921BJ5F8RjkjoByfmO/efjCn+VQlX8=;
	b=Vm4QAkNfg8kpygJn5DLMFeCfgYgKHC19rz+9N0G7Sk/gm/LKL+DT9qL3XLrkupouEhV5
	 XNMOP4gomESWlfiuqYSWhvMqSlhPA4o2RlGeozmRLFZRiVV921nvbqHWwsNwIIdzA636H
	 AULxsOEnfmFAg1rYOS98oS8NsKkIgLNwUZvqZC+tEmiJ9hIrT+Q6bvPCo6tZlFGcrjrIc
	 nXM8UNCN/CZikBY6J5xxSquHIO0/e2bl8JHLOCSxFrcoo6T5sG4IAvYMqQwZad6Cmr1fm
	 VGikjS9i3UbW2pRDHg2Ls42GB7VKJdS/cCwIUdYM93RW2d/Y0oFy4AeN3BwmbquNoug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hW26WO0S;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283C1606A32C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 19:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 283C1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hW26WO0S
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so37442235e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 11:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735269; x=1794340069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hTkEOPsHRDG69921BJ5F8RjkjoByfmO/efjCn+VQlX8=;
        b=hW26WO0SOOMBz0mElZpigk7JGQRSY7vUdE6sSwq7Fjj7GzWfgtKsLrdkAY4g418Kzw
         b/BO8c8MShJTnCy5CT+uhrzMjOFuPG8+3aEeKH4YepHutNbJ/WQDmVxHD4fGvaxZ1Os+
         RXDpW5x81SdPXsW+fHuDxf1MZo0yMQ5y9w60fud8v+DtXheGQuVylDn+2+Dll8nUKzaT
         cQ39d8ngxahfo9ERWTUY0EgrLGYh83v8GUrNdTZ8UT+hJNNtl2K7NYZ+fkgQVu5fRYmC
         kffquMmEUJSeodHOE+Df+Ux8LQxLxxZLuxQOR6AMBC/9PkYhO0P4cuH6PU6jgVKP9z2T
         7YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735269; x=1794340069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hTkEOPsHRDG69921BJ5F8RjkjoByfmO/efjCn+VQlX8=;
        b=hHNlzcO6opVe2XjqR2C6YgcqS4j8kl5z6gHuPwtX5aqXoxMaR364OtdCi3UDumjOUt
         ccZiiGMAPHa7Vxtnil+sSQjKEdqEwaLT3wNm6EvNeXWDylGR1LnUvyiAmPegqLAq+tG3
         E2NIPfdDiP9rd21yCaMbhrfz7gyVls+WZ1ZDs1TfhbIuVdE9OzKwPs5P4mnaOzcrHjr6
         pLspP/JaGzqO677lQUIAaeCYIqcelR4kHKLDVEPhXBVl/YZu5kVJcprR8YylDFFLeX+H
         fTztFjBD2E8AFy2srTCWxSrrFIDZ2ZctQ7IiSROUKvfcE32R8cYrMQPKAX1BjzJv7OkF
         mxfA==
X-Forwarded-Encrypted: i=1; AKwUvBziQFDXcy+gDh6BxGLXCNlE9b9Jl5EPF729iA9tW/r+KKGng1lTwKQ9BmQzagh25SX8z4nBOk3PoMe++A==@vger.kernel.org
X-Gm-Message-State: APuU4Z/kJv6iL/suUuJZZQKJcpfsd1QvZj6vnffQ0/tiI6qMm7dmnpDg
	9dNbS+fh2AI0CtoV/uKL7Q1OK8iwEe8po1HP9lmwWQIyR6mlipmHZxvX
X-Gm-Gg: AYBFou3UpRdkhZFIwtxUn5O2JIBgm3xUN4QIssvIGc6PyKZ3xU/wuUsQ6xCpW/GAEPg
	2/RBlm38DeMjycmujUQtHzx+WdQTjiz/Hj2LstSWwC7fO4WAom0posBjC4uPudnEa23RcfHEuzU
	03redUGlMMz+wc5vf39OImIJXWFAm7x/T8Ni45fdoIB7ZXRqbGZ1J213FYNtsIko8WdePn8IE7V
	PHeFW8VNcwEaEBoOJxv6YI/dzfm3VNNMnhBh0gs1UXf9gtca8vufw0mtdx2tcnj+hoNg9/fritx
	YzhN8vUpZtu2GwtQ2KnsC62bwOdguJHysqHxpVo1fyA1QU/1r4MptiPAEDXGiszBOlhtDdT0KIK
	kHuLDW25mwudA/GzxEeotMWM92+/XwqNOFaw6nMSUL/L8jumVlz2Mx4/lHvyoKIcSnaiBfC4dGd
	/bKnyUJ+1594t3OiOLd/pjHUfdnCEumJoMjyFmmPQBaHbP3Mh66nYJYx3CSHlWIybVj27WXcLpQ
	7lHAuzkQ9AdJ5oa9DbGtCCKeCwb4nd+qTXSm4cJR7A/sQ/mZz94QXGMyIYF1ku2RPnQGcwW0G37
	z6ptWfEE4qgVgMBnzi0gKFQR
X-Received: by 2002:a05:600c:1d07:b0:4a5:87a:50ba with SMTP id 5b1f17b1804b1-4ac18e5dbaamr318905355e9.33.1793735269522;
        Tue, 03 Nov 2026 11:47:49 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a879f401sm76832035e9.5.2026.11.03.11.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:47:49 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	linux-btrfs@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v6 RESEND 4/6] btrfs: support inheritance for per-inode compression levels
Date: Tue,  3 Nov 2026 20:47:32 +0100
Message-ID: <20261103194734.598182-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103194734.598182-1-koray.fra@gmail.com>
References: <20261103194734.598182-1-koray.fra@gmail.com>
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

Change prop_handler's extract() signature to take an output buffer and
its length. This allows for the algo:level string to be generated
dynamically, but now the caller is in charge of managing that buffer
memory. Before this patch prop_compression_extract() would return only
the address of statically compiled string without being able to add the
level, now it concatenates the level to that statically compiled string.

This signature change is fine because the only currently supported prop
is compression, so there is only 1 extract() function.

Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/props.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index effc2daa2e3d..9427be2f28e0 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -36,7 +36,7 @@ struct prop_handler {
 	int (*validate)(const struct btrfs_inode *inode, const char *value,
 			size_t len);
 	int (*apply)(struct btrfs_inode *inode, const char *value, size_t len);
-	const char *(*extract)(const struct btrfs_inode *inode);
+	const char *(*extract)(const struct btrfs_inode *inode, char *buf, size_t len);
 	bool (*ignore)(const struct btrfs_inode *inode);
 	int inheritable;
 };
@@ -411,12 +411,19 @@ static bool prop_compression_ignore(const struct btrfs_inode *inode)
 	return false;
 }
 
-static const char *prop_compression_extract(const struct btrfs_inode *inode)
+static const char *prop_compression_extract(const struct btrfs_inode *inode,
+					    char *buf, size_t len)
 {
 	switch (inode->prop_compress) {
 	case BTRFS_COMPRESS_ZLIB:
 	case BTRFS_COMPRESS_LZO:
 	case BTRFS_COMPRESS_ZSTD:
+		if (inode->prop_compress_level) {
+			snprintf(buf, len, "%s:%d",
+				 btrfs_compress_type2str(inode->prop_compress),
+				 inode->prop_compress_level);
+			return buf;
+		}
 		return btrfs_compress_type2str(inode->prop_compress);
 	default:
 		break;
@@ -453,6 +460,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		const struct prop_handler *h = &prop_handlers[i];
 		const char *value;
 		u64 num_bytes = 0;
+		char buf[BTRFS_COMPRESS_PROP_MAX_LEN];
 
 		if (!h->inheritable)
 			continue;
@@ -460,7 +468,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		if (h->ignore(inode))
 			continue;
 
-		value = h->extract(parent);
+		value = h->extract(parent, buf, sizeof(buf));
 		if (!value)
 			continue;
 
-- 
2.56.0

