Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9886387566;
	Tue, 14 Jul 2026 06:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009550; cv=none; b=O4LQKcF24ck7RN3ZDajUuhCL/QCllOTfJAw1rDJTZp4IxnPSgflL7QEcga4tO1hAN1VRemoM6w7Wr8mjGfPeSAOqYpcS+FEkwgs2w0A5ZnWdaYU9Moz2/q866JzYBUZKTFZhAbC32jQ8U0VQTCPXvVsdkrsBmCWIzCUdZq12ikI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009550; c=relaxed/simple;
	bh=71i53mglirWXf8SKGByf16iO+4mVhi3KV46Zp4Qv/g0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=jUzIwU8ezUOfhfJJ3ZuO/KwGIgFVs7QApnNixa2IWLQA3PmI3qPCz8mFPxL8g35GkI8IGmUjp10HlDR5HaQOjmQ7xKo48BRBnZxbxgL8jz7v4e4gzR/XrgI+zna9/uBcRT2iC4AU+aw+INxWM19cr+gQK0auXjIlmTqvYEr4XVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=AU5gPXs4; arc=none smtp.client-ip=203.205.221.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="AU5gPXs4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1784009540; bh=K1PgLaqu6CXttFoJjAD+NSe2Z5VznvhaJvYwC7X85mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AU5gPXs4ZPf6yFQCf2bMeAcWEyjHlQoBpt6BgDPkbb0Ziy1/nfYsv4GLkXQ39AR2n
	 yhsuShV471eMgwyG6B+fv72DWLSGgKz76nBHcO06/jcDyTkUgJGjH9V8HP7EnrtRIf
	 fkqhMX5NGXySnwkS0JJS2NOdfQijwaz1r0NVMqAk=
Received: from ikun ([221.176.157.250])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 2C6982AA; Tue, 14 Jul 2026 14:11:06 +0800
X-QQ-mid: xmsmtpt1784009469td62nzvjc
Message-ID: <tencent_4668A8BA7892157D3C6D4228DC5E217E6209@qq.com>
X-QQ-XMAILINFO: Nj+lDvaLCxoM+HOJomgQM9c/DPmZ5vrQGMJydUTp+MlseXMgRZndED0UW+itdU
	 anhm5wjX6rNse6rZX3NN/H+XVbsYRcWNxgaKr/oP+i3l7NC78Jg0Lr9Bir6jw4TxeBxnRlHw26sw
	 TG4QPw1RQeaWyQe4vCB55LSDjdbET2CVnNsveAC/fWEamPKg3Fw0a0QWsj4ni52N0pc4uhtw3oVt
	 ttNAPkDVQrdYlZKOgTAlBgz61JZFhKHpWMevgfD+5ZbqSPmj8fCjM2rb6wZU/sTRjovy90D2pS7t
	 QeLJ31eyFPoYdY6a+vp5j2OVwe2HhI21fcBoj4RiItTPzv1tmm0zXSLX1YoCG2mGLqOp9XXqspgL
	 kU7tAOC+2QETN2rpzgkM5hiD2RJK9fc4d0cZQYstsmtlCS/G0efEORlaPiD+MIjU3u5wQapKp6Ab
	 20GSyRBGs8ykbA3xpg7X2IzpzAQl+jNfl9vHGmIbk59HLs+iSlOB/sBy4N+Js82qAYPDrFaj1Uu5
	 wGV5T4Cj6Lm6uA/Hqiiad87v0Vol2hNsJyXNN+GuXshVajo96tv/jRr/7pD1myb8Uuu+ZMtdQRDi
	 sZV3RB2t6U6m/wgRGoF3ePxqtppiskRgG71BATJFR5MJsrR1+Vq5r2x4JmHl1EqD+mN/fQ2NO52W
	 z4rWimoJ/q/bF6SnP4CP4bsBJSIxoOAa0Yy0iT0ibfXC7wPui+kQLgE7Rk7u332wri+qNdIhBwGV
	 Kn5KywQywSZikJEe7BZBt+mRAsYmMrzw7fDa9rSWEnjWTlHWwjT4u56PTmuesYJqYdOTHaC3qoHj
	 vGcS7KrnSoBKMuSCYhSOM0Eg+Unnip7dUNCuBpO7/an1KR5IrV1+XRAlVZc2dreLgL9JyXMTgGyt
	 TnXuFe2kQoLNWrjcSJ/tnKu8cyMoJqtbXMgRB1KNnXe3ugnomoWPACs4psNFVKy1hIRykFAPVGuO
	 l7hNKqwDKwVuZE0LcO5c2tt/HFGH1gO648KZFwlY+wrQPOZYpaGCsT+gien2hNn4QZHpwWIDfUXe
	 lq4CgdkHFmeNULfqGPkqQzjl/unTYPPuuuEnIywjQ3FyWKIaJ6TZf91EE+geCwUsvuy+UwEa8APe
	 bMqBNpnDgeuPTguSo=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] btrfs: restore active device pointers after failed sprout
Date: Tue, 14 Jul 2026 14:10:36 +0800
X-OQ-MSGID: <20260714061037.1014-3-3497809730@qq.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260714061037.1014-1-3497809730@qq.com>
References: <20260714061037.1014-1-3497809730@qq.com>
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
index 556d8a60a5ec..a14f186f5b07 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3070,6 +3070,9 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
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
2.52.0.windows.1

