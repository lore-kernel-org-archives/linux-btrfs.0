Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9D830C146;
	Sat, 19 Sep 2026 21:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789853464; cv=none; b=QXbiGE3KLb3qfOFPfgXqTcBu5w65GVvR+aQAQBuBedKlN2KOld7qfHM7KFeFeDQadiwKS2PMIWbzPQfpu/8uYpXo3kNRkfC9+QmNyqo17HfDex1/wAIdqWYQUGa2m3XYIDQ94uqfm9WQF5VSSZsjT9qaXRYqC7mHXkkaSshkzPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789853464; c=relaxed/simple;
	bh=PlkiBb3UxWDZx+EAsuQP4lTR2syQeY1IRXFV9Ip2r/4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CCHMzNKo6hYkUUtuxqtwjp7y3PYpb0NkMW4JsvioMIefpCPVBSt1YqKHCmJ50o+9SJ3CqFdkOxkJ8fKpEO4P47KOTSXMbc8bo9SWg6UvZrc6WI9ZH9ctMHY28a1oV01I2VQ5RfqupLfKxrFXQJOf2G+yu9jdEI+Vnml5dVFNfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uk2+DATm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uk2+DATm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAF11F000FF;
	Sat, 19 Sep 2026 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789853462;
	bh=Im2zR902PCCjrqqz4z8h90zb0tz3C6qwXBJ+xri+9EM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Uk2+DATmSpc2KXfPprE6c6Ju8yci5vZYV58jzhsw8vjyMYY94p7SD/f4zAic8pju3
	 W1mBolxFXnzJNQcms+Fdy4WB/nYPIkfnQkK37N+T2W/ojMxZB1VINWeMWhIskHobtI
	 KVXc5tE64y/nMyUKFGf+3bmz+qT5Xcv/5GLh1IZbk+0BXQWXWJoejnm0vXiFh/QKyf
	 uBbbq0mf7WuvJooMuIns2v4rsl7Q+j7B1DQ9XGn+hlHNcdvRSDdc+I+a8JmMtDAutX
	 hFdBI3mDnmq9OfmpsHZLOKo6sVMAZdUthMR6NdYIwVLUSRDeqkTbCq7rMyt8yVjTLv
	 XV+80/UE3/G2g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19C24392447A;
	Sat, 19 Sep 2026 21:29:56 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.3-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1789845496.git.dsterba@suse.com>
References: <cover.1789845496.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1789845496.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc3-tag
X-PR-Tracked-Commit-Id: 72de4807ba84da485dda1a91572d66da9149e95a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 518e5b794c06c0f0eb40df3e202274a66202c137
Message-Id: <178985339467.1467948.6679771484491521037.pr-tracker-bot@kernel.org>
Date: Sat, 19 Sep 2026 21:29:54 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 19 Sep 2026 21:44:31 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/518e5b794c06c0f0eb40df3e202274a66202c137

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
