Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C780C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 11:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E28206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 11:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfDDLpt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 07:45:49 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:57508 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDDLpt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2019 07:45:49 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hC0oV-0004KO-5C
        for linux-btrfs@vger.kernel.org; Thu, 04 Apr 2019 11:45:47 +0000
Date:   Thu, 4 Apr 2019 11:45:47 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: IRC logs
Message-ID: <20190404114547.GA1084@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   For some time, I've been running a log bot on the #btrfs IRC
channel, and hosting the resulting logs. I'm currently re-assessing
the collection of things I host and manage. Baudot, the "official"
#btrfs log bot, has never really been stable, and is very sensitive to
being disconnected from the IRC server (apparently not fixable with
the IRC library in question). I think it's time to retire that
particular codebase and let someone else run something more reliable
for logging #btrfs.

   Is anyone willing to take over running a log bot and hosting the
logs? I can hand over the existing dataset if you want historical
continuity.

   Hugo.

-- 
Hugo Mills             | UDP jokes: It's OK if no-one gets them.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcpe5qAAoJEFheFHXiqx3kk7gQAJKfoKXEE8tWaKVlG+2E7G3m
GF2iikg6uZOfGC10nIuNA89+IPhgs8ClvQcZHzjK9OFPWnV+eQzUtYPyjkp5+exD
iAZ+z3Zsr4J7PMbP+8UBzK6JfWiLpg0G7ML7N9/zsXXJ05rcyoY3oDi9RCFigBLR
0AuRVdCOdiUrfArtFda91D1TOfrDCFpXi+H7DgPLqx8FQuMHVIjcu6YPetp+SSHa
JLUJetdJY0nQCUCUXkd/B1/jXnO/bj2gyOhChmzRkX3lZrzEeW95IAzdW1X1Kp5x
pqoGMXj7Cmomk7PuDTw8XLpf9O/caQs5ZCrrOsqWeSmGdPCQRmrfC3MTDhZhjQNf
al7RdzIuiodSlOkWwIe7GbYqbeBqA7r4DSQz79lQjHklyc4+3xldnHHw0rzCDnDa
e576nJrwYLg4j8xEbZdonnPPTxuDqS9D13ROLalQFxmC9UeDwV9sLxmMfSPyZMlQ
rv5t6HvizzxM+NJcJ4m4RY2bsaegCHHA5FKD6Wu+Q14FXBaShqQnWa2qgtpWtICs
JvnErZ6I3KLJKZhhvHniwBIwx9nVYJv5YVdB2ZeM5ZfejJiumQRh/DAVzk3qbPCO
9Rtz+FghYFr7eXtEVj3kO6W6wFMwHAvjX7fHL2qf878/sMdHBAHh/1TXOcqcqwOi
+i6w9IHguYj/BG+1bsG+
=8XVU
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
