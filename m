From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
  then 256m
Date: Mon, 05 Jan 2009 16:49:16 +0100
Message-ID: <49622BFC.7040105@wpkg.org>
References: <49621CBA.2080802@wpkg.org> <49622525.80001@schleiser.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: Kaspar Schleiser <kaspar@schleiser.de>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49622525.80001@schleiser.de>
List-ID: <linux-btrfs.vger.kernel.org>

Kaspar Schleiser schrieb:
> Hey,
> 
> Tomasz Chmielewski wrote:
>>> This has been bothering me for some time. Why does btrfs need to have 
>>> a disk greater then 256M? I could see a much smaller limit, say 16M 
>>> but why so much? The file system itself does not need that much space 
>>> for its own use.
>>
>> In other words, 256M limit rather disqualifies btrfs as a filesystem 
>> i.e. for /boot, doesn't it?
> When 1G is just 10c?

Maybe when talking about traditional HDDs.
Anything flash-based is still $2-$5 per 1G.

I have some SAN devices booting off 512MB or 1G builtin flash. Having 
256M for /boot there would not leave much more space for the operating 
system.

Why separate /boot? It's still needed for encrypted rootfs or more fancy 
partitioning (like / on LVM, at least until GRUB2 is stable and is 
shipped by major distros).


Seriously, what are the technical reasons that btrfs needs so much space 
for a minimal filesystem?

Just 2 MB is enough for mkfs.ext4 to create a valid filesystem.


Also, the patch seems to be incomplete - i.e. what will happen if we try 
to btrfs-convert a 50MB ext3 filesystem into btrfs?


-- 
Tomasz Chmielewski
http://wpkg.org
