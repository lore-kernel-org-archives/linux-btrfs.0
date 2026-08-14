Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF70B480334;
	Fri, 14 Aug 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786721127; cv=none; b=lmR60y3jBeFgSW2PJIvz3k+ywmGW2mF4zPp513lrkLWPt+xUmsksI8xsSSFyxLedr9Q1XtXGBSp8p+woyANEDmH69k6bkPy9oIObr/16MOjiVxSXOo2Q3sSXc4wnTBnEWMpnvLDS5AFAdXhSRKieggnxInDBX4eJYyYSfS/4F8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786721127; c=relaxed/simple;
	bh=6LYC7jlI3AzbuvaoWAGLDhWeJIrZSIflhauoXti/vnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHLRFKejdhoDRz9Dl577z10ALRmZ9Ab+DxPTkvqq5mYnW/fN4OtlEed4whJCRGLdM+n2UaWDdl7Qa+iz3k3m1FFGd3MvRlRbO2TbFACIiq7+xbf1Z852mHBc7zXSowG23zXecdo5xGwbDnbBw4FMfSpp3x9tOBAbP55w6A9co9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQm8oqA6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQm8oqA6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DAB1F00A3A;
	Fri, 14 Aug 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721125;
	bh=ocXmal97LmWIM6Rl49/KY6LlAMcW3ICYwnksGSRQk6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JQm8oqA6VgwrfOQL9uey/KiMO3KIuI7DFtUCgegFBbY9nAZq1EPUvo5aAqQJ6brmq
	 ZxrJYdEzHJfQfN2E+X7FMFhZSE1D5NGZDabelw/oXWAiEhtlwUMgD3mx6bR6yIp2ui
	 brxcdtZzAE6tMiH9KNbuVfFAtNYXNMMH9g30QYZTfIpBQKIoE8HcXtKRG9NAmUVzTb
	 XbMalkP8TpX5YDAZSFJurvUqZZrrDRierDEOoVlGvfZknCrWDLHWktB3CyHrtxKrp2
	 j9QzTZqMWkGwd5aODKtTuuOm9pRElLGfyKOJ78TuKc89g/ML0/fjJKSpgr09ITG9HV
	 m+mG3Rhgf/K2Q==
Date: Fri, 14 Aug 2026 10:25:06 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>, clm@fb.com, dsterba@suse.com,
	josef@toxicpanda.com, brauner@kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] btrfs: use mount idmap for defrag permission check
Message-ID: <an8zUrSeI9xNTjCL@ubuntu-x1>
References: <20260813034146.1207640-1-cui.tao@linux.dev>
 <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com>
 <an36yH30W965eqZk@ubuntu-x1>
 <1168774a-74d3-4e77-98e3-cd688a2d7e0f@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1168774a-74d3-4e77-98e3-cd688a2d7e0f@linux.dev>

On Fri, Aug 14, 2026 at 01:15:51PM +0800, Tao Cui wrote:
> 
> 
> 在 2026/8/14 01:11, Seth Forshee 写道:
> > On Thu, Aug 13, 2026 at 04:04:05PM +0930, Qu Wenruo wrote:
> >>
> >>
> >> 在 2026/8/13 13:11, Tao Cui 写道:
> >>> From: Tao Cui <cuitao@kylinos.cn>
> >>>
> >>> btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
> >>> the mount idmap.  On an idmapped mount the owner comparison then uses
> >>> the caller's fsuid against the raw on-disk uid, dropping the mapping.
> >>> Every other permission/owner check in btrfs ioctl uses
> >>> file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.
> >>>
> >>> Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
> >>> mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
> >>> unprivileged callers on idmapped btrfs change.  The RO-fd note in the
> >>> comment above is about the file descriptor, not this inode check, and
> >>> is unaffected.
> >>>
> >>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> >>
> >> Fixes: 4609e1f18e19 ("fs: port ->permission() to pass mnt_idmap")
> > 
> > This is a misattribution. Using nop_mnt_idmap there keeps the behavior
> > the same as it was before the commit. Switching to the mount idmap opens
> > up BTRFS_IOC_DEFRAG* to idmapped users when they weren't before, which
> > is a separate policy decision that didn't belong in that change.
> > 
> Agreed, I'll resend it as a behavior change with no Fixes tag.
> > Saying that these ioctls should be allowed for idmapped users just
> > because others are isn't a good justification. Why are these ioctls safe
> > for idmapped users?  Do they actually require this capability?
> > 
> The check isn't a privilege gate. 616d374efa23 added it to test "whether
> the file could have been opened rw", and the caller can already do that
> on the idmapped mount -- open O_RDWR, write(), fallocate(). Only the
> regular-file branch changes, and defrag only reorganizes the caller's
> own extents; the S_IFDIR branch (whole-subvolume defrag) keeps its
> capable(CAP_SYS_ADMIN).
> 
> Nothing is weakened: !capable(CAP_SYS_ADMIN) stays exactly as is.
> 
> may_dedupe_file() in fs/remap_range.c already gates FIDEDUPERANGE the
> same way -- capable(CAP_SYS_ADMIN), then i_uid_into_vfsuid(
> file_mnt_idmap(file)) / inode_permission(idmap, MAY_WRITE) -- and dedupe
> is stronger, since it can rewrite one file's extents from another file's
> contents. Idmapped users can already dedupe on btrfs.

It seems perfectly reasonable to relax the check. I just think the
justification in the commit message should be updated to explain why
these specific ioctls should be allowed for idmapped users, similar to
pervious commits allowing idmapped use of the other ioctls.

Thanks,
Seth
