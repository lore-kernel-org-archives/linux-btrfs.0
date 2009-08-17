From: Mark Lord <lkml@rtr.ca>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Mon, 17 Aug 2009 17:59:08 -0400
Message-ID: <4A89D2AC.5080006@rtr.ca>
References: <4A89C1DA.6040601@rtr.ca> <4A89C86A.1040207@rtr.ca> <m3eirads6m.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3eirads6m.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Ball wrote:
> Hi,
> 
>    > Mmm.. btrfs appears to configure itself as a "pseudo" filesystem,
>    > which is why it returns fake device numbers via stat(), similar
>    > to procfs or sysfs.
> 
> Probably because a single btrfs filesystem can be composed of multiple
> devices; one major/minor would not be sufficient.
..

So I'm seeing in the code.

But for the 99% common case (personal computers, one drive), it would be
rather useful it it would comply with filesystem standards there.

In the unlikely event that a btrfs actually is composed of multiple devices,
then in that case perhaps return something nonsensical.

Mmm.. don't we already *have* an LVM layer in Linux?

Seems like a rather bad idea to have a new Linux-specific
filesystem re-implement it's own private LVM, and thus
confuse various disk management tools and the like.

Cheers
