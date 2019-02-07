Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D05C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 23:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 946D82175B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 23:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="nGHARcfJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SmMDUh1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfBGXCW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 18:02:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42151 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbfBGXCW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 18:02:22 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B5AF820DC2
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2019 18:02:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 07 Feb 2019 18:02:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=obkuDBPpplECO5S78u/McbkQ/oq
        i8jmDz8LF7rzWyIc=; b=nGHARcfJa9XidDsoymdl/DYCROOtPGcyQ3nvMSKQ2aI
        Sj6xlI75iWt94spPiYlQ3CTa6Q6xttoCPDxkgBtyVF3cEkVXBt+mB82mZCTk3OTc
        bnFb+pzWKdPZolGpIU1tKfihUbK4jYOfvpHZb0c/7QtJBucxeLEAA2xh3UDwUCm8
        gNZCL7oaXv469VSbux3gipnYghFY4sUYe462RE6xs7hVolEjVotxm7VwMULMVRBs
        kcARP2uz1CS/AoOomHcJRqzIE/XT0mlbMYrkkEIGD6l+4572ztdgBDU78MKkJHAO
        2QK4uzZZBp4cW1fu+JU9uhiD2F8ODhNKufYJEy15k9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=obkuDB
        PpplECO5S78u/McbkQ/oqi8jmDz8LF7rzWyIc=; b=SmMDUh1QegVcmTmKejif4t
        N3N8ZG6DYVLNwCNOQCcT8nu1hWT/MSYblAF+wxDhfIu3+k9nix8kBdhMI0QZ/1sk
        3hLI7HX3r8jnlEEiimrux3uDQqiWttWUFjB9L+IPWLM3BVyH0fe6IQF1UabzeLuO
        2sHqGk3MgihCQdgd86a144oJD/p/ukgWYHRhtOhdKNN3cHHbXhLqphs+2WP+NpTK
        Q+3CI7DvqDMUau7obBfNVSjWegK2j+uxoF8Axw3DWZpnj/XB8UxdmXmJUTHW6zQo
        2bfw2gAhuwVTsVJ5lQ/eTHJe2JcjGLh90zZ7vnk1WepClc90DgU8u5qHP/vI49ug
        ==
X-ME-Sender: <xms:_LhcXO2LfIpJ9cWspiaqmkDtbp7bZApAxDkvmFwLh5gQXCgT7rAQoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrledugddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffg
    ggjggtsehgtderofdtfeejnecuhfhrohhmpeftvghmihcuifgruhhvihhnuceorhgvmhhi
    sehgvghorhhgihgrnhhithdrtghomheqnecukfhppedufeehrddvfedrvdegiedrudefud
    enucfrrghrrghmpehmrghilhhfrhhomheprhgvmhhisehgvghorhhgihgrnhhithdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_LhcXKlkq5w9ycJw9EGO8dPUGWvCabbn4bCFNHRPbwIsAzs5ZWh8VQ>
    <xmx:_LhcXLLe6D1AVYDKBLxeOqpod2SCsbdqyFSYcQ-avWSO-Wnowwymvg>
    <xmx:_LhcXHYI0KqTDnfMsnNHD8lIw6KNEiP9j-DIPL6PmluCSamMneB-Qg>
    <xmx:_LhcXPxVq6t4JlK3DDHuxL6kaF9rmlo0fOJUYduIYAvEOdwYafJIVQ>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id F4007E4438
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2019 18:02:19 -0500 (EST)
Subject: Re: btrfs as / filesystem in RAID1
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <33679024.u47WPbL97D@t460-skr> <2159107.RxXdQBBoNF@t460-skr>
 <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com>
 <2840929.O1qc6pvfHa@merkaba>
 <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
From:   Remi Gauvin <remi@georgianit.com>
Openpgp: url=http://www.georgianit.com/pgp/Remi%20Gauvin%20remi%40georgianit.com%20(0xEF539FF247456A6D)%20pub.asc
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= mQENBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAG0IVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPokBPgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRrkBDQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABiQElBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <60d1710a-8b4a-1060-8a3d-eafedcffbcb7@georgianit.com>
Date:   Thu, 7 Feb 2019 18:02:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CfEwypR3jeV9Nbr9tZzTgpvuzaOy9ZPjQ"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CfEwypR3jeV9Nbr9tZzTgpvuzaOy9ZPjQ
Content-Type: multipart/mixed; boundary="zgD3YRVJWWTz21v7buG6BaheDzFNexhUx";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <60d1710a-8b4a-1060-8a3d-eafedcffbcb7@georgianit.com>
Subject: Re: btrfs as / filesystem in RAID1
References: <33679024.u47WPbL97D@t460-skr> <2159107.RxXdQBBoNF@t460-skr>
 <CAJCQCtRuUBfhXQGr29hmOU1mW1wU2jSvr+dun72NAw3O28=cyA@mail.gmail.com>
 <2840929.O1qc6pvfHa@merkaba>
 <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>
In-Reply-To: <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com>

--zgD3YRVJWWTz21v7buG6BaheDzFNexhUx
Content-Type: multipart/mixed;
 boundary="------------E570080023119F9C25AB521C"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------E570080023119F9C25AB521C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-07 5:19 p.m., Chris Murphy wrote:

> And actually, you could mitigate some decent amount of Btrfs missing
> features with server monitoring tools; including parsing kernel
> messages. Because right now you aren't even informed of read or write
> errors, device or csums mismatches or fixups, unless you're checking
> kernel messages. Where mdadm has the option for emailing notifications
> to an admin for such things, and lvm has a monitor that I guess does
> something I haven't used it. Literally Btrfs will only complain about
> failed writes that would cause immediate ejection of the device by md.


You can, and probably should, have an hourly cron job that does
something like
btrfs dev stats -c / || Command to sound sysadmin alarm

the only difference here is that this is not, at this time, already
baked into distros by default.  I think I saw mention of a project
recently to to build a package that automates common btrfs maintenance
tasks?

--------------E570080023119F9C25AB521C
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------E570080023119F9C25AB521C--

--zgD3YRVJWWTz21v7buG6BaheDzFNexhUx--

--CfEwypR3jeV9Nbr9tZzTgpvuzaOy9ZPjQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcXLj7AAoJEO9Tn/JHRWptCHEIAMchLwRFtQbVtb16g7s+XFwL
IY1x7iyn5bFy1OR0Sfau7EQQxpBC/wnhQcEIWGxyU8HvN0vOt3IAlil2d1J5lmho
HrVHwxreIEK+AhXvWcpZBz6XUMmqAJSoXVfuTXBYr7EDUplbfykTJyQrk7BCkxwD
NqUgZfsRIxiRhQ8oGhIBuhXx5geCHrUXE4Ea2oaG7DRucZxhlrbr5H/yh888DKMl
t07/9SL0Wxy5eG3ql8uq9I0s+iC6sa6vfIzfWlK0r+jLgbAcV/u2ndP+81XjIY7x
+sn8EDfVXBCr7dM5Y18QKvZutVOSXRHEjvu7r/kdgnjkUhY35lxWVvDNHah4URU=
=kDYv
-----END PGP SIGNATURE-----

--CfEwypR3jeV9Nbr9tZzTgpvuzaOy9ZPjQ--
