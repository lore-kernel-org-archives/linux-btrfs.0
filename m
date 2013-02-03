Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3BCQTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Feb 2013 11:19:13 -0500
Message-ID: <510E8DFD.8070906@redhat.com>
Date: Sun, 03 Feb 2013 10:19:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BTRFS-PROGS][PATCH] remove __attribute_const__ from raid6.c
References: <510D7356.4030903@inwind.it> <510E8898.4050606@redhat.com>
In-Reply-To: <510E8898.4050606@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/3/13 9:56 AM, Eric Sandeen wrote:
> On 2/2/13 2:13 PM, Goffredo Baroncelli wrote:
>> Hi all,
>>
>> I am playing with the new branch raid56-experimental. Unfortunately 
>> I was not able to compile the btrfs-progs tools because my gcc was unable 
>> to find '__attribute_const__':
>>
>> [...]
>> raid6.c:48:1: error: unknown type name ‘__attribute_const__’
>> raid6.c:48:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘SHLBYTE’
>> raid6.c:60:1: error: unknown type name ‘__attribute_const__’
>> raid6.c:60:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘MASK’
>> [...]
> 
> Something like this might be more in the spirit of the kernel code copy,
> and will keep the annotations.  (I'm not sure why the kernel does it
> this way, TBH).

Meh, that doesn't compile either, will look later, sorry.

-Eric

> 
> From: Eric Sandeen <sandeen@redhat.com>
> 
> btrfs-progs: define __attribute_const__ in kerncompat.h
> 
> Without this we can't build userspace.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> 
> diff --git a/kerncompat.h b/kerncompat.h
> index d60f722..8004f9e 100644
> --- a/kerncompat.h
> +++ b/kerncompat.h
> @@ -126,6 +126,8 @@ static inline int mutex_is_locked(struct mutex *m)
>  #define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
>  #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
>  
> +#define __attribute_const__	__attribute__((const))
> +
>  /**
>   * __set_bit - Set a bit in memory
>   * @nr: the bit to set
> diff --git a/raid6.c b/raid6.c
> index 3a42bdf..ce0f655 100644
> --- a/raid6.c
> +++ b/raid6.c
> @@ -19,6 +19,8 @@
>   */
>  #include <stdint.h>
>  #include <unistd.h>
> +#include "kerncompat.h"
> +
>  /*
>   * This is the C data type to use
>   */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

