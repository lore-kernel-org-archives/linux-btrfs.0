Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:34370 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbcFXRnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:43:51 -0400
Received: from [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d] (unknown [IPv6:2407:e400:b000:201:c8d9:fa83:ce8e:757d])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id D4A4F3A005C
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 03:43:47 +1000 (AEST)
Subject: Re: Trying to rescue my data :(
To: linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
Date: Sat, 25 Jun 2016 03:43:46 +1000
MIME-Version: 1.0
In-Reply-To: <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0qjfGatrA9DXcSNHEUWQUSNwHwtVavfvc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0qjfGatrA9DXcSNHEUWQUSNwHwtVavfvc
Content-Type: multipart/mixed; boundary="MKapP3mbih75Hb5GI2NwpJkvcDSbcoCM0"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
Subject: Re: Trying to rescue my data :(
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
In-Reply-To: <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>

--MKapP3mbih75Hb5GI2NwpJkvcDSbcoCM0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 25/06/16 03:40, Austin S. Hemmelgarn wrote:
> On 2016-06-24 13:05, Steven Haigh wrote:
>> On 25/06/16 02:59, ronnie sahlberg wrote:
>> What I have in mind here is that a file seems to get CREATED when I co=
py
>> the file that crashes the system in the target directory. I'm thinking=

>> if I 'cp -an source/ target/' that it will make this somewhat easier (=
it
>> won't overwrite the zero byte file).
> You may want to try with rsync (rsync -vahogSHAXOP should get just abou=
t
> everything possible out of the filesystem except for some security
> attributes (stuff like SELinux context), and will give you nice
> information about progress as well).  It will keep running in the face
> of individual read errors, and will only try each file once.  It also
> has the advantage of showing you the transfer rate and exactly where in=

> the directory structure you are, and handles partial copies sanely too
> (it's more reliable restarting an rsync transfer than a cp one that got=

> interrupted part way through).

I may try that - I came up with this:
#!/bin/bash

mount -o ro,nossd,degraded /dev/xvdc /mnt/fileshare/

find /mnt/fileshare/data/Photos/ -type f -print0 |
    while IFS=3D read -r -d $'\0' line; do
        echo "Processing $line"
        DIR=3D`dirname "$line"`
        mkdir -p "/mnt/recover/$DIR"
        if [ ! -e "/mnt/recover/$line" ]; then
                echo "Copying $line to /mnt/recover/$line"
                touch "/mnt/recover/$line"
                sync
                cp -f "$line" "/mnt/recover/$line"
                sync
        fi
    done

umount /mnt/fileshare

I'm slowly picking through the data - and it has crashed a few times...
It seems that there are some checksum failures that don't crash the
entire system - so that's a good thing to know - not sure if that means
that it is correcting the data with parity - or something else.

I'll see how much data I can extract with this and go from there - as it
may be good enough to call it a success.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--MKapP3mbih75Hb5GI2NwpJkvcDSbcoCM0--

--0qjfGatrA9DXcSNHEUWQUSNwHwtVavfvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbXFSAAoJEEGvNdV6fTHcb2YQAJAxlo+r0x3L11DKhMqG0n7G
5MIyuinJDJfyqEhgKtHwiX1i+e64EFjKwMx3K/ykXWyTpzw7WIJGS9jHcLmnAwCC
nXRsmtaEDo2pPlg9EBaQ0pr8xtkVZTCRpsVY0CObzseDDdrt8OwXrFHp1mOkInS5
eqDR4CG4lMeympO+OscPzMgDPW7AQR5oGIS4kJ9O26H+kYyifIt6WxGlYtAs0CAU
UJQaafdBwmKNxKcdFbrmwNore3btFr3gjz3pTtc74PykQw9aS52LbNGiDY1jjTWR
Tq0gHrevQhvy5Dg/UmwgMEgXRzS7n480/IXM2KLJdvKVGSaIfd+a99jLpQ5fzVUR
41hNL4BnNCCNEMWss1KpYhkA4kvLTDxBy5q0y8W6+b73C6VyqWryy3vPHAwh489l
gwiFiPzYohsFSeRe4W0dSrguTVgizJEBYcqXZ0nOs2CmmKUhQAeVThqq9pb6+FQr
kqyPjGKtiJl5QHdwG7L/Rm3UOfH+92Qhcd7DQXEUsaMwW9FT7nLgQLSDS1lxxx2O
PREk/usZEUC7KtSoWruip+mVHVPqw/Z5Z50TxPADKb4aqnW8o7ZbLQH15m/Ogeif
/UEQrFawi6m0yVzDQ3WxUuxI7Sy3OVgZZeLu4n1PDc/hVh/43ocmNE2wBRCOwffD
OVgWBnJppSUXYCyhgokF
=Cnth
-----END PGP SIGNATURE-----

--0qjfGatrA9DXcSNHEUWQUSNwHwtVavfvc--
