Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:49091 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaBFTye (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 14:54:34 -0500
Message-ID: <52F3E86B.4030805@libero.it>
Date: Thu, 06 Feb 2014 20:54:19 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
References: <20140206021516.304732cd@natsu>	<52F33BE7.4020708@swiftspirit.co.za> <20140206184502.128b7dbe@natsu>
In-Reply-To: <20140206184502.128b7dbe@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Roman

On 02/06/2014 01:45 PM, Roman Mamedov wrote:
> On Thu, 06 Feb 2014 09:38:15 +0200
[...]
> 
> There's not a lot of code to include (as my 3-line patch demonstrates), it
> could just as easily be removed when it's obsolete. But I did not have any
> high hopes of defeating the "broken by design" philosophy, that's why I didn't
> submit it as a real patch for inclusion but rather just as a helpful hint for
> people to add to their own kernels if they want this change to happen.


I agree with you about the needing of a solution. However your patch to me seems even worse than the actual code.

For example you cannot take in account the mix of data/linear and metadata/dup (with the pathological case of small files stored in the metadata chunks ), nor different profile level like raid5/6 (or the future raidNxM)
And do not forget the compression...

The situation is very complex. I am inclined to use a different approach.

As you know, btrfs allocate space in chunk. Each chunk has an own ration between the data occupied on the disk, and the data available to the filesystem. For SINGLE the ratio is 1, for DUP/RAID1/RAID10 the ratio is 2, for raid 5 the ratio is n/(n-1) (where n is the stripes count), for raid 6 the ratio is n/(n-2)....

Because a filesystem could have chunks with different ratios, we can compute a global ratio as the composition of the each chunk ratio:

for_each_chunk:
	all_chunks_size += chunk_size[i]

for_each_chunk:
	global_ratio += chunk_ratio[i] * chunk_size[i] / all_chunks_size

If we assume that this ratio is constant during the live of the filesystem, we can use it to get an estimation of the space available to the users as:

	free_space = (all_disks_size-all_chunks_size)/global_ratio


The code above is a simplification, because we should take in account also the space available on each _already_allocated_ chunk.
We could further enhance this estimation, taking in account also the total files sizes and their space consumed in the chunks (this could be different due to the compression)

Even tough not perfect, it would be a better estimation than the actual one. 


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
