Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793268019;
	b=dLxOo/Sd43rQhdY4GLe0ttNT4axkBzZdEXK/FlMq7edUbIqgmBR3YXDCoaHVs2/kmgmB
	 kJKfXMc67ECU7LDoscPlp5sPThn9pufk4ADdz8ckqqnuODpyJUOsoYnGf4tV3ByDHD0tQ
	 WHmgJ++4P/i90CsmYOY+nGpRr22uQiTuMDK2MvgWpb8yiLI0ad0TeaYjHpFNRA5/NZhw/
	 3dTDwgEM/OFBb+jXe7xfzWOCcWBXgBImWdEX+LB9EJG9+C7FKL+sngfytWw2duOs0uK3n
	 TqfdSp0j99+6CsIVGd1FwWomsysZpNWg5Us5UPdEAXGuBoDW9PiijMnCQHuUK0Embnw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=+KsF8vc4ULWHMDhPgj0bLTj8antp0LHTyec0w+asTec=;
	b=LyDsyWYRbiG4DTg8a64IDhm8iIq6yJcBOdHqNN6ITjdNMxOXJe/DhuDaD0KPmcIpYZc4
	 ad1yVd4Rjn40gYHfMpKcOcH9QR/ILxxJ7YxV4Ah4yh058eRnUcFifBlVIU242mcAKfeMB
	 uQHzwzxVHUmauC63KFjw6Ms5XYKFTz6OTVLZC8130lh/12S3IPeT1955Co6HlZKVs9Td0
	 Ip6iercFo+ztCxLm/AyAJmDgNhydCBPje4aoZ0IhU5NVOlFQlSAsMbTtmqO8SG3o4nRTQ
	 +q5x1rTqamw6FX6VTlUds66GSLaHJ2Rtwlm/H7R0IbXmjmAKPDqA+UJg0TIIwX9jzKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ARIrWMoY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585CC606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:00:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 585CC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ARIrWMoY
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-36a315ed211so734113eec.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 03:00:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793268018; cv=none;
        d=google.com; s=arc-20260327;
        b=fGYXUhIOiVEzcUVfnhFnE6QlMwuomzn8w5fJAnF0qivzXyhc+u7LJWJ3ebxJyuCbQH
         oqgcztpOqg3e90HhiLAe+IB37KeD4W3Ty26rJzRvd6m++azMtM8OZKB0IV16o+fM9fnh
         8Vlu/Z0yCC6TXGXhe8rW/f72X8jDi4tus+4buDeKCe4oQnCh1rnQZTzBedZGF0VMieMS
         IMKehGursrS5/xOI04MhGZmpCagWTcXPl1P5/ytvyBwF04ytFEqwF/VIf948pGX/c1kt
         HIKnR3ZE7gTE70n09+sVDZL5xejHEC6L68iFH3JoOJA4vKljmT+8gnqaCwzgn4dZM+Ye
         jBXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+KsF8vc4ULWHMDhPgj0bLTj8antp0LHTyec0w+asTec=;
        fh=0WviLk7gJzgFiXe3fjZBELDprvDDs6gxCMeehoCvtTQ=;
        b=NuZOZp0KRSB581T1slj9Oup+ZUzWP1O/HdcGanTnSVZ0ka5hG1fbPyUgY9EXp0+J+Q
         TjUowUvHFzr+Rc1GdC7y46DHXzvyepuZtV5stD4zOZsUjNChS7jnnn7As10vlPH0XKIw
         qya1wItE/MhKJ3emiBTwmInsNamLVMUE8o8PCTDREb1r+snCjjxbHhupaMchKaidiEq9
         2v5zlr6V51NcRJGhYC9m+c8G/FlWQk3cT5HVytzn94MKUBDim65XO212KCR/RLGASDZs
         9EqqSIye/01L6k20Q0o5P+vOpTLpvJpzCcFQoNzxcQKOmdDSHlN8snQb8CEOJdFvG6bd
         n10w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793268018; x=1793872818; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KsF8vc4ULWHMDhPgj0bLTj8antp0LHTyec0w+asTec=;
        b=ARIrWMoYuq4mUlEtGnJEbH3JHWCFIB5kUS5V8EFCUAGJviCGuN2oyTz3r202vPu/Ei
         5ex3nTKudegs0B0S9Oiwf7IC4nQzuVuSgZIfJJtZL/B1xz6LgTdnMHiGFOFAap9ett4l
         rG94afJIjwx5oKli87BbJLnVLu6YA/y2uTjF7TGlTArcLB4+KQbwL6mcL0yEf+ebpNJ/
         oI4JSlyw5lYiiFSJBWhK4uWv9YAKqpr3Xb0pY4JBqFPVtu/cIfOd7i5uoVr4IYRjz20O
         Q+oO15QAmaGvb+H7YTL2BDoScdSLeW7jbtzo4vOKv5SC48Z9nAWErtEum8qbsVBhbfBY
         c+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793268018; x=1793872818;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+KsF8vc4ULWHMDhPgj0bLTj8antp0LHTyec0w+asTec=;
        b=iWgoucAdMxu65LOz4/9xB0vfMWQCdA8oiJiHYH5wfEiKP73tz2w9HXFrg/aftyJr0b
         yKfWPxRR2hpjjYRGw3yv/byenbr58YNT4vgGdWyZb3xym/4wm3iK1qlR0gHGN1Id8By0
         wV5KoTTXnxPhjbUtt9l46/J7T95lNLagAJpswWoo2Naa3Y8Z4mVpERD4twNXj4UVJXuk
         cbGKsJjxg/PfGonUoaHAThwUu2ZuCNCoo+pAzeePfk3jz7QC0V6ILcp1o6nYvwZDZTfG
         Ui2Ooa/vm4zmDaidwvK00GN8HGyihBe0gWkDyUTIyj2sfHQbd6mIK+Eme0xcN42X01ov
         +SzQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6DR0wt2HtpRTgXoBn29CUtEdJj0Y0ZZWZpmnvGipoIaSiyIPaEwPDgE2z0DBVPJdGukXUckRdJkmb/Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJkVc7JiHb5Go204fzgL5GLeudtzqzYlpdxJRMTQ6d1w7a9r7z+
	3D1PmASDLNaomnP5khNY/U/Cym/LE+zDKKeLDyIO3+ys8uaUiobe66+NqU1uoGQSeHuLkXiRbTn
	JYwL3OWXm2lCgpeg0uV8MtREOFH9u80A=
