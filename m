Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BB6C10F11
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 00:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460FF20818
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 00:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfDKA2v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 20:28:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:53208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbfDKA2v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 20:28:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D56DABCE;
        Thu, 11 Apr 2019 00:28:49 +0000 (UTC)
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190410083508.21091-1-wqu@suse.com>
 <20190410151134.GG1177@magnolia>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <eae01c59-2280-69da-1d78-5550e3c47371@suse.de>
Date:   Thu, 11 Apr 2019 08:28:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190410151134.GG1177@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Iij6IPpVMa1LXNeMXcl1awBmNWaR4hcxs"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Iij6IPpVMa1LXNeMXcl1awBmNWaR4hcxs
Content-Type: multipart/mixed; boundary="KqyVJgBzXLW4om0Lx1M74YQ4frD9gdzam";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Message-ID: <eae01c59-2280-69da-1d78-5550e3c47371@suse.de>
Subject: Re: [PATCH RFC 1/2] errno.h: Export EFSCORRUPTED error number
References: <20190410083508.21091-1-wqu@suse.com>
 <20190410151134.GG1177@magnolia>
In-Reply-To: <20190410151134.GG1177@magnolia>

--KqyVJgBzXLW4om0Lx1M74YQ4frD9gdzam
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/10 =E4=B8=8B=E5=8D=8811:11,  Darrick J. Wong  wrote:
> On Wed, Apr 10, 2019 at 04:35:07PM +0800, Qu Wenruo wrote:
>> Xfs and Ext* uses EFSCORRUPTED to indicate filesystem corruption.
>> They both map EFSCORRUPTED to EUCLEAN.
>>
>> Btrfs/Ubifs/fscrypto all use EUCLEAN directly to indicate filesystem
>> corruption.
>=20
> I don't know if you (btrfs folks specifically) care but ext* and xfs
> also use EFSBADCRC to signal unrecovered checksum validation failures.
> Can we promote both of them to asm-generic/errno.h at the same time?

It looks pretty good to me in fact.

I'm really tired of using -EIO for csum mismatch/any other higher level
mismatch.

The only concern is the "CRC" part. Yes, btrfs uses and only supports
CRC32 so far, but I'm sure btrfs will support cryptographic hash.

So what about renaming it to EFSBADCSUM?

Thanks,
Qu

>=20
> #define EFSBADCRC   EBADMSG
>=20
> --D
>=20
>> And block layer is going to distinguish filesystem corruption with
>> oridinary EIO error, it's a good idea to export the initial EFSCORRUPT=
ED
>> declaration to <linux/errno.h> so all filesystems and block layer can
>> take advantage of this easier-to-read error number.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/ext2/ext2.h                   | 1 -
>>  fs/ext4/ext4.h                   | 1 -
>>  fs/xfs/xfs_linux.h               | 1 -
>>  include/uapi/asm-generic/errno.h | 3 +++
>>  4 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
>> index 10ab238de9a6..03d0ca8fae42 100644
>> --- a/fs/ext2/ext2.h
>> +++ b/fs/ext2/ext2.h
>> @@ -369,7 +369,6 @@ struct ext2_inode {
>>   */
>>  #define	EXT2_VALID_FS			0x0001	/* Unmounted cleanly */
>>  #define	EXT2_ERROR_FS			0x0002	/* Errors detected */
>> -#define	EFSCORRUPTED			EUCLEAN	/* Filesystem is corrupted */
>> =20
>>  /*
>>   * Mount flags
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 82ffdacdc7fa..f906b5cbf96d 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3248,6 +3248,5 @@ extern const struct iomap_ops ext4_iomap_ops;
>>  #endif	/* __KERNEL__ */
>> =20
>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>> =20
>>  #endif	/* _EXT4_H */
>> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
>> index edbd5a210df2..36e5c6549f15 100644
>> --- a/fs/xfs/xfs_linux.h
>> +++ b/fs/xfs/xfs_linux.h
>> @@ -125,7 +125,6 @@ typedef __u32			xfs_nlink_t;
>> =20
>>  #define ENOATTR		ENODATA		/* Attribute not found */
>>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>> -#define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
>>  #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
>> =20
>>  #define SYNCHRONIZE()	barrier()
>> diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-gener=
ic/errno.h
>> index cf9c51ac49f9..ebd6e7e76a98 100644
>> --- a/include/uapi/asm-generic/errno.h
>> +++ b/include/uapi/asm-generic/errno.h
>> @@ -98,6 +98,9 @@
>>  #define	EINPROGRESS	115	/* Operation now in progress */
>>  #define	ESTALE		116	/* Stale file handle */
>>  #define	EUCLEAN		117	/* Structure needs cleaning */
>> +
>> +#define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
>> +
>>  #define	ENOTNAM		118	/* Not a XENIX named type file */
>>  #define	ENAVAIL		119	/* No XENIX semaphores available */
>>  #define	EISNAM		120	/* Is a named type file */
>> --=20
>> 2.21.0
>>
>=20


--KqyVJgBzXLW4om0Lx1M74YQ4frD9gdzam--

--Iij6IPpVMa1LXNeMXcl1awBmNWaR4hcxs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyuijwACgkQwj2R86El
/qiFLAgAsYKPOj1GuSgvjjr/nyWufmBJ2q8XUpcyx+9BrjAB3sDkzp0Hfc3u34X7
nprjYLBlT7++zkfzmPklim4uSEbxigas5lBy43QNw8wPgdhRfwXiJ3n20JRctOR/
0E4z2WvEdfXtfedZnTtW18x9bhU6U7vOkOrxeBNlyss7SlP97rIOfRwDW9vLxzwj
6n7wgPSttC/iZim2g7xVPSEJNQBnG024sWtkKtbnMKrr9yTmRmBn8QvMpPUTcB7l
FEzE/UaTEujh/azdQiyLNY+9t+cIYLZLS0P4Q1ijI1KvZ6q4qTFbGf6+Ut9hN4X9
x7//RLak3MFJRrorGVg9HA3yB4O0Wg==
=/KwY
-----END PGP SIGNATURE-----

--Iij6IPpVMa1LXNeMXcl1awBmNWaR4hcxs--
