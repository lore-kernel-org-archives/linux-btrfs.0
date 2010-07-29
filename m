From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: can subvolumes be specified as compressed?
Date: Thu, 29 Jul 2010 18:04:27 +0800
Message-ID: <4C51522B.8090304@cn.fujitsu.com>
References: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>	<4C5139FB.8070504@cn.fujitsu.com> <AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Wang Shaoyan <stufever@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Jul 2010 16:55:03 +0800, Wang Shaoyan wrote:
> A prerequisite is: when first mounted file system, not specify '-o
> compress' options, only on mount subvolume
> Below is my test:
> # mkfs.btrfs /dev/sda8
> # mount /dev/sda8 btrfs
> # df
>      Used: 56k
> # btrfs subvolume create mysubvolume
> # mkdir some_dir_in_root
> # mount -o compress,subvol=mysubvolume /dev/sda8 some_dir_in_root
> # cd some_dir_in_root
> # dd if=/dev/zero of=bigfile count=2048 //create a all-0 file of 1M byte
> # df
>      Used:1088k
> we can find it is not compressed at all.
>
> Another test:if we mount subvolume with "-o compress" first, then we
> mount /dev/sda8 without "-o compress", and create a test file in
> somewhere not in subvolume, we can find the file is compressed too.

Sorry! I made a mistake.

According to the implement of the btrfs, after we mount a btrfs filesystem
(include subvol), if we mount the same filesystem again or its subvol, the
kernel doesn't allocate a new super_block object, and use the super_block
object that allocated and initiated at the first mount. So the feature is also
the same as the filesystem mounted first.

Thanks
Miao

>
> 2010/7/29 Miao Xie<miaox@cn.fujitsu.com>:
>> On Thu, 29 Jul 2010 15:50:28 +0800, Wang Shaoyan wrote:
>>>
>>> Hi.
>>> I want a subvolume in root to be compressed, I try to do this:
>>> # mkfs.btrfs /dev/sda8
>>> # mount /dev/sda8 /home/usr/btrfs
>>> # cd /home/usr/btrfs
>>> # btrfs subvolume create mysubvolume
>>> # mount -o compress,subvol=mysubvolume /dev/sda8 some_dir_in_root
>>> but when I create a file in some_dir_in_root, the file isn't
>>> compressed at all. why? How can I specify some subvolumes to be
>>> compressed, and the others Not to be compressed in a single btrfs?
>>
>> The method that you said is right, by this way, I can create a compressed
>> file
>> on the specified subvolume.
>>
>> I think your file has been compressed or is hard to be compressed, so
>> you found it isn't compressed at all. Just like we use a zip tool to
>> compress
>> a compressed file, we will find the file isn't compressed at all.
>>
>> Thanks
>> Miao
>>
>>>
>>> --
>>> Wang Shaoyan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>
>
>

