Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7677C1D8E01;
	Sat, 21 Mar 2026 17:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774115149; cv=none; b=hkbqTLZ7l1ziTVJY3xbULFDPE8sT3Ke3QlRjU4elNVIZtu9T7nKAoHEq21VYW0P/SpcQPY4oWMkqh0t69+iBh+e9MZ4Nrg+8cRI7LiR/Gi4yp98DB4gK1mYfxaM82HZ3RvsX4zdfMSZr+rhlhJdYXH6eWoWp9Sx2+OAgcorCjtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774115149; c=relaxed/simple;
	bh=HCipJeoqu2+oLbJk3o6jFsR2nO/S6OU+boTyj97vSLo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FPGYuIwZmlFIMYVH20O285PcR6jLhur96wpRo/1mYZbHYncjqbQ7kBKb/mea8096KD+ZvUDa03cUxnpSKiT+j4cuXX7KlslXmrW7f57e424mhUN8ULmQ8eV6prJQl5TZ4JGykpDqSGog2AhBjqGPmkyEH5WeoQhkx2i0yqmsTxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bD9FdMfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bD9FdMfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C301C19421;
	Sat, 21 Mar 2026 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774115149;
	bh=HCipJeoqu2+oLbJk3o6jFsR2nO/S6OU+boTyj97vSLo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bD9FdMfZKGI9VrMvWgWRo8vVm/om2QI674Z9MIb/PgyX7VC6pFPJyB6ycmO+1jFLy
	 a7SsY0RpjM5ymXNOhaP+7tBHjux7kKkkyfpjkLFr1GeWHkVNctYgptkLzhdCVbfKk0
	 K7LyytqrO30H1xE6z7CsKCyoqOvA/i5V27nhOaV/sd+3tMkZAZmMisqZJzhtzO9WvB
	 XRMbym+e141+6l3lvfkt7fsUVM5tBiIkD5uyMnTBwxL7rLyTuVKCHwPuvVRA0T7ab9
	 j1rcHZ17GDV63wUuRn286PulH9GX5rXepnmRasLMxd/z9B1MiyG79Ks8oqM8WL0Nhw
	 x2XgnNdcxpgdA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FFE13808200;
	Sat, 21 Mar 2026 17:45:40 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc5, part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1774096729.git.dsterba@suse.com>
References: <cover.1774096729.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1774096729.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag
X-PR-Tracked-Commit-Id: b17b79ff896305fd74980a5f72afec370ee88ca4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8991448e56cb2118b561eeda193af53b4ff6b632
Message-Id: <177411513878.2921174.9720640532305683781.pr-tracker-bot@kernel.org>
Date: Sat, 21 Mar 2026 17:45:38 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 21 Mar 2026 14:00:50 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8991448e56cb2118b561eeda193af53b4ff6b632

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
