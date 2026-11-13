Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794606995;
	b=aL5AFRw28NP5TkMPUn+B13Q6PECs+hDz0jj5X6b7jZ4EMq2s8+Pf8isxjyZPF3zrACtR
	 or0X/kpesYIWerGiqNZWnB+hTQtJp8syEraGqXoaZ8R5euA5y+UBOX6Xf9UgUHpny6hn5
	 igjHTpspQXH1vhc5qeEJjlFYYqmw0Tu7PMMDLBzQ5VMmJLW0mzUkSJI5bTrE7bGls11c3
	 dTsqGdpKrR6yc1nwoOy+hr+QfmHIIt+Q4IdEYFHQpvXakoJzl4ak/FQe+y8xIgoQR3Dcf
	 Ffqf63Tqe1uoIzSwC2dODc1xv5AYcNVx8BtyK0iGLjalfQRkgCnxD4OjazbgYSDXFIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794606995;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YKvcMEa+hjgpS0bpM+2xc9bQgMb5t0HsJ+pOghCdErI=;
	b=iVcP6dWEm1wPeqyFRscN0mlcHiUHJVu2SHHUJNAtdmCJp5W/IoLfEcHpO2e7ZPBlZqSE
	 XrWryGQxOyEJe1hagHvg+ukavIaMBQcDS+x9XFBwu5v7tyswdQGYjWhSJ/PYCIRVNHsPS
	 iT20MTv5suVzpzEzDq7fV9/x1XGh0bQARbcMhTL6ELHRQz68PV2bUmTS9JJXGFjhMfiCW
	 9qv1YN3kXen9JsJeAlju+XhwfMGk/9FzCcITxxdv3wNKSeYaELrJ6G9j20YnHDDNOPleK
	 3Sljf1f6ic2XHxwgqeSCmblU8ixBjvw6K1I6W7jQZ6hliOblyCnf4IEpuql2Rn5Z8zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODjGCZ5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87E8606A32D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODjGCZ5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119141F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 21:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606995;
	bh=YKvcMEa+hjgpS0bpM+2xc9bQgMb5t0HsJ+pOghCdErI=;
	h=From:To:Subject:Date;
	b=ODjGCZ5e1Y4fT545tTn8mNWKE7r2X4M9vEOD8kVwoAZ0toaf1mwRdhEW0wb57xXeG
	 giR71F3ZCd/2w13sOg9KhvYIPIPJVthI13uPWnrrNZKF+lydOKC0skyr76IXqOyJNw
	 qYPw0Ws0gH3rMFPvMi6hx18wL1IMbGg3fgLjscDFyhH7no773kxKoBDZLed+jAVMMV
	 OkywMUSoA8yyzCoZdT1D1Ye49DVQQn9nNUkvfjwA17tI+mM/A1/NAq0bLcBSI+9DsT
	 5KCY+q+aE2Y04AVY5Z9gXu4/+NXZ0C00csbXeiEaFFBwd/frAXxJdnbUnZrnWptTue
	 P9eVI38vu4aZA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix incorrect task accounting on error during io_uring read
Date: Fri, 13 Nov 2026 21:56:32 +0000
Message-ID: <f032850d8109d8a1291c2a6ddf87e78b7a5be337.1794606967.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
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

From: Filipe Manana <fdmanana@suse.com>

We are passing 'ret' to add_rchar() under the 'out' label, which is meant
to take a byte count for accounting, however if we got an error we pass
it to add_rchar() too, which is just wrong. Fix thing by passing 'ret'
only when it's not an error.

Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
Link: https://sashiko.dev/#/bug/linux-beb0369e-eb47-41d3-86c1-e79cdc2de157
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6cd12f586423..a4de331c46a5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4660,7 +4660,8 @@ static void btrfs_uring_read_finished(struct io_tw_req tw_req, io_tw_token_t tw)
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 
 	io_uring_cmd_done(cmd, ret, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
-	add_rchar(current, ret);
+	if (ret > 0)
+		add_rchar(current, ret);
 
 	for (index = 0; index < priv->nr_pages; index++)
 		__free_page(priv->pages[index]);
-- 
2.53.0

