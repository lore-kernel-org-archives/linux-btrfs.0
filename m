Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1FF345ED1
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 22:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786573469; cv=none; b=kiu9j2+A5G6KA23cxZHfzgla5uvstsy5KmqtgcG4TLi6fNQRxmIv5352jEhaacAYJvsWFjjdiR0HVjB0FQek3rANbfTc1PvGrFi31gfxzCSJ3puB4hjRjr22vchU9bR5p2B4GnhbSMAlw++CS7y6+oWz+0ueoqYqBMxaslSwD0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786573469; c=relaxed/simple;
	bh=MIdoVPvo0NEjU80Z0vAzFMKpr15t66bEHAK8PdpUThY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=V6CAe2WhGNlGdLVH8yK8mELH+FUXxrsgezmq04yX4B4bBEpzpHH6uLJLfszsJlo+bwwkR4cP3P2Wj6KUBF9OdlGhaEf7q7PNudHmIrfVJFQ5CIImrFfP0jWs9CnWgJjGrQJEQeDO8gLEkkjy11wZk5sgf2LXGKkSLfh6WmRAyrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=kB6g/RJj; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="kB6g/RJj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786573461; x=1787178261; i=quwenruo.btrfs@gmx.com;
	bh=EqlpEdSSLZqFbJHHsSrTqClSDIF+gmgJUWK6oP2yup4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kB6g/RJjgFN6Dvru7fOTYOg76hwEsCeJqIOMdGRMs+7nAdlCCInb/PmDt46affWF
	 GOzIe26ymbovuvksWAwHVNG1VsfCCNI6qo1mvVqUXkM8rhouZnFXbKI6TqEDLY08x
	 D9vfIVOeBen85dZm/PvlouYrbqS1oVgho4ND59kt2f/a7r17r4tpS4e78oN+7PrgH
	 68oWZ1AE4oKPHbBtOro7LCQIIPKbKdnX1okkc1/p5NhWv5W+YTpCVDDsc5NQBwyyO
	 j3O2RwAdLu+VtZW+RxQMvChBSXwAFT/AUqZ0WmZd0QpXyzDOcvb2fCFCmoZilvtk4
	 Llz7RgHFf/EgE9ljUg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MMobO-1wbW401eVg-00P3QO; Thu, 13
 Aug 2026 00:24:21 +0200
Message-ID: <823fa645-0bcb-437f-bc0e-719f2ca113da@gmx.com>
Date: Thu, 13 Aug 2026 07:54:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: properly cleanup replace_task when the replace
 failed to start
To: Jeff Layton <jlayton@kernel.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
References: <2bb108e8d3204506a80562fec03d0d365583631f.1786348282.git.wqu@suse.com>
 <5f0a52c918ba270886df4e5479370f286aee1adf.camel@kernel.org>
 <e1c8f795-3aa1-4162-8467-10878961f064@gmx.com>
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
In-Reply-To: <e1c8f795-3aa1-4162-8467-10878961f064@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n1oGXkfIwYZTxZDojz29jbkyKPRS4g2iOB4xOmvo2jv2wlSj708
 Vurg6Dyvhh5jMdN9/EaT4kNgz2pkjPxpspXFv5VcMoUaJk6YxrZ50CWYBf/RtzDUPx4/vc+
 pca4IWDF+dtyPiWiS7dg6SBaSt6fYeUE4482EgW5d9KjBJu/Ow+K2rfxAZpArWVRBKFUBCH
 JWzAHD+mnl4IezAirspFw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kEd2OaYU9oQ=;0MrKRcycc0l5p2GfK8H8mGjO7JG
 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



