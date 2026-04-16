Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB333BBD1;
	Thu, 16 Apr 2026 05:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776317095; cv=none; b=PtdcnKxJOVglwGA9qqm2nYx0ZueGvzU4ZNXIyThjWmiKVnyh6x74eSi1dXpGy5w9eWPqgM4hRHkwSvz4kdzGtQBlB6B8oDXUjZfZkCLSOTdHCdvJg0Oi3iEnrTqI9Oxvixv1iq8JDROTDgpqs44Q0/8ih52Ak4oKv+PJjAsowf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776317095; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xi/3innGJRFHu3rMhPelcwEe+O9X4UTh/76nThlv+qX8E8xUAURC4EJt2oKv0g1iL5NaVIdbFYV0Z3lJW8+/Ni5VAWFyWTVbHb56Cdqq+KUvt/W3JP3ZpmmNdOkPZ7H+hwAQspcwv7ugkDvo14vBZuegijZPczjuA9jmvJvlRFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 256276732A; Thu, 16 Apr 2026 07:24:52 +0200 (CEST)
Date: Thu, 16 Apr 2026 07:24:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4] fstests: test premature ENOSPC in zoned garbage
 collection
Message-ID: <20260416052451.GA15156@lst.de>
References: <20260415104015.209741-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415104015.209741-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

