Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx194.callplus.net.nz ([202.180.66.194]:24657 "EHLO
	mxi2.callplus.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503Ab2IVV5G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Sep 2012 17:57:06 -0400
Message-ID: <505E3412.4010900@theflat.net.nz>
Date: Sun, 23 Sep 2012 09:56:34 +1200
From: Jp Wise <jpwise@theflat.net.nz>
Reply-To: jpwise@theflat.net.nz
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
References: <505D32C2.8070105@theflat.net.nz> <505D6D87.1070403@gmx.net>
In-Reply-To: <505D6D87.1070403@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 22/09/2012 7:49 p.m., Arne Jansen wrote:
> On 09/22/12 05:38, Jp Wise wrote:
>> Good morning, I'm working on an offline deduplication script intended to
>> work around the copy-on-write functionality of BTRFS.
>>
>> Simply put - is there any existing utility to compare two files (or
>> dirs) and output if the files share the same physical extents / data
>> blocks on disk?
>> - aka - they're CoW copies.
>>
>> I'm not actively working with BTRFS yet, but for the project i'm working
>> on it's looking to the be most suitable candidate, and the CoW
>> functionality avoids issues with file changes that hardlinks would create.
>>  From reading other posts, aware the information could be pulled out via
>> btrfs-debug-tree, but it would then involve parsing the entire output to
>> locate the required files inodes and their extents which seems like
>> quite a roundabout way to retrieve the information.
>>
>> Also my programming skills aren't  up to the task of trying to pull the
>> tree data directly from the filesystem to do it, and I'd like to avoid
>> doing byte-by-byte comparisons on all files as it's inefficient if the
>> file can instead be identified as a CoW copy.
> The information is available in the kernel, but to find a good way to
> extract it you have to describe in much more detail what you intend to
> do. What I, first of all, don't understand, is, why you need the
> information of already shared (=deduped) blocks to build a dedup. Don't
> you want to find data that is identical, but not shared, instead?
Hi Arne, that's exactly my issue. I want to filter out files that have 
already been de-duped to avoid re-checking two files that already share 
the same data blocks.
  In this usecase, I can identify potential duplicates via filename data 
(this dataset also stores a basic checksum as part of the filename), but 
rather than then doing a secondary checksum/cmp, I'd like to instead 
check if it's already sharing the same data blocks (ie: already 
de-duped). If two files share the same data blocks, I can safely say 
it's already de-duped and move onto the next potential match with doing 
the additional crunching of checksum/cmp to verify the match.

Logically there should also be usecases where someone has made a data 
copy in the past and may be uncertain if they made a reflink copy or a 
full copy and wants to recheck if they share the same data blocks.
>> Open to suggestions of other tools that could be used to acheive the
>> desired result.
>>
> Afaik without playing with it myself fiemap can give you information
> about the mappings of each file. If the mappings of 2 files match,
> the data is shared.
OK, have just done some searching on fiemap and located a code example 
using it to pull the file extent data.
http://smackerelofopinion.blogspot.com/2010/01/using-fiemap-ioctl-to-get-file-extents.html
Will have a play around to see if i might be able to hack it up to 
compare two files, or just parse it's output between two files to 
identify matches.  Thank you for the pointer. :)

Likewise if anyone else knows of an existing utility to do a 
non-bytewise compare between two files, and just check if they share the 
same datablocks please let me know. :)
>> Thanks.
>> Jp.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

