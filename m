Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8427B34D;
	Wed,  4 Mar 2026 13:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629555; cv=none; b=UEBNu5sgzyhzFqd4WyhbP8SbqpYVbTjzJsmOIk7AmWmwrDPsAk2E4Tpie7biFXYJv82cAUfW56HVI9j8uWsUyfhR1HusXAQ1sBb8iie6V8vX/JoN3+Y5MTYi2OcaBsGddmkgsMzKhOOXK4HTlLy+LdHUgNfOsgSPfLs604ZS7bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629555; c=relaxed/simple;
	bh=qW2uZJF8G4cHoLk9Cs8Nm6DlzN/ieCEqoSLV4RcIMYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUgAf0IPnsVSiXSoR1NTfp0RphUHgQx6BCyJVTJE0YzV0YmQvspzgjdRzZH34YoWF0st7zMmZpwzWki2SNG0t5KpsByClQCldK9eijh+4ZqtODfRh3BAkxlqbh/tyRahes0hdB3NzzZX/szni3g0DPZXjTWTT2CMKErX0gWmAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=plJ2JubC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="plJ2JubC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qW2uZJF8G4cHoLk9Cs8Nm6DlzN/ieCEqoSLV4RcIMYs=; b=plJ2JubCqQsE10JJqIV6r6+s1l
	H18neL3htFlBJZt+BoikcNlhFTNG8636WAfL3AuCltFCSR6bwwICOyqUswL3ZEth/zF7A/QS7tXjR
	PZ9T9Q8e6515cwCZXOs7CEs7znDavLpcKivV2uKK6cjTyBeqwQD+TKvcJkp5eBwPt/LdQV7HHqViw
	x2hueon8YnthsdvVWeToPVwptMXgAl4kf8DO2fsBE0q2e+4r0XGpq0h5zfLQisNjNnuEwoLPkcEKi
	3kwilUjfQMwqS5L1JoayHDoM85ifpyQ3cAzU8/Ab4zBhOU26wxn1BOQWsyrkAeIaL5norYeqCz1GZ
	DtM7dF8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxlvF-0000000HDkR-2iUg;
	Wed, 04 Mar 2026 13:05:53 +0000
Date: Wed, 4 Mar 2026 05:05:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: test a directory fsync scenaro after replacing
 a subdir with a file
Message-ID: <aaguMUK6TgYfwtZk@infradead.org>
References: <8e3c1626b6e49678976db67a861cb5dcfdb532c0.1772558357.git.fdmanana@suse.com>
 <7997e07a4f530bc52edd1b93e662907c4cd07377.1772561118.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7997e07a4f530bc52edd1b93e662907c4cd07377.1772561118.git.fdmanana@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The subject is wrong, this is actually a generic test.

