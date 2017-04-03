Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 67-129-172-163.rev.cloud.scaleway.com ([163.172.129.67]:52296
        "EHLO mail1.sd85.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753946AbdDCPgZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 11:36:25 -0400
To: linux-btrfs@vger.kernel.org
From: Brian B <brian@sd85.net>
Subject: BTRFS corruption after hardware issues
Message-ID: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>
Date: Mon, 3 Apr 2017 11:26:33 -0400
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="qVHl64m6MqooBPSRS0d62lRettPie8xef"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qVHl64m6MqooBPSRS0d62lRettPie8xef
Content-Type: multipart/mixed; boundary="JbdSFdj7bodhI4uu9AMfTbIOXQgUWHgAo";
 protected-headers="v1"
From: Brian B <brian@sd85.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <f0753ae9-6842-d180-49db-435d6993dafc@sd85.net>
Subject: BTRFS corruption after hardware issues

--JbdSFdj7bodhI4uu9AMfTbIOXQgUWHgAo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I had a stick of memory go bad in my server, and after removing it my
BTRFS filesystem seems to be damaged.

If I mount the volume rw and try to use the volume, most actions will
hang, and I get btrfs-transactio related errors in the logs.

'btrfsck --repair' seems to sit in a loop, printing the same messages
about attempting to repair a dozen or so inodes over and over again.

I can mount the volume with '-o ro,recovery', but some folders are
missing from the current live volume.  It looks like some of the nodes
are still there, just orphaned or something.  For instance, from btrfsck:=



root 551 inode 102353 errors 2001, no inode item, link count wrong
        unresolved ref dir 261 index 0 namelen 5 name dir1 filetype 2
errors 6, no dir index, no inode ref


So is there some way I can mount that as a root, or re-link it to the
rest of the tree somehow?


--JbdSFdj7bodhI4uu9AMfTbIOXQgUWHgAo--

--qVHl64m6MqooBPSRS0d62lRettPie8xef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY4mmpAAoJEOrm+yJI9jqLjYgQAM4tfX7Xfdhu+C5uAvEDfGNx
W76jMklX3VUgs3V0iyR2uJtNxlkIjkFneJEFyxlxqmRSWa+cq52bQ/8LHqQb9qPD
4BZxOZ6OQe7+TqaQpRcgYEFRRl8JGZBbAuJ8PXNNotDz6D4qZojeiLljOrjtYeKJ
wWdIjfZWfZUyg0GG4TvT5lreiIKpQLZh3S51IKSOxTOeMIAYky2yrDmkqsoO4m/n
nUo1ZkhcWDuwKDa0b6/LIFw1L/Fg+KXPIgyIAmzzE+X+SOEoRUsW7SPOk999lbMq
FvAf+5xz8RFea9eXmkT3uUGjt6bjTo1qnjDOhqKuMoBML3fanHd3RIUrrEWWuLDq
zA23glq6VXdv/GVI2YmJXSaARQs6kQniZYnXsH0RvwlqJKZq1/QNpmWsjZ3WtzXH
CbskjfIagEbpoAGveU1GBIlQs3vqnGMqaoL6ZsS+luA/JJcsNJwN3akp64TiItVY
cpwam8kzkw9qq45AzYMIqQCf+f5X2j3VJOmvl8MTS1N3NEovr+IRlpLX7p5hoNgQ
VHghGaDQ39Z6LiDkq9g5QrLjTiRexQNthu6gKpsIiJw2ChiaOt7X1k8kJdgyNpyL
G8zosqhNXhUhGe3LA1fzWCf+XXlc+DHq0WseAJB84B/T3oEi/t7ratOXsaxnATB2
eNBBO5R2hWzLH71ICR07
=rHH/
-----END PGP SIGNATURE-----

--qVHl64m6MqooBPSRS0d62lRettPie8xef--
