Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F20033F37F;
	Wed,  4 Mar 2026 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772637937; cv=none; b=q6J/oF2iJ8Po/zvgcGz4m/ZzwhEDfQeVQUszFEtMO32snivLS/Ob76KcWtxZvmKOxOXmS0+1VzTTFjfEq8lI3EAp1hTjxj0vxB30/N6TCHpBrYa/9Ls+1bE/yaroU9CDnR0u8xMdwlpDBJVNh0iRmCSC1FbMdH9B05AB9s979WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772637937; c=relaxed/simple;
	bh=3TMcHI3fpBXUKGV1pTVwgnH6e8rfMQ03ftP6Od4ORtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+r1id6Gy9M2+/bdyBCz9LLA1p/UxPbmbqNwsvlT1VnuDE87o5Nv/FHkG//Xs1oE/bkmLom35cbT1FlN2i4DWMZLolwqIUJ01cwNkioBEG+sqaYJvVklG1Jq25x5ZMdmbKR/03kjRUo6+ndxJg93WjtG/cEolIDu7IuDs4uzleI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BxpFnBOw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BxpFnBOw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MwsrxkPOXCaYkQX0joRl0M8XJJY5G8w37JtoiYGpkHw=; b=BxpFnBOwTfdz6+tAMVJtZ+EGtr
	/nLSq3ik6/oKx9A+1Ujp0looFVrCTaJsxpQ1dixrWAqfObLrOM6aeWdtDj/wqA3X9I7bfpw62DMv3
	FDq6IO0jhJcpwVJqy2+ceJXuI/n1o0aeEfRjrRLFdo1ssDaRzucz4y8OGrLQDJDw4ejPJOT0fPneU
	RawkaeEkEVterh7YZfYywjnQWezyQkeK31fd2NiTA+pWeOrs81JLKH/sOCk+tOJf7JzrYMXLvjiKs
	Vcz0hgbeJmvyWsIgN+i2LaE2DYsJ5hmYDJvPB1n2kYbd9Fe/LCJHMmyQJE9RdjeOwF6U6x5YO2XS+
	pdYES3oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxo6Q-0000000HXSZ-0pJa;
	Wed, 04 Mar 2026 15:25:34 +0000
Date: Wed, 4 Mar 2026 07:25:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fdmanana@kernel.org,
	fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: test a directory fsync scenaro after replacing
 a subdir with a file
Message-ID: <aahO7rnnaYg2MQ1o@infradead.org>
References: <8e3c1626b6e49678976db67a861cb5dcfdb532c0.1772558357.git.fdmanana@suse.com>
 <7997e07a4f530bc52edd1b93e662907c4cd07377.1772561118.git.fdmanana@suse.com>
 <aaguMUK6TgYfwtZk@infradead.org>
 <20260304151800.6qkmxjsufen7sbq4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304151800.6qkmxjsufen7sbq4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 11:18:00PM +0800, Zorro Lang wrote:
> On Wed, Mar 04, 2026 at 05:05:53AM -0800, Christoph Hellwig wrote:
> > The subject is wrong, this is actually a generic test.
> 
> Yeah, thanks Christoph, I'll change it to "generic" when I merge it.

Assuming you also pick up Johanne's per fs fixed by cleanups, it
would be good to switch the new test over to that scheme.

