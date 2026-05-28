Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF0B37AA98;
	Thu, 28 May 2026 08:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779957534; cv=none; b=oVV35wTdqMIUKhp1eChuxhQAr+TJ0v+im0zTt8MAD5ygffzy96OVRg1hW9ndgHP0V8lpux0DLR0A1z/r/I4rg47iE8nEmRqhFOdNeK36b7Ne9lzR5DQYigSIFinpduXXV8WAa745+QlJ+gbspuZYIjYNE8pPRGRUMtHK2JdCRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779957534; c=relaxed/simple;
	bh=ca8a+dPPep6NApVFiDy5bg5dA2X1txktRw3eTJlLHkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTsBgf71AkSPlVKo53vT5wkU9Z3cCUijoHRtpeQZV9zzeRA6475IJDXUeK/S+tL8YVFlI/3/YbYCKpAltY90nOui1Je1gR0d///cERw+FN+QXm0RgrhMlEGqcV/kKY+qnOd1t1NNwNeGIAUuOvLGIawT9r1uaY/R/n4xkyFc4k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC8D668B05; Thu, 28 May 2026 10:38:48 +0200 (CEST)
Date: Thu, 28 May 2026 10:38:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <20260528083848.GA7694@lst.de>
References: <1ab8c579-eb76-4227-8a72-6ec819135219@I-love.SAKURA.ne.jp> <ag1223nAa0wZ8ALC@fedora> <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp> <ahRocb0Vs_m6RF_O@fedora> <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp> <ahZGxoI6oHQ_vSrx@fedora> <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp> <ahZeYQ0cLE1i8TGs@fedora> <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp> <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 28, 2026 at 03:11:05AM +0900, Damien Le Moal wrote:
> It sounds like the VFS unmount call needs to have something that waits for
> sync() to complete. Though, it really feels very strange that an FS can complete

I don't think this is the VFS-controlled VFS file data writeback, which
we wait on, but some kind of fs controlled metadata.  And yes, it looks
like those file systems are buggy in that area.  We definitively had
such bugs in XFS before and fixed them.

e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against
unmount")


