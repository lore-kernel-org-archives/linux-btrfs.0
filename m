Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:49107 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab3KURh1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 12:37:27 -0500
Message-ID: <528E44D3.8050705@libero.it>
Date: Thu, 21 Nov 2013 18:37:23 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: David Brown <david.brown@hesbynett.no>
CC: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy> <528C9297.9030801@hesbynett.no> <20131120215939.GA2622@lazy.lzy> <528DDCC9.7050701@hesbynett.no>
In-Reply-To: <528DDCC9.7050701@hesbynett.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-21 11:13, David Brown wrote:
> On 20/11/13 22:59, Piergiorgio Sartor wrote:
>> On Wed, Nov 20, 2013 at 11:44:39AM +0100, David Brown wrote:
>> [...]
>>>> In RAID-6 (as per raid6check) there is an easy way
>>>> to verify where an HDD has incorrect data.
>>>>
>>>
>>> I think the way to do that is just to generate the parity blocks from
>>> the data blocks, and compare them to the existing parity blocks.
>>
>> Uhm, the generic RS decoder should try all
>> the possible combination of erasure and so
>> detect the error.
>> This is unfeasible already with 3 parities,
>> so there are faster algorithms, I believe:
>>
>> Peterson–Gorenstein–Zierler algorithm
>> Berlekamp–Massey algorithm
>>
>> Nevertheless, I do not know too much about
>> those, so I cannot state if they apply to
>> the Cauchy matrix as explained here.
>>
>> bye,
>>
> 
> Ah, you are trying to find which disk has incorrect data so that you can
> change just that one disk?  There are dangers with that...
> 
> <http://neil.brown.name/blog/20100211050355>
> 
> If you disagree with this blog post (and I urge you to read it in full
> first), then this is how I would do a "smart" stripe recovery:
> 
> 
> First calculate the parities from the data blocks, and compare these
> with the existing parity blocks.
> 
> If they all match, the stripe is consistent.
> 
> Normal (detectable) disk errors and unrecoverable read errors get
> flagged by the disk and the IO system, and you /know/ there is a problem
> with that block.  Whether it is a data block or a parity block, you
> re-generate the correct data and store it - that's what your raid is for.
> 
> If you have no detected read errors, and there is one parity
> inconsistency, then /probably/ that block has had an undetected read
> error, or it simply has not been written completely before a crash.
> Either way, just re-write the correct parity.
> 
> If there are two or more parity inconsistencies, but not all parities
> are in error, then you either have multiple disk or block failures, or
> you have a partly-written stripe.  Any attempts at "smart" correction
> will almost certainly be worse than just re-writing the new parities and
> hoping that the filesystem's journal works.
> 
> If all the parities are inconsistent, then the "smart" thing is to look
> for a single incorrect disk block.  Just step through the blocks one by
> one - assume that block is wrong and replace it (in temporary memory,
> not on disk!) with a recovered version from the other data blocks and
> the parities (only the first parity is needed).  Re-calculate the other
> parities and compare.  If the other parities now match, then you have
> found a single inconsistent data block.  It /may/ be a good idea to
> re-write this - or maybe not (see the blog post linked above).
> 
> If you don't find any single data blocks that can be "corrected" in this
> way, then re-writing the parity blocks to match the disk data is
> probably the least harmful fix.

It has to be pointed out that all filesystems or are trying to integrate
or have integrated some sort of checksumming to avoid guessing which
between the data and/or the parity is wrong:
- btrfs is fully checksummed
- zfs is fully checksummed
- ext4 and xfs are trying to checksumming the metadata [1][2]
- refs (Windows) protects with checksum the metadata and (optionally)
the data [3]

We are talking about


[1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
[2] http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf
[3] http://en.wikipedia.org/wiki/ReFS

> 
> 
> Remember, this is not a general error detection and correction scheme -
> it is a system targeted for a particular type of use, with particular
> patterns of failure and failure causes, and particular mechanisms on top
> (journalled file systems) to consider.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
