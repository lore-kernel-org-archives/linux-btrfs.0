Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34753 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754615AbcILMds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:33:48 -0400
Subject: Re: btrfs kernel oops on mount
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        moparisthebest <admin@moparisthebest.com>, linux-btrfs@vger.kernel.org
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
Date: Mon, 12 Sep 2016 14:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HjnlRmepHwaIatai5ojrMaaObhh6ueC7f"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HjnlRmepHwaIatai5ojrMaaObhh6ueC7f
Content-Type: multipart/mixed; boundary="wD1beokovsi3GktJBQ5HgF4NpD4H6Cxmp";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 moparisthebest <admin@moparisthebest.com>, linux-btrfs@vger.kernel.org
Message-ID: <357b5b17-f84e-7f09-ad2d-c4700da0bf9c@suse.com>
Subject: Re: btrfs kernel oops on mount
References: <6fa4d5f1-1697-8817-c1b8-098afc011902@moparisthebest.com>
 <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>
In-Reply-To: <48fdc597-2431-0335-a6e5-da413615ecd0@gmail.com>

--wD1beokovsi3GktJBQ5HgF4NpD4H6Cxmp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/9/16 8:47 PM, Austin S. Hemmelgarn wrote:
> A couple of other things to comment about on this:
> 1. 'can_overcommit' (the function that the Arch kernel choked on) is
> from the memory management subsystem.  The fact that that's throwing a
> null pointer says to me either your hardware has issues, or the Arch
> kernel itself has problems (which would probably mean the kernel image
> is corrupted).

fs/btrfs/extent-tree.c:
static int can_overcommit(struct btrfs_root *root,
                          struct btrfs_space_info *space_info, u64 bytes,=

                          enum btrfs_reserve_flush_enum flush)

> 3. In general, it's a good idea to keep an eye on space usage on your
> filesystems.  If it's getting to be more than about 95% full, you shoul=
d
> be looking at getting some more storage space.  This is especially true=

> for BTRFS, as a 100% full BTRFS filesystem functionally becomes
> permanently read-only because there's nowhere for the copy-on-write
> updates to write to.

The entire point of having the global metadata reserve is to avoid that
situation.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--wD1beokovsi3GktJBQ5HgF4NpD4H6Cxmp--

--HjnlRmepHwaIatai5ojrMaaObhh6ueC7f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX1qCpAAoJEB57S2MheeWyOdUQAIUapXVcUW/MTqn3vh22byAk
b7eY7ucePDKy/QJTsLWRPM76JA87e1cxuZdaJlVxRWzTTnjqLxZSatBAxT4m2fV6
AhfHlv/ACsUYCrc28G73Dood355MhjkEpfgdxLFoc0vY9QW9/5iqzPBkNIAVjEyU
/oTyLN3KkatpX3McZmxp+knFaBiikT6E1sKAy8qNACY3l9pwrXFdGKSAfG3bwyqf
eZHkD+VkYJ10/z8m4Rp+PcVkBZOOSBth35U4c9kRIcIP8LdwP9cPPCpK1X7mKdeJ
7cuT6l/jVEzwYPG0/78Yrxfal/X7Z1nIvPGRbL2U4tyhABW0DCugtkoP23rwMnzb
zLhojYJar6ceJvD2GBc0PcWq41rw3AGSF/4jgri1ezKz0jT1k5RNg8Wwww8q4llV
XM1sp7HM2oKvwd2kPRrZZpuRnKCFuw6hIjCaILgnPOym9rK2qafMVlz4brfcJxJb
tH5x8DnAt2Jnzjr/QlmQ2JYq6xSyvYsYYV9GeDAKpyyqiMqR2f9/jX1Id7EtGSkx
YEx5ZxruQIlbVO50QJ/ZusXAG0a8yKcq9idihPTN6FHHtTGcBfwAalsGFiLdKfJT
/uu9Uxr91aDPDmr3QCsJxdL7Mnp9sWLlVlowWmzFV9TKgP7qn1KbDPuG/kr3wA54
RY8VQcV7v2woARYhGI5E
=NtOS
-----END PGP SIGNATURE-----

--HjnlRmepHwaIatai5ojrMaaObhh6ueC7f--
