Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A344C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 15:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB79020675
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 15:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387934AbfAPPg5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:36:57 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:39205 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbfAPPg5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 10:36:57 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gjnFP-00014Y-AN; Wed, 16 Jan 2019 15:36:55 +0000
Date:   Wed, 16 Jan 2019 15:36:55 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Stefan K <shadow_7@gmx.net>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: roadmap for btrfs
Message-ID: <20190116153655.GK5134@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Stefan K <shadow_7@gmx.net>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <2488171.qjqVUjIhQd@t460-skr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibq+fG+Ci5ONsaof"
Content-Disposition: inline
In-Reply-To: <2488171.qjqVUjIhQd@t460-skr>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ibq+fG+Ci5ONsaof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Stefan,

On Wed, Jan 16, 2019 at 04:34:15PM +0100, Stefan K wrote:
> Hello,
> 
> does exist an roadmap or something like "what do first/next"?
> I saw the project ideas[1] and there are a lot of intersting things in it (like read/write caches, per subvolumes mount options, block devices, etc), but there is no plan or an order of ideas. Did btrfs has something like that?

   No, there's no such thing. There's not even a concrete list of
what's currently being worked on, or what people are planning on doing
next. We tried it a while ago, but there was no good way to keep it up
to date.

   Hugo.

-- 
Hugo Mills             | Anyone using a computer to generate random numbers
hugo@... carfax.org.uk | is, of course, in a state of sin.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Jon von Neumann

--ibq+fG+Ci5ONsaof
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcP0+WAAoJEFheFHXiqx3k+VcP/19kJvVGMxn18SLUC5PUQO9T
o54d4lne/sZovvH3r6p7y3JnW9Lm+XRDVAxiiYp3oK9AhPX8nHXq5XUD4NySJAlq
31/mujwXJDY/Rl+ApvgaKpNyTIygRzCtOLXYi1mgB/vC9UyZH4S+rYqqNFxRx4I6
pX1RRLp31ASF4jBQVW+GjVWYbrDNOxIR6ROCfakUbuetx0J2lSI2cVwZchco22zS
JOrzgyhUeKhUaCT+DGD8hsawt4JX/J/nF+9eDEBZ9lvQrGFGQxvtZdyihkGaW8kx
AbEKLPfVitSdnAs8tAuSpYcmtcvKHoi319/lfczIeNA4x+cqa+m8sf6Wa6Yj4Yj4
ASPdjsjIk3F1nIa/g2Y0PVrBRRBVRLuQ7vqRdQKuNktf24w5WTlEKEuQstCvpx57
/gSsRKkHmRWmJljkjIzc628q96hnmf5Z8sg2plKCIXyW6HhuMv2X66acCfOirAxA
feyKkmMHdg98181nPPWHMAgPzm9labY252sTSjRsezfWlL+WPkXZdTzSVOhj9gzX
IVnF7OXidNmE2K/zHDpxfFk1CwPlhvByHr7rdm9bWZ1pewWGvy8sseBNHvDWzP5h
/NXYyzskbY1slhj796tVXVMKPyyIqNerB0uqSmOu2UVRNXrJD6q+ma50LTlZ+fV2
cVByoqhbnVbC0/+5DtT8
=TLIu
-----END PGP SIGNATURE-----

--ibq+fG+Ci5ONsaof--
