Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988734E0B62
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790778351; cv=none; b=W3K+1BnYq/ZuqVPSbHBZCP6gTKtc0bbtt9ABGiU3sWnX7/iUHTiBFTvtk2oe/7fr+TI576c6N06U5WVkH8e877jScEzJkm0h0evyREwFRXH9Exq4m30TgHSCvPS8UaL0gXRWA9r3uysqU98WEsewrNLvPCeE0BjCT08KMaGEowU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790778351; c=relaxed/simple;
	bh=vwFzkjSCXpWYq7xIs7tT5Qy+CLoHexXJP4JbcfFHJDU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=S2QS8Rf3mWa4sLFMzPUmlv0NTmNH8sbOszG6pH6C9gKngkOYMZMDYJ4lrzNWznLavgYVWhou8iUJD8Vh5xF8k9LKTPP0yLOMl9/fhb8ZPL8DP+0KeNdMbbgHPkqZdUUJ5WcqQhD5KV3FkGJvRElRL78UJhOa/+vvF30QXk+iq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/o30Q8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/o30Q8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C079D1F00899
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790778343;
	bh=eF+mHXJoU8EbfZHWDFTC7KT7x6cbQDj0P1ooB0zvcck=;
	h=From:To:Subject:Date;
	b=j/o30Q8Es/MdvjrBzrQP2OVuXoNECfkHtJE2qTgCVP/SXM6SmZin6em/FUkdJvw6C
	 xJ/geFjoD4+cH7Isc97WBLEYsX4KOddRVGDnuyJciR2lDBBKEIkuZE4MtdByJCD914
	 aXwRLnlJ0N0DJBH/RTTAlz19069zRQxvwxBc3C3nIncmrYrDqA4sURW7mYllg8siCR
	 swJ76njw7gHHcHqFBc3NW+FX3E5UkjRohM6NcZMG9sT6ssJ5Bg7ZCkN+RHl8HWKj+q
	 HjFHcvGpXlfWccVSJrCs/tnYOTkOIBAF81eiyIf73/6srkONGM/GBt88QVsPBKHOIL
	 xX1RRFWocjQWA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: fixes and cleanups around messages.c
Date: Wed, 30 Sep 2026 15:25:33 +0100
Message-ID: <cover.1790772326.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix a couple bugs when building the fs state string for printing in
messages and a few related cleanups in this area.

Filipe Manana (5):
  btrfs: fix incomplete iteration over fs state when logging messages
  btrfs: fix duplicated code in fs state string in logged messages
  btrfs: add missing code for no delayed iput fs state in log messages
  btrfs: remove unncessary pointer increment in btrfs_state_to_string()
  btrfs: avoid overhead when logging messages if fs state is clean

 fs/btrfs/messages.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.47.2

