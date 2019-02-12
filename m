Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C18CC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 23:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C882420869
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 23:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="UnNOjLkp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbfBLXun (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 18:50:43 -0500
Received: from mail.seblu.net ([212.129.28.29]:57668 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfBLXun (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 18:50:43 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id C34A952FBAB2;
        Wed, 13 Feb 2019 00:50:40 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id Wmhxvg3B6HZo; Wed, 13 Feb 2019 00:50:40 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 34BF652FBABA;
        Wed, 13 Feb 2019 00:50:40 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 34BF652FBABA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1550015440; bh=IjZcVwv5XnLD+siMTHy8g/zW4HyDIRGKue4tTvJNfRY=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=UnNOjLkp5AlY/+IzzFhtDqOtnwnUxUxSp99T3UhrgQUxka3U6/wqeIckz7fxl5JvK
         JmyVt9mjLqSAWCAgihwRck6k70GmHyH6ddc89COfrwBxZMAZeLu5ki30ItTof/x4Gt
         OmRBWcAV+/LaFjeEt6mmwh3yu9B3li/x4wt3uSiSi/qABR+Xp3AnQwHZxFEAfrZIc6
         jvuNA2GMSyISduHGvd2CDFXU63fm8YqljqhQ1U97SV8tQClwdEmugB0UE0twqg71Fa
         Y5pRaJJv0GsCNP2ShvvqZmTtu0o08eJwOSDWUbgTq5DZ6AVibNsN4l35fFCVtYqby8
         HuvY9X4XlaSPQ==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id jBXFtjAUYSJe; Wed, 13 Feb 2019 00:50:40 +0100 (CET)
Received: from dolores (amontsouris-684-1-71-1.w90-87.abo.wanadoo.fr [90.87.54.1])
        by mail.seblu.net (Postfix) with ESMTPSA id 0EBF552FBAB2;
        Wed, 13 Feb 2019 00:50:39 +0100 (CET)
Message-ID: <d9a44122e928f3a6cb03391364f63b7e1a49fafb.camel@seblu.net>
Subject: Re: Corrupted filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Artem Mygaiev <joculator@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Wed, 13 Feb 2019 00:50:39 +0100
In-Reply-To: <CAJwc6KuhZuHve3FLbTcfbKUL8=WXmHN=OWnvDPJc4=pZQJsHWg@mail.gmail.com>
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
         <CAJwc6KuhZuHve3FLbTcfbKUL8=WXmHN=OWnvDPJc4=pZQJsHWg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-s+Csd+qKC7AkDNaZ0b7r"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-s+Csd+qKC7AkDNaZ0b7r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-02-12 at 14:31 +0200, Artem Mygaiev wrote:
> Have same issue (RAID5 over 4 disks):
> https://marc.info/?l=3Dlinux-btrfs&m=3D154815802313248&w=3D2
>=20
> Having perfectly healthy HDDs it seem to be caused by some bit flips
> in SDRAM which is non-ECC in my case, unfortunately. Tried --repair,
> didn't helped, same for --init-csum-tree. Now using fs in ro mode
> (data is fully available), preparing for total rebuild.
>=20
>  -- Artem
>=20

Thanks for sharing your misadventure. I'm a step ahead from you, as this is=
sue
is on my rebuilt btrfs filesystem. =F0=9F=98=8E

What make you think it could be RAM bit flips?

Regards,

S=C3=A9bastien "Seblu" Luttringer


--=-s+Csd+qKC7AkDNaZ0b7r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlxjW88ACgkQShr8NF6+
GPhbUg+/Quh6ZZRtqvrBIyJ8PSUaO+ZgtszGm/o7zzL/1w0g2f12spTAjnZa1oW/
NpZwSDFoe1308WmEs87CNX9DJewag6wFzpMMwB0bt0QtQ7tWDWWnUKQd2rlg/ohW
1RGZQBMWuYYew6WX1YfZ4daCeAaMEjL18K8nmDXWqL4xhqczRMjkohXDu6DqowaH
Ti1uO8bnEHbEEc3RB4Hxb8jLOf7qMHe0YQ2iqJJmJyYTmNDWNzHP9vmRAXSC+lyi
M6pVAHiyl4DVQsM0tFXKd93WPca/4csv4hkEDQxkMrE0uex+yH/4AlE/cfmC5b5l
xM3Cgnq24FmA8AwlcXTua7U4/BSm/LXlN3LveYCSUP2uazns0/dN2xpV/A3gUl4C
/CpmCwkORrakef51EXT8mcaqxNeJGZBKMStb4x401/tQ8LsGRT6neqMCM8dM/wWQ
AUtCrlQlUXUqlL4EOh03bBsyI9zITFLAPRnLUs0iTZBi15aJoHtqC7loCDkNLEYu
11rYqPzUiecavtu+OqrSmc3+X8DyB4ikVZ8ft+mwat6/LF2B5/DjiIvwIaOXS4yu
UdTyNZhxLgtqXrZSgNIKN2WCUj4+cT8MKmWCQkZbaQa5NsncamdQCfwp+OF2wEWP
Y3FwAJPjtdodQN+IMnBmx/3J8UMvHprHhrDhFV0V
=Bevy
-----END PGP SIGNATURE-----

--=-s+Csd+qKC7AkDNaZ0b7r--

