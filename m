Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124F0C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4052075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfC0ORu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:17:50 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:57750 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfC0ORt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:17:49 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1h99NA-00043M-Rv; Wed, 27 Mar 2019 14:17:44 +0000
Date:   Wed, 27 Mar 2019 14:17:44 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
Message-ID: <20190327141744.GF27856@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Adam Borowski <kilobyte@angband.pl>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Content-Disposition: inline
In-Reply-To: <20190327140748.GA30466@angband.pl>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 27, 2019 at 03:07:48PM +0100, Adam Borowski wrote:
> On Wed, Mar 27, 2019 at 05:46:50PM +0800, Qu Wenruo wrote:
> > This urgent patchset can be fetched from github:
> > https://github.com/adam900710/btrfs-progs/tree/flush_super
> > Which is based on v4.20.2.
> > 
> > Before this patch, btrfs-progs writes to the fs has no barrier at all.
> > All metadata and superblock are just buffered write, no barrier between
> > super blocks and metadata writes at all.
> > 
> > No wonder why even clear space cache can cause serious transid
> > corruption to the originally good fs.
> > 
> > Please merge this fix as soon as possible as I really don't want to see
> > btrfs-progs corrupting any fs any more.
> 
> How often does this happen in practice?  I'm slightly incredulous about
> btrfs-progs crashing often.   Especially that pwrite() is buffered on the
> kernel side, so we'd need a _kernel_ crash (usually a power loss) to break
> consistency.  Obviously, a potential data loss bug is always something that
> needs fixing, I'm just wondering about severity.

   It's a pretty regular event -- there's often a segfault or other
uncontrolled exit when running btrfs check on a broken filesystem.
It's usually hard to say whether that kind of thing (in --repair mode)
is causing additional corruption, or whether it's not fixing anything,
or whether it's fixing something and exposing the next error down.

> Or do I understand this wrong?
> 
> Asking because Dimitri John Ledkov stepped down as Debian's maintainer of
> this package, and I'm taking up the mantle (with Nicholas D Steeves being
> around) -- modulo any updates other than important bug fixes being on hold
> because of Debian's freeze.  Thus, I wonder if this is important enough to
> ask for a freeze exception.

   My ha'penn'orth: it's probably not worth asking for a freeze
exception -- I don't think it makes normal operation of the btrfs
progs actively dangerous, but it's increasing risk somewhat on what
are generally pretty rare operations in the lifetime of a filesystem.
It's only the offline tools that are going to be affected here anyway
-- most of the use-cases for btrfs-progs are in telling the kernel
what to do, rather than modifying the FS directly.

   I'd say it's definitely worth fixing the issue upstream (which Qu
is doing), and then (if possible) backporting it to your maintained
packages after the Debian release.

[Other opinions are also available from alternative vendors].

   Hugo.

-- 
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcm4YIAAoJEFheFHXiqx3kBmQP/31v4Z8Fbzbuz58sdN4rAjrc
qR+ZiutVeBh40dVEhBZ28ESKfX3Ivn0eQD/JYU06ncRnSr3J7mMxbkPdGaphMDF+
IWtqasZAGWArA1TaINIZQQWlVHbScc3CeWNCpa/2KQgW0J5blt+YyHp2jnVwX3wy
xcMO5qVy8AxFfTBEnlXvtuclK3qyEegKx4+9KsHQTHNGKkwaPGDDpJcdoQp4rCUu
mAtHeutEs4hrFYzHRUkSxKENjM7we5XkTgGMNHy794I7AicY+XG5y2VHITT4dPUl
3fQqIqw1yy9t1FuGHGeomG7ZkHNodthU7Em57rM6YfvZsNHm+8Cx2TvSQ9oIORJz
N0rhrVHqt1flRT1dXdZ10TDJFqo3tuX2FlDTFOsbRDHASsKF/aevf4egQyQQw26g
TdlqDQL1MyRxAwJlMhHnYamJKuXwHKFH5zTNH31ex2htUfM640/cyCbCCRxKDOo+
mJ2UJkHTUee+L+KZUL2vTQsbp4CIirDOCZaktlBek0cpozYSyiEkiuNrjMEcDhnc
xjp5gwKaizzsW2JDuIXfeb3yoVBwZYRrhfEcOSIfY8vsUOLr8Yua+OQ49t3V/bLh
u2UVKLtMAlNocmPFiSBMZPRo6VtMFEFvZmW15WiPO4tJTMSqYA3Xvv+BLx5MLrwM
KzuR5Ful2rVAb++DAfIu
=hv3W
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
