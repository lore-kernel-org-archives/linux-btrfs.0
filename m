Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40661 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaIKVnw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 17:43:52 -0400
Received: by mail-ob0-f173.google.com with SMTP id m8so685931obr.18
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 14:43:51 -0700 (PDT)
Message-ID: <54121651.50004@converseincode.com>
Date: Thu, 11 Sep 2014 16:38:25 -0500
From: Behan Webster <behanw@converseincode.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, jbacik@fb.com
CC: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] btrfs: LLVMLinux: Remove VLAIS
References: <1409957901-28962-1-git-send-email-behanw@converseincode.com> <5411B304.4000203@fb.com>
In-Reply-To: <5411B304.4000203@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/11/14 09:34, Chris Mason wrote:
>
> On 09/05/2014 06:58 PM, behanw@converseincode.com wrote:
>> From: Vinícius Tinti <viniciustinti@gmail.com>
>>
>> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
>> compliant equivalent. This is the original VLAIS struct.
>>
>> struct {
>> 	struct shash_desc shash;
>> 	char ctx[crypto_shash_descsize(tfm)];
>> } desc;
>>
>> This patch instead allocates the appropriate amount of memory using an char
>> array.
>>
>> The new code can be compiled with both gcc and clang.
>>
>> struct shash_desc contains a flexible array member member ctx declared with
>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
>> of the array declared after struct shash_desc with long long.
>>
>> No trailing padding is required because it is not a struct type that can
>> be used in an array.
>>
>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
>> as would be the case for a struct containing a member with
>> CRYPTO_MINALIGN_ATTR.
> We copied this from one of the other crypto api users, and I'm sure
> cooking up all these patches was not a great way to your afternoon.
>
> But, can I talk you into making a helper macro of some kind for this and
> putting it into the crypto api headers?  Honestly this setup seems
> really error prone.
You're not the only person to ask for this. I've got one already coded 
up based on suggestions from tglx.

I've regenerated all the patches. I will resubmit soon.

Will fix.

Behan

-- 
Behan Webster
behanw@converseincode.com

