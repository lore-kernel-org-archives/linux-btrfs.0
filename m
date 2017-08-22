Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33356 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932615AbdHVMkh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 08:40:37 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1dk8U0-0007WC-SS
        for linux-btrfs@vger.kernel.org; Tue, 22 Aug 2017 12:40:36 +0000
Date: Tue, 22 Aug 2017 12:40:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822124036.GA32302@carfax.org.uk>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <20170822122350.GA14804@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 22, 2017 at 02:23:50PM +0200, Ulli Horlacher wrote:
> How do I find the root filesystem of a subvolume?
> Example:
> 
> root@fex:~# df -T 
> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> -              -    1073740800 104244552 967773976  10% /local/.backup/home

   I've never seen the "- -" output from df before. Is this a bind
mount or something?

> root@fex:~# btrfs subvolume show /local/.backup/home
> /local/.backup/home
>         Name:                   home
>         uuid:                   f86a2db0-6a82-124f-9a71-1cd4c20fd6fb
>         Parent uuid:            ba4d388f-44bf-7b46-b2b8-00e2a9a87181
>         Creation time:          2017-08-10 22:19:15
>         Object ID:              383
>         Generation (Gen):       148
>         Gen at creation:        148
>         Parent:                 5
>         Top Level:              5
>         Flags:                  readonly
>         Snapshot(s):
> 
> 
> I know, the root filesystem is /local, but who can I show it by command?

   Probably in /proc/self/mountinfo -- that should give you the full
set of applied mount options, plus the original source for the mount
(which will be a block device for most filesystem mounts, a path for
bind mounts, or something FS-specific for network filesystems).

   Hugo.

-- 
Hugo Mills             | And what rough beast, its hour come round at last /
hugo@... carfax.org.uk | slouches towards Bethlehem, to be born?
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                         W.B. Yeats, The Second Coming

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZnCZEAAoJEFheFHXiqx3kfwQP/AjO9Ey9WItpMx7v0AX45U0a
6Ozc+qONUYz5sDJ6A0wrtkRTiotDscjPdjbAw/P69c6zVPq3ML7d/zKTitjeSPfQ
K7ekOMan8l9xbtSYSibiCAJQZ8x+Njg7HHsDJ2gUE2H8BnU8zIK2A4kbW4FBAeVl
INTWRBDFtGN/4L4AxFO4SkYgOIcwkjWZTwmpEmBN/U+ovJzGO+pvhla79jEPgMgN
JujJg52+P/9kFXkC1mcLyuxVXK/pUFOAoYDkaKr82mdXP6i8Bdp74wJIH1GURdaN
ZBueEYmqCrrhcehlRJKZzsuOns5LOZ2H0HA9MD/QTMFuqc82rRjyz1X+cN5c26UF
X6U9MQWQo7QyCk22sSffETzDarhWl4YKKrBeJ8OUS6Fv5FJJjuPHg4M8T9ZG5/oa
B88fQ8Br7rMnKFoCUbmhW9lYzXWClzJtCSn/PqzYHbDs53MssNEbBSIaCFjAyHrP
iw/7Tpw594EvjMU/nqWf8Tvyg9IUfL5hwLCfKn9QBPBiF04vNnjUcnBgIlnVtBdR
B0saAcQk1Y+uIl32Bg4MsrUHS8h9SICo6TPkK/bm9BbeLzc93GKW7P4/WFsTQWGq
k++cDZmZdug5XQ1FugoYMxbTVV2MGGvHRJI03avjjvRqfx7DhV37lWZTVJZ32Jpt
P0MxqxJSEC9Yo/RhPh9/
=oaoB
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
