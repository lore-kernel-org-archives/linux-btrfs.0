Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415212;
	b=BsWLpKhPUfWFKUVRwc9nt+6JENRt27FWzullKR+qmexGq7tf94bIc9jlZPOaNfnOGopa
	 3Csfj+5bzzDrsW/vp4hwxd3YXIjBzaVEFuxRih1vunVYdVwetm/7oPm8g2V/A2rdlhVHt
	 kxHRJDg11oqg2UJvUbj2RgZop4qc0KL0CqyowSW3U9Bs93YEnxgzc06832PUn+RU+vcfo
	 +XNI5NI3kR0uaRm/jk5pS8Ir/lqr6wz/LcldXvt+yWJa5s+W0Dqn4e86g+415iC99THnH
	 cSEN0EYxlPJ8mHjK/JLNp+YG6F6Snv6OXpggwnEdSTT4pXRQo7c2rMJe+PC9bkJEfzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415212;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=XTaoawpfG2/m40LWjnwn05iAMQHX3ni6C1Ea2/w/CsQd5OLEOPGRP6CPgJS48fStr9Hl
	 oAcu4rAVDy5r+un9aPTGoAeLZgVa9wdRSlWEkf18oKhY24mhzPsnGXh3yribwqQSMs6ti
	 pBazSjunxXhiVkmAPg1uKqV3wwtkZfsWkVR9oPForxby9I8qCpjAv5xfyFWTe47WqgFkq
	 ylqN77JDYTrOOFTYpdfBP+L8edvWvgddiRRlBeV40wwfIJjM11M5EQPgJCPNPmVc/NcYp
	 f35zuOPtLTLVUYb7kMu9p3HpGB/Tez/DkVXTFlUEO/GXMo9cHnAxDzOICenjjrHa3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E8606A324;
	Wed, 11 Nov 2026 16:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 442E8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37DB468D17; Wed, 11 Nov 2026 17:40:08 +0100 (CET)
Date: Wed, 11 Nov 2026 17:40:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] common/zoned: allow setting the zloop device
 capacity and extra parameters
Message-ID: <20261111164007.GA17968@lst.de>
References: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
