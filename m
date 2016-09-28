Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38296 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932652AbcI1QTC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Sep 2016 12:19:02 -0400
Date: Wed, 28 Sep 2016 12:18:41 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Mason <clm@fb.com>
Cc: Paul Jones <paul@pauljones.id.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH][RFC] btrfs rare silent data corruption with kernel data
 leak (updated, preliminary patch)
Message-ID: <20160928161841.GS21290@hungrycats.org>
References: <20160921045556.GN21290@hungrycats.org>
 <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
 <c47741e6-76d4-0900-e126-2be4862233db@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NAmHCRPXNp23hR9r"
In-Reply-To: <c47741e6-76d4-0900-e126-2be4862233db@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NAmHCRPXNp23hR9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2016 at 04:42:06PM -0400, Chris Mason wrote:
> On 09/21/2016 07:14 AM, Paul Jones wrote:
> >>-----Original Message-----
> >>From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> >>owner@vger.kernel.org] On Behalf Of Zygo Blaxell
> >>Sent: Wednesday, 21 September 2016 2:56 PM
> >>To: linux-btrfs@vger.kernel.org
> >>Subject: btrfs rare silent data corruption with kernel data leak
> >>
> >>Summary:
> >>
> >>There seem to be two btrfs bugs here: one loses data on writes, and the
> >>other leaks data from the kernel to replace it on reads.  It all happen=
s after
> >>checksums are verified, so the corruption is entirely silent--no EIO er=
rors,
> >>kernel messages, or device event statistics.
> >>
> >>Compressed extents are corrupted with kernel data leak.  Uncompressed
> >>extents may not be corrupted, or may be corrupted by deterministically
> >>replacing data bytes with zero, or may not be corrupted.  No preconditi=
ons
> >>for corruption are known.  Less than one file per hundred thousand seem=
s to
> >>be affected.  Only specific parts of any file can be affected.
> >>Kernels v4.0..v4.5.7 tested, all have the issue.
>=20
> Zygo, could you please bounce me your original email?  Somehow exchange a=
te
> it.
>=20
> If you're seeing this databases that use fsync, it could be related to the
> fsync fix I put into the last RC.  On my boxes it caused crashes, but mem=
ory
> corruptions aren't impossible.

The corruption pattern doesn't look like generic memory corruption.  Data in
the inline extents is never wrong.  Only the data after the end of the inli=
ne
extent, and the correct data in those file offsets is always zero.

> Any chance you can do a controlled experiment to rule out compression?

I get uncompressed inline extents, but so far I haven't found any of those
that read corrupted data.

I've tested 4.7.5 and it has the same corruption problem (among some others
that make it hard to use for testing).

The trigger seems to be the '-S' option to rsync, which causes a lot of
short writes with seeks between.  When there is a seek from within the
first 4096 bytes to outside of the first 4096 bytes, an inline extent
_can_ occur--but does not most of the time.

