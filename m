Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D6C328260;
	Tue, 16 Jun 2026 07:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781593682; cv=none; b=fCMkqCMlyJ3nRtfsoCPHIM61NAWHprm/t3JvfX5GOp/kTKJMh236DIRtN6wSPwRAjr6ABA6Pz5dcFsr1fX2gndD7azodnYMfiTkHaIFlzE3GLCTkfI7JYm5mTw13U+2nkqzFRcsiUUoeamYubwvoT7q6L7vcfQ18zXszIqyDhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781593682; c=relaxed/simple;
	bh=w1zQBnAGZB7q4v0fs/1OCmf7A7iu+O6a1Mp/dQLwc0k=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ity0MQ/FkuaL0bZBW2o5xOXwrI2/5b+uNE2f5tsfuqmXgSZTsLHs3Wix6QFgRvagRuxssz3xtO5tTM5ROB2IiZq+f7D0GaTquiE9tH8kfxiwQHz3CxRSSLypiFiYXS0iHJLdAvAG2KmWw/tyxgJSNNkrfkLu8fFGlhbLa8Mn2YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ex3wxGqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ex3wxGqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEA51F000E9;
	Tue, 16 Jun 2026 07:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781593681;
	bh=+QefDv9TTMXZJYgWMUsB3wPQOZ+A8roB1K9bz/vzIVw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Ex3wxGqzWIL675qMDgXVayXu+XikonA7/jP1we/nJDQTl6Wjs+6tgJMBlWC2JWWAX
	 PiAQhpm1NppWzolnQc/K3CdCBvq46b2MX4FSEykIxWSF137O7u2/29RCe5CtITotsg
	 zonMwiF5+voS16bUA+6vc7yVNJoykegK6WEL3cMPuK8h/9vf9dJD6m0Ynav4JNAFMS
	 gubA/m93smILgSzdN4rPBcJM50cCXnwpXDIXN0fxFSo0B8tkUuqWxNGitZBVJWIXRS
	 CKWXAiTLnsyPNzsuwbsUyDmXi7FpkC2wM7BkXdyaIRjrJvRa0kla84W1meoGwCkLbZ
	 ODYSXnee6nhtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93B8D383BF5B;
	Tue, 16 Jun 2026 07:07:57 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1781558337.git.dsterba@suse.com>
References: <cover.1781558337.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1781558337.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-tag
X-PR-Tracked-Commit-Id: ae2eb64bfd9762536f60b690840adcdf622cdcce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 31b706da2cfd8ee3352391181ccf9696bed3d25d
Message-Id: <178159367612.494683.5268382620088031351.pr-tracker-bot@kernel.org>
Date: Tue, 16 Jun 2026 07:07:56 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 15 Jun 2026 23:29:11 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/31b706da2cfd8ee3352391181ccf9696bed3d25d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
