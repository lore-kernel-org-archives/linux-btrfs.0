From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: New performance results
Date: Tue, 07 Apr 2009 15:53:41 -0500
Message-ID: <49DBBD55.50300@austin.ibm.com>
References: <49DA7BA7.7010607@austin.ibm.com> <1239075439.17426.11.camel@think.oraclecorp.com> <49DB7511.5020008@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49DB7511.5020008@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Steven Pratt wrote:
> Chris Mason wrote:
>> On Mon, 2009-04-06 at 17:01 -0500, Steven Pratt wrote:
>>  
>>> I am continuing to do runs to provide more data on the random write 
>>> issues with btrfs. I have just posted 2 sets of runs here:
>>> http://btrfs.boxacle.net/repository/raid/longrun/
>>>
>>> these are on a pull of the btrfs-unstable experimental branch from 4/3.
>>>
>>> These are 100 minute runs of the 128 thread random write workload on 
>>> the raid system (1 for btrfs and 1 for ext3).  Included in these 
>>> runs are graphs of all the iostat, sar and mpstat data (see analysis 
>>> directories).
>>>
>>> A couple of interesting things. First, we see the choppiness of the 
>>> IO in btrfs compared to ext3.
>>> http://btrfs.boxacle.net/repository/raid/longrun/btrfs-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_10.25.03/analysis/iostat-processed.001/chart.html 
>>>
>>> http://btrfs.boxacle.net/repository/raid/longrun/ext3-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_13.44.49/analysis/iostat-processed.001/chart.html 
>>>
>>>
>>> In particular look at graphs 7 and 11 which show write iops and 
>>> throughput.  Ext3 is nice and smooth, while btrfs has a repeating 
>>> pattern of dips and spikes, with IO going to 0 on  a regular basis.
>>>
>>>     
>>
>> The dips and spikes may be from the allocator.  Basically what happens
>> is after each commit we end up with a bunch of small blocks available
>> for filling again.  Could you please try with -o ssd?
>>
>>   
> Will give it a shot.

Results with -o ssd were not much different. 2.85MB/sec vs 2.5MB/sec. 
Also, the spiky behavior still exists.  All 3 runs at:
http://btrfs.boxacle.net/repository/raid/longrun/

Also, finally have the blktrace runs you wanted.  A 128thread odirect 
random write workload is tarred up at:
http://btrfs.boxacle.net/repository/raid/blktrcrun.tar.bz

blktrace is inteh analysis/blktrace.001 dir.

Steve

>>  
>>> Another interesting observation is what looks a lot like a memory 
>>> leak.  Looking at chart 6 Memory at :
>>> http://btrfs.boxacle.net/repository/raid/longrun/btrfs-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_10.25.03/analysis/sar-processed.001/chart.html 
>>>
>>> we see that the amount of page cache drops slowly throughout the 
>>> entire run.  Starting up around 3.5GB and dropping to about 2.3GB by 
>>> the end of the run.  The memory seems to have moved to the slab 
>>> which grew to 1.5GB.  Doing a repeat of the run while watching 
>>> slabtop, we see that size-2048 is responsible for the majority of 
>>> the slab usage (over 1GB).
>>>
>>>     
>>
>> size-2048?  That's probably the csums.  I'll give it a shot when I get
>> back next week
>
> Ok.
>
> One other thing I noticed that is really bad.  For ext3, we see 
> 115MB/sec both from the benchmark reporting and from iostat write 
> throughput.  However, for btrfs, we see a benchmark throughput of 
> 2.5MB/sec while iostat shows a whopping 35MB/sec of writes.  That to 
> me implies that btrfs is doing an additional 32-33MB/sec of metadata 
> or journal writes.  More than 10x the amount of actual data being 
> written.  Can that be right?
>
> Steve
>> .
>>
>> -chris
>>
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

