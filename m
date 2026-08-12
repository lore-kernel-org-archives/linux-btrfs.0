Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13865400962
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786570910; cv=none; b=Lppj36fnf+D4RvbOBMGKAD+19F/hU9/AEpYryPCMEnPy8dVeCJz/xm+h34Ybm6k5LJjPgW/VwEYttgYerZQbU6WWT3q5UP8Ji/rdn6F5lKodJL6aeIfOMay+bWup7Hb+lftEkk99avPGg3zjS2JdDJFhDaJugwP+/fn/flEdG5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786570910; c=relaxed/simple;
	bh=6fbts1I3ECBRI0fxhWnCw28jcEoNlk27ClITIw8JEPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=L3T5PXwF7N1rxLM4cb9anGbU+j/9THhE82D1sUXXTdo1n142b2R8lWWHiFT930tt8qmdfMKgQbTlgO8JXdsMjO95pNILFf+Y50DkNd+ncN259xEkecFf3CUKpjCCVj4wFRvAx9YSLCQP5/Ao1GJD9wQe6x8MbTab3FViLi6vft4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=S7Wndmak; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="S7Wndmak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786570906; x=1787175706; i=quwenruo.btrfs@gmx.com;
	bh=ldt6wNxSZgj7Mh4ggj7IxXgv1KNZ51K1CJrwGF+Jr2Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=S7Wndmaks1TfltmCFDbkdfEdY9uGowMVFF6+Ojob+w5RbCm7uW2QSt+SoAGfeXpv
	 TW5SaWi5gEeetdK2DAKcXhG/E7IuDOe+Ga71PcOxsCAXy9rq+kp22oi5FizvA3Qn3
	 5aLOHxzkemrosobbD72awZGKvwz98Brl/MIPhmPg6lAIAklLCdrIr1buLvaDkdmtR
	 WdtjiSCIGeqZRCt6bvr1w+zi8j3e4zzwO0INK7WPHk7OyWiLsbS84649bXLJJ6LrP
	 382SdjopLUjtwb+7vcno8FWcCHlYqvDFIyaX92Pp5vczv19Av8uMVwGX2z5H9g+Yz
	 Bho3UjL68PKH7AjI/w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MF3He-1weqMy3SK8-009dll; Wed, 12
 Aug 2026 23:41:45 +0200
Message-ID: <e1c8f795-3aa1-4162-8467-10878961f064@gmx.com>
Date: Thu, 13 Aug 2026 07:11:41 +0930
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
In-Reply-To: <5f0a52c918ba270886df4e5479370f286aee1adf.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:efEp2O00st6zD9GNstECq/JF/rFn2juvdSpcHIiTSNXa1BWhH14
 pMMiFhtb88Xao7xG5LfXTK7WSFSt8wA0pYzp87/iOdwmSv7JiilW4PNQ21u3bMQ334So7wj
 7RmEYHR+5/2ImaQ0bCuPtgOYoiVFBt8ZXBBCRNc6/u6Ljd7nKvR//kqL0S3eHKFlcZEV0NQ
 AyqHKrN15eWvS4EgLjQTA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sXk3fTUA9TY=;OH7/hM7rFQaEhQyVbm//S3fRXOO
 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



=E5=9C=A8 2026/8/12 21:33, Jeff Layton =E5=86=99=E9=81=93:
> I ran this through some LLM review and it seems to think that this fix
> isn't complete. Pasting the review comments verbatim below:
>=20
> On Mon, 2026-08-10 at 17:21 +0930, Qu Wenruo wrote:
>=20
>> In the function btrfs_dev_replace_start(), we have several error paths
>> that assigns replace_start without reverting it back to NULL.
>=20
> This isn't a bug, but should replace_start be replace_task here?
>=20
>> But since dev_replace->rwsem is incorrectly updated, a process
>> triggering the update will no longer be protected from dev-replace's
>> device list modification, thus later IO can get stale device info,
>> triggering things like use-after-free.
>=20
> The thing left incorrectly updated is dev_replace->replace_task, not
> dev_replace->rwsem, right?

Oh no, I updated the commit message without review it again, now it's=20
all kinds of wrong names...

