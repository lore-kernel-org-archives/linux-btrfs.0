Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58130 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQN2w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 09:28:52 -0400
Date: Thu, 17 Jul 2014 14:28:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Philippe.Simonet@swisscom.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: NFS FILE ID not unique when exporting many brtfs subvolumes
Message-ID: <20140717132849.GJ4834@carfax.org.uk>
References: <562cbe8120c64c99b7dcee045a3bdc7e@SG001738.corproot.net>
 <20140717111303.GI4834@carfax.org.uk>
 <fa81b967fc564d7db91ef948c6605a3f@SG001738.corproot.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
In-Reply-To: <fa81b967fc564d7db91ef948c6605a3f@SG001738.corproot.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 01:02:06PM +0000, Philippe.Simonet@swisscom.com wrote:
> Hi Hugo
> 
> > -----Original Message-----
> > From: Hugo Mills [mailto:hugo@carfax.org.uk]
> > Sent: Thursday, July 17, 2014 1:13 PM
> > To: Simonet Philippe, INI-ON-FIT-NW-IPE
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: NFS FILE ID not unique when exporting many brtfs subvolumes
> > 
> > On Thu, Jul 17, 2014 at 10:40:14AM +0000, Philippe.Simonet@swisscom.com
> > wrote:
> > > I have a problem using btrfs/nfs to store my vmware images.
> > [snip]
> > > - vmware is basing its NFS files locks on the nfs fileid field returned from a NFS
> > GETATTR request for the file being locked
> > >
> > 	http://kb.vmware.com/selfservice/microsites/search.do?language=en_
> > US&cmd=displayKC&externalId=1007909
> > >    vmware assumes that these nfs fileid are unique per storage.
> > >
> > > - it seemed that these nfs fileid are only unique 'per-subvolume', but because
> > my nfs export contains many subvolumes,
> > > the nfs export has then my files (in different subvolume) with the same nfs
> > fileid.
> > >
> > > - no problem when I start all machine alone, but when 2 machines are running
> > at the same time, vmware seems to mix its reference to lock file and
> > > sometimes kills one vm.
> > >
> > > 	in esx server, following messages : 	/var/log/vmkwarning.log :
> > >
> > > 	2014-07-17T06:31:46.854Z cpu2:268913)WARNING: NFSLock: 1315:
> > Inode (Dup: 260 Orig: 260) has been recycled by server, freeing lock info for
> > .lck-0401000000000000
> > > 	2014-07-17T06:34:47.925Z cpu2:114740)WARNING: NFSLock: 2348:
> > Unable to remove lockfile .invalid, not found
> > > 	2014-07-17T10:18:50.320Z cpu0:32824)WARNING: NFSLock: 2348:
> > Unable to remove lockfile .invalid, not found
> > >
> > > 	and in machine log :
> > > 		Message from sncubeesx02: The lock protecting vm-w7-
> > sysp.vmdk has been lost,
> > > 		possibly due to underlying storage issues. If this virtual machine
> > is configured to be highly
> > > 		available, ensure that the virtual machine is running on some
> > other host before clicking OK.
> > >
> > > - vmware try to make its own file locking for flowing file type :
> > >
> > 	http://kb.vmware.com/selfservice/microsites/search.do?language=en_
> > US&cmd=displayKC&externalId=10051
> > >
> > > 	VMNAME.vswp
> > > 	DISKNAME-flat.vmdk
> > > 	DISKNAME-ITERATION-delta.vmdk
> > > 	VMNAME.vmx
> > > 	VMNAME.vmxf
> > > 	vmware.log
> > >
> > > Is there a way to deal with this problem ? is that a bug ?
> > 
> >    Add an arbitrary and unique "fsid=0x12345" value to the exports
> > declaration. For example, my server exports a number of subvolumes
> > from the same FS with:
> > 
> > /srv/nfs/nadja    -rw,async,fsid=0x1729,no_subtree_check,no_root_squash \
> >                    10.0.0.20 fe80::20
> > /srv/nfs/home     -rw,async,fsid=0x1730,no_subtree_check,no_root_squash \
> >                    fe80::/64
> > /srv/nfs/video    -ro,async,fsid=0x1731,no_subtree_check \
> >                    10.0.0.0/24 fe80::/64
> > 
> >    Hugo.
> > 

> first of all, thank for your answer !

> on my system, I have one export, that is the root btrfs subvolume
> and contains itself one subvolume per vm.
> if I change the NFS export fsid, it does not change anything in each
> the file IDs of the whole NFS export.
> (I crossed checked it just to be sure, tshark -V -nlp -t a port 2049
> | egrep "Entry: name|File ID", and effectively,
> fsid has no impact on file id) 

   Aaah, that's interesting. I suspect that you'll have to make the
mounts explicit, so for every subvolume exported from the server,
there's a line in fstab to mount it to the place it's exported from.
This happens as a side-effect of the recommended filesystem/subvol
layout[1] anyway, since it doesn't use nested subvolumes at all, so
I've never actually noticed the situation you mention.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---   
                to you about a cure for the common cold."                

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU8fPkVheFHXiqx3kAQKjYhAAjDwQ0/8o40rwuja+Wrp62cM8Snw8ELx1
MGTxm0ICylODkk0Mwa19DDxSyPAtmQQ9bVK1W3enS4dN89n1xTU+woHEbEG3Uslq
YxSm70n70MU3gPuKt7rz3PeUYIN+ygmOxd3yI9BKtdwbt622dMXQ9SBCBgxULa9R
TmO4bw7bhZMalsqEpLJPGVGqbta0Z3ZWy3apcM7YrNPQqt4PMN9YwuBCJRZvG3nj
t55omaSGiX7qLUsgQVV+CN2ARE80qj07VHS8ZskmlRMIhA3R2G9D9fVFLGNajTaK
8s8/axHqvZtwT72pIGy3B5UHmgwt5e0A1tOdf1twC/7T03zighfFlEHu0asjcjgE
IqmbqnUW0h0Es6u+bRjsShgflhIR7Jv2d7/NMukRzmbZubczZU3GceiCHU0E3nAa
4AXMR5Ea5YDBaRsRBWQ1xQ1onhudkA/IcIXORPGFhN59QnP0bCvyL1ueRc18bIdI
lky8dCrSwITfrasW332JJbNIgoux6Z1l2ImP5SU7mdCsjcWT7SR864uGIxvqsDXR
hh98+fbLepE4bYj42b2FVpDrlzAYSl+UWlePpxTfizvioJZ8JVZ3MpfWnBEEmu4x
hlwQebRfnnM7HJ9xwOtEVwhoJ9hI/7NYvFyCUyPPK+IvZEoXGIAIncN02lzYfOtP
ol9wrNl/Vi0=
=PZDL
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--
