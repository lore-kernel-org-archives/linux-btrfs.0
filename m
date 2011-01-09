From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 9 Jan 2011 22:01:01 +0000
Message-ID: <20110109220101.GB29572@carfax.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com>
 <201101061342.23991.CACook@quantum-sci.com>
 <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
 <201101071720.08298.hka@qbs.com.pl>
 <4D29A033.7000803@chandlerfamily.org.uk>
 <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
 <4D29D508.6080006@chandlerfamily.org.uk>
 <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
 <20110109183030.GA29572@carfax.org.uk>
 <4D2A2128.2060508@chandlerfamily.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Cc: linux-btrfs@vger.kernel.org
To: Alan Chandler <alan@chandlerfamily.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2A2128.2060508@chandlerfamily.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 09, 2011 at 08:57:12PM +0000, Alan Chandler wrote:
> On 09/01/11 18:30, Hugo Mills wrote:
> >
> >    No, subvolumes are a part of the whole filesystem. In btrfs, there
> >is only one filesystem. There are 6 main B-trees that store metadata
> >in btrfs (plus a couple of others). One of those is the "filesystem
> >tree" (or FS tree), which contains all the metadata associated with
> >the normal POSIX directory/file namespace (basically all the inode and
> >xattr data). When you create a subvolume, a new FS tree is created,
> >but it shares *all* of the other btrfs B-trees.
> >
> >    There is only one filesystem, but there may be distinct namespaces
> >within that filesystem that can be mounted as if they were
> >filesystems. Think of it more like NFSv4, where there's one overall
> >namespace exported per server, but clients can mount subsections of
> >it.
>
> I think this explanation is still missing the key piece that has
> confused me despite trying very hard to understand it by reading the
> wiki.  You talk about "Distinct Namespaces", but what I learnt from
> further up the thread is that this "namespace" is also inside the
> the "namespace" that makes up the whole filesystem.  I mount the
> whole filesystem, and all my subvolumes are automatically there (at
> least that is what I find in practice).  Its this duality of
> namespace that is the difficult concept.  I am still not sure of
> there is a default subvolume, and the other subvolumes are defined
> within its namespace, or whether there is an overall filesystem
> namespace and subvolumes defined within it and if you mount the
> default subvolume you would then lose the overall filesystem
> namespace and hence no longer see the subvolumes.

   There is a root subvolume namespace (subvolid=0), which may contain
files, directories, and other subvolumes. This root subvolume is what
you see when you mount a newly-created btrfs filesystem.

   The default subvolume is simply what you get when you mount the
filesystem without a subvol or subvolid parameter to mount. Initially,
the default subvolume is set to be the root subvolume. If another
subvolume is set to be the default, then the root subvolume can only
be mounted with the subvolid=0 mount option.

>  I find the wiki
> also confusing because it talks about subvolumes having to be at the
> first level of the filesystem, but again further up this thread
> there is an example which is used for real of it not being at the
> first level, but at one level down inside a directory.

   Try it, see what happens, and fix the wiki where it's wrong? :)

   Or at least say what page this is on, and I can try the experiment
and fix it later...

> What it means is that I don't have a mental picture of how this all
> works, and all use cases could then be worked out by following this
> mental picture.  I think it would be helpful if the Wiki contained
> some of the use cases that we have been talking about in this thread
> - but with more detailed information - like the actual commands used
> to mount the filesystems like this, and information as to in what
> circumstances you would perform each action.

   I've written a chunk of text about how btrfs's storage, RAID and
subvolumes work. At the moment, though, the wiki is somewhat broken
and I can't actually create the page to put it on...

   There's also a page of recipes[1], which is probably the place that
the examples you mentioned should go.

> >    The main awkward piece of btrfs terminology is the use of "RAID" to
> >describe btrfs's replication strategies. It's not RAID, and thinking
> >of it in RAID terms is causing lots of confusion. Most of the other
> >things in btrfs are, I think, named relatively sanely.
> 
> I don't find this AS confusing, although there is still information
> missing which I asked in another post that wasn't answered.  I still
> can't understand if its possible to initialise a filesystem in
> degraded mode. If you create the filesystem so that -m RAID1 and -d
> RAID1 but only have one device - it implies that it writes two
> copies of both metadata and data to that one device.  However if you
> successfully create the filesystem on two devices and then fail one
> and mount it -o degraded it appears to suggest it will only write
> the one copy.

   From trying it a while ago, I don't think it is possible to create
a filesystem in degraded mode. Again, I'll try it again when I have
the time to do some experimentation and see what actually happens.

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/UseCases

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- A clear conscience.  Where did you get this taste ---        
                         for luxuries,  Bernard?                         

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNKjAdIKyzvlFcI40RApBuAJ0RWqMxpQ5F7KeXbroBG0q19TU1GACfbjj3
2QDzExIf9iAMUEDqiwmhlDg=
=QUN6
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
