Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FD33E348;
	Fri, 17 Jul 2026 16:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307187; cv=none; b=HdWy6U6ZqayZN/R8xhlm61Oj+RXn3taa1P2KgROQBDV0o1jAWB4MRqJmZdT/1ybZpn2PJC/+69rYuyyKfxdzk6c6Qg+SoglZgNXyky+rSEM9vjrmHAtDUa5uOQZpCRTRSRiX+yP8twF0JVRVH1nMAI2haH3Vzszhth+Zis1zFqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307187; c=relaxed/simple;
	bh=TR2yomNhvTMx4b1qXjHY4wNpUuP7EKrteqngpEWZKI8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iWp6Kbudm47tpRLRUV4NWvJD95RyMl1a92p2XDT4+7NuoKGpjsgvkd495wk3tJgdmJFwS1kJ9pDNgJyi6BTiXygPQNVwAroHgFhV3jDomIsObGvAiae5nDkfDm/Fw33CflAwDEtL4ncGk20Up29Cv6a/Lt2quTUOiX/TqNpHUrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhG2p33W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhG2p33W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BB91F000E9;
	Fri, 17 Jul 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307185;
	bh=gBny68WfmfuYSdiSIEVVYaedFGwLwACwTaCHxR59/k4=;
	h=From:Subject:Date:To:Cc;
	b=ZhG2p33W6TGlAK+NeFhHxrk5wkVM9UkoDCL3Gv0njRyUIYRqXfJR1h5sXECRElaEN
	 owkSYcAN+ENpjevROwomO2yWtrdFJ6G4qhfmjEtY0rZ4jdnuG2C1F0PwlYeFQHEhxG
	 da4vvYWyaguquQZEzU5UamPFzqSoZpXbr39noshyDWTpDv0OdYOMYu5D6oRR7R04uQ
	 RRbqrwB5XwD51Dkr+8OaNC3BLjCy9y6xSXhsUzPwhdgrYy2OoJMDWtdlEIIcCPeYjG
	 Hpd9XZTj+2n8q1tLILLaGTH3pKERF46MZXVw1KsuqUu5R3ICd5mwG1+pQOA+leKniH
	 Qp96mkGytuRmA==
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/4] btrfs: handle -ENOMEM errors in some synchronous
 dirops without aborting
Date: Fri, 17 Jul 2026 12:52:35 -0400
Message-Id: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDc0NT3aSSorRi3dS8/NzUXF1LC4s0o+RkY7O0tBQloJaCotS0zAqwcdG
 xtbUArGeqhl4AAAA=
X-Change-ID: 20260715-btrfs-enomem-988f2cc36ffd
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1706; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=TR2yomNhvTMx4b1qXjHY4wNpUuP7EKrteqngpEWZKI8=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqWl3mTcy4Sz+ulA9LYhkrnf5xkX+u5YkgLmORC
 Onsd8ru3cyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCalpd5gAKCRAADmhBGVaC
 FT9xEACwBw+BpYWmWRkDlpVKEg+XWd+Pokf4NJZfMaQ+tEjBLD2UZAhf4V9o+GkidufCiJrBtRP
 XQ1J+t2eF0an6/o/yA19EDGbgdHCtGGf2SuBpZMFbhbofJlpt2P5F6Ruqwa0AlcmWGLfp0GgRkS
 C8wh2fYtyENaguXKdPo9iVKDdVxJ/rTN1A3ooOghAWnR0A2hj22PhJ63upiIZpNH/4wIcd8GBh2
 T5XMu2hMcMpUaGDIvHuNsxzQuaQr3sXJGT4aUyFxRLqwqoZSY6wWkTzTiI0xdvF89IyACqWAVuW
 JL0GoWsT4tZ7eXv9/3YQXORUuqoPlhq8RvwL1QqVSaHR/tg1kT6yFwibkSwuxbfXc5frerubxmG
 BSY+NnmTJSr0oDTTf66ZryGRWhUe53dK0QZkj+evdjXVyyKpYnERud0UY4dKVgkpiIuQ+snxbm5
 3PcbvKEveabmXFRxkfw1ZS4OVy6x0fqPZSGaLDEHH8np/cIA0t5+YGevmK8OmWkox1tvRMvYAU2
 OvUglFStWa7EAJGudCYXSyhHe+s+CcspO8izTWZmLwZda3GLq6+PbTIk4FKF5vMv5PVNlNF2oz9
 Uiski50O5x/sWfzlUAYpxwomHjChA+Q1cwyF79yzcH/tJts7x+5Qfxs0Njj+TTefsy4rToQ8qz6
 ZMgLMVfdBWa2JOw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

We've had a (relatively small) number of ENOMEM btrfs aborts occur in
synchronous directory morphing codepaths. It's not terribly common, but
there are a few places where an memory allocation failure results in an
abort.

This patchset reworks the code to do the allocations up front, before the
point where we'd have to abort the fs if it fails.

This does not cover all potential cases where this can currently occur.
In particular, a rename that overwrites the target can still abort the
fs if a memory allocation fails. Fixing that is, unfortunately
substantially more work, but this should help improve things.

AFAICT, these are ancient problems, dating back at least to ~2011, so I
didn't bother adding Fixes: tags.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
Jeff Layton (4):
      btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
      btrfs: pre-allocate delayed dir index before btree modification
      btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
      btrfs: pre-allocate delayed dir index for non-overwrite rename

 fs/btrfs/btrfs_inode.h   |   4 +-
 fs/btrfs/delayed-inode.c | 109 ++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/delayed-inode.h |  17 ++++++++
 fs/btrfs/dir-item.c      |  30 ++++++++++---
 fs/btrfs/dir-item.h      |   5 ++-
 fs/btrfs/inode.c         |  60 +++++++++++++++++++++-----
 fs/btrfs/transaction.c   |   2 +-
 fs/btrfs/tree-log.c      |   4 +-
 8 files changed, 185 insertions(+), 46 deletions(-)
---
base-commit: af5e34a41cd607c00ef752e00331736570992354
change-id: 20260715-btrfs-enomem-988f2cc36ffd

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

