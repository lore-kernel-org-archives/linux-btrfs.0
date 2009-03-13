From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Btrfs experimental branch updates
Date: Fri, 13 Mar 2009 17:52:15 -0500
Message-ID: <49BAE39F.8050102@austin.ibm.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1236959774.17095.3.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hello everyone,
>
> I've rebased the experimental branch to include most of the
> optimizations I've been working on.
>
> The two major changes are doing all extent tree operations in delayed
> processing queues and removing many of the blocking points with btree
> locks held.
>
> In addition to smoothing out IO performance, these changes really cut
> down on the amount of stack btrfs is using, which is especially
> important for kernels with 4k stacks enabled (fedora).
>
>   
Well, no drastic changes.  On Raid, creates got better, but random write 
got worse. Mail server was mixed. For single disk, pretty much the same 
story, although CPU savings is noticeable on write, although at the 
expense of performance.

Raid graphs and links:
http://btrfs.boxacle.net/repository/raid/history/History.html

Single disk graphs and links:
http://btrfs.boxacle.net/repository/single-disk/History/History.html

Steve

> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

