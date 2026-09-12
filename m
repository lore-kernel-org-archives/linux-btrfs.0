Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8E342885F;
	Sat, 12 Sep 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229860; cv=none; b=EYgGSbz4SSos1jOzqhmLZQvIv3oGPtTf/0oMCWa6YLSkQMpLttM1SXLdfJtDk/xskxH28c/sB668XM9uSSi8aOfaDp5wn3wnPho/9iTyWy+WJdA1TJyNXo6H5hjVo0P+ot9bmYEegcDZWk4gldm25mXcQHP/CZHN3kkphggraKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229860; c=relaxed/simple;
	bh=bxDWy4RC6LbNzk2UXAMDLDtzzg0lI1ZvKUHUhE1Zyvs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TQf+BvU64NYqDqzc4gbVLYf5jgpq94DU5i1sgw9slgna+aRZk7v0sD4o7OicXFieIUy/gGo1FdtEjh3Rq6WifwNvKDv/nJR3SEXMeE9AsHJFiNZSLn/0gn1UZB2SKJYeJfueqvs+Ew9cAcBNWW4k/y3xFXNYYbMKma5h615wAYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwnWSnuC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwnWSnuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F01F00893;
	Sat, 12 Sep 2026 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789229857;
	bh=D94CwZ5aHJh85yg9N4Iro2wabENMIS5iaTtO7fKv5Io=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SwnWSnuCeg7i4PILLMr65ZWF7xpvup1lTlE22rQ+L5ZOAJeXzKZyhV93tXhSjcnC/
	 rnifh5PyS0Ea7XcxP++Ey6RtfezDhqL7tpVRhKoyD8JoZXA6RUPMlmBnuhHH+QGP5Y
	 pKiNhUsiwAd8PA7XGxHcFJvdL84crJFHolTgmC9BZDx7MTk6EDZUeXwjwrq6sNUFgF
	 8WA+QcJOqKsDRFTsqmm62iU90aZYXGeb8IAvSf53yNyJX/2EMcbUdzN2yfX0LN7Y2F
	 8KJGhHIw1APcBNNGV0YyVKjMqQ7y8KPYdwnuBo0DKlK/iyISOR4EGIhzjLs3DcT1xt
	 J1QxnjQRSiuJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4C52E380820D;
	Sat, 12 Sep 2026 16:16:35 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1789169569.git.dsterba@suse.com>
References: <cover.1789169569.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1789169569.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc2-tag
X-PR-Tracked-Commit-Id: 09f1294ee2abee7fe1c2d600671498b7642e0fe0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 95deca8dd9a91063babb2ef3a69f5248b1fa824e
Message-Id: <178922979397.3530607.10616460555041501348.pr-tracker-bot@kernel.org>
Date: Sat, 12 Sep 2026 16:16:33 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 12 Sep 2026 15:37:14 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/95deca8dd9a91063babb2ef3a69f5248b1fa824e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
