Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36433 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbbGFRbN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 13:31:13 -0400
Received: by wguu7 with SMTP id u7so146755884wgu.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 10:31:12 -0700 (PDT)
From: Johannes Pfrang <johannespfrang@gmail.com>
Subject: Re: Btrfs - distribute files equally across multiple devices
To: Roman Mamedov <rm@romanrm.net>
References: <559AAB5C.1030001@gmail.com> <20150706214544.184908dd@natsu>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <559ABB5D.9070305@gmail.com>
Date: Mon, 6 Jul 2015 19:31:09 +0200
MIME-Version: 1.0
In-Reply-To: <20150706214544.184908dd@natsu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vHdoQJONMKrpjQu2tjwQjdPEKHLmx4Qni"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vHdoQJONMKrpjQu2tjwQjdPEKHLmx4Qni
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

That looks quite interesting!
Unfortunately this removes the ability to specify different RAID-levels
for metadata vs data and actually behaves more like btrfs "single" mode.
According to your link it fills drive by drive instead of distributing
files equally across them:

"When you create a new file in the virtual filesystem, |mhddfs| will
look at the free space, which remains on each of the drives. If the
first drive has enough free space, the file will be created on that
first drive."

What I propose (simplest implementation):

"When you create a new file in the filesystem, btrfswill look at used
space on each of the drives. The file will be created on the drive with
the least used space that can hold the file."

Difference:

mhddfs only achieves maximum recoverability once the filesystem is full
(just like "single"), while my proposal achieves such recoverability
from the start.
(maximum recoverability by (totalDisks-failedDisks)/totalDisks as
percentage of recoverable data/files (depending on by which the fs is
balanced))

Also I'm not sure if it's compatible to btrfs's special
remaining-space-calculation magic ^^

On 06.07.2015 18:45, Roman Mamedov wrote:
> On Mon, 6 Jul 2015 18:22:52 +0200
> Johannes Pfrang <johannespfrang@gmail.com> wrote:
>
>> The simplest implementation would probably be something like: Always
>> write files to the disk with the least amount of space used. I think
>> this may be a valid software-raid use-case, as it combines RAID 0 (w/o=

>> some of the performance gains[2]) with recoverability of about half of=

>> the data/files (balanced by filled space or amount of files) in the
>> event of a drive-failure[3] by using filesystem information a
>> hardware-raid doesn't have. In the end this is more or less JBOD with
>> balanced disk usage + filesystem intelligence.
> mhddfs does exactly that: https://romanrm.net/mhddfs
>



--vHdoQJONMKrpjQu2tjwQjdPEKHLmx4Qni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVmrtdAAoJEE/+YBzbApIXnhcQAK6Dd+MGU1ifsTB6N0svSDV1
t2yIrycHn0XQLc4J3RLj+Io316wmfF5pjdI4GUSDCCKwopV//iSqrS7brkrhPJMb
o0h0TW2p9Ruyzy2NrBC2FptMlCuSRWN/yA3Y7tcPeuimUnFo5AcOy5cQql50Redx
KBuQSySgPVwxVPh/0LdEeEwOKqyTD0fOOjIUvVq/cIE6g6/ONhhH2nGFgG7kxcfm
A8/zVXbDwcr5KcYORX9U+SJ/YEqs3rzf3dNmikh+WlH8BTXnt4dKcrR41mCrvqCP
ZFRn02SYUHaC+3lUujtCpLyFXKvsaNAVcA1xEdCQFHHnj07kUPIDt8v6iiNe9dSC
nNMzjeMZ84UpLIqsZs8FMEoqwPPT0Mg3+85iCkIbS5Xbh0CVjYoAKevGvMGkrW6a
PcB2Q/fEKUWy1hOwRE4weVvmfrZyp9QEEkO4AqJdakfB68ud24Gtg8kTHaiUfY/b
nXdL00z+ja+AgUuc36uTAwbkImpu7tAdIy5VF5t6tnc5aqKYg9n8cdglW39MFD20
BU8IzJgsmEjtzazHNB4nnopaOwgVhEayZR9tJ+cv9QFkoxW9vjeVvnpttt6S05MS
6E66b0q2qeWq0GVlLf663EzEscO/H57oxmSCvJ2RTSmpLkNmdp7ruvuPfp8oTl81
q2njtZqDzIUKTAa7east
=X9Ml
-----END PGP SIGNATURE-----

--vHdoQJONMKrpjQu2tjwQjdPEKHLmx4Qni--
