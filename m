Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54068 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaCHWA3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Mar 2014 17:00:29 -0500
Date: Sat, 8 Mar 2014 22:00:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: send/receive locking
Message-ID: <20140308220027.GF6318@carfax.org.uk>
References: <20140308215350.GE6318@carfax.org.uk>
 <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
In-Reply-To: <usnory0eq5h626p5eaeeh4ki.1394315749442@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 08, 2014 at 09:55:50PM +0000, Josef Bacik wrote:
> Hey Hugo will you try the danger branch on btrfs-next, Wang changed the locking a bit.  Thanks,

   Sure. I'll build a kernel tonight and report tomorrow. I'm not sure
how repeatable the problem is, though. I'll see if I can quantify
that, too.

   Hugo.

> Josef
> 
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> 
>    Is there anything that can be done about the issues of btrfs send
> blocking? I've been writing a backup script (slowly), and several
> times I've managed to hit a situation where large chunks of the
> machine grind to a complete halt in D state because the backup script
> has jammed up.
> 
>    Now, I'm aware that you can't send and receive to the same
> filesystem at the same time, and that's a restriction I can live with.
> However, having things that aren't related to the backup process
> suddenly stop working because the backup script is trying to log its
> progress to the same FS it's backing up is... umm... somewhat vexing,
> to say the least.
> 
>    Is this a truly fundamental property of send/receive, or is there
> likely to be a simple(ish) solution?
> 
>    Hugo.
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Well, you don't get to be a kernel hacker simply by looking ---   
                    good in Speedos. -- Rusty Russell                    

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUxuS+1heFHXiqx3kAQKurA//VcyoGwCU3Pzg51O/JRz+ACA2S67TtNWB
zS423A5QkioHWEKONxk55D09SsbxRDua2vebi6yrWhN9KGX3SCxZNFX5ycY/i/1I
ElnJOfGhzwT6tn/inTC5HGyK61OQr8s2BxSf3kBSV4gDeWGZz76ngQMsXPvo1DIg
YbVRwOR8n8WZD8mYPNMM7LuWa/6+ow0wim/jTfqE7eKGMu/vman6VgpLKlx5miEr
mby5XBZUxlOhDsTcOye7IPCR0G2485MbbjXgwsjAOcxXdD/76ajCtCKsiQQXYNdi
4dTljdgIxPVkgjCNG9HpcK4i7mJB/AdK2XkN4COWsHvQy15Ci8HDCIfTwA6iMQLT
7D985AroDnB8UIHjHcRUDlnSZfjt05vjvhaMElkrQSNvbCOh3Zz+CECI1fECPtkO
NN/77M3A6e5KM2nP2zBIid3osUs/qgkI7D7oEs/2IJZnwMvIXLkalcQIbW4eyAk2
yWvRDuGgyqOgSlVAI1oQqGbIVkxPiF/K+UotLSVCT+E5JHyUF571FasLcPIv9prD
KYin7qI3aeIJs6Oav3sqQ74a9Sspy3TNfxvTmYLqH0Rjp1t5Kd3REyOxQ2aTb6uu
8pNjLLBZy0/naMJOWoLHhkFfocLkfqF9aRVs/Tp9/Dvh4U/rbIS/SFJuRzeFZxHE
FBjXASa9n3Q=
=uuqZ
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
