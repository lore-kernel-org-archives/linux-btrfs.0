From: lutz.euler@freenet.de (Lutz Euler)
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Tue, 14 Feb 2012 18:32:31 +0100
Message-ID: <20282.39599.228651.376423@localhost.localdomain>
References: <20270.59513.240729.662692@localhost.localdomain>
	<4F3386D8.6010108@cn.fujitsu.com>
	<20275.60248.386622.516828@localhost.localdomain>
	<4F34795B.2020004@cn.fujitsu.com>
	<20279.61547.888033.662423@localhost.localdomain>
	<4F38A665.4030506@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F38A665.4030506@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Liu Bo wrote:

> Actually I have no idea how to deal with this properly :(
> 
> Because btrfs supports multi-devices so that we have to set the
> filesystem logical range to [0, (u64)-1] to get things to work well,
> while other filesystems's logical range is [0, device's total_bytes].
> 
> What's more, in btrfs, devices can be mirrored to RAID, and the free
> space is also ordered by logical addr [0, (u64)-1], so IMO it is
> impossible to interpreted the range.

I do not concur with this reasoning, but please see below that I concur
with your conclusion.

I still think that the range could be interpreted like I hinted at in my
mail:

>> So, to make bulk discard of ranges useful, it seems the incoming range
>> should be interpreted relative to the size of the filesystem and not
>> to the allocated chunks. As AFAIK the size of the filesystem is just
>> the sum of the sizes of its devices it might be possible to map the
>> range onto a virtual concatenation of the devices, these perhaps
>> ordered by devid, and then to find the free space by searching for the
>> resulting devid(s) and device-relative offsets in the device tree?

This would only be somewhat difficult to use if the filesystem consisted
of a mixture of non trim-capable and trim-capable devices and if the
idea behind ranges is that the user can expect an equal amount of
trim-capable storage behind different equally sized ranges - but I don't
know if this is indeed an idea behind ranges. If, on the other hand,
there is a way outside of the ioctl to find out which devices the
filesystem consists of and which of these support discard, the above
mentioned way to interpret ranges would extend to this setting.

But maybe this would already be too ugly, essentially working around
the shortcomings of an interface that is too restricted.

Moreover, I don't know why ranges smaller than the filesystem are
supported by fstrim. I couldn't find any use cases or rationale for it
in fstrim's or the ioctl's documentation or elsewhere. This makes it
difficult to find out what might be useful in the case of a multi-device
filesystem ;-)

So, with ranges being this unclear, I concur with your suggestion:

> I'd better pick up "treat the "trim the complete filesystem" case
> specially", and drop the following commit:
>
> commit f4c697e6406da5dd445eda8d923c53e1138793dd
> Author: Lukas Czerner <lczerner@redhat.com>
> Date:   Mon Sep 5 16:34:54 2011 +0200
>
>     btrfs: return EINVAL if start > total_bytes in fitrim ioctl

More specifically, what I do wish for is:
- Fix the problem I started the thread for: Make fstrim of the complete
  filesystem work.
And then, if possible:
- Simplify btrfs_trim_fs as much as possible to remove all traces
  of support for ranges smaller than the filesystem, document that this
  anyway wouldn't do what the user might expect, and, if possible,
  return an error in these cases.
- Also trim unallocated space (for use after balancing and at mkfs
  time).

Thanks for your time and your work,

Lutz
