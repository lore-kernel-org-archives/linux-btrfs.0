Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794411260;
	b=eZAe9nOy2ZgPppkue0OA5bt1R1Z9HdiVl2Os3TSuW3DsWfFrafOveT0IysR1Oc5vAmZX
	 RxQaf1LYGQ2O2jBDyorrbfflJRC9Y89mflesf0oKTXnLzl488H4Ro1ykeYnSewL25H/CJ
	 DfBqUwgjd1IDOGtzUOaaQjTDg5EMCdQqjFM03Y6MSdiQvmX5LsWoBm8P2sZi6UnHDDIlM
	 8102tGes2af3EeXQNREXbDxv+Qq5m6n97UCbU0XPcNbHBJQlarXVb4WmVWlrdJG1CqpjA
	 cTjuMJFvAwjQaG8RKJphFmuYLUR8FBp9Oq9aDJmrFIssL8/hj8RNgzTv74mtf6gVs+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794411260;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=EzK1hNSMxo32ItZf4bkuFg0x82A1x1EKC0sDK/fhMS4=;
	b=ejRWjsNcPY+D5Pf4T6+V3nmSKXgz4NVTcXhs/Y24XZh5728/EKUSPYutwd54ZOwLESDp
	 dQamKftRBOPbKIgeYX9upSYnPeuYCDvNmowCdgm60PPMzZ05roBD2se6djmb0rFw5r9dH
	 VIRaTOwdtsijIWiO5G6dZNtZnqGUNjwDl4ZpsQx0w/AK5lLCrAKAnFCXtbbHKFPH5C7IS
	 peFgvkfw5woCydGUSakvNltx3cy8XYWSGvu5T3JrdEJL4kSw+oodpd+sOPbJIn7UJbksq
	 nhqZWQPJs9f9Z4WpTzx1OhttUsE/TMLg5dYjF6l/BTh5KgDIa19TcNYJVimbKzaoZ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=gBd7erp7;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA7F606A326;
	Wed, 11 Nov 2026 15:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CA7F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=gBd7erp7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EzK1hNSMxo32ItZf4bkuFg0x82A1x1EKC0sDK/fhMS4=; b=gBd7erp7OJf2pLw3ilFv6e8Q8v
	ksbxnJaOih501hqS1N3dC/Zb9pLgQfugaBsv6VQn2Dyw/kqqj6pvFuReYLnyKWt+uAM+CI3rJAOnO
	TPl+3o1pK4SxBPicQ6qz1fEAJT8pTK+L/ZIIHTI6bPuZC62kAGdtZoh4PSZZGxwHGFcdrcmUmIk1H
	KG2iW3odUt41hsTCo5Ng9p2P2y6/IEoyjwS4J2NbGfgknQFB+uNeN7U2traYPxNypDPgzb7KNdjZH
	cApMoEEKKRAW7TwlSP1eTK0gAiuHTNCWuebni89H9YCkxPw7UAFsg3/G32zFp8MZ0jDu/0WLJ0kb9
	rU9Bx28w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRAL0-000000075vR-0pFt;
	Wed, 11 Nov 2026 15:34:14 +0000
Date: Wed, 11 Nov 2026 07:34:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH] btrfs: test that fsync on zoned doesn't fail with -EAGAIN
Message-ID: <avSK9s4cGKqqLpDA@infradead.org>
References: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>
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
In-Reply-To: <20261110095911.2013053-1-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 10, 2026 at 10:59:11AM +0100, Johannes Thumshirn wrote:
> On a zoned filesystem, btrfs_start_transaction() forces a transaction
> commit when the delayed refs reservation exceeds its zoned cap. If the
> cap is still exceeded after the commit, it returned -EAGAIN, which
> fsync passed on to user space.
> 
> Run parallel writers creating, overwriting and deleting small files with
> an fsync after every write on a zoned device with a limited number of
> active zones, and check that no fsync fails.

Should this be a generic test?

