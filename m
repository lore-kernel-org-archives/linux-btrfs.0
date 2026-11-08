Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794096082;
	b=H+v0Fqf+VKS+diymuYp/ORNpOvrdakZ4c9/ioeazBMpWUajFA5fMoQz2vJXQgoT2nN6k
	 Tnz2MnZ1qlTp5nMRRUA5fwCUwA3NudzpJTHSi7Uv9v7E0CedUsYHXOwWOhHxExBIm/jkr
	 DdWsI2pwlxh+fOujvLSWBc974skO/YgaeX8AAGfgClXC4T5C0R9uUla3f/7MVs5bidNM/
	 8lEMx5FumoWwMOgh+r31cuaLHn0PupXPCRBQumcJvGu+Pv1OYTOgtIBukw/mkX6+ENRez
	 PVo72xQx+Ht0p+CFvBkdsjDaugX6e942jB+yxdNiSShvnSJ3ny0auSennmzXc698KSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794096082;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=HuqvdMhd+3FXASHW/XnQtAhHLkKifWf1J8izzLIV5ZM=;
	b=k4UxyCdB8qmH+8Qgk7MaVAqe3L0JByiJBwBRW245K6OGpTZU88LOCECO9eS+avIP9CMR
	 nXD36Rnqka8IxP7k6hrGRjvm3p7KpC+nH6ipEXi4DNd3J04bwzvvkOi34sbDa4D7/Fq+j
	 Ch7bcUrFF5qI6z6NsxBvxD4EVeqoBdSwce6Lib6q39wSk5fYbqf+TqJNjPrY6Dd6bV73H
	 CuxoSgwmrDU8LSnaZt2thP2Ajfk/4AWCuButNA0bwR+PHzExJRQD3Aox2qW/d4dW0ZlcE
	 2MTqBUAFgx1Q4yqzsFtr9rv3A+RL0dKAgeyWjGfykKvIRdOh0TD5NkVjsygsQTucYSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N++lbpHh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6C606A331;
	Sun,  8 Nov 2026 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N++lbpHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493901F008A2;
	Sun,  8 Nov 2026 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794096082;
	bh=HuqvdMhd+3FXASHW/XnQtAhHLkKifWf1J8izzLIV5ZM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=N++lbpHhcqcVSHIPU6dBqOqY9mlp3tcUfaR+h/uJfAZDcTi1mizMJqkfLDIrfjLGc
	 T8FwrWG4TqMXY3+0agTwPg/lDFusXHszqaw17e259l4cf+/v+znecpCDGj6vjYeVdj
	 YeXpbGhs2QgB0fx2F4XALdcYen+t7yDTx9kkAolAIb51DBTK6HZjrxwl4zJb5ySqCI
	 JEYphOF1zrb187Dk1RZRG9tgIK7Tpy4UxfmWTzZVzNIkoHQi9ef+oy4wOorUvYW2Zv
	 HN01TjDkYnQY9YRFsR2KtRfhBHLmyQGRlMWzkF06Im9Pvl5p0JcWLIIdXWE3nUrlcv
	 NkrlX84xBxImg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B2BF3808220;
	Sun,  8 Nov 2026 00:01:22 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1794085177.git.dsterba@suse.com>
References: <cover.1794085177.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1794085177.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-7.4-rc1-tag
X-PR-Tracked-Commit-Id: 8c66a6aa59a5df1d672d72b7cd379d897ff73200
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fa4ad798f6f681031775266044ba1b0cf3c670bd
Message-Id: <179409608100.1384930.3247728165087919113.pr-tracker-bot@kernel.org>
Date: Sun, 08 Nov 2026 00:01:21 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat,  7 Nov 2026 22:04:25 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-7.4-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fa4ad798f6f681031775266044ba1b0cf3c670bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
