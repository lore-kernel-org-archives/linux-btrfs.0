Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2193B14A2
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Aug 2026 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788090223; cv=none; b=FiaepDZkDxKH1Dyj7+PKvo1pg62PwCRlZ/zp4ncPXFZzo7d8iiRp0isPKE3exID9CMjD3hEFwEKkaSxUxqVmZDkdvXhaHd+w7xaTKlUtDUI1YBnZCnTRKYkZQ6cBa6DDjD+3aFdL1ld1NzRmyCBWiWyA6ZKxixgrgURU4/syVNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788090223; c=relaxed/simple;
	bh=ZSBcoQd59itycfzYZkz0w0S+20hQkmQsFxDYsaMFR3s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsaiJKdg52tVWksT+/a5bHUoSwR36WW3RrMcG2JT27fDqNzdt4qE7r5LRl4UH2LvHfw3ZXVqWgLwfaUfcJcWsRD/HUpFtFKup3GWxcclDK4UO9RrrO0FllDIwpo8/ke45TQhm/Z4XXmh8zi2uzIlN5YBb5emeio4Lf+Lv/5+55s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edPIi5Q+; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edPIi5Q+"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so21520025e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Aug 2026 04:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090219; x=1788695019; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WlfkYyar9vumibw7mRgIAgoFjQzAhszDTK4deysoT4I=;
        b=edPIi5Q+OpL5K0wrWuEECGgjvO4wRDh/IjeR4XbmFuaGG73HoijSuPnQbZG38eTRw+
         lcUdJ6vRtCgWLBdicYlvHczEQ8qOuDIjZnzkt58Pog9a4mVqXvNyciBl4VaCCReEYS5g
         ZWXEm9BNIJ3N6eTaM8HmNAErtpiabk/IqXmM12kMUfpMXPWlrVd5BLEsaclw7gB0lCKt
         0srVDVG7f2/c4l1WCuXz5ssn78n8j5Fa5iYSyFtk0Mf6JEQmewRpQnOZv4DPaAPOtffY
         eLRm0lfPFHBBLpVvoEX77uWxH/Vv9PRUHS/IXEsFFLRsrNK3WgJmxFTxbvFNchakbBQC
         QR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090219; x=1788695019;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlfkYyar9vumibw7mRgIAgoFjQzAhszDTK4deysoT4I=;
        b=MBVClzI0sCk3LJZ3OQSv135z3BXmJzEURfAmHyJ0o2xPwFmg7iDQ7Yqn4QGeo7BcXP
         E3PUJda59v/QIDk/fnyARl2OHx7l9i4jn4is017waAt8cwFdLlBvX+9l9M2Rtz0KVheC
         NNwMPNCUweLOmZ+F0ypXFQ2pJCeudPLc301GOR1+CpM1GBpiL6hXdxFYxzXHez3/jnaJ
         QLE3Nz/75wHMLmjE/+6isVEyUkCYTeUnOiJL6imHKyr4w3j9/m9Pl+FpLnVL76NqNs4t
         Cgku280Udlpb86ftSX1gEIkit0YpCxA6sI2Z/MoXFwjOYthg9uInqGoN+mL0Qn/dOfBS
         5+2w==
X-Forwarded-Encrypted: i=1; AHgh+Rqc/qEUupnljTHjpGrg5KyE1lA2bfcHZ253FV/Jxlct2DLCeXFjIBc7Fei6P4uMS7sL5THVTAMSuGMslQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nnC58HFqR6zDBqqFnSIR6hHIytrHmCEjjYXmuRjfcQsMJpd0JP
	JqF2Mu1bVmomypjzgf5WIE/oHHp9Nm5DGwXSxqqUCRk2aPIPatBpCnSQ
