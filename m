Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300CA3D4123;
	Thu,  6 Aug 2026 20:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048354; cv=none; b=Vensup6enKaFUezR99DQHoiZlpvyWFyE51MN4F9paQuNHhaGAlaXOFN+3z8Mpu8GHfIQpruRS9REFEdz51qQRXB+1B1f7LDZU58YC+cQZEIr1wJ9IJoitFDoNuMnnCLM69oV/VR6v3A5xCtbH+cllXU0TM5xFElRy0ZZTXWpyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048354; c=relaxed/simple;
	bh=b31mFWE950rGbvXUp1vHDMu3z8bDzRSSIz8e4VvwW80=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=aa2Ie/5597AsOXUdhBINygFPn6TZdDDI8U4RrQ8/GrCJ2yx415SuBGDwdQKOwIEhBc9CJxtsG0gURfYVDVZPwu9wcUUnNZpfcJTSvhXs9iIOBq6LOHrhZngEAvw03+dmYfRizbkNhreeNZMWt/grO7nn3zJHr7J++tqE9KjSKfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VJIVvIS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJIVvIS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C71F00A3A;
	Thu,  6 Aug 2026 20:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048353;
	bh=J64xwMll7NHdtkXzLOpp/vkcE/+bM+s1Dus0F3FgHQA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=VJIVvIS64OTbyDH+cCuuJkZw+ZJ2ZD0udJcnHSRpS/stDLPQeR715ZLlsPN7miEX7
	 8QTVhDRuAMZ8J9/9mFiQ6FmTJcq6qTbT02wdZbkfqfLjjDXH0xVQfgNp7ybDutPYpB
	 ek0vf0R6O458ddeJmf3eizPrk/8HzJrlFedhlztct/rUguRVPSx7eAyeH+5PQF6jbR
	 hJ4ZRsdfSZ+ku6Gg3O+jpE0Uu425kEMREgfrHaOa7JeU1VYgJQRJkgSvCyI2Sh7Vek
	 6tJdM9mI+9O8PuoL+1K94tRl5yyq85Mx0WKao7iX8+OygKOwvaDUEe9Fh9iwNlGkzO
	 87BqVyMCxencQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7C9123809A85;
	Thu,  6 Aug 2026 20:31:53 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc7, part 1
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1786042395.git.dsterba@suse.com>
References: <cover.1786042395.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1786042395.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-tag
X-PR-Tracked-Commit-Id: 0ef349734a93227b45f65fc50a3311d1cc5f03e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 63354634885c8d41675c5af54f757db2d14326e6
Message-Id: <178604831234.1469677.78421195660592694.pr-tracker-bot@kernel.org>
Date: Thu, 06 Aug 2026 20:31:52 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  6 Aug 2026 21:13:29 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/63354634885c8d41675c5af54f757db2d14326e6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
