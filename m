Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE0647CA6D;
	Fri, 21 Aug 2026 10:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787308731; cv=none; b=tH//dFeD0Uherhr1T6QUZdu4QvVwKKUCepypInS701V+AOLMeu1SiURgrAms1mmM7fxjp12LQAyvsn8K4bG1JzsAbnYYQ0BpKKcVIP6pWXC0O1PfMUmut7cli3AbKXQMKDckvH0iXmP8t6q/XHAsw7N3O7GwSiEN5kBldz0TwnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787308731; c=relaxed/simple;
	bh=OOaWybtVMXug585yFvPePryQcVXFQG1kjsH6qm/PIUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KS9scJaJo3lbaCYPUQRJIorfdMkVo5O2Y9Ocw/nIY0pNULgCp03c74oR5cxsolmbwACmh0RY+0xXiIsoqMRWzZgFQSuKtMwn7GzXIFSeWrcEBPdeHpSrYvJ2YfH75vUGOdhHjKzM/pcyds0t4yW5hNR998uOWUvUf5eZiJje2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=RQPnPXQo; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="RQPnPXQo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=mavefolkAulVCV/Becm6vECjJ4gAyqP+29Ruk5rSmqs=; b=RQPnPXQoiLOKpkGc8+Nj1bRz8R
	cQTjmI4RvX0NKJbNOdyyS9IEHyJbr9kHJqcKmyv0+vfa6pXfdcoT7FzjjmloKkQlZN5DKmiRZ2esU
	/GcsX2fIuBZHdnJgb0buwSDT2wWjjIx+Wsmq3lHBSvml6UX/vusrkBFfcILD1O9+oEeXCvc08Iv4z
	OHHlrcKR2WEvYsaSH3trcLmeDLUMiDHN0cHM6URIm/acbP9vgOvhTe1QOJdoBXNx+/nsDIV8zxRzf
	99+bsQUlC6ocbBnY58+S5v3/JgIHutb4xFPUWxdfguLoFiSXRsgvMO3zVxDvwgNLtNnxcTTjv8jhc
	PAkWhkOQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxMdt-00BHRY-0z;
	Fri, 21 Aug 2026 10:38:33 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:38:27 -0700
Subject: [PATCH] btrfs: skip the extent map tree lock for inodes without
 extent maps
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-b4-btrfs-em-shrinker-v1-1-286f3fb15873@debian.org>
X-B4-Tracking: v=1; b=H4sIAKIqiGoC/yXMTQ6CQAxA4auQrm1SR/7iVQwLhulANY6mBUNCu
 LujLL/FexsYq7DBtdhA+SMmr5RxPhUwTH0aGSVkgyNXU+sIfYl+1mjIT7RJJT1Ysbm0LjSRQqA
 KcvpWjrL+t7fusC3+zsP8e8G+fwGonZbceAAAAA==
X-Change-ID: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 fdmanana@suse.com
Cc: boris@bur.io, wqu@suse.com, layton@kernel.org, 
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1404; i=leitao@debian.org;
 h=from:subject:message-id; bh=OOaWybtVMXug585yFvPePryQcVXFQG1kjsH6qm/PIUs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCqmbPjBC0jUY+84yNAeHxJnNgRbBEKmdWcUq
 OB2dgEFEtOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogqpgAKCRA1o5Of/Hh3
 bVNiD/9s5gnqRtNsGNqrt8/tTG16ktDwYoIYWrOwuFWEdc+be/LGJv5rEWmPDBNmFXFAPl1xidh
 gc4RF/xcLq8A97TJuQze+EX5PCVJtatccl2hXG3Y8fVdyC4qzaZy8fAl+GQn3SltNMsGBtF/cMr
 S/43dVKnpBoA6smSZUllnAcEa1Zm1XDt49r+WSsdajxrXqv9ctRL07fpM3m9rEqe6yN0TD8hsPC
 8mFdzqnOo/cseyjXpx2ndI/qh+XP7gZcByJwmbuO2ppJE/OicGrBhGpWvmicIEoRxfG0tyb7p3Q
 tFxLDG/qA7LhoCQGBY7FzJtlowSrxr2L3CjF+N+ItxpZ29MYDh26jfOkyzY0jVVRXr7+LAn4dBZ
 ciw5fx88RH6My4ZrcVEvYzFe/6t7fQroeqwEl9B3QNA+iKXNhE237MfgVKdZMwX9x0EQ78Boim9
 i4h7kbVBeBRhRd8WJhzWN2r7vUOoOHsG9SuOJOZ3s7z5yfGPdcKEuvTc6AMLaiU8ZbkBR3ktTbi
 PkH0SRTFI3hzfUuY3Y6buH8gScyd62fR2P84MPJTuQo5sNQ1AZIpzY0cLxcFo5jy2b8+9Zs+Jwe
 /fczQRmTBhzQTz5K5YHvOo2ephl2lUTvG67YYS1SD6zCCpmzVGzno+KJulMKO5eNE+TKwtmTJmD
 BeRjUH93M4Ldjbg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The shrinker (find_first_inode_to_shrink()) takes inode->extent_tree.lock in write
mode on every inode it walks, only to find out whether that inode has
any extent maps.

Most have none, from what I understand, so, avoid the lock  by testing the
tree with a plain read before taking the lock. tree->root is only
modified with the tree lock held for write, so the unlocked read is
a benign race: a false negative just defers the inode to a later scan.

On my tests, find_first_inode_to_shrink() was a bit faster, so, if this
patch is correct, I think it is worth having to reduce lock contention.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/btrfs/extent_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 6ad7b39ae358b..cdcd2b779050d 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1219,6 +1219,9 @@ static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
 
 		tree = &inode->extent_tree;
 
+		if (!READ_ONCE(tree->root.rb_node))
+			goto next;
+
 		/*
 		 * We want to be fast so if the lock is busy we don't want to
 		 * spend time waiting for it (some task is about to do IO for

---
base-commit: 6a746cd265aed59107ebdaa9ce039bb832922969
change-id: 20260820-b4-btrfs-em-shrinker-7382d7f0dd05

Best regards,
--  
Breno Leitao <leitao@debian.org>

