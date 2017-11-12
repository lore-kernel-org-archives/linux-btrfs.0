Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58984 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbdKLAmb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Nov 2017 19:42:31 -0500
Date: Sun, 12 Nov 2017 00:42:30 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image hash collision option, super slow
Message-ID: <20171112004230.GJ27985@carfax.org.uk>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
In-Reply-To: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 11, 2017 at 05:18:33PM -0700, Chris Murphy wrote:
> OK this might be in the stupid questions category, but I'm not
> understanding the purpose of computing hash collisions with -ss. Or
> more correctly, why it's taking so much longer than -s.
> 
> It seems like what we'd want is every filename to have the same hash,
> but for the file to go through a PBKDF so the hashes we get aren't
> (easily) brute forced. So I totally understand that -ss should take
> much longer than -s, but this is at least two orders magnitude longer
> (so far). That's why I'm confused.
> 
> -s option on this file system took 5 minutes, start to finish.
> -ss option is at 8 hours and counting.
> 
> The other part I'm not groking is that some filenames fail with:
> 
> WARNING: cannot find a hash collision for 'Tool', generating garbage,
> it won't match indexes
> 
> So? That seems like an undesirable outcome. And if it were just being
> pushed through a PBKDF function, it wouldn't fail. Every
> file/directory "Tool" would get the same hash on *this* run of
> btrs-image. If I run it again, or someone else runs it, they'd get
> some other hash (same hashes for each instance of "Tool" on their
> filesystem).

   In the FS tree, you can go from the inode of the file to its name
(where the inode is in the index, and the name is stored in the
corresponding data item). Alternatively, you can go from the filename
to the inode. In the latter case, since the keys are a structured 17
byte object, you obviously can't fit the whole filename into the key,
so the filename is hashed (using, IIRC, CRC32), and it's the hash that
appears in the key of the index.

   When an image is made without the -s options, the whole metadata is
stored, including all the filenames in the data items. For some
people, that's a security risk, and they don't want their filenames
leaking out, so -s exists to put junk in the filename records.
However, it doesn't change the hashes in the index to correspond with
the modified filenames, because that would at minimum require the
whole tree to be rebuilt (because all the items would have different
hashes, and hence different ordering in the index). This is a bad
thing for debugging, because you're not getting the details of the
tree as it was in the broken filesystem. So, in this case, the image
is actually broken, because the filenames don't match the hashes.

   Most of the time, that's absolutely fine, because the thing being
debugged is somewhere else, and it doesn't matter that "ls" on the
restored FS won't work right.

   However, in some (possibly hypothetical) cases, it _does_ matter,
and you do need the hashes to match the filenames. This is where -ss
comes in. We can't generate random filenames and then take the hashes
of those, because of the undesirability of rewriting the whole FS tree
to reindex it with the changed hashes. So, what -ss tries to do is
stick with the original hashes and find arbitrary filenames which
match them. It's (I think) CRC32, so it shouldn't be too hard, but
it's still non-trivial amounts of work to reverse engineer a
human-readable ASCII filename which hashes to a given value.
Particularly if, as was the case when Josef wrote it, a simple
brute-force algorithm was used.

   It could definitely be improved -- I believe there are some good
(but non-trivial) algorithms for finding preimages for CRC32 checksums
out there. It's just that btrfs-image doesn't use them. However, it's
not an option that's needed very often, so it's probably not worth
putting in the effort to fix it up. (I definitely remember Josef
commenting on IRC when he wrote -s and -ss that it could almost
certainly be done more efficiently, but he had bigger fish to fry at
the time, like fixing the broken FS he was working on)

   As to the thing where it's not finding a pre-image at all -- I'm
guessing here, but it's possible that this is a case where two of the
orginal filenames hashed to the same value. If that happens, one of
the hashes is incremented by a small integer in a predictable way
before storage. So it may be that the resulting value isn't mappable
to an ASCII pre-image, or that the search just gives up before finding
one.

   Hugo.

-- 
Hugo Mills             | Yes, this is an example of something that becomes
hugo@... carfax.org.uk | less explosive as a one-to-one cocrystal with TNT.
http://carfax.org.uk/  | (Hexanitrohexaazaisowurtzitane)
PGP: E2AB1DE4          |                                            Derek Lowe

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaB5j1AAoJEFheFHXiqx3kkikP/2aPsSimfPDpz34XFj22rRyl
mssrlr5Lhfnt5SxYlnFC6SliihBi9dWFCAut6MoQWSNGJFuLEHLdnBT6LxgvPigI
1WJJ9eBnrXhOvl/r49Rw4ulwz8QTPKP+npPG9voDywi49v2n9XoAEcx+B/SjuuUF
yRuGNzVu5Jklu+0wLn2kJF3GnVWmYN5UNa41bwH7QMaYm8uRk0OJTj3cSJYY7C01
nX3rJDSToyE4Y8fHMjsIeweuKnu5Wk6PTgsJ7LILtAkp3J7E+bjdIPXP06C2hyz2
8U74FToa4gJvC8oa6bD2nVt19jngAmOu/tCYhOpiBZdGdl458EK75vKwyo8qM1wz
xCetXcAdw0CWdnyXUnlpr2UQrzR1+4Zrq25bVvq2kxSDEVXsqWkUf+sFKBdAQ4SW
++o4uRbShqx+5CJYRrihKVtnAZH4SglJwS/d+aAsg0xo2BSurH+QPA+HBIPZOPHk
QXTw97ITS1j6YmJAILLJj6RCQoXpjvPJ2A0/MHq5+s4oSKWiU6PPytqKCHKge2sj
ZfEQ+gcWljHT8oEywaXVI0jDpYJ5VvwFcNsuQZhOCWDrIawr1FS+LanJCnfE4xeP
Ri1rwf9aqNULgKyOi02CT2U5BPDUfDhF+ibUuTDh5Wfn8WYskKtmrTXEunpX26xv
3zzWa52lA2EOLG85XTZp
=4/1y
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
