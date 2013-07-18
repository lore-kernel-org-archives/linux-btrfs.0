Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob14.myregisteredsite.com ([209.17.115.52]:49493 "EHLO
	atl4mhob14.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758677Ab3GRNhk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 09:37:40 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.117])
	by atl4mhob14.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r6IDbcaj031166
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 09:37:38 -0400
Message-ID: <51E7EFA6.10503@chinilu.com>
Date: Thu, 18 Jul 2013 06:37:42 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: What is the current status of defragmentation?
References: <51E7182F.9020009@statystyka.net> <51E733FF.2070102@chinilu.com> <51E79542.9030001@statystyka.net>
In-Reply-To: <51E79542.9030001@statystyka.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Indeed! That is a VERY good question and one I have not seen a good 
answer to thus far.  A traditional defragger in the Windows realm, which 
defrags on a global basis rather than directory by directory, file by 
file, also "restacks" the file and directory structure in a way that 
minimizes free space and the result is also close to a maximum amount of 
contiguous free space somewhere within the filesystem after the defrag 
process finishes.  As you correctly point out, no one has indicated a 
method as to how that can be accomplished with btrfs at this point.  I 
am not even sure that rebuilding the partition from scratch would do the 
job.  My solution so far is just to always make sure to have a 
ridiculous amount of free space available, but that cannot go on forever 
(and is very inefficient).  So it would be nice to know what the 
solution to this conundrum would be.  Thanks for pointing this out.

On 07/18/2013 12:12 AM, Adam Ryczkowski wrote:
> On 07/18/2013 02:17 AM, George Mitchell wrote:
>> find /home -type d -mtime -3 -o -type f -mtime -3 | egrep -v
>> "Cache|cache" | while read file; do /usr/sbin/btrfs filesystem defrag
>> -f -v "${file}"; done
> Thank you for your answer.
>
> This still defragments file-after-file. But what about a little
> consolidation of free space? As I understand, if there is no consecutive
> free space for a file's extents, it is impossible to defragment it, no
> matter how many times I run the above command, am I right?
>
> Adam Ryczkowski
>
> <http://www.google.com/>
>
>
>