Normally, the inline extent disappears in this sequence of operations:

	# head -c 4000 /usr/share/doc/ssh/copyright > f
	# filefrag -v f
	Filesystem type is: 9123683e
	File size of f is 4000 (1 block of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..    4095:          0..      4095:   4096:             last=
,not_aligned,inline,eof
	f: 1 extent found
	# head -c 4000 /usr/share/doc/ssh/copyright | dd conv=3Dnotrunc seek=3D1 b=
s=3D4k of=3Df
	0+1 records in
	0+1 records out
	4000 bytes (4.0 kB) copied, 0.00770182 s, 519 kB/s
	# filefrag -v f
	Filesystem type is: 9123683e
	File size of f is 8096 (2 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..    4095:          0..      4095:   4096:             not_=
aligned,inline
	   1:        1..       1:          0..         0:      1:          1: last=
,unknown_loc,delalloc,eof
	f: 2 extents found
	# sync
	# filefrag -v f
	Filesystem type is: 9123683e
	File size of f is 8096 (2 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..       1:    1368948..   1368949:      2:             last=
,encoded,eof
	f: 1 extent found
	# head -c 4000 /usr/share/doc/ssh/copyright > f

but very rarely (p =3D 0.00001), the inline extent doesn't go away,
and we get an inline extent followed by more extents (see filefrag
example below).

The inline extents appear with and without compression; however, I
have not been able to find cases where corruption occurs without
compression so far.

Probing a little deeper shows that the inline extent is always shorter
than 4096 bytes, and corruption always happens in the gap between the
end of the inline extent data and the 4096th byte in the following page.

It looks like the data is OK on disk.  It is just some part of the read
path for compressed extents that injects uninitialized data on read.
Since kernel memory is often filled with zeros, the data is read correctly
much of the time by sheer chance.  Existing data could be read correctly
with a kernel patch.

This reproducer will create corrupted extents in a kvm instance (4GB
memory, 16GB of btrfs filesystem, kernel 4.5.7) in under an hour:

	# mkdir /tmp/eee
	# cd /tmp/eee
	# y=3D/usr; for x in $(seq 0 9); do rsync -avxHSPW "$y/." "$x"; y=3D"$x"; =
done &
	# mkdir /tmp/fff
	# cd /tmp/fff
	# y=3D/usr; for x in $(seq 0 9); do rsync -avxHSPW "$y/." "$x"; y=3D"$x"; =
done &

This is how to find the inline extents where the corruption can occur:

	# find /tmp/eee /tmp/fff -type f -size +4097c -exec sh -c 'for x; do if fi=
lefrag -v "$x" | sed -n "4p" | grep -q "inline"; then ls -l "$x"; filefrag =
-v "$x"; fi; done' -- {} +
	-rw-r--r-- 1 root root 86040 Nov 11  2014 /tmp/eee/3/share/locale/eo/LC_ME=
SSAGES/glib20.mo
	Filesystem type is: 9123683e
	File size of /tmp/eee/3/share/locale/eo/LC_MESSAGES/glib20.mo is 86040 (22=
 blocks of 4096 bytes)
	 ext:     logical_offset:        physical_offset: length:   expected: flag=
s:
	   0:        0..    4095:          0..      4095:   4096:             enco=
ded,not_aligned,inline
	   1:        1..      21:    2819748..   2819768:     21:          1: last=
,encoded,eof
	/tmp/eee/3/share/locale/eo/LC_MESSAGES/glib20.mo: 2 extents found

These are the mount options I used:

	# head -1 /proc/mounts
	/dev/vda / btrfs rw,noatime,max_inline=3D4095,compress-force=3Dzlib,flusho=
ncommit,space_cache,subvolid=3D5,subvol=3D/ 0 0

Adding 'compress' and 'compress-force' causes corruption on reads.
'max_inline=3D4095' made more files with inline extents so I could test
faster.  'flushoncommit' might have an effect on reproduction rate,
but I tested with and without, and didn't notice a substantial difference.

I was thinking the problem might be in uncompress_inline, and could be
fixed like this:

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a39eaa8..512b713 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6762,7 +6762,16 @@ static noinline int uncompress_inline(struct btrfs_p=
ath *path,
=20
        read_extent_buffer(leaf, tmp, ptr, inline_size);
=20
-       max_size =3D min_t(unsigned long, PAGE_CACHE_SIZE, max_size);
+       /*
+        * We can't have max_size > PAGE_CACHE_SIZE because we only
+        * allocated one page.  We can't have max_size < PAGE_CACHE_SIZE
+        * because we might extend the file past the end of the page,
+        * so we need to memset the end of the buffer to zero.  Since
+        * max_size can't be anything other than PAGE_CACHE_SIZE,
+        * just set it to that value.
+        */
+       WARN_ON(max_size > PAGE_CACHE_SIZE);
+       max_size =3D PAGE_CACHE_SIZE;
        ret =3D btrfs_decompress(compress_type, tmp, page,
                               extent_offset, inline_size, max_size);
        kfree(tmp);

Unfortunately I just tested that code, and while it seems to make the
data _less_ nondeterministic, it doesn't fix the problem:

	# history -a; (while :; do sysctl vm.drop_caches=3D1; cmp -l {/tmp/eee/3,/=
usr}/share/locale/eo/LC_MESSAGES/glib20.mo; done)
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1
	 4094   1   0
	vm.drop_caches =3D 1
	 4096   1   0
	vm.drop_caches =3D 1
	 4094   1   0
	vm.drop_caches =3D 1
	 4094   1   0
	vm.drop_caches =3D 1
	 4094 105   0
	 4095 124   0
	 4096 137   0
	vm.drop_caches =3D 1
	 4094   1   0
	vm.drop_caches =3D 1
	 4096 154   0
	vm.drop_caches =3D 1
	 4094  40   0
	 4095  40   0
	 4096  40   0
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1
	 4094   1   0
	vm.drop_caches =3D 1
	 4096 154   0
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1
	 4094  46   0
	 4095  17   0
	 4096 100   0
	vm.drop_caches =3D 1
	 4096 325   0
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1
	vm.drop_caches =3D 1

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NAmHCRPXNp23hR9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfr7WEACgkQgfmLGlazG5xvsQCg3cu9+/h+P5jYxFZKt4E2ua6Q
hioAoLGzZA24ndbNgo8a0fq917kGdjLF
=cLC8
-----END PGP SIGNATURE-----

--NAmHCRPXNp23hR9r--
