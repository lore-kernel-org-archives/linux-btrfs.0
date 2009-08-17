From: Mark Lord <lkml@rtr.ca>
Subject: Re: Why does stat() return invalid st_dev field for btrfs ??
Date: Mon, 17 Aug 2009 18:03:33 -0400
Message-ID: <4A89D3B5.5080200@rtr.ca>
References: <4A89C1DA.6040601@rtr.ca> <4A89C86A.1040207@rtr.ca> <m3eirads6m.fsf@pullcord.laptop.org> <4A89D2AC.5080006@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758198AbZHQWDe@vger.kernel.org>
In-Reply-To: <4A89D2AC.5080006@rtr.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Mark Lord wrote:
>
> stat(2) seems to return invalid major/minor device info
> for btrfs filesystems.
> 
> Why?  Is this a bug?
> 
> Eg.
> 
>     [~] uname -r
>     2.6.31-rc6
>     [~] mkfs.btrfs /dev/sdb
>     
>     WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>     WARNING! - see http://btrfs.wiki.kernel.org before using
>     
>     fs created label (null) on /dev/sdb
>             nodesize 4096 leafsize 4096 sectorsize 4096 size 30.06GB
>     Btrfs Btrfs v0.19
>     [~] mount /dev/sdb /x -t btrfs
>     [~] stat --format="%04D" /x
>     0017
>     [~] touch /x/junk
>     [~] stat --format="%04D" /x/junk
>     0017
> 
> This gives major=0x00, minor=0x17 for /dev/sdb,
> which should have major=8, minor=0x10.
> 
> ???

> Chris Ball wrote:
>> Hi,
>>
>>    > Mmm.. btrfs appears to configure itself as a "pseudo" filesystem,
>>    > which is why it returns fake device numbers via stat(), similar
>>    > to procfs or sysfs.
>>
>> Probably because a single btrfs filesystem can be composed of multiple
>> devices; one major/minor would not be sufficient.
> ..
> 
> So I'm seeing in the code.
> 
> But for the 99% common case (personal computers, one drive), it would be
> rather useful it it would comply with filesystem standards there.
> 
> In the unlikely event that a btrfs actually is composed of multiple 
> devices,
> then in that case perhaps return something nonsensical.
> 
> Mmm.. don't we already *have* an LVM layer in Linux?
> 
> Seems like a rather bad idea to have a new Linux-specific
> filesystem re-implement it's own private LVM, and thus
> confuse various disk management tools and the like.
..

[added linux-kernel to CC: list]

Along those lines -- since btrfs reports invalid device information to stat(2),
then I would suggest that it should also return -ENOTSUP for the FIBMAP and FIEMAP
ioctl() calls.  Otherwise, somebody's filesystem is going to get corrupted.

Cheers
