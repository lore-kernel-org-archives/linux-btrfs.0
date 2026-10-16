Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0590F5448AC
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170569; cv=none; b=cDSqew/Tu6Z/oVIgjC84YyYWl3aHWIVUXu4C21K84em+YttanWCE14wUCqKtGPWnePhjJYJywx+CuWP3pv/JZIlsYOHuxe3WTIatTdgQy4CA2o2MEQ2RxPqpt6+7IDGtmrzr78PsCoFS0FVGZ2evk31U1Z5XS4lT8qVHBdFR9x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170569; c=relaxed/simple;
	bh=dB+qjT5dX4U6ABEmx1hiU3Hgogsk6r3Eyeh+QglwTgg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tpHRuR22aH4A3kRQNd7RPQ9jtG8480E1Sp0IGo2jmQY6KXuKt13z2Cg4Yq8O8Nr1+7Q9jBX5GH1qY78U1R+u3uAwMc+XCgtJoNVmeluKwrlZHpi+n9qIhz4D1mHG0jC7dao+gJfXpLJ4n49g4cA2EHgU6O7o0xIvHO9szgDaB2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XoKOfgBm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XoKOfgBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634841F000C5
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792170568;
	bh=LQ7YKyPw3oYAIwWhsBEj+2CYqJi09DU8LLX/apAZN34=;
	h=From:To:Subject:Date;
	b=XoKOfgBm9D/42LH7iQwJ3bvr4fE+xk+pmZfhBknO+MLvQTgbkjcHZsqbGUURuY9R7
	 ODfen09yBNTI4c8DN+iw4z7vYC5B8yAxrciUlYCot1LLjMEI3X/9mggluMD+CcYfkR
	 6x5ex0PEgozH9Z9MUQpcA3z6yL0dqgTUKLCoeTq8aYF1BgLnFkRk3bqWSlRoPnNw4E
	 RQRY2Kxz+T2Y4OA0/aXrRk1CK9aDSNIm0zloDDP+wYI5opJCaFF97BCpUfOzIEunC8
	 RvkT94eILzKUg9PRD6gh59Zk1b3xiUHjx/AaUxyZolZrfBmsjX4ilvn3xfObeuxY/F
	 39iugyBj1aFHg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: fix a couple races between scrub and the scrub progress ioctl
Date: Fri, 16 Oct 2026 18:09:24 +0100
Message-ID: <cover.1792170434.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Details in the change logs.

V2: Added a another patch to fix another race (patch 1/2).

Filipe Manana (2):
  btrfs: scrub: fix race leading to use-after-free in the scrub progress ioctl
  btrfs: scrub: fix race between scrub and scrub progress ioctl

 fs/btrfs/scrub.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.53.0

