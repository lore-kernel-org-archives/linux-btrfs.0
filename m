Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D132F41168B;
	Wed,  7 Oct 2026 20:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791406704; cv=none; b=gZUwvDNur2PKa2uZHxgdCHHryBKOz642y8EbdfD9SZ6ylR+4jT6mC2p+GGzsL+hnI4z3u34NrddexY2W8u0XgDMn5WwDPOlTZKQO9m7bAp018bjVCoMu2n35J9ZdbW3NeKlVIlP83+rqw+InVcdVgdJnEKzVeaVK4nt/RisnP/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791406704; c=relaxed/simple;
	bh=gU1CSRhaGHCAwOQZsW3eFuaPSE3QDE8zkwaEM9DfO7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fv/EjX0laoF+JlvmcnSsV8uAZTeefjnxJ2YWbTNswkytX4fcvFsZp6zv3SxlBQu1qCJUyTzeluk87jvYyGDSK9v3dpQaS0tcynZYxpjtfQxXTNacejMKsduybRcXIyIIV9Sxx4n62emWhNFWdxfwwicVc0CDS23Vw5trW1ddRJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=kmeF/NjX; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="kmeF/NjX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791406694; x=1792011494; i=quwenruo.btrfs@gmx.com;
	bh=UcTwgeylLFptTbmR9a/AFVs68pptstoCQzW1uc5hYvU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kmeF/NjXwWy3DugULQqmzPvOJ7bAmyqwxfS/iVtCAnjQfkCqheZKm4XoRdvMCgs+
	 ChOk348tDDYl5okl2mEszJVfs8GLaVSPwVakWlVY3UVUok7WMQpqkLpBS/jDJTaND
	 mlE0tamnmPnuphfAJVgBPVdUp8t58+VwzVA5N3adx6/lOKpv5ZMJWHf9Bwoe7hLsV
	 m1jOU433N1mzDAOoFrjYzbZNk/MOQ0Mjct9QHfpVSWsemY/WkeNN3nmpgeiB2ZUNC
	 cDXpR1dNk2McEYn0u5fGIAAVQbId9C1ICrh9252bC7rqNS1U3oh5vz84T4KqWsrpg
	 Q/Q3RTDLdwxSbXSFfA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M1Ycl-1xGUWc3QVv-006oMZ; Wed, 07
 Oct 2026 22:58:14 +0200
Message-ID: <0686b86d-0677-4041-9875-c4cb73b91582@gmx.com>
Date: Thu, 8 Oct 2026 07:28:08 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix use-after-free on quota enable allocation
 failure
To: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
 Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.com, mason@kernel.org, fdmanana@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
References: <20261007090656.20609-1-pavankumaryalagada@gmail.com>
 <4851139b-6cd0-4b1a-9a6e-1af947d49098@suse.com>
 <55739226-436a-42c3-a5fa-c699b01f819e@suse.com> <asYzOSJqJTgD5Yzp@user>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <asYzOSJqJTgD5Yzp@user>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:r2TI/pg+Xs+lV7MbEJHEceXlWJQsj++LSf+3Wf+8Hu+T5NCWHGB
 O6VlfHSw/6sFblT04Oct7r4I2HCC+SiipTQrNWg6KK05PUV6McJGoKBqR4YcaKYveH8ChKs
 qkFAOdsKBjVkk7OwWJ8ViM91DLpj+dVmqb7wnMP25F/l+i5m3+xB6f0QGkbOoEowjVvBQgr
 Rz2GxHXunLJfOvuTZTSrg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8d3aBkjEKzc=;7cEIRVjz54oY1EE+Hw40bEWONzS
 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



=E5=9C=A8 2026/10/7 22:25, Yalagada Pavan Kumar =E5=86=99=E9=81=93:
> On Wed, Oct 07, 2026 at 08:29:14PM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/10/7 19:47, Qu Wenruo =E5=86=99=E9=81=93:
>>>
>>>
>>> =E5=9C=A8 2026/10/7 19:36, pavankumaryalagada@gmail.com =E5=86=99=E9=
=81=93:
>>>> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>>>>
>>>> The quota root remains on the transaction's dirty root list when
>>>> kzalloc_obj() fails and btrfs_quota_enable() releases it without
>>>> aborting the transaction. Later add_root_to_dirty_list() then accesse=
s
>>>> the freed dirty_list, causing a slab-use-after-free.
>>>>
>>>> Abort the transaction on allocation failure to clean up the dirty
>>>> root before releasing the quota root.
>>>>
>>>> Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=3D947286c775f432b073a=
8
>>>> Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to
>>>> reduce GFP_ATOMIC usage")
>>>> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>>>
>>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>>
>> My bad, Sashiko exposed a valid but very rare race that the temporary
>> quota_root can be added to fs_info->dirty_cowonly_roots list.
>>
>> This requires enough subvolumes to make quota_root to be higher than le=
vel 0
>> in the first place, which is not common but definitely possible.
>>
>> Although all readers of fs_info->dirty_cowonly_roots won't be reached a=
fter
>> the transaction is aborted, there is still a very small window that ano=
ther
>> thread is already holding a trans handler just after the transaction is
>> aborted and the quota root is freed.
>>
>> In that case the other thread may access the already freed quota_root
>> through fs_info->dirty_cowonly_roots->next.
>>
>> I'm afraid we need to call list_del(&quota_root->dirty_list) with prope=
r
>> trans_lock hold during error handling.
>=20
> Thanks, Qu. I understand.
>=20
> I'll update the error handling to remove quota_root->dirty_list under tr=
ans_lock
> before dropping the quota root reference, based on the latest for-next. =
I'll send v2.

I'm exploring the idea to put such list_del() into btrfs_put_root(),=20
which should handle it more gracefully and cover all other situations=20
where a new root is created and dirtied.

Thanks,
Qu

>=20
> Thanks,
> Pavan
>=20
>>>
>>>> ---
>>>>  =C2=A0 fs/btrfs/qgroup.c | 1 +
>>>>  =C2=A0 1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>> index f68b696b4bf7..42be06675c90 100644
>>>> --- a/fs/btrfs/qgroup.c
>>>> +++ b/fs/btrfs/qgroup.c
>>>> @@ -1204,6 +1204,7 @@ int btrfs_quota_enable(struct btrfs_fs_info
>>>> *fs_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prealloc =3D kzalloc_obj(*prealloc, G=
FP_NOFS);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!prealloc) {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOM=
EM;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_abort_transaction(t=
rans, ret);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_free=
_path;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 qgroup =3D add_qgroup_rb(fs_info, pre=
alloc, BTRFS_FS_TREE_OBJECTID);
>>>
>>
>=20

