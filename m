Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795189529;
	b=DkHx/0P513+A4Yaw8OdtmR/marLuFkzKL/hQxGWbsJ+yOTtBqyZezVumhLYC/rzoYbHM
	 GKkvQJjY5T6zdLlCtnppY8Ffyd5rTSHJPpWo394aSAxUYrn5sQ59kQkM/9sVOmvi7SVe3
	 GrqkIkchAF3y64ldK5vOmlIJDz1aQtgi7QgpoFkkSpa/ndXoX6qDTjLQCcU8aRu49GWo6
	 nWDdEctT3JdatqEcCnhHKxnNGzDqP3PocoLy0v6g7A+j0sqIYHb/GZ9rppOg0YPTBaaha
	 8glWJGvtzqlkDrvA1L98mnhVq7hfzivN7IprVjdhE0D0Rh0tjZepz/4RR9NMpuzYRRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795189529;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=eoDK2hrqHFW2nQi70GNqj4hfSkbzxKZJkh1V+BN/pIFY+vUB1mmh5g2ZR2MJnyuFb2Qu
	 n/+kp6XiNxeIDa0J9nKXgRHAPgFXEW6rYkq4Ol857nS6u5uZyCY8zIUa6LByMjSBHj85b
	 Vb6mbpdO0OjhLHXHQJ9rScE59eNsa2RqyTJELNBGELT4Zl++2KtFP2f+8CvY81n2gYJmy
	 hbFSKV3yfNKbSf2Ef0AHNt+zQGaPdtFy/kYMk9jzBH0gFacj8K9+Sx9sMNT3mtqhtUWzh
	 dbseARxkHq46T8v9xVmkz72CF4apaUerZvjzst0ndhbC2GFkUIPk8zm+qyTwQLS4rXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070B1606A320;
	Fri, 20 Nov 2026 15:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 070B1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4FF468AFE; Fri, 20 Nov 2026 16:45:25 +0100 (CET)
Date: Fri, 20 Nov 2026 16:45:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org
Subject: Re: [PATCH v2] generic: test that fsync on zoned doesn't fail with
 -EAGAIN
Message-ID: <20261120154525.GA29036@lst.de>
References: <20261117065848.3825371-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261117065848.3825371-1-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

