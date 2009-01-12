From: Peter Klotz <peter.klotz@aon.at>
Subject: Re: 2.6.29-rc1: Cannot loopback mount btrfs formatted file
Date: Mon, 12 Jan 2009 07:14:34 +0100
Message-ID: <496ADFCA.6020900@aon.at>
References: <496A683A.6090004@aon.at> <200901120015.14521.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901120015.14521.mail@earthworm.de>
List-ID: <linux-btrfs.vger.kernel.org>

Christian Hesse wrote:
> On Sunday 11 January 2009, Peter Klotz wrote:
>> Since 2.6.29-rc1 contains btrfs I had to try it.
>>
>> However the loopback mount of my btrfs formatted file fails:
>>
>> user@host:~$ dd if=/dev/zero of=btrfs.img bs=1MB count=512
>>
>> user@host:~$ mkfs.btrfs btrfs.img
>> fs created label (null) on btrfs.img
>>      nodesize 4096 leafsize 4096 sectorsize 4096 size 488.28MB
>> Btrfs v0.16+da35ab2b0b54
>>
>> user@host:~$ sudo mount -t btrfs -o loop btrfs.img /mnt/btrfs
>> mount: /dev/loop1: can't read superblock
>>
>>
>> Is this version of mkfs.btrfs compatible with the kernel module in
>> 2.6.29-rc1?
> 
> You have to use the btrfs-progs from unstable git repository. Chris plans to 
> release a new stable version within one day though.

Thanks, Btrfs v0.16-40-g6a63d49 worked fine.

Regards, Peter.
