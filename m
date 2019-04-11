Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5E1C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 01:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CB3020850
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 01:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CtQ3hLLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfDKBnW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 21:43:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:59655 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbfDKBnW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 21:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554946992;
        bh=feNUs1dYoqhJDIrazmuWUZSYTKEl3gHu3nPdBsbIU3M=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CtQ3hLLksBLQ7W/tevM+5Ts1Tqd1wr0N9pq+Fjm+WquvQBSLOpwqPnxa8vGhIj8du
         eS4P8OidFMSAyFrcFyp3rZyfgLMP5Y9CVpwGh2fUr3dt4p8oo5X3lBZAy3vYCQELG+
         oSfPadj9RtqAyMf/tY5gWfkjSGfKuZCPYCilBIE8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MS0c2-1hKXYL1BDW-00THWI; Thu, 11
 Apr 2019 03:43:12 +0200
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Qu Wenruo <wqu@suse.de>
Cc:     linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190410083508.21091-1-wqu@suse.com>
 <20190410151134.GG1177@magnolia>
 <eae01c59-2280-69da-1d78-5550e3c47371@suse.de>
 <20190411010628.GT15524@magnolia>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <89fc7ffb-412f-4e9f-efa2-a624f3ec6a14@gmx.com>
Date:   Thu, 11 Apr 2019 09:43:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190411010628.GT15524@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5OXAl4UiW8NTAvAt0LukI4dh0wOVnlXTo"
X-Provags-ID: V03:K1:rkWJO9lTvJVx7GmdN7pWrFfNgQJS5Te6BY8yXlG89WEfYipF0dZ
 BF7alOud9zoMVKHAKjVbn7PvtvEqIQwQypru7fYSMF/vEjBGJ/swz/E9u7g3DZe6y7l5uZx
 MOd01a4QMlC+F1LnCuggPkjxxwgY00p7djrcUFpko2LCiMkXFxAo6Tr8QVP6m3R+1XJM1o3
 EJ+CapjJw5b2qwN8PVjkw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:N/vOul5qkcA=:20fwPr5ZadyHrbiXHZlpMi
 liP6pmdotQMQg6OorPfNhvOD3W7zUnYeVwPAwjQ/Lh4+TD1lBH/SmnSeeUlSiFIBi6hAF3TSS
 FPTJCKTzVRo6CuP/3D4aPap2NQFMsYFrWOI36ZYTa2vVsc3D53oVGY7wqVNfdk6UfRK3ktYlK
 tUGriaXmWgucyMNZwZi4GPz1yETj3thWx3ivbD6rgwq8KHxHMJEQugEdR8G78smxKd4t1sZfm
 /xFUQEzgXLEonmmplUm2HYqBbQJfAGHody+F1BBzXHwg9P8zfUzKBIFw5ehSjPTjiXw63YzxG
 /ejsltYccBFPK0Jn6ONDGD6qxz4yWSb5FbgB1zP/cj4lYxZzFK6K81dBSrzxg9AWnG+5+hlJm
 ydv89/BDJILQnagoCtzd6Gr2m/AcnlaH6GH/npVXUKnHJE9kMy5WYz7mu9xW4iCXKU5K0fSDk
 VYDE326VFQEiDHGuLanwVkWq9wiZGUudtz8V35fsHsWs9VzCfyUYIDgnsy6PMgdiO1qQ5PNYY
 +ht6gzqUqDEXMRRc5UR2mSackl/ZG5pK6RmNc3GeLZaJPlGiYurflZO506qL2OMqE9QYVRGuk
 yjZCh7fx16+6qvb7Say0S3PKl8Itu6/0CddAoeZZXBDAtnaLzLD2L/hQJsGuh/zpDu6F7GP0E
 4xQqmGFAHyarw4E45r2h9GcPJXhGauZWNq3jZzpA/XmBq6ILNEej83JnaKmKanSHynx2U8dmb
 ruN30yidfJuCaSUPTe/TOSuLfkht0NrhxXSofY+pr8+i4ozZKd87HHlKdw0S7XKmt2oC2SCTi
 qsKmf6LYS034TXVQRo+pXtoIEWb3P0HbbVx1ZGOXQvTOVd9jHAnsFrLnjo82So7fPHTtwLz7s
 YHOEiVuA/BsXgXEc0BhCLyARHP3H3Fn19TB/+yq23IBDHvPZXAqL0fLUrYPAUT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5OXAl4UiW8NTAvAt0LukI4dh0wOVnlXTo
Content-Type: multipart/mixed; boundary="KZckM7PU0TeckYq8fvea5VlxRkG6vOfI3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Qu Wenruo <wqu@suse.de>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Message-ID: <89fc7ffb-412f-4e9f-efa2-a624f3ec6a14@gmx.com>
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
References: <20190410083508.21091-1-wqu@suse.com>
 <20190410151134.GG1177@magnolia>
 <eae01c59-2280-69da-1d78-5550e3c47371@suse.de>
 <20190411010628.GT15524@magnolia>
In-Reply-To: <20190411010628.GT15524@magnolia>

