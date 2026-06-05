Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2B7225403;
	Fri,  5 Jun 2026 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780682351; cv=none; b=L5gGf/sGk3SLd7vqgDU4/hhGN95kDha9C6mihx5vqjh9jDgHtv46Lpe3vNpgb3BjrrVPd77HsGXuWFSun8s1bln4BrNKJJMysbLgDL0fTMzRfBsdS4ZruOyTDxJgepNpWo+UV7ePZFt1FnAECDSwfS/jdMsMWe77cPxb6o2gNsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780682351; c=relaxed/simple;
	bh=CTzhNNQYSE0vF043dxGbp3VPbze7Leum3lRqyYZv4e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZFChPgpIEALnMpIEVAiAQkqRmDABza2Ls3yWHRaEBILyhBtkc3/EIguVZRlbprr56OETd1J09L4rbmMmPd8oywNE7dWYSZW3YgwjRq3rRoW4GtTkZu8lfjyv5YmnKfQdL4900GVbEF1RYfEw2pUX2H9+Yo3CxPMN60wdRQLPWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=Wp7nvOjN; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bx1rcCjq; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="Wp7nvOjN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bx1rcCjq"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 02D751D000CA;
	Fri,  5 Jun 2026 13:59:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 05 Jun 2026 13:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1780682347;
	 x=1780768747; bh=GiJhAoqaLcj8cxO5sszc5VpBU2iDUW27qEmN0lwazM4=; b=
	Wp7nvOjN3RQ5uc7qF/5KmdTfjjwk/f9NnWTJdYMttSA/ybbrxnDsBznygYBD3DfK
	XqmNCvVxMptXsJPM0G5EVJNfHXT+oAFsl8nEftt/oVEsVEgn4cworTGqepnYHEyj
	FQUmTJRlDNN3hBKC0ppCovUAeiwCsXSLnHMc+l0oMxQkVJz3OFY1A9Zs7CoSzLDb
	HbjTPJWu5RbsJkLgv6SNwgNCn3ZykHXz/cbiM5hbJQP5y6ZDpzLlD5pRI9Ei83gK
	5qiy3cTbcfrDeBouDmTmbkttfr8gu+qDdZLiJsEid5wYr9aWA9ZPLoOeQTrB9sOL
	5WdDbFzrUbVNOVpnRPI+7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780682347; x=
	1780768747; bh=GiJhAoqaLcj8cxO5sszc5VpBU2iDUW27qEmN0lwazM4=; b=b
	x1rcCjqkK0EGediT4hXCxmk3TTq/vSWYdx9+TAldat71RT+iJHRmeNDkgmysykrV
	95ykPpxKwPQ+uuhgHAvNCgmfBOHWINoH/9/arUANSCj5C+oiKf5cyxV1pEJfuzjV
	/wpfJwpDVaKOYI3rm/3ogz7r6J0TV17vkXXDn8Wxlf0UoPRZvUX9+ZKef/STWsyP
	VU61eX5a++DPZtZEB7GkKpyP1U2ePddzg1aMme9V09/HlGkp5ZiHm4/iSajpU8Nj
	CdFxn0DTPQSRIZQlBq9br08yHTG+7JCzSqgURetMSPQgY9PNnZ2AuObtpi+/Y0xu
	QF8VXw7GLTg//B7KIQ83w==
X-ME-Sender: <xms:aw4jatIjasOs0OTv-VWXDT66wzNTesFSDTMhY2QF0N4wAy9T47tEEg>
    <xme:aw4jaqoWmTeaI0YYmLTa-F3MloADTbs4UP9iphob3QfPC45zALsJ7ezX0BibzYnaF
    gVo9-kOVn7M1RwTkdmhJfnGwAZgkZ0z3D40PO_h3fT-Gn8g6dP4hP0>
