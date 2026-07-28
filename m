Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E739DBF7;
	Tue, 28 Jul 2026 17:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785259662; cv=none; b=ATBuiwBRYNFAwB7Xmws5fZ2QaHHjcqk81nU6KkMDUO8lRykIuGgFhWPxUw8ytzGdb84YxK8AXrViw58OMaBtzhshSrVuTzTjH5XzJ8AhUpSiawqb0Aj8s5JxuHppGGFYMCm5Rwz1BCv/H4x/LeE+SaTm5N4yuvUyIugK0OtKlxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785259662; c=relaxed/simple;
	bh=ukIuRjJdGHkAnQenTwxN5Izhb0zFTwZ9Mx1P1PDBv6U=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Z5EPI5lZVjc6897hWSSxC5hjek4KN5I3hE+3F618qUMYdP5gCjn3sDy1odj+ETw2qt0/xaKseK+h8e6y3WNvI3aRhJ3nB39j3ksXYeOtrz00cdKkCtgQ9gNG2jhzSmVxMtxxYDcTdUjC6acNGcRmUopbcloYt9RUMMLcPKXxDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0XPvcrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0XPvcrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532481F000E9;
	Tue, 28 Jul 2026 17:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785259661;
	bh=nxUfvWkiZYIfwkAGFso1XOzkdlhF0Od4XTbQEzlK1Dw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=G0XPvcrLvDau7bSL9k2c0W8oysOR91xBAfNNBvYq7503agUt/O89ktLyGI1XbYwov
	 frQyQKaR3c+Ic3YghruREffGsfGD38njFDdCAefaE+UoK8GYPWY3N2Je1LyBBNL5i+
	 S5fIR+BCB7iJAO8DEKj00usfe2+565KuTTZvcADxvrIbmYzaK1xmNO610fnMDC89k7
	 cpWzNIWfN/Ce/R88Qv2CVsm75hwCLtmhr1+AwPwZzIaILdpS/hDeQaO/vjMy5txeDb
	 6KxZxEImumitAETPbMDQTpv74TVcSB0QAsJCll86+iz2Y/b4BN6u+Ip4dSaJZ2Q8zT
	 np2iZN17XEHNg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A753924462;
	Tue, 28 Jul 2026 17:27:07 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1785171953.git.dsterba@suse.com>
References: <cover.1785171953.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1785171953.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc5-tag
X-PR-Tracked-Commit-Id: c4c0673e4cb15b0c127e6d00732a2427bdd12c11
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3b5f4b83c4abc0c9b0a7b9e2b44e816611b7f2ec
Message-Id: <178525962593.1830982.8991390597028418475.pr-tracker-bot@kernel.org>
Date: Tue, 28 Jul 2026 17:27:05 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 28 Jul 2026 11:25:14 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc5-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3b5f4b83c4abc0c9b0a7b9e2b44e816611b7f2ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
