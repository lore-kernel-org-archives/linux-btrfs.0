Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CAAC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 12:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32D320665
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 12:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbfAIMV1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Jan 2019 07:21:27 -0500
Received: from mail.automatix.de ([213.131.255.221]:43422 "EHLO
        mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729699AbfAIMV1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2019 07:21:27 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2019 07:21:25 EST
Received: from [192.168.11.17] (statdsl-085-016-075-061.ewe-ip-backbone.de [85.16.75.61])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jojo@automatix.de)
        by mail.automatix.de (Postfix) with ESMTPSA id 7D41D600BD;
        Wed,  9 Jan 2019 13:14:30 +0100 (CET)
Subject: Re: btrfs hang on nfs?
To:     "Scott E. Blomquist" <sb@techsquare.com>,
        linux-btrfs@vger.kernel.org
References: <23605.54017.819143.292441@techsquare.com>
From:   Jojo <jojo@automatix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=jojo@automatix.de; prefer-encrypt=mutual; keydata=
 mQGiBDrnB8YRBADPXBBqHOnUrWhtdabEakBVZO2d5cPFx+3gRHrjntCRtzUeQlSapnte3aQt
 3/5EyTiRkUsTpT0ThQFCGycKs8XN64xwWSIRDVdJ0tyugVzOud5Lx8unpi6DRBdiBZxtllqc
 sI6/WshcjD2oOocuapMa1zewg7Ft5Li/gKn6wSSZUwCg6Lqi9euJHebgAy6m9K7VugS3AdsD
 /1r5iTMRUSeA4tCL/C5tNWauft+BHoO6bxCJMAdqpk99DM7SaUJUHi6kMR8GaLLb6WzXtXwT
 27CxJzSj6pe2nyawYalGg0Sos9MSkAO13U7TXRMthPjuB3NGrosm4KG54IU8imHFelOH5lsV
 bKMjO1IU2XJgMG9L3Lm6AbInTqs1BACqGNIYNWymdyXJZkylptehd+M3WwR7MvJXggL+6igd
 muGE+fliHKDHqbim3mnoVRjE22mGVnruZfXMdrHGcyMj7CtaBOhd8FKDjRfacEyPkKVC7zWH
 /im0+lw/lHeuyKUTbp29EEs6QDkUT/UtYt1Hg6hGaadhqginIKNxErU4srQySsO8cmdlbiBT
 YXVlciAoQXV0b21hdGlYIEdtYkgpIDxqb2pvQGF1dG9tYXRpeC5kZT6IdQQTEQIANQIbAwYL
 CQgHAwIDFQIDAxYCAQIeAQIXgBYhBNeck4CyasphW2qr/Fu1CiPRKmqxBQJa1MJmAAoJEFu1
 CiPRKmqxWm8AnRhvHFmKv0c63GYutTB2tYVirs4OAJ9EiMPt2FwZaKOwUPMIZBGkShzlIbkB
 DQQ65wfKEAQAqvkN6QVdqFr8nVsr5E2PxyVn3+a/SB050fZsMs1QTPrY/USJxqLtxI1M1Di8
 bnLXcsfPu3LyFkkp6PSG6lVQb3vUcrREY3JbITtGhSjnQAhZAhuKttlFFoVe1IsD6wZS+j2J
 4K+SoyRSOG7ywMjhPwx2hMnJO/Yk2+ot4oFsz7cAAwUD/R0fYbCwAkFhstSd5W+EYRIWyCf0
 Ph5SM4TT2BNP4vHY76rnDdynUBTBbNGW/ODZhGCFz2UVM9jRl6JR/SfoZ1czGQ0tPSdTbPbV
 XkTa/E7ozpEGINPn90PjO5J041Z8rJSWEPzl+uXj4XwwNr/8Q7C9FOqXglzn7XKt4ukc/0ux
 iE4EGBECAAYFAjrnB8oAEgkQW7UKI9EqarEHZUdQRwABAUYWAKCKZKpm/130ZE/+sWL17EkE
 niDWgQCgzw9ynZhutkyeahO/fYBWUuAbkhc=
