Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:45769 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbeINL7u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 07:59:50 -0400
Subject: Re: btrfs convert problem
To: Nikolay Borisov <nborisov@suse.com>,
        Serhat Sevki Dincer <jfcgauss@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
 <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
 <CAPqC6xROL93b5DOrNPaNSZahVKYqSpg0-84DgHsFTQZtHVdnRg@mail.gmail.com>
 <10c6a6c5-4d96-30bb-3965-67272d2fe902@suse.com>
 <0af846d3-9f07-d744-f9e4-862fc5a0cbad@gmx.com>
 <d47473ef-53bb-2ef1-9c09-f0f02ffaa04f@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <662d6310-004d-d4f5-2a4f-b16978f08031@gmx.com>
Date: Fri, 14 Sep 2018 14:46:35 +0800
MIME-Version: 1.0
In-Reply-To: <d47473ef-53bb-2ef1-9c09-f0f02ffaa04f@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/14 下午1:52, Nikolay Borisov wrote:
> 
> 
> On 14.09.2018 02:17, Qu Wenruo wrote:
>>
>>
>> On 2018/9/14 上午12:37, Nikolay Borisov wrote:
>>>
>>>
>>> On 13.09.2018 19:15, Serhat Sevki Dincer wrote:
>>>>> -1 seems to be EPERM, is your device write-protected, readonly or
>>>>> something like that ?
>>>>
>>>> I am able to use ext4 partition read/write, created a file and wrote
>>>> in it, un/re mounted it, all is ok.
>>>> The drive only has a microusb port and a little led light; no rw
>>>> switch or anything like that..
>>>>
>>>
>>> What might help is running btrfs convert under strace. So something like :
>>>
>>> sudo strace -f -o strace.log btrfs-convert /dev/sdb1 and then send the log.
>>>
>> strace would greatly help in this case.
>>
>> My guess is something wrong happened in migrate_super_block(), which
>> doesn't handle ret > 0 case well.
>> In that case, it means pwrite 4K doesn't finish in one call, which looks
>> pretty strange.
> 
> So Qu,
> 
> I'm not seeing any EPERM errors, though I see the following so you might
> be right:
> 
> openat(AT_FDCWD, "/dev/sdb1", O_RDWR) = 5
> 
> followed by a lot of preads, the last one of which is:
> 
> pread64(5, 0x557a0abd10b0, 4096, 2732765184) = -1 EIO (Input/output
> error)

With context, it's pretty easy to locate the problem.

It's a bad block of your device.

Please try to use the following command to verify it:

dd if=/dev/sdb1 of=/dev/null bs=1 count=4096 skip=2732765184

And it would be nicer to check kernel dmesg to see if there is clue there.

The culprit code is read_disk_extent(), which reset ret to -1 when error
happens.
I'll send patch(es) to fix it and enhance error messages for btrfs-convert.


There is a workaround to let btrfs-convert continue, you could use
--no-datasum option to skip datasum generation, thus btrfs-convert won't
try to read such data.
But that's just ostrich algorithm.

I'd recommend to read all files in the original fs and locate which
file(s) are affected. And backup data asap.

Thanks,
Qu

> 
> This is then followed by a a lot of pwrites, the last 10 or so syscalls
> are:
> 
> pwrite64(5, "\220\255\262\244\0\0\0\0\0\0"..., 16384, 91127808) = 16384
> 
> pwrite64(5, "|IO\233\0\0\0\0\0\0"..., 16384, 91144192) = 16384
> 
> pwrite64(5, "x\2501n\0\0\0\0\0\0"..., 16384, 91160576) = 16384
> 
> pwrite64(5, "\252\254l)\0\0\0\0\0\0"..., 16384, 91176960) = 16384
> 
> pwrite64(5, "P\256\331\373\0\0\0\0\0\0"..., 16384, 91193344) = 16384
> 
> pwrite64(5, "\3\230\230+\0\0\0\0\0\0"..., 4096, 83951616) = 4096
> 
> write(2, "ERROR: ", 7) = 7
> 
> write(2, "failed to "..., 37) = 37
> 
> write(2, "\n", 1) = 1
> 
> close(4) = 0
> 
> write(2, "WARNING: ", 9) = 9
> 
> write(2, "an error o"..., 104) = 104
> 
> write(2, "\n", 1) = 1
> 
> exit_group(1) = ?
> 
> but looking at migrate_super_block it's not doing that many writes -
> just writing the sb at BTRFS_SUPER_INFO_OFFSET and then zeroing out
> 0..BTRFS_SUPER_INFO_OFFSET. Also the number of pwrites:
> grep -c pwrite ~/Downloads/btrfs-issue/convert-strace.log
> 198
> 
> So the failure is not originating from migrate_super_block.
> 
>>
>> Thanks,
>> Qu
>>
