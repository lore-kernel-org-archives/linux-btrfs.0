From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: BTRFS Performance page
Date: Wed, 22 Oct 2008 10:45:23 -0500
Message-ID: <48FF4A93.6060007@austin.ibm.com>
References: <48FE5593.2080209@austin.ibm.com>	 <48FF4028.5080109@austin.ibm.com> <1224688768.6448.63.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224688768.6448.63.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wed, 2008-10-22 at 10:00 -0500, Steven Pratt wrote:
>   
>> Steven Pratt wrote:
>>     
>>> As discussed on the BTRFS conference call, myself and Kevin Corry have 
>>> set up some test machines for the purpose of doing performance testing 
>>> on BTRFS.  The intent is to have a semi permanent setup that we can 
>>> use to test new features and code drops in BTRFS as well as to do 
>>> comparisons to other file systems.  The systems are pretty much fully 
>>> automated for execution, so we should be able to crank out large 
>>> numbers of different benchmarks as well as keep up with GIT changes.
>>>
>>> The data is hosted at http://btrfs.boxacle.net/. So far we have the 
>>> data for the single disk tests uploaded. We should be able to upload 
>>> results from the larger RAID config tomorrow.
>>>
>>> Initial tests were done with the FFSB benchmark and we picked 5 common 
>>> workloads; create, random and sequential read, random write, and a 
>>> mail server emulation.  We plan to expand this based on feedback to 
>>> include more FFSB tests and/or other workloads.
>>>
>>> All runs have complete analysis data with them (iostat, mpstat, 
>>> oprofile, sar), as well as the FFSB profiles that can be used to 
>>> recreate any test we ran. We also have collected blktrace data but not 
>>> uploaded due to size.
>>>
>>>       
>
> I'll try to reproduce things here, but I might end up asking for some of
> the blktrace data.
>
>   
Sure, not a problem for select workloads, but it was just too much data 
to upload for every run.  Just let me know which ones you need.

>>> Please follow the results link on the bottom of the main page to get 
>>> to the current results.  Let me know what you like or don't like.   I 
>>> will post again when we get the RAID data uploaded.
>>>       
>> RAID data is now uploaded.  The config used is 136 15k rpm fiber disks 
>> in 8 arrays all striped together with DM.  These results are not as 
>> favorable to BTRFS, as there seem to be some major issues with random 
>> write and mail server workloads.
>>
>> http://btrfs.boxacle.net/repository/raid/Initial-compare/Initial-Compare-RAID0.html
>>
>>     
>
> I need to look harder at the mail server workload, my initial guess is
> that I'm doing too much metadata readahead in these effectively random
> operations.
>
> If I'm reading the config correctly, the random write workload does
> this:
>
> 1) create a file sequentially
> 2) do buffered random writes to the file
>   
Correct.  Although there are multiple files(but created serially) and 
multiple threads writing to different files at the same time.  We also 
only write 5% of a file before moving on to a new file.  So while there 
can be some ordering, the merging should be minimal.  If fact we see 
that from iostat (this is from 16 thread ext3)

sdf               0.00   177.05   14.17 3665.07    56.69 15374.05     8.39    67.88   18.48   0.24  86.53

177 merges out of 3665 ios, with average request size on 4.2k.  



> Since buffered writeback happens via pdflush, the IO isn't actually as
> random as you would expect.  Pages are written in file offset order,
> which actually corresponds to disk order.
>
>   
Right, there will be a fair amount of locality to the random writes.

> When btrfs is doing COW, file offset order maps to random order on disk,
> leading to much lower tput.  The nocow results should be better than
> they are, and I'll see what I can do about the cow results too.
>
>   
Not sure I understand this point, doesn't the COW code allocate new 
space sequentially?

Steve

> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

