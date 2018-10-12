Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E991C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA97620868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA97620868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbeJLV1Q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:27:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:55916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728354AbeJLV1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 17:27:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28E6AAD0C;
        Fri, 12 Oct 2018 13:54:41 +0000 (UTC)
Subject: Re: [PATCH v3 4/4] btrfs: Refactor find_free_extent() loops update
 into find_free_extent_update_loop()
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-5-wqu@suse.com>
 <20181012135200.ddo7dhhrwng26lnh@destiny>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <46a7ed9c-18a6-48b2-67fe-eb738434f654@suse.de>
Date:   Fri, 12 Oct 2018 21:54:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181012135200.ddo7dhhrwng26lnh@destiny>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GPDzjmJlMMSpDF3XTnvXfk300fUu0JT0H"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GPDzjmJlMMSpDF3XTnvXfk300fUu0JT0H
Content-Type: multipart/mixed; boundary="6t8uw6SoUy82EfBd9W3KMKmOVcsunK2mh";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <46a7ed9c-18a6-48b2-67fe-eb738434f654@suse.de>
Subject: Re: [PATCH v3 4/4] btrfs: Refactor find_free_extent() loops update
 into find_free_extent_update_loop()
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-5-wqu@suse.com>
 <20181012135200.ddo7dhhrwng26lnh@destiny>
In-Reply-To: <20181012135200.ddo7dhhrwng26lnh@destiny>

--6t8uw6SoUy82EfBd9W3KMKmOVcsunK2mh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/12 =E4=B8=8B=E5=8D=889:52, Josef Bacik wrote:
> On Fri, Oct 12, 2018 at 02:18:19PM +0800, Qu Wenruo wrote:
>> We have a complex loop design for find_free_extent(), that has differe=
nt
>> behavior for each loop, some even includes new chunk allocation.
>>
>> Instead of putting such a long code into find_free_extent() and makes =
it
>> harder to read, just extract them into find_free_extent_update_loop().=

