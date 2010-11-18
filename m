From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 16:39:05 +0100
Message-ID: <4CE54899.9010600@wpkg.org>
References: <4CE51613.8060609@wpkg.org> <1290090160-sup-1717@think> <4CE53EDE.0@wpkg.org> <1290092740-sup-9020@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290092740-sup-9020@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18.11.2010 16:07, Chris Mason wrote:

(...)

>> [27821.906513] btrfs-cache-8 D ffff88050c5fde98     0  8089      2 0x00000000
>> [27821.906517]  ffff88051c3a9b60 0000000000000046 ffff88051c3a9b00 ffff88051c3a9fd8
>> [27821.906522]  00000000000139c0 00000000000139c0 ffff88051c3a9fd8 ffff88051c3a9fd8
>> [27821.906526]  00000000000139c0 ffff88050c5fde98 ffff88050c5fdea0 ffff88050c5fdb00
>> [27821.906530] Call Trace:
>> [27821.906534]  [<ffffffff8159fc4e>] io_schedule+0x5e/0xa0
>> [27821.906538]  [<ffffffff81109f15>] sync_page+0x45/0x60
>
> So, you're caching block groups.  What you want to do is use Josef's new
> block group caching code.
>
> mount -o space_cache /dev/xxx
>
> Do the test and let the caching threads finish, then unmount and then
> your next run should be fast.

# mount -o space_cache /dev/sdb4 /mnt/btrfs/
[29720.305741] btrfs: enabling disk space caching
[29720.305743] btrfs: force clearing of disk cache


I don't see any difference in behaviour with this mount option; it still 
"hangs" for quite a bit at around ~1.8 GB (and reading with ~500 kB/s 
when the hangs happens) on a subsequent dd run (several runs, 
unmounts/mounts).


-- 
Tomasz Chmielewski
http://wpkg.org
