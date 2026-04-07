Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ADC221540
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775544648; cv=none; b=gVD2Tk1QLS3RXqJZSpejVxVzC3gznqkGUwui8J9Cqo5vN6UF8ZPgdkhkKt+M3PO+1lcOizb7nGhgchTS0Btr3WQhti0B0aXqSmRjc1TVMZ6wab1ESufK6sKJkhYsd2Dw/SYBJDYmCZIxCDK9/PYtDZ4/7cvpLm5Aqxb32yMKIqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775544648; c=relaxed/simple;
	bh=j9AQCO1O/Fad0RcuXOVYEhQkW5OKcGHzEXo/0yreDc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2dMXO4rRl9u8LsE8ruXonEJiwPUoG03NUQPOgWUawNSgWEyfmTwDoMumAn0YuqiRG0ClWfPP8MYwO8YyjKOsJ+IFyoE92QOiJPnYwvghYx8j0g8fn2hi5UJcBhKtkGLJjZmX5wdK5tAjaIH6yOU4AwCw8NNta6/rpiKww0dIOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b2Ol5B3U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b2Ol5B3U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hDjycRkwxCnJ4WwkakoKJkz5g6YGZ37v3ePVA/axM4I=; b=b2Ol5B3UH7l2Cj7zii0hJCz2q9
	E/6pFzyCZezCdtgzJjVm1Rya8ft1IOYT3gidLrbBymrytFIPVoG7fhbU1J+f2sZx5r8hP+i1OPF26
	2chafHDkfPxd2TFTUOOMy/PMP6uXtgZ8pnw4I50ldMM6EdT9j0osDaRfawEq0rS2Pat3PaIjv+wpR
	QgLZbxaGgPLvku+1B8cQZwgffTwfd7e0e/mgg3IoRsYRE/h20zvOtbzQPiul1vZXxYhEkDMJaZ7iD
	wCQzutATvpD0m4d0taxK3YJL8mPKtqlhnqP9PW5kArMprr7b5sDkvVsbGF1AN0cOxRPC4wl+SxCUJ
	+6msrwdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA0Gr-000000061s6-2Juu;
	Tue, 07 Apr 2026 06:50:45 +0000
Date: Mon, 6 Apr 2026 23:50:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] btrfs: btrfs_log_dev_io_error() on all bio errors
Message-ID: <adSpRS6uhH5jrTPy@infradead.org>
References: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
 <66b3a6ae-f035-412c-8683-8f869edad00f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66b3a6ae-f035-412c-8683-8f869edad00f@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 07, 2026 at 02:47:37PM +0800, Anand Jain wrote:
> BLK_STS_PROTECTION is interpreted differently depending on the device.
> In NVMe, it indicates invalid Protection Information (PI), while in
> HDDs/SSDs it typically points to a malformed CDB (often a software bug).
> This is one of several possible error conditions.

BLK_STS_PROTECTION should never point to a malformed CDB, and my
quick search of the source tree says we don't do that.  Where do
you think that happens?

> Rather than introducing new BLK_STS_* codes, vendors have reused
> existing ones for newer device types to maintain backward compatibility.

???

