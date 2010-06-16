From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfsck segmentation fault + trace
Date: Thu, 17 Jun 2010 06:45:37 +0800
Message-ID: <AANLkTil8fnhT-ViGRV7BIyLIiKXyAjmayTeAiBWqn1Jc@mail.gmail.com>
References: <4C18F348.80509@gmx.de>
	<20100616163109.GX27466@think>
	<4C18FD4D.4070100@gmx.de>
	<20100616172900.GA27466@think>
	<4C193329.1000500@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C193329.1000500@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 17, 2010 at 4:25 AM, John Wyzer <john.wyzer@gmx.de> wrote:
> On 16/06/10 19:29, Chris Mason wrote:
>> On Wed, Jun 16, 2010 at 06:35:25PM +0200, John Wyzer wrote:
>>>> Is 2.6.34 working normally?
>>>
>>> Yes. I can boot with 2.6.34.y and everything works fine. (Actually,
>>> before trying 2.6.45-rc3, I had an uptime of two weeks on this lapt=
op.
>>> Now, I'm writing this email on 2.6.34.y.)
>>
>> But every time you boot 2.6.35 you get errors? =A0Would it be possib=
le to
>> save the console output (netconsole works well)
>
> [...]
> device fsid 3247922091b53feb-dcb02f0506fbdc8b devid 1 transid 155748
> /dev/mapper/root
> EXT3-fs: barriers not enabled
> kjournald starting. =A0Commit interval 5 seconds
> EXT3-fs (sda4): warning: maximal mount count reached, running e2fsck =
is
> recommended
> EXT3-fs (sda4): using internal journal
> EXT3-fs (sda4): recovery complete
> EXT3-fs (sda4): mounted filesystem with writeback data mode
> btrfs: fail to dirty =A0inode 9959493 error -28
> btrfs: fail to dirty =A0inode 2987803 error -28
> btrfs: fail to dirty =A0inode 2987803 error -28
> btrfs: fail to dirty =A0inode 8873620 error -28
> btrfs: fail to dirty =A0inode 8873620 error -28
> btrfs: fail to dirty =A0inode 803894 error -28
> btrfs: fail to dirty =A0inode 2988335 error -28
> btrfs: fail to dirty =A0inode 2987971 error -28
> btrfs: fail to dirty =A0inode 2987972 error -28
> btrfs: fail to dirty =A0inode 2988336 error -28
> btrfs: fail to dirty =A0inode 6631 error -28
> btrfs: fail to dirty =A0inode 803896 error -28
> btrfs: fail to dirty =A0inode 6632 error -28
> btrfs: fail to dirty =A0inode 6633 error -28
> btrfs: fail to dirty =A0inode 6634 error -28
> [...] (nothing new coming, only error -28)
>
> Apart from that, I had messages that there was no space left on /, bu=
t
> those were from userspace and not logged via netconsole.
>

looks like the fs runs out of metadata space. btrfs in 2.6.35 reserves
more metadata space for system use than btrfs in 2.6.34. That's why
these error message only appear on 2.6.35.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
