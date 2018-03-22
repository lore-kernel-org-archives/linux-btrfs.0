Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:40121 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753883AbeCVAMr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 20:12:47 -0400
Subject: Re: [PATCH v3 0/6] Fix long standing -EOPNOTSUPP problem caused by
 large inline extent
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180320064229.31493-1-wqu@suse.com>
 <20180321155115.GT6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <74866cc8-788b-233c-e52f-9ac413e5e6af@gmx.com>
Date: Thu, 22 Mar 2018 08:12:31 +0800
MIME-Version: 1.0
In-Reply-To: <20180321155115.GT6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WjyYktvM43enuCe84RH5BUDZS43flkFvn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WjyYktvM43enuCe84RH5BUDZS43flkFvn
Content-Type: multipart/mixed; boundary="t4P3nlp2Bs3VVonYHPQTJY5UnG1DOAHmu";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <74866cc8-788b-233c-e52f-9ac413e5e6af@gmx.com>
Subject: Re: [PATCH v3 0/6] Fix long standing -EOPNOTSUPP problem caused by
 large inline extent
References: <20180320064229.31493-1-wqu@suse.com>
 <20180321155115.GT6955@twin.jikos.cz>
In-Reply-To: <20180321155115.GT6955@twin.jikos.cz>

--t4P3nlp2Bs3VVonYHPQTJY5UnG1DOAHmu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8821=E6=97=A5 23:51, David Sterba wrote:
> On Tue, Mar 20, 2018 at 02:42:23PM +0800, Qu Wenruo wrote:
>> The patch is based on v4.15.1, and is designed to replace the old patc=
h
>> in devel branch.
>>
>> Kernel doesn't support dropping range inside inline extent, and preven=
ts
>> such thing happening by limiting max inline extent size to
>> min(max_inline, sectorsize - 1) in cow_file_range_inline().
>>
>> However btrfs-progs only inherit the BTRFS_MAX_INLINE_DATA_SIZE() macr=
o,
>> which doesn't have sectorsize check.
>> And since btrfs-progs defaults to 16K nodesize, above macro allows lar=
ge
>> inline extent over 15K size.
>>
>> This leads to unexpected kernel behavior.
>>
>> The bug exists in several parts of btrfs-progs, any tool which creates=

>> file extent is involved, including:
>> 1) btrfs-convert
>> 2) mkfs --rootdir
>>
>> This patchset fixes the problems in convert (both ext2 and reiserfs),
>> mkfs --rootdir, then add check support for both original and lowmem
>> mode, and finally adds 2 test cases, one for mkfs and one for convert.=

>>
>> For mkfs test case, it can already be exposed by misc/002, but a
>> pin-point test case will be much better.
>>
>> changelog:
>> v2:
>>   Don't modify BTRFS_MAX_INLINE_DATA_SIZE(), but add extra check to
>>   callers who create file extents.
>> v3:
>>   Merge fixes for convert.
>>   Add real commit message for convert fixes.
>>   Use $TEST_TOP to replace cooperate with stand alone test cases.
>>   Use for loops to make the new test case shorter.
>>
>> Qu Wenruo (6):
>>   btrfs-progs: convert: Fix inline file extent creation condition
>>   btrfs-progs: mkfs/rootdir: Fix inline extent creation check
>>   btrfs-progs: check/original mode: Check inline extent size
>>   btrfs-progs: check/lowmem mode: Check inline extent size
>>   btrfs-progs: test/convert: Add test case for invalid large inline da=
ta
>>     extent
>>   btrfs-progs: test/mkfs: Add test case for rootdir inline extent size=

>=20
> Applied, thanks. I had to fix the test, fallocate may fail, so a file o=
f
> given size is created directly.

The fix looks good, and I learn a new trick.

But I'm wondering how could it fail.

Nowadays /tmp should be tmpfs created by systemd, which supports fallocat=
e.
Or is the CI things doesn't follow this?

Thanks,
Qu

>=20
> I hope this bug is fixed. My plan was to release 4.15.2 with just
> bugfixes but as this took some time to fix, there likely will be no
> minor release before 4.16 as kernel is about to be released next week.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--t4P3nlp2Bs3VVonYHPQTJY5UnG1DOAHmu--

--WjyYktvM43enuCe84RH5BUDZS43flkFvn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqy9O8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjuWwgAl6znwCbN0adI2KWjX2kLyM51
JqQs4Yjalyt9nDlgFkpI3ir+jgG3G1m17HWsvw7BaVLSQjQqXveiSk5cOiIhFMF+
hJDoe2GTf/304k7pWqffI/hwuaLl4KM55Nma66yF4ct9EecQAyAZn8rkn7tZQbn1
dRSeS4NWbz718Sr/pHnR8SaKNq1WG2Oac7SlcAOvN3C7yVYhcono0Ophi69EKmKb
ZAMhfSQ97tPB3llcO2OKGOroPipuipKiFEVHFHlLCaM/2IhHW95PK++21HfXjnWq
qcn8lAs25WMn0rDwuRf682Mr0Ao0wl+0ZDzKJPaPG62BnJY12CkZ53xP/AV1bQ==
=NiKC
-----END PGP SIGNATURE-----

--WjyYktvM43enuCe84RH5BUDZS43flkFvn--
