Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F20CC64EBC
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 23:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359272082A
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 23:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="MfpC5Zo3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 359272082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725746AbeJCGS1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 02:18:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37939 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeJCGS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2018 02:18:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id x17-v6so720577pfh.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2018 16:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zZtUj7mgytJ+9nyKwF4cmrud4VjO430Bgs8sUg5tvNU=;
        b=MfpC5Zo3MzPTB5WlmHDJvCwwDyvw+Q3sRnO2XdTlx8+21sLIlRJgClCrRfKEdaa5I/
         eVC/hphKy8fGlZwwdOAQoLozmUndDx4Mi/9Mbfifu88eAwHrfNJad5WoFEnWzYt6BXSd
         H1Qf3NSbB72+4EL4YBrAdJ4h90mRfyOOtgA0IlQ07ZTMUdlwJfH9+ocYMqHd05v2+mX6
         VwxAiSKoJD0/V7nDooSBKYoAEaf+vn6HNw7kghPHvJ/1yZ2cnDA7FZVvIPUVb+cbHRr2
         3AaQuJBFjAIqP9FPFz13S4jmESN0RGHlPawLccXRa4V2idENIiKBmPXPZiqvSTxNrFpZ
         2HfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zZtUj7mgytJ+9nyKwF4cmrud4VjO430Bgs8sUg5tvNU=;
        b=bAkFo9Hy1W+Z6+L82PXv33y7kx3fySR+WGs87VHN7aR8qlpU58AlfO7IYABG2auSZH
         BGa9V0/qSALUs0QCBLu3gPE7iXNq7jVvF4n7i4gOZEEqzbgpDu7erEB+EwBSeteYUKu2
         YbLpD4wnmgU5GOvvvmqhOLaFVs/ybqR38hbZohQUxbGRz+WdK1nT0pPiNIoA4cnjRu31
         OZ7lV818Rc5xaB54M3aijRMl6U8zx7vthItUBAE6whqsGnoJZ068bLre8pPd/2/cxle+
         kv67H2M2zj/U8VRHNKv+vswXZZWohihU3CIukDkdiPCLrUe3toZUcggfroz4XobS8eQ3
         q7wQ==
X-Gm-Message-State: ABuFfojabdzP741yXN7p8OtGsfrbvTTc8MuTuTFrqtJSFPYcLejgSgNo
        O0zZTz/yYpnwYmFt8YbPD5ztEg==
X-Google-Smtp-Source: ACcGV61X3ws7Mmf1lGrc3UYoa4FQyfn+Ns2N8MIBJSwjLckp7bJTtzvufMdVkQMxcqPH1PPmaFDgWA==
X-Received: by 2002:a62:7a81:: with SMTP id v123-v6mr18773211pfc.240.1538523157547;
        Tue, 02 Oct 2018 16:32:37 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::4:7d90])
        by smtp.gmail.com with ESMTPSA id 8-v6sm21484570pgu.10.2018.10.02.16.32.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Oct 2018 16:32:36 -0700 (PDT)
Date:   Tue, 2 Oct 2018 16:32:36 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/10] btrfs-progs: Replace homegrown bitops related
 functions with kernel counterparts
Message-ID: <20181002233236.GC25437@vader>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
 <1538405181-25231-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538405181-25231-4-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:46:14PM +0300, Nikolay Borisov wrote:
> Replace existing find_*_bit functions with kernel equivalent. This
> reduces duplication, simplifies the code (we really have one worker
> function _find_next_bit) and is quite likely faster. No functional
> changes.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  kernel-lib/bitops.h | 142 +++++++++++++++++-----------------------------------
>  1 file changed, 46 insertions(+), 96 deletions(-)
> 
> diff --git a/kernel-lib/bitops.h b/kernel-lib/bitops.h
> index 5b35f9fc5213..78256adf55be 100644
> --- a/kernel-lib/bitops.h
> +++ b/kernel-lib/bitops.h
> @@ -2,6 +2,7 @@
>  #define _PERF_LINUX_BITOPS_H_
>  
>  #include <linux/kernel.h>
> +#include "internal.h"
>  
>  #ifndef DIV_ROUND_UP
>  #define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> @@ -109,116 +110,65 @@ static __always_inline unsigned long __ffs(unsigned long word)
>  
>  #define ffz(x) __ffs(~(x))
>  
> +#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) & (BITS_PER_LONG - 1))) 
> +#define BITMAP_LAST_WORD_MASK(nbits) (~0UL >> (-(nbits) & (BITS_PER_LONG - 1)))
> +
>  /*
> - * Find the first set bit in a memory region.
> + * This is a common helper function for find_next_bit, find_next_zero_bit, and
> + * find_next_and_bit. The differences are:
> + *  - The "invert" argument, which is XORed with each fetched word before
> + *    searching it for one bits.
> + *  - The optional "addr2", which is anded with "addr1" if present.
>   */
> -static inline unsigned long
> -find_first_bit(const unsigned long *addr, unsigned long size)
> +static inline unsigned long _find_next_bit(const unsigned long *addr1,
> +		const unsigned long *addr2, unsigned long nbits,
> +		unsigned long start, unsigned long invert)
>  {
> -	const unsigned long *p = addr;
> -	unsigned long result = 0;
>  	unsigned long tmp;
>  
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if ((tmp = *(p++)))
> -			goto found;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> +	if (start >= nbits)
> +		return nbits;
> +
> +	tmp = addr1[start / BITS_PER_LONG];
> +	if (addr2)
> +		tmp &= addr2[start / BITS_PER_LONG];
> +	tmp ^= invert;
> +
> +	/* Handle 1st word. */
> +	tmp &= BITMAP_FIRST_WORD_MASK(start);
> +	start = round_down(start, BITS_PER_LONG);
> +
> +	while (!tmp) {
> +		start += BITS_PER_LONG;
> +		if (start >= nbits)
> +			return nbits;
> +
> +		tmp = addr1[start / BITS_PER_LONG];
> +		if (addr2)
> +			tmp &= addr2[start / BITS_PER_LONG];
> +		tmp ^= invert;
>  	}
> -	if (!size)
> -		return result;
> -
> -	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
> -	if (tmp == 0UL)		/* Are any bits set? */
> -		return result + size;	/* Nope. */
> -found:
> -	return result + __ffs(tmp);
> +
> +	return min(start + __ffs(tmp), nbits);
>  }
>  
>  /*
>   * Find the next set bit in a memory region.
>   */
> -static inline unsigned long
> -find_next_bit(const unsigned long *addr, unsigned long size,
> -	      unsigned long offset)
> +static inline unsigned long find_next_bit(const unsigned long *addr,
> +					  unsigned long size,
> +					  unsigned long offset)
>  {
> -	const unsigned long *p = addr + BITOP_WORD(offset);
> -	unsigned long result = offset & ~(BITS_PER_LONG-1);
> -	unsigned long tmp;
> -
> -	if (offset >= size)
> -		return size;
> -	size -= result;
> -	offset %= BITS_PER_LONG;
> -	if (offset) {
> -		tmp = *(p++);
> -		tmp &= (~0UL << offset);
> -		if (size < BITS_PER_LONG)
> -			goto found_first;
> -		if (tmp)
> -			goto found_middle;
> -		size -= BITS_PER_LONG;
> -		result += BITS_PER_LONG;
> -	}
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if ((tmp = *(p++)))
> -			goto found_middle;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> -	}
> -	if (!size)
> -		return result;
> -	tmp = *p;
> -
> -found_first:
> -	tmp &= (~0UL >> (BITS_PER_LONG - size));
> -	if (tmp == 0UL)		/* Are any bits set? */
> -		return result + size;	/* Nope. */
> -found_middle:
> -	return result + __ffs(tmp);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL);
>  }
>  
> -/*
> - * This implementation of find_{first,next}_zero_bit was stolen from
> - * Linus' asm-alpha/bitops.h.
> - */
> -static inline unsigned long
> -find_next_zero_bit(const unsigned long *addr, unsigned long size,
> -		   unsigned long offset)
> +static inline unsigned long find_next_zero_bit(const unsigned long *addr,
> +					       unsigned long size,
> +					       unsigned long offset)
>  {
> -	const unsigned long *p = addr + BITOP_WORD(offset);
> -	unsigned long result = offset & ~(BITS_PER_LONG-1);
> -	unsigned long tmp;
> -
> -	if (offset >= size)
> -		return size;
> -	size -= result;
> -	offset %= BITS_PER_LONG;
> -	if (offset) {
> -		tmp = *(p++);
> -		tmp |= ~0UL >> (BITS_PER_LONG - offset);
> -		if (size < BITS_PER_LONG)
> -			goto found_first;
> -		if (~tmp)
> -			goto found_middle;
> -		size -= BITS_PER_LONG;
> -		result += BITS_PER_LONG;
> -	}
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if (~(tmp = *(p++)))
> -			goto found_middle;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> -	}
> -	if (!size)
> -		return result;
> -	tmp = *p;
> -
> -found_first:
> -	tmp |= ~0UL << size;
> -	if (tmp == ~0UL)	/* Are any bits zero? */
> -		return result + size;	/* Nope. */
> -found_middle:
> -	return result + ffz(tmp);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL);
>  }
> +
> +#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
> +
>  #endif
> -- 
> 2.7.4
> 