Message-ID: <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
Date:   Wed, 9 Jan 2019 13:14:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <23605.54017.819143.292441@techsquare.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iDwJkXaJuVShErA7q8W7UwcYOXEHUnfwg"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iDwJkXaJuVShErA7q8W7UwcYOXEHUnfwg
Content-Type: multipart/mixed; boundary="8zylBZ9SFuPoMpUpBJq6nRWEbGrWDVWEQ";
 protected-headers="v1"
From: Jojo <jojo@automatix.de>
To: "Scott E. Blomquist" <sb@techsquare.com>, linux-btrfs@vger.kernel.org
Message-ID: <6d8d3b43-dc73-42b8-7c70-2fb8a3b0d98c@automatix.de>
Subject: Re: btrfs hang on nfs?
References: <23605.54017.819143.292441@techsquare.com>
In-Reply-To: <23605.54017.819143.292441@techsquare.com>

--8zylBZ9SFuPoMpUpBJq6nRWEbGrWDVWEQ
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Am 09.01.19 um 11:54 schrieb Scott E. Blomquist:
>=20
> Hi All,
>=20
> I have a system that has been hanging/wedging frequently.  It seems to
> be load dependent but have not been able to isolate the problem.  The
> only option once the hang happens is to reboot via
> /proc/sysreq_trigger
>=20
> btrfs fi df /export/
> Data, single: total=3D75.55TiB, used=3D75.54TiB
> System, single: total=3D36.00MiB, used=3D7.89MiB
> Metadata, single: total=3D187.01GiB, used=3D185.65GiB
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B


Within scheduler there were some changes according to device queueing.
Kernels after 4.16 and before 4.19.8 were problematic, as we recognized
here.
This seemed to be a regression on the "kyber" scheduler, as recognized he=
re:
[root@pc7 sysctl.d]# cat /sys/block/sdc/queue/scheduler
mq-deadline [kyber] bfq none

As work around you may change the disc scheduler to an "old" one, like

Test it like this for all of your devices:
root@pc7:~/ # echo bfq > /sys/block/sdX/queue/scheduler

For permanent add a file config to your /etc/sysctl.d.
EXAMPLE, edit it to your requirements.

[root@pc7 sysctl.d]# cat /etc/sysctl.d/90-sysscheduler.conf
#disk scheduler
block.sda.queue.scheduler =3D md-deadline
block.sdb.queue.scheduler =3D md-deadline
block.sdg.queue.scheduler =3D bfq
block.sdh.queue.scheduler =3D bfq
block.sdi.queue.scheduler =3D bfq


Hope this may help you.
It did work for me here.

Better Idea is to upgrade the kernel to 4.19.13 (which is a LTS Kernel)

mit freundlichen Gr=C3=BC=C3=9Fen
J=C3=BCrgen Sauer
--=20
J=C3=BCrgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Gesch=C3=A4ftsf=C3=BChrer: J=C3=BCrgen Sauer,
Gerichtstand: Amtsgericht Walsrode =E2=80=A2 HRB 120986
Ust-Id: DE191468481 =E2=80=A2 St.Nr.: 36/211/08000
GPG Public Key zur Signaturpr=C3=BCfung:
http://www.automatix.de/juergen_sauer_publickey.gpg


--8zylBZ9SFuPoMpUpBJq6nRWEbGrWDVWEQ--

--iDwJkXaJuVShErA7q8W7UwcYOXEHUnfwg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTXnJOAsmrKYVtqq/xbtQoj0SpqsQUCXDXlpgAKCRBbtQoj0Spq
scygAKDH2jEMOAV/OdhRQfa6Ke1O99jJLACeLkEU4rk3EaLilzpSElMd8ErRGsk=
=c6VQ
-----END PGP SIGNATURE-----

--iDwJkXaJuVShErA7q8W7UwcYOXEHUnfwg--
