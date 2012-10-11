Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:36353 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab2JKLeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 07:34:21 -0400
Date: Thu, 11 Oct 2012 12:33:59 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive to subdirectory
Message-ID: <20121011113359.GD22640@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
 <50733D66.5020600@gmx.net>
 <20121009111830.GC31743@campbell-lange.net>
 <CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
 <20121010221107.GA19266@campbell-lange.net>
 <CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
> I am using the latest code from Chris's repo (
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git),
> which has been updated recently (latest commit
> 91d9eec1ff044394f2b98ee7fcb76713dd33b994).
> Do you think you can try the following patch on top of this commit? (I
> made another small fix).

I had to fix the line wrapping, but your patch applies fine now.

> Basically, the idea is that the path that you give to "btrfs receive"
> should be the destination directory, in which the received subvolume
> will be created. And this directory should be somewhere under a mount
> point, where destination btrfs is mounted (it can also be the same as
> the mount point, but not above it). Does this make sense?
> Also it should not matter where the sent subvolume resided in the
> source fs, and, if this is a diff-send, where you have received the
> parent snapshot to (as long as it is on/under the same mount point).

I don't think the receive pathing works. Please note below the following issues:
    [aa] ERROR: open snapdir/subvol_20121011_1214 failed. No such file or directory
    [bb] ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory
    [cc] ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory

I tested this with the following:

    send mount point /bkp
    receive mount point /mnt

The 'send' mount point has the following structure:

    root@orchard:/bkp# ls
    > snaps  subvol
    (subvol a btrfs subvolume, snaps a directory for holding snapshots)

I then made a directory and two subvolumes in /mnt to receive 'sends':

    root@orchard:/bkp# ls /mnt
    > arbitrary_subvol  snapdir  subvol

I applied your patch to progs 91d9eec1, then did the following rooted in /bkp:

    1. Create snapshots

    root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/subvol_20121011_1214
    > Create a readonly snapshot of 'subvol' in 'snaps/subvol_20121011_1214'

    root@orchard:/bkp# mutt -f subvol/INBOX
    > 1573 kept, 39 deleted.

    root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/subvol_20121011_1216
    > Create a readonly snapshot of 'subvol' in 'snaps/subvol_20121011_1216'

    2. Send base snapshots to /mnt/{snapdir,arbitrary_subvol,subvol}

    root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/snapdir
    > At subvol snaps/subvol_20121011_1214
    > At subvol subvol_20121011_1214

    root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/arbitrary_subvol
    > At subvol snaps/subvol_20121011_1214
    > At subvol subvol_20121011_1214

    root@orchard:/bkp# btrfs send snaps/subvol_20121011_1214 | btrfs receive /mnt/subvol
    > At subvol snaps/subvol_20121011_1214
    > At subvol subvol_20121011_1214

    3. Send incremental changes

    root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214 
                       snaps/subvol_20121011_1216/ | btrfs receive /mnt/snapdir
    At subvol snaps/subvol_20121011_1216/
    At snapshot subvol_20121011_1216
    ERROR: open snapdir/subvol_20121011_1214 failed. No such file or directory [aa]

    root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214 
                             snaps/subvol_20121011_1216/ | btrfs receive /mnt/arbitrary_subvol
    At subvol snaps/subvol_20121011_1216/
    At snapshot subvol_20121011_1216
    ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory [bb]

    root@orchard:/bkp# btrfs send -p snaps/subvol_20121011_1214 
                             snaps/subvol_20121011_1216/ | btrfs receive /mnt/subvol
    At subvol snaps/subvol_20121011_1216/
    At snapshot subvol_20121011_1216
    ERROR: open <FS_TREE>/snapdir/subvol_20121011_1214 failed. No such file or directory [cc]


    root@orchard:/bkp# btrfs subvolume list /bkp
    ID 256 gen 9 top level 5 path subvol
    ID 260 gen 7 top level 5 path snaps/subvol_20121011_1214
    ID 261 gen 9 top level 5 path snaps/subvol_20121011_1216

    root@orchard:/bkp# btrfs subvolume list /mnt
    ID 301 gen 66 top level 5 path arbitrary_subvol
    ID 302 gen 69 top level 5 path subvol
    ID 303 gen 66 top level 5 path snapdir/subvol_20121011_1214
    ID 304 gen 69 top level 5 path arbitrary_subvol/subvol_20121011_1214
    ID 305 gen 72 top level 5 path subvol/subvol_20121011_1214



-- 
Rory Campbell-Lange
rory@campbell-lange.net
