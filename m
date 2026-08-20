Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483C53D8128;
	Thu, 20 Aug 2026 20:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787258648; cv=none; b=O3L+ecJOqABslshHwLieQQgnG7NpdyrOBmy8KzXI7LQeQYFBu+Ice7hnLSXETjZt9suWUkMkcuJQJSWaxTJlT7fcvsmsY590aiLQL8fN2ul93jgNkMfqN/+E776weqqOIs0W5bBuyxOC8TATvK4mHcBqgmN32E8LIjSv+pa1Zb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787258648; c=relaxed/simple;
	bh=A2bgmjW9bL0LwBdl66Pbd6LsMOJ3WPuTRnOt32gusK8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FxFFg/CVY/EGzZWRRgS8UVqN78/A85hFJgSdef1cAMxhRO4b1kOuPszQleqWB3MciKrKTcatPddwOOm1avZa0sAzOVJGl8XwcYzxPcUuPTeJW+1sVu+7Pgrr45xhIQTWNji8Kc8ohvSfJ3JjxUC775jOF+jhi/lSJ37ymWhFxTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnUpbrtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnUpbrtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD9D1F000E9;
	Thu, 20 Aug 2026 20:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787258647;
	bh=F0GgOCXh2QnV0tCmLlZbwnsMZzgsYMz7RVtEtyQiMDk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=DnUpbrtRCeSJeSl8Ah7GLDYtrzp1e1Rm7FXPKhbbctvgKkRLpLVPQJrUGMR7BL9FG
	 zHWpBC+Xi2WBd4oq7OMF27D6oWIsjYt2xQdx9DIXAMUwgo16KwCUyOaKBfXVbUOqmD
	 dRrPMlJN+V8k4sUPRStfaXiLqqGm9GHdTNUevtssaGBDLrMGdT3ks+smjOKMW7l8Va
	 N4Jcr7cXlED34ltL9x+RSYsl72EZjQR8svpszOJBLevOHqbuNtugZ6ENml5Wx+f0YV
	 Q1Is8B4QQgB8jy1TGADB8Se4vYqWmgszxNiij5INo+w6yDYjNpAqTwzSiTwFjzfeTV
	 zlsuHYAHUjAiw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93D8E392445E;
	Thu, 20 Aug 2026 20:43:18 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1787152457.git.dsterba@suse.com>
References: <cover.1787152457.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1787152457.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-tag
X-PR-Tracked-Commit-Id: 4096e2a06f43fae209d6472d395f3219e02ab2e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50c44fea13ec339d0d457079b254e8c8420d6511
Message-Id: <178725859713.477132.6177549497884119127.pr-tracker-bot@kernel.org>
Date: Thu, 20 Aug 2026 20:43:17 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 19 Aug 2026 18:50:10 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50c44fea13ec339d0d457079b254e8c8420d6511

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
