From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: More performance results
Date: Tue, 03 Feb 2009 08:56:44 -0600
Message-ID: <49885B2C.7050901@austin.ibm.com>
References: <49871813.8090309@austin.ibm.com> <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: debian developer <debiandev@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

debian developer wrote:
> On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
>   
>> Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
>>
>> Single disk results are not too bad.  Raid still falls apart on any write heavy workload.
>>     
>
> Would you please mind explaining how bad the results are and
> how much more this needs to be improved for Btrfs to be perfomance
> wise acceptable?
>   
Well as I pointed out most of the write workloads seem to run into 
CPU/locking issues on RAID systems (especially at higher thread 
counts)where high levels of throughput are expected.    There is lots of 
data out there, but a good place to look would be 
http://btrfs.boxacle.net/repository/raid/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2.html  
which shows performance on the latest RC kernel.  As thread counts go 
up, BTRFS lags more and more on write workloads.  For example on 128 
thread random write 
http://btrfs.boxacle.net/repository/raid/2.6.29-rc2/2.6.29-rc2/2.6.29-rc2_Large_file_random_writes._num_threads=128.html
BTRFS achieves about 4MB/sec where the next worse FS (XFS in this case) 
get 78MB/sec.   So for this example BTRFS is slower by a factor of 
almost 20x.

Let me point out that this is not a criticism of BTRFS, this is just the 
normal development cycle.  Most of the major function is now in, and 
performance can now become a focus.  The point of these benchmarks is to 
help identify the areas that need attention and provide the debug and 
analysis data to help facilitate that.    Chris has already stated that 
he hopes to start looking at write performance this week.
> I see that Btrfs almost everywhere lacks XFS and others in some cases.
>   
For now.

Steve

> Thanks,
> Andev
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

