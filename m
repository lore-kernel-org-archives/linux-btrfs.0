Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C387035CB73;
	Wed, 22 Apr 2026 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776873330; cv=none; b=M8ZCEDC5nYLJLV4KCBGZJyenV8Pgc2MHx4dhK+r0uI+eGLc7Lx0fr8+7Af1HvWMFXbnBmFSo/5MPuBB+fCKdQ51W+FhgBxbJ3K+lJuKfVo8+9BcewxgP+9ERV1La6nbf5c+j8hEcfqFSOcJXauK1JdrVjlNXwYvU4ovTGSlI2gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776873330; c=relaxed/simple;
	bh=H53Pi2+KL5AiARyZw1kDL912O/VbBph3HnqhpcmZpKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NR2o3Zv1I4MA+R3ayYOdp8PCbcOn/FE7Hi2NmHRYmu/ahMtkNYZtekB9CCh3bPlKCuNXx4NJEJFLF7na2nR7Jdd6QbKY6Zei23edlpdVEIyn6bvaixAke5dxzWTtn2iaXt1pdZdJNq60fdlk2TTUVCxuDiRtcWTrM7gUFD7CvlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUxgwOMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUxgwOMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B65AC19425;
	Wed, 22 Apr 2026 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776873330;
	bh=H53Pi2+KL5AiARyZw1kDL912O/VbBph3HnqhpcmZpKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gUxgwOMjtQWyujrNVOdu5Jk3XELjxEY1m0xXZGBCMVpV+QJFmog+ROPnRT8e0Tlf2
	 7ioQUp3dmtWAbn2R/D+caNI9uJr9A71aZZvIi5Jqko/ajr54j3qdZUY7SvQOm9lDWi
	 oLATlfYVlzEzgJ9kHEhj3VU5/KrH4wQXgSBqG5wjUf+rCW7M2JnHN2ubGNqCuLJQEL
	 Z3wcCsirx6PZ1JgUR+3OXa4Xbllvyf1p+4ixLszpyz+o65o1EFZUoFA5f1uaW858I6
	 jFUAkchtzPWcN8+lO8F0PVOmYhHEjbLHzOx0aEer+46siohUSXE4x6sSD6YcXD3WDE
	 SasZR/o8Dps1Q==
Date: Wed, 22 Apr 2026 08:55:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Disha Goel <disgoel@linux.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com, fdmanana@kernel.org,
	quwenruo.btrfs@gmx.com, zlang@kernel.org
Subject: Re: [PATCH 1/2] common/dmlogwrites: add _require_logwrites_size
 helper
Message-ID: <20260422155528.GE7739@frogsfrogsfrogs>
References: <20260414102031.74527-1-disgoel@linux.ibm.com>
 <1e1e374a-d9ef-4e0f-843d-09f292cddc57@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e1e374a-d9ef-4e0f-843d-09f292cddc57@linux.ibm.com>

On Wed, Apr 22, 2026 at 11:08:34AM +0530, Disha Goel wrote:
> Hi,
> 
> Looking for review comments on this patch series.
> 
> On 14/04/26 3:50 pm, Disha Goel wrote:
> > Add a new helper function _require_logwrites_size() to check if the
> > LOGWRITES_DEV meets a minimum size requirement.
> > 
> > This is useful for tests that use dm-log-writes with additional space
> > requirements, such as creating LVM snapshots during log replay or tests
> > that generate large amounts of logged I/O operations.
> > 
> > The function takes a size parameter in KB and skips the test if
> > LOGWRITES_DEV is smaller than the required size.
> > 
> > Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> > ---
> >   common/dmlogwrites | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> > 
> > diff --git a/common/dmlogwrites b/common/dmlogwrites
> > index a27e1966..1ce2b2fb 100644
> > --- a/common/dmlogwrites
> > +++ b/common/dmlogwrites
> > @@ -14,6 +14,15 @@ _require_log_writes()
> >   	_require_test_program "log-writes/replay-log"
> >   }
> > +_require_logwrites_size()
> > +{
> > +        [ $# -eq 1 ] || _fail "_require_logwrites_size: expected size param"

What are the units of the size parameter?  Bytes?  512b sectors?

The helper should have a comment clarifying that.

--D

> > +
> > +        local devsize=$(_get_device_size $LOGWRITES_DEV)
> > +        [ $devsize -lt $1 ] && \
> > +                _notrun "LOGWRITES_DEV too small, ${devsize}KB < $1KB"
> > +}
> > +
> >   # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
> >   # that it doesn't track the data that we write via the mmap(), so we can't do
> >   # any data integrity checking. We can only verify that the metadata writes for
> 
> -- 
> Regards,
> Disha
> 
> 
