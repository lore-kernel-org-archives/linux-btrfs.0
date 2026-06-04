Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C07747D955;
	Thu,  4 Jun 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780591581; cv=none; b=ebjiT3B7dt2byukkfIl9RoCWDHKziRfaOH7Ik0tst9Fsu/7XS5YYs9Zep7WYzTQfy0Lo0VlolvM1NrtSueaGOVzLCv/9A9bXJpDkPd0tvQc58AVP5jeaHGSwTJ1sy3hzYgOx7/LEDxQzdK/TB0QNuaicfcBuUKQSNYCBfNikpI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780591581; c=relaxed/simple;
	bh=Tw5lGgzNnHCqMEea5zqTVKsPakslIVaEPhlvR7AbpwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vB+N5p+wf+xS4MAXKFMTPBwNYEWnRiAuRUfcRGKIXYYGk2T3v8s9+yryuO34rvdMo48gorcs0B/fyp/bxHE0m3C7WGXqSHq0GkChZRNjFGYkvFu8kJU7/KMHIy3ZWRZA39W84Skuh7uHOVgD1QdhxO+wAs66qQOnxIiZykellDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/grrgkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/grrgkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9501F00893;
	Thu,  4 Jun 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780591580;
	bh=KhhMsGD0hHIEqCXVJYgHa3HFrWdd9uXB0blHijAPGwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F/grrgkCmmQnaxwyeP/ARCUCTvo6BE3rL64rb8O2CoIbtPZVbJEOWY6wR9cXl1V5N
	 bnZzhugcK4OeZroqVxD8I2valqbS5ruapOsXO+BQX6WX6OTzIsa8NvoFSW4RAl7+8r
	 c7p+glsGZNuJbSHiMosXOloWcFpICwxXn9Neuhuf2/I+SI3jOkosrg/wQHUGJmWOOk
	 1XblbTQGE2Dg4UtkQnEzmKO8vvdPREqrlNPJ6YzFqtozejNFfpfz37kKXTaA5p0YKm
	 ABcrr6wOkeC2AFjbJavOISLX+juJZpBhEVN9FWALa+Qpl4xvQ9K1xWtGeyH1JtJyrE
	 aiZ2nLfT0C5+g==
Date: Fri, 5 Jun 2026 00:46:13 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate
 TEST_FS_MOUNT_OPTS if possible
Message-ID: <aiGYgLaQ7_r9LQ2G@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Xiao Yang <yangx.jy@fujitsu.com>
References: <20260602001422.24364-1-wqu@suse.com>
 <ah50bZRaH6YWTJXc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah50bZRaH6YWTJXc@infradead.org>

On Mon, Jun 01, 2026 at 11:13:01PM -0700, Christoph Hellwig wrote:
> On Tue, Jun 02, 2026 at 09:44:22AM +0930, Qu Wenruo wrote:
> > If the test config only specifies "MOUNT_OPTIONS", but not
> > "TEST_FS_MOUNT_OPTS", the mount for TEST_DIR can have inconsistent flag
> > after _test_cycle_mount().
>
> AFAIK TEST_FS_MOUNT_OPTS gets overriden and isn't even a public option.
> It gets filled by fstype-sepcific options in _common_mount_opts.
> 
> This started to really confuse me lately when I was trying to test with
> mount options on the test fs.
> 
> I've looked at bit into the area but haven't come to a conclusion yet.
> The most recent change in this area is 1dd7395623cb ("common/config:
> Make test and scratch devices use the same mount options"), which didn't
> really make them common, adding to my confusion.
> 
> So I really think we need to fix things here, but right now I'm not sure
> how much of the current situation is intentional, and what our final
> goal is :(

Sorry for this terrible code logic.

AFAIK, TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS serve different purposes:
TEST_FS_MOUNT_OPTS is used for TEST_DEV, while MOUNT_OPTIONS is used for
SCRATCH_DEV as well as loop or dm devices and so on. For instance, _test_mount
only applies TEST_FS_MOUNT_OPTS, whereas _scratch_mount only uses MOUNT_OPTIONS.
I used xfstests for over a decade, I typically configure both variables together
(often to the same values), so I didn't give them too much thought.

About the commit 1dd7395623cb, the subject of it would be better to be
"Make test and scratch devices use the same *default* mount options"
from ${FSTYP}_MOUNT_OPTIONS parameters. The original intent was not to merge
TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS into a single variable.

About documentation, it is true that TEST_FS_MOUNT_OPTS is barely mentioned.
It is completely missing from the main README and only appears in other
sub-documents like README.config-sections. We should definitely clarify the
relationship between TEST_FS_MOUNT_OPTS and TEST_DEV, and metion that they
have no connection to MOUNT_OPTIONS.

Right now, the biggest inconsistent issue is probably with those feature-probing
helpers. They often check TEST_DIR to determine behaviors for SCRATCH_MNT. While
this works fine for features unaffected by mount options, but we might should
handle mount options related features (for TEST_DEV or SCRATCH_DEV) separately.

Thanks,
Zorro

> 
