Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12FB156661;
	Tue, 14 Apr 2026 00:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126619; cv=none; b=bpc1xuWrOWg8PathWXYgyYfOLC+rdeTV1yM6aQIvL6i6vsJ45HYXiTdmQaQF00qXH6Jbg3Ai7cbxyuYw0W6hJZAJpekAkbvdG93XfqcZtyA46XAxxn7Ytxhf0vhPnw8Pl5Ght66ugH5Ft/A8AednNCsUU58dX0c7i2NIVjWz264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126619; c=relaxed/simple;
	bh=hrQUoCSwSrIq6lheOdXdqQwGtO9pAQXk896Hpxo8lew=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=pmCPE6WHTk4gh31S3axnb/IQxvTFReT8KaEzjHNWCy7LwCrIc8fPI1OBn4Av8ZSXWX0c7w402X/H2czXgSdDNdKlCsPENXJN0mBblE1As1OqDZdgvcBfZFj2KE213eRgs4JZjKQ9EDND6QABF8YsJebVxcmGYueLBacfjPjH9qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oG7eea1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oG7eea1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D728CC2BCAF;
	Tue, 14 Apr 2026 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126618;
	bh=hrQUoCSwSrIq6lheOdXdqQwGtO9pAQXk896Hpxo8lew=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=oG7eea1Ap7zRCmg0Pcm5nTrPoYQ8XHEkP8N34BMzIMCdUZFFBPXQxRcHr2tXjPxH4
	 hzKDV5Q6mXAwCCR/ZfUCq3ZuTCvj1wMlYSKUMZ1xxwFYlTaJjd2GILYvWOwIiugD6o
	 INK51bp7jmhvDwdP9Yk+2oZLo+xOCN7d9+M5fvHhMv1GSDVkhr9YSUYB0A+ATmhRJ7
	 NmDP88LCyDTZDaWzIIaJrhPz9qZROoezm43rxP+4SewjZH8gcbWkJcyxJFKsv2QcyQ
	 4RSuo9afcZi1J5ODrBtcff1Zt+TWjJCPx9vGZSQjB3oup9TIr8rzRz557LrWeEjmA0
	 wr0e2QP5UeDzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDB53809A0B;
	Tue, 14 Apr 2026 00:29:51 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs updates for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1775782425.git.dsterba@suse.com>
References: <cover.1775782425.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1775782425.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-tag
X-PR-Tracked-Commit-Id: fc3d53288158d68444eed059adb734709b855bbf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c92b4d3dd59f9f71ac34b42d4603d2323a499ab0
Message-Id: <177612658971.618768.5677088186675347501.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:29:49 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 10 Apr 2026 03:15:45 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c92b4d3dd59f9f71ac34b42d4603d2323a499ab0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