>=20
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 72cba7fed942..5fc1dec88fb2 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -633,7 +633,6 @@ static int btrfs_dev_replace_start(struct btrfs_fs_=
info *fs_info,
>>   		goto leave;
>>
>>   	down_write(&dev_replace->rwsem);
>> -	dev_replace->replace_task =3D current;
>>   	switch (dev_replace->replace_state) {
>>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
>>   	case BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED:
>> @@ -647,6 +646,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_=
info *fs_info,
>>   		goto leave;
>>   	}
>>
>> +	dev_replace->replace_task =3D current;
>>   	dev_replace->cont_reading_from_srcdev_mode =3D read_src;
>>   	dev_replace->srcdev =3D src_device;
>>   	dev_replace->tgtdev =3D tgt_device;
>> @@ -693,6 +693,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_=
info *fs_info,
>>   			BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
>>   		dev_replace->srcdev =3D NULL;
>>   		dev_replace->tgtdev =3D NULL;
>> +		dev_replace->replace_task =3D NULL;
>>   		up_write(&dev_replace->rwsem);
>>   		goto leave;
>>   	}
>=20
> Both of the paths handled here are inside btrfs_dev_replace_start().  Is
> the same reset needed in btrfs_dev_replace_finishing()?  That function
> only clears replace_task on the path that completes the swap:
>=20
> fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
> 	...
> 	list_add(&tgt_device->dev_alloc_list, &fs_devices->alloc_list);
> 	fs_devices->rw_devices++;
>=20
> 	dev_replace->replace_task =3D NULL;
> 	up_write(&dev_replace->rwsem);
> 	...
> }
>=20
> The scrub_ret error path returns earlier.  It clears srcdev and tgtdev a=
nd
> moves the state to canceled, but leaves replace_task pointing at the tas=
k
> that started the replace:
>=20
> fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
> 	...
> 	down_write(&dev_replace->rwsem);
> 	dev_replace->replace_state =3D
> 		scrub_ret ? BTRFS_IOCTL_DEV_REPLACE_STATE_CANCELED
> 			  : BTRFS_IOCTL_DEV_REPLACE_STATE_FINISHED;
> 	dev_replace->tgtdev =3D NULL;
> 	dev_replace->srcdev =3D NULL;
> 	...
> 	} else {
> 		if (scrub_ret !=3D -ECANCELED)
> 			btrfs_err(fs_info, ...);
> error:
> 		up_write(&dev_replace->rwsem);
> 		...
> 		return scrub_ret;
> 	}
> 	...
> }
>=20
> An ordinary "btrfs replace cancel" ends up there:
>=20
> btrfs_dev_replace_cancel()
>      btrfs_scrub_cancel()
>=20
> btrfs_dev_replace_start()
>      ret =3D btrfs_scrub_dev()			-> -ECANCELED
>      ret =3D btrfs_dev_replace_finishing(fs_info, ret)
> 	-> error: ... return scrub_ret
>=20
> The ioctl then returns to userspace with dev_replace->replace_task still
> set to the task that ran the ioctl.  Isn't that the same stale pointer t=
he
> commit message describes for the already-started case, only reachable
> without a second replace or an allocation failure?

You're right! This is indeed a missing call site.

>=20
> The two other early returns in btrfs_dev_replace_finishing(), the
> btrfs_start_delalloc_roots() failure and the btrfs_start_transaction()
> failure in the commit loop, leave it set as well.
>=20
> There is a second effect once replace_task is stale but still compares
> equal to a live task.  btrfs_map_block() reads it twice:
>=20
> fs/btrfs/volumes.c:btrfs_map_block() {
> 	...
> 	if (dev_replace->replace_task !=3D current)
> 		down_read(&dev_replace->rwsem);
>=20
> 	dev_replace_is_ongoing =3D btrfs_dev_replace_is_ongoing(dev_replace);
> 	/*
> 	 * Hold the semaphore for read during the whole operation, write is
> 	 * requested at commit time but must wait.
> 	 */
> 	if (!dev_replace_is_ongoing && dev_replace->replace_task !=3D current)
> 		up_read(&dev_replace->rwsem);
> 	...
> }
>=20
> If a later btrfs_dev_replace_start() assigns replace_task between those
> two reads, the first test skips down_read() while the second one runs
> up_read().  Can that release an rwsem this task never acquired?

This is another missing point, although it may be a little tricky to fix.

If we take the rwsem just to read replace_task, it will greatly reduce=20
the concurrency of btrfs_map_block(), even if there is no running replace.

I'll replace all those existing replace_task checks, and only do one=20
comparison and save the result, so as long as we take the rwsem, it will=
=20
always be released.


Although I'm not sure if we should introduce one extra spinlock to=20
protect btrfs_dev_replace_is_ongoing().
As in that function we're checking two members, is_valid and state=20
without any protection.

Thanks,
Qu
