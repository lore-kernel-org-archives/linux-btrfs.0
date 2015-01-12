Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:38708 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbbALPfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 10:35:30 -0500
Received: by mail-yk0-f181.google.com with SMTP id 142so9454642ykq.12
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 07:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B3E03E.80606@gmail.com>
References: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
	<54B3E03E.80606@gmail.com>
Date: Mon, 12 Jan 2015 16:35:29 +0100
Message-ID: <CABdHLQ6b_PpaMK7n+NhU5qV9UvtanqJcpn8y1vpM84h9RGSXDQ@mail.gmail.com>
Subject: Re: btrfs performance - ssd array
From: "P. Remek" <p.remek1@googlemail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Another thing to consider is that the kernel's default I/O scheduler and the default parameters for that I/O scheduler are almost always suboptimal for SSD's, and this tends to show far more with BTRFS than anything else.  Personally >I've found that using the CFQ I/O scheduler with the following parameters works best for a majority of SSD's:
>1. slice_idle=0
>2. back_seek_penalty=1
>3. back_seek_max set equal to the size in sectors of the device
>4. nr_requests and quantum set to the hardware command queue depth

I will give these suggestions a try but I don't expect any big gain.
Notice that the difference between EXT4 and BTRFS random write is
massive - its 200 000 IOPs vs. 15 000 IOPs and the device and kernel
parameters are exactly the same (it is same machine) for both test
scenarios. It suggests that something is taking down write performance
in the Btrfs implementation.

Notice also that we did some performance tuning ( queue scheduling set
to noop, irq affinity distribution and pinning to specific numa nodes
and cores etc.)

Regards,
Premek


On Mon, Jan 12, 2015 at 3:54 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-01-12 08:51, P. Remek wrote:
>> Hello,
>>
>> we are currently investigating possiblities and performance limits of
>> the Btrfs filesystem. Now it seems we are getting pretty poor
>> performance for the writes and I would like to ask, if our results
>> makes sense and if it is a result of some well known performance
>> bottleneck.
>>
>> Our setup:
>>
>> Server:
>>     CPU: dual socket: E5-2630 v2
>>     RAM: 32 GB ram
>>     OS: Ubuntu server 14.10
>>     Kernel: 3.19.0-031900rc2-generic
>>     btrfs tools: Btrfs v3.14.1
>>     2x LSI 9300 HBAs - SAS3 12/Gbs
>>     8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
>>
>> Both HBAs see all 8 disks and we have set up multipathing using
>> multipath command and device mapper. Then we using this command to
>> create the filesystem:
>>
>> mkfs.btrfs -f -d raid10 /dev/mapper/prm-0 /dev/mapper/prm-1
>> /dev/mapper/prm-2 /dev/mapper/prm-3 /dev/mapper/prm-4
>> /dev/mapper/prm-5 /dev/mapper/prm-6 /dev/mapper/prm-7
> You almost certainly DO NOT want to use BTRFS raid10 unless you have known good backups and are willing to deal with the downtime associated with restoring them.  The current incarnation of raid10 in BTRFS is much worse than LVM/MD based soft-raid with respect to data recoverability.  I would suggest using BTRFS raid1 in this case (which behaves like MD-RAID10 when used with more than 2 devices), possibly on top of LVM/MD RAID0 if you really need the performance.
>>
>>
>> We run performance test using following command:
>>
>> fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
>> --name=test1 --filename=test1 --bs=4k --iodepth=32 --size=12G
>> --numjobs=24 --readwrite=randwrite
>>
>>
>> The results for the random read are more or less comparable with the
>> performance of EXT4 filesystem, we get approximately 300 000 IOPs for
>> random read.
>>
>> For random write however, we are getting only about 15 000 IOPs, which
>> is much lower than for ESX4 (~200 000 IOPs for RAID10).
>>
>
> While I don't have any conclusive numbers, I have noticed myself that random write based AIO on BTRFS does tend to be slower on other filesystems.  Also, LVM/MD based RAID10 does outperform BTRFS' raid10 implementation, and probably will for quite a while; however, I've also noticed that faster RAM does provide a bigger benefit for BTRFS than it does for LVM (~2.5% greater performance for BTRFS than for LVM when switching from DDR3-1333 to DDR3-1600 on otherwise identical hardware), so you might consider looking into that.
>
> Another thing to consider is that the kernel's default I/O scheduler and the default parameters for that I/O scheduler are almost always suboptimal for SSD's, and this tends to show far more with BTRFS than anything else.  Personally I've found that using the CFQ I/O scheduler with the following parameters works best for a majority of SSD's:
> 1. slice_idle=0
> 2. back_seek_penalty=1
> 3. back_seek_max set equal to the size in sectors of the device
> 4. nr_requests and quantum set to the hardware command queue depth
>
> You can easily set these persistently for a given device with a udev rule like this:
>   KERNEL=='sda', SUBSYSTEM=='block', ACTION=='add', ATTR{queue/scheduler}='cfq', ATTR{queue/iosched/back_seek_penalty}='1', ATTR{queue/iosched/back_seek_max}='<device_size>', ATTR{queue/iosched/quantum}='128', ATTR{queue/iosched/slice_idle}='0', ATTR{queue/nr_requests}='128'
>
> Make sure to replace '128' in the rule with whatever the command queue depth is for the device in question (It's usually 128 or 256, occasionally more), and <device_size> with the size of the device in kibibytes.
>
>
