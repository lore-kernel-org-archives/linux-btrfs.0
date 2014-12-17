Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35-i2.italiaonline.it ([212.48.25.208]:50896 "EHLO
	smtp-35.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaLQS57 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 13:57:59 -0500
Message-ID: <5491D290.6090706@inwind.it>
Date: Wed, 17 Dec 2014 19:59:28 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] Print the summary
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>	<1418673780-22000-7-git-send-email-kreijack@inwind.it> <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
In-Reply-To: <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2014 02:58 AM, Duncan wrote:
> Goffredo Baroncelli posted on Mon, 15 Dec 2014 21:02:59 +0100 as
> excerpted:
> 
>> +	printf("  Total disks size:                          %10s\n",
>> +		pretty_size(total_block_count));
> 
> I really like this patch series. Makes mkfs.btrfs much nicer to use. =:^)
> 
> I'm not a dev and won't attempt a technical review, but three very minor 
> and quick nits:
> 
> * Please s/disk/device/, here and possibly elsewhere.  I know I'm not the 
> only one who is trying to make the switch in my own usage, as it looks a 
> bit foolish (and/or marks the user as an old fogey who's likely to start 
> lecturing about how a GiB isn't "small", as I'm known to do at times! 
> =:^) already, as it's only going to be more so over time.

Ok, I agree

> 
> * patch title typo and omission, patch 7:  There's a good chance you 
> already caught it, but just in case, for the next version, s/-o/-q/, and 
> please mention it's /documentation/ that's patched here (patch 1 adds the 
> switches to the code).

Ok
> 
> * Also in patch 7, first chunk, -q|--quiet is added twice...

good catch for that
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
