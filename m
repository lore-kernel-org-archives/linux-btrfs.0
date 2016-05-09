Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39876 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbcEIQ3p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 12:29:45 -0400
Date: Mon, 9 May 2016 12:29:41 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org, Clemens Eisserer <linuxhippy@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
Message-ID: <20160509162940.GC15597@hungrycats.org>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
 <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
 <2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
 <CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
 <f1dd07efb34a0a110f62566979530944@linuxsystems.it>
 <799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
 <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
In-Reply-To: <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 09, 2016 at 04:53:13PM +0200, Niccol=F2 Belli wrote:
> While trying to find a common denominator for my issue I did lots of back=
ups
> of /dev/mapper/cryptroot and I restored them into /dev/mapper/cryptroot
> dozens of times (triggering a 150GB+ random data write every time), witho=
ut
> any issue (after restoring the backup I alwyas check the parition with bt=
rfs
> check). So disk doesn't seem to be the culprit.

Did you also check the data matches the backup?  btrfs check will only
look at the metadata, which is 0.1% of what you've copied.  From what
you've written, there should be a lot of errors in the data too.  If you
have incorrect data but btrfs scrub finds no incorrect checksums, then
your storage layer is probably fine and we have to look at CPU, host RAM,
and software as possible culprits.

The logs you've posted so far indicate that bad metadata (e.g. negative
item lengths, nonsense transids in metadata references but sane transids
in the referred pages) is getting into otherwise valid and well-formed
btrfs metadata pages.  Since these pages are protected by checksums,
the corruption can't be originating in the storage layer--if it was, the
pages should be rejected as they are read from disk, before btrfs even
looks at them, and the insane transid should be the "found" one not the
"expected" one.  That suggests there is either RAM corruption happening
_after_ the data is read from disk (i.e. while the pages are cached in
RAM), or a severe software bug in the kernel you're running.

Try different kernel versions (e.g. 4.4.9 or 4.1.23) in case whoever
maintains your kernel had a bad day and merged a patch they should
not have.

Try a minimal configuration with as few drivers as possible loaded,
especially GPU drivers and anything from the staging subdirectory--when
these drivers have bugs, they ruin everything.

Try memtest86+ which has a few more/different tests than memtest86.
I have encountered RAM modules that pass memtest86 but fail memtest86+
and vice versa.

Try memtester, a memory tester that runs as a Linux process, so it can
detect corruption caused when device drivers spray data randomly into RAM,
or when the CPU thermal controls are influenced by Linux (an overheating
CPU-to-RAM bridge can really ruin your day, and some of the dumber laptop
designs rely on the OS for thermal management).

Try running more than one memory testing process, in case there is a bug
in your hardware that affects interactions between multiple cores (memtest
is single-threaded).  You can run memtest86 inside a kvm (e.g. kvm
-m 3072 -kernel /boot/memtest86.bin) to detect these kinds of issues.

Kernel compiles are a bad way to test RAM.  I've successfully built
kernels on hosts with known RAM failures.  The kernels don't always work
properly, but it's quite rare to see a build fail outright.

> [...]I have the feeling that "autodefrag" enhances the
> chances to get corruption, but I'm not 100% sure about it. Anyway,
> triggering a whole packages reinstall with "pacaur -S $(pacman -Qe)", giv=
ing
> high chances to get irrecoverable corruption. When running such command it
> simply extracts the tarballs from the cache and overwrites the already
> installed files. It doesn't write lots of data (after reinstallation my
> system is still quite small, just a few GBs) but it seems to be enough to
> displease the filesystem.

pacman probably does a lot of fsync() which will do a lot of metadata
tree updates.  autodefrag triples the I/O load for fragmented files and
most of that extra load is metadata tree writes.  Both will make the
symptoms of your problem worse.


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlcwuvQACgkQgfmLGlazG5zjcgCgqMooCOQQMBDscGJbUEscKcVx
irYAoJ3tNA6nX57eXYxN9M07Pr794dmd
=gBoF
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
