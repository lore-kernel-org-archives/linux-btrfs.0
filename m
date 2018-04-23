Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39513 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbeDWGNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 02:13:10 -0400
Subject: Re: 4.17-rc1 FS went read-only during balance
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
References: <20180421175548.4b07dffc@demfloro.ru>
 <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
 <20180423080745.5a9dc6be@demfloro.ru>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3d2443c8-0b34-2eea-3adc-2f33570f75b1@gmx.com>
Date: Mon, 23 Apr 2018 14:13:03 +0800
MIME-Version: 1.0
In-Reply-To: <20180423080745.5a9dc6be@demfloro.ru>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yk4kOR1blRcO1oXUI3FlsRRPKsKoEqxDL"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yk4kOR1blRcO1oXUI3FlsRRPKsKoEqxDL
Content-Type: multipart/mixed; boundary="M9kmVi72YCA94yRhOB59lUNSX73L9AUsm";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Dmitrii Tcvetkov <demfloro@demfloro.ru>, linux-btrfs@vger.kernel.org
Message-ID: <3d2443c8-0b34-2eea-3adc-2f33570f75b1@gmx.com>
Subject: Re: 4.17-rc1 FS went read-only during balance
References: <20180421175548.4b07dffc@demfloro.ru>
 <5775f38a-5f17-1f6d-a6cd-289e18188a26@gmx.com>
 <20180423080745.5a9dc6be@demfloro.ru>
In-Reply-To: <20180423080745.5a9dc6be@demfloro.ru>

--M9kmVi72YCA94yRhOB59lUNSX73L9AUsm
Content-Type: multipart/mixed;
 boundary="------------860A16B7428CEACBC6C6BF3C"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------860A16B7428CEACBC6C6BF3C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8823=E6=97=A5 13:08, Dmitrii Tcvetkov wrote:
> On Mon, 23 Apr 2018 09:23:53 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>=20
>> On 2018=E5=B9=B404=E6=9C=8821=E6=97=A5 22:55, Dmitrii Tcvetkov wrote:
>>> TL;DR It seems as regression in 4.17, but I managed to find a
>>> workaround to make filesystem rw mountable again.
>>>
>>> Kernel built from tag v4.17-rc1
>>> btrfs-progs 4.16
>>>
>>> Tonight two my machines (PC (ECC RAM) and laptop(non-ECC RAM)) were
>>> doing usual weekly balance with this command via cron:
>>> btrfs balance start -musage=3D50 -dusage=3D50 <mountpoint>
>>> Both machines run same kernel version.=20
>>>
>>> On PC that caused root and "data" filesystems to go readonly. Root
>>> is on an SSD with data single and metadata DUP, "data" filesystem
>>> is on 2 HDDs with RAID1 for data and metadata.
>>>
>>> On laptop only /home went ro, it's on NVMe SSD with data single and
>>> metadata DUP.=20
>>>
>>> Btrfs check of PC rootfs was without any errors in both modes, I did
>>> them once each before reboot on readonly filesystem with --force
>>> flag and then from live usb. Same output without any errors.
>>>
>>> After reboot kernel refused rw mount rootfs with the same error as
>>> during cron balance, ro mount was accepted, error during rw mount:
>>> BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=3D-117  =

>=20
>> 117 means EUCLEAN, which could be caused by the newly introduced
>> first_key and level check.
>=20
>> Please apply this hotfix to fix it.
>> btrfs: Only check first key for committed tree blocks
>> (Which is included in latest pull request)
>=20
>> Also, please consider enable CONFIG_BTRFS_DEBUG to provide extra
>> debug info.
>=20
>> Thanks,
>> Qu
>=20
> I tried 4.17-rc2 (as the pull request was pulled) with
> CONFIG_BTRFS_DEBUG on LVM snapshot of laptop home partition (/dev/vdb)
> in a VM (VM kernel sees only snapshot so no UUID collisions). Dmesg
> attached.

Thanks for the info and your previous btrfs-image.

The image itself shows nothing wrong, so it should be runtime problem.
Would you please apply these two debug patches?
https://patchwork.kernel.org/patch/10335133/
https://patchwork.kernel.org/patch/10335135/

And the attached diff file?

My guess is the parent node is not initialized correctly in this case.

Thanks,
Qu

--------------860A16B7428CEACBC6C6BF3C
Content-Type: text/x-patch;
 name="debug.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="debug.diff"

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..79f482578e02 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -458,6 +458,7 @@ static int verify_level_key(struct btrfs_fs_info *fs_=
info,
 			  eb->start, first_key->objectid, first_key->type,
 			  first_key->offset, found_key.objectid,
 			  found_key.type, found_key.offset);
+		btrfs_print_tree(eb, false);
 	}
 #endif
 	return ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00b7d3231821..cde0cb6c9786 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1870,6 +1870,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 					     level - 1, &first_key);
 			if (IS_ERR(eb)) {
 				ret =3D PTR_ERR(eb);
+				btrfs_err(fs_info, "parent leaf, slot: %d:", slot);
+				btrfs_print_tree(parent, false);
 				break;
 			} else if (!extent_buffer_uptodate(eb)) {
 				ret =3D -EIO;

--------------860A16B7428CEACBC6C6BF3C--

--M9kmVi72YCA94yRhOB59lUNSX73L9AUsm--

--yk4kOR1blRcO1oXUI3FlsRRPKsKoEqxDL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrdeW8ACgkQwj2R86El
/qjSPAf/dT7YHKsS9YfGBByGXM4yqhEUUpJEY/L/bFnMUjuW2wNTUBm3UOMwBLI3
dkds19F2D523tqtbMBXOd2NCK2gX/p5Z0Q5mLD2pH/7a0sHFLX5svVWMOTywgxge
k/Ej7BaV+WepuBbrtL3mIpGHYbWRL5HPFkK/XmH9t4WodrRQhgxQ5bnDRDnTwh7u
XWJB4Bpl/94rcMhBBlzSfHX8N651HaL8Dvsenm4A1u9fCDD2WF2mmOmR0q3GbDQd
w7Hq52sovip3/gMH4p/KyGj2FsQaJEk3pL8MHE7xkWYPAx5zuqbvoL9WcITWdfZV
za10WxUSUaLruosgSfC4bpEr4X9BoA==
=QZsN
-----END PGP SIGNATURE-----

--yk4kOR1blRcO1oXUI3FlsRRPKsKoEqxDL--
