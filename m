From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Fri, 24 Jul 2009 09:24:07 -0400
Message-ID: <20090724132407.GC16192@think>
References: <4A68AD69.4030803@dangyankee.net> <20090723210051.GB1040@think> <4A68DE81.3020505@dangyankee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <steve@dangyankee.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A68DE81.3020505@dangyankee.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2009 at 05:04:49PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
>> On Thu, Jul 23, 2009 at 01:35:21PM -0500, Steven Pratt wrote:
>>   
>>> I have re-run the raid tests with re-creating the fileset between 
>>> each  of the random write workloads and performance does now match 
>>> the  previous newformat results.  The bad news is that the huge gain 
>>> that I  had attributed to the newformat release, does not really 
>>> exist.  All of  the previous results(except for the newformat run) 
>>> were not re-creating  the fileset, so the gain in performance was due 
>>> only to having a fresh  set of files, not any code changes.
>>>     
>>
>> Thanks for doing all of these runs.  This is still a little different
>> than what I have here, my initial runs are very very fast and after 10
>> or so level out to a relatively low performance on random writes.  With
>> nodatacow, it stays even.
>>
>>   
> Right, I do not see this problem with nodatacow.
>
>>> So, I have done 2 new sets of runs to look into this further. One is 
>>> a 3  hour run of single threaded random write to the RAID system.  I 
>>> have  compared this to ext3.  Performance results are here:    
>>> http://btrfs.boxacle.net/repository/raid/longwrite/longwrite/Longrandomwrite.html
>>>
>>> and graphing of all the iostat data can be found here:
>>>
>>> http://btrfs.boxacle.net/repository/raid/longwrite/summary.html
>>>
>>> The iostat graphs for btrfs are interesting for a number of reasons.  
>>>  First, it takes about 3000 seconds (or 50 minutes) for btrfs to 
>>> reach  steady state.  Second, if you look at write throughput from 
>>> the device  view vs. the btrfs/application view, we see that for a 
>>> application  throughput of 21.5MB/sec it requires 63MB/sec of actual 
>>> disk writes.   That is an overhead of 3 to 1 vs an overhead of ~0 for 
>>> ext3. Also,  looking at the change in iops vs MB/sec, we see that 
>>> while  btrfs starts  out with reasonable size IOs, it quickly 
>>> deteriorate to an average IO  size of only 13kb.  Remember, the 
>>> starting file set is only 100GB on a  2.1TB filesystem, and all data 
>>> is overwrite, and this is single  threaded, so there is no reason 
>>> this should fragment.  It seems like the  allocator is having a 
>>> problem doing sequential allocations.
>>>     
>>
>> There are two things happening.  First the default allocation scheme
>> isn't very well suited to this, mount -o ssd will perform better.  But
>> over the long term, random overwrites to the file cause a lot of writes
>> to the extent allocation tree.  That's really what -o nodatacow is
>> saving us.  There are optimizations we can do, but we're holding off on
>> that in favor of enospc and other pressing things.
>>   
> Well I have -o ssd data that I can upload, but it was worse than  
> without.  I do understand about timing and priorities.
>
>> But, with all of that said, Josef has some really important allocator
>> improvements.  I've put them out along with our pending patches into the
>> experimental branch of the btrfs-unstable tree.  Could you please give
>> this branch a try both with and without the ssd mount option?
>>
>>   
> Sure, will try to get to it tomorrow.

Sorry, I missed a fix in the experimental branch.  I'll push out a
rebased version in a few minutes.

-chris

