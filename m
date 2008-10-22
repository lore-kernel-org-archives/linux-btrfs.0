From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 17:56:23 -0400
Message-ID: <48FFA187.8000704@redhat.com>
References: <20081021132322.271ad728.skraw@ithnet.com>	 <1224597580.27474.93.camel@think.oraclecorp.com>	 <1224622451.7412.1.camel@telesto>  <48FE553D.80501@redhat.com>	 <1224642544.7189.17.camel@telesto> <48FF038A.4010105@redhat.com>	 <48FF0625.6040400@kernel.org> <48FF2343.3070107@redhat.com>	 <48FF276B.6090602@kernel.org> <48FF296F.9060009@redhat.com>	 <48FF515B.2030209@kernel.org> <1224711108.7399.12.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tejun Heo <tj@kernel.org>, Chris Mason <chris.mason@oracle.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224711108.7399.12.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

Eric Anopolsky wrote:
> On Thu, 2008-10-23 at 01:14 +0900, Tejun Heo wrote:
>   
>> Ric Wheeler wrote:
>>     
>>> Waiting for the target to ack an IO is not sufficient, since the target
>>> ack does not (with write cache enabled) mean that it is on persistent
>>> storage.
>>>       
>> FS waiting for completion of all the dependent writes isn't too good
>> latency and throughput-wise tho.  It would be best if FS can indicate
>> dependencies between write commands and barrier so that barrier
>> doesn't have to empty the whole queue.  Hmm... Can someone tell me how
>> much such scheme would help?
>>     
>
> The extent of my coding for ZFS on FUSE was in this area. Solaris has a
> generic ioctl to flush the write cache on a block device but Linux does
> not. I wrote a few routines to detect the type of block device and flush
> the cache by talking to the hardware via an ioctl.
>
> Tests with bonnie++ on my laptop showed that throughput and metadata
> operations per second were not noticeably affected by completely
> flushing the write cache when necessary versus never flushing the write
> cache or using any kind of IO barrier.
>
> Caveats:
> *Not every HDD is a laptop HDD.
> *ZFS on FUSE got average to poor results for metadata operations per
> second since it hadn't been optimized for that yet.
>
> Maybe fancier schemes aren't necessary?
>
> Cheers,
> Eric
>
>   
What I have seen so far with meta-data heavy workloads & the write 
barrier (working correctly!) is a pretty close match to the specs of the 
drive, at least for single threaded writing.

For example, if you have an average seek time of 20ms, you should see no 
more than 50 files/sec (if only one barrier is issued per file write).  
In practice, we see closer to 30 files/sec.

If nothing else, you can always detect a broken (or disabled) write 
barrier by exceeding that spec for single writers :-)

ric



