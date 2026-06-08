Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D025C357D10
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917564; cv=none; b=rKuKBx0eYrNNObcDMGcGW6ZXQCEsu4KW6mmrZLAUn83hidBC2TKJB0O47G8ItBNf3bdDwrYBUzN3BIG6NYZjrsXv8Uhf4vbhrcwJYmrRxupRWKBXpu+w2MLQutTYykpSy1TO0WBT1CFmfxi7nloky2D/3mYBC4OP/Ovl7PiuJcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917564; c=relaxed/simple;
	bh=BoE52yJjRaxwxTU2SYLha3eYOhmq7c7WTursWLUEGlA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Z4hYJO0CMR4dfLUbYQNKVp73vLlcdQF3u12ELnKzqSyNS6RFp4tZy9FoKJZ4OjzyUxcIbqVuVdbdY1dkk6Qz1hcKOO3ixmb6kQo8GRPkIKhlm8HP6Bk6IOtWnOKIYuPP1AxzC+Bn6J1BFIeWBQV8VcoeHPmF0m0FFW/BEO5AR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZ+jVDP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZ+jVDP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86411F00893
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 11:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780917563;
	bh=HmXNdffbciK/PMRIMZE5WqQGqkt4ySPa0w488ULE7tQ=;
	h=From:To:Subject:Date;
	b=aZ+jVDP8rhvjsz6rh4qhRw+zhJcOGh8H53wTakC4cwIVN504geJfnYZlVvv8LRaFV
	 Iwldgsic3NtWKb8gcQK36kL9iV3h3vfoGTfuPeWoNGUnZqk2+3B1QKfDnMO97sVUke
	 J7qnmx7JW+aODOXOmD8E5FTLbD2OVe+HjDyvVJB7nWYwkyiD9HfDEJu6BrKIXf/qmZ
	 SI4dIMDDzqPCBXtRcuod9u6didCi038MstVDUx67lCbSDvaBpbClHg0B6CFdz355Fa
	 R8zcfp71yWHM+Z1H8H6UcJibh6beHmle9gFcqgTbi1YBOf1TsF0+SGRM5Q/bfvlQw+
	 ysYLfTQDYTjvg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: fixes and cleanups setting/clearing properties
Date: Mon,  8 Jun 2026 12:19:17 +0100
Message-ID: <cover.1780916663.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Some fixes and cleanups to setting and clearing the compression xattr,
either directly through the xattr API (first patch) or through the
fileattr API (all 3 patches). Details in the change logs.

Filipe Manana (3):
  btrfs: validate properties before setting them
  btrfs: don't over reserve metadata space for property in btrfs_fileattr_set()
  btrfs: fix transaction abort logic in btrfs_fileattr_set()

 fs/btrfs/ioctl.c | 22 ++++++++++++++--------
 fs/btrfs/props.c | 16 +++++++++++++---
 2 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.47.2

