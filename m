Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53771 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHSWWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 18:22:47 -0400
Date: Tue, 19 Aug 2014 23:22:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Zach Brown <zab@zabbo.net>
Cc: Klaus Holler <kho@gmx.at>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0 and
 btrfs-progs 3.14.2
Message-ID: <20140819222241.GD31558@carfax.org.uk>
References: <53F0A3B2.80709@gmx.at>
 <20140819221055.GI429@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
In-Reply-To: <20140819221055.GI429@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2014 at 03:10:55PM -0700, Zach Brown wrote:
> On Sun, Aug 17, 2014 at 02:44:34PM +0200, Klaus Holler wrote:
> > Hello list,
> > 
> > I want to use an ARM kirkwood based NSA325v2 NAS (dubbed "Receiver") for
> > receiving btrfs snapshots done on several hosts, e.g. a Core Duo laptop
> > running kubuntu 14.04 LTS (dubbed "Source"), storing them on a 3TB WD
> > red disk (having GPT label, partitions created with parted).
> > 
> > But all the btrfs receive commands on 'Receiver' fail soon with e.g.:
> >   ERROR: writing to initrd.img-3.13.0-24-generic.original failed. File
> > too large
> > ... and that stops reception/snapshot creation.
> 
> ...
> 
> > Increasing the verbosity with "-v -v" for btrfs receive shows the
> > following differences between receive operations on 'Receiver' and
> > 'OtherHost', both of them using the identical inputfile
> > /boot/.snapshot/20140816-1310-boot_kernel3.16.0.btrfs-send
> > 
> > * the chown and chmod operations are different -> resulting in
> > weird/wrong permissions and sizes on 'Receiver' side.
> > * what's "stransid", this is the first line that differs
> 
> This is interesting, thanks for going to the trouble to show those
> diffs.
> 
> That the commands and strings match up show us that the basic tlv header
> chaining is working.  But the u64 attribute values are sometimes messed
> up.  And messed up in a specific way.  A variable number of low order
> bytes are magically appearing.
> 
> (gdb) print/x 11709972488
> $2 = 0x2b9f80008
> (gdb) print/x 178680
> $3 = 0x2b9f8
> 
> (gdb) print/x 588032
> $6 = 0x8f900
> (gdb) print/x 2297
> $7 = 0x8f9
> 
> Some light googling makes me think that the Marvell Kirkwood is not
> friendly at all to unaligned accesses.

   ARM isn't in general -- it never has been, even 20 years ago in the
ARM3 days when I was writing code in ARM assembler. We've been bitten
by this before in btrfs (mkfs on ARM works, mounting it fails fast,
because userspace has a trap to fix unaligned accesses, and the kernel
doesn't).

> The (biting tongue) send and receive code is playing some games with
> casting aligned and unaligned pointers.  Maybe that's upsetting the arm
> toolchain/kirkwood.

   Almost certainly the toolchain isn't identifying the unaligned
accesses, and thus building code that uses them causes stuff to break.

   There's a workaround for userspace that you can use to verify that
this is indeed the problem: echo 2 >/proc/cpu/alignment will tell the
kernel to fix up unaligned accesses initiated in userspace. It's a
performance killer, but it should serve to identify whether the
problem is actually this.

   Hugo.

>  Does this completely untested patch to btrfs-progs,
> to be run on the receiver, do anything?
> 
> - z
> 
> diff --git a/send-stream.c b/send-stream.c
> index 88e18e2..4f8dd83 100644
> --- a/send-stream.c
> +++ b/send-stream.c
> @@ -204,7 +204,7 @@ out:
>                 int __len; \
>                 TLV_GET(s, attr, (void**)&__tmp, &__len); \
>                 TLV_CHECK_LEN(sizeof(*__tmp), __len); \
> -               *v = le##bits##_to_cpu(*__tmp); \
> +               *v = get_unaligned_le##bits(__tmp); \
>         } while (0)
>  
>  #define TLV_GET_U8(s, attr, v) TLV_GET_INT(s, attr, 8, v)

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---   
                to you about a cure for the common cold."                

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU/POMVheFHXiqx3kAQKeZQ/+ODWxajRLvcOW7acsxtqDFAlOVwElnzi3
7dT+Rxw/bkAW/JX0XP3p+c45chamAwiy3i+HIF333+YxmWfM6t3iZ9ntw4BNCHur
u04PDuEufIegUsPhtWH7+FYXuWWiaNw9D0S48/Y4rN/xhdkkcgw9Z2Z+lEEpl7ZK
My2mXL8d/JH+okzEQ+KQH8jwepuTymgXhKiA1B2grbANHno9G+MHf58Ps+PLYCB8
fSAU99euhej5UlepF7Hy/7HjHyb2QIRczkWXtmLEi5PKV92OLLMsd3MVh5qb2axr
CGxRiIVR117kfc6ohsDe+UQeCpuucvWYtcewwFapDTJFfSau7NobsdpRGt+Dr9CU
CGVOR2Xlk+ewtTR1pO0yvC8YE6wWg/mmU0jFaCmlWyZHhdoGZ1/YBRaHrcrUKDWz
h6p+NlcN0inblPx/eG2UJ1q/CjbDbWm38pE3EP8gjRXzz2yVoMlUUr8MLWEmzsHs
cUi9BxgL0/k45Y3d2rpyFtZNF6Ije6KRMgUrFR30WZkiU/DXYKj4aywmHO6BYo0/
ywf6FXwrBuknmgB/vGrJk2k+CAaEd+sJ/2EEbz0t7Pw4UgoC8DRvNcF6Pgvsy9oH
8buuHZjNlSS85GUSJYM4hOlM0294BOZ0YwfL7njkT7a2Kjo5lah0uetvR2QwBRgq
+rV2RJsq6Fg=
=yqNm
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
