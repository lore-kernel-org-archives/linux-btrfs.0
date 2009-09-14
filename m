From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Mon, 14 Sep 2009 16:41:48 -0500
Message-ID: <4AAEB89C.3040100@austin.ibm.com>
References: <20090724140002.GD16192@think> <4A6F5BB6.4020204@austin.ibm.com> <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com> <20090805203526.GE12524@think> <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think> <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090914135130.GE8839@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, Sep 11, 2009 at 04:35:50PM -0500, Steven Pratt wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Mon, Aug 31, 2009 at 12:49:13PM -0500, Steven Pratt wrote:
>>>       
>>>> Better late than never. Finally got this finished up.  Mixed bag on
>>>> this one.  BTRFS lags significantly on single threaded.  Seems
>>>> unable to keep IO outstanding to the device.  Less that 60% busy on
>>>> the DM device, compared to 97%+ for all other filesystems.
>>>> nodatacow helps out, increasing utilization to about 70%, but still
>>>> trails by a large margin.
>>>>         
>>> Hi Steve,
>>>
>>> Jens Axboe did some profiling on his big test rig and I think we found
>>> the biggest CPU problems.  The end result is now setting in the master
>>> branch of the btrfs-unstable repo.
>>>
>>> On his boxes, btrfs went from around 400MB/s streaming writes to 1GB/s
>>> limit, and we're now tied with XFS while using less CPU time.
>>>
>>> Hopefully you will see similar results ;)
>>>       
>> Hmmm, well no I didn't.  Throughputs at 1 and 128 threads are pretty
>> much unchanged, although I do see a good CPU savings on the 128
>> thread case (with cow).  For 16 threads we actually regressed with
>> cow enabled.
>>
>> Results  are here:
>>
>> http://btrfs.boxacle.net/repository/raid/large_create_test/write-test/1M_odirect_create.html
>>
>> I'll try to look more into this next week.
>>
>>     
>
> Hmmm, Jens was benchmarking buffered writes, but he was also testing on
> his new per-bdi write back code.  If your next run could be buffered
> instead of O_DIRECT, I'd be curious to see the results.
>
>   
Buffered does look a lot better. I don't have a btrfs baseline before 
these latest changes for this exact workload, but these results are not 
bad at all.  With cow, beats just about everything except XFS, and with 
nocow simply screams.  CPU consumption looks good as well.  I'll 
probably give the full set of tests a run tonight.

Results are here:
http://btrfs.boxacle.net/repository/raid/buffered-creates/buffered-create/buffered-create.html

Only bit of bad news is I did get one error that crashed the system on 
single threaded nocow run. So that data point is missing.
Output below:

btrfs1 kernel: [251789.525886] ------------[ cut here ]------------
Message from syslogd@ at Mon Sep 14 13:13:04 2009 ...
btrfs1 kernel: [251789.526574] invalid opcode: 0000 [#1] SMP
Message from syslogd@ at Mon Sep 14 13:13:04 2009 ...
btrfs1 kernel: [251789.526654] last sysfs file: 
/sys/devices/pci0000:0c/0000:0c:01.0/local_cpus
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654] Stack:
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  ffff88013fc234c0 ffff88013fbcf400 
0000000000000000 ffff88013fc01080
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  ffff880132e11d38 ffffffff802a5392 
0000000000000001 ffff88013fbcf400
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654] Call Trace:
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802a5392>] 
cache_flusharray+0x7d/0xae
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802a5629>] kfree+0x192/0x1b1
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffffa0378c9f>] 
put_worker+0x14/0x16 [btrfs]
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffffa0378d55>] 
btrfs_stop_workers+0xb4/0xc9 [btrfs]
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffffa0355cbe>] 
close_ctree+0x210/0x288 [btrfs]
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802bd1a1>] ? 
invalidate_inodes+0x100/0x112
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffffa033f4cb>] 
btrfs_put_super+0x18/0x27 [btrfs]
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802ad12b>] 
generic_shutdown_super+0x73/0xe2
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802ad1e5>] 
kill_anon_super+0x11/0x3b
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802ad51d>] 
deactivate_super+0x62/0x77
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802bf9eb>] 
mntput_no_expire+0xec/0x12c
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff802bff3a>] sys_umount+0x2c5/0x31c
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654]  [<ffffffff8020ba2b>] 
system_call_fastpath+0x16/0x1b
Message from syslogd@ at Mon Sep 14 13:13:05 2009 ...
btrfs1 kernel: [251789.526654] Code: 89 f7 e8 48 07 f8 ff 48 c1 e8 0c 48 
ba 00 00 00 00 00 e2 ff ff 48 6b c0 38 48 01 d0 66 83 38 00 79 04 48 8b 
40 10 80 38 00 78 04 <0f> 0b eb fe 48 8b 58 30 48 63 45 c8 48 89 df 4d 
8b a4 c5 60 08

Steve


> Thanks,
> Chris
>   