X-ME-Received: <xmr:aw4jalwfWbzvXhYsYPvBij-htzs4QF4AlTly1WFn67aSc6lN8axiT4MmszYCvqhhPXMpVYeiEVicXw02kReVVtqJdRQ>
X-ME-Proxy-Cause: dmFkZTEbKoF8ULXzidCPGNgDzcRW2MivI8aGCinFPvj5r49z9JJ2n+WncwdmV097h1Bou3
    9k5PrT5vvVMMynB0XUOOwbarUVnrpl3LdriD3Z0wWdh1gPuYIGYF8N1ro+O20yJd27sRrt
    dpgKfgj19KjhazvKQg2hrLWV8r9Yno7AdUjj6eCpx6fWdOUUAC2uaeaWRnhLE8vwJ29dTU
    7c8dqQkU+dv9MJTUyVra1u2gegWwb0WYhimbSDSF4FJQGfdMpLJ++IPQohtzVOVkpCNoSe
    9h00ver8Nl9TtEBwJ7oYEnrTrKVRbcAwkyapR2fmBLVgS+2iqBs7B3hUV4jGX0FuyMjGrc
    NoyLp3zblt4kDlPgwrtx1KDItxhxgYAacdjrmmfpTFt2Db6sZbVoJ/1mbpq9cwUIjdJoAj
    dELmF0fEnCcbHjaB53KWVK2jEqmI545ddp+CiEYM0oc4TW3UhKoAtuoXfwNyw5Lk2sD56k
    xQ+HmEkg7mCyPzJKbONx/L8imJfuC0hNm0ZiWGMIWl9XKs5/hzTtd8iGhYtTemWMo7J5wh
    Nl6IHlqmGeo+QoTLq6dYK4AtEJJSbj0Ain4M3oQ5kq6Y6JbOmiYwtiBfqZUcpSzNuPiE7o
    hifZfXb9FopDpFX0v1Shpfo8DQvmiIXXBWoK2RKQXSHjmmzXdU6vNkx4MEMg
X-ME-Proxy: <xmx:aw4jauNb6_g9gR-Q89judPp_rSoImSxE7glZNbEDOLl60vCfs8DbSw>
    <xmx:aw4jaq5ZQVZ9w0Ql7Gj0Lf98FZ7jYoc54whyBGoai05nPruNPYdNfg>
    <xmx:aw4jannEPviVIWM0hv5WpbzFPKhHDc0qTM5NqWJ9m5j7arLgq8dFdw>
    <xmx:aw4jajS4jW0Z-l-0se0VbO6MMxCRfNDeDsDhJGIVk_1OFvRKHSGRTA>
    <xmx:aw4jaqlg9kXB6U7H8G94yGVrE37JWbdIJACbfzOAPxNGY76lazWJWElL>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Jun 2026 13:59:06 -0400 (EDT)
Message-ID: <db5dec70-766c-4e0b-9a22-1b75ad68adfe@sandeen.net>
Date: Fri, 5 Jun 2026 12:59:06 -0500
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use -f by default for mkfs as xfs/extN do
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Christoph Hellwig
 <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 linux-btrfs@vger.kernel.org
References: <a31e9841-fd0c-435f-b376-86a7e01ddca7@redhat.com>
 <aiJL1CBTV_N4YAtb@infradead.org>
 <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <16b7fc31-3684-4144-9076-8cdb60e97001@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/4/26 11:14 PM, Qu Wenruo wrote:
> 
> 
> 在 2026/6/5 13:38, Christoph Hellwig 写道:
>> On Tue, Jun 02, 2026 at 10:47:39PM -0500, Eric Sandeen wrote:
>>> Recently saw a case where testing ext4, xfs, then btrfs failed all
>>> btrfs tests because mkfs.btrfs refused to overwrite the left-over
>>> xfs filesystem on $SCRATCH_DEV.
>>>
>>> This seems well-enough fixed by only making the change to _scratch_mkfs,
>>> but several other helper functions explicitly use -f / -F for xfs
>>> and extN, so I've updated them for btrfs as well.
>>
>> I haven't run into this yet, but it seem like btrfs needs this.
>> But maybe you should also Cc the btrfs list?

Yeah, sorry.

> This is the wrong fix.
> 
> It's caused by a mkfs.btrfs help string output change, and it's properly fixed by this patch which is already merged for a while:
> 
> https://lore.kernel.org/linux-btrfs/20260510001704.68396-1-wqu@suse.com/

Oh, ugh. I did not know (ok: remember, because I wrote it in 2013) that
we had a special helper function used only for a subset of
filesystems, while hardcoding -f / -F on other filesystems. :(

Anyway, this fix is still on for-next and I missed it, sorry about that.

Thanks for the heads up.

-Eric
 
> Thanks,
> Qu

