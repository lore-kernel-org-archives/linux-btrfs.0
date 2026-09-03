Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A7372B2F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451238; cv=none; b=Kl+XAhbuwVaPRKi7ST77ttjm2z/uwgXRYzyDKomGZJdQcPX6hSzTLshLYziLJE7GtdBvgW2X6dAL++3J4H3ub8jVwcrLJPjanH8wPmf4pNNIWt6VXvV3MLHWmUC0SBiL1VlFLkJ1E5fWw+2pRm2mi1Ts/yMVC+nZJuv0ZwtRWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451238; c=relaxed/simple;
	bh=j+9t1YdeCIQxs3VUjxHOH98niSNVKycQC1ChKnx0ZUc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAE+7qftBEMx75Fjudw9bdwY/Gtx4Dy4gj+hqiHBQvSoC4aXaOi09ytA0WRmJiFkMFL5TapfzY3PjdlDj4L3O3ix2N9nvmfbhEs94Fa/PhWKjHC+3jaZwjV4j2EyQ6jGqVwfszPjFljfxFjR85P/O6rkl1MPub0BvtlGm7wfVNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ehrv5i65; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ehrv5i65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F5C1F00A3D
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451236;
	bh=tOhxnViRLq59DZ3Ms0+izDS+RJGeFcYJXtDTlKVPSxE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Ehrv5i65DQDfWhF8iFTDOHKhttjq7D/iBUjz6crxFMt51OBUyZwj4CTwTL9lGA9XH
	 j3OmcmGvVR++DtzmC/pGYS20gVH3z0mf1Rs1xpZ90vsTsysPhZqh9XR0mMf42XLQwD
	 Y68IhNAdMaeBKv4B3Wu+DkavKaFwcLlMee9m2W4KSxMP3N5henreEw+Qlqi2sIT32X
	 qbgI68uSdMyC8uUHRkg3HnYS+xsW7NMO6hvDzUSyrSYIPSHcVsPczfqCzmW+UFxedq
	 mDT0UGzkyxPXfLgTTvzKJDc6vD5IJIS8zeVDObSQaUlA4fY/QiDyYL4xFnUr/OB9Zt
	 huwdQkrAvpaeg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: avoid unnecessary transaction commit and tree-checker updates
Date: Thu,  3 Sep 2026 17:00:30 +0100
Message-ID: <cover.1788451065.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1788449622.git.fdmanana@suse.com>
References: <cover.1788449622.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Details in the change logs.

V3: Fix misplaced parenthesis in patch 2/3, making a condition always
    evaluate to false.

V2: Updated patch 1 due to sashiko's complain about lacking
    checks in tree-checker for inode ref key offsets and unnecessarily
    trigger assert failure instead of falling back to transaction commit.

    Added tree-checker patches to validate inode ref keys and inode extref items.

Filipe Manana (3):
  btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
  btrfs: tree-checker: validate key offset for inode ref keys
  btrfs: tree-checker: validate parent field for inode extref items

 fs/btrfs/tree-checker.c | 22 ++++++++++++++++++++++
 fs/btrfs/tree-log.c     | 16 ++++++++++++++++
 2 files changed, 38 insertions(+)

-- 
2.47.2

