From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: experimental branch rebased
Date: Thu, 26 Feb 2009 16:54:13 -0600
Message-ID: <49A71D95.8030707@austin.ibm.com>
References: <1235663145.4631.11.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235663145.4631.11.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hello everyone,
>
> I've rebased the experimental branch again with my latest performance
> fixes.
>
> I took out the delayed unlink code, it wasn't making a big enough
> difference in any benchmarks to justify the complexity.
>
> I changed the delayed backref code to do delayed processing for all
> extents.  In general it is much faster and uses less stack.
>
> I pulled Josef's enospc work into the master branch and asked Linus to
> pull it.
>
> I'm going to hammer on the experimental branch for a few days and ask
> Steve to give it another run.
>   
Done.  Results for RAID are updated in history tree   
http://btrfs.boxacle.net/repository/raid/history/History.html

This gives back a few of the performance improvements made on the tree 
from the 24th (mail server and random write).

Also, I have reordered the bars with btrfs at the end for 2 reasons. 
First, makes it a little easier to find the latest btrfs results.  Also 
this fixes a problem with my scripts where I was not picking up the 
random write odirect tests.

Single disk tests are running.

Steve
> -chris
>
>   

