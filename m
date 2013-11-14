Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:34930 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3KNVbQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 16:31:16 -0500
Message-ID: <5285411F.5020805@libero.it>
Date: Thu, 14 Nov 2013 22:31:11 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: btrfsRe: Does btrfs "raid1" actually provide any resilience?
References: <l62akc$ujc$1@ger.gmane.org> <528514CA.8080903@libero.it> <528536F7.6030503@libero.it> <A0F65AC7-D109-47AB-AA1B-9156A33E86A5@colorremedies.com>
In-Reply-To: <A0F65AC7-D109-47AB-AA1B-9156A33E86A5@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-14 22:22, Chris Murphy wrote:
> 
> On Nov 14, 2013, at 1:47 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>>
>> Instead if I use the btrfs-progs c652e4efb8e2dd7... I got
>>
>> [snip]
> 
>> Data+Metadata: total=8.00MB, used=28.00KB
>>
>> Note the absence of any RAID1 profile.
> 
> What happens if the devices are large enough to avoid mandatory block group mixing? Try 100GB for each device. Is the problem reproducible?

It seems related to the mixing (see my other email). Even looking at the
code and doing some tests seems to confirm that.

> 
> Chris Murphy--

Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
