From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: [patch 2/4] Add an option to show ISO, binary or raw bytes
	counts using df.
Date: Mon, 18 Oct 2010 21:46:54 +0100
Message-ID: <20101018204654.GA7986@vlad.carfax.org.uk>
References: <20101017182643.297900488@carfax.org.uk> <20101017182706.430006857@carfax.org.uk> <4CBC03A4.4080600@kingswood-consulting.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Cc: linux-btrfs@vger.kernel.org
To: Frank Kingswood <frank@kingswood-consulting.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CBC03A4.4080600@kingswood-consulting.co.uk>
List-ID: <linux-btrfs.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 18, 2010 at 09:21:56AM +0100, Frank Kingswood wrote:
> On 17/10/10 19:26, hugo-lkml@carfax.org.uk wrote:
>> Change btrfs filesystem df to allow the user to control the scales
>> used for sizes in the output.
>>
>> Index: btrfs-progs-unstable/btrfs.c
>> ===================================================================
>> --- btrfs-progs-unstable.orig/btrfs.c	2010-10-17 18:43:57.000000000 +0100
>> +++ btrfs-progs-unstable/btrfs.c	2010-10-17 18:47:36.000000000 +0100
>> @@ -87,9 +87,10 @@
>>   		"Show the info of a btrfs filesystem. If no<uuid>  or<label>\n"
>>   		"is passed, info of all the btrfs filesystem are shown."
>>   	},
>> -	{ do_df_filesystem, 1,
>> -	  "filesystem df", "<path>\n"
>> +	{ do_df_filesystem, -1,
>> +	  "filesystem df", "[-r|-b|-i]<path>\n"
>>   		"Show space usage information for a mount point\n."
>> +		"-r, -b, -i for raw (bytes), binary or ISO sizes."
>>   	},
>
> This seems to eat up the short option namespace a bit quickly.
> Fileutils uses different names as well, it may be convenient for users to 
> match its names:
> 	-h --human-readable   powers of 2**10
> 	-H --si   powers of 1000

   Matching fileutils is probably a good idea. I'm happy to use -h and
-H.

>>   	{ do_balance, 1,
>>   	  "filesystem balance", "<path>\n"
>> Index: btrfs-progs-unstable/btrfs_cmds.c
>> ===================================================================
>> --- btrfs-progs-unstable.orig/btrfs_cmds.c	2010-10-17 18:43:57.000000000 +0100
>> +++ btrfs-progs-unstable/btrfs_cmds.c	2010-10-17 18:47:36.000000000 +0100
>> @@ -841,7 +841,36 @@
>>   	u64 count = 0, i;
>>   	int ret;
>>   	int fd;
>> -	char *path = argv[1];
>> +	char *path;
>> +	int format = PRETTY_SIZE_BINARY;
>
> Should the default not be to show sizes in bytes ("RAW")?

   I was trying not to change the default behaviour at all, but with
-h/-H (and no switch for --raw), that would make sense. I'll re-roll
the patches. (And update the man pages, as Goffredo asked).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- "I don't like the look of it,  I tell you." "Well, stop ---     
                          looking at it, then."                          

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFMvLI+IKyzvlFcI40RAqs8AJ9rA9lBMjquqSPHmkeaVBWx46vm4wCggiBn
HXexlJkO0RR0RHhG/T70kRM=
=ezzh
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
