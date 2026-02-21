Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CD2324B09;
	Sat, 21 Feb 2026 01:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771636842; cv=none; b=D8T4pvFsUTADKM+HynrQUBeNgigf5OGzdyiVV/pLzNy6wuCpJk4qGFQkdy9thjItdEgpUP8UwGf3Tn3Yr+Yqw6X5yrqDKaAHzkHq+iMW8RwkUegj8BRg/gdwRLIHylMHO/kSZForYsGl6WMVU8l2DX37awNsNHbeQx4/6EULFkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771636842; c=relaxed/simple;
	bh=cEacp4oH0oUq7bhH9a/JdFyiSTbN7Fv1iaph87di5eo=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jc2l0Xx+46htE2WQgSNmhWChtYBd0EV+zih1CAMVQCrQKZ1G4jUMK4FyDXS0Tk2Jbg43odDJhzBbPBtWGnsZSIyImob9Z9rJW/DqKIzPtZNKfxIWySGbYP08gtguzP/nD7293Ol55g6YCyl6yDNdqxCSDDcNpcK1PjdlF1L7ZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1PmOlop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1PmOlop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978EEC116D0;
	Sat, 21 Feb 2026 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771636842;
	bh=cEacp4oH0oUq7bhH9a/JdFyiSTbN7Fv1iaph87di5eo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=J1PmOlopRDWbl3SaQ/jRjEJuEcIlURcJTREji7WrCg5/DpIPtfcc+tliLs5tfO7Bj
	 EjidHwrnPAJvg+A8dmNcflThq6Im4SD7DGjMa+DnovMTNua2q5P7KOUhu4lVYJpIKQ
	 B63XCBtS3Q0m7fpDEsTd4pgZ2l9t9V+C+iHu4P3kH+L61EE2CpDgXcDL/OVoMDvfga
	 GkipsdxbVG7JJCeGEJ//luwVENqzrPccvNv0ExZoYWfhYrJ6bl6twZnrPzhkORlN8v
	 OLFCYduD8VIWb0+3GNiajUESoxW+Ict0KxO6lIpHcAk4t1uyld6Tm9pMZRHZhK4bcq
	 Min354FIWXowQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9EAC3808201;
	Sat, 21 Feb 2026 01:20:51 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1771614421.git.dsterba@suse.com>
References: <cover.1771614421.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1771614421.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc1-tag
X-PR-Tracked-Commit-Id: ecb7c2484cfc83a93658907580035a8adf1e0a92
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b3f1da2a4d851b8e1ccf932e52c6772fe2253a47
Message-Id: <177163685022.970518.13640576953069358456.pr-tracker-bot@kernel.org>
Date: Sat, 21 Feb 2026 01:20:50 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 20 Feb 2026 23:29:20 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc1-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b3f1da2a4d851b8e1ccf932e52c6772fe2253a47

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
