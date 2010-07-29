From: Wang Shaoyan <stufever@gmail.com>
Subject: Re: can subvolumes be specified as compressed?
Date: Thu, 29 Jul 2010 16:55:03 +0800
Message-ID: <AANLkTi=HwyeSxwMNXWTCDzpzDMqoza1DcTuEzS6oirXF@mail.gmail.com>
References: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>
	<4C5139FB.8070504@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5139FB.8070504@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

A prerequisite is: when first mounted file system, not specify '-o
compress' options, only on mount subvolume
Below is my test:
# mkfs.btrfs /dev/sda8
# mount /dev/sda8 btrfs
# df
    Used: 56k
# btrfs subvolume create mysubvolume
# mkdir some_dir_in_root
# mount -o compress,subvol=3Dmysubvolume /dev/sda8 some_dir_in_root
# cd some_dir_in_root
# dd if=3D/dev/zero of=3Dbigfile count=3D2048 //create a all-0 file of =
1M byte
# df
    Used:1088k
we can find it is not compressed at all.

Another test:if we mount subvolume with "-o compress" first, then we
mount /dev/sda8 without "-o compress", and create a test file in
somewhere not in subvolume, we can find the file is compressed too.

2010/7/29 Miao Xie <miaox@cn.fujitsu.com>:
> On Thu, 29 Jul 2010 15:50:28 +0800, Wang Shaoyan wrote:
>>
>> Hi.
>> I want a subvolume in root to be compressed, I try to do this:
>> # mkfs.btrfs /dev/sda8
>> # mount /dev/sda8 /home/usr/btrfs
>> # cd /home/usr/btrfs
>> # btrfs subvolume create mysubvolume
>> # mount -o compress,subvol=3Dmysubvolume /dev/sda8 some_dir_in_root
>> but when I create a file in some_dir_in_root, the file isn't
>> compressed at all. why? How can I specify some subvolumes to be
>> compressed, and the others Not to be compressed in a single btrfs?
>
> The method that you said is right, by this way, I can create a compre=
ssed
> file
> on the specified subvolume.
>
> I think your file has been compressed or is hard to be compressed, so
> you found it isn't compressed at all. Just like we use a zip tool to
> compress
> a compressed file, we will find the file isn't compressed at all.
>
> Thanks
> Miao
>
>>
>> --
>> Wang Shaoyan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>>
>
>



--=20
Wang Shaoyan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
