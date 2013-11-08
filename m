Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33317 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3KHINQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 03:13:16 -0500
Date: Fri, 8 Nov 2013 08:13:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix/remove "csum failed ino" error
Message-ID: <20131108081307.GQ14405@carfax.org.uk>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
 <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
 <CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
 <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
 <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
 <151A7826-2EA1-45F5-8FAD-EC79FA7F08CE@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/F2XdnRjS8y2HUtp"
In-Reply-To: <151A7826-2EA1-45F5-8FAD-EC79FA7F08CE@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--/F2XdnRjS8y2HUtp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 07, 2013 at 10:56:10PM -0700, Chris Murphy wrote:
> What's the kernel and btrfs progs version?
> 
> I wish the dmesg errors were more explicit about the nature of checksum errors: do the two metadata checksums mismatch each other (one of them matches with data), or the metadata checksums match each other but mismatch with data?

   If there's two copies, and one fails the checksum and the other
passes, then there will be a note following the failure that it
read the other checksum and succeeded, and repaired the problem.

> Hopefully I'm mistaken, but it looks in this case that the data is actually corrupt, not the metadata. In which case repair would only be possible for raid1 or raid10 data profiles.
> 
> Why the corruption occurred depends on kernel and btrfs-progs versions, and what you were doing prior to the corruption so dmesg prior to the corruption would be needed and also when trying to mount with the recovery option so it might be worth:
> 
> dmesg
> [note the last time entry]
> dmesg -n7
> btrfs mount -o recovery <dev> <mp>
> dmesg
> 
> report results since the previously noted last time entry
> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- For months now, we have been making triumphant retreats ---     
               before a demoralised enemy who is advancing               
                           in utter disorder.                            

--/F2XdnRjS8y2HUtp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUnydE1heFHXiqx3kAQLjmQ//ZEe0YIhfTPUj43S85Bwc8n85/dxJyt+5
DPJiqneZRF5kjtiVwjqdTrVpHw9FQDnkF5HPsr30C8lOGHHi4k5Rh67VuqUwD9c2
N9zgMpm7FhjEdx/zPEieaLu3Ftw26rDEbwI/ds6UkvjNWScKLsHYTzmt/f1sMbBv
LyWSqSidj0xhENnKLdECpInY1s7rwn2yJKVsu3TCRTr5djfAYIv1eAIU0lmS7EIn
7D6CRxsWG5lNrIqVOMXQVR+42uNgsccmrmqNsqnJOX8nDVW7gxD6Cfc45ARmq7Bt
iz5bSli+L+4URGvy6wLumGDJQNV4U8orcuJtSkYh7CdC2aQKML6r05/waCHCJBah
JUw5dmhkdlgXDJ1f1duBAZSssZ4GlCSRBmWLNkP2/YWoEVxuQ+OOiFTDoF/e1ikf
BCjR6BLKSowJW+mDa19xnfe6ndnvylPxOnCkk1qB+ntyIU1kYyITR+L4vXaGGvWd
sOSUzMeSDS3himEG//4tgs19lawa/Gjx6ocQavD5wKf3fz7OhlyD1mr3OHnEraZu
g+uzsENmnVGStuUhvo6xvMRCkYWzH8Q67TdFdyu14YFOYNhshqKCSeTKZ4dQqocs
RepPdM4/KsxjhPIJxR4AnXGqChix03bBlwBB4HKx5NCuPhho+vladU7XzChWjUic
83+wgirJTVQ=
=mR9M
-----END PGP SIGNATURE-----

--/F2XdnRjS8y2HUtp--
