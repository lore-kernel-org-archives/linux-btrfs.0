Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBCE340298;
	Sat, 27 Jun 2026 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782567726; cv=none; b=Y7HlWauHw29KCckAgc4DNvahM9QEELtAJjyr71CV8noinBInuFeqGjV2/3Kd8L5z1NwLu43rP1fgnxVuMTWlJNl1DhBqbbvgxQWyKi/kbdzcW1XFkcfepBEaL5G09REfQNBD8eE7Dk2vn/Uqe53gmXuDEaHQO/J/UYGqc1yxDjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782567726; c=relaxed/simple;
	bh=F0VGWsJlS39cgFuTAoNdDsh7un72P7F4xMwjma6pqUM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jPUekgRAky7B73bQX5JgWbIHXrj1U4WXYDUFTAHDKr62bFbAqSXswgD6xk0736ms6yO3ZX/9L3yW3q4P1kaGfghaCXQFstxU2Hp02AXHzN/OFwXN/DzavWbOBePhBv9ZzL69HAwOFYNoZ7GRzjFmpWHWsOJ4k+lnPgPvNzf9owM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=X6mVKdP4; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="X6mVKdP4"
Received: from PC-202605011814.localdomain (unknown [221.228.238.82])
	by smtp.qiye.163.com (Hmail) with ESMTP id 44003ff03;
	Sat, 27 Jun 2026 21:36:51 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Runyu Xiao <runyu.xiao@seu.edu.cn>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn
Subject: Question: btrfs: clarify space_info RCU-list traversal contract
Date: Sat, 27 Jun 2026 21:36:46 +0800
Message-Id: <20260627133646.3870769-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f094c1dcd03a1kunmc097a1b4d1773
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHxpKVkgfTEMeS01PH0MYGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUpVSUlDVUlIQ1VDSVlXWRYaDxIVHRRZQVlPS0hVSktISk
	9ITFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=X6mVKdP4JCYIhKCOk75h5YuxJE/A9SKqPFurryGOkLip9l/y1CVBOr+8khGXLY8uR3pzBpAao9dCSmACEHEyoc7CJzQzCRaJ1hyb7CLvAFZHJTNENjFnXDoJ4ojMuhqNphSmeDNcrVmGUWVWD14Ffez9SV61Brl+/zmxCFuHmzM=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=zlLbOQcTXa0fpqSYC3mV92MX2rNLJcC2RY3IzaYUp6w=;
	h=date:mime-version:subject:message-id:from;

Hi Btrfs maintainers,

This question comes from a candidate found by our static analysis tool
and then manually reviewed against the current tree. The audit used
CONFIG_PROVE_RCU_LIST as target-matched triage evidence; I am asking
for maintainer guidance because the source-level review did not prove
a use-after-free.

A CONFIG_PROVE_RCU_LIST audit flags the space_info traversal in
clear_incompat_bg_bits():

  fs/btrfs/block-group.c:1061 clear_incompat_bg_bits()

The function walks fs_info->space_info with list_for_each_entry_rcu()
while checking whether RAID56/RAID1C34 incompat feature bits can be
cleared after block-group removal.  The current source also documents
fs_info->space_info as effectively read-only after initial setup:

  fs/btrfs/fs.h:748

The comment says the list is populated at mount time and cleaned up
after all block groups are removed, with RCU used to protect it.  For
that reason I am not claiming a use-after-free here.  The question is
only whether the iterator in clear_incompat_bg_bits() should express
the intended contract more directly.

Would you prefer one of these directions?

  1. convert this traversal to ordinary list_for_each_entry() because the
     space_info list is stable after mount setup;

  2. keep list_for_each_entry_rcu() but add an explicit RCU read-side
     section around this traversal;

  3. keep the current code and treat the PROVE_RCU_LIST warning as
     expected for this stable-after-setup list;

  4. use a different Btrfs-specific annotation or helper pattern.

I am intentionally sending this as a maintainer question rather than a
patch because the right shape depends on the intended space_info list
lifetime and API contract.

Thanks.
