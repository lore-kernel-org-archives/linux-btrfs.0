Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086933E3C7E;
	Mon, 27 Apr 2026 23:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777334026; cv=none; b=WJ+UEyCU00H8+cZsjOtab5KudhJdszgWvbQctHIaOI6fAt2n/2eGZR3lSnpnRexBuz+WR+SxI5Uy1yq0aAsKRlGfiMbW6eKSPp8QbADDTPHV9mZ5ow47IoJRq9sCA9afg5mSJiY0iubX+GGUPkUHfd2OKf1DOKsEP6kcEO3IAOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777334026; c=relaxed/simple;
	bh=BVnsTvKH60jSCbsUgKZlmw4MMIYIhaTUsRlxCdpgJuQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=PT7XZlVECsUu9gxRNExFLEs8mUDCOoPzbvrRRaixD7QzB/btSO+zHKaj6RxFJseUYZ8xN3cCHketndMsp/vjp854ccon/QmxIDazWyubKY9qrsVfhvn13jsAV4fH73d5czGcITYT8gTwg88LLH9LLqH5tng7QPg7Rajqu49t+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQLABC0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQLABC0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FABC19425;
	Mon, 27 Apr 2026 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777334025;
	bh=BVnsTvKH60jSCbsUgKZlmw4MMIYIhaTUsRlxCdpgJuQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=mQLABC0ujF58hmXnnhYSfq0rkYmEb+KRipJzzgue5BMGif1Wv09GMjg0veM7Gpnk4
	 qr1qjaV8mSub8DTf0NFoj/my8lynKcxHPsdXudMdh/mpam87rk905m6ElHU2DgUP1A
	 sZ4LJB+EAXoMFNsNCthslpd9BZBH0cgYrttYswttoLLRyeMOHnMtarHxs9wbyl4+tG
	 R4KzJu38eDufX78sukgz9zih+pHbyxvSATFc+Lg/pKB5XCIXjJ0erCdJB+wmLV7OtJ
	 DMyJLwrPSxA/7ozvL6NxXimI6C9pJh1He09E6s/B2lAlr5QE7jMMgn+289n9peiijJ
	 40CCU6raFwTnQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D179392FFCA;
	Mon, 27 Apr 2026 23:53:04 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.1-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1777300791.git.dsterba@suse.com>
References: <cover.1777300791.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1777300791.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc1-tag
X-PR-Tracked-Commit-Id: 82323b1a7088b7a5c3e528a5d634bff447fa286f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 73082fbdb10aba317e8469f51e3411814f2e65b4
Message-Id: <177733398301.159864.4825416072706877461.pr-tracker-bot@kernel.org>
Date: Mon, 27 Apr 2026 23:53:03 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 27 Apr 2026 17:04:29 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/73082fbdb10aba317e8469f51e3411814f2e65b4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
