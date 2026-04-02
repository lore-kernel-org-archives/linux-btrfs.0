Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F17A3F0ABE;
	Thu,  2 Apr 2026 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775151518; cv=none; b=jK/W1pBzWRRwiKtJrzqOMY+jgZTMf/9JXNal1FXqpTKBM6GiTc8vCWl8H+rUgZeADgzihsCwY0DVHz2YmqACExLOzBrKCVbQ24dymBKDJN0/yrGuIdcfdoxllz/VZxziJiuLpkV13QyQAGBalIkSIXMFB8hJisWSJAaJlvu5bxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775151518; c=relaxed/simple;
	bh=sB3FJcVhDec/KwnGgosapScr5AxuLMjpzHfZQalrclw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=t1JsseFm6DDDd9o488sPiPP9ihqnRY3CsaFIxD1G73+Deo+1/UdYjdnQG807sDfCmfCbeSvc7JI6yQ8ajutmxzViXB+fYBCp+3IZRwl3CmSMNsOKnLISBeTbPscINsCsRhJMbFCPTv7ryC5DC7kfbuEMektR25P6Joznkc8VPas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErssArN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErssArN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D7CC116C6;
	Thu,  2 Apr 2026 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775151518;
	bh=sB3FJcVhDec/KwnGgosapScr5AxuLMjpzHfZQalrclw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ErssArN1c9+DEI60m58mXn/M61GOoWsR+gPRu32Eg+1yv+sAgYKAOFTHG3k7N2dbF
	 Vrsl99rBdUbgUORY3JbMWvfxe1R3pn4vU8yoRZahEhs1dNivrl9s3MwCWO5e6Js3BB
	 T3mee3RHx7Xo6K7Cv+b6uEybnnNKNpppudZ99khd/zne14WN7Zof6EHeA1AqXa1M6K
	 b4zrK7jUeoQID0NmGATMyZOaYzn+zITEcdiJS9KEZih3hKMOBr1FFpj64kMby6qrBG
	 m7LQZyztnPPX0AOJusmRTUXPOF4WnNLLGnN2bPp1yuzmEnl6QMBN5XjBvDXpTx3Yjg
	 1x6E0m3mloJHQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA24A3809A08;
	Thu,  2 Apr 2026 17:38:21 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fix for 7.0-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1775149839.git.dsterba@suse.com>
References: <cover.1775149839.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1775149839.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc6-tag
X-PR-Tracked-Commit-Id: 316fb1b3169efb081d2db910cbbfef445afa03b9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5619b098e2fbf3a23bf13d91897056a1fe238c6d
Message-Id: <177515150038.547608.6350963810303336934.pr-tracker-bot@kernel.org>
Date: Thu, 02 Apr 2026 17:38:20 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  2 Apr 2026 19:19:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5619b098e2fbf3a23bf13d91897056a1fe238c6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
