Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6FE1E98FF
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 06:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778480067; cv=none; b=krbzaiCWtU9uDHWRIK27nQGUwN83W7m8sKcsFnMYyeKQhWQKkbC00hc14pGeUG4uVWJQ1MC979EG0F5XGjQNEaj4XmOZ2JcPmnZEKtjPyF23d3bWHxhqh+qAUGqKFKgWoxmcd1DroY5PsZ9rRjt/2LKCyL8xMM2b+Dz36cHpM5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778480067; c=relaxed/simple;
	bh=r7y1hwvZsm7VTHfXtRu93poOIiLADgJ+ViST8qMixeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXL2KQPwxgsEwzVRv2onn2s/Ops68PPhubQlnGzR3ngKenhra4CS8FzGU4jALgeHnCNqRMtm6mx/RCcDFhO8MDuFbtr+kbBn0mdJic0yL9FrBW+c1q2eDGh668Go+BTrcxwOmiHjx4Wo7HdLaXzvUm4o3Sg6jnNfyf1XinHJhxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ythQRyqY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ythQRyqY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r7y1hwvZsm7VTHfXtRu93poOIiLADgJ+ViST8qMixeU=; b=ythQRyqYlFEhJTej7ClQtKa1S1
	vZ9msDp5l2ShOWSNJr44geOMX7EG0XfZVRgqYA7XIiw4iHlQsMRBDjeWQg0BIRMRNt7CYqDdPGweg
	PJL11MF1e9YOaAgreYYIjbfhUecKMjqPoAyXxY9PUpN9X4g8TTE/8DXYtFoRArHkHF1NTIBEJTug7
	AIiCA4fEu03cQSlYHiv3fu7P/zy1mZArBr8V9Ld0iSQyt4Sz2VHwAtGzReNL8jsAD5UPWA72Xnw5N
	ZYBsk1HFEkxsf24rS0wNnB/ekzwE2Q5Gdvu6tIYjsW9USXNbDl0aEq77Ad0QhRbApoKRo5QJDLlIY
	9nJoqpWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMJuI-0000000CSiX-2T1P;
	Mon, 11 May 2026 06:14:22 +0000
Date: Sun, 10 May 2026 23:14:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: mark file extent range dirty after converting
 prealloc extents
Message-ID: <agFzvuxD3iOiDl-I@infradead.org>
References: <20260508134215.1716255-1-robbieko@synology.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508134215.1716255-1-robbieko@synology.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 08, 2026 at 09:42:11PM +0800, robbieko wrote:
> The following reproducer triggers the problem:

Please add this to xfstests.

