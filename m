Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10114D90CD;
	Thu,  6 Aug 2026 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048358; cv=none; b=YTbE2iawcBHBe4HKSpFzIJy9pKWz9DtR7zPQu69/uq1/sJiVUUB9NOMObxlaTj2Ue51DFMbtJ4Wu2yhWl0jkooeehD5sU9JYPGq/Oaa1JwRQXVT0NIXkgzjA0v28I0MJZLg7Q2lwMRBPPsu1gAELcEEt5u/sYdtC6NOXjjoW5Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048358; c=relaxed/simple;
	bh=6NAhFGHvBoTS0R9+ZpakRdQFzU1uPEPxepFjjNvHirU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hANRUK4ccioYDABJYa3bEdugIb/HQqjhwQyKBkCvpbCNpIcPGoQu6FE2raHY05XdPzbWCyB++TqOWV3eP9OzbByMI4UDcUM0xkmbBLgHb5cXj/7PkVGv7Ua30QfU2ZycpZ/j+czS7jeXWqWPnOO0QPW1IIs+o9OZ+xPMm3lO7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jkhe8wn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jkhe8wn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58661F000E9;
	Thu,  6 Aug 2026 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048354;
	bh=W0380+76p8VTia6P+leZ1YN0y9Lpaxnc4sXWwpTISIo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=jkhe8wn1dr0HjBiCqnz1pR9zVOaB5yYx+z0o8svVJ5p+Hc1YEvfDfOILyhmcHJFn9
	 hZQTlVhxtWXBgj7WDAytxDieRc6F+8LDPC9O52S8Arhfx/RMARbjgIi8eEesaEk4xQ
	 TazK/m7YRzrfAs56F2ilGs4bdGsseex9xaYVXQ9+UHTh4yoHzUfhBy0C11vgAUCRvG
	 y5Vt/CYubbcpghYtJbBwO2uaMIj+aOoyWcF/d53RXXOEGh7SjTlekm3G8yqqSVJl1Z
	 DVOUnn0B7hHLfN1vIewta1TFznZDABJnz7CKJhASLqaIHEXbIkxUyMdvGr3o3TPpj+
	 OBaoJFLbu21Gg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1973A3809A85;
	Thu,  6 Aug 2026 20:31:55 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc7, part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1786044747.git.dsterba@suse.com>
References: <cover.1786044747.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1786044747.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-fixup-worker-tag
X-PR-Tracked-Commit-Id: ae2567b11c3df43861d05f856bdb3434b3961aa1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6c68fa601b49683ecb04eded993a71dfa8b2ba0b
Message-Id: <178604831361.1469677.8369117660899808898.pr-tracker-bot@kernel.org>
Date: Thu, 06 Aug 2026 20:31:53 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  6 Aug 2026 22:20:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-fixup-worker-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6c68fa601b49683ecb04eded993a71dfa8b2ba0b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
