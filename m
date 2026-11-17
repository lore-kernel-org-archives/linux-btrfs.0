Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948733;
	b=CwvCUKKctRJ0mU9xj+FZhrWdbWbMkrLTFuOV+ZOvcuS1Vxyrd4aT7G9dcM+RQq+J630R
	 bNDUhrlFiHkpaDA3wAsVxEwi7SeRdw/IYZ1SPp91hpsgRANY7OnbsLW8PFyb4/FENjh0B
	 abY1xVj7E8bmhYm1jbFTGFGXRW0rOAs/F6zMRJD+HlV2z/DwGhjnHvEwAwRxrEBitn3Fa
	 Gw+jZS4RWsjFhM2c+FeHZ+EWfHSfzRYez0J2zkIPj0Tebjo2gfOO7X6ws/TTMx57DIEu9
	 4lCVV5vcGXdq3Pe90hB6Zv5AzlDE3T8rc3pH/ZWf7bSogM8ERXR/MEqLUIgTrBd8Bew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948733;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=OMSdxoh4DEvIl1J3Hb9jcdWcPf4agMxrp6lywjep55s=;
	b=K+lFHmN5qDqXci1Rct2agjM/o7i0zk19cjZx6ZUVyHccKsYonLxryQ+orUtbp4wPWWBK
	 IV9ouY7Vf4p/bsGC+4HqByQZJsFm8L+ON2xdCcorqaPJ+X4/c6sy77UYoow4uYCKwhJkQ
	 bmJOamNtP/RkYTejrcJt4DuVbjkNGJLxJceSZSha6LmqoTZv7RT2f9MUgACcMo6oK+abt
	 B9Lift4pjbfxzG/sSE3ni/eXnTmWs8rCYuKSA7QEUGyKLUrTWbCixr9guj5sYuYxblNrO
	 yRwg04MTrbRcdejl1ntmQo1DMsd4/ceRraOdPWfc2jvjMsj+N69xyyJyOaPwL3JFgHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lW9n9DO3;
	arc=none smtp.remote-ip=212.227.15.15
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DD0606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 20:52:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1DD0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=lW9n9DO3
DKIM2-Signature:  i=1; m=1; t=1794948729;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:G+cWREOJJWlnaxqxDp+Jm+3GrsQm
   9ghdyTtxYl458Bech0AUITfUNjD479H/UNE3pndPA986y0j5BLPGSL+9dXUkkiWtlzldQCjQUuQ
   4Jw+QdWwLSFD6C4f5rVuhFV2Jye/13g4CT1DdV5sWVVNntmFxQBuZt0J1zJUJmJ7+uzkoxMzIms
   M0i1uRbqrWGZmS84m0PbBQKQnUd9XtaZL6dPRUqTC9S/aIaBM5AvWcpHPRyAwPW0WhqwLmceJHw
   fqQkhsJCvlZfwjHwfwaLAd0SLPcNgc9Fnl7LNmlOhamDLKXnoYiP2qO+FDVOez9I+zaJ4pAZ7SW
   G1rDo4pid3leiQ==;
Message-Instance:  m=1;
 h=sha256:
   nEe52XYn0uwjDFbpWZvLCJKzc1mvynLlHUE1yTxeLVA=:
   giT+kCzsTBLsiHBIHG02UAOTF2cLzOCwp5eUf+DRkbM=,
  sha512:
   b6OvAPyudfqFb2jWq12sQytacIry1wzZh2QraNm2QgTabEg9smTbSQEP4r/PCxkl6Z9CyHMBdnduS0rDRbpzFw==:
   ph/wzCRxE5jviIIvBKYyMviTUmnPC6Pa+fH+iroz6Q9hmAY6Q4gfmS93LDEFUyujdPZB5If/uis/8lmhK/q8Pg==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1794948729; x=1795553529; i=quwenruo.btrfs@gmx.com;
	bh=OMSdxoh4DEvIl1J3Hb9jcdWcPf4agMxrp6lywjep55s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lW9n9DO3HwiElK2NwuL8ClRM++o9VcLKnZK985TGqCVxv43eGmgONyRxaKWnoArK
	 Q/wP86fCPgDEIGh8SYSRiaLLateE5eJNHEm+aSvRANKU4pYogVrQ9NZpfT57sX2Yx
	 H1yiFqn09Bkijj+gKnZytGfKZs6YRWPBTZ8X1GvqyMo8Y2jpep4q/5Ezn4YKPhwxB
	 ZkeJlZk3a/k0gfmQ++XwLMoEXsx8QwYfb0Qfopq+ZdqpJutIMT76iHMH5wNW1jzXP
	 YLcUnqpusCODz2f6bJHo+OlOuqibesGqFTVgZqOIG+SbhuGq2aQQErJc6GTd5PMbs
	 yZZiOwSmOoRSbAbfCg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MatRZ-1wshYw0mS3-00fjA2; Tue, 17
 Nov 2026 21:52:09 +0100
