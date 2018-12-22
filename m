Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B856C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E7E21934
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733072AbeLVStg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:49:36 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:45820 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbeLVStg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 13:49:36 -0500
X-Greylist: delayed 2696 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2018 13:49:35 EST
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1galde-0007Nc-JQ; Sat, 22 Dec 2018 18:04:38 +0000
Date:   Sat, 22 Dec 2018 18:04:38 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Raymond Jennings <shentino@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Specifying block group size
Message-ID: <20181222180438.GG30713@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Raymond Jennings <shentino@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ewQ5hdP4CtoTt3oD"
Content-Disposition: inline
In-Reply-To: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ewQ5hdP4CtoTt3oD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 21, 2018 at 10:18:40PM -0800, Raymond Jennings wrote:
> How do I specify the size of a block group at mkfs?

   You don't -- there's no explicit control over it. The FS will
decide based on the overall size of the filesystem in question.

   Typically, data groups are made of 1 GiB chunks, and metadata
groups are made of 256 MiB chunks (where the RAID level will determine
the number of chunks in a group and the amount of usable space of the
group).

   Hugo.

> 
> Like, for example, saying that data groups will be 1GiB, but metadata
> groups will be 1MiB?
> 
> I noticed that they had different default sizes based on the profile
> (dup vs single vs raid)

-- 
Hugo Mills             | Beware geeks bearing GIFs
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ewQ5hdP4CtoTt3oD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcHny2AAoJEFheFHXiqx3konEP/3Wt3GDC+exwVjmuNGXxFdb4
DQqVU1aGxabJCR5kGXhFElJMujZxoM6uIKvl0g/eRwNrELGSKUqn46NuRU2zIf8l
4T7eJElFUaueEEEQFe2bMmJC5Ji3Y/r+ILzDWS2iizh2DlxIZMQhB0PtlVDOLPum
heNaBIAriLawmy+6P6XYFf9rtbhOewr4RYD6S/IEKqfypgbBLpiQV9bj6I/G1Q1O
4RsXH+SWr616CS5qVrf4jlsZX6ToL8TA5NgtQBKTZRMqqgh0FRPAPEVWXW0mj6yM
A9nWn15DAwTd95mF7ybdSQ11gAyCqViwumyOJtp1foKVf1fgAzSKA0Z+wMn5xTxS
7YxQ61pIQvq1plHcSkP6nKphsvgkCHLPKa0wkbXffmpe5jbWtk/UwMZr6mrM0GPy
w0tQjwKpiAPLFDj2WaNpUOXWUfPn9dzWewqF+pFAkgPTOXeUC+9nbfswHd/WoVMx
aYg8NraI0tgzsWwoDx+N4NslIixqd9MPwSWQ3zRBqdQ6gtkCULSZyQLIyilHaD1x
866rVYY+tJTnwwZ7DuR7zReZR6ogfmsU2jmoUpxKPpGUEkQ4PCD/QNRVFU77DBCn
n5mal7lb8upvimoanXw8sp7bUoZm8jRmrJPcdAGvJFzXtqf0GaVBOB5Krn9D4h3y
Z1hWVsu3jJSB/9CB6hmw
=XvWK
-----END PGP SIGNATURE-----

--ewQ5hdP4CtoTt3oD--
