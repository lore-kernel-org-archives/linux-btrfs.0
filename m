Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBEAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 16:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9DD62084D
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 16:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfBTQl7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:41:59 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40874 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfBTQl6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 11:41:58 -0500
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 2ECD222B15F; Wed, 20 Feb 2019 11:41:58 -0500 (EST)
Date:   Wed, 20 Feb 2019 11:41:56 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20190220164140.GF9995@hungrycats.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
 <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Checking if the destination root is read-only was being performed onl=
y for
> > > clone operations. Make deduplication check it as well, as it does not=
 make
> > > sense to not do it, even if it is an operation that does not change t=
he
> > > file contents (such as defrag for example, which checks first if the =
root
> > > is read-only).
> >
> > And this is also change in user-visible behaviour of dedupe, so this
> > needs to be verified if it's not breaking existing tools.
>=20
> Have you had the chance to do such verification?
>=20
> This actually conflicts with send. Send does not expect a root/tree to
> change, and with dedupe on read-only roots happening
> in parallel with send is going to cause all sorts of unexpected and
> undesired problems...

This is a problem bees ran into.  There is a workaround in bees (called
--workaround-btrfs-send) that avoids RO subvols as dedupe targets.
As the name of the option implies, it works around problems in btrfs send.

This kernel change makes the workaround mandatory now, as the default
case (without workaround) will fail on every RO subvol even if that
behavior is desired by the user.  That breaks an important use case on
the receiving side of sends--to dedupe the received subvols together
while also protecting them against modification on the target system
with the RO flag--and preserving that use case is why the send workaround
was optional (and not default) in bees.

bees also won't handle the RO/RW/RO transition correctly, as it didn't
seem like a sane thing to support at the time.  That is arguably something
to be fixed in bees.

> This is a problem introduced by dedupe ioctl when it landed, since
> send existed for a longer time (when nothing else was
> allowed to change read-only roots, including defrag).

Is there a reason why incremental send can't simply be fixed?  As far
as I can tell, send is failing because of a runtime check that seems to
be too strict; however, I haven't tried removing that check to see if
it fixes the problem in send, or just hides the next problem.

More details at:

	https://github.com/Zygo/bees/issues/79#issuecomment-429039036

> I understand it can break some applications, but adding other solution
> such as preventing send and dedupe from running in parallel
> (erroring out or block and wait for each other, etc) is going to be
> really ugly. There's always the workaround for apps to set the
> subvolume
> to RW mode, do the dedupe, then switch it back to RO mode.
>=20
> Thanks.

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXG2DQQAKCRCB+YsaVrMb
nEjNAJ4t9qA9U0W6/ZJFRFoYkolKUmW4YQCfTH5Q/b3u9TCoXaCSnbXmURprMls=
=e16n
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
