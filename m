From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Btrfs experimental branch updates
Date: Sun, 15 Mar 2009 09:38:28 -0500
Message-ID: <49BD12E4.4070505@austin.ibm.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>	 <49BAE39F.8050102@austin.ibm.com> <1236994421.17095.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1236994421.17095.7.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, 2009-03-13 at 17:52 -0500, Steven Pratt wrote:
>   
>> Chris Mason wrote:
>>     
>>> Hello everyone,
>>>
>>> I've rebased the experimental branch to include most of the
>>> optimizations I've been working on.
>>>
>>> The two major changes are doing all extent tree operations in delayed
>>> processing queues and removing many of the blocking points with btree
>>> locks held.
>>>
>>> In addition to smoothing out IO performance, these changes really cut
>>> down on the amount of stack btrfs is using, which is especially
>>> important for kernels with 4k stacks enabled (fedora).
>>>
>>>   
>>>       
>> Well, no drastic changes.  On Raid, creates got better, but random write 
>> got worse. Mail server was mixed. For single disk, pretty much the same 
>> story, although CPU savings is noticeable on write, although at the 
>> expense of performance.
>>
>>     
>
> Thanks for running this, but the main performance fixes for your test
> are still in testing locally.  One thing that makes a huge difference on
> the random write run is to mount -o ssd.
>
>   
Tried a run with -o ssd on the raid system. It made some minor 
improvements in random write performance. Helps more on odirect, but 
mainly at the 16thread count. Single and 128 threads it doesn't make 
much difference.

Results syncing now to history boxacle
http://btrfs.boxacle.net/repository/raid/history/History.html

Steve

> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