X-Gm-Gg: AR+sD10K8D6tML/ovY60QlxIwP2ZFP9UFvrFxFlyefgrdstIG+14BmP4La6jErJRFDd
	jpPswtMMcE5LA3pFvN6LKH3ZXNtex73ZldzKRx2R6dc/YWBiad9wAz6IyjUAnsp3NBVr08QiEl/
	GlKsaAKTFMNd0Br+HnEoCSzcdwf11BMOHARRmcksGbsbk+88jRBQHMZYADvLEd0Bru/CxOW8M2t
	ctCflL2yGnwBLzJpmx51ezBsgw875HiApdM3ZEwgj2aMZ3xmnrvPvt1Qxb3pexgYpWLcgUsoozd
	VrwXGwunobzrY7FFu9M7ZWfqGwMJUblvj6F60SYeJEVrRWc5mrvcaHdWPoFsBs76OAjnz8MgkiM
	0NndYsYWcx/DNaZM5Ha6BxkNcKNzKpFFe+HYlTQJHxkdz3JliFIYgJRMF9ZUtbnGOh4GdFSaA0U
	xp8q8sNgG2Y5pDrbf0S4a/0o+y8/hNg8aqODanQ9MOSBuvnU0JVmt0yIZFzlkwrNLrk8IevA5fH
	5YsD4xr6FexBxPrsNcQ+MOJzJBTC0jPocl1
X-Received: by 2002:a05:600c:a016:b0:49c:d60c:74e0 with SMTP id 5b1f17b1804b1-49cd60c74eemr23912455e9.13.1788090219141;
        Sun, 30 Aug 2026 04:43:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dc1076sm195266535e9.3.2026.08.30.04.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:43:38 -0700 (PDT)
Date: Sun, 30 Aug 2026 12:43:34 +0100
From: David Laight <david.laight.linux@gmail.com>
To: David Gow <david@davidgow.net>
Cc: Jim Cromie <jim.cromie@gmail.com>, "Maciej W . Rozycki"
 <macro@orcam.me.uk>, Andrew Morton <akpm@linux-foundation.org>, Matthew
 Auld <matthew.auld@intel.com>, Arun Pravin
 <arunpravin.paneerselvam@amd.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Chris
 Mason <mason@kernel.org>, David Sterba <dsterba@suse.com>,
 dri-devel@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] linux/log2.h: Add 64-bit safe variants of
 power-of-two functions
Message-ID: <20260830124334.105b84b1@pumpkin>
In-Reply-To: <20260830103321.2042968-1-david@davidgow.net>
References: <20260830103321.2042968-1-david@davidgow.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Aug 2026 18:33:15 +0800
David Gow <david@davidgow.net> wrote:

> The existing roundup_pow_of_two() and rounddown_pow_of_two() functions work
> on values of type unsigned long, which is 32-bit on 32-bit systems.
> Equally, is_power_of_2() operates on an unsigned long.
> 
> There are several instances where 64-bit safe versions of these (which
> operate on a 64-bit value regardless of sizeof(long)) are required. Most
> particularly, some hardware (especially GPUs) have 64-bit address spaces,
> and some formats (such as filesystems) use 64-bit offsets. Some of these
> (such as i915 and btrfs) have already implemented their own 64-bit
> is_power_of_2() helpers.
> 
> Add a version of these which always operate on a 64-bit value. These have
> the (unimaginative) names:
> - is_power_of_2_u64()
> - roundup_pow_of_two_u64(), and
> - rounddown_pow_of_two_u64()
> and otherwise work identically to their unsigned long counterparts.

Why not just change the definitions (back?) to #defines.
Then they can be size neutral and you don't have to guess the correct one.

You may need to use __builtin_constant_p(x <= ~0u) to select between 32 and
64 bit versions.

It is also worth checking what gcc/clang generate for the 64bit versions
on 32bit when passed a 32bit variable.
It might be that they optimise the code and avoid all the 64bit maths.

David

