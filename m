Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8B342CB6
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 04:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778819930; cv=none; b=FPpRB9w7PxSKi0TwpXwFjJtmq14uQZi5YuwS8Ju/N161mNG5ScO/aSxGtQfLMRm/4Oonh39Aj6Dq5kCgXyR12qkTkv2PJgitd6FFngPp/DKYLBDpl9dzWV31ByyH9DTzZp4r2vMNVQQ5dI8ELhchhsdlUT+nuMPjOKXnIKRhN2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778819930; c=relaxed/simple;
	bh=M3qnWJgDzDVo4IBa0Nz5T4+hrty6cJ99lGf+ulXoDgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXNU/BxWkfjqQjSU24gxaFR2a03o5XV3MPqtMTHLJn47I9VGXYAa3yJb4CsdYXd31usFH5+x4b9dQgODLZRPENTxIxfKfkXGFriIvwvyDyqpEUpF0jdMvBE/K7vjX4jzmU+zU7VRs2UpSXgbltFQLqySF5hzb5PKnI2ZxsBsr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29B5C68BEB; Fri, 15 May 2026 06:38:46 +0200 (CEST)
Date: Fri, 15 May 2026 06:38:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] btrfs: zoned: don't account data relocation
 space-info in statfs free space
Message-ID: <20260515043845.GA3936@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com> <20260513123445.43197-5-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513123445.43197-5-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 02:34:42PM +0200, Johannes Thumshirn wrote:
> Don't account the free space in a data relocation space-info sub-group as
> usable free space in statfs.
> 
> This is misleading as no user allocations can be made in this space-info
> sub-group. It is only a target for relocation.

Yes, this sounds very sensible.

