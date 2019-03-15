Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0850C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6815A21872
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ej2l7uTe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfCOFi0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:38:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34271 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbfCOFi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 01:38:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id v12so5645327pgq.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 22:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RmudFSdb2x2mtvol4Y0DBxo8HvNTXANGIznOH1HBmiE=;
        b=ej2l7uTeUAri7mRDnsv0FHjAyurwwX1UkFLUO14LfV9/XqLYXQthbb1Tc+4sF7EUih
         qPVKr53VhFEiq57JZSRv2g27pXHcbIJ4iQIdVXT9sztSAQwHimSxSWG582svISqRSwFd
         TLR5snn+70A7NoG3RylCXCUgCwXcfJs4sfCs4yascI38Aqg6dj23ma1pHuS53u6FUF3u
         +rIc2OdTxSYEGw0/63iVNTK56AaDtB9HCNWbNcL+wAO1kLQPV7p+LmV1rocJxvXq551n
         TWFaDd9s8C4Hlmkb0gyL6pqhx/on8NucnU+r9FFG+3I1WezGRpErZj+8VrTWh6cW+6iI
         ER9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RmudFSdb2x2mtvol4Y0DBxo8HvNTXANGIznOH1HBmiE=;
        b=Bnss0KAYILRNk53R3pmWfmjcsrua8Sbc8/cXztdnKUA+eBmHuxLmDNG+ieyL3KPgWE
         zA8rL/qcZjQ9d0TYsy7RhGqc6gGrPPQUN1m3LYL5FBuqR2JA7ZT47Xta9qVg/byWYwQp
         pi8bLweJ422qaELFb+amxTeynX+aGMm6jMMVoD6qAzF+k9Dq0Ydq49HfAjt6D73ZDrqi
         jez5BtxUTTa2X2jNv1Ep4NXbpYlGpG6TR+tkiVJPo5SYWASqgRl4H0oRgqnSFXcvE5Zp
         jBGcwGZE4n2CCDuUM8RXj4UkvpvvvPL72FJjzLHGOEbDO/H33lkoXeEMUjncZNR1CzWr
         TpMw==
X-Gm-Message-State: APjAAAVm8ejJXIz5n6SyO6q3V5zW36ksvZN7vfq+A6vdn9TBwIjK7t65
        De1p8Y9e+Zrh3Rmond4xxF4sFiJYB80=
X-Google-Smtp-Source: APXvYqzhOvKY+/mADf1HqItYnftga19YxxucKnpMdOYLX0ZprtkSSfQlJ7vxGpHRO1EWWTmZn8AVsw==
X-Received: by 2002:a63:cf4c:: with SMTP id b12mr1681632pgj.316.1552628305156;
        Thu, 14 Mar 2019 22:38:25 -0700 (PDT)
Received: from localhost (d198-53-11-87.abhsia.telus.net. [198.53.11.87])
        by smtp.gmail.com with ESMTPSA id n6sm1194380pfa.3.2019.03.14.22.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 22:38:24 -0700 (PDT)
Date:   Thu, 14 Mar 2019 23:38:23 -0600
From:   Nicholas D Steeves <nsteeves@gmail.com>
To:     Martin Raiber <martin@urbackup.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: psa, wiki needs updating now that Btrfs supports swapfiles in 5.0
Message-ID: <20190315053822.gsqwah5dpp23uimw@navis>
References: <CAJCQCtQYezBhv0FvCineu9eTGs9gisyispwDD4wEe-CURVoTCg@mail.gmail.com>
 <010201697e5acc16-2345a495-0bdc-45d4-8363-d4397d9a7841-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fm35dnos5zmvk54i"
Content-Disposition: inline
In-Reply-To: <010201697e5acc16-2345a495-0bdc-45d4-8363-d4397d9a7841-000000@eu-west-1.amazonses.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--fm35dnos5zmvk54i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin,

On Thu, Mar 14, 2019 at 10:37:53PM +0000, Martin Raiber wrote:
> On 14.03.2019 23:20 Chris Murphy wrote:
> > If you install btrfs-progs 4.20+ you'll see the documentation for
> > supporting swapfiles on Btrfs, supported in kernel 5.0+. `man 5 btrfs`
> >
> > Anyone with access to the wiki should update the FAQ
> > https://btrfs.wiki.kernel.org/index.php/FAQ#Does_btrfs_support_swap_fil=
es.3F
>=20
> Yeah, and remove that tip about swap file via loop device. That will
> only cause memory allocation lock-ups and is not advisable.
>=20

Thanks for additional facts.  I've quoted you on the Debian wiki,
since Buster (Debian 10) users will have linux-4.19.x, and ought to
also be more firmly dissuaded from using swap via loop/virtual block
device.

Cheers,
Nicholas

--fm35dnos5zmvk54i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlyLOk4ACgkQWogwR199
EGFNMBAA0xfuEzhM/zRllO32OFII2jiwDiVdk/v7SwrrCFs15uDl8fcdyAU4vRLl
Bcu/GV48FVeXzGyS3768zHXqY1CJEpF9bJ2empBmO0kJggffoXBVMdtFRaxPoPD6
5G64yiMSw5Q6eOzzju51oj5UZNM0UUysfEEdL9bYZ9x/Jf2lr4OZdgh1CwQUugKF
5Lg1aTcvh2twKDAmK194jK2GOsRAOagy4VXqJlCYiYabI7vTPvVVXDWjL08wDRkT
+wIQ7HK3RJxRnBu8m4qVapCKl4TsO1D2THJ09oLdXF23DQpsuOBvqCtOJedkCtA9
HdFyrWww4REVOA1/SrQ/kwjESXFGu6m+8Nr0tyFvL5La7JeJs3XnVgU9kcRtNXl+
00b2uvyQy8CgEPVI/Vr20mDy9qPcUiX+Y90iexBeZxWsa9qwbnY71+P5D3Cyi843
T0fQ+0XMMUdIp9YAMeOnKsFUADKUU3PZf9EQncJGKm8GzOW9QHJSh1kC7+Jv1CLj
j9fpljLmUbhD1dxHoQzCi79Un4M/VEeXmg36cOH6TBWTVVudB2HjILWNDMma0Q5P
A0UIvmKBWmPOfRwVGb3hdwDKY5TrjxOOcFYyHyyPdoc9ZaMwXzR5EYf/iWSRRhxd
RY3V1AtL58zqwvUN2n1pM4cLyzlpxm2xUv3I2qSdNkaQqsbBgco=
=B6L/
-----END PGP SIGNATURE-----

--fm35dnos5zmvk54i--
