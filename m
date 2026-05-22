Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FCE3AB282;
	Fri, 22 May 2026 08:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779439955; cv=none; b=IviX1Ti542nbbq9B2wHAk7fyFh5tcBUFE7Ih0MwnKhQF/BA/ocfSW5znCP95VcvTmTUjg1bWGkvPPDUWM/Cn4FzmzqG2i4VgA+0OglGdwzoELs5JS1Nrw7FFuC+Z0X5/O7YgRfcgjlQlzRfAYR+Mqp7jjX6BZFfqJng+lEhu6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779439955; c=relaxed/simple;
	bh=2TQQl9UZw4gX7irz1cO1vHtyLtPiVjtLfhgexJXeWlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRIqEiFIB9nX59GJ1/M1T2M73rh4ZN/X82IFXKY8lQv1bPF+6iQ4vsidtfp2sigB7exXzD6Ekg4wQzclJiY4AGAKUsiX/AbZmPCmzDdcseiSQRrfpM1D1iQSaFW8pDWRKX1Ax96tqpWnDxJ5x+dDR1gwbGQvVIwxWc1A5yWvD7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 602E468AFE; Fri, 22 May 2026 10:52:11 +0200 (CEST)
Date: Fri, 22 May 2026 10:52:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Message-ID: <20260522085211.GA6702@lst.de>
References: <a1d63733465229936351804f3760803d5894a962.1779274630.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1d63733465229936351804f3760803d5894a962.1779274630.git.wqu@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Qu,

this does looks sensible to me.  Maybe add an xfstests case that
exercises these using loop devices?

