Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795666638;
	b=MBpD4FISVB7Xr73LiHw1dB3U7c0BjgC4HcEWFPGX2VHhDcVSCQrZ5LOjbjHjbkhtrBI0
	 hYnrZZGjIT2a+z+1wrcatpySLzmgVBT9ii7I+gBhktWWkN3DgwQIzaV5i+2j15ORl72AD
	 6GScB/Blydxjo3amZSLTmRMH409D1eanOSrL/KruJPqDx7m0BBMGyLae5ye1BgmvZtIxk
	 N09wEmUPUXvO1OVYbHiq8W8GPsYehX/JFDVbIa4+Kt7161WhdyTkHfTaiwCUlv38O72I6
	 UmqvEFiFNR4oaY9MnLSfYcQah6ScLw3GLR4ni7VEakMCPB8VfS0imaByf5/Rzwk6LWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795666638;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=Nxr8ybLNFTNsenZOk7Ln0OiGd8U9XanZ19c7dvRP6xg=;
	b=d8P6hM8j8oGXqIN4xaGSa98JszZ5609Z5JTpeU5r48xAsC5ETbYEp0brrsuaGwUTx+ud
	 wcdc7MIIiNVVmZmaHy0XQ1dwBLzPFJj8sUU/DlCE99V34zVBsFboA5IFFfv7Jyy4rijhe
	 eqHr8vzOL6NOUlatBVwv75jx6xlzoUSZi74L5joMrcvs17Nh982b+/1k+OL32Y7+2Em2I
	 +XCvzJuucWCi+L9281TapDZQAFrBHilphiFKOrTMo4OH9hywZYfxk6yUGfH58lr5yJHDw
	 SCEVMCR0+SfqW4qH0KOG5ohXBrabjv77CRN1aYodyOudwKGg0yYhT1AHi9gTrnBquyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fPyDBsCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663A3606A31C;
	Thu, 26 Nov 2026 04:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fPyDBsCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431841F000C4;
	Thu, 26 Nov 2026 04:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795666638;
	bh=Nxr8ybLNFTNsenZOk7Ln0OiGd8U9XanZ19c7dvRP6xg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fPyDBsCyy8itAANzPHK20Mb2SJFosf5oD0fynTsCeIIdupXKBk0GSYwPOlcilJN/e
	 ISNhCkXFloWVqw0cnBS9i00PhtX9fiCHf8Hr8JiM+Gdfno+zlseXCa9Yr4GjzJGWMp
	 z6QekCPhJvgEmsXZCBtKUW7feYCfTa4PQHlQ250dwUv2N6hBs93IjP8BczEDL3UOyR
	 dWva2ij44/gpFIR+ULSXOFu3xlD0vN/8HoYDc+87c9zcvjNZTxQiyU2hoCVJCTEtzS
	 C8a6SqCCAoctfqFm/kcONwEDLRXlwX0wGwPeOccPlNtWkAt+M4HG+2Eb0BQqqwB8oQ
	 PVPZatZtccSMg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4123809A34;
	Thu, 26 Nov 2026 04:17:18 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.4-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1795641319.git.dsterba@suse.com>
References: <cover.1795641319.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1795641319.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc4-tag
X-PR-Tracked-Commit-Id: 3100f46985fd14148e79a0e79912180934ef7231
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40212b29a6f718d4e7fb3275cede181cb8e137cf
Message-Id: <179566663683.1492115.2008810245067918087.pr-tracker-bot@kernel.org>
Date: Thu, 26 Nov 2026 04:17:16 +0000
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

The pull request you sent on Thu, 26 Nov 2026 02:46:16 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40212b29a6f718d4e7fb3275cede181cb8e137cf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
