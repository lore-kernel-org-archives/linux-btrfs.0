Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D94F12F585;
	Sat, 27 Jun 2026 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782567423; cv=none; b=jFHzsxp6WE2eaFH782GDJFkT+LVDgKXKzOpkCE57qNJR+HoAQzFaXf/Qh92pmgLv7h6UeMfUI7Ys7nLDcWCiPQw0NEQgIqkDfApLfzUswvLFUy5M43tfYUxzQj+0MgrfyYx5mqCVjzq+UBfH3cK53ubcO0qHviLInLPMjAbz7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782567423; c=relaxed/simple;
	bh=uUTYL+XiY6nbZ0YUir4XMg22YbfTVMU7jfHFV+vOYwc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wa2aza/y73B/WOv5IOkCQbJEty6zwinPM7gqeM042m6P15sAT7YiiOFJidSa97rouwonuOF+w8eE0ZYimLuZMChpMFJJT0KvrPKRp+XGkzlx7JArxhZEqf0CbYw2BFKxHtIHq5K65rpIAjq+kY64G45tgzsPlWShAwEGk92sSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=YJaTGbBC; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="YJaTGbBC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uUTYL+XiY6nbZ0YUir4XMg22YbfTVMU7jfHFV+vOYwc=; b=YJaTGbBCAVkVuPVOSxUJ2kyeYa
	46ME1ttXik+l5W/4OaXgsFFRgNxoTXOJSK9N8VJ+c/+QrIfMDCzUE2fJ4GAkPb7p3H0fc8JDQdYcf
	kxGge3hiO4PZ6LpBE3ofT5oqUu/Rnnwn/foxEhnSgeZM4nVCrVAWDZqJZaiUAfsiA8a5CX3uLPzBN
	r+DZp2wjEQcTBiLwDbHh0eDvbOH4wBM0AmEQmchQpavFxPzudC489W+mjUYDlbAoiI0e0dfdnBKI/
	rrqtnG+L8Vvh2CgwhahdXjZDSVs5uXIiefETS5PJUZeHRreYtb4s5n1eh9ab5nIEMB80rdg6igmk4
	ZhzQ7/9w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wdTDI-000000001nG-0Ciu;
	Sat, 27 Jun 2026 09:36:52 -0400
Message-ID: <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
 Andrew Morton	 <akpm@linux-foundation.org>, Jonathan Corbet
 <corbet@lwn.net>, Chris Mason	 <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Vlastimil Babka <vbabka@kernel.org>,  Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Rafael J.
 Wysocki"	 <rafael@kernel.org>, Oscar Salvador <osalvador@suse.de>, Mike
 Rapoport	 <rppt@kernel.org>, linux-doc@vger.kernel.org,
 linux-btrfs@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, 	linux-cxl@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>
Date: Sat, 27 Jun 2026 09:36:51 -0400
In-Reply-To: <aj9yrlB0TrlYCLlf@lucifer>
References: <20260520150018.2491267-1-riel@surriel.com>
	 <aj9yrlB0TrlYCLlf@lucifer>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-06-27 at 10:28 +0100, Lorenzo Stoakes wrote:
>=20
> So really, you need to start again, from scratch, and without the use
> of an
> LLM for generating code, or at least with it kept on a (very very
> short)
> leash.
>=20
> And to be clear, I _want_ this concept of GB superpageblocks to land.
> It's
> a really exciting concept.

That is the one reason I sent out RFC code before it
is ready. I am looking for feedback on the concepts
in this series.

How do people feel about splitting up the free lists,
so each gigabyte (well, PUD sized) chunk of memory
has its own free lists?

How can we balance the desire for higher-order kernel
allocations, against the desire to preserve gigabyte
sized chunks of memory that can be used for user space?

>=20
> Pulling compaction kicking and screaming into 2026 stands to
> significantly
> benefit linux users and developers.

That's another big question. How do we balance the
desire to keep compaction overhead low with the desire
to do higher order allocations almost everywhere?

>=20
> But the execution has to be _completely_ rethought.

There's no argument there.

I am just hoping to figure out what I should be
doing on a conceptual level, before figuring out
how to do it cleanly.

The mess in the RFC is the result of trying something
that seemed right, watching it fail in some subtle
way, and trying to fix it up.

Once I know what I need to do, coming up with a
cleaner implementation is very doable.

>=20
> IOW I say we take off and nuke the entire site from orbit. It's the
> only
> way to be sure :)
>=20
BOOM?

> Another issue here is maintainer time - even this _extremely_ light-
> touch
> review has taken me a few hours (of my weekend :). To review it in
> detail
> would take probably DAYS of dedicated work.

I suspect there is a mismatch in expectations here.

I already knew this code has to be totally redone.

I was looking for feedback on the basic concepts
and design in the patch series, but failed to
clearly communicate that.

You provided some detailed feedback on the code,
but as of yet nobody has really provided any
opinions on things like whether it is desirable
at all to have the free lists per gigablock,
or whether we need to come up with some totally
different approach.

How do we better communicate that kind of thing
in the future?

Is that something to spell out more clearly in
the cover letter?

Is that kind of feedback something developers
could even reasonably ask for? (if not, how do
we figure out what maintainers want?)


--=20
All Rights Reversed.
