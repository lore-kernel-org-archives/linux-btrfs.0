Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AF481FB0;
	Tue, 14 Jul 2026 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784045760; cv=none; b=i5JBfXtipgArkUnV3znrsSzlFa6FHBjNsFO2aStXsIq+hi6D+kISyFsFWxwCAvVKuzF1seHWn3VRWv1Ir6M50xuG3YQZC9P8sbyybLe662ZeTEkbVnwPH81VS0XYcd4jjmeYJPi2VDU40KTQ58xOWagyb6QFjkuTn55H8uTekow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784045760; c=relaxed/simple;
	bh=R9k794ZCEfphev6hy9jkuPTchiJs9Wq0lMvkTVirirI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TI6JhbcBqIeRcmJzrVSKL1hzc3BbRt1rYJMAKu4ai7VqsOuqHIvBYn+iS+8P0w7Jc1mSxmCN9F3dPjOiD0JRtZJr3tELAcefPuE/CylQ4q9lNbRt/cdy7V3AXpzbn25q1YLiSedzCM+fjj400e6OEfe4swE78UsVU/p0ynHaDBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjWGbxO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjWGbxO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832CB1F000E9;
	Tue, 14 Jul 2026 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784045759;
	bh=AV7AsJDOlBQTutwgIa4hSlFRBN7O6wfH2x6ni05qpx8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cjWGbxO3jMPHZbj1klEWb5KZlXK/LDBNwrynqtmfrcBhSbvGZr34m1oWshFvvTVfH
	 5nEHBlgDO1rdND0nrtRjnNNWX6cwOfXvcWy6Cw8AM2MHZverIkkUIIqRPaVWv17Fsl
	 2m9ivoPz6RGgWItsNmuCu12sxMef9mmxErxhTuS/0Ha1C5czbqVBHB2HH0S9mXIiBc
	 o8QAZQBLgnkd+27X3gDv/LG2qBNJJiaq/EpryCbGzWmEYlvYIyDhrs4xndObkcxVhe
	 GeJzuSEIDNl1uVa76ATT37w5upH9A7BAjVKAjSj98duL0dXOveCf39IOokuJqVEp44
	 ls6cNIwf6p53A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 585DC39253FB;
	Tue, 14 Jul 2026 16:15:35 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.2-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1784004728.git.dsterba@suse.com>
References: <cover.1784004728.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1784004728.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc3-tag
X-PR-Tracked-Commit-Id: c0041b502e579a5c52e5cae918b90678f03faddd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7059bdf4f04a3e14f4fafb3ac35fdca913e3e21a
Message-Id: <178404573404.3675086.16279043409058615949.pr-tracker-bot@kernel.org>
Date: Tue, 14 Jul 2026 16:15:34 +0000
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 14 Jul 2026 07:00:53 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7059bdf4f04a3e14f4fafb3ac35fdca913e3e21a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
