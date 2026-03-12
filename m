Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85A738734D;
	Thu, 12 Mar 2026 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773344669; cv=none; b=IT+3KCWncRvEiMjr65joar/RuQdzWUHe1tePVWrgwof1fwDM8gIc0xnfAu6H36Z8Rr/MLlRXdxmUR6wjnB+RJAVperTxRXz2WJJTQgFO0G+MO+8Q8qyT4e6y4urzBqRH/nhbNHuCCCgdDUgoQvbZmYWcbexxk94JEaGuNXdhrPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773344669; c=relaxed/simple;
	bh=rpu4s1Jkkmihelu9XEi+K5Eg2qLPlVNGKgLbTlZnKW8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y6+2QgfPTkdrDDdc7PC2FwlqqAG4RSuqbCSsId3/5uJGmiPPBred7HgBa+HMX6OXIqGo00nnUBwHPZPErZ0lFdnHvuL0Y4TjR4WJz3xm3/0KTxoX4aWfJ1lh00UkUTW8Q5odKQZvOROVykzUAfI5WvTy1LQuQXyLvB6sBTucU+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1GHk8w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1GHk8w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C329C4CEF7;
	Thu, 12 Mar 2026 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773344669;
	bh=rpu4s1Jkkmihelu9XEi+K5Eg2qLPlVNGKgLbTlZnKW8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y1GHk8w7hGeiKVFfuvAc3YV6K8wKqGuf3neC5NoWM+UbhSytooaSJTENahU04Whx2
	 tegG2k2ugxBYbLPU2K364TTzeZlABduJzDMuSlauqxD7Nl1wr6nwIm6XC/RCh3cNOV
	 ZA1ABAdH5/zoSbJJBo8q7C+NYbRv+8UY8QNb4R4L+x5b6GP7QwoKpjXV/DXEsXzkmZ
	 GTBTXkH/HYXBEC6xRO/b6erIJ2oyvVx40h5YumpqoyVDc5UvvMIIT5fMryyN6DiXiQ
	 8gEpAwgTmCTO/TP9KWnZ8fuJb4L7z+bsnxpfQ1HEZ/QmZb5dhvFjJs1b7oj6JW3GPm
	 f7PxPS7t+RfAw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 401513808200;
	Thu, 12 Mar 2026 19:44:26 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1773328799.git.dsterba@suse.com>
References: <cover.1773328799.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1773328799.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc3-tag
X-PR-Tracked-Commit-Id: 0749cab6174dc035b1628fb6db03abf758cfda6f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e0b38d286eef4633d231859e47679772db07db07
Message-Id: <177334466483.523191.13784373197128151693.pr-tracker-bot@kernel.org>
Date: Thu, 12 Mar 2026 19:44:24 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 12 Mar 2026 16:42:09 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e0b38d286eef4633d231859e47679772db07db07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
