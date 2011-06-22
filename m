From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Wed, 22 Jun 2011 12:09:44 -0400
Message-ID: <4E0213C8.20006@redhat.com>
References: <201106061220.05696.markotahal@gmail.com> <201106102043.19025.markotahal@gmail.com> <4DF28414.8090601@redhat.com> <1340741.hHfqtiVQGn@beruska>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Andy Lutomirski <luto@mit.edu>
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1340741.hHfqtiVQGn@beruska>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2011 05:52 PM, Marek Otahal wrote:
> On Friday 10 of June 2011 16:52:36 Josef Bacik wrote:
>> On 06/10/2011 02:43 PM, Marek Otahal wrote:
>>> On Friday 10 of June 2011 15:33:20 Josef Bacik wrote:
>>>> On 06/09/2011 10:06 PM, Daniel J Blueman wrote:
>>>>> On 10 June 2011 09:57, Andy Lutomirski <luto@mit.edu> wrote:
>>>>>> On 06/06/2011 06:19 AM, Marek Otahal wrote:
>>>>>>>
>>>>>>> Hello,
>>>>>>> the issue happens every time when i have to hard power-off my notebook
>>>>>>> (suspend problems).
>>>>>>> With kernel 2.6.39 the partition is unmountable, solution is to boot
>>>>>>> 2.6.38 kernel which
>>>>>>> 1/ is able to mount the partition,
>>>>>>> 2/ by doing that fixes the problem so later .39 (after clean shutdown) can
>>>>>>> mount it also.
>>>>>>
>>>>>> Same problem here.  Mounting with 2.6.38 says:
>>>>>>
>>>>>> [   41.906259] Btrfs loaded
>>>>>> [   41.906747] device fsid e040a9d60da49596-66c0275e348878bf devid 1 transid
>>>>>> 69217 /dev/mapper/vg_midnight_ssd-home
>>>>>> [   41.908767] btrfs: disk space caching is enabled
>>>>>> [   42.232185] btrfs: unlinked 17 orphans
>>>>>> [   42.232189] btrfs: truncated 2 orphans
>>>>>>
>>>>>> dmesg in 2.6.39.1 says:
>>>>> []
>>>>>> [   15.004255] kernel BUG at fs/btrfs/inode.c:4676!
>>>>> []
>>>>>
>>>>> I've been experiencing the same issue also.
>>>>>
>>>>> Josef/Chris, would an metadata snapshot or full block snapshot help
>>>>> debug this regression? I can probably setup a small testcase to
>>>>> trigger this.
>>>>>
>>>>
>>>> If you can come up with a testcase to reproduce I would love you forever
>>>> ;).  If I get done what I wanted to do today I will try and reproduce.
>>>> Thanks,
>>>>
>>>> Josef
>>>>
>>> ...I was getting ready for you eternal love, Josef :P...but I can't reproduce it 100%, like 70% 
> success-rate. 
>>>
>>> The test-case is quite easy, 
>>> 1. mount the FS, just with compress-force=lzo option // I didn't try without, but on my other 
> btrfs partition that doesn't use compression the err never happened ...so, can the others who 
> experience the bug confirm compress=lzo used?   
>>> 2. cd to it & create a file (not sure if needed)
>>> 3. hard power-off
>>>
>>> To reproduce my tests: 
>>> dd /dev/zero /btrfstest bs=1M count=256 (min required for default mksf.btrfs)
>>> losetup /dev/loop0 /btrfstest
>>> mkfs.btrfs /dev/loop0
>>> mount -o compress-force=lzo /dev/loop0 /mnt/tmp
>>> vim /mnt/tmp/hello.txt
>>> ---power off!
>>
>> How long do you wait between these two steps?  I've not been able to
>> reproduce this and I've done it maybe 5 times.  Either I've fixed it in
>> my tree (yay!) or I'm doing something wrong (boo!).  Thanks,
>>
>> Josef
> Not much but not immediately too, I'd say like ~5s. Did ls, df and quit. 
> Tomorrow I'll try if I can spot a difference. 
> Btw, is there a way to simulate power-off on a loopback-fs? Like to kill the loopback device while 
> fs is mounted or some way? So I don't have to stress the poor hw :) 
> Thank you, Mark
> 

I've not been able to hit this at all.  Can you try on 3.0-rc4 and see
if you are still hitting it?  Maybe it accidently got fixed already :).
 Thanks,

Josef
