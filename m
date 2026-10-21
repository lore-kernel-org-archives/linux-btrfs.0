Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792550194;
	b=okYG1bDwRgNa3PfdMQ+xO/eZlEe4k9YhfF2EITVe60bInrPcHGLkIKPtc5DNstxFcmJS
	 NQazeC4p1qsMzaHfadjZQ2B7pVWofuPYdPdKgqYksiow/I0BhOg+kOxWwVXCxSpqvtNrn
	 7yMJibjyNI0vj0GtwJlVXLRTN466+B8vknFJWFflZ0FSzPQERriVZVgo96P/ubpokcuus
	 +iujzVX94OsUEOPXhbFwuMoNmDhGb1VtntSwUjiQnPu8HNrudjqmtFXK8wPi9DiLwiGhF
	 p/VjM9EzlCK/59zVk44Rs8rTSIjNgVICud6zsS4ZBegTY/ibCcJygRtomvPRQzWoIFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792550194;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=9kQEVbMM+w9PSHwOoD/SETY4uOLeqi7Ws2dVE2+1Foc=;
	b=spjGr/sDLys3ezWRxaxrDsaeRy+hgK9jeLJ5v2UYQVZ10cT+ItWmsJGkbGiW8KsjooPM
	 qzYRYRLr9I8UwvCTYfAKjnw4wYCSk8Ayn3/cBM7BIZimsEmNBWggf0FbpCczVvM1x4yNK
	 u0+S1SCPkbgYBRjHRBOSLtn+6aq14TWhEvJfx9waeBJ7+vcCKon4nAi92EwoHLImV8xjO
	 P5xvahpTNTgfp2hhrG3hZ5Pk7783pH46AbpBJUUVCKA1H3qK2dHsT8kh0GUgQ5Pnu5Cbx
	 8gVKCTX2EqCkEWTZ4GpfX9n8Rz9EujhFiJe/urVeRQZXaq1lnraBFpJVmo6i+/H27oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVc67wpd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD9E606A31F;
	Wed, 21 Oct 2026 02:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eVc67wpd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D1C1F000C9;
	Wed, 21 Oct 2026 02:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792550194;
	bh=9kQEVbMM+w9PSHwOoD/SETY4uOLeqi7Ws2dVE2+1Foc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=eVc67wpd/cYe8EkpqpjybX1eq2LeMeMutknAcmkInIQA60DeckWo7h1oi5MkCgQbA
	 Pl7hUkONv9je4jrLGfGWyosM0u9ZRAD0EP8Lsn0O0tmRR+HMc5nrH6LmXJqdNVx+7C
	 tI5GXp7hUxI3UFrC3sdGC7ytbwmiQFgnCxICquLb6Wy/h7xrSygHzdqvKDPqj6k4MU
	 0Efzx8BwlY4pYN4CwVBoWvKBt+6MK8bj210HQFhA28bb8v3GqtWWvNkyygnaUNjpIl
	 uYsEVFVTvy6LDBQEDfneapYPoIYaZATYDFyD1CenDZhaskA4I+nSjophWymVwPWnZT
	 ApncdpI1gEFKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14DF3809A18;
	Wed, 21 Oct 2026 02:36:33 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 7.4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1792086912.git.dsterba@suse.com>
References: <cover.1792086912.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1792086912.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-tag
X-PR-Tracked-Commit-Id: 58e844c3ba387ceb0f527a6ba82aa50c81c4d7b7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1b8fc3d89ee0522f535d3714abb300455ed53a4e
Message-Id: <179255019241.339009.14717510459865195849.pr-tracker-bot@kernel.org>
Date: Wed, 21 Oct 2026 02:36:32 +0000
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

The pull request you sent on Thu, 15 Oct 2026 19:57:24 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1b8fc3d89ee0522f535d3714abb300455ed53a4e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
