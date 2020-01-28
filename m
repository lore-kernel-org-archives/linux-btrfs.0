Return-Path: <SRS0=Obef=3R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B8DC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2882173E
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=integralblue.com header.i=@integralblue.com header.b="oJFX8izR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgA1Oqs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:46:48 -0500
Received: from smtpauth.rollernet.us ([208.79.240.5]:48997 "EHLO
        smtpauth.rollernet.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgA1Oqn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jan 2020 09:46:43 -0500
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
        by smtpauth.rollernet.us (Postfix) with ESMTP id CB06B2800075;
        Tue, 28 Jan 2020 06:46:39 -0800 (PST)
Received: from irrational.integralblue.com (pool-96-237-186-35.bstnma.fios.verizon.net [96.237.186.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by smtpauth.rollernet.us (Postfix) with ESMTPSA;
        Tue, 28 Jan 2020 06:46:39 -0800 (PST)
Received: from www.integralblue.com (irrational [IPv6:::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by irrational.integralblue.com (Postfix) with ESMTPSA id 25169559DBE8;
        Tue, 28 Jan 2020 09:46:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=integralblue.com;
        s=irrational; t=1580222795;
        bh=VS0TYh3jeQNl/6Xr+W3fyDhn45Mlkl+fYnNpivtRoPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=oJFX8izRcDFOMHDvX2JWTXSjvKB2Jmmb53H/rn6YaZnhpApFab0QRwHUqJoO4pT5q
         TDbNzNHDGabZY7q1cMNOtXYimtEorbkx+WqzKFP16LWW3H/9V4x21Z0TSxGV8oBAhT
         IaSVfEvrBdahqT3swS3OQpNI0dEE9RtHeHKQuR14=
MIME-Version: 1.0
Content-Type: multipart/signed;
 protocol="application/pgp-signature";
 boundary="=_6247bb960cba2591fa84bc6a98584d4d";
 micalg=pgp-sha1
Date:   Tue, 28 Jan 2020 09:46:34 -0500
From:   Craig Andrews <candrews@integralblue.com>
To:     fdmanana@gmail.com
Cc:     =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs2@lesimple.fr>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Regression in Linux 5.5.0-rc[1-5]: btrfs send/receive out of
 memory
In-Reply-To: <CAL3q7H4-3Mg2GUf2JMMFem77sSQR5opN9dxdvHz2kk1Qd=RD=A@mail.gmail.com>
References: <5ba0716449eb4f838699fc0b1fb5b024@integralblue.com>
 <20200113133741.GU3929@twin.jikos.cz>
 <7e7e4f63a89b6bb8a270d4c4ec676835@integralblue.com>
 <8254df450ca61dd4cbc455f19ee28c01@lesimple.fr>
 <CAL3q7H4-3Mg2GUf2JMMFem77sSQR5opN9dxdvHz2kk1Qd=RD=A@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.1
Message-ID: <06639bb0a512aff6ed8a41bffb033f35@integralblue.com>
X-Sender: candrews@integralblue.com
X-Rollernet-Abuse: Processed by Roller Network Mail Services. Contact abuse@rollernet.us to report violations. Abuse policy: http://www.rollernet.us/policy
X-Rollernet-Submit: Submit ID 70bf.5e30494f.c61ed.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)

--=_6247bb960cba2591fa84bc6a98584d4d
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

On 2020-01-27 08:44, Filipe Manana wrote:
> On Sat, Jan 25, 2020 at 11:18 AM Stéphane Lesimple
> <stephane_btrfs2@lesimple.fr> wrote:
>> 
>> > ERROR: failed to clone extents to var/amavis/db/__db.001: Invalid argument
>> 
>> If I may add another data point here, I'm also encountering this issue 
>> on a 5.5.0-rc6, with the btrfs-rc7 patches applied to it (so as far as 
>> btrfs is concerned, this is an rc7).
>> 
>> On the first time, it happened after sending ~90 Gb worth of data, and 
>> aborted (as I didn't specify the -E option to btrfs send). Then, I 
>> retried with btrfs send -E 0, and it encountered the exact same error 
>> on the same file.
>> 
>> # btrfs send -v /tank/backups/.snaps/incoming/sendme/ | pv 
>> 2>/dev/pts/23 | btrfs rec -E 0 /newfs/
>> At subvol /tank/backups/.snaps/incoming/sendme/
>> At subvol sendme
>> ERROR: failed to clone extents to 
>> retroarch/x86_64/cores/mednafen_saturn_libretro.dll: Invalid argument
>> ERROR: failed to clone extents to 
>> retroarch/x86_64/cores/mednafen_saturn_libretro.dll: Invalid argument
> 
> This is probably the same case for which I sent a fix last week:
> 
> https://patchwork.kernel.org/patch/11350129/
> 
> Thanks.

I applied that patch to 5.5.0-rc7 and that solved the problem. I can now 
do backups (which is a send/receive) successfully.

> 
>> 
>> The send/receive is still going on for now, currently around the ~200 
>> Gb mark.
>> 
>> Bees is running on this FS (but I stopped it before doing the 
>> send/receive).
>> 
>> I can test patches if needed.
>> 
>> --
>> Stéphane.

The patch appears to have fixed my problems - thank you!
~Craig

--=_6247bb960cba2591fa84bc6a98584d4d
Content-Type: application/pgp-signature;
 name=signature.asc
Content-Disposition: attachment;
 filename=signature.asc;
 size=195
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRXYh1D8NS5wgKWveFHeNF+DbGKQgUCXjBJSgAKCRBHeNF+DbGK
QjhcAKCZqZEzVhoNmjGWAeWKPivfi5WVLACgol8jksaTp2Tb22EKIOR9zkm4YWw=
=WQrn
-----END PGP SIGNATURE-----

--=_6247bb960cba2591fa84bc6a98584d4d--
