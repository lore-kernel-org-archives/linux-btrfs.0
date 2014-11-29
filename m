Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52172 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaK2O2P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 09:28:15 -0500
Date: Sat, 29 Nov 2014 14:28:13 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving contents from one subvol to another
Message-ID: <20141129142813.GD32735@carfax.org.uk>
References: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="89VDYHnQ8ukgENkm"
In-Reply-To: <CAH-HCWUR4QPDn=M8nchdRedzGU3DYDHC8d6YRH8-FBm6trWCJg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--89VDYHnQ8ukgENkm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 29, 2014 at 07:51:07PM +0530, Shriramana Sharma wrote:
> Hello. I am now taking the first steps to making my backup external
> HDD in BtrFS. From
> http://askubuntu.com/questions/119014/btrfs-subvolumes-vs-folders I
> understand that the only difference between subvolumes and ordinary
> folders is that the former can be snapshotted and independently
> mounted.
> 
> But I have a question. I have two subvols test1, test2.
> 
> $ cd test1
> $ dd if=/dev/urandom of=file bs=1M count=500
> 500+0 records in
> 500+0 records out
> 524288000 bytes (524 MB) copied, 36.2291 s, 14.5 MB/s
> $ time mv file ../test2/
> real    0m2.061s
> user    0m0.013s
> sys     0m0.459s
> $ time { cp --reflink ../test2/file . && rm ../test2/file ; }
> real    0m0.677s
> user    0m0.022s
> sys     0m0.086s
> $ mkdir foo
> $ time mv file foo/
> real    0m0.096s
> user    0m0.008s
> sys     0m0.013s
> 
> It seems that mv is not CoW aware and hence is not able to create
> reflinks so it is actually processing the entire file because it
> thinks test2 is a different device/filesystem/partition or such. Is
> this understanding correct?

   The latest version of mv should be able to use CoW copies to make
it more efficient. It has a --reflink option, the same as cp. Note
that you can't make reflinks crossing a mount boundary, but you can do
so crossing a subvolume boundary (as you're doing here).

> So doing cp --reflink with rm is much faster. But it is still slower
> than doing mv within the same subvol. Is it because of the
> housekeeping with updating the metadata of the two subvols?

   I should think so, yes.

> Methinks --reflink option should be added to mv for the above usecase.
> Do people think this is useful? Why or why not?

   See above: it already has been. :)

> My concern is that if somebody wants to consolidate two subvols into
> one, though really only the metadata needs to be processed using
> ordinary mv isn't aware of this and using cp --reflink with rm is
> unnecessarily complicated, especially if it will involve multiple
> files.
> 
> And it's not clear to me what it would entail to cp --reflink + rm an
> entire directory tree because IIUC I'd have to handle each file
> separately. Perhaps something (unnecessarily convoluted) like:
> 
> find . | while read f
> do
> [ -d "$f" ] && mkdir target/"$f" && touch target/"$f" -r "$f"
> [ -f "$f" ] && cp -a --reflink "$f" target/ && rm "$f"
> done
> 
> Again, what would happen to files which are not regular directories or files?

   Probably just the same thing that would happen without the
--reflink=always.

> And why isn't --reflink given a single letter alias for cp?

   I don't know about that; you'll have to ask the coreutils
developers. They're probably expecting it to be largely set to a
single value by default (e.g. through a shall alias).

   Hugo.

-- 
Hugo Mills             | "I will not be pushed, filed, stamped, indexed,
hugo@... carfax.org.uk | briefed, debriefed or numbered.
http://carfax.org.uk/  | My life is my own."
PGP: 65E74AC0          |                                Number 6, The Prisoner

--89VDYHnQ8ukgENkm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUedf9AAoJEFheFHXiqx3kqooQAJ2foOTN8HSS+LQ1Pu4VN5z3
ifyREfiqQMJ1s2/gAYKbhked3+fnUzSHpGoR281pZBaqJliOKog0aMxOgZdupu0c
vBv8nEjEU1TFGYgy8z12182bFHA3DWcZthojkZHXtDbH6AfAQ6ew5cOj8INnOUdE
uP2jq4rTWTrunmGQYliHalK7bpyk+0N3EZqw65Ge9rC1qLR+hT0MXAPHfPv5JnJK
u+oLPGMkCJ7QERd6tm5ElpaxfliI/iwRNUn5uE3MSXN9tKmqX8MyxlbEICPugosM
wt7u7zwiG9WejrDHVPQxNlyK9si3hLI9giWUPOaGTHhgTDt5VgWPkqBcWrNQkJOy
mH2HAeJ7D6XZSXVW0sVjK1eXbVodw/yfQGlgWP6Y1jRDajQZJrmw2xrTnlx2l2n0
n6SzeYg02Kg4RMiUYxyHN+wQ7iL5FtU1WQ/I0aJcd9FNL8vIIWhE9FGbeBdNBkEa
NOe6OCTggVABJv/UrYjsmkDWcytlpjRCYrAQNruv/XcGgbizXil4MgcnecBRP09M
lT8AUCcXr458EIIM11gJRw1Ay3dtd+Ov0Es961VZePDfWTF6jIdL3elcyPKgNUWo
pVUuepFt+0A+i2HxbCIA8Vaa1/xc7PF4GB7ssIFD6d2Iogv9oCRzoZ2iXEXO3tOn
iy+gRG8ffzS6gazAKRcN
=R6H2
-----END PGP SIGNATURE-----

--89VDYHnQ8ukgENkm--
