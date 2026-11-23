Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795433249;
	b=P1kqk7vSdCIl5/O7vW6WO3HpVUL194TGYsMeIUG2M8rZdxF3k9zBaO1qyomi3it8/Nah
	 F4qrMW+8dlKdsnmSH/libH2AUoLPZAw3ruvaTQnYL0MjPc9QikgGsq7NNWIMFHRyEI05M
	 5azNrVqO4YB9HcWplHGsA48XYZzIBpwrwbrwenMvaOyarobrBUtB7VVEaeNAWjdQXVJ0g
	 rSXgIgQwCwBFJcsqtCmmR6nhkEA/XlOU1K4ZDtXP6J/ObPMlewxRoy4EZp+39MBIAQWjD
	 8js0mvm/Ulos+ANrI47SdswptOWmeCCIfVnTYFNKHcrqeOByD8RbQOawlBwPBAlprqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795433249;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znqUotAh/827NECUu/Pqrs2F27hDL/TFJEW8vMMP1/A=;
	b=5e5/GYwwHIUjfc2JNqhRsXApkWgEOXrwSaQUcomaFkdf9zy+JL6FElKoebNLvQYXeCz7
	 qVpkMv0KP3gzjJos/Fzsm4HW5wlcy0cq7BKcJoQrUAbIP6qsST2RfaQBFMnQnwKVrDn2v
	 Lsgq6e2DANuwbin2eN4sE59bQSNVq9UHEbjUsVMTwDe47O4x23u9fGYjDwcoEkGk5MXg+
	 OwFb3rLdwXRvL7olkbjy4VFTRE4E93ffZlqu/keHdg6VTISeH9aRegVB2HmSRHHffVLLV
	 W7pF7m6ATXdJfu4AZ5Cs7cNasCeCMXyheJtKLj7MIZs+Wh7dlhryRqCUDDWk5HpNOjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caIGsZD6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1783B606A32E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=caIGsZD6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94E41F000CF
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 11:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795433248;
	bh=znqUotAh/827NECUu/Pqrs2F27hDL/TFJEW8vMMP1/A=;
	h=From:To:Subject:Date;
	b=caIGsZD6bh+ESPWi3DwcS5Guzrg/lpU3WCuVZRU/EZfBs27M0Zm84waauFolE0TXA
	 f9hHSCIugvEURdfXtALAUswNb/hB+UqEWW95lrcyZW9ZGRUablvv++XQMj9s2xcD1l
	 JuVkCkCv6kLr0KNGdgbybjiJ0UWLbqYjAufgSUaRZIKYyfdnCBnk0P7tG6QdqShdgC
	 8BphPJZrwCrD3NvZDAbFWxU7H6Pu6OZRvYjij3hItgMW5C9zAF2b5tLx58jkglkM8t
	 YHVLZyOgOiOQGjErF8bsPeocBdcoNIKqlhv4M3V5/w4VUikfKsqA8WckNrp4ED4Z9A
	 fcL5kub7HGNkQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: cleanup some use of boolean struct members
Date: Mon, 23 Nov 2026 11:27:23 +0000
Message-ID: <cover.1795433118.git.fdmanana@suse.com>
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

Trivial, details in the change logs.

Filipe Manana (3):
  btrfs: assign boolean literals to fragmented field of btrfs_free_cluster
  btrfs: use boolean types in struct btrfs_dev_replace
  btrfs: use boolean type for struct btrfs_device::dev_stats_valid

 fs/btrfs/dev-replace.c | 22 +++++++++++-----------
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/fs.h          |  4 ++--
 fs/btrfs/scrub.c       |  4 ++--
 fs/btrfs/volumes.c     |  6 +++---
 fs/btrfs/volumes.h     |  2 +-
 6 files changed, 21 insertions(+), 21 deletions(-)

-- 
2.53.0

