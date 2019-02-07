Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66272C282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 21:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A2C21721
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 21:22:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="opx5KvNG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xLnp6ZKO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfBGVWA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 16:22:00 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33903 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbfBGVV7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Feb 2019 16:21:59 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9455E21E9E
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2019 16:21:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 07 Feb 2019 16:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=swJOXJv1fuEwlWWd0fQDocQI120
        L3wAf4IJkZNYrRPY=; b=opx5KvNGk0YpGoXNF/2Fax1cPuN9+/fvxZ9MEHJK4C7
        Uy0W+wM2MwgMJu2RbjbGn9S3BqWpj0crSzeVn8lk2Ft9vYuZmXDaE5UmhBV6QcCE
        6ZMfZhYke3ZZ1FlaLDKsJ6pgCNvl3xwVR8YuYjUNR+UGUCzKXl/1tnZyt5OpUlZg
        jE8fUdO2KFp3pddDukDjLjZ1jNZXib4nOkBkU378jL1ZRD7iQH4tmjQYi4XflENA
        otzXSj553Jl31z1U6SNmUE3cllwgrVR3UR2iEbpgQq+kbRlQazqaIL+OkxgU8opJ
        JWpH66VMbPwTxfrw+IRZ1RCh+5TBS/mQQHLCCo1NGnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=swJOXJ
        v1fuEwlWWd0fQDocQI120L3wAf4IJkZNYrRPY=; b=xLnp6ZKOvIXHrNELxyOor7
        vSHwog0slFy3DEw+zEls65N16EdZNzjlG13YcqtzhgkExAbh5ciYLa6JGhavFXhr
        qmjpbeJW9E912WBP9qGB0Y54oVVg/N00nNyghCrXdoJ/fqh2+JyGmqaD/MZJkyrp
        7mexBgmH5giHlKD5ZWpJeSsnHObMApvXzTDYNH8PEG4YbDDHS+Gia5JbvWwK3UN4
        vt+Rk4BZKuYEEPQU3RrRm82Xj9LDqBBxKOhcjE3etS7IpEoP3SXaa1HVY1azeenz
        6LkFkVCfVE9issKeJY/fq3Y4eEzvF5Mvt41UB0u4YlU0be5ihkZD1HpiujTRMnZA
        ==
X-ME-Sender: <xms:dqFcXHSTAIPxvE7F_H83FrGHv6i391PlTZYPnKH9K608pRbbM5ncOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrledtgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecunecujfgurhepuffvfhfhkffffgggjggtsehgtderofdtfeejnecuhfhrohhmpe
    ftvghmihcuifgruhhvihhnuceorhgvmhhisehgvghorhhgihgrnhhithdrtghomheqnecu
    kfhppedufeehrddvfedrvdegiedrudefudenucfrrghrrghmpehmrghilhhfrhhomheprh
    gvmhhisehgvghorhhgihgrnhhithdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dqFcXPKWy5DcitFWQqpbqc9xFOabGSLzpppiHCtQB3UlHutCCX9lhw>
    <xmx:dqFcXBixCtzthfD2TOwYtedJlEDNMIQ4TwH0U3rni6-xAeiBbZASyQ>
    <xmx:dqFcXKIdazDAPIaJUW8EonpL5bpQoy4LlifH__P1Mts6QSx08L-gew>
    <xmx:dqFcXLfa9FuK6O0QwRuQHnj3WvbEuOPTVXfpzficSG3NNmEix5DmjA>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8EB56E454A
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Feb 2019 16:21:57 -0500 (EST)
Subject: Re: btrfs as / filesystem in RAID1
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
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
Message-ID: <f43e21e6-a399-5dfe-e24c-fd7938e13ad3@georgianit.com>
Date:   Thu, 7 Feb 2019 16:21:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RvurNLonvN1RukS2En5hyV6jLxQrY3B6b"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RvurNLonvN1RukS2En5hyV6jLxQrY3B6b
Content-Type: multipart/mixed; boundary="gLdRJifIV9TQifhh2RcdtHasiVIjPIjRV";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <f43e21e6-a399-5dfe-e24c-fd7938e13ad3@georgianit.com>
Subject: Re: btrfs as / filesystem in RAID1
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
 <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
In-Reply-To: <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>

--gLdRJifIV9TQifhh2RcdtHasiVIjPIjRV
Content-Type: multipart/mixed;
 boundary="------------CB5D2C0C9A2FA8611E6CE9DA"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------CB5D2C0C9A2FA8611E6CE9DA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-07 2:39 p.m., Austin S. Hemmelgarn wrote:


> Again, BTRFS mounting degraded is significantly riskier than LVM or MD
> doing the same thing.=C2=A0 Most users don't properly research things (=
When's
> the last time you did a complete cost/benefit analysis before deciding
> to use a particular piece of software on a system?), and would not know=

> they were taking on significantly higher risk by using BTRFS without
> configuring it to behave safely until it actually caused them problems,=

> at which point most people would then complain about the resulting data=

> loss instead of trying to figure out why it happened and prevent it in
> the first place.=C2=A0 I don't know about you, but I for one would rath=
er
> BTRFS have a reputation for being over-aggressively safe by default tha=
n
> risking users data by default.


Another important consideration is that BTRFS has practically zero
tolerance for corruption in the metadata.  Most other FS's can, at least
on surface appearance, either continue working despite bits of scrambled
data, or have repair utilities that are pretty good at figuring out what
the scrambled data should be and make a best guess effort that more or
less works (leaving aside for now statistics as to how often that might
cause undetected data corruption, which possibly propagates to backups et=
c.)

BTRFS is almost entirely reliant on the Duplicate copy of metadata,
which is missing when running degraded.  It makes it much more likely
for simple error to break the FS entirely.

BTRFS default configuration prioritizes data integrity over uptime, and
I think a very good argument can be made for any FS that *should* be the
default.


--------------CB5D2C0C9A2FA8611E6CE9DA
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


--------------CB5D2C0C9A2FA8611E6CE9DA--

--gLdRJifIV9TQifhh2RcdtHasiVIjPIjRV--

--RvurNLonvN1RukS2En5hyV6jLxQrY3B6b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcXKF0AAoJEO9Tn/JHRWpt8LIH+wc2keUwhKQ9GU7OGsybHtKp
2Vgq7dKiy4XEz7zLrWMOeDaMmJBAgNGtgCns5xrTKmqKtD0MJz2ix4bXWXFBU6Mj
WVziBCmYXQr5hicCwKQnK0VWY02gX4gnvIWm4efGK/jJVed5OZIkeyhdzJ/Nyya9
4bjQeYD1jxy9surkZJZCCv95k9AmSkVp8S423J4FlCcVXGcPFO7jDTsdjDu8j08W
fEULjRrT7L3JkJskZ0DA6yLWg63S+SjiV6zpadgQ24InVDO8dgOlW0q3kUMIi9VP
duL3CoS7jinteXwA5SImK7Net36ZHPRbJxKVmZImC+/IblpHmUgr8YsYIURZTFk=
=o/V/
-----END PGP SIGNATURE-----

--RvurNLonvN1RukS2En5hyV6jLxQrY3B6b--
