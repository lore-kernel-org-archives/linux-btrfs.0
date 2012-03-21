From: Daniel J Blueman <daniel@quora.org>
Subject: Re: 'bad tree block start' mount failure...
Date: Wed, 21 Mar 2012 18:19:16 +0800
Message-ID: <CAMVG2suxFWRY7uc0tv-AZ3pmSyzqhG+hXwzfNv8-a_E+P8On1Q@mail.gmail.com>
References: <CAMVG2suJw2miSP9QUi-ArFrzS0-okN0_MsLPZTc6Xv7xkjLHDw@mail.gmail.com>
	<CAK-xaQbAq85UFa41h-As3yDXvVz5ybtGU-ySVYJmcRLc0GgbgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAK-xaQbAq85UFa41h-As3yDXvVz5ybtGU-ySVYJmcRLc0GgbgA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 21 March 2012 00:16, Andrea Gelmini <andrea.gelmini@gmail.com> wrote:
> 2012/3/20 Daniel J Blueman <daniel@quora.org>:
>> mkfs.btrfs -m raid0 -d raid0 /dev/sdb1 /dev/sdc1
>> mount /dev/sdb1 /mnt
>> umount /mnt
>> mount /dev/sdb1 /mnt -o compress
>> umount /mnt
>> mount /dev/sdb1 /mnt -o ssd
>> umount /mnt
>> mount /dev/sdb1 /mnt -o discard
>> umount /mnt
>> mount /dev/sdb1 /mnt
>> <mount failure>
>
> Well, I can't reproduce this. It's also true that I use some
> out-of-the-tree patches.
> I wrote this each step. They must be in a script?

I can reproduce this booting with the ubuntu 3.3 mainline kernel with
eg 'ramdisk_size=2048000' and then:

# mkfs.btrfs -m raid0 -d raid0 /dev/ram0 /dev/ram1
# mount /dev/ram0 /mnt
# umount /mnt
# mount /dev/ram0 /mnt -o compress
# umount /mnt
# mount /dev/ram0 /mnt -o ssd
# umount /mnt
# mount /dev/ram0 /mnt -o discard
# umount /mnt
# mount /dev/ram0 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/ram0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

Thanks,
  Daniel
-- 
Daniel J Blueman
