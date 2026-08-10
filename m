Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BEE242D70;
	Mon, 10 Aug 2026 10:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359598; cv=none; b=DcKEpn6Qf56pbxSb/2S+E99nLleWHFOAgeMTblMG4OX9xuQDjI5jrYKn1X717MM17ArB1arxGDeluRYtvK/YM8cRPuAk7AQkpbGZpGl0Jrk7/EdM0lXOmORDCywWZvvy9csY+JACFGctmLvn/2DczI9t6uIPcHtb/m6TzemylNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359598; c=relaxed/simple;
	bh=2qDfRtBOIervqU14KlqRPGOexCc8OZdO1qz3dUEKwy8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=uuvhxgQIP4dNkPVOUIKzLlz6K1hQGrXtBq8x2w2AaospX4sbX4gg3h5U3ssNx6N61uJNgeAzFQyStlcNAMLWWEog3qcUJfQzXRqk5jbcF0jC0ZSulrSMDpqYNedOjDe0j3C10TTPxGOwETFQXI+ZdRMVT0HyFO4x6jLJoedFnNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=PURG460C; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="PURG460C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786359593; bh=6oTZKyUlBuWDwTdhkpltO/sBSIy/CTp2Zyj9nyuegho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PURG460CEW7C243/61W8R7ck889i10ZFZRY/WuBfxWasxhaW6+V8uOY8hJM5mVtD+
	 wJwsQ6kdEF9JQieyhZG4Gual8NQ5GySsgKvV282XnGysSr4Bnlv48CEqoNaB+c4A1D
	 EHOaEZPkLcdYJAaX58/q8iARMl3o/cdNAXAD/ays=
Received: from ikun-VMware-Virtual-Platform.localdomain ([223.65.85.45])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EE8AE615; Mon, 10 Aug 2026 18:59:40 +0800
X-QQ-mid: xmsmtpt1786359591tbsv7winx
Message-ID: <tencent_3797A74151C2F32C84C30D1DC22F66846A05@qq.com>
X-QQ-XMAILINFO: NmRjDopJZVxOOmNS1hVe51h+YXUsMVzyWsOIWKs774RjmpNrYPtflrbC5LXHG4
	 upafvUAxvbIno9YHHNLbrRkKQyOOgoD4HA2HCdQAejP/apUo54Uym54aUwtY6PjIyrGWg8J1kxug
	 vvrsUF0fEA+A0J3HDLl+OlR6BxSDMTn1+uPUxUsn+LzehcMEzrCR5PY4fnIFje4p/8TNccRXShFk
	 lF1owEmkonWaZ/7Nb8vtKivIw0gVQOqK8HOWVS5MkatCDrUdRT2TdnoWShmqqYHSNvvBAPzh+d+6
	 AcgK0nen4xt7o+4uIPWHQltKiixHH3hsr/qHmMV6bb+HgTUj8Wa2DlEGCK+h2YsYN+eHC6BTWqO8
	 o8S0l8esQrvNHHJ2OPtiekpqq02kyI+tAuJB83qpyFeGuOSWt/lwjup5cQG9/Bc9JscTxpnnNSQc
	 MzNDd/oo1fwHTpkrDvXtJfWIryZ/MtBsKZ/wDmOtUCbsOdNc2hzhFslr6As7b7qDPtsS6lozYUkK
	 UoxGEXeEPL1x7mQ3ffE1bcjPdm1wj9NdAl6vWoZvrzlvOhSxDJrbJ1KlXrbU0QG7vrVgPPCdx+km
	 Hu/EBNRQfV12MSWKOtfjJ5QRltHhDXfxKhSKSpKrTe8/p4tnJ3A9UYETuTbPL0d+I+O+Hayzlsge
	 XZe+bPUzYbzVogeNPaVAQkSkayxgyUKNWQZ2J4wjaT47aQ9blXiwVB8Hic9heW04jG8a4qp1+cq0
	 VJEwDBEvD5M0NjWFa5SJrDujFoSc92c6KryMrf4uCtm745LIBHz0gzJSDXGrZVKRYCKDL2iPFBe/
	 L0MZcokB/wH9QuN9KQtlJbd8RZ1hhEinsBCNkhR68TuxT8ab8iIrspqBAo7ZfV59mF/insM42psP
	 ExE615lFm2bV4OimnWZFvze+G+zFQdAdzRgaVCqoDJZlsK7wV6m28SK3A/jAGDSPkJYXayr1KVWH
	 Cem0H09DWL52lGu7l28zE9lIjHUF5iLVK0GHBnf/yg6Qum+0k2ryco+mbHKjnf+9VYpfyEJ1sVsV
	 ThDnHwYvkrhcsqP6njxkM/SQKKD6I/8VbFgjQgB9QuaQ2QG01lRyJolTzLXD8=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: Guanghui Yang <3497809730@qq.com>,
	clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: restore active device pointers after failed sprout
Date: Mon, 10 Aug 2026 18:59:15 +0800
X-OQ-MSGID: <62f930b3a904a7ca4be2c87cea3727f226f5e6cb.1786358930.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786358930.git.3497809730@qq.com>
References: <cover.1786358930.git.3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_init_new_device() switches latest_dev and possibly s_bdev from the
seed device to the new sprout device before creating the first writable
chunks.

If chunk creation or the subsequent sprout setup fails, the error path
releases the new device without switching those pointers back.
btrfs_show_devname() can then dereference the freed latest_dev and crash.

Restore the active device pointers to the latest seed device before
removing and releasing the failed sprout device.

Fixes: b7cb29e666fe ("btrfs: update latest_dev when we create a sprout device")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Yang <3497809730@qq.com>
---
 fs/btrfs/volumes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ffd076e87..f3f77c89c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2987,6 +2987,9 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_sysfs:
 	btrfs_sysfs_remove_device(device);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	if (seeding_dev)
+		btrfs_assign_next_active_device(device,
+						seed_devices->latest_dev);
 	mutex_lock(&fs_info->chunk_mutex);
 	if (!list_empty(&device->post_commit_list))
 		list_del_init(&device->post_commit_list);
-- 
2.53.0

