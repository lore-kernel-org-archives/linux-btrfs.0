Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779886;
	b=BYODS6XbVxlGzMRl6Obva6ug2lvwu8MDBrQxeEKlgTnoF2cYbucIQpk32cz0wFWbOPt4
	 X9knCswWeFqxy6xLePp33YqayvZAuA0UYfqnrW2huLShYS1hkt6wkQIvEzXlSYNpcoMBL
	 STToYoIVexB8gMXaYBon8AiROE75agh0Ms7a6Cg9dP2cYznqrkOYAKCdqhE6AINdSnABN
	 ECvdrEoJhbZv7lJyAbDE9oTMgIVVxslrmiHUTlN0fOIH+4ZA9eTZfoKCRVAIKzCRnxeGE
	 Hi4TOyDR/rTR75ljXOoPc7bnCNmV0O5HsCqPcGQW/BGRzR7T7Nt/ueLQjyBbdJa7lBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779886;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=A97GxorY9Lo80fl9vkb5cEPK5PAAMnUd3y/xEzq9gHI=;
	b=mCwomKpGSBPp15ej7z1IudMRCZ3k7mm05yfdHWWRi8Lgv1xHR1B2t50aUqCKLaaKqIWz
	 hlusE+XlNw/0AXr26KZMM5TF91/a+ZHOviGxwpSbHD8q+89W8ungDPyGS92A2tvaoP/Tf
	 SOufT7xRHJhpAK2VEcDuZBgYZWeWJqGr+Tb9eW0w4gemI082VHR3VtejqpEdQp9rp/WQe
	 l0zg4K/qjhXZT79xxGp5GHqn9n7+MroP0q1JlUV2JIqkepf+9BYkE6AMmSkAuAT+gHdCr
	 0mNwBobkYZMQFquxxIXbVnqou65nMovn6qGmP3aiIQ1rIkiCgHg9mS6IMXbiSm8b8vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jYgnlCvk;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0A7606A326
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 08:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B0A7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=jYgnlCvk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A97GxorY9Lo80fl9vkb5cEPK5PAAMnUd3y/xEzq9gHI=; b=jYgnlCvknhVzmFY9/8uu4tRZkB
	/At5GAiMKRE1aEqJTt46Fr//RdKJZX6E0HYIw9s6n2bgjRVXDMBXV0N3RpW5ptAINCVAMJO1UkUvR
	4wfuC8yusXLUqA/pi10yCCItodbrd7K21MDooRc4oed8MFf8bAmoNZI9aAjZEoWcPuYjpbrVGmuCV
	VTpj1Y5tLQbTxDZ27DHxcNv+ScTH4wYcy4lVPpD5cLjGV2Mu3NNrXaeXPR2u55LpRSYQSpWkOP7Se
	jLvAQzOS+1fUFAVvJWMysmfdE25XQYsanLu/GpjZvf2vD87hyYNT1mUd8qERf50BPBb3YYtSQDn5F
	keP6IKug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOW5c-00000004fG4-1Tm1;
	Wed, 04 Nov 2026 08:11:24 +0000
Date: Wed, 4 Nov 2026 00:11:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
Message-ID: <aurorIaI3EAocPQE@infradead.org>
References: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
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
In-Reply-To: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 04, 2026 at 05:40:46PM +1030, Qu Wenruo wrote:
> This is only covering encoded IO, not direct IO.
> 
> As we should not mix direct and buffered IO in the first place, fsync()
> definitely counts as a function in the buffered IO family.

It absolutely does not.  fsync/fdatasync covers all data and metadata
changes.  It is a fundamental part of O_DIRECT data integrity
operations to write back metadata and to flush disk caches.

