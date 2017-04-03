Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 67-129-172-163.rev.cloud.scaleway.com ([163.172.129.67]:58246
        "EHLO mail1.sd85.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdDCRxJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 13:53:09 -0400
Subject: Re: BTRFS corruption after hardware issues
To: linux-btrfs@vger.kernel.org
References: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>
From: Brian B <brian@sd85.net>
Message-ID: <aa3991f3-e377-c5b9-2e12-a2986faf40a5@sd85.net>
Date: Mon, 3 Apr 2017 13:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="lN5WExCChkT6BwlfkfGAXsXRHKbB70nEJ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lN5WExCChkT6BwlfkfGAXsXRHKbB70nEJ
Content-Type: multipart/mixed; boundary="trNENqNJF2xBCb9aioUFVHFA2Uo5S63Dc";
 protected-headers="v1"
From: Brian B <brian@sd85.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <aa3991f3-e377-c5b9-2e12-a2986faf40a5@sd85.net>
Subject: Re: BTRFS corruption after hardware issues
References: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>
In-Reply-To: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>

--trNENqNJF2xBCb9aioUFVHFA2Uo5S63Dc
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/03/2017 11:26 AM, Brian B wrote:
> I had a stick of memory go bad in my server, and after removing it my
> BTRFS filesystem seems to be damaged.
>
> If I mount the volume rw and try to use the volume, most actions will
> hang, and I get btrfs-transactio related errors in the logs.
>
> 'btrfsck --repair' seems to sit in a loop, printing the same messages
> about attempting to repair a dozen or so inodes over and over again.
>
> I can mount the volume with '-o ro,recovery', but some folders are
> missing from the current live volume.  It looks like some of the nodes
> are still there, just orphaned or something.  For instance, from btrfsc=
k:
>
>
> root 551 inode 102353 errors 2001, no inode item, link count wrong
>         unresolved ref dir 261 index 0 namelen 5 name dir1 filetype 2
> errors 6, no dir index, no inode ref
>
>
> So is there some way I can mount that as a root, or re-link it to the
> rest of the tree somehow?
>
So, turns out that although the directories don't SHOW in an ls, I can
still navigate to them:


# ls __current/pictures

mom

# ls __current/pictures/dad

2006-2008


I'll be trying to get the data off these later tonight when I can plug
in an extra HDD.



--trNENqNJF2xBCb9aioUFVHFA2Uo5S63Dc--

--lN5WExCChkT6BwlfkfGAXsXRHKbB70nEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY4owAAAoJEOrm+yJI9jqLS6wP/1L3KLBZA70pNNX6bIjACLO2
jIDphb7dEtTUL0faQYbZsyrv+NZf7O80VfzCIPY8fOhW0z+VBxwoYONlDziCNpRO
FOkk/DuZL5FgpkyLq42BN9BtVW9IBXeQYo4RCHYkKkBqI4iwtTZ6t+5zgrWmSrlk
7kwU6CR5GpimvjFMulKgzj9sQQG3Giz6CF/gvKQClANrYbHHSFPTkMK1AfgRT6mr
2E4azdwRdk8L39JN21Q5Z+4NiQibtnt5tW5e/+SMSeqPFqZXjNLCv1gqQJZ8lx4w
BVBj1Erm61bjKFMCy1r+xCRp849TtXWaHn2xqjDu52kyVrBPb73Lb6nJldc22Q5X
rS31oq85NV/O/0wV6iN0JXEhYeaEJO85vH4BGtDpX4zFqX3VOTJcn7KUqLDN6oEw
knMF3UJr6lpthTVLQnSYhizFyf0nFeTNxakm8aqfirFNLvHaNIfGZazo9D8RW2cE
nSmCzSyJr/aYEWS5RMrC8/yLkc1qsaOaybDWXBInB+fJWJ+qlMkgfM+yI0rARzTb
Y63BmoBsbZp3HRoqiiFWAL5Uk2SdqU/W9qm+Y6hJQhB7IImT1Fzpd/I3uXTANbQw
iFrAEwe4l9sMD/j5Qaf2wpix0li002YogUOi9LcdpZnKEAYt0YgzWl1y7P6oVoJl
fOgAIv89NYqqQlI/gu60
=x0Ri
-----END PGP SIGNATURE-----

--lN5WExCChkT6BwlfkfGAXsXRHKbB70nEJ--
