Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55229 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161057AbcBDTsh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 14:48:37 -0500
Date: Thu, 4 Feb 2016 19:48:33 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Moviuro <moviuro@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
Message-ID: <20160204194833.GD30635@carfax.org.uk>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B2AA51.80908@cn.fujitsu.com>
 <56B387C6.9070505@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rqzD5py0kzyFAOWN"
In-Reply-To: <56B387C6.9070505@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 04, 2016 at 06:17:58PM +0100, Goffredo Baroncelli wrote:
> On 2016-02-04 02:33, Qu Wenruo wrote:
> > The idea itself makes a lot of sense.
> > But I have at least two things to worry about:
> > 
> > 1) Old scripts backward compatibility
> >     Especially xfstests. Maintainer will hate it a lot.
> >     As we have changed it several times and broken existing test cases.
> > 
> >     Although personally I like to let all the backward compatibility
> >     things go hell, but that's definitely not how things work. :(
> 
> we could change the name of the btrfs prog (like bfs or bctl  ?). 
> 
> If the command is called with the old name (btrfs) the old behavior is maintained; with the new name the new output is show if the specific sub command was updated; instead if the specific sub-command is not updated, the old output is show. 
> 
> We could allow a window of 1-year of transition where the new command will be in the alpha state where there is no any guarantee to be backward compatible, hoping that this time would be sufficient to reshape the output of all commands.
> 
> For the old command no update or enhancement should be allowed (with the exception of bugfix of course).

   If that's going to happen, can I strongly request that all of the
output selection options in btrfs sub list are dropped, and all of the
possible use cases enumerated, evaluated, and understood, before
producing a set of coherent and functional options that are actually
useful.

   There's a load of different ways that the command can be called,
and several of them aren't well supported. There's also different
questions what can be asked of the tool, and it's hard to work out
which switches to use for any given desired output (if it supports
them at all). This _really_ needs fixing.

   (I'm more than happy to do that hard thinking and write up a
detailed spec for it, BTW).

   Hugo.

-- 
Hugo Mills             | How do you become King? You stand in the marketplace
hugo@... carfax.org.uk | and announce you're going to tax everyone. If you
http://carfax.org.uk/  | get out alive, you're King.
PGP: E2AB1DE4          |                                        Harry Harrison

--rqzD5py0kzyFAOWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWs6sRAAoJEFheFHXiqx3ktBAQALBjcG8PJHWal3mTZPyjlWdx
7AnJFUKekwkklsRYx3tzUjJGwxZdIRwy56wFpHohtKY927XkTz0fJ+FiW3x9Ntvm
SOtvK4krtb6msU7oX9OPsVWdeg/L+T2Ypjx2av+4gEQtnY7VFPz8F2asygqTqPQn
2Rm96ML/u17Sb37E2A+Zc0IB/4OmZ2/yyElr49btx/Uirde4VOr0u6dDC1re48Oy
maNXHkWtj5Q2cJv5reI0eueJrSDphMeA7lv4MFHzcNFAZIsofQr3QYMhf/6Vtl4a
hf1vu7oo8iuR6YTzqkXtIpBBWfEhrMKg8GR0mBrbs6/15nPqhCmap2gEGUXI2fiA
UojUGTG1QEOyKIiGQFCPA80GtIHhxNzm/jGB5Kbr1TCil+HWzqO0ciLl7BpnQN4/
YdxcxuGXuMfWvdSqRW+BHhqY79YlWg5lK5e6m6j4QwYjbh8N7IkDrR2ViSu9wXrj
uNTg2Y994S36w7YsBP+E7NbTlnumbkSOB9yMe6xfoqWUMrt6pRbhBS1NsnyingVV
oCck5GrQm/y9DK2z12tqhK/DaPDB2i/4pfrdMunNpxdOpbTOE9l3QjtuQlC41CtD
dXlsqj/4nW2c3YDHeKNUbDA8NnKrv1T6Hpvb2NYDaVJOghUpQB32kvnrGsDqfYUW
aE692CDNZG7tiL6LlTSl
=irQm
-----END PGP SIGNATURE-----

--rqzD5py0kzyFAOWN--
