Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E1D1A28D;
	Mon, 23 Sep 2024 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727118391; cv=none; b=G814+rIKXkwqmG5rPK5DCXmMAxlAnlijZ/AJvFYPeCX0ClX9iI2rBVxOc0nqPYHoQ1QmiVvnhh8t9CPA6V9xjTzMuTQyQTSPvpWzgtv0ZUnwZzdGrmVGCEYg+6+7kUWAD7V+C50Ll2lboJhze98SNRVRZAmvP548tvbueKjfvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727118391; c=relaxed/simple;
	bh=EY4MOMdUU/CRLfaeZ+xJnJHrnZT4k1CgfqkwQQP979I=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=WNlaZnChi5yeH70dBFFiT7R7t/q5PmGO2YwIwgPhmJ0SWHMULwqGxcN+OdHnt+MjusH4iBrYePKj6NXwx/LPz9DP09DseQGam15tLwabylsDRO/UaSUBpMEteZCJgHnsC/ZK7ZCOIU3STIxYZZLh+4lj0t4N0dkCojmI1SQLhY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sauu8xv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sauu8xv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D158C4CEC4;
	Mon, 23 Sep 2024 19:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727118391;
	bh=EY4MOMdUU/CRLfaeZ+xJnJHrnZT4k1CgfqkwQQP979I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Sauu8xv+VpRGiy8ercEn0VqRvvYK2NiA+2LBVLHmu3s2sWEJQjQD7bpYdvcoMY9w5
	 I/4h4tKT0raK80j0CZYK/XneIVe4zJMsHP2Yuva106ibLkAEF7HLrmQ4Xhxsyx9J4R
	 gMLEx1iLP+/B8iz/qQY34AYVVL32YIdjV1+8+JZKO8R7Ld0OgBTcxIj9eX3TYPhmyq
	 wuLCLa0jI2+uKn8MCJaWiqz2C92JdU5XvMj4jLbRKjypav+XXfE5RaHhJkUFAeNtHy
	 ZA3N87SpvXiuQts9QCw7EQtsVtJnh2a4XhbgcTxkVAljopH5O/6p3nR+kj5ld9TPf7
	 vinVKC3ikZjTA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD723809A8F;
	Mon, 23 Sep 2024 19:06:34 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 6.12, part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1727091859.git.dsterba@suse.com>
References: <cover.1727091859.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1727091859.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.12-tag
X-PR-Tracked-Commit-Id: 7f1b63f981b8284c6d8238cb49b5cb156d9a833e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1fb2fcbb60650621a7e3238629a8bfb94147b8e
Message-Id: <172711839348.3454481.2408513667156887286.pr-tracker-bot@kernel.org>
Date: Mon, 23 Sep 2024 19:06:33 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 23 Sep 2024 13:52:06 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.12-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1fb2fcbb60650621a7e3238629a8bfb94147b8e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
