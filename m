Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE49493D34;
	Wed,  7 Oct 2026 14:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791382508; cv=none; b=E5tZLndCMcGcDRVE3Fp/CEEadEax7CdW5NDdek4sZWNKIxr5/iFs+RG0LCcvFKQ8UhCApPV3/WUlQFM8BWBLPLFxryHCp6TnNgQIAJ1kYZsJRbC66A60O9lOa8wmozeHb4Wr+czCEsc4YcaRLSw4SpKYDPAcQ66D8Tpk57qctZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791382508; c=relaxed/simple;
	bh=kAvqCyXdf1iIPl1fcVYNJEoCkGVzxy0JOcKypLp4Ndg=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EWFlO4cT7mi9pOqQrue+8qdw76PCb+cVfYmMZd++jsM6P4RjuYzxSn5VjAPr5FP8FHhHsIyF/dCnr7JGI63NDeJUY/fobA36HlVEgVqkiaEJ7jF8BX2g/thPCfSjcFjp/Br3Spufpb1xVGd4NqSUh20k44eOXmqJ9EjqLOK8Aw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/wOz3if; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/wOz3if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456D31F0089B;
	Wed,  7 Oct 2026 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791382494;
	bh=uA1aSUCThTXM20nOvIHCPyhqpt35FORk5c4C+eLaUDc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=D/wOz3ifrhpc97/3PAKC/3kF8xP7cbwvOS0AX+NxZhPeJ2bGgS4iwXkfEXJM+jIf4
	 58HMRe2pxPOYUm5v1HL8JIeBvw6wK84juq6JRPbRUqot9Rqye3q/kKlII9V5QHqg1X
	 zld2J0QilAp0BayXnqWJF5mzqEpmDvqqqY/k0wpUYR3TnojQ0r9IxdXkg6WTZnB7na
	 Qh/mmnYi9X8TdH4IIfPZ/tlUsKx8rF5Z6FILCxbKg6ZhV+k6xCoYicmsXjNtsVG09l
	 Vl/qxcVaGhgTjD9rdYnpzHsE2U19X29vc5nNZ2A9NWj8dHAHFjS77aTXn7grrNPoZK
	 zqgSY3tU3pqYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A5033808209;
	Wed,  7 Oct 2026 14:14:54 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1791380069.git.dsterba@suse.com>
References: <cover.1791380069.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1791380069.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc6-tag
X-PR-Tracked-Commit-Id: 41c8899d59898f6fa51ceebd2b6e55257191a8ee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b63ef2d55f24519e7e9e5f4d15dbea03f126e40
Message-Id: <179138249275.3561993.11198973481969594313.pr-tracker-bot@kernel.org>
Date: Wed, 07 Oct 2026 14:14:52 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed,  7 Oct 2026 15:49:12 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b63ef2d55f24519e7e9e5f4d15dbea03f126e40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
