From: Daniel Poelzleithner <poelzi@poelzi.org>
Subject: flush-btrfs-1 hangs when building openwrt
Date: Tue, 25 Jan 2011 09:51:01 +0100
Message-ID: <4D3E8EF5.1050008@poelzi.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7B47DFD5A762D5170E5887E"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7B47DFD5A762D5170E5887E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Since update to 2.6.37 I can't build openwrt on my btrfs buildroot anymor=
e.
I'm not sure if this is related to the other flush-btrfs-1 thread.

plenty of diskspace is free:

/dev/mapper/cruor-build
                       97G   68G   27G  73% /opt/build

It always hangs when openwrt builds the ext4 image and runs tune2fs on it=
=2E

/opt/build/fahrenheit/openwrt/staging_dir/host/bin/tune2fs -O
extents,uninit_bg,dir_index
/opt/build/fahrenheit/openwrt/build_dir/linux-x86_kvm_guest/root.ext4
tune2fs 1.41.13 (13-Dec-2010)

the processes can't be killed.

alt-sysctl-t does not show anything, nor is there a oops.

I put the the openwrt config I'm using at https://gist.github.com/794593
, maybe it is reproduceable.

Linux cruor 2.6.37 #2 SMP Thu Jan 20 02:09:59 CET 2011 x86_64 GNU/Linux

Please CC.

kind regards
 Daniel




--------------enigC7B47DFD5A762D5170E5887E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNPo76AAoJEFYpgV2RoepckxMP/irKWho8suwn86CGHpH71uLn
BX9a8upbqA9gaDu5F5rGyNDuofe0GsHL6M1w9R7qYRsQYgpmVIHqQBAPEKFaKuBr
WalyX4L3hIBVbLYvn6zO0O7xgUxOZfrZM1uyx1GnUqaQXUHJPt11t3mBxWB+Uhpm
HhRsjbgqkhLRTkwC9TkFN7K2roTbOdXOWMfOsTKdo2F2HrW30DVGm85gJj+CvMe1
V2Dc9XpcbmdyVJMOhu0RnE4KbQRr5fJsJ8JZKmdRMqoGLB3KBNfc3yBCrRvSfTzC
YcixSgswtgJaNLrlLbxaGdgp/qz0VHUzggwsv388C8lLHX95HhNQ84gLy45rrfRZ
2FzEO3CnfLBigCZNH/PEVoBJoTNdnV2ZX8m2Fhw9g1Yc6WJr5XzHLkxiaPKNhtfZ
z2LdHxniGgt6J++RgAvd/L2qLg7p0m8t7CEXfsLyyXof+NAVkjpkQJjM4EoarsbI
4IicK0jBMMKV7jWFBUsZfanuPhfSELZOKZah4owrCK0CFTWfyoafPeVFOpJoUYUT
7mMdx5rK+jy/IWrBkLwhts0nkKC7erKPZFx+NTs3GeihCnH9xIUBK9pHtvphLVkb
tuEk2RdWYTHCzVCjmfn7S4Tgr+pR70KLOOzFz3X8mljST3LkIbi4Wu5PnDoQOaXQ
0uyFKtb2tw9K8ywQiUCm
=/Ug9
-----END PGP SIGNATURE-----

--------------enigC7B47DFD5A762D5170E5887E--
