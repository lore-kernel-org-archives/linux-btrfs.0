Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA47013A3ED;
	Mon, 16 Mar 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681384; cv=none; b=YMfxE1B03rWO1DaSGLjNpcQYEiUv1xDe+E5poFJXJncxmh5PP0LT7DVl5lcZujsc2XGKMd57ONirmFTWFYYoc2/HMhv4ZFMa1t77BCmLoToXD0DbcrkPoz7csrZDJkmAPsCjfgGbOaZNU4ZmhfbEFODYGdHiad3tn59BNNXDjFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681384; c=relaxed/simple;
	bh=uswzFpXCUpljAyw7SVEGntE9yo7pZSE9z8NyI2eO1aY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=X0tRh4PIgWGml5iOPr2D3/0i2ldfUO8QV613/bNGKqj7o1AQwqZG+EPV8lJqRujOU2W7m0mz3L+ULnC565bmLPTF7kRxLUrXHT2kBRAEdkZRXYVlgLAQujxZNCAJ8cnScKhWRgVy/35gjhug3mPshHG/LAsLdnQ/6bSfevhlDO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLuHFRJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLuHFRJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD543C19421;
	Mon, 16 Mar 2026 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773681383;
	bh=uswzFpXCUpljAyw7SVEGntE9yo7pZSE9z8NyI2eO1aY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JLuHFRJ0BUfGj7nUjgn6n9mn4OYOnbf6hp9DihHznin4a8WXCUUhbOIwZ1scfjGK1
	 BHHYaoclovvQ3kw2UvqRpKe4+vLGzwr8mcYZ9rXIIjRiC7BAL5XEgJmTsEjv3aVTnV
	 FmUwSNkWz5ETKKecIGqHBXaxBBWV1pkw9DuD9GyAkggUZdjbZCQhKUv9kF+RV2EsjN
	 ksjlQQyK/7RzULTr7u8PcMTO0ErkMlcJsk24INPqPvttwCPFx2py5U8t5sHuqyP//N
	 h9fwWZaL3tm2zSFhzRuyEAgvb4J0KvofG8NYORKSDnMbX/yFCV6aIxbu/u2kr+Rdw/
	 aPgahsjo1JHJg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02F683808200;
	Mon, 16 Mar 2026 17:16:18 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1773665572.git.dsterba@suse.com>
References: <cover.1773665572.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1773665572.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag
X-PR-Tracked-Commit-Id: fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2d1373e4246da3b58e1df058374ed6b101804e07
Message-Id: <177368137664.2764283.10138397123345097023.pr-tracker-bot@kernel.org>
Date: Mon, 16 Mar 2026 17:16:16 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 16 Mar 2026 14:04:13 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2d1373e4246da3b58e1df058374ed6b101804e07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
