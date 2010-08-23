From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: 2.6.35 performance results
Date: Mon, 23 Aug 2010 15:10:11 -0500
Message-ID: <4C72D5A3.9030407@austin.ibm.com>
References: <4C5C57FB.4090003@dangyankee.net> <20100816200444.GJ993@think> <4C69B2D0.4010501@dangyankee.net> <20100819010031.GI5854@think> <4C6FF007.3080800@austin.ibm.com> <4C72C871.4040602@austin.ibm.com> <20100823193325.GJ26773@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100823193325.GJ26773@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Aug 23, 2010 at 02:13:53PM -0500, Steven Pratt wrote:
>   
>> This did not seem to help, in fact we regressed more with COW
>> enabled.. One thing to note, the last 2 sets of runs in the history
>> graphs were actually run by Keith and he used stock kernel trees.
>> For my recreate, I pulled the latest btrfs-unstable which is based
>> on a 2.6.34 tree. Should I retest this on stock 2.6.35?  The high
>> time in btrfs_start_one_delalloc_inode still exists.
>>     
>
> btrfs-unstable or .35 are both fine.
>
>   
Ok.
> Is this a fresh mkfs or are you reusing an existing tree?
>
>   
In between. New mkfs before benchmark run, multiple tests are all then 
run with unmounting and remounting, but no new mkfs. The random write is 
preceded by sequential reads and random reads.
>> Full results can be found here:
>> http://btrfs.boxacle.net/repository/raid/perftest/perfpatch/perfpatch.html
>>
>> 128 thread random write test that shows the problem:
>>
>> http://btrfs.boxacle.net/repository/raid/perftest/perfpatch/perfpatch_Large_file_random_writes._num_threads=128.html
>>     
>
> Ok, thanks, I'll try again.
>   
Ok, will probably just run the 128 thread random write next time, since 
I am not seeing much difference on anything else.

Steve
> -chris
>   