--KZckM7PU0TeckYq8fvea5VlxRkG6vOfI3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/11 =E4=B8=8A=E5=8D=889:06, Darrick J. Wong wrote:
> On Thu, Apr 11, 2019 at 08:28:44AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/10 =E4=B8=8B=E5=8D=8811:11,  Darrick J. Wong  wrote:
>>> On Wed, Apr 10, 2019 at 04:35:07PM +0800, Qu Wenruo wrote:
>>>> Xfs and Ext* uses EFSCORRUPTED to indicate filesystem corruption.
>>>> They both map EFSCORRUPTED to EUCLEAN.
>>>>
>>>> Btrfs/Ubifs/fscrypto all use EUCLEAN directly to indicate filesystem=

>>>> corruption.
>>>
>>> I don't know if you (btrfs folks specifically) care but ext* and xfs
>>> also use EFSBADCRC to signal unrecovered checksum validation failures=
=2E
>>> Can we promote both of them to asm-generic/errno.h at the same time?
>>
>> It looks pretty good to me in fact.
>>
>> I'm really tired of using -EIO for csum mismatch/any other higher leve=
l
>> mismatch.
>>
>> The only concern is the "CRC" part. Yes, btrfs uses and only supports
>> CRC32 so far, but I'm sure btrfs will support cryptographic hash.
>>
>> So what about renaming it to EFSBADCSUM?
>=20
> We've been shipping EFSBADCRC in xfslibs-dev userspace libraries for
> years now, so we can't change the symbol name.

Fair enough.

Any extra error number worthy export?

Thanks,
Qu

>=20
> --D
>=20
>> Thanks,
>> Qu
>>
>>>
>>> #define EFSBADCRC   EBADMSG
>>>
>>> --D
>>>
>>>> And block layer is going to distinguish filesystem corruption with
>>>> oridinary EIO error, it's a good idea to export the initial EFSCORRU=
PTED
>>>> declaration to <linux/errno.h> so all filesystems and block layer ca=
n
>>>> take advantage of this easier-to-read error number.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>>  fs/ext2/ext2.h                   | 1 -
>>>>  fs/ext4/ext4.h                   | 1 -
>>>>  fs/xfs/xfs_linux.h               | 1 -
>>>>  include/uapi/asm-generic/errno.h | 3 +++
>>>>  4 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
>>>> index 10ab238de9a6..03d0ca8fae42 100644
>>>> --- a/fs/ext2/ext2.h
>>>> +++ b/fs/ext2/ext2.h
>>>> @@ -369,7 +369,6 @@ struct ext2_inode {
>>>>   */
>>>>  #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
>>>>  #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
>>>> -#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
>>>> =20
>>>>  /*
>>>>   * Mount flags
>>>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>>>> index 82ffdacdc7fa..f906b5cbf96d 100644
>>>> --- a/fs/ext4/ext4.h
>>>> +++ b/fs/ext4/ext4.h
>>>> @@ -3248,6 +3248,5 @@ extern const struct iomap_ops ext4_iomap_ops;
>>>>  #endif	/* __KERNEL__ */
>>>> =20
>>>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>>>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>>>> =20
>>>>  #endif	/* _EXT4_H */
>>>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
>>>> index edbd5a210df2..36e5c6549f15 100644
>>>> --- a/fs/xfs/xfs_linux.h
>>>> +++ b/fs/xfs/xfs_linux.h
>>>> @@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
>>>> =20
>>>>  #define ENOATTR		ENODATA		/* Attribute not found */
>>>>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>>>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>>>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>>>> =20
>>>>  #define SYNCHRONIZE()	barrier()
>>>> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-gen=
eric/errno.h
>>>> index cf9c51ac49f9..ebd6e7e76a98 100644
>>>> --- a/include/uapi/asm-generic/errno.h
>>>> +++ b/include/uapi/asm-generic/errno.h
>>>> @@ -98,6 +98,9 @@
>>>>  #define	EINPROGRESS	115	/* Operation now in progress */
>>>>  #define	ESTALE		116	/* Stale file handle */
>>>>  #define	EUCLEAN		117	/* Structure needs cleaning */
>>>> +
>>>> +#define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
>>>> +
>>>>  #define	ENOTNAM		118	/* Not a XENIX named type file */
>>>>  #define	ENAVAIL		119	/* No XENIX semaphores available */
>>>>  #define	EISNAM		120	/* Is a named type file */
>>>> --=20
>>>> 2.21.0
>>>>
>>>
>>
>=20
>=20
>=20


--KZckM7PU0TeckYq8fvea5VlxRkG6vOfI3--

--5OXAl4UiW8NTAvAt0LukI4dh0wOVnlXTo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyum6oACgkQwj2R86El
/qgSlgf/bi0qz8behNLHFebW8swiKeNB1N126vhg4TdVhmRcbAjq2At353eFX7b4
dLJh7eFdPLMOYGRFmk3ZD4v+h6c/Oy3/6YDDPrc2YpX0E5BRo6Kle5cELHxL/Ai7
YOiX5dYaKIq8u7S4TvZ17fkRftMXXdDOHGv5zgCpIJdkJtqT7IEk7ecCgOCtxcE/
1YgvNf1HchBnNyz9weWz16gmkpWeRcwITVRqJ6SCidhPvqK6ywbMfqt8xLcG4D5T
UwJP0M0mQRTt9FStWLm1KxWATNKwLZJ/3VfDCo7HMMK8swWZJ9lx156/2n8iZflB
EYoSc5jL48zPAPO+MDXw7fx8l10HpQ==
=OQEp
-----END PGP SIGNATURE-----

--5OXAl4UiW8NTAvAt0LukI4dh0wOVnlXTo--
