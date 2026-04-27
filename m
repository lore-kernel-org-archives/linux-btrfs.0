Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D26169AD2
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777285100; cv=none; b=Jvch9qJJ1s7Tm2Ez5T8hpgj8txzJr9qHgShuiNctAABI+zGQjjWlLECrllKRgNvBpxDoPL3gyPStix/Y4rTp78gqcT6h8Kl+HbdJ2Y7gSzbrCR6y6wiRLMPuJOTWdfIZUXtiaKx/LpWdNOtv0Y/dgdZGFUwWUXHjPWJL5WAubU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777285100; c=relaxed/simple;
	bh=cokB+rE+3lMi6h44uNRcQk/Bi//I6ASoWw7flNDLwfQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o9tBg+3EY9DnVT+tDPHFjgt2gTKMJW51oZWlhG60wVHDJw2CZJ4boQMQU45t8CSBdpyNP4ldUKFnxJQ8p8hAfvQ22Mk/PIIyEgbSQvWqO0yN+HKjtke0RJvxNDYTLYeMXBf9ASQ2ugYlxcWNtfnMuu7Z4N6omA7kqrO8D57vfuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHw4vqnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHw4vqnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E0BC19425
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 10:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777285099;
	bh=cokB+rE+3lMi6h44uNRcQk/Bi//I6ASoWw7flNDLwfQ=;
	h=From:To:Subject:Date:From;
	b=mHw4vqnqAekRvz5vBd/Yq5sBEhQbEctjBo2AzuqgNFurXrD65T/+WfU1FHVL2tYHU
	 rhoNY96+GX/jM65bg2aM8twKWEvyDRR4mDnRhG5a3WqD9rmbU++tY++7tQGE3x3mju
	 cJL9sQ3Lfwj/rsOa+knqJB90TGiHljIdKKA+aFmZb06JV0FmPwzSbtf4aQ9faqzq2Z
	 Ar0VT1Z1Db7epg7fmudq72+GHOOmLRGINu3fLvDrml5yMroIq52Putt+21OqPHQj+D
	 J8WN9VMFqo+PaPNxERDXyl2YL5TZz3r1Hw/TWMsIhIovJ7kvQEYjo9FUQgVZqPhOb0
	 LCy9IV/ZnAt8Q==
From: Anand Jain <asj@kernel.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] fix s_uuid and f_fsid consistency for cloned filesystems
Date: Mon, 27 Apr 2026 18:18:02 +0800
Message-ID: <cover.1777281686.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
  Thanks for the input. The plan to implement a consistent f_fsid across
  all major filesystems has been dropped for now, so ext4 patch is removed.
  Please refer to the discussion here [1]:

    [1] https://lore.kernel.org/linux-btrfs/33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org/#t

  This patch set specifically addresses the issue reported by OverlayFS [2]
  regarding cloned Btrfs filesystems.

    [2] https://lore.kernel.org/linux-btrfs/20251014015707.129013-1-andrealmeid@igalia.com
 
v2:
  https://lore.kernel.org/linux-btrfs/cover.1774092915.git.asj@kernel.org

Anand Jain (2):
  btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
  btrfs: derive f_fsid from on-disk fsuuid and dev_t

 fs/btrfs/disk-io.c | 11 ++++++++++-
 fs/btrfs/super.c   | 41 +++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

-- 
2.43.0

