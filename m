From: "Dongjun Shin" <djshin90@gmail.com>
Subject: Re: Future Linux filesystems
Date: Wed, 4 Jun 2008 11:34:46 +0900
Message-ID: <7fe698080806031934g32bc0804pd2c2bd806d44d613@mail.gmail.com>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>
	 <20080603065205.GA19533@infradead.org>
	 <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Thomas King" <kingttx@tomslinux.homelinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 3, 2008 at 11:37 PM, Thomas King
<kingttx@tomslinux.homelinux.org> wrote:
>> All the issues he complains about actually are solved by XFS, and XFS actually
> does better in
>> exactly these environments than either zfs on Solaris or JFS2 on AIX.
>>
>>
>
> I asked the author that question and he states XFS is actually a pretty good
> answer to most of those issues but believes it still falls short where "the
> metadata areas are not aligned with RAID strips and allocation units are FAR too
> small but better than ext." Another detail he brought out was sending data and
> metadata to different devices in those environments and referenced RT XFS.
> Otherwise having them on the same device increases the possibility of corruption
> and/or a longer filesystem check/repair. Will btrfs offer something like this in
> the future?
>
> Do y'all foresee btrfs being used in exabtye installations?
> Does/Will btrfs have RAID awareness in that it will align "the
> superblock and metadata to the RAID stripe"?
> What is the largest block allocation available?
> Will btrfs be T10 DIF/block protect aware?
> I remember reading that CRFS relies on btrfs, but will btrfs support NFS,
> specifically version 4.1?
>

I also would like to comment that btrfs is ready for the future storage
- the solid state drive. Btrfs performs well on both HDD and SSD.

AFAIK, the ssd option of btrfs only affects the block allocation behavior.
However, under hybrid combination of HDD and SSD with the multi-device
support of btrfs, there can be more interesting optimizations that utilize
the physical characteristics of each device.

-- 
Dongjun