=E5=9C=A8 2026/8/13 07:11, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/8/12 21:33, Jeff Layton =E5=86=99=E9=81=93:
>> I ran this through some LLM review and it seems to think that this fix
>> isn't complete. Pasting the review comments verbatim below:
>>
>> On Mon, 2026-08-10 at 17:21 +0930, Qu Wenruo wrote:
>>
>>> In the function btrfs_dev_replace_start(), we have several error paths
>>> that assigns replace_start without reverting it back to NULL.
>>
>> This isn't a bug, but should replace_start be replace_task here?
>>
>>> But since dev_replace->rwsem is incorrectly updated, a process
>>> triggering the update will no longer be protected from dev-replace's
>>> device list modification, thus later IO can get stale device info,
>>> triggering things like use-after-free.
>>
>> The thing left incorrectly updated is dev_replace->replace_task, not
>> dev_replace->rwsem, right?
>=20
> Oh no, I updated the commit message without review it again, now it's=20
> all kinds of wrong names...
>=20
>>
>>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>>> index 72cba7fed942..5fc1dec88fb2 100644
>>> --- a/fs/btrfs/dev-replace.c
>>> +++ b/fs/btrfs/dev-replace.c
>>> @@ -633,7 +633,6 @@ static int btrfs_dev_replace_start(struct=20
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto leave;
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_write(&dev_replace->rwsem);
>>> -=C2=A0=C2=A0=C2=A0 dev_replace->replace_task =3D current;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (dev_replace->replace_state) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVE=
R_STARTED:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BTRFS_IOCTL_DEV_REPLACE_STATE_FINI=
SHED:
>>> @@ -647,6 +646,7 @@ static int btrfs_dev_replace_start(struct=20
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto leave;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>
>>> +=C2=A0=C2=A0=C2=A0 dev_replace->replace_task =3D current;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->cont_reading_from_srcdev_m=
ode =3D read_src;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->srcdev =3D src_device;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->tgtdev =3D tgt_device;
>>> @@ -693,6 +693,7 @@ static int btrfs_dev_replace_start(struct=20
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->sr=
cdev =3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->tg=
tdev =3D NULL;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dev_replace->replace_task =
=3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&dev_r=
eplace->rwsem);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto leave;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>
>> Both of the paths handled here are inside btrfs_dev_replace_start().=C2=
=A0 Is
>> the same reset needed in btrfs_dev_replace_finishing()?=C2=A0 That func=
tion
>> only clears replace_task on the path that completes the swap:
>>
>> fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> =C2=A0=C2=A0=C2=A0=C2=A0list_add(&tgt_device->dev_alloc_list, &fs_devic=
es->alloc_list);
>> =C2=A0=C2=A0=C2=A0=C2=A0fs_devices->rw_devices++;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0dev_replace->replace_task =3D NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0up_write(&dev_replace->rwsem);
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> }
>>
>> The scrub_ret error path returns earlier.=C2=A0 It clears srcdev and tg=
tdev=20
>> and
>> moves the state to canceled, but leaves replace_task pointing at the ta=
sk
>> that started the replace:
>>
>> fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> =C2=A0=C2=A0=C2=A0=C2=A0down_write(&dev_replace->rwsem);
>> =C2=A0=C2=A0=C2=A0=C2=A0dev_replace->replace_state =3D
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 scrub_ret ? BTRFS_IOCTL_DEV_=
REPLACE_STATE_CANCELED
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
>> =C2=A0=C2=A0=C2=A0=C2=A0dev_replace->tgtdev =3D NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0dev_replace->srcdev =3D NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> =C2=A0=C2=A0=C2=A0=C2=A0} else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (scrub_ret !=3D -ECANCELE=
D)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrf=
s_err(fs_info, ...);
>> error:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_write(&dev_replace->rwsem=
);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return scrub_ret;
>> =C2=A0=C2=A0=C2=A0=C2=A0}
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> }
>>
>> An ordinary "btrfs replace cancel" ends up there:
>>
>> btrfs_dev_replace_cancel()
>> =C2=A0=C2=A0=C2=A0=C2=A0 btrfs_scrub_cancel()
>>
>> btrfs_dev_replace_start()
>> =C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_scrub_dev()=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -> -ECANCELED
>> =C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_dev_replace_finishing(fs_info, r=
et)
>> =C2=A0=C2=A0=C2=A0=C2=A0-> error: ... return scrub_ret
>>
>> The ioctl then returns to userspace with dev_replace->replace_task stil=
l
>> set to the task that ran the ioctl.=C2=A0 Isn't that the same stale poi=
nter=20
>> the
>> commit message describes for the already-started case, only reachable
>> without a second replace or an allocation failure?
>=20
> You're right! This is indeed a missing call site.
>=20
>>
>> The two other early returns in btrfs_dev_replace_finishing(), the
>> btrfs_start_delalloc_roots() failure and the btrfs_start_transaction()
>> failure in the commit loop, leave it set as well.
>>
>> There is a second effect once replace_task is stale but still compares
>> equal to a live task.=C2=A0 btrfs_map_block() reads it twice:
>>
>> fs/btrfs/volumes.c:btrfs_map_block() {
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> =C2=A0=C2=A0=C2=A0=C2=A0if (dev_replace->replace_task !=3D current)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_read(&dev_replace->rwse=
m);
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0dev_replace_is_ongoing =3D btrfs_dev_replace_is=
_ongoing(dev_replace);
>> =C2=A0=C2=A0=C2=A0=C2=A0/*
>> =C2=A0=C2=A0=C2=A0=C2=A0 * Hold the semaphore for read during the whole=
 operation, write is
>> =C2=A0=C2=A0=C2=A0=C2=A0 * requested at commit time but must wait.
>> =C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0=C2=A0if (!dev_replace_is_ongoing && dev_replace->rep=
lace_task !=3D current)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up_read(&dev_replace->rwsem)=
;
>> =C2=A0=C2=A0=C2=A0=C2=A0...
>> }
>>
>> If a later btrfs_dev_replace_start() assigns replace_task between those
>> two reads, the first test skips down_read() while the second one runs
>> up_read().=C2=A0 Can that release an rwsem this task never acquired?
>=20
> This is another missing point, although it may be a little tricky to fix=
.
>=20
> If we take the rwsem just to read replace_task, it will greatly reduce=
=20
> the concurrency of btrfs_map_block(), even if there is no running replac=
e.
>=20
> I'll replace all those existing replace_task checks, and only do one=20
> comparison and save the result, so as long as we take the rwsem, it will=
=20
> always be released.

It turns out that, this is a complex false alerts.

There are several things here to ensure we won't get split lock/unlock=20
behaviors:

- For tasks unrelated to replace
   They always get the replace_task mismatching current, and since the
   current task is already inside btrfs_map_block(), there is no way that
   the current task can run code to reassign replace_task.

   So even if replace_task is changed, it will never be changed to the
   current task, so we will still unlock the rwsem.

- For task which started the replace
   In that case, we are the task which called btrfs_dev_replace_start().

   However the only call site that re-assign replace_task is either
   btrfs_dev_replace_start() or btrfs_dev_replace_finishing() that I'm
   fixing.

   As long as btrfs_dev_replace_start() is fixed so that replace_task is
   not assigned to another task, we're safe.

   As btrfs_dev_replace_finishing() can only be reached by the running
   replace, which is the current task.

>=20
>=20
> Although I'm not sure if we should introduce one extra spinlock to=20
> protect btrfs_dev_replace_is_ongoing().
> As in that function we're checking two members, is_valid and state=20
> without any protection.
>=20
> Thanks,
> Qu
>=20

