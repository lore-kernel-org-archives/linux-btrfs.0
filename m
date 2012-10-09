Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:56355 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab2JILSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 07:18:49 -0400
Date: Tue, 9 Oct 2012 12:18:30 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive to subdirectory
Message-ID: <20121009111830.GC31743@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
 <50733D66.5020600@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50733D66.5020600@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/12, Arne Jansen (sensille@gmx.net) wrote:
> On 10/08/12 18:30, Rory Campbell-Lange wrote:
> > I can send snapshots to <volume>, but not <volume>/<dir>. Please advise
> > if what I am doing is incorrect.

> > Try and snap to /mnt/<subdir>
> > 	root@orchard:/bkp# mkdir /mnt/snaps
> > 	root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/snaps
> > 	> At subvol snaps/snap_081012_1715
> > 	> At subvol snap_081012_1715
> > 	root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
> > 	                   snaps/snap_081012_1716 | btrfs receive /mnt/snaps
> > 	> At subvol snaps/snap_081012_1716
> > 	> At snapshot snap_081012_1716
> > 	> ERROR: open snaps/snap_081012_1715 failed. No such file or directory
> >     root@orchard:/bkp# ls /mnt/snaps
> >     > snap_081012_1715
> 
> The target has to be a subvol also. But interestingly enough, it also
> fails for a subvol. The base send works, the incremental fails, because
> btrfs receive can't find snaps/snap_081012_1715. If you give /mnt/snaps
> as the target for the base and just /mnt for the incremental, it works.
> There's clearly something broken there...

Actually, this does work:

    root@orchard:~# mkfs.btrfs /dev/sdb1
        ...snip...
        > Btrfs v0.20-rc1-37-g91d9eec
    root@orchard:/bkp# ls
        > snaps  subvol
    root@orchard:/bkp# mount /dev/sdb1 /mnt
    root@orchard:/bkp# btrfs subvolume create /mnt/subvol
        > Create subvolume '/mnt/subvol'
    root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/subvol
        > At subvol snaps/snap_081012_1715
        > At subvol snap_081012_1715
    root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
                             snaps/snap_081012_1716 | btrfs receive /mnt/subvol
        > At subvol snaps/snap_081012_1716
        > At snapshot snap_081012_1716

It certainly seems to work if the receive target is a subvolume other
than the implicit subvolume at the root of the mount point.

So one can only btrfs receive to a subvolume, which makes sense, and is
I believe the reason one cannot 'btrfs receive to a subdirectory' as set
out in the subject of my original email.

Are there any other problem cases you can see, Arne?

Regards
Rory

-- 
Rory Campbell-Lange
rory@campbell-lange.net
