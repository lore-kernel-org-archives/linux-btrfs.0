Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35080 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaKSPU0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 10:20:26 -0500
Received: by mail-qa0-f46.google.com with SMTP id u7so516827qaz.5
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 07:20:25 -0800 (PST)
Message-ID: <546CB531.2060509@ubuntu.com>
Date: Wed, 19 Nov 2014 10:20:17 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com> <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
In-Reply-To: <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 9:54 PM, Chris Murphy wrote:
> Why is it silly? Btrfs on a thin volume has practical use case
> aside from just being thinly provisioned, its snapshots are block
> device based, not merely that of an fs tree.

Umm... because one of the big selling points of btrfs is that it is in
a much better position to make snapshots being aware of the fs tree
rather than doing it in the block layer.

So it is kind of silly in the first place to be using lvm snapshots
under btrfs, but it is is doubly silly to use lvm for snapshots, and
btrfs for the mirroring rather than lvm.  Pick one layer and use it
for both functions.  Even if that is lvm, then it should also be
handling the mirroring.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbLUxAAoJEI5FoCIzSKrwh0oH/3TZ2oo8u2BjHYO3b0x8800/
LFkmGFWrZFSnAvtWuN5B1WlhMXku4dxLRXz14fJKFp3fNmnYRNVvw3tu9btvsBsC
sZdwLaKwKPHTK8RS+QCI2pZPX+cGB+F7/z9PCHrzIzzCKk/4SvnJ76e2nnZFpY1m
Md3f1BCHEVUPMMXbqv6Ry6v7PDs/8bx8WITYyAL9uh3tjh0dXQsjbZJn5u4XDitS
/CoE8eX4rf1vc7qHI4K56TtArCcXQxAHcC56fXmcmS03bVhAkkJ5Z+/uwi6+TkJe
55rMFCd7UFy9pwKha3Q2flJHtDYG6ns7Njyff6BSL9Yzq7tHh4wLk1H3XxaOCP8=
=ktv/
-----END PGP SIGNATURE-----
