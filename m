From: Phillip Susi <psusi@cfl.rr.com>
Subject: Snapshot rollback
Date: Sun, 23 Oct 2011 15:42:50 -0400
Message-ID: <4EA46E3A.9090307@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I created a snapshot of my root subvol, then used btrfs-subvolume
set-default to make the snapshot the default subvol and rebooted.  This
seems to have correctly gotten the system to boot from the snapshot
instead of the original subvol, but now /home ( @home subvol ) refuses
to mount claiming that /dev/sda1 is not a valid block device.  What gives?

Also, is there no way to move or hard link subvolumes to somewhere other
than their original location?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6kbjoACgkQJ4UciIs+XuJ9cgCgplNTWEmJjW+9fC87y9nO9yao
xcQAoLzsOCVgxsm4a28wKudvyX+7OCpB
=rL1g
-----END PGP SIGNATURE-----
