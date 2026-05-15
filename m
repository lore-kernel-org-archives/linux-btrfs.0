Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398FF3F58EB;
	Fri, 15 May 2026 22:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883243; cv=none; b=nnoC82FdFhHj98dpZgsD/ljzCxknfS9oNfQsx6ylaY/RLeExHDNxbrSoRtqDRBJax70qrOvJnFyE1GpvDdidcVNWGjPSqs6WLMXKoRphAMhp8MvkAexNqax7hbRb0E5NdIPiN0vsh/T3SR/rjaxs6C72DKahX9DsLlGNdPE2rxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883243; c=relaxed/simple;
	bh=8txCSnrepK0AXL84arejAvxy0j+6fR5d6x0yG4B3gLw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=G8kzi2sdR3IyrKl2Mm+bcme93BCQWEymTX3vzjLXwTGW9Ngul45ZX8WYsJ6eGU55CG9qWdvBHVbJ0zuTafNfcb6410D6FAx0Yzef+BOoMfLol+NKoH20DPvVYCgT9m4gNV/fS3kUJQdmkxfSAM+1K8EbQKuLQnO1a0uo0E57Mq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baaqOkOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baaqOkOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA3C2BCB0;
	Fri, 15 May 2026 22:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883243;
	bh=8txCSnrepK0AXL84arejAvxy0j+6fR5d6x0yG4B3gLw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=baaqOkOeSeOj6YVWIgqLo+n2n3BpabLtik5QB/6q0Ks+rwBsQ+1l5QyWw0jAFS8om
	 0Wjsu0ydetU8RWg9wYlswgTfSLcM199eK9p5gmo8yrM3oB6DqRZ2DOAQrF7HRaO2SD
	 LBhCuHlYw66GHXlRlZ1C7DeaQ6cn7lbSYTmzA8qbk2HEHOiH8XGPWS1BjtR0roxpg7
	 Dp6gsE+dWiwosf67ordvEi20RLwxHOIbuCrtC5z07W9XGTUq4APRM1E1+NA76rOhrN
	 nwDlY0NVBBEqSnYpreyfDarVSJx1X26jlkRYuHKiw+eKU78R1LDvD6m3pU74ylMm+n
	 LauuI4ZQI4xIw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A073930A12;
	Fri, 15 May 2026 22:14:17 +0000 (UTC)
Subject: Re: [GIT PULL] Btrfs fixes for 7.1-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <cover.1778865786.git.dsterba@suse.com>
References: <cover.1778865786.git.dsterba@suse.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <cover.1778865786.git.dsterba@suse.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc3-tag
X-PR-Tracked-Commit-Id: c562ba61fc5e11798720acc1b172862158f1fa0b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a8b0b72255d09bb12ada5620cd6ced91adde5ac8
Message-Id: <177888325608.173168.5522132836775439446.pr-tracker-bot@kernel.org>
Date: Fri, 15 May 2026 22:14:16 +0000
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, torvalds@linux-foundation.org, David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 15 May 2026 19:34:23 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc3-tag

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a8b0b72255d09bb12ada5620cd6ced91adde5ac8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
