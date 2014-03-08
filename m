Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54154 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaCHWQz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 17:16:55 -0500
Date: Sat, 8 Mar 2014 22:16:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: send/receive locking
Message-ID: <20140308221652.GG6318@carfax.org.uk>
References: <20140308215350.GE6318@carfax.org.uk>
 <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
 <20140308220027.GF6318@carfax.org.uk>
 <gm5l2kqc332h7w6arx688tf2.1394316159256@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
In-Reply-To: <gm5l2kqc332h7w6arx688tf2.1394316159256@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 08, 2014 at 10:02:39PM +0000, Josef Bacik wrote:
> Don't do it on a fs you care about, cow is broken with that branch so it will corrupt your fs.  So actually just find Wang's patch that sets skip locking for send and do that.  Thanks,

   Aah, that's good to know. It's not an FS I care about massively
much, but it'd be a pain to recreate all the setup. I think I'll go
cherry picking tomorrow morning. :)

   Hugo.

> Josef
> 
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> 
> On Sat, Mar 08, 2014 at 09:55:50PM +0000, Josef Bacik wrote:
> > Hey Hugo will you try the danger branch on btrfs-next, Wang changed the locking a bit.  Thanks,
> 
>    Sure. I'll build a kernel tonight and report tomorrow. I'm not sure
> how repeatable the problem is, though. I'll see if I can quantify
> that, too.
> 
>    Hugo.
> 
> > Josef
> >
> > Hugo Mills <hugo@carfax.org.uk> wrote:
> >
> >
> >    Is there anything that can be done about the issues of btrfs send
> > blocking? I've been writing a backup script (slowly), and several
> > times I've managed to hit a situation where large chunks of the
> > machine grind to a complete halt in D state because the backup script
> > has jammed up.
> >
> >    Now, I'm aware that you can't send and receive to the same
> > filesystem at the same time, and that's a restriction I can live with.
> > However, having things that aren't related to the backup process
> > suddenly stop working because the backup script is trying to log its
> > progress to the same FS it's backing up is... umm... somewhat vexing,
> > to say the least.
> >
> >    Is this a truly fundamental property of send/receive, or is there
> > likely to be a simple(ish) solution?
> >
> >    Hugo.
> >
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Comic Sans goes into a bar,  and the barman says, "We don't ---   
                         serve your type here."                          

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxuW1FheFHXiqx3kAQLrAhAAvMGzU+Dt8ruMdAXZZdvBcgVjO0125nrg
/uWNmdvY4+s1GZkf75Ec+IeeZfv6mFbM3qbLVAGpf4EQGhcDlWW5Lz9ynWKl5t/z
fCITh06s2sN5tpouIOaJUGFlIRjyrDp/YyoVATLNLfSPtgf/cQW10bILaqecRtOz
aFGWPnYe4YnC4XxXijAX3dmh191PZi6Q5U50LjIkHxuQj5Wu6CQMxibZxKBuKkfm
RW+3Ne9y+WoM3Lc85ZaHQ0fBlRWRC5YP/p6nPo6RPN8lhHYDEpXZrTp7X0DiULqs
x58BP4uShxMnpnWDh0ZK0mgy7fUqXfdtKSrr8X0w4IR9YzW4I6bmpmqAF3Pzw/Mg
HhPUHlzR6TA8T0/P8pIBnNllPGc24foRkVyGGXyQs6tDcIDZEReOzRKoTahYPyDp
jyrPuWq3LBKosktXLCs99nTundAn8OqxH4966jwhTTljT1aQ7rSoat8ms5S/WHz7
jYUXFx47CPcuV7AZDMFpi7LO1MMB8eEIhNAy/fWLwCqglAdX/fWRkuwzSJf+rG+Y
9F0HDJbk80/wOIaquEM0kjPOmtbViqAsObjK0gBOsf2S4xUPQs5DplEY9/0HZHSV
KcKb0m24YHBIdiv89jujwYzwo02s/CRO/PW5WJubL+Nwhnfj8jJ7mLN3CPTgoJ2d
M/J+rvrNxqU=
=tdRc
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
