Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F5418871F
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 23:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770161945; cv=none; b=kOH5HCtyHiR1Dnj7hClq4eCqJ3f7sPFkzjtv30P6geQAU+Vtw+VpwTDSd2u8xcLPGa4hwJJ5Eb+PmHZDcfeJYViBWRolPJUlAp751T1BlUApOJHdig0iiJv22/E2FjmHCP9puCgwEt4h3n3OqcvLKgih+Cy0GsPivW72DEJlvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770161945; c=relaxed/simple;
	bh=wWHdHIxWylie46i1fzsC4FFezipZjPmD2STTDcpjr7k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCh1TyQz2xmiptOnkE0YPp1C6EBNAsGsA55rzJSrUJW6yX0DTZYCyDGTDuBqAXHgolFmqVyJx7lzG23HquB+RFPq2QX4IsCBwbCaaPvdLvaxXupR51OvvYiGHRpUMZcMT3pvWu2elTUJY39ObecoBVmcvanmrrnOYi0rjBBzF8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbW+ovJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbW+ovJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180FBC116D0
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 23:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770161944;
	bh=wWHdHIxWylie46i1fzsC4FFezipZjPmD2STTDcpjr7k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RbW+ovJRa57Ab0Verw+NJCUpXDb368Op2xv6QGGS2cNDH4q144+tyxg7h1tGax6FY
	 nsFTNkJjiAVIN8VpkbVtnn2GVWaqICtyN62oCs33ZFLHc1hehH5OWomfxaXgcdE85G
	 LwMejSw67gB3/3ZzoHh1/wbXchmlXmMaM21IxosFm5X086sSRxQ01qH6WcXN6/Nmq6
	 MA3VPMInLauYTuo71at0jyx5THzmCHnc+agb6Yg0lSNKBdNsNEKz6b0fnBQRBVMlIc
	 E5aOXG2OtSx5iTjanMj8t4WP4JFDf9xQ58xdBRYxSAt2kWx+O3QWZmK3E35JUSn0VB
	 J+aG64uJo0Xaw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: a few space reservation fixes and comment update
Date: Tue,  3 Feb 2026 23:38:58 +0000
Message-ID: <cover.1770161798.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770123544.git.fdmanana@suse.com>
References: <cover.1770123544.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

A couple fixes for metadata space reservation and update a comment.
Details in the changelogs.

V2: Updated changelog of patch 1/3 with much more details about why
    metadata chunk allocation fails. Added Review-by tags to patches
    1/3 and 2/3.

Filipe Manana (3):
  btrfs: be less agressive with metadata overcommit when we can do full flushing
  btrfs: don't allow log trees to consume global reserve or overcommit metadata
  btrfs: update comment for BTRFS_RESERVE_NO_FLUSH

 fs/btrfs/block-rsv.c  | 25 +++++++++++++++++++++++++
 fs/btrfs/space-info.c |  7 ++++---
 fs/btrfs/space-info.h | 19 ++++++++++++++++++-
 3 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.47.2

