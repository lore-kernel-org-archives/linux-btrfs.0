Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9D33E2ABB
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527285; cv=none; b=h9vzmcOB/fxb15JwOFQlEZ8AcuJAFy2GLJbxt+ESzQmWOFa5swKnpHtoeddJ3lCa9A4FxnA+VcKjyR2rcbVVf4Gkc0+norOcI8xwUOZa/K/dq8HBc1RoeG86nOwErUPvEdLUyIlQR67XjEss3RQ4fpq9QEJdI1e00lmjHUXhioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527285; c=relaxed/simple;
	bh=R36LgQYbjp2ZxNEyBbWx5Jk5cRiWFWCG2J1dUGNrHQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsnBj+L14eJOR1awDUTIgDWP+ufiR6TxK5R4pFgs5cGDNZCf02R9G0DT0qDhmlUhFPklhoiWbd5LbwxPs2khNGZ9ct8qh7G1dVsj+Z7zi1YitSmhhdmsTHj558ytZOlQ2p81U0JjgUejBU0diReEDvBb/4UY1q8H4baluHIOH6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=RQ05KoEC; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="RQ05KoEC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780527280; x=1781132080; i=quwenruo.btrfs@gmx.com;
	bh=NgrYwQ2ZicJQTXI/Z497FMrLZXzaDpcHrW9ywGyxBkk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RQ05KoECPWu8w2drE6rB8tbY6eclXCu/SVX0MgA9EPrejMuEXyraSWv90UR984dg
	 5xKYEVZteOHbKc5r5HP2rWpbvPqpMk5fnpV00wvhdDv2AdY2nnM4io4jyobYuaHGO
	 v3ESe599dLiUPw3WNFHJ+wrPwql0wpSIb6rczXiu79KkW4SUCJjdvfHWsRTBSG5Xz
	 lAgfDXSAOtEi8Tv8FcHaFgrp55oLpVrngjVOJ7C1iGs+Xz3a/p21E3a+fEGM0RuC8
	 8JR/SdIj7rgNmHpUhUJbnqjGdsU1+E+/gJAp+BkM5Veyx341OBoyY7ApDFIPIrbPw
	 EVm675BTh5OjAtqgtg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mz9Ux-1xQqey3TMZ-0121uE; Thu, 04
 Jun 2026 00:54:40 +0200
Message-ID: <a0623603-8220-49d0-8fe5-c4c80b8fa7a3@gmx.com>
Date: Thu, 4 Jun 2026 08:24:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: do not enforce qgroup limits when changing
 qgroup limits
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, fdmanana@suse.com
References: <20260603111857.230985-1-zhudongjiang@fnnas.com>
 <ad4ceb68-99e5-432a-8589-de5e917b47d6@gmx.com>
 <7159aec7-f117-4e3e-9b91-bfef6cbf8d6b@fnnas.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <7159aec7-f117-4e3e-9b91-bfef6cbf8d6b@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4lYahm/TuqO/wYAO2LXIVUgNF+/GXBWc1ekf74ZzJm/DRJptPWI
 YIHhVgxM5r3thDg+M07gutIEDjP8wCxd/g10srmizoKhno6NK9vG5nY3bMlfDzTCOAWfz9k
 f9v1bdjcpX329dpLaXj2EOlUjdSd1p8T/zoZdZzramama9v2UHAEaPS6MXYbki0e6qSbjfh
 FREtedeU8TnaO/SqaAd7g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:P78I/gwVh54=;ZhiN+bWpB+WlYN3gJwr4MxG/Oo+
 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



=E5=9C=A8 2026/6/3 22:29, Dongjiang Zhu =E5=86=99=E9=81=93:
> =E5=9C=A8 2026/6/3 19:33, Qu Wenruo =E5=86=99=E9=81=93:
>>
>>
>> =E5=9C=A8 2026/6/3 20:48, Dongjiang Zhu =E5=86=99=E9=81=93:
>>> Since qgroup ioctls started reserving transaction space, qgroup limit
>>> changes can fail before reaching btrfs_limit_qgroup().
>>>
>>> For example, if a subvolume qgroup has reached its max referenced limi=
t,
>>> issuing BTRFS_IOC_QGROUP_LIMIT on a path inside that subvolume makes
>>> btrfs_start_transaction(root, 1) reserve qgroup metadata against that
>>> same qgroup. The reservation can fail with -EDQUOT, so the administrat=
or
>>> cannot increase or disable the limit that caused the failure.
>>>
>>> This is also path dependent. The same operation may succeed when the
>>> ioctl is issued on another path from the same filesystem whose root
>>> qgroup is not limited, while it fails on the target subvolume path.
>>>
>>> Keep reserving transaction space for the QGROUP_LIMIT item, but do not
>>> enforce qgroup limits for that transaction reservation. This preserves
>>> the metadata and delayed ref reservation semantics added for qgroup
>>> ioctls, while avoiding a qgroup limit self-deadlock for limit changes.
>>>
>>> Currently this can be worked around by enabling quota_override or by
>>> issuing the ioctl on another path from the same filesystem whose root
>>> qgroup is not limited. However, changing a qgroup limit should not dep=
end
>>> on either of those.
>>>
>>> This only changes BTRFS_IOC_QGROUP_LIMIT. A follow-up question is whet=
her
>>> the same helper should also be used for other qgroup management ioctls=
,
>>> such as qgroup destroy or relation removal, when they are part of
>>> recovering from an over-limit state.
>>>
>>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
>>> ---
>>>  =C2=A0 fs/btrfs/ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 ++++=
++++--
>>>  =C2=A0 fs/btrfs/transaction.c |=C2=A0 8 ++++++++
>>>  =C2=A0 fs/btrfs/transaction.h |=C2=A0 3 +++
>>>  =C2=A0 3 files changed, 19 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 9d47d16394fc..1e410db06c19 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -3758,8 +3758,14 @@ static long btrfs_ioctl_qgroup_limit(struct
>>> file *file, void __user *arg)
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_writ=
e;
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 /* 1 BTRFS_QGROUP_LIMIT_KEY item. */
>>> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 1);
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * 1 BTRFS_QGROUP_LIMIT_KEY item.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not enforce the current qgroup limit wh=
ile changing that
>>> limit,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * otherwise a qgroup that already reached it=
s limit cannot have the
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * limit increased or disabled.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction_no_qgroup_enforc=
e(root, 1);
>>
>> Nope, you should not work on the subvolume root.
>>
>> The transaction is working on qgroup tree, so it's just simply passing
>> the wrong root.
>=20
> Yes, that makes sense. The qgroup ioctls update the quota tree, so using
> the inode root makes the transaction reservation depend on the path used
> for the ioctl.
>=20
> I'll rework this to start the transaction on fs_info->quota_root instead
> of adding a no-qgroup-enforce helper.
>=20
> I think the same should apply to the other qgroup management ioctls,
> such as create/destroy and assign/remove, since they also update the
> quota tree. Do you think v2 should switch them to fs_info->quota_root as
> well?

Yes

>=20
> Thanks,
> Dongjiang

