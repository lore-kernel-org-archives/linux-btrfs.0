Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96412C282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 19:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F5E120870
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 19:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfAVTpp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:45:45 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:35991 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfAVTpp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 14:45:45 -0500
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1gm1zS-0001zf-CO; Tue, 22 Jan 2019 19:45:42 +0000
Date:   Tue, 22 Jan 2019 19:45:42 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Incremental receive completes succesfully despite missing files
Message-ID: <20190122194542.GP5134@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <CAJCQCtScPtJ=agTJbunPG9GT4hQg5VQWMOEM_JAyLseNKraqNw@mail.gmail.com>
 <f3075aa9-d475-43cb-45eb-e02acb1d2868@georgianit.com>
 <CAJCQCtTeiWKnBM5+7L+1PSqL+4aXLyYeK3A=GEyk6=gr1DUj0w@mail.gmail.com>
 <72d097cf-e4b9-80bf-556d-422767ee0376@gmail.com>
 <CAJCQCtTnyTV=Q=vuF1Rg9EK3=S9C_sXf85r6u44UZWtwR3ayLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cmVHo2jXx4bdYlgS"
Content-Disposition: inline
In-Reply-To: <CAJCQCtTnyTV=Q=vuF1Rg9EK3=S9C_sXf85r6u44UZWtwR3ayLQ@mail.gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--cmVHo2jXx4bdYlgS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2019 at 12:37:34PM -0700, Chris Murphy wrote:
> On Tue, Jan 22, 2019 at 10:57 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> > "Related" is in the eye of the beholder. Clone subvolume, delete content
> > of clone, reflink content of another volume into clone. Are original
> > subvolume and clone related now? Clone still have parent UUID ...
> 
> I'm not talking about -c option. Just -p. Conceptually -c is even more
> complicated and effectively supports multiple "parents" as it can be
> specified more than once.

   I tend to use the term "reference" for the -p subvolume, and the -c
subvolume(s).

   Hugo.

-- 
Hugo Mills             | The future isn't what it used to be.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--cmVHo2jXx4bdYlgS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcR3LlAAoJEFheFHXiqx3kr00QAK9QofgdXSSD4nx30k0JCfPg
JlhcL3NfzQ164hStp6Ecg2quE/InJ29t6Bi46s5bNldl97EXV2RLWmhYRzaTimyV
w715XH98q0URj0Ib23gL3D83QxuTBVLPeDn/JeMVXP7nN3XrHIZ9En2In8liLZn4
mrsYukgKX53aC16ffG0OeRAcx3WAb5eFALLA08bGsWOqsPxoTaIwscG01eyzl3U8
uBLHNBZ2JkKPawTdh6qMB5KMM6YO0Os5JPShrdSn/Qm4soPBCXfZM2ygsJUwP3Kd
reh/bXvZDRjMh7XSUgPiCo3KDW0ZgiYiLlQXeYAisQEmnwSmP5wgeTJVAZC5+vqe
inNCbqCJsGnZt0u9N3n4C2Uyl63AN38MeK5BP1qH/ZhUpzcxV2FVWVlHBjfos0lP
mFAIWReWZy/F/vKCgG6PeKFR4bvcgxRwHSU0iRNT90wMvQ6ooDs6wqxVLOzeIhpM
0b9//S6+9izQQZRO5fSPe1xXzx2g/cf9kAgPGeJBvkkuNUL4oQdm0crG1TRtkGN2
7NtP2hSOcY8VN9GMJiyd/XY4RbM2BAqDDgEUHBnsRb7qiVu9Az1sRznirUIgpN+S
ga5Ku726M4/Wd9Z8n0aoN5ZoRZV6ZnzQ0xpiOhYB4/q13MFbKG207TZ71EJ6EHZr
xdwj2py+jPpzFbvy++7a
=Du76
-----END PGP SIGNATURE-----

--cmVHo2jXx4bdYlgS--
