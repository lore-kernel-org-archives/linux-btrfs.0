Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7E0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 20:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A8502177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 20:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="hKBxVumG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfBRUOw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:14:52 -0500
Received: from mail.seblu.net ([212.129.28.29]:46054 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfBRUOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 15:14:52 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 32C9952FBC34;
        Mon, 18 Feb 2019 21:14:49 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id lcVRtvTvueAN; Mon, 18 Feb 2019 21:14:48 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 7F1A352FBC36;
        Mon, 18 Feb 2019 21:14:48 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 7F1A352FBC36
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1550520888; bh=cSUGzEzA7/afyBtZ0/w0HSk3/8lBl9uiecKxFNhcYfc=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=hKBxVumGPN/XYe8D+3hx82PdBFwcuZnqEIbKMoFf2NIqIJe2RSAApmxRXKukeFnHR
         EImvfsamvKeOA9uhgbeTwUXS+vevONTPond8ZhRh+52klQidfOo9/bPfzcQIh8EgQN
         6ZrSkL6O+iP+Nr2TrslPxFM7q2WSFOOEgjsUaLVf0DveBqZgnt2dAWLl209wMKoidi
         p/CnhLv90RM54ToKM2IAYXiapzpqwCihb2aiAIpm1fE0VYBXipL/Smd8OSgoNNkkgN
         SImbih5RR6yOJ60mbYSEO6qEYtzmZB/2bQYujVloN0F/xofLZ5mMxs+Doz/VFYg7Ne
         udtAuVqcskjkQ==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id iAWvzgY_Bie3; Mon, 18 Feb 2019 21:14:48 +0100 (CET)
Received: from dolores (amontsouris-684-1-76-225.w90-87.abo.wanadoo.fr [90.87.59.225])
        by mail.seblu.net (Postfix) with ESMTPSA id 4473652FBC34;
        Mon, 18 Feb 2019 21:14:48 +0100 (CET)
Message-ID: <91e2c9ef095eae21f9e88f7b5cf49102571dcba8.camel@seblu.net>
Subject: Re: Corrupted filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Mon, 18 Feb 2019 21:14:47 +0100
In-Reply-To: <CAJCQCtQ+b9y7fBXPPhB-gQrHAH-pCzau6nP1OabsC1GNqNnE1w@mail.gmail.com>
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
         <CAJCQCtQ+b9y7fBXPPhB-gQrHAH-pCzau6nP1OabsC1GNqNnE1w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-AzVJNo7DYgHz2X915YAL"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-AzVJNo7DYgHz2X915YAL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-02-12 at 15:40 -0700, Chris Murphy wrote:
> On Mon, Feb 11, 2019 at 8:16 PM S=C3=A9bastien Luttringer <seblu@seblu.ne=
t> wrote:
>=20
> FYI: This only does full stripe reads, recomputes parity and overwrites t=
he
> parity strip. It assumes the data strips are correct, so long as the
> underlying member devices do not return a read error. And the only way th=
ey
> can return a read error is if their SCT ERC time is less than the kernel'=
s
> SCSI command timer. Otherwise errors can accumulate.
>=20
> smartctl -l scterc /dev/sdX
> cat /sys/block/sdX/device/timeout
>=20
> The first must be a lesser value than the second. If the first is disable=
d
> and can't be enabled, then the generally accepted assumed maximum time fo=
r
> recoveries is an almost unbelievable 180 seconds; so the second needs to =
be
> set to 180 and is not persistent. You'll need a udev rule or startup scri=
pt
> to set it at every boot.
All my disks firmwares doesn't allow ERC to be modified trough SCT.

   # smartctl -l scterc /dev/sda
   smartctl 7.0 2018-12-30 r4883 [x86_64-linux-4.19.20-seblu] (local build)
   Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.=
org
  =20
   SCT Error Recovery Control command not supported

I was not aware of that timer. I needed time to read and experiment on this=
.
Sorry for the long response time. I hope you didn't timeout. :)

After simulated several errors and timeouts with scsi_debug[1],
fault_injection[2], and dmsetup[3], I don't understand why you suggest this
could lead to corruption. When an SCSI command timeout, the mid-layer[4] do
several error recovery attempt. These attempts are logged into the kernel r=
ing
buffer and at worst the device is put offline.

=46rom my experiment, the md layer has no timeout, and waits as long as the
underlying layer doesn't return, either during check or normal read/write
attempt.

I understand the benefits of keeping the disk time to recover from errors b=
elow
the hba timeout. It prevents the disk to be kicked out of the array.=20
However, I don't see how this could lead to a difference between check and
repair in the md layer and even trigger some corruption between the chunks
inside a stipe.

>=20
> It is sufficient to merely run a check, rather than repair, to trigger th=
e
> proper md RAID fixup from a device read error.
>=20
> Getting a mismatch on a check means there's a hardware problem somewhere.=
 The
> mismatch count only tells you there is a mismatch between data strips and
> their parity strip. It doesn't tell you which device is wrong. And if the=
re
> are no read errors, and no link resets, and yet you get mismatches, that
> suggests silent data corruption.=20
After reading the whole md (5) manual, I realize how bad it is to rely on t=
he
md layer to guaranty data integrity. There is no mechanism to known which c=
hunk
is corrupted in a stripe.
I'm wondering if using btrfs raid5, despite its known flaws, it is not safe=
r
than md.

> Further, if the mismatches are consistently in the same sector range, it
> suggests the repair scrub returned one set of data, and the subsequent ch=
eck
> scrub returned different data - that's the only way you get mismatches
> following a repair scrub.
It was the same range. That was my understanding too.

I finally get ride of these errors by removing a disk, wiping the superbloc=
k
and adding it back to the raid. Since then, no check error (tested twice).

> If it's bad RAM, then chances are both copies of metadata will be identic=
ally
> wrong and thus no help in recovery.
RAM is not ECC. I tested the RAM recently and no error was found.

But, I needed more RAM to rsync all the data w/ hardlinks, so I added a swa=
p
file on my system disk (an ssd). The filesystem on it is also btrfs, so I u=
sed
a loop device to workaround the hole issue.
I can find some link reset on this drive at time it was used as swap file.
Maybe this could be a reason.

> > How could I save my filesystem? Should I try --repair or --init-csum-tr=
ee?
>=20
> If it mounts read-only, update your backups. That is the first priority. =
Be
> prepared to need them. If it will not mount read only anymore then I sugg=
est
> 'btrfs restore' to scrape data out of the volume to a backup while it's s=
till
> possible. Any repair attempt means writing changes, and any writes are
> inherently risky in this situation. So yeah - if the data is important, f=
ocus
> on backups first.
Fortunately, data are safe, as I was in the middle of restoring them back t=
o
the server after a first issue with an old BTRFS filesystem[5].

> Next, I expect until the RAID is healthy that it's difficult to make a
> successful repair of the file system. And for the RAID to be healthy, fir=
st
> memory and storage hardware needs to be certainly healthy - the fact ther=
e
> are mismatches following an md repair scrub directly suggests hardware
> issues. The linux-raid list is usually quite helpful tracking down such
> problems, including which devices are suspect, but they're going to ask t=
he
> same questions about SCT ERC and SCSI command timer values I mentioned
> earlier, and will want to figure out why you're continuing to see mismatc=
hes
> even after a repair scrub - not normal.

I think I will remove the md layer and use only BTRFS to be able to recover
from silent data corruption.
But I'm curious to be able to repair a broken BTRFS without moving all the
dataset to another place. It's the second time it happen to me.

I tried:
# btrfs check --init-extent-tree /dev/md127
# btrfs check --clear-space-cache v2 /dev/md127
# btrfs check --clear-space-cache v1 /dev/md127
# btrfs rescue super-recover /dev/md127
# btrfs check -b --repair /dev/md127
# btrfs check --repair /dev/md127
# btrfs rescue zero-log /dev/md127


The detailed output is here [6]. But none of the above allowed me to drop t=
he
broken part of the btrfs tree to move forward. Is there a way to repair (by
loosing corrupted data) without need to drop all the correct data?

Regards,

[1] http://sg.danny.cz/sg/sdebug26.html
[2]=20
https://www.kernel.org/doc/Documentation/fault-injection/fault-injection.tx=
t
[3] https://linux.die.net/man/8/dmsetup
[4] https://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/x215.html
[5]=20
https://lore.kernel.org/linux-btrfs/6e66eb52e4c13fc4206d742e1dade38b04592e4=
9.camel@seblu.net/
[6] http://cloud.seblu.net/s/EPieGzGm9xcyQzd


--=20
S=C3=A9bastien Luttringer


--=-AzVJNo7DYgHz2X915YAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlxrEjcACgkQShr8NF6+
GPixuw+/YVtVjVULfSxC6K/gONfc0KxVL5HGSUFfGdf3ILmySrRQZFGIAzYqKQbq
4cj1EfxACfl1CUQlYNs4q6uiqV/Tt34YfeUPdBUPvLz5vDm9mzGG96aCNuwtkwJQ
T66O5r/4Cd3d12Po+UOixzf/Y+RiYKP9IHenRdH/nOtf6erbHchcC5tMOY7OEkdO
LF+RBFtNMSnfepgomFsGjAXwOwF2WOuDHmHRTsb8F82t9ZUGm/E5V/UKGx1sAUZk
WB04cUOv6WfFSm9Ei2OtcDWTnSHx8dAIzGbLdi1mLO2aoIzWarbpMip5CpfaS4Mx
kOp8FpjHSHJug1i7mnb93t3a4eBnX7bvzK2oqiWG1T42NatGQ+Alv8rSu2VNfVqJ
LZyvrHYplHAY0nVSR3N362tIoaTMfgUWYurlTViJaAX4G32hl9cZZSABb0FwCiA8
/PBg1Sp4C91xOvqPAEHLNL+XUo2GWzM2srpP4yNUuYFS1z2EsosHhRJtxbUyqFxT
lzKrntJYK+X+FWtEkltWTDGtTylYrEQmvofNlrq8O67XThp4F/nADjvM4RErzcEi
5NB/t35RnvMIhGUFHQDfSn9RFx4zGwM1etHdUGiRpuM5uVzFQOvNRpFuL3/i0IFq
hH2Eq76vQN2lcTh+R9q4+TVlyrjDHPZCz/MzoO2S
=0fsO
-----END PGP SIGNATURE-----

--=-AzVJNo7DYgHz2X915YAL--

