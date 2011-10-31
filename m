From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Unable to mount btrfs partition
Date: Mon, 31 Oct 2011 08:30:07 +0000
Message-ID: <20111031083007.GT29548@carfax.org.uk>
References: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de>
 <20111028210947.GM29548@carfax.org.uk>
 <df08964cfb0f7e20f039e7fdbb970f35@joachim-neu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yBTw3iMQSKDA2CaE"
Cc: linux-btrfs@vger.kernel.org
To: email@joachim-neu.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <df08964cfb0f7e20f039e7fdbb970f35@joachim-neu.de>
List-ID: <linux-btrfs.vger.kernel.org>


--yBTw3iMQSKDA2CaE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 29, 2011 at 01:45:32AM +0200, email@joachim-neu.de wrote:
> 
> On Fri, 28 Oct 2011 22:09:47 +0100, Hugo Mills <hugo@carfax.org.uk>
> wrote:
> >On Fri, Oct 28, 2011 at 08:36:28PM +0000, email@joachim-neu.de wrote:
> >>Now I'm not able to mount my btrfs / and /home (both on the same
> >>partition) anymore:
> >>
> >>device fsid SOME-UUID devid 1 transid 84229 /dev/dm-0
> >>parent transid verify failed on 77078528 wanted 83774 found 84226
> >>parent transid verify failed on 77078528 wanted 83774 found 84226
> >>parent transid verify failed on 77078528 wanted 83774 found 84226
> >>parent transid verify failed on 77078528 wanted 83774 found 84226
> >>btrfs: open_ctree failed
> >>
> >>The boot process drops to the initramfs shell with no btrfsck
> >>available.
> >
> >   It wouldn't make any difference if it were -- btrfsck doesn't
> >actually fix anything, I'm afraid. This error message is regrettably
> >generic, and covers a whole range of evils. It's possible that 3.1
> >may
> >be able to deal swith the breakage ufficiently well to allow you to
> >boot and copy your files.
> 
> I'll give the 3.1 kernel a try right after "restore" finished which
> is running right now and doing quite a good job so far (as far as my
> / is concerned, lets wait for the /home).
> 
> What do the above error messages indicate? Is there an incrementing
> number for every transaction and the number of the most recent
> transaction is stored somewhere and those messages occur once those
> numbers are out of sync somehow?

   Yes, that's more or less right.

> Is it possible to "just" discard
> the last transactions? I would not mind, better loose a day than a
> month... Why is the message there three times?

   The transid is stored in every single metadata block. When reading
anything from the filesystem, there are typically many metadata blocks
read, and in this case several of them have transids later than the
expected value (which will come from the superblock).

> Is this information stored in a couple of backups? If so: can't I
> use any of the other backups temporarily?

   There's no explicit backups. btrfs is a copy-on-write filesystem,
which means, amongst other things, that when new metadata (or data) is
written to the FS, the old metadata is not overwritten immediately.
However, it _is_ marked as free space, and so could be overwritten at
any time. This isn't a backup in any sense of the word, and it's not
directly reachable through the FS's normal interfaces. It's entirely
down to luck whether the older blocks are still there.

> "restore" opens the fs in a ro recovery mode somehow where it
> ignores those errors. Is it possible to "force" the btrfs driver to
> load the fs in this recovery mode as readonly, too?

   No, I think the reasoning is that once your FS has got to this
state, it's sufficiently badly broken that we don't want to try
recovering anything from kernel space because it's too hard, and too
many odd things could show up and crash the FS driver.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---   
                              at the stars.                              

--yBTw3iMQSKDA2CaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrlyPIKyzvlFcI40RAjfJAJ9DJT89ARs1DYg44ZD7m3uYpD3gUQCaAtbL
cXPlxxlkApaapGzj+Kloiyc=
=JQ8n
-----END PGP SIGNATURE-----

--yBTw3iMQSKDA2CaE--
