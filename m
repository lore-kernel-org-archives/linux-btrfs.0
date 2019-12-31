Return-Path: <SRS0=DsAV=2V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D3EC2D0DC
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Dec 2019 20:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9686206D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 31 Dec 2019 20:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=miegl.cz header.i=@miegl.cz header.b="TFiWLVs5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfLaUJd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 15:09:33 -0500
Received: from ocelot.miegl.cz ([195.201.216.236]:46986 "EHLO ocelot.miegl.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbfLaUJd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Dec 2019 15:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1577822970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gTpU8IDvNFeza1NBRk3uC2RwpgpDwt3/z4XrxvkX0DU=;
        b=TFiWLVs51O20s8MWSCj/IIuuYEUcuBS1DCggOz+7spmpFVY6JeOjdyaL+Zef0LM0Znq0Cy
        eS+Cc4SBIikK7yuXUQTxRM2JJ420t1z6cQgH99p7yVLOmCZhw3/GixBiHvxJE5wJZShWTR
        /iy7VNPCj6nhlUfG/SMpJasEA4BDXOgKgXCUO0TuqN5CdCx1eRavh0NvMxp+cMRneutfWG
        S0u5hgazeO0iT8JFUwewaaz/ViafKt1ZLayHHdOPczdW3sGXtHpln5d+0mmHV4k/pWYuaH
        mE5irfyFxTWevga5Lh0rbc/A3jxTqcPE1mTFgw5I9pRKooE+tlDVJgFKDcojvA==
Date:   Tue, 31 Dec 2019 21:09:26 +0100
From:   Josef Miegl <josef@miegl.cz>
To:     linux-btrfs@vger.kernel.org
Subject: Re: 5.4.6 page fault while running btfrs scrub
Message-ID: <20191231200926.ejauiyeyn3swfvkp@t420>
References: <20191230123635.bpcei77hntjx4th2@t420>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5kk2yovqd3jsbcb5"
Content-Disposition: inline
In-Reply-To: <20191230123635.bpcei77hntjx4th2@t420>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--5kk2yovqd3jsbcb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Updating intel microcode fixed the issue. Sorry for the false alarm!

Josef Miegl

--5kk2yovqd3jsbcb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEhXfJKsVC4JYTeQttDVyVn2MnXf0FAl4LqvIACgkQDVyVn2Mn
Xf0jrwf9HCnB+A7VdUCeAKvT6PB0NmYmlwTveexKKFhrzaT06URl+iAlEX0STzwu
nMQJJq/tHF1X+lfCSjN5TGMrLZyoIziSbAKr4pNPwt0OKg72X9rDJot2rG+vuo1q
+OhXyKoWzreyKXp8EOs5pMmZb+ZtyW3d1WRchH6GaqBbkujkw3cUPZ/f+Z4Egzzh
fumncYp5AK/fpPmxnYSiVGwc7Q5iJQ9AIt6YQz5MJskwPqDdBSLM+8nTWKRqCWWo
L7NcF696CFtQ7mab+jWKo/A5eq3wVHXWxGAugWzUDZVN8JHrOHgOVDMjZ8iS19X3
PlGrjpHaCJs2MUwR2kz4m8hKY+h+lA==
=23Cz
-----END PGP SIGNATURE-----

--5kk2yovqd3jsbcb5--
