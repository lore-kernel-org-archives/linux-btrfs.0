Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E895E17B505;
	Mon, 10 Aug 2026 10:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359597; cv=none; b=upSYH+VWaeK+BkzGZ8l85BbBAQ8oyGAfV3MDiMxvYnFWgT4NDFQRF5XF26YBTOfZdkP/KUR8BU8J06JzLv+81n3ztoRSe66/auU9T7nkQPWYLHLaUWvuyF/qmAZE/esU+PyaFoTEKBFtO/p0MY94YS5jIv84uGAyOQV7GdXAxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359597; c=relaxed/simple;
	bh=gHwwZ0XNfzj0qOmMNal6eVQcSHxpg/TEEE/OT3C3yZY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=kLayZLeORgdjUXXIJr5fW8jB3hBIAImbzDtPO/n2jdTzS17JGR8YPqUYVEtMFo1wV3lcSjB85/uqpjFqbHdXopI99LYNCtTze3XMqR05jhJ7JYN7eRMIM09KTNTsoJdBBCdFzXVsB59qygyU30d5+vosd5N8/vxmSUEa0CCuFcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ITqrlbCg; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ITqrlbCg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786359591; bh=RrInkoygW3e8tpplqBejXZpxdyFGW3Vq+o/MMihjRp0=;
	h=From:To:Cc:Subject:Date;
	b=ITqrlbCgSKdceRceCr7tfej2EvZ1pHWacVtYWkTkbUxNIkmQT3XNa5Evk9tOZ/rJR
	 n+7zZZO/gaAD+CfpFCk6LWLvd4C0i9yIRVj+6Y1D3WktP7Jx1B56civ0KVJSNulj6x
	 KzumDmqawXt8/0uHKur7ih4EjBvX596FmW5VCAz0=
Received: from ikun-VMware-Virtual-Platform.localdomain ([223.65.85.45])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EE8AE615; Mon, 10 Aug 2026 18:59:40 +0800
X-QQ-mid: xmsmtpt1786359580tay08652e
Message-ID: <tencent_A4486230A84078C414753C894308DC342009@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GsRGDPCxih1b/phKg5XBU3mi0II9yyhNWpgYlq/7047BRsbd54H
	 M2q112+sS7WT6CgXJMGDNzWPDkmii3Dy9bLE487Ug7LDdx2bp+Sc/rgtCN63+ilHP77QVUe1Xs4Q
	 Uh/foN66gceYyuYQo73aiPMmvkyk96a+KN9udJcCyuDOCZkqMXjeBACXD5IcR8jMCaJe9e3l09kk
	 9FUotwKYdRyzhloGHvZOYiwJxazHllf/mdq0H5Qert0SRjECkeRICbo1xp8soF5aXTOJ+30C5pj1
	 YDOwmw3j6Aq/ubI6Sxr824EU1ppgCSRrKdDDVeTKsr03JsiPYvvt5uodb2+Dt0tGVATgPvcTdoUd
	 XDV4KkGynKGUO9MGDg7GGgLT33zAO/UJYhBLKIJopl69mD+lyWtJiayoFvC/utltmh60bFmlgvT+
	 iOD9g9HeYxkh6EzUR3Wf9TTCfDnLeGo2+cxDIhQR6o3yxGLtvOxA4mc6pBW2ffNMRUnJWcgzAc/I
	 zfNajQrOw0gVcC9y5ISkrQk/RCunFAdM17RMojLea14yDgBRhqh40WTLZdCJXBRgLpCLnC9kmG5c
	 EWevXo9sTCsSq5hSZdQhs6InpOsqCMxttmg+ToPJ/jLZfeZqnqb8Bb9TWlYnMYEqB4liv5VsQV96
	 MGqyplnuoxF34MCq1wc50Ic7wiJ927Igp5OZDnH0KDqpNBwr/kYi1sCBp6PrC4CbQ2AHrqPQBG5z
	 0BP//UpWMrm3EfurRahcNQcatZ8KIwrCn5rMj/VcAB1xAV1mMDA5vx6NItWpdArZaZTzqYl3kLG+
	 8WtA0Yr4HT8f4PE2e65oG//wD0TjKS5rLsEQBGO2Jb6YIC/0vwp8OosoRpF2RNWZCg8Aykf3o34f
	 MQkZBiQvsxTrkDILK65oOjsxj+SzD3eb17N8iCzd9ehjks9n648658wRDU9m3I3wiT5X3t8gGjC8
	 04P559ZguyJyMbwXduqj6PQAapwWwyxV5ixS8xcW6T+eTMIiXXBGKNu5HnZrLKS02OnWe1vFVT4e
	 Zy5LyRpvSSv+XjeoAmxX8/VxO8ZUs=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: Guanghui Yang <3497809730@qq.com>,
	clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: fix failed sprout device add rollback
Date: Mon, 10 Aug 2026 18:59:13 +0800
X-OQ-MSGID: <cover.1786358930.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes the error path for adding the first writable device to a
seed filesystem.

I verified the failure path locally in QEMU with null_blk and a seed btrfs
filesystem:

- create btrfs on /dev/nullb0
- set the seed flag with btrfstune -S 1
- mount the filesystem read-only
- run "btrfs device add -f /dev/nullb1 /mnt"
- inject -EIO after metadata chunk creation in init_first_rw_device()

Before these fixes, the injected failure triggered:

- WARN_ON(!list_empty(&device->post_commit_list)) in btrfs_free_device()
- a NULL pointer dereference through btrfs_show_devname()
- the sprout fs_devices state left with no open devices

Without the injected failure, the same device-add path succeeds.

Guanghui Yang (3):
  btrfs: detach failed sprout device from transaction update list
  btrfs: restore active device pointers after failed sprout
  btrfs: roll back sprout setup after device add failure

This v2 keeps the code changes unchanged and adds the local reproduction
result to the cover letter.

 fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.53.0

