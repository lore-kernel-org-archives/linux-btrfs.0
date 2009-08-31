From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Mon, 31 Aug 2009 12:49:13 -0500
Message-ID: <4A9C0D19.5010108@austin.ibm.com>
References: <4A68AD69.4030803@dangyankee.net> <20090723210051.GB1040@think> <4A68DE81.3020505@dangyankee.net> <20090724132407.GC16192@think> <20090724140002.GD16192@think> <4A6F5BB6.4020204@austin.ibm.com> <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com> <20090805203526.GE12524@think> <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090807231240.GD3710@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, Aug 07, 2009 at 08:56:52AM -0500, Steven Pratt wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Tue, Jul 28, 2009 at 04:10:41PM -0500, Steven Pratt wrote:
>>>       
>>>>> Hi Steve,
>>>>>
>>>>> I think I'm going to start tuning something other than the
>>>>> random-writes, there is definitely low hanging fruit in the large file
>>>>> creates workload ;)  Thanks again for posting all of these.
>>>>>           
>>>> Sure, no problem.
>>>>
>>>>         
>>>>> The history graph has 2.6.31-rc btrfs against 2.6.29-rc ext4.  Have you
>>>>> done more recent runs on ext4?
>>>>>
>>>>>           
>>>> Yes, thanks for pointing that out, had so many issues I forgot to
>>>> update the graphs for other file systems.  Just pushed new graphs
>>>> with data for 2.6.30-rc7 for all the other file systems.  This was
>>>>         
>>> >from your "newformat" branch from June 6th.
>>>
>>> I've been tuning the 128 thread large file streaming writes, and found
>>> some easy optimizations.  While I'm fixing up these patches, could you
>>> please do a streaming O_DIRECT write test run for me?  I think buffered
>>> writeback in general has some problems right now on high end arrays.
>>>
>>> On my box 2.6.31-rc5 streaming buffered write with xfs only got at
>>> 200MB/s (with the 128 thread ffsb workload).  Buffered btrfs goes at
>>> 175MB/s.
>>>
>>> O_DIRECT btrfs runs at 390MB/s, while XFS varies a bit between 330MB/s
>>> and 250MB/s.
>>>
>>> I'm using a 1MB write blocksize.
>>>       
>> On my todo list, but am swamped this week trying to get ready for
>> vacation.  Will try to get to it as soon as I can.
>>     
>
> Ok, I've pushed out a very raw version of my buffered write fixes to
> a new branch named performance on btrfs-unstable.
>
> Please try this with the streaming large file create workload.  I'm also
> curious to see if it improves on your box when you mount with
>
> mount -o thread_pool=128
>
>   
Better late than never. Finally got this finished up.  Mixed bag on this 
one.  BTRFS lags significantly on single threaded.  Seems unable to keep 
IO outstanding to the device.  Less that 60% busy on the DM device, 
compared to 97%+ for all other filesystems.  nodatacow helps out, 
increasing utilization to about 70%, but still trails by a large margin.

Results are more favorable for multithreaded tests.  nodatacow is 
actually the top performer here!  However, cow still raises it's ugly 
head and causes significant performance degradation (45%) and increased 
CPU (43%).  Also, even without cow, BTRFS is consuming 8-10x more CPU 
than other File Systems.  I don't have oprofile data for these runs, as 
that was causing some issues with BTRFS.  Will retry, and see if that 
problem is fixed.

thread_pool seemed to make no difference at all.

All runs were done against an August 20th pull of experimental tree.  
These are 1M, odirect file creates, with each file being 1G in size.

Results can be found here:

http://btrfs.boxacle.net/repository/raid/large_create_test/write-test/1M_odirect_create.html

Steve
> -chris
>   

