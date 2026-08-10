Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DE23DC878;
	Mon, 10 Aug 2026 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786364195; cv=none; b=XaKcC70/HFO0S0G61eJBXpZXgvW5diHicwq/t14Kpo83fUjQOGnCYvGnjzRGKUI2+M1atZQB4vu8qgC1qZAV/YuVeZLcfEGJVv1etcT5vC0C2FgQo7CH2aMWGgZg9nuaIGHsWulEhWp95YvWS/zHFM07oElik1lQsFDj3/EZIK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786364195; c=relaxed/simple;
	bh=y2Z2033M9/kwAeifs10feMoiGZUnrYHkpUHgVD6iC+0=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=W5ihRRKFcwqAz8VSbnXHqqdkSL9xSpOBmW95Nd5XH9Yyk3rKInqW2Q3iRDrg2LugCtBTkzCYBGv5YZ6CwsEZCecizQY9L38FCRydhxRrPfvkpEVj9i/YxOUXW7jrDVJAuv/QiTA1ozOe6ztXbA0zc9HHmopKrPmyfhx119TlczY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jmt1CtgD; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jmt1CtgD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786364181; bh=BTkAinKRLNFpo4MUO8/D4Ar6+5TaOSHwQHQbaeUJHeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmt1CtgDr9MyjnKB0d26imU6yrBrZwOX7oMVvo5qcnZ+MfrvfoSIh+BIJ61xRbWJT
	 mbuG2A8u1dUakzkqFkhSOE7Br1EdMLEEpjj3nqhYU8oD15AmGBaO3zJP2XvoU1ulff
	 N2qiKuzzet/kJbcAd9GAWmvHQkw9V/Hu6X36YKDs=
Received: from ikun-VMware-Virtual-Platform.localdomain ([2409:8a20:b30:4fb4:bdd2:8b42:d496:7e16])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 41134061; Mon, 10 Aug 2026 20:16:17 +0800
X-QQ-mid: xmsmtpt1786364177t9va28ej0
Message-ID: <tencent_AD274BC8BB1B11444FCC2955080F81A2BE06@qq.com>
X-QQ-XMAILINFO: Nte9/BsRzcszaafnlMST0OPa9vbBEy4ZnoXve0D+TorFrOMU+P94bunEZ1ixGL
	 gQP/RMmYgBK7vQcgCCyV56VxTVFu5nHaw4Lr0Fm/s53eKkkV/jIb70MpjOSOlt+RY8eqM2wDlVAe
	 MOGd+S8HghlmKP2JPS3ywoW3z2Tw8mkgQAKEeE6jGbxC9x2EyilMfcWrcl7yjLXPtZkAwK+Fuoij
	 M/BNLudSizOEu1sBmcsmLt+YhTPHBM+6OgJP8vIJge9IX9mYN31YucR5cBPT6q8/mTOeprA6ptxp
	 cdJF/i3/3X/H+/bIOJys0GsmtQcGupnIBkD3jopgkbBMwC2GP3fG1MeIMdU7nUOzBBnyGO+AOUOr
	 hTnp7gndF3hExO68jKL/s+nAf0WKJrQN/1v4nQ3WC139guzGm6HsJvpBVlGvjXTj5SBjn/InZcdB
	 jNIaW8854uMSr8kTOayTNruDPr4L88bAbskUj9zyuNA5TXagLrP60Q8IMjcW7b08b18ttJkOhkla
	 gNTm+jfYpvkWLHXYrh6TNkmSNp9wbsOOHnDTeztUFLkHCmFV25BsHlGbK+Pf7eEOkc4d1UZiWFiz
	 9o03cjBO44/FntF6hoP8Y0eGpxY18HRLL3evaqFg+1tW32srpGiMes6iNLSdSudR1J67UazOe0oQ
	 QVhy84syRsZ4K9FvdR6wyt16jlALOnC06vlrN5l4z7EfvA3DQewnVat0haTPuemcX5LfSJfGVMZs
	 TndKOt9ghUkT9XD1ir25AZu5Ahz0Z464BEhe/XfraZ2YAgsfro4FvFwIL2U4yc2dpVQLHb5VLYg5
	 Z4RH3XQAl5vQZnquJBWIAy6L5WnHmrqwtwBCBOA+Bc++8iGkWTfbIGvAmiVPku4ZLITLM8a8kcS7
	 EDnqDQJi3lG1tAjWrCp0V2u6Xs/hkpdlb6eygUglTq1S75gw5WQOsqGkkzLdgyNRkPHfb8/uGq3B
	 15w7gOQkuUsIH6ZnqbQAgMwEOojExGPt+0P3XgWnyOr+MQGxVfa+tfXT6KpJH9w34S7B2M7JI8iA
	 LrcLLcGRPsWz/oisIw5OtAmBEPqG6dYIs6WZvljGHlkBVTC37fATU/TnKUDsdPR2xB2ZXdRg==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Guanghui Yang <3497809730@qq.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guanghui Yang <3497809730@qq.com>
Subject: [PATCH v3 0/3] btrfs: fix failed sprout device add rollback
Date: Mon, 10 Aug 2026 20:16:03 +0800
X-OQ-MSGID: <cover.1786363229.git.3497809730@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786358930.git.3497809730@qq.com>
References: <cover.1786358930.git.3497809730@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes the error path for adding the first writable device to a
seed filesystem.

I verified the failure path locally in QEMU with null_blk and a seed btrfs
filesystem:

- create btrfs on /dev/nullb0
- set the seed flag with btrfstune -S 1
- mount the filesystem read-only
- run "btrfs device add -f /dev/nullb1 /mnt"
- inject -EIO after metadata chunk creation in init_first_rw_device()

Before these fixes, the injected failure triggered:

- WARN_ON(!list_empty(&device->post_commit_list)) in btrfs_free_device()
- a NULL pointer dereference through btrfs_show_devname()
- the sprout fs_devices state left with no open devices

Without the injected failure, the same device-add path succeeds.

AI disclosure: AI assistance was used during code analysis, patch
development, and drafting parts of the commit messages and cover letter.
I reviewed the final code and local validation results and take
responsibility for this submission.

Changes in v3:
- Add AI assistance disclosure to the cover letter.
- No code changes.

Guanghui Yang (3):
  btrfs: detach failed sprout device from transaction update list
  btrfs: restore active device pointers after failed sprout
  btrfs: roll back sprout setup after device add failure

 fs/btrfs/volumes.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
-- 
2.53.0

