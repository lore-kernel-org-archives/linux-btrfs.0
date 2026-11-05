Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793909275;
	b=QppUFRjLoFrYDNcx7gpV+6Wz7qmZBVmSdgV3VB/JB2o+Ao/wW7FI+B24sJ2W4XtyS/WQ
	 lqXYaw8wNa6IT4t5x3mXeJg6cxX1+uk+ai/B5l/9gyl+FISfH7+41/MWeEkmSmQs+FF6L
	 upWJsORxiAmzUHuv6wkEJUSwysGe0PMIbAdS+RVM6060643/DdwaKaA8+HCW6CH5JUk0Y
	 MVkoTHdhRt2EeEpgVPuPxcyFdkqkP/bP0YwIMQg/bmp5Gi5L5NK3hwvx6mOGm+VgclXCv
	 PLSEgCbYAudhey0sAolNwydvBp5KRZgtLtcgV5vv/VT4ZTi4mvmxO/cYwtj7Wq8rwCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793909275;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lmH0Rd8KdrfGMEgDO27H40AfY5Euh0gAFmSDhmyefT0=;
	b=W3QkPz0uf0HWvH2J9QkhPL1tO3Mmm9yyKyGyZC8jRwmLNc6GRUa9iMSow9dvJfZOpHvl
	 GQD/AEvRBwvAFrEykxz2cH/nUEOgJ9sEpBUoo2RSbBNz2/1b10HuJRoV+5vQ7eneCt0sI
	 R9wWNuIc53nPv/RGQVI95t+C+dT4T1Dxc9kUmKSEnHsZ/+VA0QsTRdhmV4xx7cRCWryU6
	 45v+eZB2ESeDLcGtaWjl+GZ+TW++KaXcmmoMMWxsH7qS7LuMC7FdtYrTbSfVksitopM/3
	 h1JNu3pIKmlAmSsnv+ioJaNAGuLFeunoYG0WAye74QgEnbsNMs5cOeIHN2SK1PlZ5IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4krmH4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD19606D837;
	Thu,  5 Nov 2026 20:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4krmH4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86FB1F008BC;
	Thu,  5 Nov 2026 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793909275;
	bh=lmH0Rd8KdrfGMEgDO27H40AfY5Euh0gAFmSDhmyefT0=;
	h=From:Subject:Date:To:Cc;
	b=C4krmH4+W7hKEYLINs1SrrWaB1a3Gw3bHAxuW388Z8aVpnhBgYDEnzyrLmHa8p1MF
	 qPAtQnNAZUVx+TccF76KbijMEWkscWGCzZVQiletiIFU7qsOvi1TdAbYOukJOr9fXc
	 WkYWKdyGW/pecpA03OAsB4U5XWAhwJ4LYuCWgeWqOeTsoXQ64rOflGA54h1zLalA81
	 1r09hTLZAMZyvBOYyiL7qlA0qAaEDkALy2Ppi0Y3XXbBnAMcanDtL4KNEek7BKfyvP
	 yKrpDFNdltutSMz2aFhLT02VN/jTGj9BPxeyrABEeopC7utOiEPhH99V/BE9zWBfGM
	 EbyekgYpsIK1g==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/4] btrfs: fix FMODE_NOCMTIME handling in btrfs
Date: Thu, 05 Nov 2026 15:07:41 -0500
Message-Id: <20261105-delegts-btrfs-v1-0-a42a2b93cdc2@kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwMT3ZTUnNT0kmLdpJKitGJdQyMTI2MDAxOL5ERzJaCegqLUtMwKsHn
 RsbW1AJXFVBtfAAAA
X-Change-ID: 20261104-delegts-btrfs-124230048ca7
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chuck Lever <cel@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1166; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=mf0FAxH80St5KOdNCyebSdgNvA7O8X+DwopV5PPMtns=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7OIVcytTCp/DZZAcbwkL9wakY9mqmSX42cZeq
 N3UR4SBSTeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauziFQAKCRAADmhBGVaC
 Ff8XD/92ZopGN6ma3AM9nB4XHxWP2PJMxZaEAFWpB1FnUuro7WA3lls1JEfGi9yEbXmatJULjgy
 ntjfSOoETHCGQ3FcihUlOD2tdM+ekRYj6/yhn5w2tfXvB9CYB6V/r11q57IASOMgEB9wea9M5XQ
 0kBd2Q7nMD1LMLQAqsIcqhVxoQJrbOnHgHpQ/zJaGlZu8yiseCad5eRgS/kqzGKmlaNq8wPKMnh
 hBtrkE7feztGKlut25kMlRr9AJ1+M8iIXLqe+ziK4ocJvhYXZ7PgEehhkmP57g3XF/3iH70jIHl
 G/Unfke8iuGPg6jI09flcica/WTHFN+qZ7k6o/NKsP0d4adsM3u+lgsJujiJmez8mcOHHN9TMhR
 bB/4ZrsmAokNf3y8svX+o3V9/JXVmoHXe7ip/zyM0hiZuRVxB1g5wxb44e5eabe2mg6DfNnr01P
 VH1Hb8v2GqiymfdjjeIAJD0HOfePqlgeOLt9VfWfhFQGzgsAK94hDC93R5ox98MkjZy0lrUVN+m
 TkI2SHnn3USsznaH7ygnZm2cCl7qR4lbU4ft7yXRUfVvCV8Sca7l0kAj1oVeTjAv3LoTSRwu5A1
 m4lAX8LK8z9lWyaJWIkQKlrpyfjjaQgeCthzqZGWcVFb1cnOjQhCmGfyGULKvzt3Z2RxdPK6aHp
 6M2rnpO02AT0s1Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

I tested the delegated timestamp support in nfsd recently. That support
relies heavily on FMODE_NOCMTIME, and I found several places where btrfs
didn't handle that flag properly. This series seems to fix them for me.
I tested mostly with the git regression testsuite, because it is very
sensitive to subtle bugs in timestamp handling.

Please consider for v7.5.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Jeff Layton (4):
      btrfs: honor FMODE_NOCMTIME in btrfs_write_check()
      btrfs: honor FMODE_NOCMTIME when punching holes
      btrfs: honor FMODE_NOCMTIME in fallocate
      btrfs: honor FMODE_NOCMTIME when cloning

 fs/btrfs/btrfs_inode.h |  3 ++-
 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/file.c        | 60 +++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/file.h        |  2 ++
 fs/btrfs/inode.c       | 13 ++++++-----
 fs/btrfs/reflink.c     |  9 ++++----
 fs/btrfs/relocation.c  |  2 +-
 7 files changed, 59 insertions(+), 32 deletions(-)
---
base-commit: d692f252c52b8d1b4bc7481554f314df31ed8249
change-id: 20261104-delegts-btrfs-124230048ca7

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

