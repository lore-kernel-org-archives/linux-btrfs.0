From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Unable to mount btrfs partition
Date: Fri, 28 Oct 2011 22:09:47 +0100
Message-ID: <20111028210947.GM29548@carfax.org.uk>
References: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Cc: linux-btrfs@vger.kernel.org
To: email@joachim-neu.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de>
List-ID: <linux-btrfs.vger.kernel.org>


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2011 at 08:36:28PM +0000, email@joachim-neu.de wrote:
> Today I downgraded from Ubuntu's APT repo "oneiric-proposed" (which
> brings some kernel 3.0.0-13) back to the standard repo "oneiric".

   It's odd that switching from one 3.0.0 to another would cause
something bad to happen. Did something else happen in the process,
like a reboot without a clean shutdown? (This includes power loss,
suspend and failure to resume, and Alt-SysRq-b).

> Now I'm not able to mount my btrfs / and /home (both on the same
> partition) anymore:
> 
> device fsid SOME-UUID devid 1 transid 84229 /dev/dm-0
> parent transid verify failed on 77078528 wanted 83774 found 84226
> parent transid verify failed on 77078528 wanted 83774 found 84226
> parent transid verify failed on 77078528 wanted 83774 found 84226
> parent transid verify failed on 77078528 wanted 83774 found 84226
> btrfs: open_ctree failed
> 
> The boot process drops to the initramfs shell with no btrfsck
> available.

   It wouldn't make any difference if it were -- btrfsck doesn't
actually fix anything, I'm afraid. This error message is regrettably
generic, and covers a whole range of evils. It's possible that 3.1 may
be able to deal swith the breakage ufficiently well to allow you to
boot and copy your files.

> I tried to boot with both the "new" 3.0.0-13 kernel and
> the old 3.0.0-12 and 3.0.0-11 kernels -- no success. I'm running a
> live cd right now with 3.0.0-12 and I get the above error no matter
> what I do: no mount, no fsck, no nothing.
> 
> I really hope someone can help me get my data back...

   You could try using a 3.1 kernel, as I suggested above. Failing
that, in josef's git repository at [1], you will find a tool called
"restore". This should allow you to copy any files that had been
modified since your last backup. If you haven't got backups, you
*really* should look into getting some before continuing to use a
filesystem marked as EXPERIMENTAL...

   Hugo.

[1] https://github.com/josefbacik/btrfs-progs

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---         
                           of the precipiate.                            

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOqxobIKyzvlFcI40RAqtjAJ9cZKugVoBZCKpM2OOvYz7Dv463iQCgwFAx
onQnQc55rmWapulexxx1K0s=
=OKhQ
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
