Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39197 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaADRt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jan 2014 12:49:26 -0500
Date: Sat, 4 Jan 2014 17:49:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Subject: 32/64-bit structure alignment problem in receive
Message-ID: <20140104174923.GL8913@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7vAdt9JsdkkzRPKN"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7vAdt9JsdkkzRPKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Sending the exact same send stream to two different machines, on
one of them I am getting:

ERROR: BTRFS_IOC_SET_RECEIVED_SUBVOL failed. Inappropriate ioctl for device

   The other machine is fine. Investigating, I find that the working
machine is 64-bit userspace and kernel. The failing machine is 32-bit
userspace and 64-bit kernel.

struct btrfs_ioctl_received_subvol_args {
        char    uuid[BTRFS_UUID_SIZE];  /* in */
        __u64   stransid;               /* in */
        __u64   rtransid;               /* out */
        struct btrfs_ioctl_timespec stime; /* in */
        struct btrfs_ioctl_timespec rtime; /* out */
        __u64   flags;                  /* in */
        __u64   reserved[16];           /* in */
};

struct btrfs_ioctl_timespec {
        __u64 sec;
        __u32 nsec;
};

   This latter struct is 16 bytes in a 64-bit environment (with 4
bytes wasted) and 12 bytes in a 32-bit environment. This means that on
my broken machine, the kernel is expecting ioctl(5, 0xc0c89425, ...)
and is being called with ioctl(5, 0xc0c09425, ...).

   As far as I can see, the best (only?) solution is to teach the
kernel to accept both

_IOWR(BTRFS_IOCTL_MAGIC, 37, struct btrfs_ioctl_received_subvol_args)

and

_IOWR(BTRFS_IOCTL_MAGIC, 37, struct btrfs_ioctl_received_subvol_args_32)

if it's compiled on a 64-bit architecture, where the _32 version of
the struct is otherwise identical to the struct(s) above, but declared
as __packed__.

   Patch to follow.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- "Big data" doesn't just mean increasing the font size ---      

--7vAdt9JsdkkzRPKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUshJo1heFHXiqx3kAQL3uxAAqFksTjdhc7PwcMxBnaCmO7oCy6Pt1DEa
HYMpP27gmaoWFgcKVBug26EKuUWqJ6cTEbG5h5H5u06NSza+kSVTcuY+ahF4djJ5
ps1WTGp//hl02jBpLZPp9D6fgNgkQ9Zl/sEPueTB1DrrF+nXRwTy2aiGde7XBjYT
yJ0lBAF7NMzbkSWtzlBul/iP/YNAnf6hcEUYobcfrpu4ZLMqucx5be4aYssurtxQ
gtFHrZ2mcQ3L0zqvENHeb6+QCuRQ15FuZ3YrVBB7jWzpEf36ZO18/xMn93HiVf/Y
+FNj0JYupy9hQ61wIGX4dMp5L8EcGtEAilCNyNrTsvCC7GBw6GQXV1mTSshPNuOZ
MBZkiC2N+iNEJwjeMVvK6T7VT2qV3IWS7qSzrDhvW+2YrgszKkH7Q4OeBHyvXO8d
Lre4othC/R7wIxjE4mCCuUO+D7qbh9VtQ/9f6Q5psZp2Rry8EMmN3qASHW9ZhU5N
wAU4oLfH3Yb9993JK+3/Sk7yC3TQb0v9iTa0Poq+oQQtYUqQcWOmFUPT+lB23yS6
YSKfR6zl+ojqAaiS6Ai9tvywsZo1M1tfKTLtaoFCSyuWaHO3+S/7MXmqeaSGbG7/
1kiTjqQs91ehoa0HQx1WzSgjiWvJfKwCiZlrPNTUYBOySkcOwFWN+IznMZ/ZSFK8
8DcnCHZDmcI=
=ZrhP
-----END PGP SIGNATURE-----

--7vAdt9JsdkkzRPKN--
