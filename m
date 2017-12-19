Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56626 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936130AbdLSLVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 06:21:14 -0500
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171219104511.3563-1-wqu@suse.com>
 <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
Date: Tue, 19 Dec 2017 19:20:59 +0800
MIME-Version: 1.0
In-Reply-To: <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sndneNvGs9DMdGRqSB4QwKR2leK3HtUMd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sndneNvGs9DMdGRqSB4QwKR2leK3HtUMd
Content-Type: multipart/mixed; boundary="C1jje2uo5sXBEuEUi9XP7w1L6QcWfM70s";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
References: <20171219104511.3563-1-wqu@suse.com>
 <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
In-Reply-To: <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>

--C1jje2uo5sXBEuEUi9XP7w1L6QcWfM70s
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B412=E6=9C=8819=E6=97=A5 19:12, Nikolay Borisov wrote:
>=20
>=20
> On 19.12.2017 12:45, Qu Wenruo wrote:
>> btrfs_qgroup_inherit structure has two members, num_ref_copies and
>> num_excl_copies, to info btrfs kernel modules to inherit (copy)
>> rfer/excl numbers at snapshot/subvolume creation time.
>>
>> Since qgroup number is already hard to maintain for multi-level qgroup=

>> scenario, allowing user to manually manipulate qgroup inherit is quite=

>> easy to screw up qgroup numbers.
>>
>> Although btrfs-progs supports such inheritance specification, the
>> options are hidden from user and not documented.
>> So there is no need to allow user to manually specify inheritance in
>> kernel.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> The only concern is, currently we don't have good tool to handle
>> inheritance of multi-level qgroups.
>> The only method to get qgroup numbers correct is to run a quota rescan=
=2E
>>
>> So there may be some case where experienced (well, mostly a developer)=

>> user can use the hidden btrfs-progs options or manually craft an ioctl=

>> to handle multi-level qgroups without costly rescan.
>> ---
>>  fs/btrfs/qgroup.c          | 56 ++++++++++++++-----------------------=
---------
>>  include/uapi/linux/btrfs.h |  4 ++--
>>  2 files changed, 19 insertions(+), 41 deletions(-)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 168fd03ca3ac..d8a2413272f9 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2158,9 +2158,24 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans,
>>  	}
>> =20
>>  	if (inherit) {
>> +		/*
>> +		 * num_excl/rfer_copies indicate how many qgroup pairs needs
>> +		 * to be manually inherited (copy rfer or excl from src
>> +		 * qgroup to dst)
>> +		 *
>> +		 * Allowing user to manipulate inheritance can easily cause
>> +		 * problem in multi-level qgroup scenario.
>> +		 * And the ioctl interface is hidden in btrfs-progs for a long
>> +		 * time, deprecate them should not be a big problem.
>> +		 */
>> +		if (inherit->__num_excl_copies || inherit->__num_ref_copies) {
>> +			ret =3D -ENOTTY;
>> +			btrfs_warn(fs_info,
>> +			"manually inherit excl/rfer is no longer supported");
>> +			goto out;
>> +		}
>>  		i_qgroups =3D (u64 *)(inherit + 1);
>> -		nums =3D inherit->num_qgroups + 2 * inherit->num_ref_copies +
>> -		       2 * inherit->num_excl_copies;
>> +		nums =3D inherit->num_qgroups;
>>  		for (i =3D 0; i < nums; ++i) {
>>  			srcgroup =3D find_qgroup_rb(fs_info, *i_qgroups);
>> =20
>> @@ -2286,43 +2301,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_han=
dle *trans,
>>  		++i_qgroups;
>>  	}
>> =20
>> -	for (i =3D 0; i <  inherit->num_ref_copies; ++i, i_qgroups +=3D 2) {=

>> -		struct btrfs_qgroup *src;
>> -		struct btrfs_qgroup *dst;
>> -
>> -		if (!i_qgroups[0] || !i_qgroups[1])
>> -			continue;
>> -
>> -		src =3D find_qgroup_rb(fs_info, i_qgroups[0]);
>> -		dst =3D find_qgroup_rb(fs_info, i_qgroups[1]);
>> -
>> -		if (!src || !dst) {
>> -			ret =3D -EINVAL;
>> -			goto unlock;
>> -		}
>> -
>> -		dst->rfer =3D src->rfer - level_size;
>> -		dst->rfer_cmpr =3D src->rfer_cmpr - level_size;
>> -	}
>> -	for (i =3D 0; i <  inherit->num_excl_copies; ++i, i_qgroups +=3D 2) =
{
>> -		struct btrfs_qgroup *src;
>> -		struct btrfs_qgroup *dst;
>> -
>> -		if (!i_qgroups[0] || !i_qgroups[1])
>> -			continue;
>> -
>> -		src =3D find_qgroup_rb(fs_info, i_qgroups[0]);
>> -		dst =3D find_qgroup_rb(fs_info, i_qgroups[1]);
>> -
>> -		if (!src || !dst) {
>> -			ret =3D -EINVAL;
>> -			goto unlock;
>> -		}
>> -
>> -		dst->excl =3D src->excl + level_size;
>> -		dst->excl_cmpr =3D src->excl_cmpr + level_size;
>> -	}
>> -
>>  unlock:
>>  	spin_unlock(&fs_info->qgroup_lock);
>>  out:
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index ce615b75e855..099e088414d6 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -80,8 +80,8 @@ struct btrfs_qgroup_limit {
>>  struct btrfs_qgroup_inherit {
>>  	__u64	flags;
>>  	__u64	num_qgroups;
>> -	__u64	num_ref_copies;
>> -	__u64	num_excl_copies;
>> +	__u64	__num_ref_copies;	/* DEPRECATED */
>> +	__u64	__num_excl_copies;	/* DEPRECATED */
>=20
> I'd prefer we name them something even more generic i.e. :
> pad1, pad2 or unused1, unused2 to really deter any efforts to use them.=

> I guess this could shouldn't have been merged in the first place ...

Naming like pad1/2 will make the check in btrfs_qgroup_inherit() look
quite weird.

Although I don't have any better idea, so I'm mostly fine with such renam=
e.

Thanks,
Qu

>=20
>>  	struct btrfs_qgroup_limit lim;
>>  	__u64	qgroups[0];
>>  };
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--C1jje2uo5sXBEuEUi9XP7w1L6QcWfM70s--

--sndneNvGs9DMdGRqSB4QwKR2leK3HtUMd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlo49hsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhDDgf7BNBz2B7rKPKq/K+4cliOQS77
z03VIZCCsqvMe/UW2/VINIrPGmhMzLQ1+7nKpeyHckYogrXw9+/xCD3OpFGIhX2V
iC98k0FArN1SWmlhd6zXxix25yzeBnm8LvN7uhL9EuBqWk5/XX9jJXgICYedtZb0
CD1187Z1OlQwqQiwN1AOHJ7OL0ijP6gm3a3J2SgrdSLQ+7nz4vz66JSsqvbyY1xj
5hhgPIwS6zcFOLzEHMeEQWdtSP/S/kxZubkGRfdG1Jv5G72M3S3zbi4oow/XA+sU
PqsGxtYVmKuWMCP4MR2S70Nh9A6vbqcpMSRCdMvQ6EyfUJkuUJXfXHffLpRYFg==
=5BnV
-----END PGP SIGNATURE-----

--sndneNvGs9DMdGRqSB4QwKR2leK3HtUMd--
