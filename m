Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4469DC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 03:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F1E218D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 03:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfDXD6m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 23:58:42 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42754 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbfDXD6l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 23:58:41 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 24A982CB125; Tue, 23 Apr 2019 23:58:41 -0400 (EDT)
Date:   Tue, 23 Apr 2019 23:58:41 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Paul Jones <paul@pauljones.id.au>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Global reserve and ENOSPC while deleting snapshots on 5.0.9
Message-ID: <20190424035840.GA11500@hungrycats.org>
References: <20190423230649.GB11530@hungrycats.org>
 <SYCPR01MB508619DDF149E56FAAC7C9D29E3C0@SYCPR01MB5086.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <SYCPR01MB508619DDF149E56FAAC7C9D29E3C0@SYCPR01MB5086.ausprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 24, 2019 at 02:57:47AM +0000, Paul Jones wrote:
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org <linux-btrfs-
> > owner@vger.kernel.org> On Behalf Of Zygo Blaxell
> > Sent: Wednesday, 24 April 2019 9:07 AM
> > To: linux-btrfs@vger.kernel.org
> > Subject: Global reserve and ENOSPC while deleting snapshots on 5.0.9
> >=20
> > I had a test filesystem that ran out of unallocated space, then ran out=
 of
> > metadata space during a snapshot delete, and forced readonly.
> > The workload before the failure was a lot of rsync and bees dedupe
> > combined with random snapshot creates and deletes.
> >=20
> > I tried the usual fix strategies:
> >=20
> > 	1.  Immediately after mount, try to balance to free space for
> > 	metadata
> >=20
> > 	2.  Immediately after mount, add additional disks to provide
> > 	unallocated space for metadata
> >=20
> > 	3.  Mount -o nossd to increase metadata density
> >=20
> > #3 had no effect.  #1 failed consistently.
> >=20
> > #2 was successful, but the additional space was not used because btrfs
> > couldn't allocate chunks for metadata because it ran out of metadata sp=
ace
> > for new metadata chunks.
> >=20
> > When btrfs-cleaner tried to remove the first pending deleted snapshot, =
it
> > started a transaction that failed due to lack of metadata space.
> > Since the transaction failed, the filesystem reverts to its earlier sta=
te, and
> > exactly the same thing happens on the next mount.  The 'btrfs dev add' =
in #2
> > is successful only if it is executed immediately after mount, before th=
e btrfs-
> > cleaner thread wakes up.
>=20
> I had a similar problem on iirc 4.20, except that I couldn't get the new =
devices to add (raid1) before the cleaner thread ran, no matter how fast I =
added them after mount.
> I ended up just commenting out the part that forces the fs to go read onl=
y. The cleaner thread exits gracefully (I think?) so then it was no trouble=
 to add the devices.
>=20
> Is it still necessary to have the fs go read only like that when it's out=
 of space?

It's definitely a good idea to go read only on generic transaction
failures.

Maybe it's not such a good idea to lump ENOSPC in with other kinds of
transaction failure.

> Paul.
>=20

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXL/e7wAKCRCB+YsaVrMb
nBCfAKDGPwLYGSjgy0YL0qokrHYj6/a5TQCgt42LCCaqnuc9gHzfRmjmHfllvxk=
=CLWm
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
