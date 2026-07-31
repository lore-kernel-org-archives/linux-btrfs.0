Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324E33E9C0E;
	Fri, 31 Jul 2026 11:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498452; cv=none; b=H9ajruUZzhED4XYKMo7fdkqa1ddnY3bO/0J+MjA/5oAoUhYMO7qFMqQ60mBO8WmiL+bT48Or6LdO2gJZT+cEGFquw64yG/49vbg+ExO8gnDaw9Yh+PVk+RsYjS1intqjvjDk5ZDjWpwAfZYKfj+br9YlM9qCv+bVDtjufcMFpFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498452; c=relaxed/simple;
	bh=j2kbiZ5d8UQhC+qi/rNVK+FxGOolPsy+b5VZUgzbrL8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZnTXzWxoc5+Jgk58gZvkJo/Y7ulA+j5eWdQTKQl2FNXo9LuSG2PUvUAetytxjcUgCdBB+brAnDnOncuRzf9f7OXQuc7GO1+V2v8CmtMVZHBEw7WWl1hqlNQcskuXErdVWRrnMk09b+BXNxNdn7ukNV7D1syyQxukhrCq+KnLq3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=HRUp6FdU; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="HRUp6FdU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=+pbm0Een0iQxQXUEvmirzUJcQ5Ofri5wp66TU1kbRZI=; b=HRUp6FdU1H9t/xgNQevXqEkfNq
	r7DQFbmIi/jW/glvE63cyvWIJ6rXngYpFWQY2BiK78DZYN+0mQiSSbaRzt+s2BI2mOiEo81b3pTOM
	TkBlMi/YlhN03xlcpw/umTJaKbNCmXaWkgethJJLQ5QRYMa0mn8yLZesyqoR0YqCxHW2LNOns9gyr
	8pJtqUGcWhcol1+8azNtA/EKywdYSHQSLQQ82JVajyYF9aUoQ0R8Cr989rSRvazpPDVBBHNDJBmxl
	lo8VQtn7y1BQSB89keBxkigcgWJ7FTSTNHIMisYWAEJdsadn37eS8P6CUSk3WYpPlJ3hay7/KLBu6
	qLlFDXNQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpli1-009zI8-2t;
	Fri, 31 Jul 2026 11:47:26 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 31 Jul 2026 04:45:50 -0700
Subject: [PATCH] btrfs: fix extent changeset leak in encoded writes
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-btrfs_kmemleak-v1-1-9600453eef4e@debian.org>
X-B4-Tracking: v=1; b=H4sIAO6KbGoC/x3M2QmAMBAFwFaW923AxJO0IiJqVl08SUQEsXfBK
 WAeBPbCAZYeeL4kyL7Bko4I/dRuIytxsAQTmzwuEq260w+hmVdeF25n5dI0T4rOmUyXiAiH50H
 uP6zq9/0AqNBvTmAAAAA=
X-Change-ID: 20260731-btrfs_kmemleak-d44637bd2518
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 jlayton@kernel.org, boris@bur.io, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1933; i=leitao@debian.org;
 h=from:subject:message-id; bh=j2kbiZ5d8UQhC+qi/rNVK+FxGOolPsy+b5VZUgzbrL8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbItJwOlTEEd8zWRzDAZ6Z+t3U564Ifegc+feq
 7Ozz94s/xiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamyLSQAKCRA1o5Of/Hh3
 bZ3hD/9tM3cjsxHgH73UbggPsJa2rfwxTpLSHx7leb3+ep/Vs4aeM71G+tS1GCDv1AvIXz2lkP/
 7E1cDnr/8k949hS2QlvYkEHHsXFO1D7bQlrZfVOKowTZgRw5pZL7Fovze/WAV/vyPlyf/gbbNW9
 yw2A86xuamBkJJ3T2UtkhCx6p7M+Qt0nSlBxw/YD1Lx1Tpzx9DGl6KcNTxJSXbk8ulSXPdoEkdX
 CVg+WqKtFe61IG0mR9v+z+Hyl4wIA8QIGX6PuXGXlTJQdBMMJH8zYunlH7fzXn3kToDUwkg0lsY
 +DCmCQN8CxvULz1weFyNAjGKbSXncTSdGtB85U5oahOFO2fhbo0C9+CEyTuadJv1WyRkG7SsFsW
 bXJbP2k03rxnOV0QQCJzCDliQ8aTcBpvdwy7Zx9Eev9Wr+Ao++xOWNvCeVohX75QswYX9XArwRa
 q2Dle4I3vCO+ClUTkiOuFB+JSu5vXHK2pGYHUvmcSnf8bais2ZXNwr3hmuqq89Guie6Bk6m08du
 PWFXDR71xm4fG/u+4xZoTLxt8emoDJdylabvsHgrij4kl6FaIX/YtwlKuKa5WDQ7SEvnlEjV0Va
 1XMsH7UHoYaTcUXYrt/4VnTNYlM2dq7g3CxMdVygJ1QBqDIOmYVyCssEiwLm0wY0COb5GHBPyXq
 4Y39Ywi9UD/JZzA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

Investigating some machines with kmemleak, I am constantly seeing
the following memory leak that seems real.

  kmemleak: unreferenced object 0xffff88869f7d01c0 (size 64):
  kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
  kmemleak:   backtrace (crc ab59040a):
  kmemleak:     __kmalloc_cache_noprof
  kmemleak:     qgroup_reserve_data
  kmemleak:     btrfs_qgroup_reserve_data
  kmemleak:     btrfs_do_encoded_write
  kmemleak:     btrfs_do_write_iter
  kmemleak:     btrfs_ioctl_encoded_write
  kmemleak:     btrfs_ioctl
  kmemleak:   ... and 2 more object(s) with the same backtrace

and

  kmemleak: unreferenced object 0xffff88830d94edc0 (size 64):
  kmemleak:   comm "btrfs", pid 1613416, jiffies 4316358595
<snip>
  kmemleak:   ... and 2 more object(s) with the same backtrace

Looking at the code, it seems we don't free data_reserved, but
we should (!?). I was able to come up with a xfstest test that exposes
the kmemleak above:

https://github.com/leitao/xfstest/commit/81c83a3fbb20b4ad695055ede7fcb73d3ffa2e52

Free the changeset on the way out, as every other caller of
btrfs_qgroup_reserve_data() already does.

Fixes: 7c0c7269f7b5 ("btrfs: add BTRFS_IOC_ENCODED_WRITE")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0fcbfc3939462..f8ad96256ff67 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9965,6 +9965,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	if (cb)
 		cleanup_compressed_bio(cb);
 out:
+	extent_changeset_free(data_reserved);
 	if (ret >= 0)
 		iocb->ki_pos += encoded->len;
 	return ret;

---
base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
change-id: 20260731-btrfs_kmemleak-d44637bd2518

Best regards,
--  
Breno Leitao <leitao@debian.org>

