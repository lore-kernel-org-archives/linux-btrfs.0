Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792981202;
	b=ra8IsU08i5tJf+pJ5bANp6A/zTQIe8ESEH3Kv14R2+/XP6ACKcIFjgPPLhbpJrPeKg5h
	 zAOVtY05HGndds/g/EF1UtAdykzsZN56Oss2mztmIwSUKHyRkvYVRIhGwf7+BmIBiE6eW
	 V0wNEuYizw0eRFlzVlK+yErgYi5nsKZXFBq38fbzuMz49KvEvDOzefBILoB3cS2fmpx1Q
	 4wfTvHIwEJJ7lBA7fscCvoG41AYceio62jR/dxW2gZZuZrHIUm972eflaKT18FiwiPStI
	 bgXqYbsLB715fKnN5ezabG4/SARKOppeLE3RWN3PGLKdAAou1HO6uI84GxsPjoIABgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792981202;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=eRNzVYgocIn8sTNIuFg77xHivEvvyreG23FGwazPaBA=;
	b=PUabRbuWCMsud2hjmNemk6u/HRFK+llaJZI2/46A/9GIq6cwHMxwnHcpuIaPo7zK6wYt
	 7PHVqYM8dt0Hnr6KqnP02LnWyv68MvYHbt95v+coSZqesbL5kNM2BkDJpAd/8m4pI5F1s
	 j0jfzVW2M1/7FnU+NhWrYCFU30Yn9Bs4OXxMOc0gFutLx/rDkgG1SLvgqCSYHMIxIFTOx
	 YJgVL+vVcawYtbqRchRBX4JZtg+CCQeUegICKHgcFvGo2/lvkCRRKakg6vHeqKMMBbzf8
	 2eA3V3cAw5TlMKjbU6fSn4B334ZuPn8dB6EvMhkXsF7ImFFgofUVTw7yqfywfzJrFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8vdgC2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D78606A31A;
	Mon, 26 Oct 2026 02:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8vdgC2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCB61F01825;
	Mon, 26 Oct 2026 02:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792981201;
	bh=eRNzVYgocIn8sTNIuFg77xHivEvvyreG23FGwazPaBA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=J8vdgC2Ow+Za8yl2v+uMElrVyLlRWUx+Ozgfe16oq1tPQw5YmgQH44MEIybix9hQ5
	 Z9SSLa8xe3ThSOgKIWKmeNhWWYF+Ti47SvwZZAaQyqJkd0n0oIml0wVGgSfgkoK/RL
	 xaq40zDg3+7LiDxo+I4Zd4OVfTKe2NVFlz6jNvUADI8TgjR7RIpW6kx2Yp7Nk79rwf
	 uPEzENuys90KLZAhMzxLYTrFTeOHmxZ1nWz8P5Oa1h4Xe64GBiQ6hMkg+35NEsKcQL
	 zMt3svbvBvA37/A/dpLdNtCiOK98tkanc8SJJiti0ONJ8lHbBjJf5s2BBYvcNSUJxb
	 feFdgMQSGsirA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 816ED39EA760;
	Mon, 26 Oct 2026 02:20:01 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 7.4, part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1792947250.git.dsterba@suse.com>
References: <cover.1792947250.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1792947250.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-part2-tag
X-PR-Tracked-Commit-Id: 293aae0123e1c178c7f76fd7a93bcced41e6663c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 390febb5805d3bb830402679f277f1d5f309e6bc
Message-Id: <179298119998.2366534.1669726155900482907.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 02:19:59 +0000
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

The pull request you sent on Sun, 25 Oct 2026 18:03:33 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-part2-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/390febb5805d3bb830402679f277f1d5f309e6bc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
