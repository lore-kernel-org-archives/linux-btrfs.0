Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:50034 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750959AbdHQHnP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:43:15 -0400
Subject: Re: slow btrfs with a single kworker process using 100% CPU
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>,
        Roman Mamedov <rm@romanrm.net>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
 <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru>
 <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag>
 <4669553.344.1502874134710.JavaMail.gkos@dynomob>
 <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
 <18522132.418.1502884115575.JavaMail.gkos@dynomob>
 <20170816170003.3f47321d@natsu>
 <31057849.442.1502886546489.JavaMail.gkos@dynomob>
 <a7ecda6e-6b75-c7b9-3546-4f3150de08d3@profihost.ag>
Message-ID: <27208cbf-0715-970c-5804-fdc7d65193ef@profihost.ag>
Date: Thu, 17 Aug 2017 09:43:13 +0200
MIME-Version: 1.0
In-Reply-To: <a7ecda6e-6b75-c7b9-3546-4f3150de08d3@profihost.ag>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

while mounting the device the dmesg is full of:
[ 1320.325147]  [<ffffffffa80a37b0>] ? kthread_park+0x60/0x60
[ 1440.330008] INFO: task btrfs-transacti:3701 blocked for more than 120
seconds.
[ 1440.330014]       Not tainted 4.4.82+525-ph #1
[ 1440.330015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1440.330020] btrfs-transacti D ffff88080964fdd8     0  3701      2
0x00080000
[ 1440.330024]  ffff88080964fdd8 ffffffffa8e10500 ffff880859d4cb00
ffff880809650000
[ 1440.330026]  ffff881056069800 ffff88080964fe08 ffff88080a100000
ffff88080a100068
[ 1440.330028]  ffff88080964fdf0 ffffffffa86d2b75 ffff880036c92000
ffff88080964fe58
[ 1440.330028] Call Trace:
[ 1440.330053]  [<ffffffffa86d2b75>] schedule+0x35/0x80
[ 1440.330120]  [<ffffffffc04cfa55>]
btrfs_commit_transaction.part.24+0x245/0xa30 [btrfs]
[ 1440.330159]  [<ffffffffc04d027a>] btrfs_commit_transaction+0x3a/0x70
[btrfs]
[ 1440.330186]  [<ffffffffc04ca3c5>] transaction_kthread+0x1d5/0x240 [btrfs]
[ 1440.330194]  [<ffffffffa80a389b>] kthread+0xeb/0x110
[ 1440.330200]  [<ffffffffa86d750f>] ret_from_fork+0x3f/0x70
[ 1440.333316] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70

[ 1440.333317] Leftover inexact backtrace:

[ 1440.333322]  [<ffffffffa80a37b0>] ? kthread_park+0x60/0x60
[ 1560.335839] INFO: task btrfs-transacti:3701 blocked for more than 120
seconds.
[ 1560.335843]       Not tainted 4.4.82+525-ph #1
[ 1560.335843] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1560.335848] btrfs-transacti D ffff88080964fdd8     0  3701      2
0x00080000
[ 1560.335852]  ffff88080964fdd8 ffffffffa8e10500 ffff880859d4cb00
ffff880809650000
[ 1560.335854]  ffff881056069800 ffff88080964fe08 ffff88080a100000
ffff88080a100068
[ 1560.335856]  ffff88080964fdf0 ffffffffa86d2b75 ffff880036c92000
ffff88080964fe58
[ 1560.335857] Call Trace:
[ 1560.335875]  [<ffffffffa86d2b75>] schedule+0x35/0x80
[ 1560.335953]  [<ffffffffc04cfa55>]
btrfs_commit_transaction.part.24+0x245/0xa30 [btrfs]
[ 1560.335978]  [<ffffffffc04d027a>] btrfs_commit_transaction+0x3a/0x70
[btrfs]
[ 1560.335995]  [<ffffffffc04ca3c5>] transaction_kthread+0x1d5/0x240 [btrfs]
[ 1560.336001]  [<ffffffffa80a389b>] kthread+0xeb/0x110
[ 1560.336006]  [<ffffffffa86d750f>] ret_from_fork+0x3f/0x70
[ 1560.337829] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70

[ 1560.337830] Leftover inexact backtrace:

