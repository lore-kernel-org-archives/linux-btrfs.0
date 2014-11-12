Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37881 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaKLI6d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:58:33 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] mm: check memory reclaim bugs caused fs reentrance
In-Reply-To: <20141111215207.GW23575@dastard>
References: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org> <20141111215207.GW23575@dastard>
Date: Wed, 12 Nov 2014 11:58:19 +0300
Message-ID: <87fvdox0b8.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Nov 11, 2014 at 03:49:50PM +0400, Dmitry Monakhov wrote:
>> If filesystem holds transaction open 'current->journal_info' it should n=
ot
>> performs memory allocations with __GFP_FS flag enabled otherwise this re=
sult in fs
>> reentarance which lead to:
>> 1) reentrance to itself : deadlock or internal assertion failure due to =
incorrect journal credits
>> 1) entrance to another fs: assertion faulure or silient corruption due t=
o incorrect journal
>>=20
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  include/linux/kernel.h |    7 +++++++
>>  mm/dmapool.c           |    1 +
>>  mm/mempool.c           |    1 +
>>  mm/page_alloc.c        |    1 +
>>  mm/slab.c              |    1 +
>>  mm/slub.c              |    1 +
>>  6 files changed, 12 insertions(+), 0 deletions(-)
>>=20
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index 3d770f5..69923d4 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -232,6 +232,13 @@ void might_fault(void);
>>  static inline void might_fault(void) { }
>>  #endif
>>=20=20
>> +#ifdef CONFIG_PROVE_LOCKING
>> +#define might_enter_fs_if(cond) \
>> +	 WARN_ON_ONCE((cond) && current->journal_info)
>
> XFS does not use current->journal_info, and so this won't ever
> trigger on XFS. XFS uses PF_FSTRANS to indicate a transaction is in
> progress.
Yes, I've simply forget about that.
>
> Besides, isn't this redundant functionality? Lockdep already catches
> these problems with it's reclaim context tracking and it's tracking
> is more extensive than this simple check like this.  lockdep
> regularly pointed out allocation/reclaim context problems in XFS
> until we fixed them....
This is correct, but only partly, at this moment lockdep are not very good =
at
catching fs re-entrance. It has FS_RECLAIM machinery but it is not idial.
So I'll rewrite my patch and add explicit fs re-entrance rule to lockdep
>
> Cheers,
>
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUYyErAAoJELhyPTmIL6kBslQIAIJcZsV58631cBm/zt+gleoY
nh4nGNnJKvFtcXt4aUDeI10eiBKU1hXuIMzjrn9PxJNxpnvsoS//SCNe8sLbGJog
/MLtbk7fCEq6sDdLkqkInxvRHH0w7PY4WXQ4oG1wGcQ/8i9FiWMY17rCdwYob3aT
LXAHmyya0oOHY0U85VeoIUZxU8wCL3/NoVwWeMkT911Ci/zrV9tbxfTwo9t/XyAG
Ev7Oyxl5ij1yxWtqEb39yH2qsxH7sEyeF8UrWBvRGeBQvoF0IyMdRt2bPoprvhDm
gmFVNayVbMgxXhPRJuIMCsLJqfdV0sp+8pyVXKBnpJQUabKjq9TgB2G2fapbLW8=
=24BN
-----END PGP SIGNATURE-----
--=-=-=--
