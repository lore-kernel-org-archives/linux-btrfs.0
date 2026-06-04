Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE2672617;
	Thu,  4 Jun 2026 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780610297; cv=none; b=KdZ6v27cjE23c/k/oBpQVCD/WTtV0UuT22JmUp8gSkEtTrRTnQZlkwXuhaV9kGYUHZOL9ObITCs2/hDRTnNvYbnylQqWKSBeHLG1W7sQesC8+t/8d/Rvrq8MzuxA2lzsfSp9M8cm0ppR/RxUYFOCGP32l5f9R/WLD1FsO12XyCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780610297; c=relaxed/simple;
	bh=sJ2gs0iWKtFzLeY7ppQ27uJpL2vcj8ZQIHvfHOu21nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7RU6ES+cza2WU2YDIxyB4JuOQNF9nlxtgzjt2rjJC9tMRLQGkRJlbVki9fYrmP4WWXEnxbZUX0/TLVUnTrfQFL9cjRA/jPIfdCcBwh4iKZRJrA1EyhUeWLnWpivAvg8TBCmYRryu+p+fVCwEOJoCS7cRAZ5gArkkh9NQBXTgwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IT3czvc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IT3czvc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02F51F00893;
	Thu,  4 Jun 2026 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780610296;
	bh=+NtzD7huikBQhasCXN6+eHwgst6+AN97QTPuCTFbc4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IT3czvc0wslMIC/p7ZVE19SxNSe5vA58WXSGgKBeAOn/jr5CULnTXy4nwSEG39JKa
	 AwwDdnvtV1ss2zIHoX3DmWq3H7xRnAtWtqeguE3znHrDKk88g9iQWfaxE6qmGLguSA
	 N2hSUBViL1OWSV2uCmOM4jh98+zuZNYro2Cug60czCvzXIOUmDPxhCzykK7qKauYs4
	 WGtVQ4ED5K2ByYujO19iLS1PoFgKRXR3rADIQSKlaM1aHlWkEKMhn7DM2NAf0DdmF0
	 k3lCDYSyStw6oslxGOOzr1mPMIyi1lYyYE6h0Eno8mFl5JVRZ9UbJ5MVYiKfIbwsfQ
	 QK3jn30XWDG1w==
Date: Thu, 4 Jun 2026 14:58:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Breno Leitao <leitao@debian.org>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Drop WQ_PERCPU from ordered_flags in
 btrfs_init_workqueues()
Message-ID: <20260604215811.GB3915915@ax162>
References: <20260601-btrfs-fix-wq-warning-qgroup-rescan-v1-1-aff9a1128f27@kernel.org>
 <aiFKsSlaq-_VBGtZ@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiFKsSlaq-_VBGtZ@gmail.com>

Hi Tejun,

Could you please pick up this patch for -next to clear up this warning?
Not sure if this was on your radar since it is a btrfs change.

On Thu, Jun 04, 2026 at 02:52:38AM -0700, Breno Leitao wrote:
> On Mon, Jun 01, 2026 at 07:46:26PM -0700, Nathan Chancellor wrote:
> > After commit 21c05ca88a54 ("workqueue: Add warnings and ensure one among
> > WQ_PERCPU or WQ_UNBOUND is present"), there is a warning from the
> > btrfs-qgroup-rescan workqueue at run time:
> > 
> >   workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.
> > 
> > WQ_PERCPU is included in ordered_flags after commit 69635d7f4b34 ("fs:
> > WQ_PERCPU added to alloc_workqueue users") and WQ_UNBOUND is set in
> > alloc_ordered_workqueue(), which btrfs_alloc_ordered_workqueue() calls.
> > 
> > Drop WQ_PERCPU from ordered_flags, as alloc_ordered_workqueue() notes
> > that only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful.
> > 
> > Fixes: 69635d7f4b34 ("fs: WQ_PERCPU added to alloc_workqueue users")
> > Fixes: 21c05ca88a54 ("workqueue: Add warnings and ensure one among WQ_PERCPU or WQ_UNBOUND is present")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Reviewed-by: Breno Leitao <leitao@debian.org>
> 
> This will solve the following issue I am seeing in linux-next:
> 
>    workqueue: btrfs-qgroup-rescan uses both WQ_PERCPU and WQ_UNBOUND. Dropped WQ_PERCPU, keeping WQ_UNBOUND.

-- 
Cheers,
Nathan
