Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43951 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaI0RgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 13:36:23 -0400
Date: Sat, 27 Sep 2014 17:59:29 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: James Pharaoh <james@pharaoh.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS backup questions
Message-ID: <20140927165929.GC7191@carfax.org.uk>
References: <5426DA1B.9010503@pharaoh.uk>
 <20140927161741.GB7191@carfax.org.uk>
 <5426E6F6.5070701@pharaoh.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
In-Reply-To: <5426E6F6.5070701@pharaoh.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 06:33:58PM +0200, James Pharaoh wrote:
> On 27/09/14 18:17, Hugo Mills wrote:
> >On Sat, Sep 27, 2014 at 05:39:07PM +0200, James Pharaoh wrote:
> 
> >>2. Duplicating NOCOW files
> >>
> >>This is obviously possible, since it takes place when you make a snapshot.
> >>So why can't I create a clone of a snapshot of a NOCOW file? I am hoping the
> >>answer to this is that it is possible but not implemented yet...
> >
> >    Umm... you should be able to, I think.
> 
> Well I've tried with the haskell btrfs library, using clone, and also using
> cp --reflink=auto. Here's an example using cp:
> 
> root@host:/btrfs# btrfs subvolume snapshot -r src dest
> Create a readonly snapshot of 'src' in './dest'
> root@host:/btrfs# cp --reflink dest/test test
> cp: failed to clone 'test' from 'dest/test': Invalid argument

   Are you trying to cross a mount-point with that? It works for me:

hrm@amelia:/media/btrfs/amelia/test $ sudo btrfs sub create bar
Create subvolume './bar'
hrm@amelia:/media/btrfs/amelia/test $ sudo dd if=/dev/zero of=bar/data bs=1024 count=500
500+0 records in
500+0 records out
512000 bytes (512 kB) copied, 0.0047491 s, 108 MB/s
hrm@amelia:/media/btrfs/amelia/test $ sudo btrfs sub snap -r bar foo
Create a readonly snapshot of 'bar' in './foo'
hrm@amelia:/media/btrfs/amelia/test $ sudo cp --reflink=always bar/data bar-data
hrm@amelia:/media/btrfs/amelia/test $ sudo cp --reflink=always foo/data foo-data
hrm@amelia:/media/btrfs/amelia/test $ ls -l
total 1000
drwxr-xr-x 1 root root      8 Sep 27 17:55 bar
-rw-r--r-- 1 root root 512000 Sep 27 17:57 bar-data
drwxr-xr-x 1 root root      8 Sep 27 17:55 foo
-rw-r--r-- 1 root root 512000 Sep 27 17:57 foo-data

[snip]
> >>3. Peformance penalty of fragmentation on SSD systems with lots of memory
> >>
> >    There are two performance problems with fragmentation -- seek time
> >to find the fragments (which affects only rotational media), and the
> >amount of time taken to manage the fragments. As the number of
> >fragments increases, so does the number of extents that the FS has to
> >keep track of. Ultimately, with very fragmented files, this will have
> >an effect, as the metadata size will increase hugely.
> 
> Ok so this sounds like the answer I wanted to hear ;-) Presumably so long as
> the load is not too great, and I run the occasional defrag, then this
> shouldn't be much to worry about then?

   Be aware that the current implementation of (manual) defrag will
separate the shared extents, so you no longer get the deduplication
effect. There was a snapshot-aware defrag implementation, but it
caused filesystem corruption, and has been removed for now until a
working version can be written. I think Josef was working on this.

> >>4. Generations and tree structures
> >>
> >>I am planning to use lots more clever tricks which I think should be
> >>available in BTRFS, but I can't see much documentation. Can anyone point out
> >>any good examples or documentation of how to access the tree structures
> >>directly. I'm particularly interested in finding changed files and portions
> >>of files using the generations and the tree search.
> >
> >    You need the TREE SEARCH ioctl -- that gives you direct access to
> >all the internal trees of the FS. There's some documentation on the
> >wiki about how these fit together:
> >
> >https://btrfs.wiki.kernel.org/index.php/Data_Structures
> >https://btrfs.wiki.kernel.org/index.php/Trees
> >
> >    What "tricks" are you thinking of, exactly?
> 
> Principally I want to be able to detect exactly what has changed, so that I
> can perform backups very quickly. I want to be able to update a small
> portion of a large file and then identify exactly which parts changed and
> only back those up, for example.

   send/receive does this.

