Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:35606 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbcFYETd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 00:19:33 -0400
Received: from [IPv6:2407:e400:b000:201:c586:44c:f762:4f7e] (unknown [IPv6:2407:e400:b000:201:c586:44c:f762:4f7e])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id A33453A005B
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 14:19:27 +1000 (AEST)
Subject: Re: Trying to rescue my data :(
To: linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
 <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
Date: Sat, 25 Jun 2016 14:19:11 +1000
MIME-Version: 1.0
In-Reply-To: <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LtIe9huHwbUqJUuxnI6DMXJR2Fu4UPnqT"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LtIe9huHwbUqJUuxnI6DMXJR2Fu4UPnqT
Content-Type: multipart/mixed; boundary="FwUARVfaECXawHkbVX0qofe7IsJkAHHTI"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
Subject: Re: Trying to rescue my data :(
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
 <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
In-Reply-To: <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>

--FwUARVfaECXawHkbVX0qofe7IsJkAHHTI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 25/06/2016 3:50 AM, Austin S. Hemmelgarn wrote:
> On 2016-06-24 13:43, Steven Haigh wrote:
>> On 25/06/16 03:40, Austin S. Hemmelgarn wrote:
>>> On 2016-06-24 13:05, Steven Haigh wrote:
>>>> On 25/06/16 02:59, ronnie sahlberg wrote:
>>>> What I have in mind here is that a file seems to get CREATED when I
>>>> copy
>>>> the file that crashes the system in the target directory. I'm thinki=
ng
>>>> if I 'cp -an source/ target/' that it will make this somewhat easier=

>>>> (it
>>>> won't overwrite the zero byte file).
>>> You may want to try with rsync (rsync -vahogSHAXOP should get just ab=
out
>>> everything possible out of the filesystem except for some security
>>> attributes (stuff like SELinux context), and will give you nice
>>> information about progress as well).  It will keep running in the fac=
e
>>> of individual read errors, and will only try each file once.  It also=

>>> has the advantage of showing you the transfer rate and exactly where =
in
>>> the directory structure you are, and handles partial copies sanely to=
o
>>> (it's more reliable restarting an rsync transfer than a cp one that g=
ot
>>> interrupted part way through).
>>
>> I may try that - I came up with this:
>> #!/bin/bash
>>
>> mount -o ro,nossd,degraded /dev/xvdc /mnt/fileshare/
>>
>> find /mnt/fileshare/data/Photos/ -type f -print0 |
>>     while IFS=3D read -r -d $'\0' line; do
>>         echo "Processing $line"
>>         DIR=3D`dirname "$line"`
>>         mkdir -p "/mnt/recover/$DIR"
>>         if [ ! -e "/mnt/recover/$line" ]; then
>>                 echo "Copying $line to /mnt/recover/$line"
>>                 touch "/mnt/recover/$line"
>>                 sync
>>                 cp -f "$line" "/mnt/recover/$line"
>>                 sync
>>         fi
>>     done
>>
>> umount /mnt/fileshare
>>
>> I'm slowly picking through the data - and it has crashed a few times..=
=2E
>> It seems that there are some checksum failures that don't crash the
>> entire system - so that's a good thing to know - not sure if that mean=
s
>> that it is correcting the data with parity - or something else.
>>
>> I'll see how much data I can extract with this and go from there - as =
it
>> may be good enough to call it a success.
>>
> AH, if you're having issues with crashes when you hit errors, you may
> want to avoid rsync then, it will try to reread any files that don't
> match in size and mtime, so it would likely just keep crashing on the
> same file over and over again.
>=20
> Also, looking at the script you've got, that will probably run faster
> too because it shouldn't need to call stat() on everything like rsync
> does (because of the size and mtime comparison).

Well, as a data point, the data is slowly coming off the RAID6 array.
Some stuff is just dead and crashes the entire host whenever you try to
access it. At the moment, my average uptime is about 2-3 minutes...

I've added my recovery rsync script to /etc/rc.local - and I'm just
starting / destroying the VM every time it crashes.

I'm also rsync'ing the data from that system out to other areas of
storage so I can pull off as much data as possible (I don't have a spare
4.4Tb to use).

I lost a total of 5 photos out of 83Gb worth - which is good. My music
collection doesn't seem to be that lucky - which means lots of time
ripping CDs in the future :P

I haven't tried the applications / ISOs directory yet - but we'll see
how that goes when I get there...

The photos were the main thing I was concerned about, the rest is just
handy.

Interesting though that EVERY crash references:
	kernel BUG at fs/btrfs/extent_io.c:2401!


--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--FwUARVfaECXawHkbVX0qofe7IsJkAHHTI--

--LtIe9huHwbUqJUuxnI6DMXJR2Fu4UPnqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbgZQAAoJEEGvNdV6fTHcYg0QALWd2rK9pSqK6JC3dN+2E+Jd
BXglpkdRLvTqlliAiAmXrCi81tvg1OhEx171Okye2J4nl5vpXLHExgb0E/kY2ViA
X5olQDloMAV6Wbtv4alVZigpfQnV2M4FYCXDwwbpjV4z0XDlovutzlayoRb8oYv3
/Gvj0zdOW/QY3/1TXZw8hApBGmo7HgCA+rI4SPRFriuR6WU/yahCxkrNhEFi+9sD
f0ysQ9CbBelraAFvl6CZTDTAIHc2ASmNlVedit8gs8gKGhntlja8g6UC2V7V+l8h
wB6+fPGAT1VryoUyH/mtWWvVseqAixtw3MBDVNVjYcPXeaxWLFeAvh55ls2/CTdd
MwEt/IyjetRge99eimb7uzpWQY40GE2YAdEmKjY+soSaspIrjNG2g3rsgNyiJr+F
yKLmVWHgecRItHGUO5hOdrv4acs5kpLSMhdG9VccHZfab1GIRW42CIJTqoXQPyYN
9kj+2xOGMQtjU6htDH2+PBKB4lv45Fq51ZWqb0V0RdD/Og21MOLLg5bej6xjqZj0
ssgbI6hYRsMkqIei81+QyqK18M5ClEdTEcKANiMmOhFmE7oB9Xsi5Z0f1uVbdfXk
cUEVGC3atUpVerLUQNL8F0AssmKCrxOVyQlgQW+9HTb6r3Q0vsNUF0C6fb1f/wIZ
lhXzy9xlc6a55UxUX4ns
=1z3E
-----END PGP SIGNATURE-----

--LtIe9huHwbUqJUuxnI6DMXJR2Fu4UPnqT--
