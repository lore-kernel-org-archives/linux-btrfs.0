Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FAD3BE645;
	Mon,  1 Jun 2026 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780324841; cv=none; b=m+QvQ19qWp/FQvSf/x0R8i6Q/LhbAedQpBYi7Mke8h5HmifAjxIPaza0IomD9BL6/cNP647guF4DoVvkNvCAVcfg/Goohr6wR82NSQxuz8VZlnQO4QDU29hNz5lt2QnIOWWsf1pByBqT+gaLE8DkBDkhnffqKEXMV9rWxubOpb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780324841; c=relaxed/simple;
	bh=4ljzOdHMm9OcvDs8tZ0hAINRuhHXyEj6CbPzt582Qec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RKRBGXzUTLpe5Aq9jIxK8FYKiLrz3eLfeG6LHr8fa3+U1o6vgjLNFutQ3u0zt4U1o6Z3oA+t+DZ3dFqMNBjN5q9CPuDhnMUvsNze4lGiGTVP4eMIhGKDc31Cko7WooxpeZSiFzs/oXjrNzJ5NlG5qanECUyukLyWBNrFq+U86B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 891AF68BEB; Mon,  1 Jun 2026 16:40:34 +0200 (CEST)
Date: Mon, 1 Jun 2026 16:40:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Message-ID: <20260601144034.GA4918@lst.de>
References: <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp> <ahRocb0Vs_m6RF_O@fedora> <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp> <ahZGxoI6oHQ_vSrx@fedora> <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp> <ahZeYQ0cLE1i8TGs@fedora> <fbb3edda-f108-4e5b-acf2-266f043f8125@I-love.SAKURA.ne.jp> <ab5492b6-a053-4e3b-8c59-2e836ae85bc4@kernel.org> <20260528083848.GA7694@lst.de> <36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36571f8a-4df8-4152-b078-d82dbff4ad7e@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 28, 2026 at 07:46:24PM +0930, Qu Wenruo wrote:
>> e.g. 9c7504aa72b6 ("xfs: track and serialize in-flight async buffers against
>> unmount")
> Considering the xfs fix is pretty old, it's before the fix hint thus no 
> such mention in fstests.
>
> Do you happen to know which test case is for that fix?
> I'd like to adapt it for btrfs as a reproducer.

No.  Adding Brian who authored that commit.

