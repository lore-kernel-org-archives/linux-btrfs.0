Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1A382291;
	Sun, 29 Mar 2026 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774802591; cv=none; b=E8K0o2zM95foG8deJeID0fJi14ofxKnoyvm+OVJZzrUhwaf5Ug4AcKOYU7xrO6NSI+BqaJ0Lt6w4hqT7WlCdP5KR9ij+T2PQEY5c0mhVimX7zL9mxMUdocXB1M0KGDCZEK64u4HcwbC5IcQWB54x6nvXHX3ai4RLFGsmmFvSbdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774802591; c=relaxed/simple;
	bh=w1tHOcLR2EQiM1/gXLL4cM+vpE2NrWvHxDSVuydgnF0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=B7hlPBmqCXjZHikv6kjvH4uCYFyRelFIlpSaeEQ3ZaPokQgNmMt5SxFU85PNGa4dCjx/yeq29gvqu1U4QbRi47Xj1qUXDHVQG4vC5Z00/nE08zPLqJplbB4NYzIN0OFgCGkzTvzqcaT85ElD1k/qwWBcqjO5TavLAOY5fIDlYx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kU4lZtgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kU4lZtgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D32C116C6;
	Sun, 29 Mar 2026 16:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774802591;
	bh=w1tHOcLR2EQiM1/gXLL4cM+vpE2NrWvHxDSVuydgnF0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kU4lZtgG6LtlDHphveVtGvi5Y4DirFrCIPKqMCNmvbB7vQETDLsWZJoheJY1/p/dV
	 jkZvyZqFCIP22QfsYmSs7JYUxfL5jGANM8+xPdrNA9k7KMMvA49GFtyPUu/+EsU7dP
	 IBUBXfkjn7WcES4X0emo9wjGJaPtrlNaTXCNaMlsIk2cu+SQ1TJPFR+cm8kU2Dxzxn
	 85pUmCS+aEIE2u4ELC0JEJ3dggagH90nXIjRKfC1jwCbxdMG2Zve1dZbigSpciAlfO
	 V/uNT4UrqkpBn/zgyi3iI7/9rElz6PCZhzD/ZTQnrxXu9rLlW6IP1tvD4LrZrNtvIB
	 D3cGeI88bnNbw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02E27393000F;
	Sun, 29 Mar 2026 16:42:57 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1774730316.git.dsterba@suse.com>
References: <cover.1774730316.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1774730316.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc5-tag
X-PR-Tracked-Commit-Id: 1c37d896b12dfd0d4c96e310b0033c6676933917
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b51ad67773fbe9a03945843215b2cabffafa4084
Message-Id: <177480257562.408055.5933619654126848532.pr-tracker-bot@kernel.org>
Date: Sun, 29 Mar 2026 16:42:55 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 28 Mar 2026 22:18:56 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc5-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b51ad67773fbe9a03945843215b2cabffafa4084

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
