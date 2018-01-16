Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59673 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbeAPEvq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 23:51:46 -0500
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
Date: Tue, 16 Jan 2018 12:51:23 +0800
MIME-Version: 1.0
In-Reply-To: <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UOgGw4ZaxERqWiEqqmpjosfEPpFBpV7CP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UOgGw4ZaxERqWiEqqmpjosfEPpFBpV7CP
Content-Type: multipart/mixed; boundary="d7CDxtBjZJcXlOls5OE61zlMy561woOgp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Message-ID: <fbd3016e-51c9-ae21-4fce-8b878a14f9ea@gmx.com>
Subject: Re: invalid files names, btrfs check can't repair it
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115090049.6tcnoadsam7adsea@breakpoint.cc>
In-Reply-To: <20180115090049.6tcnoadsam7adsea@breakpoint.cc>

--d7CDxtBjZJcXlOls5OE61zlMy561woOgp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Now the problems are all located:

For file "2f3f379b2a3d7499471edb74869efe-1948311.d", it's the problem of
its DIR_ITEM has wrong type:

------
        item 14 key (57648595 DIR_ITEM 3363354030) itemoff 3053 itemsize =
70
                location key (57923894 INODE_ITEM 0) type DIR_ITEM.33
                                                          ^^^^^^^^^^^
------

There is unexpected type DIR_ITEM and a special number 33 here.

Despite that, the file is completely fine.


For file "454bf066ddfbf42e0f3b77ea71c82f-878732.o"
The problem is its namelen.

------
        item 13 key (57648595 DIR_ITEM 3331247447) itemoff 3123 itemsize =
69
                location key (58472210 INODE_ITEM 0) type FILE
                transid 89418 data_len 0 name_len 8231
                                                  ^^^^ Insane
                name: 454bf066ddfbf42e0f3b77ea71c82f-878732.oq
------

Despite that, it should be fine.

I'm not 100% sure if repair can really handle it well.
But I could craft a temporary fix based on btrfs-corrupt-block (I know
the name is scary).
And you may need to compile btrfs-progs with my patch.

The only remaining thing I need is the subvolume id which contains the
corrupted files.

Since there is no other hit, I assume it's root subvolume (5), but I
still need the extra confirm since the fix will be hard-coded.

Thanks,
Qu


--d7CDxtBjZJcXlOls5OE61zlMy561woOgp--

--UOgGw4ZaxERqWiEqqmpjosfEPpFBpV7CP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpdhMsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjQCgf+N1VW5BRJPE/NAYR4UyHREbuo
dv0sUAU7ld2W8P2Tc83EyDW/Y7BWecoWWljuWCa2NyEgIUKWenz+eZb80EG57heM
CWfY7x1QkBEuBy1d/+BaY25JO/2WIj5yXra3r5KN4bCLwNQkCpuX7ADPAgP2gFMj
v0uorM/Jqeu25V04MjFPPK7Jx9d+9gnV2R2k/Glo2ix6+ly5Rlf2p4/+vFRF6aQi
xYcDTou6QDUfFAtAtf8q+rkrzPMHqP5m+BlEkTeHZttd4liNbfsBCsB7ngKPfumb
Ofp+Es9Y/tfeh3f27B4TTt4CMP4aYeVBeCzuE4XIIR8JUUawfiGaBE5ACWhCLQ==
=z2mL
-----END PGP SIGNATURE-----

--UOgGw4ZaxERqWiEqqmpjosfEPpFBpV7CP--
