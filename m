From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 11:55:52 +0100
Message-ID: <20120507105552.GC8938@carfax.org.uk>
References: <1913174825.1910.1336382310577.JavaMail.root@zimbra.interconnessioni.it>
 <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 07, 2012 at 11:28:13AM +0200, Alessio Focardi wrote:
> Hi,
> 
> I need some help in designing a storage structure for 1 billion of small files (<512 Bytes), and I was wondering how btrfs will fit in this scenario. Keep in mind that I never worked with btrfs - I just read some documentation and browsed this mailing list - so forgive me if my questions are silly! :X
> 
> 
> On with the main questions, then:

> - What's the advice to maximize disk capacity using such small
>   files, even sacrificing some speed?

   See my comments below about inlining files.

> - Would you store all the files "flat", or would you build a
>   hierarchical tree of directories to speed up file lookups?
>   (basically duplicating the filesystem Btree indexes)

   Hierarchically, for the reasons Hubert and Boyd gave. (And it's not
duplicating the btree indexes -- the tree of the btree does not
reflect the tree of the directory hierarchy).

> I tried to answer those questions, and here is what I found:
>
> it seems that the smallest block size is 4K. So, in this scenario,
> if every file uses a full block I will end up with lots of space
> wasted. Wouldn't change much if block was 2K, anyhow.

   With small files, they will typically be inlined into the metadata.
This is a lot more compact (as you can have several files' data in a
single block), but by default will write two copies of each file, even
on a single disk.

   So, if you want to use some form of redundancy (e.g. RAID-1), then
that's great, and you need to do nothing unusual. However, if you want
to maximise space usage at the expense of robustness in a device
failure, then you need to ensure that you only keep one copy of your
data. This will mean that you should format the filesystem with the -m
single option.

> I tough about compression, but is not clear to me the compression is
> handled at the file level or at the block level.

> Also I read that there is a mode that uses blocks for shared storage
> of metadata and data, designed for small filesystems. Haven't found
> any other info about it.

   Don't use that unless your filesystem is <16GB or so in size. It
won't help here (i.e. file data stored in data chunks will still be
allocated on a block-by-block basis).

> Still is not yet clear to me if btrfs can fit my situation, would
> you recommend it over XFS?

   The relatively small metadata overhead (e.g. compared to ext4) and
inline capability of btrfs would seem to be a good match for your
use-case.

> XFS has a minimum block size of 512, but BTRFS is more modern and,
> given the fact that is able to handle indexes on his own, it could
> help us speed up file operations (could it?)

   Not sure what you mean by "handle indexes on its own". XFS will
have its own set of indexes and file metadata -- it wouldn't be much
of a filesystem if it didn't.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                        --- argc, argv, argh! ---                        

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPp6o4IKyzvlFcI40RAl4iAJ0Ru31kjny2Kxhcswt+OkfOnor7mgCfaFXb
vkkEHvZc11UtmRI656i177k=
=bX+i
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
