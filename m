Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A45433049;
	Tue, 25 Aug 2026 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787662515; cv=none; b=m7bu8WrC1FmOYTr3R2KsHc41rTPv4lmbxVcyrffQIPHk67HM7HtejBsF0qTd5Qb7JqM4t8dTwBRUCkhJS8g/VlwulH57j0XC9l9+PzJEhOxUD1K2CmyVh8pASwMq9vRMCdn+DEggUy7E6KJhcg867oYIABBt3D8Rf52udYUEgVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787662515; c=relaxed/simple;
	bh=YH9Wij2rjqSFoljX7ADBuGRnYuKdrrO/J/Rc1kO7QSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uETgDTq4xfBIosHNa6F7KeExg9S8gfNdelb+RpJ1RzVoEwDji9LS+/QNa45rKg4UwYNfWMISaW5n4ztlxotUsmNjpEp31PiCM29rZ745FwLsZm4R7rzsg7FYFx6lnxpgXzecNrqyFHNuP/0BebLb8ulQRCuoP6VQzNpIfY4vju8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCEuJCiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCEuJCiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785801F00A3A;
	Tue, 25 Aug 2026 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662514;
	bh=vMrV9U6/Cw1BcfpiryKwK4mg1h6w5hsRJepfy83huPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OCEuJCiNHftt/WsuHMJfhXlF0PXLEiDad137QnZoA+36tR0BcJ7Y80R0rFqIi0PSK
	 vJV3CkKHNHvmqpQJgu20SrC6bthegVNaDTGlx9NhrHF9X3+qFHDKdr27DYNSmH+TSe
	 GooZKggpNTMrT5NwdnjpNUH/WmpB3EIQIF188dSOV9HON2espC8zvgdghUihhKgrD9
	 QUMGT2LJBl/iqDt6D20H7m0YBQNWQ7S8QflwWHDf+PHzpj/7IhNZchvSdrPwZve9uP
	 hSXebilSOGSbSfvZyEXyxEihkPaySOf+U3hcWFzO9vHVkIjt3E60iaIYdw8G/Q76PV
	 NqpDwYkDKAw8Q==
Date: Tue, 25 Aug 2026 14:55:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: David Sterba <dsterba@suse.cz>
Cc: Laurent Lyaudet <laurent.lyaudet@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] "final" flag for a directory
Message-ID: <20260825-seilschaft-gegriffen-eselsfell-3b8451aa86b0@brauner>
References: <CAB1LBmsQ2xFHQeEDFspwpFSNkiFUefBCn559EJsfEz5ZUAXYiA@mail.gmail.com>
 <20260818121131.GD54102@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260818121131.GD54102@twin.jikos.cz>

On Tue, Aug 18, 2026 at 02:13:22PM +0200, David Sterba wrote:
> On Mon, Aug 17, 2026 at 04:26:31PM +0200, Laurent Lyaudet wrote:
> > I had an idea about adding a boolean flag "final" on directories in an
> > advanced filesystem.
> > In the same way, the "final" keyword on a class in OOP can be added to
> > declare no subclass can exist,
> > the "final" boolean flag on a directory could be added to say that the
> > directory has no/must not have any subdirectory.
> 
> Do you have an existing use case for that?
> 
> > So here we see that 2 flags could be added:
> > - a configuration flag "must_be_final" forbidding to create a subdirectory,
> 
> I see two possible semantics of that:
> 
> - final, no subdirectories exist and new ones cannot be created
> - no new subdirectories can be created, but some may exist
> 
> Also given how other attributes behave once set they can be unset. This
> is up to the user, and possibly a restricted operation.
> 
> > - a status flag "is_final" telling that no subdirectory currently exists.
> 
> When the filesystem tracks the number of subdirectories already, then
> it's an easy check. Otherwise a full search must be done, atomically wrt
> creating new subdirectories.
> 
> > I think it may allow some small optimizations.
> > With a very limited search on the Internet, I found no similar thing before,
> > but I do assume that I'm not the first one to have this idea of
> > marking the pseudo-leaves of the filesystem tree.
> 
> > Please, let me know if this should be discussed elsewhere.
> 
> If fsdevel is not interested we can still discuss it on btrfs
> mailinglist. I've been collecting ideas for new file attributes (listed
> below), but not all are generic enough for other filesystems (e.g.
> nodatasum).
> 
> The fileattr interface (wrapping the old flags and XFLAGs) has some

We have file_setattr() and file_getattr() both extensible beyond spare
flag bits.
