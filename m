Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB722D9796
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 04:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780461330; cv=none; b=F21IfIYQHMgmKTkckiSJSYdbk0Ls4M8Vzt9ZAls9Ju1ZTlGhsS1DOKdqoAQinwllAHAjd6XAt/FPXV6HkPzjzHAhE2HpriMkO8n9LGa6y47ChBtA5K8ZaUuvH5VpHZiJM/HK/XLYSVorKZc7RT+4+RFH+Bp7brEYD+QJIxo4lAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780461330; c=relaxed/simple;
	bh=i8IsmCE0y0CmbVZKZ5yGS/nNQyC+z9RQB9SHQ1ZXziA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0MFujFBfrqxksMS9PHIt366pMJHYgKeMVdJEflN+M8L6BxuFlD80MtFIJvwC7v3wv6oLQqlI+/VDiA/idZjmIshLatkXIH934vuOxwQ/pGvZzANuwuPZdEwHvraUyK62LKT1TMz1ATiFdH9/Q3BiJ2cUS20jBhJoFhJURgsXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=e8W0dkRS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gt1iuTHk; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="e8W0dkRS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gt1iuTHk"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CA5697A00A2;
	Wed,  3 Jun 2026 00:35:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 03 Jun 2026 00:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1780461327; x=1780547727; bh=In4IydNlm/
	NC4tybUuvZbai932Vlz39xbuB5KvwGy/U=; b=e8W0dkRS+taiMM5u0sLBSFJy9O
	wIJcVZj44PzUmRTjbgIj0VFx3jTQ59nUu8r5MXJBFYyw094hfXYodOteH6PIZDIr
	nwB3i+K1ZLRiOxVLdXHPhLaU/xho0GuvTFtGBtMkD1uqpTcufhocO2UxVsMOUUGU
	2TnYPBHvI+Cg35wgBbF0YXpagqtMkPjUac+Tazek/7Em6A/Yk5+5HzYbwXMJnmT9
	aaIjhQ6lBqk6uiD8RDiy9gvDAz1GT564y+IOVixPoVyAHIx8pQrv7eKakI3Saojh
	1Mh9eXDsM/Qv+MVYd1A0HvBwXKGsZb/eaJFR2uPkOndFLNvbviQc9eM1Y1Gw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780461327; x=1780547727; bh=In4IydNlm/NC4tybUuvZbai932Vlz39xbuB
	5KvwGy/U=; b=gt1iuTHkpNDXRrFA/bC92UEo1NEyKTKrSjsY4mcFLhHGkHobG9H
	orMIra9NmCfO27U8qaWBKJEwBfYPMeMGYiklbfS11+xOikKx+7nsElWd8XRZX6UI
	mLlWfnweHMaEKd/zrxHnvVyUH9Pt2BDxq7lbCTnDzm8dLRKEkCuQubGkoj6sOdkK
	faufVwO3nD8zXGns+toi98dsNq3bFOLrbJxL+wWzMneKmMGhl21/iI+nf/FhxrO1
	6GkBpKvFulLsUnk88vHd8paaL2m39VD0tVOs1CIylFsbnvW3LTij8B47NHt/q6ky
	An62N+c5Zg92EmIqCKOVuH0WbTDXcI49WoQ==
X-ME-Sender: <xms:D68fappqKti-WzsprcYkgjjvpAoKjidz7yfHLNygu2xIYEHYYRS9Lw>
    <xme:D68fahpfYdCM-qCCGueryBSe1ebG8fBo4h7xnjK00J6pybUTDZHppKjyn2gkcjm1Q
    yxBQE0e-bGxPQCp8vnXPOhPM5aB9EeAJ-KTuZQigWy7phOnACc3Gwo>
