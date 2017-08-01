Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49386 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdHAMUl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 08:20:41 -0400
Date: Tue, 1 Aug 2017 12:20:39 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: pwm <pwm@iapetus.neab.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Massive loss of disk space
Message-ID: <20170801122039.GX7140@carfax.org.uk>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yKucn/VR3FthLjAA"
In-Reply-To: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--yKucn/VR3FthLjAA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Per,

   Start here:

https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29

   In your case, I'd suggest using "-dusage=20" to start with, as
it'll probably free up quite a lot of your existing allocation.

And this may also be of interest, in how to read the output of the
tools:

https://btrfs.wiki.kernel.org/index.php/FAQ#Understanding_free_space.2C_using_the_original_tools

   Finally, I note that you've still got some "single" chunks present
for metadata. It won't affect your space allocation issues, but I
would recommend getting rid of them anyway:

# btrfs balance start -mconvert=dup,soft

   Hugo.

On Tue, Aug 01, 2017 at 01:43:23PM +0200, pwm wrote:
> I have a 10TB file system with a parity file for a snapraid.
> However, I can suddenly not extend the parity file despite the file
> system only being about 50% filled - I should have 5TB of
> unallocated space. When trying to extend the parity file,
> fallocate() just returns ENOSPC, i.e. that the disk is full.
> 
> Machine was originally a Debian 8 (Jessie) but after I detected the
> issue and no btrfs tool did show any errors, I have updated to
> Debian 9 (Snatch) to get a newer kernel and newer btrfs tools.
> 
> pwm@europium:/mnt$ btrfs --version
> btrfs-progs v4.7.3
> pwm@europium:/mnt$ uname -a
> Linux europium 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2
> (2017-06-26) x86_64 GNU/Linux
> 
> 
> 
> 
> pwm@europium:/mnt/snap_04$ ls -l
> total 4932703608
> -rw------- 1 root root     319148889 Jul  8 04:21 snapraid.content
> -rw------- 1 root root     283115520 Aug  1 04:08 snapraid.content.tmp
> -rw------- 1 root root 5050486226944 Jul 31 17:14 snapraid.parity
> 
> 
> 
> pwm@europium:/mnt/snap_04$ df .
> Filesystem      1K-blocks       Used  Available Use% Mounted on
> /dev/sdg1      9766434816 4944614648 4819831432  51% /mnt/snap_04
> 
> 
> 
> pwm@europium:/mnt/snap_04$ sudo btrfs fi show .
> Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
>         Total devices 1 FS bytes used 4.60TiB
>         devid    1 size 9.09TiB used 9.09TiB path /dev/sdg1
> 
> Compare this with the second snapraid parity disk:
> pwm@europium:/mnt/snap_04$ sudo btrfs fi show /mnt/snap_05/
> Label: 'snap_05'  uuid: bac477e3-e78c-43ee-8402-6bdfff194567
>         Total devices 1 FS bytes used 4.69TiB
>         devid    1 size 9.09TiB used 4.70TiB path /dev/sdi1
> 
> So on one parity disk, devid is 9.09TiB used - on the other only 4.70TiB.
> While almost the same amount of file system usage. And almost
> identical usage pattern. It's an archival RAID, so there is hardly
> any writes to the parity files because there are almost no file
> changes to the data files. The main usage is that the parity file
> gets extended when one of the data disks reaches a new high water
> mark.
> 
> The only file that gets regularly rewritten is the snapraid.content
> file that gets regenerated after every scrub.
> 
> 
> 
> pwm@europium:/mnt/snap_04$ sudo btrfs fi df .
> Data, single: total=9.08TiB, used=4.59TiB
> System, DUP: total=8.00MiB, used=992.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=6.00GiB, used=4.81GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> 
> pwm@europium:/mnt/snap_04$ sudo btrfs filesystem du .
>      Total   Exclusive  Set shared  Filename
>    4.59TiB     4.59TiB           -  ./snapraid.parity
>  304.37MiB   304.37MiB           -  ./snapraid.content
>  270.00MiB   270.00MiB           -  ./snapraid.content.tmp
>    4.59TiB     4.59TiB       0.00B  .
> 
> 
> 
> pwm@europium:/mnt/snap_04$ sudo btrfs filesystem usage .
> Overall:
>     Device size:                   9.09TiB
>     Device allocated:              9.09TiB
>     Device unallocated:              0.00B
>     Device missing:                  0.00B
>     Used:                          4.60TiB
>     Free (estimated):              4.49TiB      (min: 4.49TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:9.08TiB, Used:4.59TiB
>    /dev/sdg1       9.08TiB
> 
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/sdg1       8.00MiB
> 
> Metadata,DUP: Size:6.00GiB, Used:4.81GiB
>    /dev/sdg1      12.00GiB
> 
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/sdg1       4.00MiB
> 
> System,DUP: Size:8.00MiB, Used:992.00KiB
>    /dev/sdg1      16.00MiB
> 
> Unallocated:
>    /dev/sdg1         0.00B
> 
> 
> 
> pwm@europium:~$ sudo btrfs check /dev/sdg1
> Checking filesystem on /dev/sdg1
> UUID: c46df8fa-03db-4b32-8beb-5521d9931a31
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 5057294639104 bytes used err is 0
> total csum bytes: 4529856120
> total tree bytes: 5170151424
> total fs tree bytes: 178700288
> total extent tree bytes: 209616896
> btree space waste bytes: 182357204
> file data blocks allocated: 5073330888704
>  referenced 5052040339456
> 
> 
> 
> pwm@europium:~$ sudo btrfs scrub status /mnt/snap_04/
> scrub status for c46df8fa-03db-4b32-8beb-5521d9931a31
>         scrub started at Mon Jul 31 21:26:50 2017 and finished after
> 06:53:47
>         total bytes scrubbed: 4.60TiB with 0 errors
> 
> 
> 
> So where have my 5TB disk space gone lost?
> And what should I do to be able to get it back again?
> 
> I could obviously reformat the partition and rebuild the parity
> since I still have one good parity, but that doesn't feel like a
> good route. It isn't impossible this might happen again.
> 
> /Per W

-- 
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons

--yKucn/VR3FthLjAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZgHIXAAoJEFheFHXiqx3kkYUP/3rX2xE377C5J4oEpJXxwz+K
tc0AkvP6tD8JlAer+1h8izpm8+Hr3tdVd2jCB0D4VgGfZMSv+W3otz2GkLH+ZDEP
CuT+MvMOEoJ0KG0iUDBX5CXdQXyzu1YhPztfKG7Bz3wM1FuexdYBt9wYU3BQMLAg
iC0UxkB/uvlvI1SIpOiSp9vM/Ku9jqIGRQenconInbGdBBZNWdZnJuYDDvkHsH3R
8TBIM99AVNiWdKQdAyIYS//Z3fXVRG+8pGHUH9xJxA03MxIKQLKq29VHC3Pje17Q
4c9swbwyl0CBLkhJgorUl0I6FHYHriJAYjeIvT4DT1bqWZOnEw+5D1Phg9Wyj8sH
Qi7GNjMBi7A3rX+YYGRWF3wlNcgZEN9XNzgDT6/T5VDoyeOy4kIILl9ceT2iXaVS
IVcNKP+VRCLX5L35aEeU9NZ9GrqkokmEbzdq2SoEfYQoWg8WAxwVo4p+305TI5tz
T8g6IZlgQ+y2b66Wmts9GhjyCmKP+D0xJrF9dKZWqVTP8gs9E4lLthMrWBFGXyZw
5R3J5uvFx4cqn+V4FzdVRsq4OuEY+CC3umgkp6p58nUTRA58vbsBbujCcU4YGCbX
Q74ZyRNxO4n880+Mryn2TSyk23YzDlnLB+QeXX2FW6SISZN9ukJ758Z+SkW8r0OF
JcdIEVp55zSESszKbQ9J
=Ik2h
-----END PGP SIGNATURE-----

--yKucn/VR3FthLjAA--
