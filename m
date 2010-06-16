From: John Wyzer <john.wyzer@gmx.de>
Subject: Re: btrfsck segmentation fault + trace
Date: Wed, 16 Jun 2010 22:25:13 +0200
Message-ID: <4C193329.1000500@gmx.de>
References: <4C18F348.80509@gmx.de> <20100616163109.GX27466@think> <4C18FD4D.4070100@gmx.de> <20100616172900.GA27466@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100616172900.GA27466@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 16/06/10 19:29, Chris Mason wrote:
> On Wed, Jun 16, 2010 at 06:35:25PM +0200, John Wyzer wrote:
>>> Is 2.6.34 working normally?
>>
>> Yes. I can boot with 2.6.34.y and everything works fine. (Actually,
>> before trying 2.6.45-rc3, I had an uptime of two weeks on this laptop.
>> Now, I'm writing this email on 2.6.34.y.)
> 
> But every time you boot 2.6.35 you get errors?  Would it be possible to
> save the console output (netconsole works well)

[...]
device fsid 3247922091b53feb-dcb02f0506fbdc8b devid 1 transid 155748
/dev/mapper/root
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda4): warning: maximal mount count reached, running e2fsck is
recommended
EXT3-fs (sda4): using internal journal
EXT3-fs (sda4): recovery complete
EXT3-fs (sda4): mounted filesystem with writeback data mode
btrfs: fail to dirty  inode 9959493 error -28
btrfs: fail to dirty  inode 2987803 error -28
btrfs: fail to dirty  inode 2987803 error -28
btrfs: fail to dirty  inode 8873620 error -28
btrfs: fail to dirty  inode 8873620 error -28
btrfs: fail to dirty  inode 803894 error -28
btrfs: fail to dirty  inode 2988335 error -28
btrfs: fail to dirty  inode 2987971 error -28
btrfs: fail to dirty  inode 2987972 error -28
btrfs: fail to dirty  inode 2988336 error -28
btrfs: fail to dirty  inode 6631 error -28
btrfs: fail to dirty  inode 803896 error -28
btrfs: fail to dirty  inode 6632 error -28
btrfs: fail to dirty  inode 6633 error -28
btrfs: fail to dirty  inode 6634 error -28
[...] (nothing new coming, only error -28)

Apart from that, I had messages that there was no space left on /, but
those were from userspace and not logged via netconsole.