>>
>> With all the cleanups, the main find_free_extent() should be pretty
>> barebone:
>>
>> find_free_extent()
>> |- Iterate through all block groups
>> |  |- Get a valid block group
>> |  |- Try to do clustered allocation in that block group
>> |  |- Try to do unclustered allocation in that block group
>> |  |- Check if the result is valid
>> |  |  |- If valid, then exit
>> |  |- Jump to next block group
>> |
>> |- Push harder to find free extents
>>    |- If not found, re-iterate all block groups
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/extent-tree.c | 217 ++++++++++++++++++++++------------------=
-
>>  1 file changed, 117 insertions(+), 100 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e6bfa91af41c..938569d2c583 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -7236,7 +7236,9 @@ struct find_free_extent_ctl {
>>  	/* RAID index, converted from flags */
>>  	int index;
>> =20
>> -	/* Current loop number */
>> +	/*
>> +	 * Current loop number, check find_free_extent_update_loop() for det=
ails
>> +	 */
>>  	int loop;
>> =20
>>  	/*
>> @@ -7433,6 +7435,117 @@ static int find_free_extent_unclustered(struct=
 btrfs_block_group_cache *bg,
>>  	return 0;
>>  }
>> =20
>> +/*
>> + * Return >0 means caller needs to re-search for free extent
>> + * Return 0 means we have the needed free extent.
>> + * Return <0 means we failed to locate any free extent.
>> + */
>> +static int find_free_extent_update_loop(struct btrfs_fs_info *fs_info=
,
>> +					struct btrfs_free_cluster *last_ptr,
>> +					struct btrfs_key *ins,
>> +					struct find_free_extent_ctl *ffe_ctl,
>> +					int full_search, bool use_cluster)
>> +{
>> +	struct btrfs_root *root =3D fs_info->extent_root;
>> +	int ret;
>> +
>> +	if ((ffe_ctl->loop =3D=3D LOOP_CACHING_NOWAIT) &&
>> +	    ffe_ctl->have_caching_bg && !ffe_ctl->orig_have_caching_bg)
>> +		ffe_ctl->orig_have_caching_bg =3D true;
>> +
>> +	if (!ins->objectid && ffe_ctl->loop >=3D LOOP_CACHING_WAIT &&
>> +	     ffe_ctl->have_caching_bg)
>> +		return 1;
>> +
>> +	if (!ins->objectid && ++(ffe_ctl->index) < BTRFS_NR_RAID_TYPES)
>> +		return 1;
>> +
>> +	/*
>> +	 * LOOP_CACHING_NOWAIT, search partially cached block groups, kickin=
g
>> +	 *			caching kthreads as we move along
>> +	 * LOOP_CACHING_WAIT, search everything, and wait if our bg is cachi=
ng
>> +	 * LOOP_ALLOC_CHUNK, force a chunk allocation and try again
>> +	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try=

>> +	 *			again
>> +	 */
>> +	if (!ins->objectid && ffe_ctl->loop < LOOP_NO_EMPTY_SIZE) {
>> +		ffe_ctl->index =3D 0;
>> +		if (ffe_ctl->loop =3D=3D LOOP_CACHING_NOWAIT) {
>> +			/*
>> +			 * We want to skip the LOOP_CACHING_WAIT step if we
>> +			 * don't have any uncached bgs and we've already done a
>> +			 * full search through.
>> +			 */
>> +			if (ffe_ctl->orig_have_caching_bg || !full_search)
>> +				ffe_ctl->loop =3D LOOP_CACHING_WAIT;
>> +			else
>> +				ffe_ctl->loop =3D LOOP_ALLOC_CHUNK;
>> +		} else {
>> +			ffe_ctl->loop++;
>> +		}
>> +
>> +		if (ffe_ctl->loop =3D=3D LOOP_ALLOC_CHUNK) {
>> +			struct btrfs_trans_handle *trans;
>> +			int exist =3D 0;
>> +
>> +			trans =3D current->journal_info;
>> +			if (trans)
>> +				exist =3D 1;
>> +			else
>> +				trans =3D btrfs_join_transaction(root);
>> +
>> +			if (IS_ERR(trans)) {
>> +				ret =3D PTR_ERR(trans);
>> +				return ret;
>> +			}
>> +
>> +			ret =3D do_chunk_alloc(trans, ffe_ctl->flags,
>> +					     CHUNK_ALLOC_FORCE);
>> +
>> +			/*
>> +			 * If we can't allocate a new chunk we've already looped
>> +			 * through at least once, move on to the NO_EMPTY_SIZE
>> +			 * case.
>> +			 */
>> +			if (ret =3D=3D -ENOSPC)
>> +				ffe_ctl->loop =3D LOOP_NO_EMPTY_SIZE;
>> +
>> +			/* Do not bail out on ENOSPC since we can do more. */
>> +			if (ret < 0 && ret !=3D -ENOSPC)
>> +				btrfs_abort_transaction(trans, ret);
>> +			else
>> +				ret =3D 0;
>> +			if (!exist)
>> +				btrfs_end_transaction(trans);
>> +			if (ret)
>> +				return ret;
>> +		}
>> +
>> +		if (ffe_ctl->loop =3D=3D LOOP_NO_EMPTY_SIZE) {
>> +			/*
>> +			 * Don't loop again if we already have no empty_size and
>> +			 * no empty_cluster.
>> +			 */
>> +			if (ffe_ctl->empty_size =3D=3D 0 &&
>> +			    ffe_ctl->empty_cluster =3D=3D 0)
>> +				return -ENOSPC;
>> +			ffe_ctl->empty_size =3D 0;
>> +			ffe_ctl->empty_cluster =3D 0;
>> +		}
>> +		return 1;
>> +	} else if (!ins->objectid) {
>> +		ret =3D -ENOSPC;
>> +	} else if (ins->objectid) {
>> +		if (!use_cluster && last_ptr) {
>> +			spin_lock(&last_ptr->lock);
>> +			last_ptr->window_start =3D ins->objectid;
>> +			spin_unlock(&last_ptr->lock);
>> +		}
>> +		ret =3D 0;
>> +	}
>> +	return ret;
>> +}
>=20
> Rework this so the
>=20
> if (ins->objectid)
> 	blah
>=20
> is the first thing, that way you don't have to do the
>=20
> if (!ins->objectid && <other things>)
>=20
> for all the other if statements here.  The fast path should be the firs=
t thing,
> then we can deal with all of the other crap last.  Thanks,

Indeed, the ENOSPC should be in the last else branch.

Thanks,
Qu

>=20
> Josef
>=20


--6t8uw6SoUy82EfBd9W3KMKmOVcsunK2mh--

--GPDzjmJlMMSpDF3XTnvXfk300fUu0JT0H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvAp5oACgkQwj2R86El
/qgP8AgAim9r9TRaJAP9jhO0oUqzEHUeEdpdYYwgUaRsF0nkGjO1EfMiNZaHA/+8
LLudYOWUxmZDz2ZtWKJkY5qlV3pQtuQPT6GcDREYjZz25TVCsbg/YrcGsXI5rOKL
mjvGZxWZBl8SbfQph2CLOoPWnSBfLRSskwfSHjrRx8g4j/W72CAuHgPNpbqiP+6m
YmUEfa6odiqazQP6VKxJbFncStQK8KShMVaDU0WrMajUpZsaGLkFrXX9yf/UOOOO
xLDT6WuiHSCwIFPth8N/5iswXG2PoZsBc19p704GeJALxBrI0clsB0meLhffgxXQ
H6jOksCVBgawvlrMWnxABnPxfNxLOw==
=ZMOI
-----END PGP SIGNATURE-----

--GPDzjmJlMMSpDF3XTnvXfk300fUu0JT0H--
