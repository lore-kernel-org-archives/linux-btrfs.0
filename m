Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781984;
	b=vf3uSmITNvF0MkiMpC1saR4ZPmwXzvW2UMuqCLdhbXb900MtuR5MtkoRS3fsgzvSNQsF
	 RGCo8i8yprQgt5iPqZ5BmRQ9TeUMIjlZhfyMkg19OS9cfnd9z7Lz+AQh4+vrmQFPlPxwE
	 vjvLf54qJvueRg+O+ATU81+bvLlb+4yjGMOyp/woF+B0XgQVOtf+s8DQnvwlFrX3/quq5
	 jPUpRVG3Flad5mqxre4E7VvrhtiiPSrhvqRpkpvPQCSpGMY0GE1/5s2jNqXI04Ng44uTC
	 6C3DNs9DM4EcRuDT0RNj0TV9xd6+I0foblXhyd5zaSz5E6SjlKX8vc7m5fLhE+tI70A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781984;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=jth1TmyTud5UCEFQTt3Qar2WS3gcX17D6HqaaNvengI=;
	b=aD4tmHS7vyPGd3CNHicXb5Omckxn0c65g5NZu5xiQ04Cg2nGAbfUjrO1tkgXawXPK6ur
	 eY8LbHOLkpq98caYuuyZ02e178Ha107+wJqtoKlIy7w817vjntc0XQY+5PEQFT4v6I7jx
	 U4tfnQOIVuu7x9cDSnPbOVa4iH0b1+XA/R/9dJiLUCUlXiDzCK45z4JHhyQ0gLd6GdMLs
	 UP7HXwwfNviCrh3K6rfsmn873VMSRYcaXn7fE8OkNrbuBZ+YqE7I7n8hNNlcZ7hm2W89L
	 rO/r7EaLqNMo5s+CKGQH+kXb/K1qHBVb7luSNxl4FQnS5QneX8s/kb9EUmv1/x+vEPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vvDpXZaK;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECAD606A326
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 08:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ECAD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=vvDpXZaK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jth1TmyTud5UCEFQTt3Qar2WS3gcX17D6HqaaNvengI=; b=vvDpXZaKAXLQzmyDQz8RXTCxNT
	9RqRM9XELqewVEm0V5hNYiY52DSvtNMUKiwfRQgq2Na+j4RqsE1pLsd2Oe8re7D6817bx38Cg0Hj+
	tISzUX3ZQcu5JMY3IbK2julFwyV4pSZUY16WnByzofmAevArJ8F2ExqYYDgjGdxn+qFhpzL2+yk6F
	KNrrxEiNOgAOM25btqiTYawWGKZq4EDdZeg3qCG7gakr/Z+BeUMlsgD9RUEszhSL+aRRzeXllmTl5
	4eHh9wrpFlVLZpHGeRdjCfTLBWL+zDdoZrKCUTDE0RjDpWOHs9zZQYqDIyOk05/gu3jiddMaQkEZP
	fHk9hp5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWdS-00000004kgK-2Pgr;
	Wed, 04 Nov 2026 08:46:22 +0000
Date: Wed, 4 Nov 2026 00:46:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
Message-ID: <aurw3n4G0fxBG4Uy@infradead.org>
References: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
 <aurorIaI3EAocPQE@infradead.org>
 <514c3590-27bd-42e0-b248-ec422a58e502@gmx.com>
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
In-Reply-To: <514c3590-27bd-42e0-b248-ec422a58e502@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 04, 2026 at 06:44:55PM +1030, Qu Wenruo wrote:
> > It absolutely does not.  fsync/fdatasync covers all data and metadata
> > changes.  It is a fundamental part of O_DIRECT data integrity
> > operations to write back metadata and to flush disk caches.
> 
> Even if there is a direct write in the fly? How would you even detect it,
> there is no dirty page cache in the range.

In-flight I/O is per definition not captured by fsync.  fsync applies
to previously completed I/O.
