From: jim owens <jowens@hp.com>
Subject: Re: PATCH] Do not limit RAID1 and DUP transfer length to one stripe
Date: Fri, 18 Dec 2009 10:43:16 -0500
Message-ID: <4B2BA314.9040508@hp.com>
References: <4B2A80AB.9080401@hp.com> <20091218142324.GC3202@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, jim owens <jowens@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091218142324.GC3202@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Dec 17, 2009 at 02:04:11PM -0500, jim owens wrote:
>> The 65k stripe length should be ignored as the stripes are
>> physically contiguous on disk so transfers can span stripes.
>>
>> +		/* RAID1, DUP, and simple disk stripes are all contiguous */
>>  		*length = em->len - offset;
>>  	}
> 
> We do need to make sure the bio doesn't try to span a chunk.  The
> mapping code can't handle that.

I don't understand what code can't handle it, the em is limited
to a chunk so em->start to em->start + em->len will be reachable
as a single physical disk region for raid1 and dup... right?
