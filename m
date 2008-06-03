From: Thomas King <kingttx@tomslinux.homelinux.org>
Subject: Re: Future Linux filesystems
Date: Tue, 3 Jun 2008 09:37:27 -0500 (CDT)
Message-ID: <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>     
     <20080603065205.GA19533@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080603065205.GA19533@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

> All the issues he complains about actually are solved by XFS, and XFS actually
does better in
> exactly these environments than either zfs on Solaris or JFS2 on AIX.
>
>

I asked the author that question and he states XFS is actually a pretty good
answer to most of those issues but believes it still falls short where "the
metadata areas are not aligned with RAID strips and allocation units are FAR too
small but better than ext." Another detail he brought out was sending data and
metadata to different devices in those environments and referenced RT XFS.
Otherwise having them on the same device increases the possibility of corruption
and/or a longer filesystem check/repair. Will btrfs offer something like this in
the future?

Do y'all foresee btrfs being used in exabtye installations?
Does/Will btrfs have RAID awareness in that it will align "the
superblock and metadata to the RAID stripe"?
What is the largest block allocation available?
Will btrfs be T10 DIF/block protect aware?
I remember reading that CRFS relies on btrfs, but will btrfs support NFS,
specifically version 4.1?

Thanks!
Tom King





