Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38362 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab2L2NAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 08:00:49 -0500
Received: by mail-ie0-f182.google.com with SMTP id s9so13848706iec.27
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2012 05:00:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1ToibV-0001fD-SN@internal.tormail.org>
References: <1ToibV-0001fD-SN@internal.tormail.org>
Date: Sat, 29 Dec 2012 15:00:48 +0200
Message-ID: <CAOcd+r3OjBAGbRN-cSbL7tQP=tTRYakZO3fm9gA_oqSz6KXuYw@mail.gmail.com>
Subject: Re: Incremental btrfs receive in opposite direction fails
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: junlion@tormail.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, Dec 29, 2012 at 12:42 AM,  <junlion@tormail.org> wrote:
> Hi everyone!
>
> (I use kernel 3.7.1 and mason/btrfs-progs.git head + the receive
> lchown patch [1]. Is there a more up to date btrfs-progs repo for
> send/receive enthusiasts?)
There is no special repo, but you may want, in addition to the patch
you mentioned, apply this one as well:
https://patchwork.kernel.org/patch/1604391/
Whether you need it or not depends on how your subvolumes are
organized in a file tree.


>
> What I'm trying is basically:
>
> # Transfer a snapshot of my old system from a backup to the new system
> btrfs send /mnt/bak/.snap | btrfs receive /                 # OK
>
> # Merge the old system's files with the new system's files
> btrfs subvolume snapshot /.snap /.snap-merge                # OK
> mkdir /.snap-merge/.old                                     # OK
> mv /.snap-merge/* /.snap-merge/.old                         # OK
> cp -a --reflink /* /.snap-merge                             # OK
> btrfs subvolume snapshot -r /.snap-merge /.snap-merge-done  # OK
>
> # Incrementally transfer the merged files back to the backup drive
> btrfs send -p /.snap /.snap-merge-done | btrfs receive -p /mnt/bak
>
> The last step fails due to the changed direction of the transfer.
> "ERROR: could not find parent subvolume". It seems like btrfs receive
> cannot find the parent/clone source because it is searching for its UUID
> only by looking through the /mnt/bak snapshots' received_uuid fields.
>
> Is there a way for me to directly change the received_uuid of
> /mnt/bak/.snap to make it identical to the UUID of /.snap? This looks
> like the easiest way if I only need to do it once.
There is no implemented way, but since you debugged this far, you can
put up some code that sends BTRFS_IOC_SET_RECEIVED_SUBVOL, which is
the one setting the received_uuid (and some other small stuff, please
check the kernel code for it).

Thanks,
Alex.


>
> [1] https://patchwork.kernel.org/patch/1606091/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
