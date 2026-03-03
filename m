Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4531A682A;
	Tue,  3 Mar 2026 22:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772577110; cv=none; b=XYiScNoKWWlplYaWHvNqFy682Xcyg2h3l22rZ3FN9TwhfzvjSa/Rf47Q5Wfid8YIgSBR1sgbz5H6M/ufxQcYyzNMVW8gxaIijbaDdIwEM3tdbgXDTQE5LSkCAKtPpwgiiAlDYnzkrpRJyh3kngIUq0s66fJofo0sFpTZ3yGqYPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772577110; c=relaxed/simple;
	bh=dT4uqZ6noGh/dtZBTWHITABvKkZJVo69w3xmNwf1sF0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fY1r0HSfFvizanvAE7g7AstzgW64n1kGv+8MyDedsO7pkK2JzJv60s3hmqK9nOJ7MK6KOXk6k6Zji3qK069oA1HcBum8ZyV5DYOMOIjoH2Y5Ar0IjgiGp5bpix8RgdvPtFUJ/ViG6cS10MRO22AbMX8zHfU8C2+ZIhmaPEkWN/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiImTRxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiImTRxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8E8C116C6;
	Tue,  3 Mar 2026 22:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772577110;
	bh=dT4uqZ6noGh/dtZBTWHITABvKkZJVo69w3xmNwf1sF0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=TiImTRxtm9U3x++ooae9INh1rygyEHb0KzWiWShHMCVxPn7g3T6cn7JHz+aOoai3u
	 r4cyTPbRmfp7337LsyMXcN9a3PGi+PP8Du7AEWaNr0uJvUX9/+7rI7smVxoYQeevZQ
	 c2RMpRxCLcMnaXj5j998V4FEebEemYU5bWkZ1bpqF7m8eJXmp7ZEdqMn1dy0u3tdQT
	 ZSA8LCMAvJ58qBb8IJDd5ihSjpimuU18rhTtn42LFA3fVLdyuob7PMUhU3Mg23kfAk
	 HDWowgcFIt/EsavukVvaV3dBrJk5qz2akPgWNqpAT4XI4pWLY9RU4k6Ee7gxW6IAW/
	 PvL/kZ2EgL8vw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0533808200;
	Tue,  3 Mar 2026 22:31:52 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1772547600.git.dsterba@suse.com>
References: <cover.1772547600.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1772547600.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc2-tag
X-PR-Tracked-Commit-Id: f8db8009ea65297dba7786668d4561f6dbd99678
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c44db6c820140ffbc0e293a34c6a6de4b363422b
Message-Id: <177257711139.1500124.16835770675280199716.pr-tracker-bot@kernel.org>
Date: Tue, 03 Mar 2026 22:31:51 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue,  3 Mar 2026 15:53:08 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c44db6c820140ffbc0e293a34c6a6de4b363422b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
