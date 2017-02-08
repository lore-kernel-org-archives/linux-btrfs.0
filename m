Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34308 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754465AbdBHBuF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 20:50:05 -0500
Received: by mail-io0-f180.google.com with SMTP id l66so105308271ioi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 17:49:33 -0800 (PST)
Received: from DigitalMercury.dynalias.net (mtrlpq0313w-lp130-01-70-50-10-135.dsl.bell.ca. [70.50.10.135])
        by smtp.gmail.com with ESMTPSA id y124sm241985itd.19.2017.02.07.17.49.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2017 17:49:32 -0800 (PST)
Date: Tue, 7 Feb 2017 20:49:31 -0500
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: user_subvol_rm_allowed?  Is there a user_subvol_create_deny|allowed?
Message-ID: <20170208014931.GA22397@DigitalMercury.dynalias.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear btrfs community,

Please accept my apologies in advance if I missed something in recent
btrfs development; my MUA tells me I'm ~1500 unread messages
out-of-date. :/

I recently read about "mount -t btrfs -o user_subvol_rm_allowed" while
doing reading up on LXC handling of snapshots with the btrfs backend.
Is this mount option per-subvolume, or per volume?

Also, what mechanisms to restrict a user's ability to create an
arbitrarily large number of snapshots?  Is there a
user_subvol_create_deny|allowed?  What I've read about the inverse
correlation between number of subvols to performance, a potentially
hostile user could cause an IO denial of service or potentially even
trigger an ENOSPC.

=46rom what I gather, the following will reproduce the hypothetical
issue related to my question:

# as root
btrfs sub create /some/dir/subvol
chown some-user /some/dir/subvol

# as some-user
cd /home/dir/subvol
cp -ar --reflink=3Dalways /some/big/files ./
COUNT=3D1
while [ 0 -lt 1 ]; do
  btrfs sub snap ./ ./snapshot-$COUNT
  COUNT=3DCOUNT+1
  sleep 2   # --maybe unnecessary
done

--

I hope there's something I've misunderstood or failed to read!

Please CC me so your reply will hit my main inbox :-)
Nicholas

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJYmnkrAAoJEFqIMEdffRBhnP0QALF+pS5308iLjJMEghxmf9Du
owpDdVXJMOkbzG13p1sniU1k5F20d+1OctkPtGZliu+0r1foXHgM/yo6Rl65kEPA
MzChJgB1+0xoQ9wx1JktE1Ot0nPV7ktHAsEdD462VbRa3xJzybywLB0551Aj0Xod
EeX/LP8y+/Ipmzwe81UNVm4/JKF4li8NUwBhdrPKu3WPrRBCq2/AqiKXU6mHibfh
HoF/b+IOG4yC5WpEw+g6XJFi10VBRR28AYEPkL44vRidb5oyW0cPfvD115aWzvPN
ffu9L1QGFqP7WQAf6zZFN8fBS1mAWl64QKP+7w6J35KZfelNk1YkSIRwdcHcvxAL
D2bwpJUe5x/6xOe6RNyyY88JzZDyOaCWXh8eMgXMqB+xJJFzaLJsBJ4xM1XpJQtd
ouTATTaiOBFJc0ovoZmfhgO7BvZC5sXwkhrhbWuaozQRXsJ6qHmnJVCAYXYt4Wgo
ZAGXvA37HXU50bbcNLy04WboGxoVfu8+hKUvZM0iLultF7ALh4PVcIaOuve4KVS6
60Y8qVR/zaspT43RPCRyBZiWfovxici1YWMu/uDiBfj7iL8760rgtv6wvJDVsxYP
GIWclkNNqdxA8td2xGy8ftUXBONKaiP/212O1Tqew1BTrrL/NTTpLcGn3ehnHJfE
d72iNWO2QvReI6Y6vkBf
=WIhc
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
