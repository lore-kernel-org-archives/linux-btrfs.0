Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A383A4538
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160503; cv=none; b=Axd0Z0Vo0qC9tCETwCc+WkUqjdBWhchSYS7GX6J9K8C2kcgh6l1L0eKDMyrhwbfie4Ll6qRiieIczw488EYm90VmnKJzR8cLYnNbj5SiTZiyCGK5OHxaxKaduEccLO8yPUP1gsjcA1v3csmxuooBM5CiU9OeTBj4v1ddKnzbjNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160503; c=relaxed/simple;
	bh=RbTlK4ywTUNYjTgAxKfZ3HZxrZae1YmkT5zcudQhUXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/fUfvxNeMM22BMLgOi61m7BGuFpIBLwqmlB5fGpT+S0PiNy8JF5xdDgAZFyg/+1fv7naE0oPrIv5ZGb/xaqUMs+XnZZRqHHXxCdmxv3DQDcqN02X1N1KpbntyUkj+/NtW97Gu+snZvmgQCxDDe0seM6KKpzS+kAcRSTL4y0aW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pyv7nv7O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pyv7nv7O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=31D1ew3DY7aDJ9/weeKgxdDhieM7js/RiHkJSonCwxA=; b=pyv7nv7O2zxLIoDz2hbcltbGV4
	eK/Dlbkg7Fe92Qv+1VpBdr6HakNRGC2JBqyHznTwEoq/dzFD8XCA2EVtjquPbykXT5yC8W4lCo/Ja
	7WLcWVomK1Y0qe61wrzafPFzE6ZwfPKdSRWgN5D9I8zQyyl0ksx3pkS22hMPIKkiwzRa/a0kSa5vN
	NIlIP2qDSbLSIntA3t7NU+O+4D4OWpqKMvV/tUoyvpTE9z9lqmMRAsMYwxiBv3mrr+I7XIEjHzxn9
	NJvq2N1YP2y4W1OcF/jnivh4aQug8SZEMWDi8ItsVGKbu7ezRU3CyxaVhodpZA5bID9TLAmbCIxei
	wUWTNohw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0wEP-00000008hRZ-0a6v;
	Mon, 31 Aug 2026 07:15:01 +0000
Date: Mon, 31 Aug 2026 00:15:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use IOMAP_DIO_BOUNCE flag for direct reads
Message-ID: <apUp9SjdTSAmmzXV@infradead.org>
References: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219d8d9ed105a922d9af6130e08532e2907ea17.1787909265.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Aug 28, 2026 at 06:58:16PM +0930, Qu Wenruo wrote:
> Similar to direct writes, if the inode requires data checksum, we should
> use a stable buffer for IO, or even for direct reads an unstable buffer
> (e.g. the buffer is being modified during the direct read) can lead to
> checksum mismatch and even cause read failure.
> 
> To address the potential problems of unstable dio read buffers, use
> IOMAP_DIO_BOUNCE for dio reads if the inode requires data checksum.
> 
> This will bring a small performance drop, around 7% for my benchmark,
> which is definitely observable on modern NVME SSDs, but the overhead is
> still much smaller compared to data checksum:

Please take a look at the "lazy bounce buffering for checksummed reads"
series I just sent v2 of.

For one this removes the read-side IOMAP_DIO_BOUNCE support you are
using here, because it had problems.  The alternative is iomap-based
and better at building large, aligned read bios which matter for HDD.
It also introduces the concept of lazy bouncing where it only bounce
buffers after a checksum failure happens by default, which means you
only pay an overhead for misbehaving applications.  And unlike for
writes where they do exist in real life, I don't know any that modify
the buffer they read into.

