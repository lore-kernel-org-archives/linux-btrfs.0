Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F197336B059
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2026 17:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781285317; cv=none; b=JTeAxlkdM65S3G6lV2/x5rulgZ1CJkZcT9lbOrPEApi7hnB3wpOb5KQhuzIr1qWOc5GcKOaWRGCcH4/VYB+W1axWB2ZQnLB5gw7Rm/ZFuLwLGSk6Il7wJ75Q+3bb9Rxv0ngPDb66Azx81n1PDTjQOSS1oP8IDI8IgYfO/5NT49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781285317; c=relaxed/simple;
	bh=iHJMR5WUzbGeqvQjqNJjxFFzevHJVaWmp5xLEB0FRZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aHpaZL7v9JywOKuCnzWWiYjHvDxTB4yrWxNvITbLUeLOjWeWU5N8ORRy+4RWcq56v4nJagMH2I3+mEP54YxRg1WMVEI8qtOaOrdZ4mna7KX2m22vSkBPFbTmupYTc2En0WSLUGtFmVtoSX6Y68V3cuoE5nDtjKYqBrnscjKdIxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=qhyN+obB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=M5XLCTSc; arc=none smtp.client-ip=202.12.124.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="qhyN+obB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="M5XLCTSc"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 155D77A0020;
	Fri, 12 Jun 2026 13:28:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 12 Jun 2026 13:28:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1781285314; x=1781371714; bh=AemVJipNqv
	BNREoCOIV0pQdtvS9FFvOx6cywlHC6Zz0=; b=qhyN+obBZSCKOHfCM62EmdWJed
	AE6W1cs9w8+52vgfV3V1lJ2S/zUEpb5Y3XDwrBSJq206XqUSENxlzlmunTMIKZM6
	3AJ6DZyb3jn3YSN+bEN2N8Xlz3f2BXYmse60eCBPGjdMXP69ZWlyunyemlU8Kmib
	xO8XGVzy1Yy5Txb91tEC8oV48mWxdh3lcSenWIMfeRUsqKzwHon9fXitR0NwgA1r
	UlNKLzm6MS+EXAfkoufp1jsG+MRSrb76WweWXgXtQ8AsZ4VrEq9hbXneG14bUnx1
	Vy24st2EXr08koxfe8sfgzfoGOA9hjsnrjUZsSVqzKlt6T3cSaPlFZ9j74Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781285314; x=1781371714; bh=AemVJipNqvBNREoCOIV0pQdtvS9FFvOx6cy
	wlHC6Zz0=; b=M5XLCTScGOFMvmZpQdEHFhr98IO/tjiaEbD1Kc2UA9zChZC4qh+
	vYB6PKYrZvjtNVVGnBNxWjTQ50+yL/uMbs7bMJxwBDDQP8UI7JL8HkfDHzhZt3RP
	Sz3dpoid0VbvlcvFTbjdVRS9BVGyeeIuIuAYoX4mEUIc3SKHLujqzqE+l+4+a8/k
	1kc97Wolv74LROAJFKnilWnuc6Ch3HYk6v3wILJtXSzeKjIvehkSXfIICrLmZr7t
	jJXdOxE6MADBwWFbvvqTnJZnA6dQwtwfv0kJbayjvnU5GKJsHBYBwxsgG1ODq8hj
	EWX8X08OFdiRYHFqvF/oMAzgbyUXlb6qrEQ==
X-ME-Sender: <xms:wkEsauTFdtYckLDgwDkg4dsyJcriG4B_aXkNHBpf6jBhEuCPcEa0Bw>
    <xme:wkEsapy5IAX6AsM1sooKUMVdCgvHAlZ4qEwOC2nmv7S_GoASa7RPNoNP9v7hlAPWP
    PZCEmYE_n3zovx7pgCjcMxiBsF0aCG_2BlnkChlH88Vu9AyF0WaB6Y>
X-ME-Received: <xmr:wkEsapclyi2JYk_SdL3y5BLX0xzGujKqz0vqsQb6yIIiFlg2nHr6rja4UPA>
X-ME-Proxy-Cause: dmFkZTGuluRsvcnB4yT1KSS9aC08fZWTS+C9AMfrD6qDuKldMfkL5kyJ7HkjryeiF5DYAP
    irFpd1dtgDHZeqd19xqsmlgNJhm39ZL2mv3BshXww38t5qfdohB8WWXxQelYDVbnVfSao6
    szUoKeddVT/XEqRPnxfec5nBXfwFCuUn0EENT/KFfO5bkZG/u8lsQ0qVnprhZAyiO+7zJE
    idLq+aFbk1S1+GhM1QD+Dxz8S9vHVG+u9w1TBfBW11+f1TNYkSbFKY8lQYzZM+nSUzdXhv
    w4kYcsw8IO/1ptUOQmZEk32Ad5fSQnxp7pRFOsOkArxgKFnCfrvNM1goAKSDbyPprF7Jmo
    bpT8UlTBJD+2YTzUpUf9Hyl4TraI5j1fy9WQSJGA5/oBHgWOSlv+qlL/alQ7WZDnpCrdaP
    ojhIFw2Y285nZ3q2uvQ2sYCrRhv+sf7o+X3UZ6RXkiHGRnde2S6Mcq5O3eXzfseHlLbOdP
    UWER4R85KwfEsvP29FPpHt6kXlhpA6CgCudJJW9OG0SR3eyiHDgAbDouQ8xuQrD53xHKlB
    Q+o+0Mxt86og0kXbxl3zZ/Y/y+sORDzi/k0DSl5vDmN2AXfw63pEjIRKIkkeTt5nnlIK1K
    MiA7v95vxcZgbAibFKFLp4G0TDsyiVpLlWKK8Ca4aw54XSjMjrc3UeLZ+iOQ
X-ME-Proxy: <xmx:wkEsalL05d0se1o37NDhTOtglIGKGSjvxvHwqWJ4ekIjFg9rPNmW0g>
    <xmx:wkEsaqEwyVXLcCs9_I7qAA0IOhN7Npt-UmbMEsNQhE_19c6Tz2a1Kw>
    <xmx:wkEsavpFXlhWVB5MOCFneNqkJJqGmliuYGuMr0AMwqw3PYyfb0bmfw>
    <xmx:wkEsajQaD30aafFIUWVJ0CjJvosN3UMRqIMsbgIX6jLWK4MXQe-QVg>
    <xmx:wkEsalGxyZ7sBZ0XpuFNClngDHIF_p7pSFuDy7QUCIuMvnPP70zWuAFz>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Jun 2026 13:28:34 -0400 (EDT)
Date: Fri, 12 Jun 2026 10:28:31 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfs: fix incorrect barrier usage in relocation
Message-ID: <aixBUShPBYelgHic@devbig013.atn7.facebook.com>
References: <cover.1781263239.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1781263239.git.fdmanana@suse.com>

On Fri, Jun 12, 2026 at 01:13:55PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Sashiko recently detected we are not correctly using memory barriers
> in the relocation code, and these patches address that. Details in
> the change logs.

Reviewed-by: Boris Burkov <boris@bur.io>

> 
> Filipe Manana (2):
>   btrfs: fix reloc root cleanup in merge_reloc_roots()
>   btrfs: fix memory barrier order in reloc_root_is_dead()
> 
>  fs/btrfs/relocation.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> -- 
> 2.47.2
> 
