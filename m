Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DCC2264A7
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202424; cv=none; b=bbXVGI/NmYEJBleu5tMD8B20XtZKozX3ccuyOTyOYCJ4EGoUXRPJPRY2JR1qoNY/QBcHSe+HTHlcL7znZuyPY/eIFWMpMXo89ET61TQjlD7zG5UMafeDHWlManubi+Nz3d0DB/34LeBaLjdg3Hc68CbguZ0HDhc0SUBUBXWN/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202424; c=relaxed/simple;
	bh=ysmfHAt0C3rWgyAFZiVq85jN/IRKM+3ZmK93hrcSEEo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WadY0XzySx+u6byRPehLTx98O2JYpkjlEniIdsRdGegW+ZJInnPvbKAw1vVg+rPsY1hpP97TDnK+m5OYHxNjuOFFlPsPcwlU4Fdt7J2uFnQWGzXsoEn/GzaFVAqmuU0kLynpc634GqJ7ejCARuB4rMLGHrF76h+ngahSyLZL6ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHXDai0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHXDai0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E921F000FF
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202422;
	bh=9z91S4QtQMrhFNHJ04GqYjKAgycfR/GfAVVKS9J7swY=;
	h=From:To:Subject:Date;
	b=hHXDai0ABL+9bYkOzsEPT9sJtztwfq96faRzrvhZkfA5C28yfrqsIM94deVAsgksb
	 muihHfm7WWfI2w78qmlaO8LZzAiSBv0xHOeI4QwQi63DSE5wyrhYLkXjDgjNxFVCCL
	 ePbZM6NbJu1BzpuNhcUDd5FHF51dspNcc6rguuUSCyIX3IoGwLK0HNt5Nsx8TRrGdz
	 relbVVRupnvTUUsidlwG+tt2l/P0FXTCmUNTzR8Sjk3GSQZgHQV1Aa+TWHpcQkgtol
	 6PgqNCx2dO+xDOcV7JiGisq5rV4fEbY/M5Sb5S6lor48SsDg7LAq5/KWRNg52dlU6G
	 UhOydWthn2LZw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix a bug with the squotas code and cleanup.
Date: Mon,  5 Oct 2026 13:13:36 +0100
Message-ID: <cover.1791202322.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Fix a bug during log replay (regardless if quotas are enabled or not) and
a cleanup.

Filipe Manana (2):
  btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
  btrfs: qgroup: make btrfs_record_squota_delta() return void

 fs/btrfs/extent-tree.c | 11 ++++-------
 fs/btrfs/qgroup.c      | 14 +++++---------
 fs/btrfs/qgroup.h      |  4 ++--
 3 files changed, 11 insertions(+), 18 deletions(-)

-- 
2.47.2

