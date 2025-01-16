Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14C122D4EF;
	Thu, 16 Jan 2025 17:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047622; cv=none; b=N6ZRAG+4mjGWif+4OMq0baG1cBLbvQUqOC8SxVMnkImcksEnSXU9OHUh88y0hO2nRbLUC/7ug39sAEE3zSFZwHeLAhc4WXlk8X1MRFNYGBTVQIaOUHq7MFZaFISrHSS5nppdBY7CLhmnTrtMzATag2RealJSshiGhOKrQsgbYUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047622; c=relaxed/simple;
	bh=rIgjiU2WZ2ccEoGlK5NR3IlVGAKZrhx21XRLrNfXdp0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=e36mmL1+u4SLrSXXwahtCWox9fTRoWzhlE/C0wgojHNsTObtwaGNfwmmj7teQUYbAfBxk5Llsrq0KhuMzKlryxfTJfP422438vdS7TAnlhxMKAGUzYTzf2rRY7tJJOglKxbBO6UpNfhQqgbfkN9ZKR2e2QOk2kURb246EICDlmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftoZmCtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftoZmCtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4D3C4CED6;
	Thu, 16 Jan 2025 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737047621;
	bh=rIgjiU2WZ2ccEoGlK5NR3IlVGAKZrhx21XRLrNfXdp0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ftoZmCtOGHY3XZZ0ozD5XlKXeoFCBojxrhL16s4pBn7g8C5WKpYlApk1gOOSonq/7
	 KhNul95ucvt2tm+0ZnHV/EvzOxmWiz9YprYTPm3nFyonDB9CFDlXYZRCCynmB6Qrxb
	 9p2h43FOMJt6q1UsmnpFSEfEFKPRz7/up9gl5EvBQicA3B1ioHIUIc2/NjtnLEo6Am
	 W+KSDWvSL4kFw4Fl/B1lyWe5Y5j1vA7y3HaeWJZAEL0RjTl1ZcqsVTL/kNOjME5Yfz
	 voV9zgEE1tSDDVeMA96bocWzi1MXZKDp+4w1ApjDvbhzWVVHjdkuPBrWhbRkYtHipD
	 +xsTztTM7ftPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33B13380AA63;
	Thu, 16 Jan 2025 17:14:06 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fix for 6.13-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1737024972.git.dsterba@suse.com>
References: <cover.1737024972.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1737024972.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.13-rc7-tag
X-PR-Tracked-Commit-Id: fe4de594f7a2e9bc49407de60fbd20809fad4192
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ed8fd8d5dd4aa250e18152b80cbac24de7335488
Message-Id: <173704764469.1527932.17696800031686709235.pr-tracker-bot@kernel.org>
Date: Thu, 16 Jan 2025 17:14:04 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 16 Jan 2025 12:03:00 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.13-rc7-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ed8fd8d5dd4aa250e18152b80cbac24de7335488

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
