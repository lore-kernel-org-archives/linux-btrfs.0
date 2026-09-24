Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414A32E737D;
	Thu, 24 Sep 2026 00:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790209269; cv=none; b=UyHc4e3C8X1E5iTDbI0F09OPvljs5HUiTmhnNPZyl/vgTmWmQvOpn3THCas5od4NhQkPNAd59/qzxF74VpDa31ZZ39ulgMZFMxL5b7t8MxmL6e261DKbEFmR6patuMIduJMaOnzexBrxJz54VHXO/BBcDrlHpK5FzfuR6bWyesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790209269; c=relaxed/simple;
	bh=hU7M3BUX2CIlqcDNCSktw3B94z31jCISM4BUFx3ngSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzjfgpmfGjIYwXwn/o9m6PKqdkWAmO8sNSFwnB2ksJDkTifoIx0UyqADy2ULZJSxJlnQy93vh5WMt4IqZWRoWYG+XiI6v59ZrEV6vl7ZDYVWXK6k0SolIbNRiYAx3dNafKHPoaIqfcZwcE4tBjhYqevD7Tr94JVPObvHDZD30qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7C6n2Bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7C6n2Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C513B1F00898;
	Thu, 24 Sep 2026 00:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790209267;
	bh=PayJxaBo08se+kR+gQ/fmiz6ERBN594kz+OnQ9Wnb9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7C6n2BbL0ib84oL07Tfgnzi3aNwdaPCGO/s3+ZNHGQmpkoz0JHq+UTNPM6j2GvVY
	 0tvig5fk9uT9skmm8l+hvLSme0nCeFpA4joz83BHPxx67agIphuk4eiGxfp0q/0PZt
	 UxvMdVc8w0RJ9RnGNuy0AXK3YsmGQH49LsrqSC6V7TMH5RffDBLduQNCJGhEh7Y0q2
	 E8nfX6LO+SkDzkZKUJ5v5v1OucZnUofmhyqnD04nMaKLmfpmSaIa6OIDfbKZi4O349
	 wom34enQCv8OHVDCOracrYhCKZuCrGeOAteePUaPfKS5jWCktdxxbZn2m28+t/n7tf
	 lqUxnE/UFZjYA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6.1.y] btrfs: don't check PageError in __extent_writepage
Date: Wed, 23 Sep 2026 20:20:51 -0400
Message-ID: <2026-09-23-daily-reply-0002-re-btrfs-pageerror-extent-writepage-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260922195836.27193-1-artem@trailofbits.com>
References: <20260922195836.27193-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Backport to 6.1.y: apply the PageError-to-ret change in this tree's
>   pre-btrfs_bio_ctrl __extent_writepage(). ]

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
