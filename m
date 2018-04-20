Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:41376 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755172AbeDTOtx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 10:49:53 -0400
Received: by mail-io0-f179.google.com with SMTP id o7-v6so9021031iob.8
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Apr 2018 07:49:53 -0700 (PDT)
Subject: Re: [PATCH 0/6] Add ioctl to clear unused space
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524233244.git.dsterba@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e1e66539-ac4c-f811-7a45-bbbc93779087@gmail.com>
Date: Fri, 20 Apr 2018 10:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1524233244.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-20 10:21, David Sterba wrote:
> This patchset adds new ioctl similar to TRIM, that provides several
> other ways how to clear the unused space.  The changelogs are
> incomplete, for preview not for inclusion yet.
+1 for the idea.  This will be insanely useful for certain VM setups.
> 
> It compiles and has been tested lightly, the clearing modes depend on hw
> capabilities (secure discard, sector unmapping instead of zeros), so
> I've tested only zeroing and discard.
I don't have specific experience with blkdev_issue_zeroout, but I think 
the sector unmapping may be covered by the discard support.  When 
dealing with SCSI devices, discard operations get converted to the SCSI 
UNMAP command, which just based on the naming, sounds like what 
blkdev_issue_zeroout is issuing (at least, when dealing with SCSI 
devices).  Pretty much, the SCSI command works just like the ATA TRIM 
command does on ATA devices which zero data on discard (except it's 
SCSI, so it can pretty much always be queued, and has some other 
semantics around it that give it better performance than ATA TRIM).

Assuming that is the case, the unmapping support could be tested using 
the QEMU PV-SCSI driver (which supports the UNMAP command) with 
appropriate backing storage.  I can look at doing this testing myself, 
as I already use PV-SCSI for storage on all my QEMU VM's.
> 
> I personally think the zeroing has a usecase and the other modes were
> easy to add. Further extensions can be considered, eg. WRITE_SAME,
> overwriting with a randomly generated pattern, or some filesystem canary
> patterns that can be used to report unused block read as metadata.
Zeroing does have a use-case.  It's wonderfully useful for handling 
compaction of VM disks when using a virtual machine manager that doesn't 
support discard operations for this purpose.  I can also see the secure 
discard support being useful (though not necessarily the sector 
unmapping support for reasons mentioned above).
> 
> As this is modelled after the generic FITRIM ioctl, so this could be a
> new generic ioctl too. However, last time somebody wanted such ioctl,
> there was a pushback. I'll consider making a generic version and send it
> for comments to fsdevel eventually.
> 
> git://github.com/kdave/btrfs-devel dev/zero-free
> 
> 
> David Sterba (6):
>    btrfs: extend trim callchain to pass the operation type
>    btrfs: add wrapper to switch clearing operation
>    btrfs: add zeroing clear operation
>    btrfs: add new ioctl BTRFS_IOC_CLEAR_FREE
>    btrfs: add discard secure to clear unused space
>    btrfs: add more zeroout modes for clearing unused space
> 
>   fs/btrfs/ctree.h            |   5 +-
>   fs/btrfs/extent-tree.c      | 130 ++++++++++++++++++++++++++++++++++++++------
>   fs/btrfs/free-space-cache.c |  22 +++++---
>   fs/btrfs/free-space-cache.h |   3 +-
>   fs/btrfs/ioctl.c            |  42 ++++++++++++++
>   include/uapi/linux/btrfs.h  |  26 +++++++++
>   6 files changed, 199 insertions(+), 29 deletions(-)
> 
