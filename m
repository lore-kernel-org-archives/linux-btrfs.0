Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C18368D73
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781266442; cv=none; b=Db7kXsP96QXsUwtSdTev4FgMqFm/tmg+2lV7fTAhJzA8SQ+i71+HMSCDp7g325uAAm6onkzw12x4aeJdTRHFNwKlJvY1LbXvPaLGYwg9GM/JZNy4n4U9bjp4Z97iPt4bjfS3kbDTl4rQxB5vW3Oc7s+YOnQ2VD16Cwr0dbyqqzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781266442; c=relaxed/simple;
	bh=Y3XsqLynruXpJz8LVb45PsMHCwIEWJUApm+Z6DCgWac=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JnE1Yhn63sMTPo4QxO/Kuh2abCtypUW1yRPjHN+6yRmWRYtWnHFeWq9Uxe315N+c6ZEafiuOHWtG37D5Ng6Mbs+6Ivue4Fqu3mR+Hzztsjp4FwvmJfyMCH8SDXAVZPfl/b2hsJvcq/r9tTlkymyM8Q9owxEvFQb6cmh68ZtRLzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvimuCgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvimuCgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0B61F000E9
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 12:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781266441;
	bh=WyoZ0Rut9u50eZSY33+IlNBC/b2cBeaadZsktzdKfF0=;
	h=From:To:Subject:Date;
	b=QvimuCgJTicZnKxUTqnPaCbLFBj3AcKim+vNw+NsCdhb6Pqb4P5BA9/zhMFu5Ux4W
	 UwIdfVllhhwPc8I2BW/bPoKcvl/PJTmunyaBJfqDkYVngm0L97PKNxkweLTahGLnrc
	 Ai/JF9eYEDJPwveZFg59P9+cpRolkLLXojwiBW6N/fthn4ODYnkJM3qtNA4wpBjWLx
	 jJ0C4npIneIkz0hiQGs6+npfrNMZn2HCUR0didTVN7mq9jNuQTPkpjsMy9iSQzDKEH
	 xnEONAgWbJ1CYtDAVfxIgOsGgRbOaPpA4SsIB6+PUwbeCfBCTDcnx/5HTcBshyfW/8
	 93APQ0ArZo54Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix incorrect barrier usage in relocation
Date: Fri, 12 Jun 2026 13:13:55 +0100
Message-ID: <cover.1781263239.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Sashiko recently detected we are not correctly using memory barriers
in the relocation code, and these patches address that. Details in
the change logs.

Filipe Manana (2):
  btrfs: fix reloc root cleanup in merge_reloc_roots()
  btrfs: fix memory barrier order in reloc_root_is_dead()

 fs/btrfs/relocation.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

-- 
2.47.2

