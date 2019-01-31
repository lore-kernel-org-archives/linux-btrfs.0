Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C316C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E682086C
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbfAaQon (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:44:43 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:39091 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbfAaQon (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 11:44:43 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gpFSB-0004wI-Iu; Thu, 31 Jan 2019 16:44:39 +0000
Date:   Thu, 31 Jan 2019 16:44:39 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20190131164439.GC4461@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Filipe Manana <fdmanana@kernel.org>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
 <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> >
> > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Checking if the destination root is read-only was being performed only for
> > > clone operations. Make deduplication check it as well, as it does not make
> > > sense to not do it, even if it is an operation that does not change the
> > > file contents (such as defrag for example, which checks first if the root
> > > is read-only).
> >
> > And this is also change in user-visible behaviour of dedupe, so this
> > needs to be verified if it's not breaking existing tools.
> 
> Have you had the chance to do such verification?
> 
> This actually conflicts with send. Send does not expect a root/tree to
> change, and with dedupe on read-only roots happening
> in parallel with send is going to cause all sorts of unexpected and
> undesired problems...
> 
> This is a problem introduced by dedupe ioctl when it landed, since
> send existed for a longer time (when nothing else was
> allowed to change read-only roots, including defrag).
> 
> I understand it can break some applications, but adding other solution
> such as preventing send and dedupe from running in parallel
> (erroring out or block and wait for each other, etc) is going to be
> really ugly. There's always the workaround for apps to set the
> subvolume
> to RW mode, do the dedupe, then switch it back to RO mode.

   Only if you want your incremental send chain to break on the way
past...

   I think it's fairly clear by now (particularly from the last thread
on this a couple of weeks ago) that making RO subvols RW and then back
again is a fast way to broken incremental receives.

   Hugo.

-- 
Hugo Mills             | A clear conscience. Where did you get this taste for
hugo@... carfax.org.uk | luxuries, Bernard?
http://carfax.org.uk/  |                                          Sir Humphrey
PGP: E2AB1DE4          |                                   Yes, Prime Minister

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcUyX3AAoJEFheFHXiqx3k958P/03C/u2HTP0rRjUmUUAYceMZ
TriLO1axklZ0tGFT0Mb8O0BuErZyq0rfuIVAH+loH4sqdVhDkMK+oZUGp318RK0w
6ZMweDoy7CppaxJyvevKAr0m5Z9jyZqxnVnlD6qgKpAqZCqqjzL3++TsVb4LJnVG
DRqFHwmQLbsqcnemQ5Dy582+Jrxb15ZWPIchloZDyeLAwUGBtK5bz6KQ+cIXY5KS
NDND4thIYCVMSisFNv9m/6OhkdPg6q+USEwxoE3yFu/ZEOF/Uzyz1b6B37cQkCpp
8au1tjGO6lJu+IoZJNoMd5/l9KTRiPg8kxa+bWS1GSiVMLaeL/W4ZbNKmKRqmABC
n28RGxRftvp0Rk9ydgIdJfdbv38vTR/q/WsQ3KbFUUBCkerZQUa6Kjl0nqUlm9In
L4qxgLW2sxKPwtB3b9qYyHrWX2j+xzh0SNNiksffte09V0HGoqbCtyDldOBWKXjH
aGFbdRclUsh12/Mulfub8a3tIDywnTPfL0WVNaflfNZLN4E9D9/+Iv5E6Xyu/j2e
KLHEPLA40Ce/5Rz4K2LZg1l1q9SYSXBv7TZ4IGLfKx4hx7WXd0TxLuDjKi/+mwXW
vlHneXo3wgARZTGB4sXY9anMM3sdcVnKE1tdbZ0OX66dQNVd0Qfm0DIgiLVT84Am
Lamr2A1P88sLXaN8PQnb
=4unu
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
