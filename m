Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C88C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 07:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A3620645
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 07:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfDWH3t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 03:29:49 -0400
Received: from mail.automatix.de ([213.131.255.221]:45925 "EHLO
        mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfDWH3s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 03:29:48 -0400
Received: from [192.168.11.16] (statdsl-085-016-075-061.ewe-ip-backbone.de [85.16.75.61])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jojo@automatix.de)
        by mail.automatix.de (Postfix) with ESMTPSA id AF573600A3;
        Tue, 23 Apr 2019 09:29:41 +0200 (CEST)
Subject: Re: reading/writing btrfs volume regularly freezes system
To:     Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
From:   Juergen Sauer <juergen.sauer@automatix.de>
Openpgp: id=D41F20FCD4A08AD588776084C89D88C98852A789
Autocrypt: addr=juergen.sauer@automatix.de; prefer-encrypt=mutual; keydata=
 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
 8CGD2mDl+cnaYgWQxjU9aDyOAw==
Organization: automatiX GmbH
Message-ID: <476a657f-ae87-38ab-47b0-1bd410092621@automatix.de>
Date:   Tue, 23 Apr 2019 09:29:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F3UetUCTLLMvjxEBx4H0OsLnkndSSZXkE"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F3UetUCTLLMvjxEBx4H0OsLnkndSSZXkE
Content-Type: multipart/mixed; boundary="PfLIaQedEoKdt2z7snU4IykO3b4OzlSQi";
 protected-headers="v1"
From: Juergen Sauer <juergen.sauer@automatix.de>
To: Nathan Dehnel <ncdehnel@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <476a657f-ae87-38ab-47b0-1bd410092621@automatix.de>
Subject: Re: reading/writing btrfs volume regularly freezes system
References: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>
In-Reply-To: <CAEEhgEsQD1WgqZBZ2YEsEZKKH6X6PSxZGKbMgSVrzkEjVVDFrg@mail.gmail.com>

--PfLIaQedEoKdt2z7snU4IykO3b4OzlSQi
Content-Type: multipart/mixed;
 boundary="------------AD1526A68E4B76B7CE616F0C"
Content-Language: de-DE

This is a multi-part message in MIME format.
--------------AD1526A68E4B76B7CE616F0C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 22.04.19 um 22:37 schrieb Nathan Dehnel:
> I have a raid10 volume that frequently locks up when I try to write to
> it or delete things. Any command that touches it will hang (and can't
> be killed) and I have to start a new ssh session to get into the
> computer again. Nothing fixes it besides a reboot, and the volume will
> fail to unmount while the computer is shutting down.
>=20
> [  302.360912] sysrq: SysRq : Show Blocked State
> [  302.360951]   task                        PC stack   pid father
> [  302.360987] btrfs-transacti D    0  2187      2 0x80000000
> [  302.360993] Call Trace:
[...]

Nathan,
I presume you are using a kernel before 4.19.8 and after 4.0.9.x.
Your Post does not mention the kernel version, you use.
Could you please post the output of "uname -a" ?

During the rework of the kernel scheduler (multi queue schechduler) by
the kernel team around Linus, there were huge modification done, which
effected nearly all filesystems. Those rewritings caused data loss in
ext4, complete crashes in xfs and so on.

I was hit by this issue on BTRFS, so your description was somewhat a
dejavu for me.


Your can try to use the old mono-queued schedulers in an interim kernel,
or you may upgrade to an recent kernel.

The means disable "kyber" scheduler, wihch is default after 4.18.x or
so, and reactivate cfq, bfq or deadline or noop scheduler. If your
problems are solved it would be a great idea to upgrade the kernel.

We use BTRFS as raid5 (not advised, experimaental), but we use it with
kernel 5.x in arch linux.

Even the multi device code is under heavy development,
BTRFS likes the most recent kernels!



mit freundlichen Gr=C3=BC=C3=9Fen
J=C3=BCrgen Sauer

--------------AD1526A68E4B76B7CE616F0C
Content-Type: text/x-vcard; charset=utf-8;
 name="juergen_sauer.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="juergen_sauer.vcf"

begin:vcard
fn;quoted-printable:J=3DC3=3DBCrgen Sauer
n;quoted-printable:Sauer;J=3DC3=3DBCrgen
org:automatiX GmbH
adr:;;Neue Str. 11;Schwanewede;Niedersachsen;28790;Deutschland
email;internet:juergen.sauer@automatix.de
tel;work:+49 4209 4699
tel;fax:+49 4209 4644
tel;home:+49 4209 4653
tel;cell:+49 162 9699 259
x-mozilla-html:FALSE
url:https://automatix.de
version:2.1
end:vcard


--------------AD1526A68E4B76B7CE616F0C--

--PfLIaQedEoKdt2z7snU4IykO3b4OzlSQi--

--F3UetUCTLLMvjxEBx4H0OsLnkndSSZXkE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEepxTH+9otopXeixExh7qHMhf53gFAly+vuQACgkQxh7qHMhf
53iCHg//dpRFgCKxrWE0reHo+lk4UphHAwg9WIm4mxENPcMZNSPd2SNQJTDABoSL
e4LSXXhRyHJ9+0yeFaRljLvqNlSuuhgc3C7NKSwfrcTWD4fBUbqSxp7sVcq/KocZ
ekzCwTW6rk6uib+0TWromYQbzUeUUQJQkmySpRYHSfN+zc2o0x8CZ1ktd0XNfisM
cND4/vjqPGeoAM4ctqX8aMVAjQKT4L3Ik+Jz1okA5rEphP1+T3rBLDjh/7DvTAvh
JGkt+Fs4yyZ5BmNCIGd4KrMu9gKyyH00GZKP+IO8ggrDcfwexZdypEf/5InbNRpe
wV4ca/azMcBx4LP1pJszTNmHs1SJ7b4pQDxZ2CbCIPSQ3stj17MbjNGijxE6xJJ1
p9ZNdQPeL9J5SCEy8v8rovB5NDe17Ytcrw6pHealySAJa5y8LDOV2n7CNyRbJcdZ
g3BBJ9xhi35krsjCSyvY58XgkTZqsywO2GW9yZwPE15KHUjHdskAv/gPJf3q7Hk5
bWyp5b5ymcWh727XEoBVSpQ3C2BNd/Ri0JeIyyEvwVrc+pAx13IjdInXtrC/V5iR
t9F7cQZ6BDzOedwC+PKh02prUTpk4s4vhWMdSQIEalZ055YZK5uUW8vhHkqQHVRG
cU0jxURxEWdAI3fbT4V4kbi13Oy7oWjwf6k3VfonDyxXFfMW0JA=
=RCdC
-----END PGP SIGNATURE-----

--F3UetUCTLLMvjxEBx4H0OsLnkndSSZXkE--
