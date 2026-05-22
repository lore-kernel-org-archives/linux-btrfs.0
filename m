Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342F52FE057;
	Fri, 22 May 2026 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451721; cv=none; b=FiT+7ebw8kyWmdtki+jac4EFOqQ2UbJmvCl34OkhgAiZoLbeO96ht5n6JKhMoUh4ko1Ntz0rYIWCEU70LEmjdLSnUgUa6ZChZzgYFklm9bygFWMQ1Ok9MlwmrWIa02enILrx3pWt/keCbDGJj+4lco9r59BaHEx8WBlqUvtIRfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451721; c=relaxed/simple;
	bh=SaeAy17DQz4ZQJdiPE5ahPVCtmRMnexTYkXVSRuCLMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kf/tiBS4L/HEdIpUyvzrXKEPhtU0j2HCyUfUEzrEwnIqhT9ol1XZe5NGRFu3VKGIamkaoZt/9Sl48BTNxy560XQkxkOy1W0wn+XSxZJq0Oa/eJy0IVhg51rJUMsLT9M8ZQfRVTLpwsZp7xTyGu7Xej6jomAX9uU6vnL+8/8x5Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8A8268BFE; Fri, 22 May 2026 14:08:37 +0200 (CEST)
Date: Fri, 22 May 2026 14:08:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@lst.de>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260522120837.GB21041@lst.de>
References: <a1d63733465229936351804f3760803d5894a962.1779274630.git.wqu@suse.com> <20260522085211.GA6702@lst.de> <a8de8d07-d262-4f91-96eb-473fcded6549@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8de8d07-d262-4f91-96eb-473fcded6549@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 22, 2026 at 07:00:25PM +0930, Qu Wenruo wrote:
> Not sure what specific workload you may want to verify, but my planned 
> workload is:
>
> - Create single-data-RAID56 btrfs
> - Fsstress it
> - Unmount
>
> - Mount with one device missing, readonly
> - Do a readonly scrub, should be no error
> - Retry with the remaining device(s)

fsstress doesn't actually check data ingtegrity.  So fsx is usually
a better choice for these kinds of tests.  Otherwise this sounds good.

