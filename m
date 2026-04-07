Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EEF3A6EF8
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775578636; cv=none; b=PFSNoSm16tSkZ/pSx5VTm5LGQA2ALhBs7FE5Vnh4dpuGWNtu3Y38QKxPQVdb5756vS8QzQYK4MsH7HxFO/NKkHyFnlGbwnnLWHq/fjXmlLDKD/Z2yqmt5UrYaK5usN24vWXJMjP9hiSyK7kWUWf4UqY9IAg5YVPFup+32fd2ToA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775578636; c=relaxed/simple;
	bh=p2p+eYLCj/XGFZtqVXaswKTLdZUsmlq7Cq4sZQMK4Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=a0ZVcWR+C4MkBt7JuLomd/sXk1VRpjslrG+iGW8IE7vb0NlRAJSP3aqjUztHQ64Wja0qP7nV4JvK9Wv0vbA2qViM6TZ0U9JaFSus9tKCyoZsmLjl9vY1k5xvLdC13tj7s8gWp/RGb+MxKCSiwGOQIuSRyyVQ/8n5pwOgOXtnxW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=EIl/jtad; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="EIl/jtad"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 5433F31A3AB;
	Tue,  7 Apr 2026 17:17:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775578625;
	bh=R0A8WUWOW7L2DDvzTtW0XYV7FgGbaExi73WJvj5M80Q=;
	h=From:To:Cc:Subject:Date;
	b=EIl/jtad2q6G6JY0R0qL5Fg7WWx9VfIRSAOlncHttGvjqbOLngDgV606V1ZIcz/Kz
	 DQpPoi/4/GojGq0oqOKD8JF2T/I8Ds3paxq7vrfYfi2JEDOdXVmAjDk5fxnynQEDXv
	 aRkGR4zDpvlsXNjY8gv0NtIlPcWj8JbZQn3RHSQI=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: abort transaction in do_remap_reloc_trans() on failure
Date: Tue,  7 Apr 2026 17:16:56 +0100
Message-ID: <20260407161703.123545-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

If one of the calls made by do_remap_reloc_trans() fails, we can leave
the remap tree in an inconsistent state. Abort the transaction if this
happens, to prevent the corrupt state from reaching the disk.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bddd5..277a0042967665 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5089,6 +5089,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	btrfs_free_reserved_extent(fs_info, new_addr, length, 0);
 
 	mutex_unlock(&fs_info->remap_mutex);
+	btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
 
 	return ret;
-- 
2.52.0

