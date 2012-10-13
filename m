Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:44550 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2JMRAV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 13:00:21 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so2586565lag.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 10:00:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121012161047.GB20378@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
	<50733D66.5020600@gmx.net>
	<20121009111830.GC31743@campbell-lange.net>
	<CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
	<20121010221107.GA19266@campbell-lange.net>
	<CAOcd+r20CmNtpWvJ1KzgiyfTuUk=KMeM9b0okgQRefEhEyGPfA@mail.gmail.com>
	<20121011113359.GD22640@campbell-lange.net>
	<CAOcd+r3E=vhtHwenmHbqV_i3FN5e4rK0x+CkOOHz3WHKVAQi1A@mail.gmail.com>
	<20121011145601.GA29841@campbell-lange.net>
	<CAOcd+r0F-nj6kNrT-eO2g51qG+a8rPqAvOQKMFMavF8g=Zsxtg@mail.gmail.com>
	<20121012161047.GB20378@campbell-lange.net>
Date: Sat, 13 Oct 2012 19:00:19 +0200
Message-ID: <CAOcd+r1ZeWiemXQnBFkTxZP9zZuyVq+swuFTziuUoQJEQM1fig@mail.gmail.com>
Subject: Re: btrfs receive to subdirectory
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Rory Campbell-Lange <rory@campbell-lange.net>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rory,
thanks for confirming. I will put together a more formal patch to the list.

Thanks,
Alex.


On Fri, Oct 12, 2012 at 6:10 PM, Rory Campbell-Lange
<rory@campbell-lange.net> wrote:
> On 12/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
>> Hi Rory,
>> can you pls check if you have a file "/etc/mtab" on your machine? If
>> not or if it's empty or something like, then this probably explains
>> the issue. In this case, pls apply patch2 that is attached (instead of
>> previous patches). Otherwise, pls try with patch1 (instead of
>> previous) and then with patch2 (instead of any previous). Both will do
>> some amount of prints, pls post them. With both patches your tests
>> work fine for me.
>
> Hi Alex
>
> I reset everything and remade the btrfs partitions. I re-pulled
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> and applied your first patch.
>
>   (in /bkp)
>   mkdir snaps
>   btrfs snapshot -r mail snaps/snap1
>   btrfs subvolume snapshot -r mail snaps/snap1
>   mutt -f mail/INBOX/
>   btrfs subvolume snapshot -r mail snaps/snap2
>
>   # targets (dir, subvol with same name, subvol with different name)
>   mkdir /mnt/snaps
>   btrfs subvolume create /mnt/mail
>   btrfs subvolume create /mnt/snapmail
>   # base backup
>   btrfs send snaps/snap1 | btrfs receive /mnt/snaps
>   btrfs send snaps/snap1 | btrfs receive /mnt/mail
>   btrfs send snaps/snap1 | btrfs receive /mnt/snapmail
>   # update snapshots
>   btrfs send -p snaps/snap1 snaps/snap2 | btrfs receive /mnt/snaps
>   btrfs send -p snaps/snap1 snaps/snap2 | btrfs receive /mnt/mail
>   btrfs send -p snaps/snap1 snaps/snap2 | btrfs receive /mnt/snapmail
>
> All worked fine. Sorry for the previous errors, which look to be
> invalid.
>
> Cheers
> Rory
>
>
> /etc/mtab:
>
>     rootfs / rootfs rw 0 0
>     sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
>     proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
>     udev /dev devtmpfs rw,relatime,size=10240k,nr_inodes=749414,mode=755 0 0
>     devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
>     tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=600748k,mode=755 0 0
>     /dev/disk/by-uuid/6e899e2d-c401-4a92-8adf-a097bcaf2148 / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
>     tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
>     tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=1396860k 0 0
>     /dev/sda1 /boot ext4 rw,relatime,data=ordered 0 0
>     rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
>     /dev/sdb1 /mnt btrfs rw,relatime,space_cache 0 0
>     /dev/sda6 /bkp btrfs rw,relatime,space_cache 0 0
>
> --
> Rory Campbell-Lange
> rory@campbell-lange.net
