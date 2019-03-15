Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D30AC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE2821872
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk1EwukB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfCOFfx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:35:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41302 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfCOFfx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 01:35:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id d25so5483915pfn.8
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 22:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zQYOSlbyOep1f3dkRz/5laerR7Q+F5yJn8fHukmCodk=;
        b=Nk1EwukBnXoaHB82P5MnGQajy+F/hODv79wsBtBotAR5lsKgmesPiAxR14DXfdyqn5
         bt5beKd/Ip+/wCsjardEmHkiVv1NDoBUQ9SH5l71GybOSCmXABAdq/zOMJeSaeO3WWCR
         NNAEt4XaPfDEEheD01b/OLkdlSyod28e/xtVL5wgUa7SZub8AN2jA4GP8z8eDNJXm3Rd
         XvkEJ98zQ6jCotXeUF6/EOc1gjeDYpQ6K6wte89s5GunWppdkJSEOIEoSIBpwg/oV7uD
         OcKBLj2aFUbLt8I0OL76kh8AE/QTeEgEoAryKgSzOcDuc8w+FnN6O5Dsz3LuOl9HDh6g
         Tw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zQYOSlbyOep1f3dkRz/5laerR7Q+F5yJn8fHukmCodk=;
        b=eIMec39NNcO4TqKuHtC6Fcg6ZcYbZLNNfa8OefOUI+VsQ0+7hNOg1zdxdx+LNNnghx
         VFndhqys5KTumnJPRXeQXGoZzC7FSqUM+lcOvcMFf1CmHnE5yo6E1CclJ1ClMOqSHMMp
         LLpBpbwZTGBNL9pHDncyC4kytC3dN6Ham8DQBhM/sl4/g7QBopgic3laQb1PuOT+71yt
         i2pRFBChI6m/ItssXJ++EA27Vrb4pc8p3TAGP0nfiQhyb6a807e0KxaiHrtuQ+OPJV3W
         1XgUrVO9CC7JRXcC4NNXH1uDtn+uCimL6hT0GuPPHOKa5zlLVNFKcmkddhc7nlf6qMiw
         fp6w==
X-Gm-Message-State: APjAAAUmpl1L08bgkdplwp4Fe+DuHMubFJtR95klnWLCelObnageWF46
        mLcTXpDow4fq91ihzzhyKBtAKxppD5k=
X-Google-Smtp-Source: APXvYqx5mWFRXbgHV4ak4FIQENP925vhSNWaxp7I2fmcjJrXXFBtnsjIjQMDPNir0is2JRPDWGQJBw==
X-Received: by 2002:a17:902:bb0c:: with SMTP id l12mr2300128pls.108.1552628152032;
        Thu, 14 Mar 2019 22:35:52 -0700 (PDT)
Received: from localhost (d198-53-11-87.abhsia.telus.net. [198.53.11.87])
        by smtp.gmail.com with ESMTPSA id x1sm1205938pge.73.2019.03.14.22.35.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 22:35:51 -0700 (PDT)
Date:   Thu, 14 Mar 2019 23:35:50 -0600
From:   Nicholas D Steeves <nsteeves@gmail.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: psa, wiki needs updating now that Btrfs supports swapfiles in 5.0
Message-ID: <20190315053548.hvwixck5yun3uzox@navis>
References: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4k3tavqqa4oiucca"
Content-Disposition: inline
In-Reply-To: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--4k3tavqqa4oiucca
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris!

On Thu, Mar 14, 2019 at 04:20:45PM -0600, Chris Murphy wrote:
> Hi,
>=20
> If you install btrfs-progs 4.20+ you'll see the documentation for
> supporting swapfiles on Btrfs, supported in kernel 5.0+. `man 5 btrfs`
>=20
> Anyone with access to the wiki should update the FAQ
> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_files=
=2E3F
>=20

Thanks for sending this email!  While I don't have permission to
update the kernel.org wiki I've updated the Debian one, so this is
documented in at least two places now ;-)

Cheers,
Nicholas

--4k3tavqqa4oiucca
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlyLObQACgkQWogwR199
EGEOcg/6A/2EcN4g68AtCdYNVJIkny8o0Pt4/W/yEHDkZZHtKG+S88v+uppolc7g
DEeTRMNeb8EfV3dQPPrAhoUQLuhQIvUQCcjONmcPwg7ZgruMA8ZYFa9Qk8HDT8Vo
Xd1q6PkYW/JyrHA2lmHfepOoqwFOjpgbzwlBwAv5DiyhwYtsp6OYcnR8G0NsoOQj
VAXMRwMzyQWhS1/1XTBKcZu0Hv35eT+Yo//Z6eXZ/RH7wIAdUve29mH2v1rS5LYI
FnRAWRy2OLpOa05Nxgr+lXNPPFma+RKRmvCFe6hSNKUCryMolIIZFXoaTIV0Mr9d
MW852t81LnE0U8mraaPH9O2utLlXnGFJPKTtpBMC0U2ZDfRG/OOD92DAi7PLhnRo
K/fynCt/uOd6cJW2PVvgCLB1l2DFOMCDR6a4VNdSRugR31bpLpz+720qiRYzYGHr
pZY3Ms8Mw9cgRlJUJ2ebSqs8ke7j4Avkey3urBaj8NVTcAYKDTQukuekUx3H0fFe
qbmZi2iviiSCvApXjsXqft0SX2KGdKj0sXNend1khTbbQ6pqvaVNjknh+ofVdqiQ
YHJLO3ZT2MIAwcqLWCsoltTtHcbbeP69bjN16gdNBzmF9C0i35EKxZQFkqQ6qhu1
/rbwEY324Ei2YN85XpKvAslpGscdwSak0shPgC8EIkJyRXNFJgA=
=IoJQ
-----END PGP SIGNATURE-----

--4k3tavqqa4oiucca--
