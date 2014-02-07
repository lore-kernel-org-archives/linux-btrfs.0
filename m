Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:48870 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaBGOFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 09:05:17 -0500
Message-ID: <52F4E817.5080406@kingswood-consulting.co.uk>
Date: Fri, 7 Feb 2014 14:05:11 +0000
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
MIME-Version: 1.0
To: <kreijack@inwind.it>
CC: Goffredo Baroncelli <kreijack@libero.it>, Roman Mamedov <rm@romanrm.net>,
        Brendan Hide <brendan@swiftspirit.co.za>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Provide a better free space estimate on RAID1
References: <20140206021516.304732cd@natsu>	<52F33BE7.4020708@swiftspirit.co.za> <20140206184502.128b7dbe@natsu> <52F3E86B.4030805@libero.it>
In-Reply-To: <52F3E86B.4030805@libero.it>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/02/14 19:54, Goffredo Baroncelli wrote:
> Hi Roman
>
> On 02/06/2014 01:45 PM, Roman Mamedov wrote:
>> There's not a lot of code to include (as my 3-line patch demonstrates), it
>> could just as easily be removed when it's obsolete. But I did not have any
>> high hopes of defeating the "broken by design" philosophy, that's why I didn't
>> submit it as a real patch for inclusion but rather just as a helpful hint for
>> people to add to their own kernels if they want this change to happen.
>
> I agree with you about the needing of a solution. However your patch to me seems even worse than the actual code.
>
> For example you cannot take in account the mix of data/linear and metadata/dup (with the pathological case of small files stored in the metadata chunks ), nor different profile level like raid5/6 (or the future raidNxM)
> And do not forget the compression...

Just because the solution that Roman provided is not perfect does not 
mean that it is no good at all. For common use cases this will give a 
much better estimate of free space than the current code does, at a 
trivial cost in code size.

It has the benefit of giving a simple estimate without doing any further 
work or disk activity (no need to walk all chunks).

Adding a couple of more lines of code will make it work equally well 
with other RAID levels, maybe that would be more acceptable?

Frank

