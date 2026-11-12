Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794518651;
	b=jQ5n120oNb5UYqruzpaR66GutGqUx4KCa1liZkWSTdQ38gpUtg/sPXaY16gpQjnghf3b
	 RsAPQDl3TLCdyM/v2nM3lYIakfkZAFoYaRDup9x0O3/Jjz8AhMPFK4KFc7y7bxnZYlR3d
	 kotRFQfwIHEA4s7/J4wQFHKcxtJolf/8mVXZM3XFaexjo1uu/yViMyjzBDTSlPSFeNM9M
	 yMP3IoF95Mjgo4E05VYve610wU11lUqXYOrSVTAYVAo3TlZPeB6fvlRCaeDGxEkfwW4EL
	 XGlDRjG0Nj2C/3sCyuCoX+oLcYtDAXYoWuMC8IylnZ8C8KEJ0EYyZPoDazy32GkmmbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794518651;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=HEF0xcm9Wf1kqsPsq1QLRo7lfasxMA/6lEpzmVjqXb8=;
	b=KHhOPhNSzd5LDvfijzYkAA27rlSW+y83LmHA0eiBqH3oYRNZtsOBQWZYdRaIS+vH7Hc/
	 NvtPBqqAjQr2CRxCBm+9HzySDQfnkJAZ6+JqvzYS8eb6e0Yk1Vy3dl0nkR49JBClVHs+1
	 Xx3haGQvDuECHxqAmZSOv9B6W2TQSSk20omWs+4VKvnD3cfge2l7Rw8QszQeuUCUCsSaO
	 3i+r+YcnF6klZpGt9tJQHiEGlmZe5MU4ggGpNR+/HPL68S24XoElIahlbC0qBMjFddH1S
	 bdbI/A4h6IwcT6A7+SEaSlYpBbl7ta4jV4mcNBpZkYATEArlye0dZZuN/n8RsFWLbAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fySbS7ax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3789606A33A;
	Thu, 12 Nov 2026 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fySbS7ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E9F1F000C4;
	Thu, 12 Nov 2026 21:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794518651;
	bh=HEF0xcm9Wf1kqsPsq1QLRo7lfasxMA/6lEpzmVjqXb8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fySbS7axKibqhjdf9UdwgIcwW/dxDYA7QE66ckSTixqK52tohDNSvB7UbWjWqjb2P
	 egCg5bscHdcRn6F9UO03Nh/AQTgWMrPMYd78j96FSme7Ooc3DJH9IbBxxjG/YykaqP
	 7KmluUFbQXh71Opfor9Ud9XVPM83EEkeE5ZsCv1uu+n9zISbh8xzn9zbvbqObhPLWG
	 vVDx1sPf20ibLMdyu026ZEDJnzFIMD3mmhw5IVHNPuMXPq2nz6awUt3Dyk2Go7TtKC
	 y3pX0mhhiAPKGR/9zOzQf9Bc0Tb2PDaJ/ajdbbqgcFijnPxNxrY8EO8jo0gwdHdZLx
	 3S6uoobkG1wog==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77645392626A;
	Thu, 12 Nov 2026 21:24:11 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1794506624.git.dsterba@suse.com>
References: <cover.1794506624.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1794506624.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc2-tag
X-PR-Tracked-Commit-Id: d27d0039bc1334be8a72c769e14c0b0c3efc317d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3e7c23ec3d004de154dc85d3ddeae0feff4159d
Message-Id: <179451865014.654083.8523188552672362972.pr-tracker-bot@kernel.org>
Date: Thu, 12 Nov 2026 21:24:10 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Thu, 12 Nov 2026 19:08:57 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3e7c23ec3d004de154dc85d3ddeae0feff4159d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
