From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH] btrfs: fix btrfs_read_block_groups return value
Date: Thu, 12 Feb 2009 09:54:29 -0500
Message-ID: <49943825.7080507@suse.com>
References: <4993808C.20000@suse.com> <1234450175.8300.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234450175.8300.1.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Mason wrote:
> On Wed, 2009-02-11 at 20:51 -0500, Jeff Mahoney wrote:
>> btrfs_read_block_groups returns an ambiguous value. Whether it finds
>>  a block group or not, it will return -ENOENT. find_first_block_group
>>  will eventually return -ENOENT when it reaches past the last block
>>  group, and that is what is returned to the caller.
> 
> Jeff, thanks for starting on all of this.  Could I talk you into setting
> up a git tree?  I think you're going to have a long stream of patches
> and merging them with my trees is going to be much easier over git.

Sure. I'm operating on a clone of your tree right now anyway. It
shouldn't be difficult to find a way to publish it.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkmUOCUACgkQLPWxlyuTD7JqjwCfRCF2+Bwv/BUJoFW85qFizxSS
KtAAnRpvLy5i4qpWduGwpv8lBlgF7xKn
=4ZAW
-----END PGP SIGNATURE-----
