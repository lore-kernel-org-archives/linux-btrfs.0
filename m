From: debian developer <debiandev@gmail.com>
Subject: Re: Updated performance results
Date: Fri, 7 Aug 2009 13:00:17 +0530
Message-ID: <f24d23310908070030u2ee49b41obcaafa5d7547cf69@mail.gmail.com>
References: <4A68AD69.4030803@dangyankee.net> <20090723210051.GB1040@think>
	 <4A68DE81.3020505@dangyankee.net> <20090724132407.GC16192@think>
	 <20090724140002.GD16192@think> <4A6F5BB6.4020204@austin.ibm.com>
	 <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com>
	 <20090805203526.GE12524@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090805203526.GE12524@think>
List-ID: <linux-btrfs.vger.kernel.org>

HI,

Do you have any benchmarks against non-raid common workloads?
Like say a desktop user? It would be great to compare against ext3,
ext4, xfs etc.,

Thanks,

On Thu, Aug 6, 2009 at 2:05 AM, Chris Mason<chris.mason@oracle.com> wrote:
> On Tue, Jul 28, 2009 at 04:10:41PM -0500, Steven Pratt wrote:
>> >
>> >Hi Steve,
>> >
>> >I think I'm going to start tuning something other than the
>> >random-writes, there is definitely low hanging fruit in the large file
>> >creates workload ;)  Thanks again for posting all of these.
>> Sure, no problem.
>>
>> >The history graph has 2.6.31-rc btrfs against 2.6.29-rc ext4.  Have you
>> >done more recent runs on ext4?
>> >
>> Yes, thanks for pointing that out, had so many issues I forgot to
>> update the graphs for other file systems.  Just pushed new graphs
>> with data for 2.6.30-rc7 for all the other file systems.  This was
>> from your "newformat" branch from June 6th.
>
> I've been tuning the 128 thread large file streaming writes, and found
> some easy optimizations.  While I'm fixing up these patches, could you
> please do a streaming O_DIRECT write test run for me?  I think buffered
> writeback in general has some problems right now on high end arrays.
>
> On my box 2.6.31-rc5 streaming buffered write with xfs only got at
> 200MB/s (with the 128 thread ffsb workload).  Buffered btrfs goes at
> 175MB/s.
>
> O_DIRECT btrfs runs at 390MB/s, while XFS varies a bit between 330MB/s
> and 250MB/s.
>
> I'm using a 1MB write blocksize.
>
> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
