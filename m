From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Future Linux filesystems
Date: Tue, 3 Jun 2008 19:52:06 +0400
Message-ID: <20080603155206.GB22439@2ka.mipt.ru>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org> <20080603065205.GA19533@infradead.org> <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

On Tue, Jun 03, 2008 at 09:37:27AM -0500, Thomas King (kingttx@tomslinux.homelinux.org) wrote:
> I asked the author that question and he states XFS is actually a pretty good
> answer to most of those issues but believes it still falls short where "the
> metadata areas are not aligned with RAID strips and allocation units are FAR too
> small but better than ext." Another detail he brought out was sending data and
> metadata to different devices in those environments and referenced RT XFS.
> Otherwise having them on the same device increases the possibility of corruption
> and/or a longer filesystem check/repair. Will btrfs offer something like this in
> the future?

Right now btrfs can be created on top of multiple devices.
AFAIK, there are no policies on hwo to put data and metadata between them.

> Do y'all foresee btrfs being used in exabtye installations?
> Does/Will btrfs have RAID awareness in that it will align "the
> superblock and metadata to the RAID stripe"?
> What is the largest block allocation available?
> Will btrfs be T10 DIF/block protect aware?
> I remember reading that CRFS relies on btrfs, but will btrfs support NFS,
> specifically version 4.1?

Original author does not belive in networked filesystem as a key method
to organize large storages :)
Changes to filesystem are quite simple in order fs would be exported via
NFS, so that should not be a problem.

-- 
	Evgeniy Polyakov
