From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: INSTALL hint: create device btrfs-control
Date: Thu, 4 Aug 2011 21:42:20 +0100
Message-ID: <20110804204219.GB8970@carfax.org.uk>
References: <20110804173548.GA8970@carfax.org.uk>
 <BrDfVHaT1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BrDfVHaT1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 04, 2011 at 10:13:00PM +0200, Helmut Hullen wrote:
> Hallo, Hugo,
> 
> Du meintest am 04.08.11:
> 
> >    What are the symptoms of not having the device node? (i.e. how
> > would I diagnose this particular problem?)
> 
> The days get shorter and shorter ...
> 
> running
> 
>         btrfs device scan
> 
> produces something like
> 
> ...
> failed to read /dev/hdc
> failed to read /dev/hdc8
> failed to read /dev/lmscd
> failed to read /dev/sdc1
> failed to read /dev/sdb4
> failed to open /dev/btrfs-control skipping device registration

   OK, that's the symptom we can put in the problems list for this
particular issue.

> failed to read /dev/sdd8
> failed to read /dev/hdc9
> failed to read /dev/sdf8
> ...
> 
> a lot of error messages for not existing devices and 1 error messages on  
> behalf of "btrfs-control".
> 
> My "/dev" directory has worked (without "udev") without any problem for  
> more than 10 years, it contains (has contained) a lot of entries for  
> nearly every case of disk. Therefore i had started with
> 
>         btrfs device scan 2>/dev/null
> 
> and that deleted the "btrfs-control" error message too. And
> 
>         btrfs device scan 2>&1 | grep -v 'failed to'
> 
> didn't help too.

   Goffredo published a patch to scan only the contents of
/proc/partitions, which should at least shut up the scan over the
issue of non-existent devices in /dev. That's in the next
integration-* branch (going out shortly... I'm just integrating and
updating the balance management patches before i release).

>         btrfs-show
> 
> doesn't need "/dev/btrfs-control", it shows the existing btrfs  
> partition(s).
> 
> If I remember correct: mounting works, writing works, reading works. And  
> adding another partition works.
> 
> But there are strange messages when I try to resize or delete.
> 
> I'll try to reproduce these messages ...

   Thanks. We can add those as symptoms to the solution later.

   How's this?

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_the_message_.22failed_to_open_.2Fdev.2Fbtrfs-control_skipping_device_registration.22_from_.22btrfs_dev_scan.22

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "I lost my leg in 1942.  Some bastard stole it in a ---       
                            pub in Pimlico."                             

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOOwQrIKyzvlFcI40RAiFXAJ4kYIOK2L8/O63fBJZXqSnQc6/paQCdE3gC
Pu++hJ1rqUEImyT9mTjPLFE=
=oqGr
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