[ 1560.337833]  [<ffffffffa80a37b0>] ? kthread_park+0x60/0x60
[ 1680.341127] INFO: task btrfs-transacti:3701 blocked for more than 120
seconds.
[ 1680.341130]       Not tainted 4.4.82+525-ph #1
[ 1680.341131] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1680.341134] btrfs-transacti D ffff88080964fdd8     0  3701      2
0x00080000
[ 1680.341137]  ffff88080964fdd8 ffffffffa8e10500 ffff880859d4cb00
ffff880809650000
[ 1680.341138]  ffff881056069800 ffff88080964fe08 ffff88080a100000
ffff88080a100068
[ 1680.341139]  ffff88080964fdf0 ffffffffa86d2b75 ffff880036c92000
ffff88080964fe58
[ 1680.341140] Call Trace:
[ 1680.341155]  [<ffffffffa86d2b75>] schedule+0x35/0x80
[ 1680.341211]  [<ffffffffc04cfa55>]
btrfs_commit_transaction.part.24+0x245/0xa30 [btrfs]
[ 1680.341237]  [<ffffffffc04d027a>] btrfs_commit_transaction+0x3a/0x70
[btrfs]
[ 1680.341252]  [<ffffffffc04ca3c5>] transaction_kthread+0x1d5/0x240 [btrfs]
[ 1680.341258]  [<ffffffffa80a389b>] kthread+0xeb/0x110
[ 1680.341262]  [<ffffffffa86d750f>] ret_from_fork+0x3f/0x70
[ 1680.343062] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70

Stefan

Am 17.08.2017 um 07:47 schrieb Stefan Priebe - Profihost AG:
> i've backported the free space cache tree to my kerne and hopefully any
> fixes related to it.
> 
> The first mount with clear_cache,space_cache=v2 took around 5 hours.
> 
> Currently i do not see any kworker with 100CPU but i don't see much load
> at all.
> 
> btrfs-transaction tooks around 2-4% CPU together with a kworker process
> and some 2-3% mdadm processes. I/O Wait is at 3%.
> 
> That's it. It does not do much more. Writing a file does not work.
> 
> Greets,
> Stefan
> 
> Am 16.08.2017 um 14:29 schrieb Konstantin V. Gavrilenko:
>> Roman, initially I had a single process occupying 100% CPU, when sysrq it was indicating as "btrfs_find_space_for_alloc"
>> but that's when I used the autodefrag, compress, forcecompress and commit=10 mount flags and space_cache was v1 by default.
>> when I switched to "relatime,compress-force=zlib,space_cache=v2" the 100% cpu has dissapeared, but the shite performance remained.
>>
>>
>> As to the chunk size, there is no information in the article about the type of data that was used. While in our case we are pretty certain about the compressed block size (32-128). I am currently inclining towards 32k as it might be ideal in a situation when we have a 5 disk raid5 array.
>>
>> In theory
>> 1. The minimum compressed write (32k) would fill the chunk on a single disk, thus the IO cost of the operation would be 2 reads (original chunk + original parity)  and 2 writes (new chunk + new parity)
>>
>> 2. The maximum compressed write (128k) would require the update of 1 chunk on each of the 4 data disks + 1 parity  write 
>>
>>
>>
>> Stefan what mount flags do you use?
>>
>> kos
>>
>>
>>
>> ----- Original Message -----
>> From: "Roman Mamedov" <rm@romanrm.net>
>> To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
>> Cc: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>, "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org, "Peter Grandi" <pg@btrfs.list.sabi.co.uk>
>> Sent: Wednesday, 16 August, 2017 2:00:03 PM
>> Subject: Re: slow btrfs with a single kworker process using 100% CPU
>>
>> On Wed, 16 Aug 2017 12:48:42 +0100 (BST)
>> "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com> wrote:
>>
>>> I believe the chunk size of 512kb is even worth for performance then the default settings on my HW RAID of  256kb.
>>
>> It might be, but that does not explain the original problem reported at all.
>> If mdraid performance would be the bottleneck, you would see high iowait,
>> possibly some CPU load from the mdX_raidY threads. But not a single Btrfs
>> thread pegging into 100% CPU.
>>
>>> So now I am moving the data from the array and will be rebuilding it with 64
>>> or 32 chunk size and checking the performance.
>>
>> 64K is the sweet spot for RAID5/6:
>> http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html
>>
