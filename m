Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795841813;
	b=RLZ5SK05q47oKM6A6IxC5t+a0ULIk/IDq9wO9TraNC8ZWLJMyirFbQxHnAAiV14b4wL2
	 rYmd4VRgtRwsdiGIHu7EGfw13Yk2za8KZuIq+CTcTUeD/d+LHR4X3z9gvZqIIPwpBwaNh
	 eY698iT5KGxV/69BLar6PeCJPVOVhk4aSNdTpeQeLV+aaMuH1b8+aAaOmFRL/x+w1bB26
	 9SJZ8IdtMCrqMfYU7MnF5c7lE1ACIJo5C4OPu9a9J+s7KfwEuxpbpe1mHMI7A8vD7dxT6
	 ZIpfEebCi+1GgdVTcvnB44oihTMy470Qcx6ggVmlxMad7IKFFBV+46iguEL/CffHoeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795841813;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=+sXlcVSr6pbKyCWZveIHR1OXALZz80NHyQHz/XR3jK0=;
	b=MeGLnT8uVkxAqY7TeSaZhi/H7izOEinPnNaR27gkiJe+hOSp1SOF0WzW6EAan53PakM0
	 CMhtiKuIyEmGkrgdbt/q5ELiRbSS/CG8+grnuZko5lTjNv5lfG1VluEkRipbmTlPdQ9RD
	 8WBnPh966EoR/G/Sa4rveIMJMFYyrzcpzWR50oQdME0vEDsmDxbDfC/laW1SF+3cno+jW
	 udO5RbfE1sBRzVgi9w/dfx2FjmfbQYPld/xuYa9Ds97wPvDXqO8ROGxgH8naRv2liSack
	 V4j7xSvFzIF7hUiJmB9JwNcrxx6PE11U5+Y8nIlmoet0obreB0vDhmJAX4xozMHfF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=akkT2FLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D9606A31C;
	Sat, 28 Nov 2026 04:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=akkT2FLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B911F000C1;
	Sat, 28 Nov 2026 04:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795841813;
	bh=+sXlcVSr6pbKyCWZveIHR1OXALZz80NHyQHz/XR3jK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=akkT2FLAMrQ6Kbx4E5teDsJvM3SH0Ah+vSxYUhddV5SBuhkfJproqNky5XImF7n9u
	 7PWLsgi9KndxXxNN/RKVkfaUELb2iqnQ9h8UyMqCljxx1vEF5+Yis9uA7X2G8rLA9j
	 SJR1NU2NkqFY8Vu+4ox5PdtEvA2z5oywJ81i4z1AbGbWjcMXs/jnMFwhansy1+2d/d
	 EE+7hdRE5ZupRQTqdtacbFAtjA9AlIrYkvAk4l34W5fq23T4RZlBV+RowWrpqbdRI9
	 2Ch0OaVk4MtMI5oZctorOQPL6CTHmIix4Kpo+sQUH0b7nEb1BuT5QguEB4gdzLyhMk
	 +Db9bxj7f5qxw==
Date: Sat, 28 Nov 2026 06:56:49 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] btrfs: add a maintainer entry profile
Message-ID: <20261128045649.GE774860@unreal>
References: <0037554862c0d9dce3ddafd1238347e4b16a5079.1795581896.git.wqu@suse.com>
 <20261126133712.GN774860@unreal>
 <978c5ae0-8cf2-47d4-8fb5-1d96896132be@suse.com>
 <20261127151418.GY774860@unreal>
 <138ba3eb-7225-429b-9791-2de9d49e1fdf@suse.com>
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
In-Reply-To: <138ba3eb-7225-429b-9791-2de9d49e1fdf@suse.com>

On Sat, Nov 28, 2026 at 08:31:09AM +1030, Qu Wenruo wrote:
> 
> 
> 在 2026/11/28 01:44, Leon Romanovsky 写道:
> > On Fri, Nov 27, 2026 at 08:23:13PM +1030, Qu Wenruo wrote:
> > > 
> > > 
> > > 在 2026/11/27 00:07, Leon Romanovsky 写道:
> > > > On Wed, Nov 25, 2026 at 03:16:21PM +1030, Qu Wenruo wrote:
> > > > > This new file is mostly based on my personal preferences, focusing on
> > > > > how to improve the human readability in the LLM era.
> > > > > 
> > > > > The new file should also act as a guide for humans that want to be a
> > > > > long term contributor to btrfs.
> > > > 
> > > > My previous comment still applies. Most of it is relevant to other
> > > > subsystems as well, and some of the suggestions duplicate existing
> > > > documentation.
> > > 
> > > One question is, I can't find a generic one, nor there is a generic entry
> > > inside the MAINTAINERS file.
> > > 
> > > If we're going to create a generic one, shouldn't we just update the
> > > existing docs like `Documentation/process/submitting-patches.rst` instead?
> > 
> > See Documentation/process/coding-assistants.rst file.
> > For example, this series from Sasha changes it
> > https://lore.kernel.org/workflows/20261126171926.2766137-1-sashal@kernel.org/
> 
> I think this is against Krzysztof's comment:
> 
> 
> > Then it should be a maintainer profile. We should write docs for humans,
> > which can be used by agents. Not the other way around.
> 
> I agree with that comment.
> 
> But putting that into code-assistants.rst means it's only for LLMs, not
> humans.

Please decide to whom you are writing first.
Almost everything written in your proposal is for LLMs.

LLMs instructions go to the coding-assistants, instructions for humans
to submitting-patches and specific to BTFS goes to maintainer profile.

Thanks
