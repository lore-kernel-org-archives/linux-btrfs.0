From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Snapshot rollback
Date: Mon, 24 Oct 2011 20:45:04 -0400
Message-ID: <4EA60690.7080401@cfl.rr.com>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111024T071806-3@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/24/2011 01:45 AM, dima wrote:
> Hello Phillip,
> It is hard to judge without seeing your fstab and bootloader config. Maybe your
> / was directly in subvolid=0 without creating a separate subvolume for it (like
> __active in Goffredo's reply)? In my very humble opinion, if you have your @home
> subvolume under subvolid=0 and then change the default subvolume, it just cannot
> access your @home any more.

Why can't it?

It appears that Ubuntu sets up two subvols, one named @ and one named
@home, and mounts them at / and /home respectively.  The boot loader was
set to pass rootflags=subvol=@.  After changing the default volume, the
system would not boot until I removed that rootflags argument, then it
mounted the snapshot correctly as the root, but refused to mount /home,
giving this nonsense error that /dev/sda1 is not a valid block device.

> Here is a very good article that explains the working of subvolumes. I used it
> as reference a lot.
> http://www.funtoo.org/wiki/BTRFS_Fun#Using_snapshots_for_system_recovery_.28aka_Back_to_the_Future.29

This advice seems completely goofy.  It tells you to change the default
subvol and boot from the snapshot, but then to have rsync copy all of
the files back to the default volume, then switch back to using that.
This seems to defeat the entire purpose.  If you are already booting
from the snapshot, why would you want to waste time copying the files
back to the original subvol instead of just deleting it, and using the
snapshot volume from now on?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6mBo4ACgkQJ4UciIs+XuK+wgCeOD0km3GpdseQ0h4y0FKSI7JS
xC0An2JqA4aOHCkZ7+g+TORunVnpmQj7
=6KKf
-----END PGP SIGNATURE-----
