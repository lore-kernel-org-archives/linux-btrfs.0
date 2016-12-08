Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53923 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbcLHUH7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 15:07:59 -0500
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <808d0394-db2a-0a15-d084-309accc04ff9@suse.com>
Date: Thu, 8 Dec 2016 15:07:53 -0500
MIME-Version: 1.0
In-Reply-To: <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mMlbDQlnFW5eL8Tk7dfolWxaQMRNBUN1n"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mMlbDQlnFW5eL8Tk7dfolWxaQMRNBUN1n
Content-Type: multipart/mixed; boundary="oFaqa9iI7bFXEps6QD6DQ0J1Qkf7cwAxR";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
 =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>,
 linux-btrfs@vger.kernel.org
Message-ID: <808d0394-db2a-0a15-d084-309accc04ff9@suse.com>
Subject: Re: duperemove : some real world figures on BTRFS deduplication
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>
In-Reply-To: <8da6fc44-2756-0bfd-7d7c-e11529f54f74@gmail.com>

--oFaqa9iI7bFXEps6QD6DQ0J1Qkf7cwAxR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/8/16 10:42 AM, Austin S. Hemmelgarn wrote:
> On 2016-12-08 10:11, Sw=C3=A2mi Petaramesh wrote:
>> Hi, Some real world figures about running duperemove deduplication on
>> BTRFS :
>>
>> I have an external 2,5", 5400 RPM, 1 TB HD, USB3, on which I store the=

>> BTRFS backups (full rsync) of 5 PCs, using 2 different distros,
>> typically at the same update level, and all of them more of less shari=
ng
>> the entirety or part of the same set of user files.
>>
>> For each of these PCs I keep a series of 4-5 BTRFS subvolume snapshots=

>> for having complete backups at different points in time.
>>
>> The HD was full to 93% and made a good testbed for deduplicating.
>>
>> So I ran duperemove on this HD, on a machine doing "only this", using =
a
>> hashfile. The machine being an Intel i5 with 6 GB of RAM.
>>
>> Well, the damn thing has been running for 15 days uninterrupted !
>> ...Until I [Ctrl]-C it this morning as I had to move with the machine =
(I
>> wasn't expecting it to last THAT long...).
>>
>> It took about 48 hours just for calculating the files hashes.
>>
>> Then it took another 48 hours just for "loading the hashes of duplicat=
e
>> extents".
>>
>> Then it took 11 days deduplicating until I killed it.
>>
>> At the end, the disk that was 93% full is now 76% full, so I saved 17%=

>> of 1 TB (170 GB) by deduplicating for 15 days.
>>
>> Well the thing "works" and my disk isn't full anymore, so that's a ver=
y
>> partial success, but still l wonder if the gain is worth the effort...=

> So, some general explanation here:
> Duperemove hashes data in blocks of (by default) 128kB, which means for=

> ~930GB, you've got about 7618560 blocks to hash, which partly explains
> why it took so long to hash.  Once that's done, it then has to compare
> hashes for all combinations of those blocks, which totals to
> 58042456473600 comparisons (hence that taking a long time).  The block
> size thus becomes a trade-off between performance when hashing and
> actual space savings (smaller block size makes hashing take longer, but=

> gives overall slightly better results for deduplication).

IIRC, the core of the duperemove duplicate matcher isn't an O(n^2)
algorithm.  I think Mark used a bloom filter to reduce the data set
prior to matching, but I haven't looked at the code in a while.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--oFaqa9iI7bFXEps6QD6DQ0J1Qkf7cwAxR--

--mMlbDQlnFW5eL8Tk7dfolWxaQMRNBUN1n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYSb2aAAoJEB57S2MheeWySbgP/iUOE2EsNcFtbR8fL8RHNfqh
rBVA/czDRqhs4Qtk+jSmag1anDmExtxymtPtY9NlUuHi21/xrNFgVnx4tXms70gc
GO7UppnlxGe2mXukw2olVgMCNVWUOSaFLLe2bbKRLS/I44+aVexv21FJ63fedZbj
bkfKm6W3xLwo/CmezKthDluicboNaiOXt+5UXkOrdU72rhCvzCeIbxQBUpnDWGcZ
PyaBrRJUK+VexZMJmZpGg4bKQCO8oZkOKeTlwhjKTu072xbeaKtLIKiDba8eyNJE
rS+0BE0QBvPTtt/l3y0ck9L+1uBxyTuy2hsMlPLGdcg10fmw16A4cqCg0NlpzVof
cohNA6CQw29yjGLXBsyUttgksU9n93qiD28v8KHXfk5zuayTm8YaLla2TkI78IZW
XSMRI7mkbxrs9nZ4Os0Phf05HMK3TaOvrDA0A94fs3oIZxEiwuwctXBfIAynEl5O
hkGVwCPq50d5lht3/h4cMSo1gLWCll5EH10ALcD2lDHeVIwYVB90AjlvQMYy4bAq
uI/ZhzKKbgaFCYesz3uKflMeiYRnRvcGNv/spV7D58le/Rh/hG10HRaucey4/iaH
cBJCGK5xAW33/vkG4vowlr1nVJNGF0Kzf9MlQLQT5W0j5l1T7ZmgP2kUzX5feY7q
EAclYv1CzjcvpSGGu50t
=0q8x
-----END PGP SIGNATURE-----

--mMlbDQlnFW5eL8Tk7dfolWxaQMRNBUN1n--
