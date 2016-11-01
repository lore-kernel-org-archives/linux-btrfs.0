Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8636 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752057AbcKAENu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 00:13:50 -0400
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>, Hugo Mills <hugo@carfax.org.uk>,
        <linux-btrfs@vger.kernel.org>
References: <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
 <20161031020616.GH28648@merlins.org>
 <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
 <20161031054719.GN28648@merlins.org>
 <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
 <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
 <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
 <20161031084412.GI16645@carfax.org.uk> <20161031150422.GQ28648@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
Date: Tue, 1 Nov 2016 12:13:38 +0800
MIME-Version: 1.0
In-Reply-To: <20161031150422.GQ28648@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/31/2016 11:04 PM, Marc MERLIN wrote:
> On Mon, Oct 31, 2016 at 08:44:12AM +0000, Hugo Mills wrote:
>>> Any idea on special dm setup which can make us fail to read out some
>>> data range?
>>
>>    I've seen both btrfs check and btrfs dump-super give wrong answers
>> (particularly, some addresses end up larger than the device, for some
>> reason) when run on a mounted filesystem. Worth ruling that one out.
>
> I just finished running my scrub overnight, and it failed around 10%:
> [115500.316921] BTRFS error (device dm-0): bad tree block start 8461247125784585065 17619396231168
> [115500.332354] BTRFS error (device dm-0): bad tree block start 8461247125784585065 17619396231168
> [115500.332626] BTRFS: error (device dm-0) in __btrfs_free_extent:6954: errno=-5 IO failure
> [115500.332629] BTRFS info (device dm-0): forced readonly
> [115500.332632] BTRFS: error (device dm-0) in btrfs_run_delayed_refs:2960: errno=-5 IO failure
> [115500.436002] btrfs_printk: 550 callbacks suppressed
> [115500.436024] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
> [115500.436029] BTRFS: error (device dm-0) in cleanup_transaction:1854: errno=-5 IO failure
>
>
> myth:~# ionice -c 3 nice -10 btrfs scrub start -Bd /mnt/mnt
> (...)
> scrub device /dev/mapper/crypt_bcache0 (id 1) canceled
>         scrub started at Sun Oct 30 22:52:59 2016 and was aborted after 09:03:11
>         total bytes scrubbed: 1.15TiB with 512 errors
>         error details: csum=512
>         corrected errors: 0, uncorrectable errors: 512, unverified errors: 0
>
> Am I correct that if I see "__btrfs_free_extent:6954: errno=-5 IO failure" it means
> that btrfs had physical read errors from the underlying block layer?

Not really sure if it's physical read errors. As we throw -EIO almost 
every where.

But that's possible that your extent tree got corrupted so 
__btrfs_free_extent() failed to modify extent tree.

And in that case, we do throw -EIO.

>
> Do I have some weird mismatch between the size of my md array and the size of my filesystem
> (as per dd apparently thinking parts of it are out of bounds?)
> Yet,  the sizes seem to match:

Would you try to locate the range where we starts to fail to read?

I still think the root problem is we failed to read the device in user 
space.

Thanks,
Qu
>
>
> myth:~#  mdadm --query --detail /dev/md5
> /dev/md5:
>         Version : 1.2
>   Creation Time : Tue Jan 21 10:35:52 2014
>      Raid Level : raid5
>      Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
>   Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>
>   Intent Bitmap : Internal
>
>     Update Time : Mon Oct 31 07:56:07 2016
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : gargamel.svh.merlins.org:5
>            UUID : ec672af7:a66d9557:2f00d76c:38c9f705
>          Events : 147992
>
>     Number   Major   Minor   RaidDevice State
>        0       8       97        0      active sync   /dev/sdg1
>        6       8      113        1      active sync   /dev/sdh1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       65        3      active sync   /dev/sde1
>        5       8       49        4      active sync   /dev/sdd1
>
> myth:~# btrfs fi df /mnt/mnt
> Data, single: total=13.22TiB, used=13.19TiB
> System, DUP: total=32.00MiB, used=1.42MiB
> Metadata, DUP: total=75.00GiB, used=72.82GiB
> GlobalReserve, single: total=512.00MiB, used=6.73MiB
>
> Thanks,
> Marc
>


