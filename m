From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Btrfs TODO
Date: Thu, 09 Apr 2009 14:30:40 -0400
Message-ID: <49DE3ED0.4070206@suse.com>
References: <20090409162418.GC20769@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090409162418.GC20769@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Josef Bacik wrote:
> Hello,
>
> Trying to put together a list of TODO items for btrfs so we can update
the wiki
> page fully.  So far these things are on the list
>
> * Proper ENOSPC handling
> * O_DIRECT support (without checksumming)
> * AIO support
> * Subvolume quotas and inherited space usage information
> * Snapshot removal
> * QA Suite for automated regression testing
> * Reserved space for online fsck and the ability to add storage so that a
> * background extent allocation check can proceed
> * Additional ioctls to set per-inode attributes (nodatacow, nodatasum,
etc)
>
> So I think all of those are still true.  Things that I know are being
worked on
> are
>
> * async block group cacheing - me
> * locking changes - Chris
> * backref stuff - Yan
>
> Som other things off the top of my head are
>
> * a better way to cache block groups in general, for this I was
thinking of a
> 	bitmap or something like that per block group of free space
> * space balancing.  this will likely need to wait on proper ENOSPC
handling
> * grub support :)

I'm doing some work in the area of more robust error handling. My patch
set is a little stale now but I'm going to spend some time this week
bringing it back to life.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEUEARECAAYFAknePtAACgkQLPWxlyuTD7LNmQCeOU4VxDmHIaI/lzgMHqCho7Vi
uasAl1Iggk87F9YEj1g1KDir5boWsYI=
=H7Yx
-----END PGP SIGNATURE-----
