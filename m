Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E157336888;
	Tue, 21 Jul 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653619; cv=none; b=r/uU/xIajO7h5YeH21FErLanQ5rigW6gc7tEZsONK10/xj5rNEbOSEtIT1nRq4jSXZcCHOsgKjfSlNBj5OPRN4rucBqvrm9NgMXBmAFS03qtYkfJiqDvtadwIFPrACuAtukKgdKLhNT8O3ri4t7C88fgFP0BK3jJ2zmhYOaikD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653619; c=relaxed/simple;
	bh=RvSPRSBvyToszn2s/qejMz1z32W3EEisVoAL+w/kFRM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=C0rBLmQhXL9o/XPoUlhxx984HRL6ggdjBzh0XKrny5eK5FyxbpZzwESZhycLlBJKbwVhiukwvvdqmqszyr97bjtdgHdi7pvoL7IrsEHB1VmsFRTx0gGKGD3aXlE3QkjSh4PHrPrMRsp0F1KY5MXZ3enTzzEOcD1D7qD5De7h+9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NUH6xKZW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NUH6xKZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6B71F00A3A;
	Tue, 21 Jul 2026 17:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784653618;
	bh=5aCgYnwdJgVVrai2x4jIgHXzklkakfKP7TVv72PFBl0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=NUH6xKZWbHqGz2+b4zFz4hvLqwaW1UtqxKx0MKgzG7RzGi+z7ZkeQZMusn0edoKau
	 hxY5Uk5NI1gRhva+OPTdUjIOksNBCDLKrLf8wCZY8n3tCvz0NuleCh6j6vi2lLb3Yd
	 1kXAoHkVxVvstfxrVgnnqqh3EtvCmnfQG3Aupff2t8NLb3n6rCxPTrfidKNcNetSUH
	 l4P1lr7ParS1NEOhURDmHx15Rqk2z+LMBoSvTwHiRUdkYh21ASwKE5nK2sX0U/+1H0
	 +CuXGZdD2pOafFURExNyVoVd3miAOwrSGSekUBQWDcyVMvzVVh0cu4p/bXtjT5A/xa
	 69drEeHiw8IuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BA739253C4;
	Tue, 21 Jul 2026 17:06:28 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1784603168.git.dsterba@suse.com>
References: <cover.1784603168.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1784603168.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc4-tag
X-PR-Tracked-Commit-Id: 75a41e3e51eb0d6f7a4969c5056298c2aa3e85f2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51f247c4b293b470723e69a321e2cc5ecf9080db
Message-Id: <178465358737.846420.6446425543171336359.pr-tracker-bot@kernel.org>
Date: Tue, 21 Jul 2026 17:06:27 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 21 Jul 2026 06:28:05 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc4-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51f247c4b293b470723e69a321e2cc5ecf9080db

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
