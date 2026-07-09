Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C80439331
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783617504; cv=none; b=EwhiQT9+CfNdLqqzUy5qaDrHEQpU5etxjGG8tNbNfs9hi0LZAMoTOjvHLD7djrQDwt2fh2Iaqd1wtUH1oGBSavGaVjHhZ6geKLHXpeLz0l1SGHW+D1Tt6dN4lxhf+IMVrCC6/9y60DvIlAySu7tYyfVfxaGacNIgfxhfIxac+bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783617504; c=relaxed/simple;
	bh=pBb5F8xeqX6Vb4OsNYVdPrjuPsjVJaPzk5Cbliu4ayo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgrQm4Jli3ixKkbCR+WjtYAyebK1o0MRrVxbryEDw52ZvbWtb5Jk7BQU6zYz3AGBuOtsA1IUep3IYwREAnJCrOjjfzgwg4tmg1Dw+j3DW4YAqxc2FcXK5tagSGbkRScKwo8R++UBCbMhDwwHqzMmGVHSAGNcXb/MvGHPzyc37dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=V4XWqQiB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ps+6UzgG; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="V4XWqQiB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ps+6UzgG"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 23FCB1400167;
	Thu,  9 Jul 2026 13:18:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 09 Jul 2026 13:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1783617502;
	 x=1783703902; bh=VPb8QKLbUVFuyIWyDDr7UGSCI78twH9BIvWhBjHPfjo=; b=
	V4XWqQiB1N8ahP1YxZfdRiMdBl8XYclLqbkH2/qHeG5WjXX/V7M4gFdpuMntjo24
	QvkpDF6/FiTkZLyHHZmevUK5W07oabkd0FejcwGtYyMMyjYlBJcCMgsDq0pDyev1
	VquXtrSUIh3xEke2y8w5JkdBW/uLMTzFatMagA4rZErmaA1QvuUF2yTrt74nBic3
	0PMqLX2+mOxURJWsnErjY11k1gUck5XLo1FlLg7m0Nv5MeBF4pShtURV5PIFFHUk
	bFMpE7uYVE+HfOTVRYq1GGi0Zn3aE00PiF/XpxEj4NUxc+xYSSwS3CtzJqTNt1PK
	O9vtPgljbZ2sX6DXQ/f04A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783617502; x=
	1783703902; bh=VPb8QKLbUVFuyIWyDDr7UGSCI78twH9BIvWhBjHPfjo=; b=p
	s+6UzgG4PgF88FuTtDGkHeNlr3pXG1BW3GNnp5f2nPpktEgrnCpszv1NBJukoSJS
	waU/BhNKTjBZMwBp1WE9t+1FMQJgE8Jv6SN6Vg8QIQH7Kz599FwJz2gb5+v+XhJk
	n6Ds2xkecG4QZ4Ek0kC4pdrpNYZwHAL2TBLI5TNFYb05nJlhkstWxdCPW+SxMBq+
	B7d8pTTEWvWxZZgh2hLd1YTZ6RrDovXgpkg3BpjZjEL8Jn+dnz0Iv3la7uJ0SQUk
	LQ3cnJF/l2otlM9usKcFfIcYPIutSjvbre/wdcf7zeIBSG8e2CwTCEMdmO103US/
	Ua9dJ0aVUJfff0MFoJdcA==
X-ME-Sender: <xms:3ddPajrjy7sASt_wt9z06ChM7xQtArZEW-D4rxPnAn0GSHXU_kmyPg>
    <xme:3ddPakqcnEwFysZccc2obj8vBIGNC4M3vEWjubVmbTLlPNRdES0Bq_TlLb0plBP1Q
    PUI4nV8H_smFnlFDKFEK7R2FUi5IKCueOyoVorFDSgTlCyM5h0Z7r4>
X-ME-Received: <xmr:3ddPalMVOwGi33C4UOt0Krcy2mNAzn4F5_3dehRA9NauvXI_eVp_5ZwiZ-epgjPQhtdotNzdOobBwu_kMep5aYJJFJY>
X-ME-Proxy-Cause: dmFkZTFxm/yRJj1ytK+hWVmxr6+EknSE4NRE9sBLTQqe11uPX1EaYGTcYobaN7GtO+jKWk
    1EtLetSfOKFUz568pl2UniUW1Cf3zrFkqp7C6eze+N4yX6WePh05T9YboaRVlX0FBz/FJ0
    LrMBPgGUG1XxBahsq1EALI/tYhlGrMWBIdkqsov18e50LmmqT7ap2ga5NJz1lLwNiDg80s
    McKqaI3zMlZVd2tQgkX8p9sRTMJQV296FPHQyVXHOhobFX8PEl66fxMPQcWVJjFAJCtrZf
    +VnzgvcMfss2VEMZ4DnlJVE1vobIJMQ50pHxsTfJt0oJGhX/H8T4aER4jZnkzYnWv1ImOU
    gh57s6McRRbAhz0DgP/7TYXDpwaWRsVjrZt3boSWUeoy7OUdzdY/a8tWCE3BnnxJI9LwU/
    zEEbvYlnRZVNALzwDl03X2XAkFw2ABPkkDO2A5MLqf8Bj8pZi8bd1uwNhCKf7BOwo7qqst
    sT7d1m4IgCUZpvE43IuwiY8IvZN3zlAtQwMjLVQkNrFa7h5RmLGBpDNWmN/kR9tQ1ChSKc
    ItFpLPcnfEaevVYRYkMUipg0TLFRLS6IRjq29USPHmq3Y9P3sWF+zgABShU9ArXEGYkIAV
    k2KQrhg5R6qIIOXKIzhu6vzsNhjj9Z2DC3PRjr40rV3YD8vamv8cLkzboh3w
X-ME-Proxy: <xmx:3ddPaly09BbJ0lzkTBpkCM8ybV_0t5KI_n9PJvLfw3W5Ti2oFUqwZA>
    <xmx:3ddPauuoTFqSeClO6jcheacfkA5Z9sYls3zVXILMmZ69kTshRLaq6w>
    <xmx:3ddPau5boSOfu_VS0jkLmhZ9IzFu1IQZTjm-3U331M7nIf8oh8VmXg>
    <xmx:3ddPatQLn88jirJUVB45lBGvwj8zAC_oSda4kwtcXWxgTgzo9BoIfg>
    <xmx:3tdPaojwJSUvLwRegKtJwGYdkBqplg0rOXGLRbJ0UFI6hSv2iswc5NfO>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 13:18:21 -0400 (EDT)
Date: Thu, 9 Jul 2026 10:18:35 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, willy@infradead.org
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
Message-ID: <20260709171835.GC1552049@zen.localdomain>
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
 <220e9095-7eae-4129-a36f-53403df6fc8a@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <220e9095-7eae-4129-a36f-53403df6fc8a@suse.com>

On Thu, Jul 09, 2026 at 06:49:45PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/9 18:16, Qu Wenruo 写道:
> > 
> [...]
> > 
> > 
> > With all these said, this may help you to craft a more reliable
> > reproducer, by:
> > 
> > 1. Allocate a large folio (e.g, 64KiB on 4K ps systems)
> >     By doing a 64KiB sized buffered write at file offset 0.
> 
> My bad, missing a sync here.
> Other wise the later mmaped write will not cause two different dirty ranges.
> 

No worries, your notes already helped me a lot with improving the
reproducer scripts that I'm working on.

> > 
> > 2. Mmap range [4K, 8K) and [16K, 20K)
> > 
> > 3. Trigger writeback with mmaped range being modified
> > 
