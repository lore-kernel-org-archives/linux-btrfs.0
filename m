Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73BB2DF134
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424654; cv=none; b=cZOZkpg0msEWKa1QSaL9BldzphhbLGGnxO4R9Mqd5GsmGSbf0GcM753Jwta4Eiwl2plWlWE+UIkzyVlF4UU7q6accMZX1wYLdA8bPTQnPCOLEsKYQh5GQwr/atXD0h7b3KswjyI8HtK5UMdtpmUMaGB1LUdO2W8gEsUvwFNEcV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424654; c=relaxed/simple;
	bh=t4QqCf6UB3VvaU9si4wabgq6LGK/X7HXGDOhPSKDikY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/O8w687XEWlO5CutlLmjIAKlEgf27URofP+44x8fFyvgoXbgcR/t8zkoeldYChQ97/uTJTk0MT8fpnwn8j+EE56/SjNpJ3z6mQ//R6opBM7bra95KRJPp0ant0Fe4liuCqnSPSV9vOXfHo+7dfjgpBlHNMTKw8t897K/n1UKt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=rw3h5h39; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xREt2if0; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="rw3h5h39";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xREt2if0"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 053C014001C4;
	Mon, 14 Sep 2026 18:24:12 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 14 Sep 2026 18:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789424652; x=1789511052; bh=btAVe71YOc
	PMqi/z7yhdIOSHrxwAtUSnyumi0U/28sQ=; b=rw3h5h392I/T0idEz9EzIH7uJK
	pbUvBUZfB++A0FvfiL6aNb4pt8zUbmCfMzRTr+PURh8rfb+5cDKJtyAOPhnQRr/o
	l6ws38Qb5DhV4E+LZM1Eu48VjJYJ1S/vFTP67/4wbiCZXXXFpaKU0blNX6ot1U4y
	srZ+iSqsMYaKFHD8BPD6uuoV/opT2roXfYgHuxURKD7WUA0SggwdyizVJTMpnqDA
	rz/0LDIvtKTPgvSsAnQMKy0CJHeMmNrRNWRftL6rp4gDYWh8xs82fAqMc4onrpce
	/VhHA6//Jk3MeEJlk82z5CiPvQtpucePTETip0qJOt0yRvFmfaL6nwM7OlcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789424652; x=1789511052; bh=btAVe71YOcPMqi/z7yhdIOSHrxwAtUSnyum
	i0U/28sQ=; b=xREt2if06JitDcZKBvlTvGZ7m92NwNPzT7JmC6WTEyT5PA1PQ/I
	WLsriGcZa4ZhZ0FxWlLj6hNyvoQIKpCuSzAF9O0ooIQsbDGZCZz3YwQJvwpo6Ouf
	ML/aD8+cnoV37745Kao7hb3R7XtqPDY0ikGfDyG0O3qoANs4hcrQgRruG4c0OnKz
	rXtNO519qnrCkOo4lDERs1emaR0RcGOHxs8UYJ8x1cQVap/Q1FjmP8NDb49KObQw
	SyjI8JwayyGU67HykHlQ32QG41lZIGN6ZroaxFex1MdVLjy+5ZqUKuV6ibaNd7uN
	pi8fdvAPj5GFOo1IftGJ7PC6G3rkTtNYFfg==
X-ME-Sender: <xms:C3Soau3G-JSosCYpWvrGWbhsb2l9ErqwKKYvMrUNQFwD4RPxdQtZ7Q>
    <xme:C3SoanFAtbHXNKUYsJPjFIOidhl-ow1uD6lijqonI1qGe_eoMNGBi1cPsgEZZvusK
    BKTnnhoHH7V3wQWq5JmdWKoZIakNNtABg92dTKWSzBqKbJ_VmIplu3t>