X-ME-Received: <xmr:D68faj3QJ6G_2S4fDna6-qvyp8lu2VYX_loo3eVffC5MddNu84U49n7nG9WlsCwfXBWw7vvqbzv6qVnZzafztoRvw1Y>
X-ME-Proxy-Cause: dmFkZTEvcPBtMUHLATK856ZaJdLls92aPJVShWcL9sMXx4N3+WiCjJX3sICt/qIQTubrbR
    WbZ9YwTexNCR5msgtQcNZeBQae34jsJbTJnGMKN9fn2Wehwniqc8qAl46N6CeVIo8zhApm
    GWPTnTSE8ehMc51aqAPQLQKYTeuE2yxPGvHMXMijhwv0ncL2WYTNk4eWLOKWcmkhttwgSK
    sxgsnbqndPoFtxaIwu7VMhzmUoFt6AATY4ZpFv8lSg80wMn4itex28mpQE+oRgUZbJ6FqG
    uAfEdSWyLJFWK4OJL6QrQJ2f7tE86OFsLgC+KVyxR8FfiEgB5R4j0JnYIP2V5WReA9MBAp
    yV/5PovcmWz1FKGL3kgtu4EQunNjHzBjJo955jIvPiozXpqkaPsXcfe3DH3UtQRxLjvDBo
    XExEa9acA4Vdv72a7xSwPOilATWYtkGSC1qYoAG+S1Fgy1uMk1SPuQJ7qhGT1GtuJpZ07x
    o00wykqqOhXHs3nDDTarZXC2BaPdtGm81vjYdRrLJ6DrIh4a0yEFqW+EmepneNQV+CZ5Pn
    /uzHjRKw7UTRdzOstogk38lxaQdbqcjovCVaFrXhzRITTnY/7t85kCisu52sLjYwPAQDq0
    y4XA0awlVRE/TLV/7dE4aHydNV5Am2ArO/81C2UeyXqY7Ic5qRg9379tn7Pw
X-ME-Proxy: <xmx:D68fagDBIGnehm6HZRiQX4Nw6u-qOMwIj8LQItGg8OEV3yFyc6l8Ow>
    <xmx:D68fareqHgagp482n3W0VesfxIsdSc3k_yFu0saY0xpX1sAr84UYWA>
    <xmx:D68falgFu9jroVYRytk8DkH-Ig8ZntFcglKR0elZr50DR29Dnh4_cw>
    <xmx:D68fajoJI2dLP_6XBj8kd_2b4Ml18FzCiUEC5dDhg5AOkSbF6vLdHA>
    <xmx:D68fao1Wy9O_8R_80wVNUWVzaFXB8MDnFLQuoedRzkqfCeEbaVxN6NaD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 3 Jun 2026 00:35:27 -0400 (EDT)
Date: Tue, 2 Jun 2026 21:35:02 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] btrfs: retry faulting in the pages after a zero
 sized short direct write
Message-ID: <20260603043502.GC2114331@zen.localdomain>
References: <cover.1780112003.git.wqu@suse.com>
 <70c80c02852c233abb0b3cde0c99efc37f14f9d8.1780112003.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70c80c02852c233abb0b3cde0c99efc37f14f9d8.1780112003.git.wqu@suse.com>

On Sat, May 30, 2026 at 01:04:19PM +0930, Qu Wenruo wrote:
> Currently btrfs_direct_write() will not try to fault in the pages, but
> directly fall back to buffered writes, if the first page of the buffer
> can not be faulted in.
> 
> For example, during generic/362 with nodatasum mount option, there is a
> write at file offset 0, length PAGE_SIZE, and the page is not faulted in.
> Then we go the following callchain and directly fall back to buffered
> IO:
> 
>  btrfs_direct_write()
>  |- btrfs_dio_write()
>  |-  __iomap_dio_rw()
>  |  |- iomap_iter()
>  |  |  |- btrfs_dio_iomap_begin()
>  |  |     Now an ordered extent is allocated for the 4K write.
>  |  |
>  |  |- iomi.status = iomap_dio_iter()
>  |  |  Where iomap_dio_iter() returned -EFAULT.
>  |  |
>  |  |- ret = iomap_iter()
>  |  |  |- btrfs_dio_iomap_end()
>  |  |  |  | return -ENOTBLK
>  |  |  |- return -ENOTBLK
>  |  |- if (ret == -ENOTBLK) { ret = 0; }
>  |     Now the return value is reset to 0.
>  |
>  |- ret = iomap_dio_complete()
>  |  Since no byte is submitted, @ret is now zero.
>  |
>  |- if (iov_iter_count() > 0 && (ret == -EFAULT || ret > 0))
>  |  @ret is zero, thus not meeting the above retry condition
>  |
>  |- Fallback to buffered
> 
> Just slightly loosen the condition to allow retry faulting in pages after
> a zero sized short write.
> 
> Unlike the previous two bug fixes, this one is not really cause any real
> bug, but only reducing the chance to do zero-copy direct IO.
> Thus it doesn't really require stable-CC nor fixes-tag.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Boris Burkov <boris@bur.io>

> ---
>  fs/btrfs/direct-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index fd53fac7186e..99c959be8de7 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -960,7 +960,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	if (ret > 0)
>  		written = ret;
>  
> -	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret > 0)) {
> +	if (iov_iter_count(from) > 0 && (ret == -EFAULT || ret >= 0)) {
>  		const size_t left = iov_iter_count(from);
>  		/*
>  		 * We have more data left to write. Try to fault in as many as
> -- 
> 2.54.0
> 
