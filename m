Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hmm.wantstofly.org ([148.251.232.15]:55465 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbbFIKyq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 06:54:46 -0400
Date: Tue, 9 Jun 2015 13:54:43 +0300
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
Message-ID: <20150609105443.GA13858@wantstofly.org>
References: <20150526173634.GU11340@wantstofly.org>
 <20150526180820.GG16826@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20150526180820.GG16826@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 26, 2015 at 06:08:20PM +0000, Hugo Mills wrote:

> > The btrfs filesystem on my newly installed laptop has managed to
> > hose itself rather thoroughly, and it's now in a state where it
> > works okay if you don't write too much to it, but if you do, it
> > starts returning -ENOSPC on a random subset of your filesystem
> > operations until you let it cool down again.
> > 
> > This was a fresh Fedora 21 install, upgraded to F22, installed
> > about a month ago, with a ~250G btrfs filesystem on a 256G SSD,
> > and this system has only even run 4.0, and it has never had more
> > than ~60G on it.  It's currently running:
> >
> > # uname -a
> > Linux foobox 4.0.1-300.fc22.x86_64 #1 SMP Wed Apr 29 15:48:25 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > # btrfs --version
> > btrfs-progs v4.0
> > 
> > # btrfs fi show
> > Label: 'foobox'  uuid: [...]
> >         Total devices 1 FS bytes used 58.87GiB
> >         devid    1 size 229.97GiB used 229.97GiB path /dev/[...]
> 
>    All the space has been allocated for some purpose.
> 
> > # btrfs fi df /
> > Data, single: total=227.94GiB, used=58.16GiB
> > System, DUP: total=8.00MiB, used=48.00KiB
> > System, single: total=4.00MiB, used=0.00B
> > Metadata, DUP: total=1.00GiB, used=730.80MiB
> > Metadata, single: total=8.00MiB, used=0.00B
> > GlobalReserve, single: total=256.00MiB, used=0.00B
> 
>    For a filesystem of this size, a very small proportion has gone to
> metadata for some reason. This is odd. Given that it's happened,
> though, all the other behaviour is as expected.
> 
> > It's currently still in a funky state:
> > 
> > [root@foobox lib]# df /
> > Filesystem     1K-blocks     Used Available Use% Mounted on
> > /dev/dm-0      241145856 62743256 178027464  27% /
> 
>    Looks reasonable, give the figures above.
> 
> > [root@foobox lib]# pwd
> > /var/lib
> > [root@foobox lib]# touch foo
> > [root@foobox lib]# rm -f foo
> > [root@foobox lib]# ls -ald abrt
> > drwxr-xr-x. 1 root root 56 May 21 10:02 abrt
> > [root@foobox lib]# mv abrt abrt2
> > mv: cannot move ‘abrt’ to ‘abrt2’: No space left on device
> > [root@foobox lib]# 
> > 
> > Any tests anyone wants to run on this before I wipe and reinstall
> > the box?
> 
>    No tests needed. Just run a filtered balance on it to clean up
> unused chunks:
> 
> # btrfs balance start -dusage=5 /
> 
> as suggested in the FAQ [1].

Doing this helped for a few days, but now I'm back in a state where
I can't create any files at all -- everything fails with -ENOSPC.  The
filesystem isn't even half full and has never been more than half full.

[root@foobox ~]# uname -a
Linux foobox.wantstofly.org 4.0.4-301.fc22.x86_64 #1 SMP Thu May 21 13:10:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

[root@foobox ~]# btrfs --version
btrfs-progs v4.0

[root@foobox ~]# btrfs fi show
Label: 'foobox'  uuid: [...]
        Total devices 1 FS bytes used 98.72GiB
        devid    1 size 229.97GiB used 100.97GiB path /dev/mapper/[...]

btrfs-progs v4.0

[root@foobox ~]# btrfs fi df /
Data, single: total=98.00GiB, used=98.00GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.47GiB, used=737.73MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=256.00MiB, used=0.00B

[root@foobox ~]# df /
Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/dm-0      241145856 104533304 135265480  44% /


The balancing trick doesn't do anything:

[root@foobox ~]# btrfs balance start -dusage=5 /
Done, had to relocate 0 out of 104 chunks
[root@foobox ~]# btrfs balance start -dusage=10 /
Done, had to relocate 0 out of 104 chunks
[root@foobox ~]# btrfs balance start -dusage=20 /
Done, had to relocate 0 out of 104 chunks
[root@foobox ~]# btrfs balance start -dusage=50 /
Done, had to relocate 0 out of 104 chunks
[root@foobox ~]# btrfs balance start -dusage=80 /
Done, had to relocate 0 out of 104 chunks
[root@foobox ~]# 


Any ideas?
