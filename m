From: Martin Mailand <martin@tuxadero.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Thu, 27 Oct 2011 13:17:57 +0200
Message-ID: <4EA93DE5.8060506@tuxadero.com>
References: <4EA86FD7.4030407@tuxadero.com> <4EA93844.3010601@tuxadero.com> <CADdPHGtimucFn5k8A-RWDGYa-C3u7wB-bajxgT0LtiNH4HZ7=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Sage Weil <sage@newdream.net>, chb@muc.de,
	Josef Bacik <josef@redhat.com>, chris.mason@oracle.com
To: Stefan Majer <stefan.majer@gmail.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CADdPHGtimucFn5k8A-RWDGYa-C3u7wB-bajxgT0LtiNH4HZ7=A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,
I think the machine has enough ram.

root@s-brick-003:~# free -m
              total       used       free     shared    buffers     cached
Mem:          3924       2401       1522          0         42       2115
-/+ buffers/cache:        243       3680
Swap:         1951          0       1951

There is no swap usage at all.

-martin


Am 27.10.2011 12:59, schrieb Stefan Majer:
> Hi Martin,
>
> a quick dig into your perf report show a large amount of swapper work.
> If this is the case, i would suspect latency. So do you have not
> enough physical ram in your machine ?
>
> Greetings
>
> Stefan Majer
>
> On Thu, Oct 27, 2011 at 12:53 PM, Martin Mailand<martin@tuxadero.com>  wrote:
>> Hi
>> resend without the perf attachment, which could be found here:
>> http://tuxadero.com/multistorage/perf.report.txt.bz2
>>
>> Best Regards,
>>   martin
>>
>> -------- Original-Nachricht --------
>> Betreff: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
>> Datum: Wed, 26 Oct 2011 22:38:47 +0200
>> Von: Martin Mailand<martin@tuxadero.com>
>> Antwort an: martin@tuxadero.com
>> An: Sage Weil<sage@newdream.net>
>> Kopie (CC): Christian Brunner<chb@muc.de>, ceph-devel@vger.kernel.org,
>>   linux-btrfs@vger.kernel.org
>>
>> Hi,
>> I have more or less the same setup as Christian and I suffer the same
>> problems.
>> But as far as I can see the output of latencytop and perf differs form
>> Christian one, both are attached.
>> I was wondering about the high latency from btrfs-submit.
>>
>> Process btrfs-submit-0 (970) Total: 2123.5 msec
>>
>> I have as well the high IO rate and high IO wait.
>>
>> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>>             0.60    0.00    2.20   82.40    0.00   14.80
>>
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sda               0.00     0.00    0.00    8.40     0.00    74.40
>> 17.71     0.03    3.81    0.00    3.81   3.81   3.20
>> sdb               0.00     7.00    0.00  269.80     0.00  1224.80
>> 9.08   107.19  398.69    0.00  398.69   3.15  85.00
>>
>> top - 21:57:41 up  8:41,  1 user,  load average: 0.65, 0.79, 0.76
>> Tasks: 179 total,   1 running, 178 sleeping,   0 stopped,   0 zombie
>> Cpu(s):  0.6%us,  2.4%sy,  0.0%ni, 70.8%id, 25.8%wa,  0.0%hi,  0.3%si,
>> 0.0%st
>> Mem:   4018276k total,  1577728k used,  2440548k free,    10496k buffers
>> Swap:  1998844k total,        0k used,  1998844k free,  1316696k cached
>>
>>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>
>>   1399 root      20   0  548m 103m 3428 S  0.0  2.6   2:01.85 ceph-osd
>>
>>   1401 root      20   0  548m 103m 3428 S  0.0  2.6   1:51.71 ceph-osd
>>
>>   1400 root      20   0  548m 103m 3428 S  0.0  2.6   1:50.30 ceph-osd
>>
>>   1391 root      20   0     0    0    0 S  0.0  0.0   1:18.39
>> btrfs-endio-wri
>>
>>    976 root      20   0     0    0    0 S  0.0  0.0   1:18.11
>> btrfs-endio-wri
>>
>>   1367 root      20   0     0    0    0 S  0.0  0.0   1:05.60
>> btrfs-worker-1
>>
>>    968 root      20   0     0    0    0 S  0.0  0.0   1:05.45
>> btrfs-worker-0
>>
>>   1163 root      20   0  141m 1636 1100 S  0.0  0.0   1:00.56 collectd
>>
>>    970 root      20   0     0    0    0 S  0.0  0.0   0:47.73
>> btrfs-submit-0
>>
>>   1402 root      20   0  548m 103m 3428 S  0.0  2.6   0:34.86 ceph-osd
>>
>>   1392 root      20   0     0    0    0 S  0.0  0.0   0:33.70
>> btrfs-endio-met
>>
>>    975 root      20   0     0    0    0 S  0.0  0.0   0:32.70
>> btrfs-endio-met
>>
>>   1415 root      20   0  548m 103m 3428 S  0.0  2.6   0:28.29 ceph-osd
>>
>>   1414 root      20   0  548m 103m 3428 S  0.0  2.6   0:28.24 ceph-osd
>>
>>   1397 root      20   0  548m 103m 3428 S  0.0  2.6   0:24.60 ceph-osd
>>
>>   1436 root      20   0  548m 103m 3428 S  0.0  2.6   0:13.31 ceph-osd
>>
>>
>> Here ist my setup.
>> Kernel v3.1 + Josef
>>
>> The config for this osd (ceph version 0.37
>> (commit:a6f3bbb744a6faea95ae48317f0b838edb16a896)) is:
>> [osd.1]
>>          host = s-brick-003
>>          osd journal = /dev/sda7
>>          btrfs devs = /dev/sdb
>>         btrfs options = noatime
>>         filestore_btrfs_snap = false
>>
>> I hope this helps to pin point the problem.
>>
>> Best Regards,
>> martin
>>
>>
>> Sage Weil schrieb:
>>>
>>> On Wed, 26 Oct 2011, Christian Brunner wrote:
>>>>
>>>> 2011/10/26 Sage Weil<sage@newdream.net>:
>>>>>
>>>>> On Wed, 26 Oct 2011, Christian Brunner wrote:
>>>>>>>>>
>>>>>>>>> Christian, have you tweaked those settings in your ceph.conf?  It
>>>>>>>>> would be
>>>>>>>>> something like 'journal dio = false'.  If not, can you verify that
>>>>>>>>> directio shows true when the journal is initialized from your osd
>>>>>>>>> log?
>>>>>>>>> E.g.,
>>>>>>>>>
>>>>>>>>>   2011-10-21 15:21:02.026789 7ff7e5c54720 journal _open
>>>>>>>>> dev/osd0.journal fd 14: 104857600 bytes, block size 4096 bytes, directio = 1
>>>>>>>>>
>>>>>>>>> If directio = 1 for you, something else funky is causing those
>>>>>>>>> blkdev_fsync's...
>>>>>>>>
>>>>>>>> I've looked it up in the logs - directio is 1:
>>>>>>>>
>>>>>>>> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
>>>>>>>> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size 4096
>>>>>>>> bytes, directio = 1
>>>>>>>
>>>>>>> Do you mind capturing an strace?  I'd like to see where that
>>>>>>> blkdev_fsync
>>>>>>> is coming from.
>>>>>>
>>>>>> Here is an strace. I can see a lot of sync_file_range operations.
>>>>>
>>>>> Yeah, these all look like the flusher thread, and shouldn't be hitting
>>>>> blkdev_fsync.  Can you confirm that with
>>>>>
>>>>>        filestore flusher = false
>>>>>        filestore sync flush = false
>>>>>
>>>>> you get no sync_file_range at all?  I wonder if this is also perf lying
>>>>> about the call chain.
>>>>
>>>> Yes, setting this makes the sync_file_range calls go away.
>>>
>>> Okay.  That means either sync_file_range on a regular btrfs file is
>>> triggering blkdev_fsync somewhere in btrfs, there is an extremely sneaky
>>> bug that is mixing up file descriptors, or latencytop is lying.  I'm
>>> guessing the latter, given the other weirdness Josef and Chris were
>>> seeing.  :)
>>>
>>>> Is it safe to use these settings with "filestore btrfs snap = 0"?
>>>
>>> Yeah.  They're purely a performance thing to push as much dirty data to
>>> disk as quickly as possible to minimize the snapshot create latency.
>>> You'll notice the write throughput tends to tank when them off.
>>>
>>> sage
>>
>>
>
>
>

