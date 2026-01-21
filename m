Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C403837E2E6;
	Wed, 21 Jan 2026 18:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019697; cv=none; b=RBTy+hr4OKFvRgnKS4YZRxT2BBrb0depoSAeBnvJnUY1Gkama1jgtMpdiapJk+xJ00YAVsER2N1TYG+0GIlt1N+KMxemjRh1SfbzS0LtAlBKTAjahg7Qd4+1n3coKr4J4LTN5ZPxpGPirK5Ep1vmaR8CzeEYF6fH2ZBmJ4rg1QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019697; c=relaxed/simple;
	bh=0/oTLvIS6X78ZnthKCFsMcFf8ezdebr7fSXjGvxuhkA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JX6+TWCvm0kkOwW/YfhHIFsr797JVowpacSi3xJs+RReBEobga+DJGH8fzZbCz6I1iK0AFRdBd2xQIRAMJNkYD5ZFmVTcFiHRkI2C1k52s4NAsQztZ801Ehrdn+PxsHVrv1LiGOczDdZvjI+R9w41AdgTDRx6tAoL1P0qvk15iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V83KbcBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V83KbcBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE7EC4CEF1;
	Wed, 21 Jan 2026 18:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769019697;
	bh=0/oTLvIS6X78ZnthKCFsMcFf8ezdebr7fSXjGvxuhkA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=V83KbcBkmGYvltt1QM/9kr0m6fFBkJYFbU1bkB3W82HgMuzLxjYLWUCa25IA+m535
	 lYvTLJsDb9J9gTRrfX5CLzbVzqBhpqVBGCLAK7oTrHmGyM0ss4kFrLIHfFSpAJ4vba
	 wK2t1or6z1+WoasguHgI+ky4v8ICgphUNLlRpynfUL4pGfAoPLhEyjRx8nhO3QfJcf
	 BxleqwLHlZsPWfRX/zKUsFDP9isqD4PSfK67pckJ6bp3qdjL1ATb08O+xsoNarnQZ/
	 fulBn1LdJCM2YHI1tO4+aelDkvz0jv+mdYung9/tLbCoHEVueth90eqYAPHZdhGP9G
	 JRCLhJX5tXXZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C8E063808200;
	Wed, 21 Jan 2026 18:21:35 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1768969871.git.dsterba@suse.com>
References: <cover.1768969871.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1768969871.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.19-rc6-tag
X-PR-Tracked-Commit-Id: 34308187395ff01f2d54007eb8b222f843bdf445
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 07eebd934c9cb9f12f589ea5b826fa7ca056cb4d
Message-Id: <176901969429.1402269.10352506048533771133.pr-tracker-bot@kernel.org>
Date: Wed, 21 Jan 2026 18:21:34 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 21 Jan 2026 06:56:59 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.19-rc6-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/07eebd934c9cb9f12f589ea5b826fa7ca056cb4d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