> 
> To avoid conflicts, the i915 implementation is also removed here. The btrfs
> one (which has a different name) is replaced in a separate patch.
> 
> Signed-off-by: David Gow <david@davidgow.net>
> ---
> 
> This patch adds u64 helpers, and the following two use them. And v2 also
> has the i915 change to remove the conflicting implementation.
> 
> So I'm not sure who best wants to take these. Ultimately it's an include/linux
> change, but it touches i915, patch 2 touches GPU/DRM, and patch 3 btrfs.
> Personally, I'm keen to get patch 2 in, as it fixes a real issue, so if taking
> 1 and 2 via DRM makes more sense, that's fine by me.
> 
> Changes since v1:
> https://lore.kernel.org/all/20260821091918.1902032-1-david@ingeniumdigital.com/
> - Include is_power_of_2_u64() as well, and remove the i915 version
>   (Thanks, Matthew)
> - Use _u64 as a suffix for the 64-bit versions, not just 64
>   (This is a much nicer name, and matches what everone else was doing)
> - Fix some comment typos.
> - Add a third patch which removes a similar is_power_of_two_u64() helper
>   from btrfs.
> 
> ---
>  drivers/gpu/drm/i915/i915_utils.h |  5 ---
>  include/linux/log2.h              | 73 +++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
> index ecc20e0528f4..1cec51984d8c 100644
> --- a/drivers/gpu/drm/i915/i915_utils.h
> +++ b/drivers/gpu/drm/i915/i915_utils.h
> @@ -75,11 +75,6 @@ struct drm_i915_private;
>  	__idx;								\
>  })
>  
> -static inline bool is_power_of_2_u64(u64 n)
> -{
> -	return (n != 0 && ((n & (n - 1)) == 0));
> -}
> -
>  void add_taint_for_CI(struct drm_i915_private *i915, unsigned int taint);
>  static inline void __add_taint_for_CI(unsigned int taint)
>  {
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index e17ceb32e0c9..fc44e59f5732 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -47,6 +47,22 @@ bool is_power_of_2(unsigned long n)
>  	return n - 1 < (n ^ (n - 1));
>  }
>  
> +/**
> + * is_power_of_2_u64() - check if a 64-bit value is a power of two
> + * @n: the value to check
> + *
> + * Determine whether some value is a power of two, where zero is
> + * *not* considered a power of two. Unlike is_power_of_2, this version
> + * always operates on 64-bit values, even on 32-bit architectures where
> + * long is 32-bit.
> + * Return: true if @n is a power of 2, otherwise false.
> + */
> +static __always_inline __attribute_const__
> +bool is_power_of_2_u64(u64 n)
> +{
> +	return n - 1 < (n ^ (n - 1));
> +}
> +
>  /**
>   * __roundup_pow_of_two() - round up to nearest power of two
>   * @n: value to round up
> @@ -195,6 +211,63 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>  	__rounddown_pow_of_two(n)		\
>   )
>  
> +/**
> + * __rounddown_pow_of_two_64() - round a 64-bit value down to nearest power of two
> + * @n: value to round down
> + */
> +static inline __attribute_const__
> +u64 __rounddown_pow_of_two_u64(u64 n)
> +{
> +	return 1ULL << ilog2(n);
> +}
> +
> +/**
> + * rounddown_pow_of_two_u64 - round a 64-bit value down to nearest power of two
> + * @n: parameter
> + *
> + * round the given value down to the nearest power of two
> + * - this always operates on 64-bit values, even on 32-bit systems
> + * - the result is undefined when n == 0
> + * - this can be used to initialise global variables from constant data
> + */
> +#define rounddown_pow_of_two_u64(n)		\
> +(						\
> +	__builtin_constant_p(n) ? (		\
> +		((n) == 1) ? 1ULL :		\
> +		(1ULL << ilog2((n)))		\
> +				   ) :		\
> +	__rounddown_pow_of_two_u64(n)		\
> +)
> +
> +
> +/**
> + * __roundup_pow_of_two_u64() - round a 64-bit value up to nearest power of two
> + * @n: value to round up
> + */
> +static inline __attribute_const__
> +u64 __roundup_pow_of_two_u64(u64 n)
> +{
> +	return 1ULL << (ilog2(n - 1) + 1);
> +}
> +
> +/**
> + * roundup_pow_of_two_u64 - round a 64-bit value up to nearest power of two
> + * @n: parameter
> + *
> + * round the given value up to the nearest power of two
> + * - this always operates on 64-bit values, even on 32-bit systems
> + * - the result is undefined when n == 0
> + * - this can be used to initialise global variables from constant data
> + */
> +#define roundup_pow_of_two_u64(n)		\
> +(						\
> +	__builtin_constant_p(n) ? (		\
> +		((n) == 1) ? 1ULL :		\
> +		(1ULL << (ilog2((n) - 1) + 1))	\
> +				   ) :		\
> +	__roundup_pow_of_two_u64(n)		\
> +)
> +
>  static inline __attribute_const__
>  int __order_base_2(unsigned long n)
>  {

