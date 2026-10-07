Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38E37DEA8;
	Wed,  7 Oct 2026 21:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791407038; cv=none; b=BaQkh2jMZy02YeXonyE0JlOCWwK3AHyuWt+B35mf/A4vzmkkKUJXAudyQG3YPvHtXBnx35xLHTZo4Sf1GZCeiQo+1mwtMOYCEfSRhxfZ88pDDmbJdYbe+0XW6j0yHZsNhT4P/j4UUIjL3AR5UZAitacRMY6vFpDwKtYzsDKqlQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791407038; c=relaxed/simple;
	bh=oqtq798sjlnZLbg4uuhDr0Sd4HINwbErLEiuzrf+SuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjZfo/c8takvpklQPYcECYu1UzuhAf3xhl8GERCFGtzCgSIMRzME1AyXddsaKsKEa97cJSQ3DJU2yhrSs/w+WYOvyubw9get3PgP0UIlSSPUjcoZAKKs5+v6E+tbVcGboyirzsca3GFTiPT5/c9JDgiYgY61s/6LW/5ZOn1pD54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU7a9mK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU7a9mK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294391F00893;
	Wed,  7 Oct 2026 21:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791407037;
	bh=k+ouy0dpxuTkl5aBd6YD4mEeTn6vL1NsHU5mM8Yvxk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aU7a9mK29IAeoziZW93IlOfaLTldQ0DWhcOED2TRTUJ+DhkGx8THal5vkEnn4a2zt
	 x/1ls7dMRW4nUGqc9TLVUz2LU/jF4jRxAuynhyyPu0TA6q4pKoXQql1ViAP6OFuCZg
	 nLziXJl68+qgsnUI1iIpSC7CjJuDwoUS9GqZgy4S4xYugb99nJKVXPkL9LhMQCdxdy
	 sN+7XrhBhdVUHpkLbs+fwMRxlP+ASIwLuF5lA53s3wlF8hK1W0VyKlR2ueojldH3Cs
	 pqMZ4W7jJF8wavG52ajvNzXBeB+wC5ORozTALp1TNxHvRkNV8kW1MmaUAAM/eFnXNk
	 myiBMDLAYL1eQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	fsverity@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 6.6 0/2] Forbid truncate of fsverity files on btrfs
Date: Wed,  7 Oct 2026 17:03:24 -0400
Message-ID: <2026-10-07-1-daily-reply-0007-fsverity-truncate-btrfs-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261006213815.47194-1-ebiggers@kernel.org>
References: <20261006213815.47194-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport the fix to forbid truncate(2) of fsverity files on btrfs (and
> also the fix for that fix).

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