X-Gm-Gg: AYBFou1Cy+lKCDpQY/Ows8vbJOXs+tMtmorJJhdSCFC7yzSHcq3SboPuxtOEcafEN6i
	q4qkQlg/02sVHY95kDnK7nJ5I1dWazJEbA08n7R+RNOKGM5BvS7/NNZ82ncVxeOluRjCl04t5sF
	dL1KheVdWHcpWJ1/eLa1yfGs+ggqUWSTLWSswqKPd1jL5uBQFFciesOpF5wD8ryge23yW+tuBTl
	wX7rghuLuyj+4fJj5gfXiWL+TcLjBrYcQ0e+CRTZoLgtHOkica5pNPY0EPpJYYhRmI0oslB0jh1
	fIL+Gs+g7dLhrBTi1tpkHaRxjJwO6o4LrTrot4gjIAqE1gVlcnY9FMKyqoG/BAaQL3jB0DKpF6G
	7wjY3ONYshZxqyTA/jlNFNHxnhICiJuX677ralJrqnVkdrnHpDHi3LlHjpFYghUPxWEcWxKdzZs
	EyTAtxZufi8ADPVyZyvQvpjtdisM5A5cgkSyD/36xQ3g1+NQ==
X-Received: by 2002:a05:7300:d58a:b0:35a:3b98:b428 with SMTP id
 5a478bee46e88-36a2ff7d91fmr3444661eec.12.1793268018117; Thu, 29 Oct 2026
 03:00:18 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
In-Reply-To: <20261029-btrfs-zoned-active-zone-leak-v1-0-777dd01ff914@gmail.com>
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Thu, 29 Oct 2026 15:00:05 +0500
X-Gm-Features: AclHuK83BlPPV7_H23TeJ2xs5ky4kyB8aLO0AL_l-vZHvRN09V9scQgST6v9LKo
Message-ID: <CAEmTpZHvmyPWMFztcG4MT4jszwjXYuwogJKrJgvx2vxESjhnKg@mail.gmail.com>
Subject: Re: [PATCH 0/2] btrfs: zoned: fix silent data loss from leaked active
 zone reservation
To: socketpair@gmail.com
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="UTF-8"

Adding Johannes, as this overlaps with his recent zoned work.

A few notes on how this series relates to what is in btrfs for-next and
on the list:

- The series is based on master, but it applies cleanly to btrfs
  for-next as of today (c393445c12fc), only with line offsets.

- 0be761ecf1a9 ("btrfs: zoned: only change active zone counter on
  successful (de)activation") in for-next does not cover the leak fixed
  by patch 1: the block group removed by relocation gets its active bit
  cleared by the zone reset in btrfs_relocate_chunk_finish(), but
  reserved_active_zones is only given back in call_zone_finish(), which
  never runs for it.

- Patch 2 makes btrfs_zone_finish_one_bg() the normal path again when
  buffered writeback runs out of active zones with a negative
  reservation (cow_file_range() -> btrfs_reserve_extent() ->
  find_free_extent() -> btrfs_zone_finish_one_bg()). That is the path
  of the deadlock fixed by "btrfs: zoned: don't wait for ordered extents
  in do_zone_finish()" (30c6d31da683 in for-next), so for stable patch 2
  should go together with that one.

- Patch 1 and "[PATCH v6 21/25] btrfs: zoned: reuse block groups emptied
  by reclaim as relocation target" both change
  btrfs_relocate_chunk_finish(). The conflict is trivial, and the two
  fit together: btrfs_zoned_can_reuse_bg() requires the block group not
  to be active, which patch 1 makes sure of, so the
  btrfs_zone_finish_relocated() call has to stay before the reuse check.

I can resend the series on top of for-next, or on top of the generic/747
series, if that makes it easier to take.

Thanks,
Mark
