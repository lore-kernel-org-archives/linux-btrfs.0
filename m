Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63269 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaKSTX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 14:23:28 -0500
Received: by mail-qc0-f174.google.com with SMTP id c9so963703qcz.33
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 11:23:27 -0800 (PST)
Message-ID: <546CEE27.10706@ubuntu.com>
Date: Wed, 19 Nov 2014 14:23:19 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>	<54699CC7.1050909@swiftspirit.co.za>	<546A46A5.8030603@inwind.it>	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>	<546B68F8.6080008@ubuntu.com>	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>	<546BA96D.4050805@ubuntu.com>	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>	<546CB531.2060509@ubuntu.com> <CAJCQCtR6CZq2iz4_cP5Es4HHGsZiOmo55w8iy6MT+cEN0BE0yQ@mail.gmail.com>
In-Reply-To: <CAJCQCtR6CZq2iz4_cP5Es4HHGsZiOmo55w8iy6MT+cEN0BE0yQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 1:33 PM, Chris Murphy wrote:
> Thin volumes are more efficient. And the user creating them doesn't
> have to mess around with locating physical devices or possibly
> partitioning them. Plus in enterprise environments with lots of
> storage and many different kinds of use cases, even knowledable
> users aren't always granted full access to the physical storage
> anyway. They get a VG to play with, or now they can have a thin
> pool and only consume on storage what is actually used, and not
> what they've reserved. You can mkfs a 4TG virtual size volume, 
> while it only uses 1MB of physical extents on storage. And all of 
> that is orthogonal to using XFS or Btrfs which again comes down to 
> use case. And whether I'd have LVM mirror or Btrfs mirror is again 
> a question of use case, maybe I'm OK with LVM mirroring and I just 
> get the rare corrupt file warning and that's OK. In another use 
> case, corruption isn't OK, I need higher availability of known
> good data therefore I need Btrfs doing the mirroring.

Correct me if I'm wrong, but this kind of setup is basically where you
have a provider running an lvm thin pool volume on their hardware, and
exposing it to the customer's vm as a virtual disk.  In that case,
then the provider can do their snapshots and it won't cause this
problem since the snapshots aren't visible to the vm.  Also in these
cases the provider is normally already providing data protection by
having the vg on a raid6 or raid60 or something, so having the client
vm mirror the data in btrfs is a bit redundant.




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUbO4nAAoJEI5FoCIzSKrwl/QIAJ7arJ0ZXVc16pBRjE2F66uV
GAOhatdx8pLhGey6by+gV8Ltvx4bK3BG40dkvQIM9RN9UFC5vofQ4FnzIn1nfXZB
qyyITE2mF+lE3RNCb8ZKxwG58rfa9NOModPCeNVFWkS6+fyyhGY23sliWbVO6b15
w6BD5xu/Pp7Fhgkx81AL07XpusR9c8pKZd8ZHw4nozFHw20+13XuL+2g8axpZS+O
Xd9W5GRlC+0k9jQ0q9xGi1jh6QpjMSWVj54MNS5jRubsY65TtmFPkdvgaMGD4U5k
bADSEUMfij9NRMw8VwA4ik/JEi1IbukD4u1geKeZTowMGXReel2RimeA/PhFYcc=
=tmDI
-----END PGP SIGNATURE-----
