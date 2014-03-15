Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54038 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaCON1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 09:27:20 -0400
Date: Sat, 15 Mar 2014 13:27:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove transaction from send
Message-ID: <20140315132716.GL6151@carfax.org.uk>
References: <1394739733-500-1-git-send-email-jbacik@fb.com>
 <20140313221628.GF6151@carfax.org.uk>
 <53234FAA.5060204@fb.com>
 <20140314224404.GJ6151@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
In-Reply-To: <20140314224404.GJ6151@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 10:44:04PM +0000, Hugo Mills wrote:
> On Fri, Mar 14, 2014 at 02:51:22PM -0400, Josef Bacik wrote:
> > On 03/13/2014 06:16 PM, Hugo Mills wrote:
> > >On Thu, Mar 13, 2014 at 03:42:13PM -0400, Josef Bacik wrote:
> > >>Lets try this again.  We can deadlock the box if we send on a box and try to
> > >>write onto the same fs with the app that is trying to listen to the send pipe.
> > >>This is because the writer could get stuck waiting for a transaction commit
> > >>which is being blocked by the send.  So fix this by making sure looking at the
> > >>commit roots is always going to be consistent.  We do this by keeping track of
> > >>which roots need to have their commit roots swapped during commit, and then
> > >>taking the commit_root_sem and swapping them all at once.  Then make sure we
> > >>take a read lock on the commit_root_sem in cases where we search the commit root
> > >>to make sure we're always looking at a consistent view of the commit roots.
> > >>Previously we had problems with this because we would swap a fs tree commit root
> > >>and then swap the extent tree commit root independently which would cause the
> > >>backref walking code to screw up sometimes.  With this patch we no longer
> > >>deadlock and pass all the weird send/receive corner cases.  Thanks,
> > >
> > >    There's something still going on here. I managed to get about twice
> > >as far through my test as I had before, but I again got an "unexpected
> > >EOF in stream", with btrfs send returning 1. As before, I have this in
> > >syslog:
> > >
> > >Mar 13 22:09:12 s_src@amelia kernel: BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040\x0a
> > >
> > 
> > I just noticed that the offset you have there is freaking gigantic,
> > like 700mb, which is way larger than what an extent should be.  Here
> > is a newer debug patch, just chuck the old on and put this instead
> > and re-run
> > 
> > http://paste.fedoraproject.org/85486/39482301
> 
>    That last run, with the above patch, failed again, at approximately
> the same place again. The only output in dmesg is:
> 
> [ 6488.168469] BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040, len=1294336

root@amelia:~# btrfs insp ino 1786631 /
//srv/vm/armand.img
root@amelia:~# ls -l /srv/vm/armand.img 
-rw-rw-r-- 1 root kvm 4000000000 Jan 30 08:11 /srv/vm/armand.img
root@amelia:~# filefrag /srv/vm/armand.img
/srv/vm/armand.img: 17436 extents found

   This is a VM image, not currently operational. It probably has
sparse extents in it somewhere.

   The full filefrag -ev output is at [1], but the offset it's
complaining about is 825257984 = 201479 4k blocks:

 ext:     logical_offset:        physical_offset: length:   expected: flags:
17200:   201478..  201478:    7220724..   7220724:      1:    8923002:
17201:   201479..  201481:    8912386..   8912388:      3:    7220725:
17202:   201482..  201482:    8923002..   8923002:      1:    8912389:

   This seems unexceptional.

   Hugo.

[1] http://carfax.org.uk/files/temp/filefrag.txt

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- "Can I offer you anything? Tea? Seedcake? ---            
                         Glass of Amontillado?"                          

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUyRVNFheFHXiqx3kAQJT4hAAs+IriIrBMwbmuzh4U8HYkNRLQJP2b+ZA
HbH/CTxc1V64lzSAf/Q/zW3HMVk9lgD11e3AikNYbE+Hecaaf48WwKlu2gSIVq1e
3PNjNXbuudu7p8sbbyqEJOw3/DtKIrEb2GVsrDOt78pTt5NAfAwtRMrCoh7VfS3g
DXa28g5wpL4TuxRpC/pe3i81cnLbtvLMpK95BOVcO3xQZMEegoPWHxAZBcNCpDSV
uHSceFV0YTfXBPKXhXbbeUNBC68gVxemowgrt7ha2/xLaxCJH4P9w/Co0D6s4a4l
NkhhFBmWq3O5cUBAXTtEmyv/Uokq8/kw+rbtzXunev2IHpOCfK5pmvs+ujjLIBFd
Sq1tSClFBh760lvaeqJ3Ir5eutqlwpBI90YhKs6MFxPCmq6tChVXMqOezDC3TVja
aGWPTfw7f5fGSKWS1Sfklmi8AUEtIueYwK33Ld6N5KQ1SliPLfWwjQhGIeWClfzT
mWegh4/9iZaDuY2kqYyVIXIAWCFJR08q5h7Jp3E1g5SnHwMHfz4hFQDxvYBYdxiv
+f0e1225Mmt3zGDCuJwzwCkFYeISVj5ekAvAB/iDDAlOu/eGOPkAA2VX3GvMz3vd
keCxmf8y7fNKEd5xAAp0xXJ0N3o8WH8bzLr6hOP/mayAimO1dlzje9LPGaRxC1+g
q90i8qkJ0xU=
=2gvy
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
