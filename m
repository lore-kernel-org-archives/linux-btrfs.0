Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38468 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaKRPgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 10:36:55 -0500
Received: by mail-qc0-f180.google.com with SMTP id i8so7376641qcq.11
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 07:36:51 -0800 (PST)
Message-ID: <546B676E.6040305@ubuntu.com>
Date: Tue, 18 Nov 2014 10:36:14 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Fennec Fox <fennectech@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs on a failing drive
References: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>	<546A9E0F.4070108@ubuntu.com> <CAD1x5BDJhZ6a=91G8+UzLTY+Oik7MVpr-XGKOQrOnXpkRLjwug@mail.gmail.com>
In-Reply-To: <CAD1x5BDJhZ6a=91G8+UzLTY+Oik7MVpr-XGKOQrOnXpkRLjwug@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please get in the habit of using your mail client's reply-to-all
button instead of reply; there is no need for us to take this
conversation private.

On 11/17/2014 10:15 PM, Fennec Fox wrote:
<snip big smartctl output>
> i know the drive is dying and needs replacing   but i need to keep 
> this drive arround for some time longer   as i cant run from a 32
> gb usb    far too slow

If it were just a few bad sectors, then you could deal with that by
writing to them, which would force the drive to reallocate them from
the spare pool.  I'd suggest you dd /dev/zero all over the drive so
everything is written to, then check the smart stats again.  If there
were no write errors, and the smart stats show zero pending sectors,
then everything has been reallocated and you should be ok to reformat
the drive and use it.

As I said before though, the errors you posted from dmesg don't
indicate that the drive failed to read sectors, but rather that it
returned incorrect data, and this is *NEVER* supposed to happen.

I'd suggest running a few passes of badblocks over the drive, testing
writing different patterns and verifying that they read back
correctly.  If it can't do that, then there's nothing for it but to
junk the drive.

badblocks -b 4096 -c 256 -s -t 00 /dev/sda

That will read the drive and verify that it is full of zeros.  If that
passes, write a different pattern to the disk and verify that reads
back correctly:

badblocks -b 4096 -c 256 -s -w /dev/sda


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa2duAAoJEI5FoCIzSKrw+0AIAJNAqF1rY2m5Oalehr3dz+G4
O6h9XERRiTl8GVMgcj7ZybeP3sFroItgiki5UdhRsjNoPEPRQpv3hApY7p2cEUtk
yNn8jAeRBjA0kli+5HMHY3eHL4RmLO3mrLmNoAu5HShvWBE4zj/18vvk15m/u5rj
SnrxBUSQ91V0D6p/CFkjAX9iBZBoWx4+J7Wz8EOhqnFJbqXaCEOdj7NKrjQ/7r+Q
5gxQWD4x54NQSGPfexERtRRaL9drE3JoLTbOEC+xdt7a9MwHw5Z50DTfMRzibpFP
kdKlRCLMzcNGXSVt/187MMbpvROXBWhfmAAFOCz5rGtrGjX3V6+/7hpPBn5ft3E=
=L5No
-----END PGP SIGNATURE-----
