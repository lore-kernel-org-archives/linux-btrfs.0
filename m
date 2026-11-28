Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795846795;
	b=tTnUTA1iaBJZgak5/d4LNyLqXPghGMu8wqSyPFdBQKwUsAiT8BNP7BI0O4z/d0fNm4Ma
	 j0tgzhiljw2XhQ2/hNuGT3pQfjD+qILjqszbnP6BeaGqHqro/L9fkfkVV7HmG44eFghHX
	 ko6sMV7U5kMmPlQJr/kHYnS9IpgORceo1XH8tF0TmrPwNMIh6/sbkfIw9E0GeqaYYlY0o
	 J+EsQHlYGAANAOp8nczzcaoMERCazcyhZoopfpA8eSLhUJ9yEDA4WtQJh3+XN1GxwdA2f
	 2WIacfLaALwW2Q/HS10ixiJ6WMrMp5PCm7niTJjhdlkUExGkgS14FXl5ofhHcd0xv0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795846795;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=20Aomw9N3j1CSSz23mLXNHXgwt0Oq0NUIdP3n+DrOTM=;
	b=bEUNP3WbMAcKd3gI/KFtPdXq78pzZ+2qen/pDDhs7tAhDaYSRCwf1qgRMT3TTN6fyzmp
	 Wmz6gMZLzkRHl/5K6Od69eMFcur+BG+yHfakGqGXNmpD9oBgDEojRggDRNwL/4XsQ4keq
	 5A6271ubf1FUEzmzTDpPzEoOkS9KETX/6Gb38UPhxYbB1UW3wNDNXxZNWYnY7nV1rJhNU
	 C/PRf/KYo8FXVIGqaBAqw4sjGbr1KiQgyG7WbzRGIh4qQQyu2sGylWaqvT9fim2hLVWDQ
	 QPvCdvowyTf+ckgdCO/jKf5kc7db0/SPq8w14PgZMa2EWfJ2oiLuG5/M/A9pIm+C9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjNx7os2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F31606A31C;
	Sat, 28 Nov 2026 06:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OjNx7os2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF91F00893;
	Sat, 28 Nov 2026 06:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795846795;
	bh=20Aomw9N3j1CSSz23mLXNHXgwt0Oq0NUIdP3n+DrOTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OjNx7os2OYdUk4EdxyuBHc8oIcEuNT37tHhp84PEgHxu+46C+yarQQr9v9n02SY8x
	 Jrn9rYIuiCAmXfyAVsg5eOSa3vvEz8KJi2KmkbcWXpyNA0LC1JEmBywLiSOv8LvkTb
	 OjlSc3vvwsSBgdVQUpveivCXaqDrEojNW8p2wfKZxaImsdXNI/wn7ASPWm5KE+INMN
	 eHWfm387u+wK5KF3EsJTfEIcZhA7pnOzw9abB00bHdGdZDMqWlzaO+uFbI9jxtRPae
	 Wv+CBo3C9M828VBlvjZQRzgyML4VTHybfu5TakEP/i8l/Y0SJoCeuPXB2V6ej5G0lp
	 rAnFUK+3Jjv6A==
Date: Sat, 28 Nov 2026 08:19:50 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] btrfs: add a maintainer entry profile
Message-ID: <20261128061950.GF774860@unreal>
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
 <20261126133712.GN774860@unreal>
 <978c5ae0-8cf2-47d4-8fb5-1d96896132be@suse.com>
 <20261127151418.GY774860@unreal>
 <138ba3eb-7225-429b-9791-2de9d49e1fdf@suse.com>
 <20261128045649.GE774860@unreal>
 <05837923-9377-4ab5-b46d-ef0124784c74@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <05837923-9377-4ab5-b46d-ef0124784c74@suse.com>

On Sat, Nov 28, 2026 at 04:13:32PM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/28 15:26, Leon Romanovsky 写道:
> > On Sat, Nov 28, 2026 at 08:31:09AM +1030, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/11/28 01:44, Leon Romanovsky 写道:
> > > > On Fri, Nov 27, 2026 at 08:23:13PM +1030, Qu Wenruo wrote:
> > > > > 
> > > > > 
> > > > > 在 2026/11/27 00:07, Leon Romanovsky 写道:
> > > > > > On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
> > > > > > > This new file is mostly based on my personal preferences, focusing on
> > > > > > > how to improve the human readability in the LLM era.
> > > > > > > 
> > > > > > > The new file should also act as a guide for humans that want to be a
> > > > > > > long term contributor to btrfs.
> > > > > > 
> > > > > > My previous comment still applies. Most of it is relevant to other
> > > > > > subsystems as well, and some of the suggestions duplicate existing
> > > > > > documentation.
> > > > > 
> > > > > One question is, I can't find a generic one, nor there is a generic entry
> > > > > inside the MAINTAINERS file.
> > > > > 
> > > > > If we're going to create a generic one, shouldn't we just update the
> > > > > existing docs like `Documentation/process/submitting-patches.rst` instead?
> > > > 
> > > > See Documentation/process/coding-assistants.rst file.
> > > > For example, this series from Sasha changes it
> > > > https://lore.kernel.org/workflows/20261126171926.2766137-1-sashal@kernel.org/
> > > 
> > > I think this is against Krzysztof's comment:
> > > 
> > > 
> > > > Then it should be a maintainer profile. We should write docs for humans,
> > > > which can be used by agents. Not the other way around.
> > > 
> > > I agree with that comment.
> > > 
> > > But putting that into code-assistants.rst means it's only for LLMs, not
> > > humans.
> > 
> > Please decide to whom you are writing first.
> > Almost everything written in your proposal is for LLMs.
> 
> LLM will also refer to maintainer's profile, through MAINTAINER's P: line.
> 
> > 
> > LLMs instructions go to the coding-assistants, instructions for humans
> > to submitting-patches and specific to BTFS goes to maintainer profile.
> 
> LLM will also refer to that submitting-patches file through the current
> coding-assitants.rst:16.
> 
> So I don't know you are pushing so hard to distinguish files for human and
> LLMs.

Please don't misrepresent what I said. I asked that general instructions
applicable to everyone be placed in the general Documentation section.

You were the one who argued that submitting-patches is not human-readable,
not me. You also did not check whether your proposal duplicates existing
instructions.

Make sure that profile-btrfs include only specific to BTRFS things.

Thanks