[snip]
> >    Are you aware of btrfs send/receive? It should allow you to do all
> >of this. The main part of the code then comes down to managing the
> >send/receive, and all the distributed error handling. Then the only
> >direct access to the internal metadata you need is being able to read
> >UUIDs to work out what you have on each side -- which can also be done
> >by "btrfs sub list".
> 
> Yes, this is one of my main inspirations. The problem is that I am pretty
> sure it won't handle deduplication of the data.

   It does. That's one of the things it's explicitly designed to do.

> I'm planning to have a LOT of containers running the same stuff, on fast
> (expensive) SSD media, and deduplication is essential to make that work
> properly. I can already see huge savings from this.
> 
> As far as I can tell, btrfs send/receive operates on a subvolume basis, and
> any shared data between those subvolumes is duplicated if you copy them
> separately.

   Not so.

   You can tell send that there are subvolumes with known IDs on the
receive side, using the -c option (arbitrarily many subvols). If the
subvol you are sending (on the send side) shares extents with any of
those, then the data is not sent -- just a reference to it. On the
receive side, if that happens, the shared extents are reconstructed.
It will also do this with the -p option.

> I'll be very happy if this is already possible, or if there is some simple
> way around this!
> 
> My current solution, which I have already implemented in the project I
> shared, is to first snapshot all the subvolumes into an identical tree, then
> to reflink copy (or normal(ish) copy for nocow) all of the files over to
> another subvolume, which I am planning to then send/receive as a single
> entity.
> 
> I believe this will allow the deduplication to be transferred over to the
> receiving machine, and that this won't take place if I transfer the
> subvolumes separately.

   You send each one in turn, and add the -c option for the ones
you've already sent:

for n in A B C D etc; do
   btrfs sub snap -r live/subvol$n backups/subvol$n.1
done
btrfs send backups/subvolA.1 | ...
btrfs send -c backups/subvolA.1 backups/subvolB.1 | ...
btrfs send -c backups/subvolA.1 -c backups/subvolB.1 backups/subvolC.1 | ...
btrfs send  -c backups/subvolA.1 -c backups/subvolB.1 -c backups/subvolC.1 backups/subvolD.1 | ...

   You can then use the same process to do incrementals against each
subvol, by keeping the last snapshot you sent and doing an incremental
against it:

for n in A B C D etc; do
   btrfs sub snap -r live/subvol$n backups/subvol$n.2
done
btrfs send -p backups/subvolA.1 backups/subvolA.2 | ...
btrfs send -c backups/subvolA.2 -p backups/subvolB.1 backups/subvolB.2 | ...
btrfs send -c backups/subvolA.2 -c backups/subvolB.2 -p backups/subvolC.1 backups/subvolC.2 | ...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- I am an opera lover from planet Zog. Take me to your lieder ---   

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVCbs8VheFHXiqx3kAQIkUhAAnBzX1s9x/Cn3f7daxCU9V1PLhOVHRnc4
SWsrKyphfq7Co3KEEj7BxHcag4+rWLcRAjomXSTaP8WQ6ugrruiOUBDJEXK3jV7g
FkJyJ+1Z+SqZDPJ0svX94G5BladVMezLJ9q4ttwcIC11v3u9MbT/kQrg2cD8gJ5/
Zgo7gMz/INHW5D7xuY3xwRJJopeh0yhKS4RDzIPSeVxZekUFE4aKotV6uMVGLlUq
Wcvk8K6qOarhBC3UKzOnWM5chd9buvG3FuIPL9j5lp3QRhFro1vlEE/cllLdTrHy
8EfO4RB+PRpMhmf76qzVZRZZIAom1n/MfLCaLAd4pc5sW1sTVgvZyQBpEAhrjRJd
sRQs1Hwj1lPi/qSDCIh+YfYwFpX84PcD/OffENHKqgT3g24sPJoWVlz7tVf1VULm
Cz6lLzoEX1dapj9VP7CRcGCz7i0KdKvYnDcMOc7/OpS8/MNM44uySxUgl4XRWV//
7jZb6Il2BWAPMF0QLGWuPV/6ecSlt9kyqw33lGyD0vYq9MecYipTqFY9hVyXNjih
YVGhP6Q02QnuMOrf2svf0fyUit4vMYgp7Q2JJY9Mg1hJJc1aW8a03vJVIMxmOtr6
O6XuZOI4NYDO675Tr/Y525SvJwsjA+CwYOChcLPd4jucsK82OHMy048fjqBuwvyj
lkHdw1Sr0XM=
=XnLC
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
