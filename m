From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: More performance results
Date: Tue, 03 Feb 2009 09:13:18 -0600
Message-ID: <49885F0E.1050705@austin.ibm.com>
References: <49871813.8090309@austin.ibm.com>	 <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com> <1233673296.7246.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: debian developer <debiandev@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233673296.7246.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Tue, 2009-02-03 at 19:02 +0530, debian developer wrote:
>   
>> On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
>>     
>>> Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
>>>
>>> Single disk results are not too bad.  Raid still falls apart on any write heavy workload.
>>>       
>> Would you please mind explaining how bad the results are and
>> how much more this needs to be improved for Btrfs to be perfomance
>> wise acceptable?
>>
>> I see that Btrfs almost everywhere lacks XFS and others in some cases.
>>     
>
> These benchmarks are great because they hammer on some of the worst
> cases code in btrfs.  The mail-server benchmark for example isn't quite
> a mail server workload because it doesn't fsync the files to disk.
>   
Actually it does.  We fixed this after the first round was posted.  Any 
results since October have fsync on the create of new files.

 From the latest runs for mailserver:

	 op weights
	                 read = 0 (0.00%)
	              readall = 4 (57.14%)
	                write = 0 (0.00%)
	               create = 0 (0.00%)
	               append = 0 (0.00%)
	               delete = 1 (14.29%)
	               metaop = 0 (0.00%)
	            createdir = 0 (0.00%)
	                 stat = 0 (0.00%)
	             writeall = 0 (0.00%)
	       writeall_fsync = 0 (0.00%)
	           open_close = 0 (0.00%)
	          write_fsync = 0 (0.00%)
	         create_fsync = 2 (28.57%)
	         append_fsync = 0 (0.00%)




 We should probably fsync that into the list of system calls that we 
track latency for.

Steve

> But what it does do is hammer on a mixed file read/write/delete
> workload, which hits btree concurrency and file layout.  In my testing
> here, the big difference between ext4 and btrfs isn't writing to files,
> it is actually the unlinks.  If I take them out of the run, btrfs is
> very close to ext4 times.
>
> So, I'm working on that.
>
> The random write workload is probably just a file allocation problem.
> Btrfs should be perform very well in that workload.
>
> -chris
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

