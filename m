From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 13/99] btrfs: clear_extent_uptodate can drop gfp_t argumetn
Date: Thu, 24 Nov 2011 21:14:32 -0500
Message-ID: <4ECEFA08.9080800@suse.com>
References: <20111124003533.395674389@suse.com> <20111124004221.324209031@suse.com> <20111124235712.GH12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124235712.GH12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2011 06:57 PM, David Sterba wrote:
> Subject: Re: [patch 13/99] btrfs: clear_extent_uptodate can drop
> gfp_t argumetn
> 
> typo in subject s/argumetn/argument/, same in the next 2 patches
> 

Thanks. Fixed.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzvoIAAoJEB57S2MheeWyQAUP/1bGJ04fHNzRGtscLj88YAHx
95AaqQUlf78kXT9nhX3VJIHF/SrQDbZ3wuHa4kXRTrvRivsRbRF+5S5UgANygtaG
rCt+RgP5ZcK2W69gVJWMjcfWGSTn+o6GztDdTHueVzJz2ACemKZmrcrnOBp3Lbco
FbhrB8KwzN+TLWF3uoZKtnrOgItVicischl8yJjik1rMhxGApPoFvEfmRXrHeyWA
jo5zaLyE08VXw0BNT5SXxknVzgf5vjHAERVf+iiHj3kAFEM/A2iV10B/JtxKaE1r
qEY+GZdKJ1ur8CsQggqYE/0adfzHdkIXFO22KyO2XhRtpmfh387azEhc3tA8JptR
tCjp90od4ZnWHb+te2BcKgluNoZ1scxoB7R8mHCYSpjCBKeVtSGq1TevfC0l+GHp
7X5uO8PX8DbEiqboLdmqxhJjxdNX2jtH+9o2hgoUEPDfteDcwZ8oA2px7yT6wQXl
TaiYmYxZCL2S656l6ylAwSxcZqPO910BbqsHGNntsKAZ0mJ1fRqj5Zzzlyl4fgqx
TnOyG8YKP5GmQlA50naBY2V5Om3Ge3rEXxUbjPU9hhaJZPL4DnWvwgJ6PNKcZST+
lOkelnz+5mZX2dj1OhjQQQCKpXufk/I+TGKQ84VGn2oUtHePfIxr3Y6+BBOIl8BQ
o1Ysr+N5VpMhY7GejIbT
=Q/Yt
-----END PGP SIGNATURE-----
