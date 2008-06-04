From: Thomas King <kingttx@tomslinux.homelinux.org>
Subject: Re: Future Linux filesystems
Date: Wed, 4 Jun 2008 09:00:19 -0500 (CDT)
Message-ID: <48373.143.166.226.42.1212588019.squirrel@tomslinux.homelinux.org>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>
    <20080603065205.GA19533@infradead.org>
    <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
    <20080604021441.GB7121@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080604021441.GB7121@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On Tue, Jun 03, 2008 at 09:37:27AM -0500, Thomas King wrote:
>> > All the issues he complains about actually are solved by XFS, and XFS
>> actually
>> does better in
>> > exactly these environments than either zfs on Solaris or JFS2 on AIX.
>> >
>> >
>>
>> I asked the author that question and he states XFS is actually a pretty good
>> answer to most of those issues but believes it still falls short where "the
>> metadata areas are not aligned with RAID strips and allocation units are FAR
>> too
>> small but better than ext."
>
> I think it would be best to let the XFS developers answer this part.
> But, XFS is designed for and used in massive installations, and I think
> it represents a scalability goal for Btrfs.
>
>> Another detail he brought out was sending data and
>> metadata to different devices in those environments and referenced RT XFS.
>> Otherwise having them on the same device increases the possibility of
>> corruption
>> and/or a longer filesystem check/repair. Will btrfs offer something like this
>> in
>> the future?
>
> Btrfs can duplicate metadata via the internal raid1 and raid10 code.  On
> single spindles it will duplicate metadata as well.  This is different
> from RT XFS which I do not understand well.
>
> There is not code today in btrfs to force data and metadata to different
> devices, but the disk format has the bits it needs to make that happen.
> I think it is an oversimplification to say that splitting the two
> between devices changes the chances of a corruption, or changes the time
> a repair takes.
>
> Btrfs does split data and metadata allocations, grouping metadata
> together in large chunks on the drive.  This does make FS check/repair
> faster by reducing seeks between metadata blocks.
>
>>
>> Do y'all foresee btrfs being used in exabtye installations?
>
> Yes
>
>> Does/Will btrfs have RAID awareness in that it will align "the
>> superblock and metadata to the RAID stripe"?
>
> Today the superblock is not stripe aligned, but it will be in a future
> release that supports super block duplication.  At least, the
> blocks that are frequently written will be striped aligned.
>
>> What is the largest block allocation available?
>
> 2^64 bytes.  But, in COW filesystems massive extents have different
> costs than they do in traditional filesystems.  It isn't always a good
> idea to make a huge extent.
>
>> Will btrfs be T10 DIF/block protect aware?
>
> I work closely with Martin, and we'll leverage the T10 DIF code as much
> as possible.
>
>> I remember reading that CRFS relies on btrfs, but will btrfs support NFS,
>> specifically version 4.1?
>>
>
> We'll definitely support NFS.  It doesn't work today, but it will before
> 1.0.
>
> -chris
>
>
Chris,

Thanks a ton for answering all these questions. I've asked the XFS developers
what was discussed here and they gave some excellent info as well.

Enjoy your day!
Tom King