X-ME-Received: <xmr:C3Soakjshhzl5eAlNE5tuBmNHVC63AUNzIJajtcpFdSeDa0mZ3lcwQA>
X-ME-Proxy-Cause: dmFkZTEtqQdjvMjdmvojz+NYrj0oL7U2XL7Y6CuT6F+fAhFDA1CwGZcTJ/qy8f+WxPosZW
    cJDPhJuaY30eAH2rFBIoD50I9fm9Td1EjeZhbOE6Wzcop/XeAofKieRZvAkG2A8SKAxiy+
    bKQqz1C/F2ZzJoltuN/d7JAlAgLgufU4iQRyhfpkh+oZvk97UVH5chfLgj6dkQgj8Q3EIl
    sBSAIvfBK2kYeLUeuy3IQ03FxWRnSHWd9CCyj/Tk8OcawZDyTTaPdkjxLBDH8NLgaLQshO
    +B5EiuForOoWju0oDNaWvw0/IjA71RTqQ1yNSz2oN29aorcszoIheGlxUgU8AeRoqc/pZa
    UV/9gkG+Yu9C9RwP5AmC30moxwsfSCTc6QSQJwoyjjqcIdWZbQeOWOfPbfTxxjsaDF7pnB
    hUnJn+td6Q4164uJd2OOe8ci24glZf2CC1dL28DYiYSGrO/le6eKDXSkt659Fws/hjFAY2
    99h8lq5C9wMkZi7cEWT/fCREX/X7TW5r4WqQxpbRPgRkiFlg5myNaAw2N7QQ4+V2ctHu4K
    3Ck1n/rpBLhauNyQLqqr0itXVJVH2Fhd2LeWTAf48yraL1tlHUJ3Jm70/vnkXvWP0pIdY3
    3LISADnqKacYAFiZUX/wKbo+v1HQXLxYEOixMqEs4/LTScjPtEiHyOSCA1aw
X-ME-Proxy: <xmx:C3Soaq-T9ceL26jS1xWvjnFZJSrmMMT9E4MLm8EvTN-a7Fbh-DRFRg>
    <xmx:C3SoajqZWZd5w8RLgM3YHIXJoXTegnvGUsUqRpD0uq1Ufn7H8RP93w>
    <xmx:C3Soah9F4Bs4IVsm_he5guD3ATOQEBe9ZB59HkYq8Pw4OiloMOax6Q>
    <xmx:C3SoavX6v9L7Rq8wOHoC6CvKykVEdC33i-f-ylgitkjZ5vWofBd88Q>
    <xmx:DHSoarg5jULXC_9sMyxYD4opMIttlCzSb_wRtwvBTV7FHcJsVuo6ZkjR>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 18:24:11 -0400 (EDT)
Date: Mon, 14 Sep 2026 15:24:20 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: cleanup submit_extent_folio()
Message-ID: <20260914222420.GA151269@zen.localdomain>
References: <ce764b1e763090b6d8983a06bb57ef08f74b1206.1789298944.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce764b1e763090b6d8983a06bb57ef08f74b1206.1789298944.git.wqu@suse.com>

On Sun, Sep 13, 2026 at 08:59:15PM +0930, Qu Wenruo wrote:
> Cleanup submit_extent_folio() by:
> 
> - Remove @size parameter
>   Since commit b2e743927fdd ("btrfs: make btrfs_do_readpage() to do
>   block-by-block read"), all callers are passing sectorsize as @size,
>   so there is no need for such parameter.
> 
>   Furthermore since we only write one block at a time, there is no need
>   for a while() loop, nor the advance of various local variables.
> 
> - Update the comments on the parameter list
>   * @disk_bytenr is shared for both read and write
>   * rename @page to @folio
> 
> - Update the return value to return 0 or error
>   Since we won't queue multiple blocks anyway, there is no point in
>   returning the queued bytes.
>   It makes more sense to return an error code, although the only error
>   code will be -EUCLEAN for writes.
> 
> - Rename submit_extent_folio() to submit_one_block()
> 
> - Rename submit_one_sector() to submit_write_sector()
> 
> - Update the error message to utilize the new returned error code inside
>   submit_write_sector()
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

