Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:60020 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaCOFZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 01:25:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 05808D47F1
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 16:25:12 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 23159-09 for <linux-btrfs@vger.kernel.org>;
 Sat, 15 Mar 2014 16:25:11 +1100 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id 9D34AD47F0
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 16:25:11 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Date: Sat, 15 Mar 2014 16:25:05 +1100
Message-ID: <4448214.x9oPWjPhdL@quad>
In-Reply-To: <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
References: <1756989.4ep0Vdupld@tethys> <20140314192605.GD6143@merlins.org> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14688730.P4QsmHScsx"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart14688730.P4QsmHScsx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Fri, 14 Mar 2014 03:57:41 PM Martin K. Petersen wrote:

> The fact that the drive reports compliance with a certain version of
> SATA does not in any way imply that it implements all commands define=
d
> in that specification.

It looks like drives that do support it can be detected with the kernel=
 helper=20
function ata_fpdma_dsm_supported() defined in include/linux/libata.h.

I wonder if it would be possible to use that knowledge to extend the=20=

smartctl's --identify functionality to report this?

Not even all drives that implement it do so correctly, the kernel has a=
=20
blacklist of drives that don't and currently lists just two:

       /* devices that don't properly handle queued TRIM commands */
       { "Micron_M500*",=B7      =B7       NULL,=B7  ATA_HORKAGE_NO_NCQ=
_TRIM, },
       { "Crucial_CT???M500SSD*",=B7     NULL,=B7  ATA_HORKAGE_NO_NCQ_T=
RIM, },

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


--nextPart14688730.P4QsmHScsx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEVAwUAUyPkMY1yjaOTJg85AQIoegf8Dm+69eHv6XSHT7GY3GdCMKNuonRTBFx3
LNqRGWoNGCBA114PiKUxNyDAFXVizybPkEaoOxyZoAlixGBxLjgskQ5o9TvI1LQ+
R1dZnogCkAswqggoTQAjKETwDE8QQXBT6Rm3aVdpEarUzw6qHiDu8E7m5k4fKoYe
TSgh9Q4l00WbEr2slGUp/Z71AiCbgOj4Bel2O3V0u2gZM1RuPtDL843Ew6EInWaf
IYXmWBkCc4kvBH4OJrxduc9l4IOf4Vapu3YORnB467Yz28kSm4OEHd7hUPT3Zj42
Fw6jQj4keb7nvYXJIV2EPEJOf37CnbQsW/vWw9sNS+5xbl5445aQbA==
=kJtw
-----END PGP SIGNATURE-----

--nextPart14688730.P4QsmHScsx--

