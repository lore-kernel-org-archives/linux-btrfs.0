Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3CWWku (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 18:40:50 -0400
Message-ID: <514E2F69.1030204@redhat.com>
Date: Sat, 23 Mar 2013 17:40:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Roger Binns <rogerb@rogerbinns.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: document mount options in Documentation/fs/btrfs.txt
References: <514DEB06.7000606@redhat.com> <kil9uq$210$1@ger.gmane.org>
In-Reply-To: <kil9uq$210$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/23/13 5:22 PM, Roger Binns wrote:
> On 23/03/13 10:48, Eric Sandeen wrote:
>> Btrfs is a new copy on write filesystem for Linux aimed at
> 
> How much longer does "new" get to be there as the filesystem has been
> going for well over half a decade.

;) well, I didn't write that.  Could remove it on the next round I suppose.

>> +  autodefrag +	Detect small random writes into files and queue them up
>> for the +	defrag process.  Works best for small files; Not well suited
>> for +	large database workloads.
> 
> What is "large"?  One man's large database is another's trivial database!
>  Same applies to "small".  Virtual machines are also in the category of
> large files with small random writes.
> 
> Quantification would help a lot.  Suggestions are "more than 10 random
> writes an hour to files larger than a gigabyte".

Fair enough.  I was going by the original commitlog for that option:

>     Btrfs: add mount -o auto_defrag
>     
>     This will detect small random writes into files and
>     queue the up for an auto defrag process.  It isn't well suited to
>     database workloads yet, but works for smaller files such as rpm, sqlite
>     or bdb databases.

I imagine it depends on the details of the workload & storage as well.

Quantifying it may be tough; it may be better to just add more description
of what happens when it autodefrags, with some indication of how file size
affects the process, and leave it up to the admin to determine whether
it's appropriate for a given environment.

Before I can do that I'll have to understand better how it works ;)

Thanks,
-Eric

> Roger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

