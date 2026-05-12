Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E987158535;
	Tue, 12 May 2026 08:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778572914; cv=none; b=fO3fddziBjBlSNiPX982wY7dAiWiudlASL0QlTRUT9bFqx6xbT7Uhmfub5WxhFo4eJ8EAF9hIjV0B80DtlQt+CjnSR5wZ2eBqTiYnKCx8F16qwwIwulZHR8zqwiWuNLkSOhIu3oql366qd0IpdCrTYuiU6uZ7iAPLEe0EisChKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778572914; c=relaxed/simple;
	bh=9fOF9NG9sNtOShx9C8ACn6+YUbk2PL9B32d5xWt27gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IWntWQGpiGvGyh7UDGd5yaQ3szAO7GQe/CjBCnhQN3IMyUh5Z5p2PhzJnCsXqTE2JgKO/k93oJH7R1TDLmtNK2iXK9+1EUYe5S0ODNE+SIgM0BhdQPpnvkEqRlB1zQs99cTIiUr+TCwgdmQE7H4n9t293OND4Us7EwdH9N/D+Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=olHmLIxo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="olHmLIxo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qjI94m8Qked++riFwWLC/SJ+hyu2Wf6SY3/bFqr0b9U=; b=olHmLIxoWiEyIV6DzqayxxwgCR
	Z4wV885pWNVvoeQtlDhg39hvikuWzmZy7VjEioUrwWSOG+ZiXztyzRFyhII1H2WZjo3h/uHMiSnaw
	Ja+15siuFkvFEPLgjZbpSU8rJIT/n/qpaTrnMHd+nMlQs373tFpwp1M0G5dMEN60pE77VHZZafmFn
	9g4ZnV0+dknATzi11MxSsttfGhLRKSyXpJdI7NrQ4OLHl53bTwlMWjPsBXP9QPfNv5i3xSKVV4Ghj
	xg/hWK1TRM3olGsgn5KbMP+o9vuGfTGtm/4H4R2ozPo2drqrifJddxzaUaqJEzDk1rOXWWsqrvAeT
	J118o6Ww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMi3r-0000000G16l-0yHr;
	Tue, 12 May 2026 08:01:51 +0000
Date: Tue, 12 May 2026 01:01:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Arun Rao Balappa <arunraobalappa@gmail.com>
Cc: linux-pm@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
	pavel@kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] docs/power: note Btrfs limitation with FIBMAP for swap
 file offset
Message-ID: <agLebyS918avQT-p@infradead.org>
References: <20260512063713.77200-1-arunraobalappa@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512063713.77200-1-arunraobalappa@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 12, 2026 at 12:07:13PM +0530, Arun Rao Balappa wrote:
> On Btrfs, the FIBMAP ioctl does not return physical block addresses.

On btrfs, and on anything that writes out of place or uses multiple
devices for that matter, FIBMAP is not implemented.

> Tools such as filefrag therefore cannot determine the correct swap file
> offset for use as resume_offset. Document the correct btrfs-progs
> command to use instead.

All of this is inherently unsafe.  File systems and do move file data
without notifying users.  This document is a really bad idea and
should be removed as we should not encourage users to rely on these
kinds of hacks.

