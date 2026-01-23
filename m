Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1064E1EA84
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769163482; cv=none; b=jD1vubrtQgnHV0i8K9/21JNcV6yl7yd+hZXlCATKchRfe+bVtAIrlE6WxNXN6ABKZDn1Hu1eiUQYEsfVtNVeKMgvIqZCeiVSES3ox+KzY5BKc6spthEoABomncOhveCmCDy/7GogWS0/hpYffhsdNU4YfUh2cjbyMAXkTgz7Ltw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769163482; c=relaxed/simple;
	bh=IAaZhXB6HhwrTsE2osbxXFCGyRa8jHT/BU3N2CstOIw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=de3nFdfB5bXzLnaRI3MsS/dRB7v1pERl+KrVn/rOmc49uAdOTq4RdYYq+sk3xGkJni1FxD+OkNykwYwBroOM8crm+yTFvzalR2/EJpe0i48DAU9lkzZ9sAFWWLwoQM6Az9l0PGZ1QJyod70SSnzODvlFZO+xUjpgaGRSeQffyaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+TGheqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+TGheqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E183C4CEF1
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2026 10:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769163481;
	bh=IAaZhXB6HhwrTsE2osbxXFCGyRa8jHT/BU3N2CstOIw=;
	h=From:To:Subject:Date:From;
	b=D+TGheqCHEgwYuCidDxh7tHhW0cI91lii/rKudjv8ku6pYTji5vhQlG3wbSU5jnMX
	 bYX5jOslgDFD2H3IwlYKZRBljRVX+6KhHO4lhpeeDTNpOOeRV/DXwP/whUZ/iGkWbu
	 W4xS9NqPp2p7R2RDOP0EtUJ8ptEnjgNlufVO2bTGzECr6XKwMrUh++rKEeY8IoOWcH
	 I3DG5FrpcZ9fLqYkHqHu9nIzPvhjW5we46vwhmRYuf7yE61KI6BXn7uAUIqZG3jQX3
	 OuEsa+DAEescHKW9XbSkme60A//vurg7xzgmx6Gww5FU6wcj4ZFWqX1ZEnik875cmf
	 vMzyLYy8jfuoA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: unfold transaction aborts for bg delete and get rid of a BUG_ON()
Date: Fri, 23 Jan 2026 10:17:56 +0000
Message-ID: <cover.1769163248.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Simple changes, details in the change logs.

Filipe Manana (2):
  btrfs: abort transaction on error in btrfs_remove_block_group()
  btrfs: do not BUG_ON() in btrfs_remove_block_group()

 fs/btrfs/block-group.c | 26 ++++++++++++++++++++------
 fs/btrfs/volumes.c     |  7 +++----
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.47.2

