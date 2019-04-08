Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B012C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562EF2087F
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 16:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbfDHQ3v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:29:51 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:41650 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfDHQ3u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 12:29:50 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hDX9X-0006T6-Ve; Mon, 08 Apr 2019 16:29:47 +0000
Date:   Mon, 8 Apr 2019 16:29:47 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     "Scott E. Blomquist" <sb@techsquare.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: checksum error...
Message-ID: <20190408162947.GF1084@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        "Scott E. Blomquist" <sb@techsquare.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <23723.27955.359573.44839@techsquare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gneEPciiIl/aKvOT"
Content-Disposition: inline
In-Reply-To: <23723.27955.359573.44839@techsquare.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--gneEPciiIl/aKvOT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2019 at 11:48:03AM -0400, Scott E. Blomquist wrote:
> 
> Hi All,
> 
> The weekend btrfs scrub/balance came back with this following...
> 
> [Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271471, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
[snip]

   Since there doesn't seem to be anything else wrong (no messages
without a filename, which would imply metadata corruption), this is
most likely a simple case of on-device corruption.

   Delete yyyy/yyyyy and restore it from backups. At least, do so in
the working copy; The snapshots of it can safely remain until they get
rotated out normally.

   Check your SMART statistics and see if anything looks wrong there
on the hardware side. Also check dmesg and earlier kernel logs for
signs of the hardware showing an error on read -- it may have tried
several times to read that location before giving up and/or returning
bad data.

   Hugo.

> 
> Here is what I have...
> 
>     root@cbmm-fsb:~# uname -a
>     Linux cbmm-fsb 4.14.24-custom #1 SMP Mon Mar 5 10:10:39 EST 2018 x86_64 x86_64 x86_64 GNU/Linux
>     
>     root@cbmm-fsb:~# btrfs --version
>     btrfs-progs v4.15.1
>     
>     root@cbmm-fsb:~# btrfs fi show
>     Label: none  uuid: d83b1e28-db27-4035-8638-d4b2eb824ff2
>            Total devices 2 FS bytes used 80.09TiB
>            devid    1 size 76.40TiB used 62.49TiB path /dev/sda1
>            devid    2 size 32.74TiB used 18.83TiB path /dev/sdb1
>     
>     root@cbmm-fsb:~# btrfs fi df /home/cbcl
>     Data, single: total=79.80TiB, used=79.80TiB
>     System, RAID1: total=32.00MiB, used=9.09MiB
>     Metadata, RAID1: total=757.00GiB, used=281.34GiB
>     Metadata, DUP: total=22.50GiB, used=19.27GiB
>     GlobalReserve, single: total=512.00MiB, used=0.00B
>     
> sda and sdb are megaraid raid6 with BBU and both are optimal.
> 
> Any tips?  Thanks.
> 
> sb. Scott Blomquist
> 

-- 
Hugo Mills             | If it ain't broke, hit it again.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                                  Foon

--gneEPciiIl/aKvOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJcq3b7AAoJEFheFHXiqx3kbv0P+gMH+22JoXawSPbGha34/3ay
uJbcnM9CCaBSe754mYJn/zvHSEuwUd9g6fw+xQMOrNDcvA9vzwCVBnjSsjs1YIUh
14Pip/0LwZ+NpGQYDwz7uSEdyQpGZeNvqyF2G1f0hWjGi1Cfsjek9GzpsDU/k5nV
VNjDqtlTH/rslomBWn9EBZWZZPwXO7fFb8JV2yhcYZKBqL4B1b90Pw/UrhHebUmh
PawrIDseCjFl+FTgGlR+wgTcK+rqZsKYBgnsRW9g6lvqpXfLEYTEHUBrrCmR9sLg
kwaHYBA6lKH8V5aYNSRJXHcrrrA9IGStgedZnfSXDhvNDCqLWkgFDkcfmXuhxuSf
Q+Zjtyj/C5bJ65SaKUa4BOdjOOPDIEm5T+0tzxKmN6ajaDCXtXaBNuRVgJcUF/vh
129+kvvjrROqUfVOQMGgzO+OJJvlERTMAAN5XT5RhfBOxw/Hn8aCqJhOBcpGDE+e
56ggocoH9mY/UGkee+aPDfYktV1ni+1A9auEjmi38LXpwHTesP8hl0bFkoJM8xiU
x/73x87K5rL/jr5q/op/RqMCoxfyiEj2G2KnHUR0egzeZinLPqY3QlihL9CSPJZh
JjIhTQK8UYv4y3mU2LhRszMm4fJCM0VsCb5XUB9uCEDJKhyk8QA1MSPtKTx8MVZD
7bfOQpUCI33AHZzcBXes
=IEQT
-----END PGP SIGNATURE-----

--gneEPciiIl/aKvOT--
