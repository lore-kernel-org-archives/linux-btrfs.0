From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: Future Linux filesystems
Date: Tue, 03 Jun 2008 09:02:54 -0600
Message-ID: <48455D1E.8010006@gentoo.org>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>          <20080603065205.GA19533@infradead.org> <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

Thomas King wrote:
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

You don't mention what I believe is the *key* issue (and I don't think
the author did either, but I skimmed his article): data integrity.  I'm
not talking about blatant failures or known need for an fsck, but rather
silent corruption.

Where I work, we are considering multi-petabyte scenarios, and with the
specs of current drives, we are talking hundreds of silent errors per
read of the volume of data - unacceptable.  With large filesystems (and
he's talking 100 PB, etc.), this is the #1 issue for me.

						-Joe
