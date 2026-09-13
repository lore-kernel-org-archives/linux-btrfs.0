Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C6B344DBD;
	Sun, 13 Sep 2026 08:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789289318; cv=none; b=HGfYy3/H0/6kzrkEywYN+7S1vi1cIKUtwClnfrYagEHxI086H/NwMBqBbGcKnaWIR9ILoUQdsUochqxzRMPO90xeGnVkrdXQ1RoLO1Bxuy5rCDrJ+i5/R9egXYy5rar5wI0dOUQg3K0XWur5jb4bUKQS9vXWGtzhkPmCXcJYQUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789289318; c=relaxed/simple;
	bh=V7Xekxc8np1jOvBEx3JQDII4A1pWfylJcA2MxHU3MGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4uaFOUSfiCewX6Uh4lMhf/rt+OZEwKAEiFy07LHC3nsqXUr5+y7sI76PSvXv28u28qR/IaD8Q/vUBZpcUd1ceITftYdao64GuIvTJjuUBAyad9gHojf+K4NTwFuTA4zwKrZIl+s1QrkDL6kEuu9YiZYOx2BKIJ5zFhd6oxXhNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id B97FD1EAB35; Sun, 13 Sep 2026 16:41:41 +0800 (AWST)
X-Spam-Level: 
Received: from [IPV6:2001:8003:8802:7000::41b] (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id D4C351EAB2B;
	Sun, 13 Sep 2026 16:41:37 +0800 (AWST)
Message-ID: <264b81f5-d975-45d3-9bbb-d5759971cf6d@davidgow.net>
Date: Sun, 13 Sep 2026 16:41:35 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] linux/log2.h: Add 64-bit safe variants of
 power-of-two functions
To: David Laight <david.laight.linux@gmail.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, "Maciej W . Rozycki"
 <macro@orcam.me.uk>, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Auld <matthew.auld@intel.com>,
 Arun Pravin <arunpravin.paneerselvam@amd.com>,
 Joel Fernandes <joelagnelf@nvidia.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Mason <mason@kernel.org>,
 David Sterba <dsterba@suse.com>, dri-devel@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260830103321.2042968-1-david@davidgow.net>
 <20260830124334.105b84b1@pumpkin>
Content-Language: en-US
From: David Gow <david@davidgow.net>
In-Reply-To: <20260830124334.105b84b1@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 30/08/2026 à 19:43, David Laight a écrit :
> On Sun, 30 Aug 2026 18:33:15 +0800
> David Gow <david@davidgow.net> wrote:
> 
>> The existing roundup_pow_of_two() and rounddown_pow_of_two() functions work
>> on values of type unsigned long, which is 32-bit on 32-bit systems.
>> Equally, is_power_of_2() operates on an unsigned long.
>>
>> There are several instances where 64-bit safe versions of these (which
>> operate on a 64-bit value regardless of sizeof(long)) are required. Most
>> particularly, some hardware (especially GPUs) have 64-bit address spaces,
>> and some formats (such as filesystems) use 64-bit offsets. Some of these
>> (such as i915 and btrfs) have already implemented their own 64-bit
>> is_power_of_2() helpers.
>>
>> Add a version of these which always operate on a 64-bit value. These have
>> the (unimaginative) names:
>> - is_power_of_2_u64()
>> - roundup_pow_of_two_u64(), and
>> - rounddown_pow_of_two_u64()
>> and otherwise work identically to their unsigned long counterparts.
> 
> Why not just change the definitions (back?) to #defines.
> Then they can be size neutral and you don't have to guess the correct one.
> 
> You may need to use __builtin_constant_p(x <= ~0u) to select between 32 and
> 64 bit versions.

I've given this a go, and (with some ugly typeof() casting) something 
like this works:

---
#define rounddown_pow_of_two(n)				\
	__builtin_constant_p(n) ? (			\
		((typeof(n)1UL << ilog2(n)) :		\
		(sizeof(n) <= 4) ?			\
			1UL << (fls(n) - 1) :		\
			(typeof(n))1UL << (fls64(n) - 1)\
)
---

Unfortunately, there are enough random places where the function 
__round{up,down}_pow_of_two() is called directly that it's turning this 
into a more involved series than I'd want to push through for a simple fix.

I'll re-send patch 2 in it's original form (without the helper changes) 
so we can at least fix the buddy allocator breakage, and then put 
together a more complete version of this series with all of the various 
callsite fixes, and a KUnit test to verify it works properly across both 
32-bit and 64-bit values.

> 
> It is also worth checking what gcc/clang generate for the 64bit versions
> on 32bit when passed a 32bit variable.
> It might be that they optimise the code and avoid all the 64bit maths.
My quick look suggested that gcc and clang were not doing anything 
excessively stupid here. The only really dubious case was for the 
roundup variant, which does end up doing the 64-bit subtraction. That 
being said, I wasn't able to come up with anything significantly better 
(particularly given that we're already pretty register constrained).

Regardless, I'll take another look at this before sending the full series.

Cheers,
-- David

