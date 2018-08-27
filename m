Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eugene2.servers.bright.gdn ([51.15.99.23]:44292 "EHLO
        eugene2.servers.bright.gdn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727171AbeH1Aya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 20:54:30 -0400
Received: from linux.local (unknown [213.21.30.38])
        by eugene2.servers.bright.gdn (Postfix) with ESMTPSA id B76B2166D53
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 00:06:09 +0300 (MSK)
From: Eugene Bright <eugene@bright.gdn>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS support per-subvolume compression, isn't it?
Date: Tue, 28 Aug 2018 00:05:59 +0300
Message-ID: <9433856.DUzOFri1R6@linux.local>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1789233.y2Kkvoq8n4"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1789233.y2Kkvoq8n4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Greetings!

BTRFS wiki says there is no per-subvolume compression option [1].

At the same time next command allow me to set properties per-subvolume:
        btrfs property set /volume compression zstd

Corresponding get command shows distinct properties for every subvolume.
Should wiki be updated?

-- 
King regards
Eugene Bright
IT engineer

--------
[1] https://btrfs.wiki.kernel.org/index.php/Compression#Can_I_set_compression_per-subvolume.3F
--nextPart1789233.y2Kkvoq8n4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEERtTEikLGad2ULk9Zvc2vv3xe74IFAluEZ7cACgkQvc2vv3xe
74LSaAf+KdvGarKFCFCmXJKwP1vsbGetGz7FDJ6oEiL3xYF1TPuvoSM0H9ZguAyY
rnHn0L/k4NCtvZd4lABMcK8DhkTz7TBUwQe8DF+qG31sNvAilCFUbMdtoRVeKD1Y
gGjiD5eNtnJ57/oPEYBAQZO0wF5hdey4rZxglc7qTu00dETHKHtlQdYPWNbJ8Hqo
cv3tkhBUqNGr6s3qKOcUFqHuwwHcBpYP/GIRjTY7g9CaQ5IZagqzyRXpJ88z2hPW
sz1qX7yMt9oL1sDZkwIaQn8VUolkJRiCSLYkoCISK3fm1NjS6qlTBtbJcVOEwFbl
ur+qardDabsTYoH6d41ZVTb6vgEYLg==
=r58k
-----END PGP SIGNATURE-----

--nextPart1789233.y2Kkvoq8n4--
