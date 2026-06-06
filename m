Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987E32E3709;
	Sat,  6 Jun 2026 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780774431; cv=none; b=mWTrlYXYludfxBZtygJRqF7jcQOzO021galbIxAAZ0ErXdSCAHh/zS77yaaAWQ7EI/xmZD5GRWf4aHX2NS30IrM+fkMbkn1mc4wonXCHdffUCjy1+BXzDu+03Mlu1GpZWuOFwEUE0EKvox92nGl01h5ksPio4SwS3XL8khFUGRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780774431; c=relaxed/simple;
	bh=BJIRS1ClEBoJKTim4H3nHXT3ZK8hRWL0BXGDq/JqTaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EODVPMERJFRwoEhbp/ja9SkvKvBYja/ggyXQo3Dk80qXF018IPUI2f4qdjMLFzLPaB6Lr74D4yNBD680Z+AmvJXqCW3hJqZxAde50MTTOl+O1bHEGYJEnC5dgjp3HCBcEK1OHgXwTdruvfD9bHezSQrCEjJizAad5G+02sSKZlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSggOYsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSggOYsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF31F00893;
	Sat,  6 Jun 2026 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780774429;
	bh=d0YZPneK29ZpZI9FOSG5LaMJVsgCUEOaINGxyD2R8fI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VSggOYsGMTB+c/JbpXG6OI9kfZK4qMjyXOX0U0DYwOw1fO5m/9aqQ8/P0ZUqRzXQO
	 X/KiOFicwZRsXRqdDZpwvH6q5/0yioCOXlMwcs8Jyrr2AJuVE3C03vOuK4L8J/g2c8
	 P1T3SZM7ATfjY/VVsowfDzti/dZyXh0uSxh6ohyR+WPv0k2Il+l/n+JXamCLNFq+A/
	 5cn7TGLWQ+EyfPKXhdHp1tR2VEbqMybwktwxyayr+DQcO2vcEUzFcOddabm1+gBL4R
	 mJE99H4xyB6AoQEoK5s7c6O+v8kHiL7ETQWSRpwJOOGEhnt94iF5oVzR3hJ1H3YtoE
	 jWcydobK/ma7A==
Date: Sun, 7 Jun 2026 03:33:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>
Subject: Re: [PATCH RFC] fstests: use MOUNT_OPTIONS to populate
 TEST_FS_MOUNT_OPTS if possible
Message-ID: <aiRsmJKtqR23Blox@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Xiao Yang <yangx.jy@fujitsu.com>
References: <20260602001422.24364-1-wqu@suse.com>
 <ah50bZRaH6YWTJXc@infradead.org>
 <aiGYgLaQ7_r9LQ2G@zlang-mailbox>
 <aiJM6o982CKp7v_y@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJM6o982CKp7v_y@infradead.org>

On Thu, Jun 04, 2026 at 09:13:30PM -0700, Christoph Hellwig wrote:
> On Fri, Jun 05, 2026 at 12:46:13AM +0800, Zorro Lang wrote:
> > Right now, the biggest inconsistent issue is probably with those feature-probing
> > helpers. They often check TEST_DIR to determine behaviors for SCRATCH_MNT. While
> > this works fine for features unaffected by mount options, but we might should
> > handle mount options related features (for TEST_DEV or SCRATCH_DEV) separately.
> 
> Yes, I've run into a lot of issues when TEST_DIR has more feature than
> SCRATCH_DEV.  The problem is just that feature testing for scratch is
> a bit annoying because we have to create a file system for it first.

Yeah, if we make those _require_*feature or _has_*feature helpers accept a
parameter like "local dev="${TEST_DEV:-$1}" to allow specifying $SCRATCH_DEV,
it would mean we can only call these helpers after running _scratch_mkfs or
even _scratch_mount. I haven't come up with a better idea for now ...

> 
> It might make sense to catch some of the results, but then again we have
> tests that override options for the scratch side so that this won't
> apply.
> 
> I've been wanting to look into splitting the scratch tests up into those
> that "just" format the file systems, and those testing very specific
> corners cases using special options.  Especially as we should not have
> to run the latter multiple times for different configurations.

Hopefully, specifying the same TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS for XFS
can help resolve some of the issues you encountered. But that doesn't help if
your TEST_DEV and SCRATCH_DEV are different devices.

About separating "corner cases using special options", xfstests always welcome
"finer-grained" group tags to better categorize and differentiate these test
cases.

Thanks,
Zorro

> 
> 
