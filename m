Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31219 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554AbaLaXi6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 18:38:58 -0500
Message-ID: <54A48910.60701@ubuntu.com>
Date: Wed, 31 Dec 2014 18:38:56 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: ashford@whisperpc.com
CC: Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>    <54A31CAE.4020606@ubuntu.com>    <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>    <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
In-Reply-To: <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 12/31/2014 12:27 PM, ashford@whisperpc.com wrote:
> I see this as a CRITICAL design flaw.  The reason for calling it
> CRITICAL is that System Administrators have been trained for >20
> years that RAID-10 can usually handle a dual-disk failure, but the
> BTRFS implementation has effectively ZERO chance of doing so.

Sure, but you never *count* on that second failure since it is a (
relatively even ) probability game.

> In order to remove this potentially catestrophic confusion, BTRFS
> should either call their "RAID-10" implementation something else,
> or they should adhere to the long-established definition of
> RAID-10.

Personally I'd prefer it follow the way mdadm does it, which is much
better than what the rest of the industry calls raid-10, which is to
say, simply a naive raid-0 on top of raid-1.  I'm very happy with my 3
disk offset layout raid-10 which gets the sequential read throughput
of a 3 disk raid-0, while still being able to handle a single drive
failure.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUpIkQAAoJENRVrw2cjl5R/wAIAKNU0NfEFGXLQK0lB1kZMJQt
WrBjKih8xG2WIYAqYCHoNTWJtmCZOCHtltt+OsUb8Pa8u075ALtEQBRNminLLuqV
LjREOyOzvzaDfNSEhptdBZ4YazqFt6UChWtu7RWhMtb7u61pmqMJatDhxLe+2CF9
YQE3qgLfP+PAMIGO/xN5m+hYba4hbF/MoqQ/XN7Z1VWvT9FNR7Dn8frflpmI2Cyh
iAravNS78hUjbxTtNz1qVXLosDVsjyZpz9UY9occNJ/vlF/GMd5q2c8xXkDTczGB
O9B55OXGzfmzPZzlNJ2MyBLgwQx/huPH8RiyuuIdy3AVubc/pXuAZQqaydf/lQg=
=qwW+
-----END PGP SIGNATURE-----
