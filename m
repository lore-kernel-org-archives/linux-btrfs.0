Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A141FB1
	for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2026 07:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782028005; cv=none; b=FfXLVoyATM4jjI+iih1tEhBNRU5XpF45q9JB3Znp8qDx9a6X/aEqbqPcopSqrfspQokNTp8RmTVmRAFWVe5aEliJLpChpeMRDw3kuc50deGrbai+lyHXCBolj7LauAZKXXcHbjVXKwODxH+uh7OONTANP/uSNY7jz0rfIGjYafM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782028005; c=relaxed/simple;
	bh=o99+UaN92qrYDCnNgVXR+2B2Q7bjLpg/Nm7FFC0f5Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HvWI22HapS/Az+mc7Tx9OmBBQLixsbG3NamlKric2BoGZd1V5yI/mTX1FPwyLwIkx6WGDpKew0VeAaQBJeX/Bpy/zVw6R0RRXMXa8zZ+FOOQsyJakid1EiMZ+SBRHON7Rn5BIKBOe5XxIN+hyFWSwn+LcxtjrdG/eRyq2Bddf1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cC6stOML; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cC6stOML"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782028000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YClda6muaVW7GgyrR58wZtd5jcgDP+zOHrI/hQGuXy0=;
	b=cC6stOMLsvbPLa16MqcU5dglYir/yEp5qAGqXY3J0K0eWht3c+p/BgKPNcEEaKazDbW6VI
	yX6wyIc5+ZS3tWIrUFDPB12Tj/W7AqYVJqJFdMtVuNY3PrEq8SByuSA/ftxONcT3X4MqHZ
	n4iDopMRsd+V2oChzcUnRuXQ6i8Euc0=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	rdunlap@infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] btrfs: sysfs: fix path of the "read_policy" module parameter in comment
Date: Sun, 21 Jun 2026 15:46:26 +0800
Message-ID: <20260621074626.11193-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The correct path of the "read_policy" module parameter should be
/sys/module/btrfs/parameters/read_policy. Fix it.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 fs/btrfs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 0d14570c8bc2..39cb01ee441a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1336,7 +1336,7 @@ char *btrfs_get_mod_read_policy(void)
 	return read_policy;
 }
 
-/* Set perms to 0, disable /sys/module/btrfs/parameter/read_policy interface. */
+/* Set perms to 0, disable /sys/module/btrfs/parameters/read_policy interface. */
 module_param(read_policy, charp, 0);
 MODULE_PARM_DESC(read_policy,
 "Global read policy: pid (default), round-robin[:<min_contig_read>], devid[:<devid>]");
-- 
2.53.0

