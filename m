Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E592A332635;
	Wed,  1 Apr 2026 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775055239; cv=none; b=G7q1/79XwXxSA1olmvR+1wXtAQc3LxzaYJuxgQWHhebh1gOTTDCPeWKh3GrQuEz7tYAJkaZ/fYjaPaHMOzw0iB2wt+QQDATq7iYFezTq6WJhtqrnCKX7bISvsOKGFVXdOsQVLMHFf5LGgDoTKCP3unyYOaJDrPrz7c/KiIgBH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775055239; c=relaxed/simple;
	bh=rFGY5ev9Y7kYDBfSHZFU8byopPvN3quU/Jr4BYZzu8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lgITzR5poDNYr2ZruvW78YtHpNZij6smXro3CYdJCavJZnh2M1uWj8Y+Sg1fIoeCDtEM2UO2G4k2xJw/DJxXT8r24UtEb6Tr8h8OiV65ytPcijHPfTGk+eNvAjxhWW8tHlodrZKHVCQ/tLwqxN4Q+sdlu/WYYZCJzDkQZGmlk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZa+fA6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZa+fA6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F140C4CEF7;
	Wed,  1 Apr 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775055238;
	bh=rFGY5ev9Y7kYDBfSHZFU8byopPvN3quU/Jr4BYZzu8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JZa+fA6PKYVV0qjX+7MGsijZREV1+8Cw3pfkbInZDs5kFqcLMnP+RtCTstbrwzk18
	 sZCmLUFl6Jmd6it8307l5kdUYAWPJNyzvWcLPrEuR8fhgAaMzrwx72Qf4DDZRMcyCj
	 u52swkCc6TNon3cCLr6KnkRvqzp+lcKPbsLo3j6TcOoOnlIdRSEzFR9f95KGiX7d2D
	 wDSAxiMRnbttyAwlf+xwBDpnsXlJ2gsXno+1X7rKok/2cm6+JsnCH6L2sWB/4hyiuT
	 EPgAlh/K/pIPHY+wW31HQHfpBSuRMkIUyeG8BD4UhyZt84a+YcLxS95qnUFAePNRUG
	 nClyVxDdQ4hNg==
Date: Wed, 1 Apr 2026 07:53:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, WANG Rui <r@hev.cc>,
	ziy@nvidia.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com,
	dev.jain@arm.com, dsterba@suse.com, jack@suse.cz,
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org,
	ryan.roberts@arm.com, shuah@kernel.org, songliubraving@fb.com,
	surenb@google.com, vbabka@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <20260401145357.GL6202@frogsfrogsfrogs>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
 <20260330160942.173324-1-r@hev.cc>
 <acqinu8H5jo3Zw7b@casper.infradead.org>
 <b6596c2c-94de-43f4-b30c-c9361d55e3b8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6596c2c-94de-43f4-b30c-c9361d55e3b8@kernel.org>

On Wed, Apr 01, 2026 at 04:38:21PM +0200, David Hildenbrand (Arm) wrote:
> On 3/30/26 18:19, Matthew Wilcox wrote:
> > On Tue, Mar 31, 2026 at 12:09:42AM +0800, WANG Rui wrote:
> >> Given the diversity of filesystems in use, each one requires dedicated
> >> engineering effort to implement and validate large folio support, and
> >> that assumes both sufficient resources and prioritization on the
> >> filesystem side. Even after support lands, coverage across different
> >> base page sizes and configurations may take additional time to mature.
> >>
> >> What I am really concerned about is the transition period: if filesystem
> >> support is not yet broadly ready, while we have already removed the
> >> fallback path, we may end up in a situation where PMD-sized mappings
> >> become effectively unavailable on many systems for some time.
> >>
> >> This is not about the long-term direction, but about the timing and
> >> practical readiness.
> > 
> > If we leave this fallback in place, we'll never get filesystems to move
> > forward.  It's time to rip off this bandaid; they've got eight months
> > before the next stable kernel.
> 
> I guess if we don't force them to work on it I guess this will never
> happen. They shouldn't be holding our THP hacks we want to remove hostage.

+1.  There are too many filesystems for the ever shrinking number of
filesystem maintainers so the work won't get done without leverage.
Leverage, as in "hey why did my fault counts go up?"

--D

> -- 
> Cheers,
> 
> David
> 
