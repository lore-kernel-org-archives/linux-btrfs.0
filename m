Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E507D52D2D6
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067376; cv=none; b=XCjpTuA43TRkiQgaWTk74G3yvFxoQNSN89cG0fUdxiA5IFTK55V/piWGFAkdeb+1n74tAAFrbKkqSjzPNq7Pleq8P2DKPpfbXT5pL8kRAN2AxPg3Ngj+doIANzoF582ZHMC6rABrfbSAZuaooBEMpFQMcHFD2YPagtoVn49J73k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067376; c=relaxed/simple;
	bh=dTZ74AujbnWToEkdYNhWDDknBgtfEGUv+/3pS6per/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kh4/rWozljvysn7nuQZdr2HoPmIVgJhpyL9O2SIvv/v5rmEjFabWlcbDGHA9ftIz+RiafbLs7kWz8d1P6xqsef10KCbzBtzy4K27itIKi09KnS0N1DFk4+jAt0Dr+CMS5rc2fM3rmAOp9ldBzdzu1TabpkU+457eyfejcXtv8wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPvvBF8U; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZbtqite; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPvvBF8U";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZbtqite"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790067373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
	b=hPvvBF8UC2vymQ2BK4aaMJYkbHYv7IxK1cVV4bzFwLICa+Ra1xa7Pf/TEiI9w6FNkxeGDf
	TBb47Eoa7EQavBcQNr1TNxWSjqergxD+JkARWeamm1/q8N9G0Nwo1iTAXtqvNTAf3sDhvU
	yr4jrvhmfg46Cr2Ciy3xXnW98isuw58=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-qJEVEFZ0Pvu8wvboYAPyTQ-1; Tue, 22 Sep 2026 04:56:12 -0400
X-MC-Unique: qJEVEFZ0Pvu8wvboYAPyTQ-1
X-Mimecast-MFC-AGG-ID: qJEVEFZ0Pvu8wvboYAPyTQ_1790067371
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f52ac21eso2553109f8f.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 01:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790067371; x=1790672171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=eZbtqitewffqEAtbuZvziZPr1toNvg5J/UstrD6538H1I0iyAiiDGGPPbtWAM1HcGV
         lIUnJ1EHJIfDGY5LMGVjjjKJKB2Zuc1ec7j8tAHuhGiwKkIleUKRFjUZx24t3DTpSswJ
         TH7+eZYGzF0+CQS4EhY0FqhNpjCuAat9FgJRxyY/hgBa9Cgt2YvpXv9hH/5rGcWAxwZ5
         WpA6ceg3/mjQL4E9xXnCjMSakIMxHEq6CXZ0n5RYFtAuMebBxuP/AE9hEy+pGFGIrXUJ
         oMwULrLe6l2XCjRk9u3et+3lf/vrFxFYu5cm3x5q3k0pvP8xg9tb1a4X3gCqUYhh6lG9
         UEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790067371; x=1790672171;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovEqrxQiNC1fApdCYwkn/e/ow08kQkdi30NnfIiXj3g=;
        b=jtiyTEFCZy5RI5ombW0YpiCyDe7z6uczYGJH9CqnFNi3VAoBKxw78Kd8Zutpi9+XeY
         9b7FzmEEvAoTTVJcOd0c1NFDT43JY7gVuYKbC501rZK8TKwlALJ9nwed+OP7fC9cnmNS
         zf2H1kt2Gld6wkqIKF3IlmAM6ipiLBGokg9Ad2vrhntDocp4zIAdL2UCNae3jQW1UB4T
         AR9MS3OnPPTmgpTJsL0THpLGquNDQ4ZNJihYfeUyyIIilg0MgImCzg4j9BGx5Y4MhSCJ
         vogYWWNHqHkctn4MYUkYJYQGsXWDUqNcpOZJGne+qUoUuXsGLvNYpkXup41SGb5m0oeJ
         uMbA==
X-Forwarded-Encrypted: i=1; AKwUvBzUmgL0jbpIS0zj0/7plQ/VpHKfkocWa2XuP6pMATf0sAzV4wyjto8P5UXRIxwhIKWJEjjzoI7PZr7H/g==@vger.kernel.org
X-Gm-Message-State: AFuF++nMPJK+pZOqsTmFECgx6VXElcM8ra0aTYaeWZjJ588pcKaJ7Yy2
	fMG1fQTcBSUP76/PEDeayZciaz0uTx2gEF/eBf3GopuEm/PkqFvHXm0ZKaSRbcv5mm/onhbOsjF
	cw6KtA7GDizEwMc94l8c0DN21Ni4SObOREpUuHRYcr2l47i7K/SGD5WXBtXh0lGM=
X-Gm-Gg: AYBFou2BqZvsazLuHdnQT6SLnHPDytSlwK3jjlJLOrpBgHZ3zsOCMV6CMy9WPy0iiGj
	NGA4WIVqLDzBDtNNIfRgJe46/em1v3gMsInBrPLy5OXrDl+3eO2yjShMRZgH7icNbFsiXMWWCoT
	quyh+rkOouSIS/TO3ScSxCHEGgaAAj07hnr3piBdl0zr3g+mer+DojGY7ul9Snq0qgD9ymvm6Ck
	ypYuGZcwL7W71xN2NRF0JmmJN+Tyj3VL+mQpyWV/GJHwhqTjwqFWgXTTImL5t6+eoz532sWzlIS
	VSz9xwI1sjjWFn2R7OIB4AN6MWJMFBYpURmJ3XsXTtn5pbOzwt+lDQFLxtpwonsIgOgQ8HPin/I
	TDZdu15NDsuC+6LHGFYmzzzaWZz8Opkh+6g==
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485482f8f.23.1790067370997;
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
X-Received: by 2002:a5d:64e8:0:b0:484:3310:f394 with SMTP id ffacd0b85a97d-4871e25c7f7mr20485428f8f.23.1790067370461;
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48862795083sm3236382f8f.33.2026.09.22.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:56:10 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:56:09 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, djwong@kernel.org, 
	ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arI-5Ejg0Xw7OVmH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <arIszDCcy0VbRVFp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIszDCcy0VbRVFp@infradead.org>

On 2026-09-22 00:22:52, Christoph Hellwig wrote:
> On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> We can't call truncate_inode_pages with the ilock held.
> 
> I also don't see what this is trying to protect to start with.
> 

I added this to remove stale pages created post-EOF, so, writeback
doesn't try to flush them latter (but now I see that writeback will
fail to map them to extents anyway). Also, if EOF gets extended
these pages would be exposed as they are up-to-date which would be
unexpected garbage.

-- 
- Andrey

