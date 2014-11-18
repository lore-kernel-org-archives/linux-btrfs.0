Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:58628 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaKRUS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 15:18:27 -0500
Received: by mail-qg0-f53.google.com with SMTP id z107so17997225qgd.12
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 12:18:26 -0800 (PST)
Message-ID: <546BA96D.4050805@ubuntu.com>
Date: Tue, 18 Nov 2014 15:17:49 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com> <pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net> <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
In-Reply-To: <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/18/2014 2:17 PM, Chris Murphy wrote:
> What if you have a Btrfs raid1 volume using two LV’s and then 
> snapshot both LV’s?

That's even more silly than a single lvm snapshot under btrfs.  Just
don't do it.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUa6lsAAoJEI5FoCIzSKrwzicIAJLXrsVpWxsI+wq8xGGumwoy
s2QGUZ3Soknr30FAeZWFpS7diXOuuOWXjaObTlFMcUAqGE134d4I3W+k2PxejHns
AfdKSdyiactcndea6aw5zBGzdk5N5bLaoCaS8GSeKVdIMWlLFh+lMzHX2q6tC+cS
8RWJI7GYk193RmWkHKUhX57J9tnP7eJmXTkqdRJIDXmaaceYLR8057LZbNsuurFA
h0ZptXKFUhp6dsEMV5JPnxKZ9l62ZNcL5zEE3D7sVU20ll/YEP7UHOYY/JTGwdLN
KWOUIJ89gM6LqWTz2gFuz8JhPhmZCIKrpN6Fu/pKDHYSrdYyazZV/D6P/dX5TUA=
=3LdX
-----END PGP SIGNATURE-----