Message-ID: <82184da3-6426-4014-aca6-a173f592c914@gmx.com>
Date: Wed, 18 Nov 2026 07:22:07 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] btrfs: fix RCU usage in btrfs_ioctl_dev_info()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b9bd6d147c0e40d4f3c2d8df1bbd8f8f11f2ed31.1794419436.git.fdmanana@suse.com>
 <036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <036f030792d3b497db41f1e7e376e085e094d006.1794588939.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/qCN/htDz4AKhRP1SRVkEly9lJ/EdVxl3wnr32vrQTSn2H4li+F
 98UWapBufJUUCgb/jdOHOcUmXUWNim+ko0MsONQ8HjFzIB9gWzmLCap+u3ZbPQQdBGYCUFG
 gUifpZAMBCNSmF6gpQd02KyZh18/quiUD9LUpaoU88bjlSOo76/weEztOGIshy8HnCZxaEe
 53d673rSO2r89j81g3Pxw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:h1PU/QwLI6w=;z1WFogriBYKTMgm3igtdcArKBWg
 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



=E5=9C=A8 2026/11/14 03:26, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We are using a RCU read section but then we call btrfs_find_device() whi=
ch
> iterates the device lists using a plain list_for_each_entry() and that i=
s
> not safe it can result in loading uninitialized or torn pointers, leadin=
g
> to arbitrary memory dereferences, use-after-free conditions, and kernel
> panics.
>=20
> Update btrfs_find_device() to use list_for_each_entry_rcu() and to alway=
s
> define a RCU read section, since we have several callers that don't lock
> the device_list_mutex before calling it, either because they are within
> an exclusive operation or because they are in a context where no
> concurrency can happen (like during mount for example).
>=20
> We also have manipulations of the devices lists that are not RCU safe, i=
n
> btrfs_init_dev_replace_tgtdev(), btrfs_rm_device(), btrfs_setup_sprout()
> and btrfs_rollback_sprout(), so update those places to use proper RCU li=
st
> manipulation variants.
>=20
> Link: https://sashiko.dev/#/bug/linux-96a9e36b-a712-491c-b210-91c8c4f607=
0f
> Fixes: c5593ca3c8a8 ("btrfs: switch to RCU for device traversal in btrfs=
_ioctl_dev_info")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>=20
> V5: Simplify things by always creating a RCU read section within
>      btrfs_find_device(), as many callers don't lock device_list_mutex.
>=20
> V4: Update stale changelog and fix a use-after-free on a device after
>      removing it (both identified by Sashiko).
>=20
> V3: Fix some more RCU related issues pointed by Sashiko.
>=20
> V2: Fix other existing RCU issues pointed by Sashiko.
>=20
>   fs/btrfs/dev-replace.c |  2 +-
>   fs/btrfs/volumes.c     | 69 +++++++++++++++++++++++++++---------------
>   2 files changed, 46 insertions(+), 25 deletions(-)
>=20
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 3c48cc714fef..6f04d0a49d86 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -319,7 +319,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrf=
s_fs_info *fs_info,
>   		goto error;
>  =20
>   	mutex_lock(&fs_devices->device_list_mutex);
> -	list_add(&device->dev_list, &fs_devices->devices);
> +	list_add_rcu(&device->dev_list, &fs_devices->devices);
>   	fs_devices->num_devices++;
>   	fs_devices->open_devices++;
>   	mutex_unlock(&fs_devices->device_list_mutex);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index a494c913ad12..f128115a3a3b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2358,6 +2358,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
>   	struct btrfs_fs_devices *fs_devices =3D fs_info->fs_devices;
>   	u64 num_devices;
>   	int ret =3D 0;
> +	bool free_cur_devices =3D false;
>  =20
>   	if (btrfs_fs_incompat(fs_info, EXTENT_TREE_V2)) {
>   		btrfs_err(fs_info, "device remove not supported on extent tree v2 ye=
t");
> @@ -2483,8 +2484,25 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info=
,
>  =20
>   	num_devices =3D btrfs_super_num_devices(fs_info->super_copy) - 1;
>   	btrfs_set_super_num_devices(fs_info->super_copy, num_devices);
> +
> +	/*
> +	 * This can happen if cur_devices is the private seed devices list.  W=
e
> +	 * cannot call close_fs_devices() here because it expects the uuid_mut=
ex
> +	 * to be held, but in fact we don't need that for the private
> +	 * seed_devices, we can simply decrement cur_devices->opened and then
> +	 * remove it from our list and free the fs_devices.
> +	 */
> +	if (cur_devices->num_devices =3D=3D 0) {
> +		list_del_rcu(&cur_devices->seed_list);
> +		ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", cur_devices->open=
ed);
> +		cur_devices->opened--;
> +		free_cur_devices =3D true;
> +	}
> +
>   	mutex_unlock(&fs_devices->device_list_mutex);
>  =20
> +	*bdev_file =3D device->bdev_file;
> +
>   	/*
>   	 * At this point, the device is zero sized and detached from the
>   	 * devices list.  All that's left is to zero out the old supers and
> @@ -2503,23 +2521,10 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_inf=
o,
>   		}
>   	}
>  =20
> -	*bdev_file =3D device->bdev_file;
>   	synchronize_rcu();
>   	btrfs_free_device(device);
> -
> -	/*
> -	 * This can happen if cur_devices is the private seed devices list.  W=
e
> -	 * cannot call close_fs_devices() here because it expects the uuid_mut=
ex
> -	 * to be held, but in fact we don't need that for the private
> -	 * seed_devices, we can simply decrement cur_devices->opened and then
> -	 * remove it from our list and free the fs_devices.
> -	 */
> -	if (cur_devices->num_devices =3D=3D 0) {
> -		list_del_init(&cur_devices->seed_list);
> -		ASSERT(cur_devices->opened =3D=3D 1, "opened=3D%d", cur_devices->open=
ed);
> -		cur_devices->opened--;
> +	if (free_cur_devices)
>   		free_fs_devices(cur_devices);
> -	}
>  =20
>   	return btrfs_commit_transaction(trans);
>  =20
> @@ -2799,7 +2804,7 @@ static void btrfs_setup_sprout(struct btrfs_fs_inf=
o *fs_info,
>   	fs_devices->open_devices =3D 0;
>   	fs_devices->missing_devices =3D 0;
>   	fs_devices->rotating =3D false;
> -	list_add(&seed_devices->seed_list, &fs_devices->seed_list);
> +	list_add_rcu(&seed_devices->seed_list, &fs_devices->seed_list);
>  =20
>   	generate_random_uuid(fs_devices->fsid);
>   	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
> @@ -2821,11 +2826,15 @@ static void btrfs_rollback_sprout(struct btrfs_f=
s_info *fs_info,
>   	lockdep_assert_held(&uuid_mutex);
>   	lockdep_assert_held(&fs_devices->device_list_mutex);
>  =20
> -	list_del_init(&seed_devices->seed_list);
> -	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, syn=
chronize_rcu);
> -	list_for_each_entry(device, &fs_devices->devices, dev_list) {
> +	list_del_rcu(&seed_devices->seed_list);
> +	/*
> +	 * Before splicing seed_devices, update the fs_devices of each seed
> +	 * device, otherwise a concurrent RCU reader could get a use-after-fre=
e
> +	 * on device->fs_devices still pointing to seed_devices.
> +	 */
> +	list_for_each_entry(device, &seed_devices->devices, dev_list)
>   		device->fs_devices =3D fs_devices;
> -	}
> +	list_splice_init_rcu(&seed_devices->devices, &fs_devices->devices, syn=
chronize_rcu);
>  =20
>   	fs_devices->seeding =3D true;
>   	fs_devices->num_devices =3D seed_devices->num_devices;
> @@ -7555,21 +7564,33 @@ struct btrfs_device *btrfs_find_device(const str=
uct btrfs_fs_devices *fs_devices
>   	struct btrfs_device *device;
>   	struct btrfs_fs_devices *seed_devs;
>  =20
> +	/*
> +	 * In many cases we are called under the protection of
> +	 * fs_devices->device_list_mutex, in others we are not, so always use =
a
> +	 * RCU read section (if a caller needs a wider RCU read section, nesti=
ng
> +	 * RCU sections works fine).
> +	 */
> +	rcu_read_lock();
>   	if (dev_args_match_fs_devices(args, fs_devices)) {
> -		list_for_each_entry(device, &fs_devices->devices, dev_list) {
> -			if (dev_args_match_device(args, device))
> +		list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
> +			if (dev_args_match_device(args, device)) {
> +				rcu_read_unlock();
>   				return device;
> +			}
>   		}
>   	}
>  =20
> -	list_for_each_entry(seed_devs, &fs_devices->seed_list, seed_list) {
> +	list_for_each_entry_rcu(seed_devs, &fs_devices->seed_list, seed_list) =
{
>   		if (!dev_args_match_fs_devices(args, seed_devs))
>   			continue;
> -		list_for_each_entry(device, &seed_devs->devices, dev_list) {
> -			if (dev_args_match_device(args, device))
> +		list_for_each_entry_rcu(device, &seed_devs->devices, dev_list) {
> +			if (dev_args_match_device(args, device)) {
> +				rcu_read_unlock();
>   				return device;
> +			}
>   		}
>   	}
> +	rcu_read_unlock();
>  =20
>   	return NULL;
>   }

