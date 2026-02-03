Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D792DB7AE
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133166; cv=none; b=g+EYFEEUjX/AUucDjvIGhB/FA9kw4lzDjAyUFf4mv1DUpts9MjFJcFJzKZBa4O+MMdTLReSPlS29BZumYZ6isbrVShQ9M3Ldmx/yYSiGzcIPLUA0kW03C1BXHVVHGBPaeKq4YBeKteLW2j+vZZpzRoaYEPvkKlmr/DLvy88dwec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133166; c=relaxed/simple;
	bh=RCfW27BeLZUsNtnllnwPSQaGZb+eFQOdZizVd9z37UU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rz3MxTAY0hQpBCzCIr+eDMqjroi6pY+3ZRI5n+q4P0H4wQegNOv3DCpwaT+8qQIbBHDvXC+skh08d2mJDAiwJWTvDOAQXZ4V3DyhEhpbuzKollegihuiYvAxbt8Q/wZeSmy5Z4N7CwB5YlwwmlZiyo8LhxEVMKK0bnAMJfkgwBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XzAPqyY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XzAPqyY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D9CC116D0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770133165;
	bh=RCfW27BeLZUsNtnllnwPSQaGZb+eFQOdZizVd9z37UU=;
	h=From:To:Subject:Date:From;
	b=XzAPqyY5PcQhZo8rKLy326bnMTKuaiUmLry8wJPf0042jbdYkbPYygCNutx/IYkys
	 T/7LRw4fpywfUtLoeV5ybqa3iesbZTLvxt1rCkaTLk/eH7SvTJRyG/lEeILIbHCgyA
	 j4U12p0+hy3tGnH/LH5D/ilj1VS6mMTXA/YSf1xOF+KkHXM+B5nhhMxrefUJ92fsAA
	 nwxoLWilvCSdWr1A4QDSIvbnvtzpFvqymC4q2C4pvHZUbwVD9l85oOEA1IEbbe3RpR
	 bH8dmsv0bDoAx7kFPXV1WcCJihd5RXpby/8F3p3ckkkb+PsaHMsxMdMUF6zWyNhiZY
	 ZtkTKgWYV6K8g==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: cleanups to the sys chunk array checks
Date: Tue,  3 Feb 2026 15:39:19 +0000
Message-ID: <cover.1770133086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

Details in the changelogs.

Filipe Manana (2):
  btrfs: remove duplicate system chunk array max size overflow check
  btrfs: move min sys chunk array size check to validate_sys_chunk_array()

 fs/btrfs/disk-io.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

-- 
2.47.2

