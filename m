Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F0E4C6C;
	Sun, 24 May 2026 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779581266; cv=none; b=KQLZ32qvsByf260qAZUMuGr0qlGiBzjdKvSvUYYO0QW8Ko/kFDMbYoJ08nYvlFxoOnllidnlQJ7xaZ+fIZzg1u03aSfaVLojQeSEgZWPgtoh9G9yVWvcu9N5zfS9+DHKcQXe7nHxgv3RH6thjJxzIO39GZYl20qLZ3FS1fmBP6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779581266; c=relaxed/simple;
	bh=oXHHcL2Z3BnHx1KbIZkGRlHn4+NR8rnioR2fzdYAqv0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=M1OZM/cc5KFP/w6KpY7dIE4nHquBx3VNOJn1dgw6ShrKFfxqXjucCbZiFhVmpLGt4xNAdR1cwOrtjckodFBxeHSfZo4mjIDAzoD5MRZiUZIgx9tKEIrgDpWXqQNQi+cjrr/N1BXp+8KTa22mGT7YMMxgUX0i60qdbL+NQdhx3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NIA+tMeQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NIA+tMeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0D31F000E9;
	Sun, 24 May 2026 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779581265;
	bh=P0tHrxTxmLu4KUMIkPXhxrTUMu8wEboTNhYts4Scb3s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NIA+tMeQRkBAwDpyXU1wrrvNOK8sI2LkieL62nQM3feQSv5KOotbKhYeOGuxC1d7m
	 GDXVI0KmfESVja2VqYzFzsi/uILL7yG1Ql5D1B0quaVK490VF2S+/YbnQBYsLlib1g
	 cXAilH8Zv401mpoks84JgL4CDp35g5ZeT7Dwr8++peS/Ae8ts5nicK+kJ+7PLh1MRK
	 NoEEDAy3qwEapQp+0dq6kB+UT7+U08rSkY1ibFMa5ttBL2RiOUu8J3EdefEDelDIys
	 g6fsTUTd5KDWwG0zi4QaPspaO8KyzeNYyqcMXxl0E/5+o7NglFkmzWoh5VmOHH1G0/
	 qoIz/fZ4ow6AA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19AD53808205;
	Sun, 24 May 2026 00:07:55 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.1-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1779547014.git.dsterba@suse.com>
References: <cover.1779547014.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1779547014.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc4-tag
X-PR-Tracked-Commit-Id: f13342e15deafb7538a7a8577ed5f4c33c56f64e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 400544639d2a11a9c1e276a912a9dff8fe4107dc
Message-Id: <177958127360.1680243.7089153514995149858.pr-tracker-bot@kernel.org>
Date: Sun, 24 May 2026 00:07:53 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sat, 23 May 2026 17:04:09 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/400544639d2a11a9c1e276a912a9dff8fe4107dc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
