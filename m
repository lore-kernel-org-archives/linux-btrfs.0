Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D23876D0;
	Fri, 24 Apr 2026 13:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777036954; cv=none; b=G6pbr+amsOpTTR56HhfD0PV0jsYF6x7wRV3a+JQX+D8kvsiuhSX90cVhr04uobuGD1QfcswH+LtxMcgTSIvWe9yqC133gAuqywaR4NzVuKm6H/ZkTvFBEU7mFMZ1Q1HegN+I1aQWu3QFa4jiqi3JPUmDc2pnHOQlryWx0dZf9LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777036954; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=raFf9dLSYAH/ubW2JMWj+7DjGzrYFL00yipsdx4cdHQJsVILodLzSrNniuVAkzcVGXN1SwKzDcnybjIrNjuDIiVNiTuOv1adAO8R57zHT9TpLybDlQXYw15La0pupCuFnKTmTseH6kpqVOdv46LoBcGgSvrE80oc1cbDSBGklJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F2CEC68D05; Fri, 24 Apr 2026 15:22:29 +0200 (CEST)
Date: Fri, 24 Apr 2026 15:22:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2] generic/793: limit number of overwrites
Message-ID: <20260424132229.GA15784@lst.de>
References: <20260424114819.177805-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424114819.177805-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

