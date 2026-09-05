Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7604EC640;
	Sat,  5 Sep 2026 18:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633682; cv=none; b=VC9eiVc93xUUn+PixCaXzDvffC/tf1xLRYUZTyRS71EMqivcPgFiZEMwlllt9sfKh1PD0G36C6T0M7eckoVwpP+3+prL0A5vopAxUXpDO2LRBSusWGe9NMrSDN/lMrKEW3jGKR5LMIe/KzXKkhCdIFxKTjmQnZMItwUwvQhS3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633682; c=relaxed/simple;
	bh=tuMlbACYg9I9OU3KoRxBRt8Qyj4+wRdAjF1UheerqY4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qcoShRVVlTHTGDqBtnErZUo5OKJielzIBaoapJaVW1Zw61vVFrgggb6IjRIOh6GaEz3FeRIf+OTY56vWquGf9IfrkUmN5keRPYoHAXEgVZ+wPsv3/KhZJ0QOQtP5y9z57vlNGeD6KXFd4TdxTQCrCf4+JP2FO7RCcP2/m677ukY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVl45+Yb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVl45+Yb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48151F00A3F;
	Sat,  5 Sep 2026 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788633680;
	bh=9REe35dVf82WuQBTgzZgBG6ksXyimXPJvLH/qcMvrJg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=DVl45+Yb5Kh9E0NEGoMvfd8bC+61dL6ZtJkfL2w6hWhwhwbBvc+GFSblciuXx0caw
	 GoEDDOMMw7uCRR7qF/9kIy98aywK03mCc/+lqLIbtOhvwjCf6Y40W6Gtf4w/FBn9dC
	 hqCgj4Jg98LOGUIAHzzvdUrcppE+dc3K6sXk86IIZk1mrGWVIf3nxL37YIjdaAU9Y6
	 dpSJlX3cHumxbtD3HpgZT3iIW949DSRE2CPsRbpyxyiLVfY0cj/nJLMRIiVxUmlOHC
	 Hm2Qdu/QORQzyyChnExRvhnfXTMZDGYLDWOlSFzQS2s450A2NBfsPumi+LdPHqArMa
	 8DtdlCXjdgZGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56FA73924FED;
	Sat,  5 Sep 2026 18:40:22 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1788623834.git.dsterba@suse.com>
References: <cover.1788623834.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1788623834.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc1-tag
X-PR-Tracked-Commit-Id: 6a7a45b1d94799a5eb8e6d26e65cf31a3fcda9e5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d9d80a859bc45ca022abc13afdd11d1c812a1034
Message-Id: <178863362079.1317773.5405486663219712509.pr-tracker-bot@kernel.org>
Date: Sat, 05 Sep 2026 18:40:20 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat,  5 Sep 2026 18:25:01 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d9d80a859bc45ca022abc13afdd11d1c812a1034

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
