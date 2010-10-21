From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: csum errors, and resizing...
Date: Thu, 21 Oct 2010 19:55:49 +0100
Message-ID: <20101021185549.GA6679@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Just encountered an interesting issue.

   Rapid summary: when a resize encounters a file with broken
checksums, it stops, and will not (apparently) proceed any further.
Un/remount seems to clear the error condition.

   I've got a filesystem with some (lots of) checksum errors on it.
It lives on a single partition. In trying to move all the data off
this, onto a btrfs raid10 filesystem, I've been moving data, and
shrinking the filesystem. The shrink process has now hit some of those
csum errors:

hrm@vlad:~ $ sudo btrfs fi show -h
failed to read /dev/sr0
Label: none  uuid: fad2f415-979d-405e-9aa2-0c1011389273
        Total devices 1 FS bytes used 660.75GiB
        devid    1 size 675.40GiB used 1019.00GiB path /dev/dm-14
[...]

hrm@vlad:~ $ sudo strace btrfs fi resize 708209608k /media/vlad/video
[...]
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fcd26974000
write(1, "Resize '/media/vlad/video' of '70"..., 43Resize '/media/vlad/video' of '708209608k'
) = 43
ioctl(3, 0x50009403, 0x7fffe9a8d140)    = -1 EIO (Input/output error)
close(3)                                = 0
write(2, "ERROR: unable to resize '/media/v"..., 44ERROR: unable to resize '/media/vlad/video'
) = 44
exit_group(30)                          = ?

   In syslog, I get a bunch of csum errors:

Oct 21 19:40:01 vlad kernel: new size for /dev/mapper/media-video is 725206638592
Oct 21 19:40:03 vlad kernel: btrfs: relocating block group 1090913304576 flags 1
Oct 21 19:40:05 vlad kernel: btrfs_readpage_end_io_hook: 4088 callbacks suppressed
Oct 21 19:40:05 vlad kernel: btrfs csum failed ino 257 off 131072 csum 752820288 private 2880127001
Oct 21 19:40:05 vlad kernel: btrfs csum failed ino 257 off 135168 csum 2112861244 private 3414608960
[and more]

   This is, I suppose, expected.

   However, it seems to put the filesystem into a state where a resize
cannot be attempted again:

hrm@vlad:~ $ sudo strace btrfs fi resize 708209608k /media/vlad/video
[...]
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f559f8af000
write(1, "Resize '/media/vlad/video' of '70"..., 43Resize '/media/vlad/video' of '708209608k'
) = 43
ioctl(3, 0x50009403, 0x7fff8dfda770)    = -1 EINVAL (Invalid argument)
close(3)                                = 0
write(2, "ERROR: unable to resize '/media/v"..., 44ERROR: unable to resize '/media/vlad/video'
) = 44
exit_group(30)                          = ?

   Unmounting and remounting it resets the resize state, and I end up
back in the first state again. Is this toggling of state intended?

   I'm on the git unstable kernel. Should I go up to 2.6.36 and try
again? The other thing I can think of to do is to delete some of the
files with bad checksums (I have backups) and see if I can get any
further with the resize.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- We teach people management skills by examining characters in ---   
            Shakespeare.  You could look at Claudius's crisis            
                   management techniques, for example.                   

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFMwIy1IKyzvlFcI40RAt17AKDOuMfkRlPHRrf1iyPreo6fRoL29ACgruS8
eJG7JGxHoj2h0XsYgE0XFIc=
=lOjG
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
