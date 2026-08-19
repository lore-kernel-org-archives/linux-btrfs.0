Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEAC3E2ADA
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787177674; cv=none; b=Be8g0FLfyK7MoSsqKQbe/msIwYJ+UqUfc6D/CPN86WQQfOTSBWdbuHygfuQ5Go4F1Vnaia+CAVcASol/wCC36RjaDJDpOWH9B7VUB4SkBLtnTO6DJd/i6xh+urmMxhxmozJK1pKQ4lezTPSuvirhGECJ3NwLq+oouSR79trWGUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787177674; c=relaxed/simple;
	bh=o2uk/F/AIBJeQQerYUb90yPKoq7RTOfUNpPEQmyXvmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fO8WaM0pdHNX3DRcIPgDO7iiDzue7bgbO45115KGmggCv0L5aeu9EYplc2QKULGFCjLVoEFYc9VXRVuuMekJ5ItiNOouQWPo1w3RPrEio6Zs5ZJqMjMNt1GNY7PS/N+dF3KD2aPF+rv5aWnDA4f0uF6J4kUgZEFdh/qMGRhwWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=AgnehRQp; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="AgnehRQp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1787177669; x=1787782469; i=quwenruo.btrfs@gmx.com;
	bh=MLmJF0SssuoQMFkOdRXFCmPUJbXjFonws7aDSO7goNA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=AgnehRQpi9DOy9GTWUimt8YC1fs7XP7raKUlldc0SDhO49RvJ22FpJ3SXkYO/2NT
	 oHAdiK/AnAiuxkUo1XC0N5cflLGkilFRrYHftTfDeQSJgOOjZBOJIFIbndqZ/gqOp
	 joWoLmk5RyzRM+dGcYRHhoVyl4cmp+gzLmlYY9I/1lSfHP2n/c6qz0jV8wSZFTSdM
	 /dguwRJIGnriEm1nkQoko7Dy8kkzz61ZbRAFHIOFHJjiscHt7hjTPh4MPT8nIIe+4
	 ishDDia168MK2ncm9vT1ffKj8TlN4G5yzUz8z/rb7LjDbCO5H/uBbjLORSn/mIxCI
	 DYLyZG7y1+/7FUuwqg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MkYc0-1wX3vP0OHm-00ZtF5; Thu, 20
 Aug 2026 00:14:29 +0200
Message-ID: <77d934f5-0dd0-4607-84f9-a95ddf052cf1@gmx.com>
Date: Thu, 20 Aug 2026 07:44:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: properly cleanup replace_task when the replace
 failed to start
To: Jeff Layton <jlayton@kernel.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
References: <8e4f535ac093c7085ab0641114e2f082788585f5.1786576348.git.wqu@suse.com>
 <fdb9d5bb8a87126399f328717cd358351ed0f4cd.camel@kernel.org>
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
In-Reply-To: <fdb9d5bb8a87126399f328717cd358351ed0f4cd.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZDvbZyQjnPi0XU892H/vl+e8kbThFeugf+aGrpVxszbRT+tMD8t
 x+i+vAzPHip+N11UJU88VsqGGE47fEYjJAI6Qc40Sn65pX7/S9HMkCkEgS8oWamVpKhtH4o
 TjrTEMmTSQ6EF5Pou7uYEyFEekM8nG912t+51P1anLy3KosvMKbjulxWaBL1v3fhRMAIiY4
 qiKK1WY0pK620jRN1/Jzw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:zFrJatbl9ic=;NziXWh+/Bi9JlaKDCNkoU1sYLTw
 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



=E5=9C=A8 2026/8/19 21:58, Jeff Layton =E5=86=99=E9=81=93:
> Claude had some more comments on this one:
>=20
> This moves the dev_replace->replace_task assignment in
> btrfs_dev_replace_start() below the replace_state switch, clears it when
> btrfs_start_transaction() fails there, and clears it at the top of
> btrfs_dev_replace_finishing() so every exit from that function drops it.
>=20
>> In the function btrfs_dev_replace_start(), we have several error paths
>> that assigns replace_task without reverting it back to NULL.
>>
>> There are two involved error paths:
>>
>> - There is already a running dev-replace
>>    Then replace_task is over-written to the current task.
>>    This is the one with long running effect.
>>
>> - The btrfs_start_transaction() call failed
>>    This is much harder to hit though.
>=20
> [ ... ]
>=20
>> Thankfully this bug is very hard to hit.
>>
>> As dev-replace is an exclusive operation, thus if there is already
>> a running replace, a new one will be rejected early without reaching
>> btrfs_dev_replace_start().
>>
>> The only remaining case is a suspended replace, which is much harder to
>> hit, e.g. requiring async dev-replace conflicting with another exclusiv=
e
>> operation, then a new replace is started.
>=20
> Is "very hard to hit" still accurate now that btrfs_dev_replace_finishin=
g()
> is fixed too?

That "very hard to hit" was for the old code before the fix, but indeed=20
Claude found an extra path that cancel can always leave that stale=20
replace_task.


>=20
> A plain "btrfs replace cancel" leaves replace_task set every time.
> btrfs_dev_replace_cancel() calls btrfs_scrub_cancel() while replace_stat=
e is
> BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED, so btrfs_scrub_dev() returns
> -ECANCELED to btrfs_dev_replace_start(), which passes it straight into
> btrfs_dev_replace_finishing():
>=20
> fs/btrfs/dev-replace.c:btrfs_dev_replace_start() {
> 	...
> 	ret =3D btrfs_scrub_dev(fs_info, src_device->devid, 0, ...);
>=20
> 	ret =3D btrfs_dev_replace_finishing(fs_info, ret);
> 	...
> }
>=20
> fs/btrfs/dev-replace.c:btrfs_dev_replace_finishing() {
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
> That exit never reaches the replace_task =3D NULL at the end of the func=
tion,
> so the ioctl returns to userspace with replace_task still pointing at th=
e
> task that ran it.  Any scrub failure, not only -ECANCELED, lands there a=
s
> well.
>=20
> The subject line says "when the replace failed to start", which does not
> cover the cancel or scrub-error case either.  Could the subject and the
> changelog describe those paths too?
>=20
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 72cba7fed942..c5e67524b417 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>=20
> [ ... ]
>=20
>> @@ -874,18 +875,20 @@ static int btrfs_dev_replace_finishing(struct btr=
fs_fs_info *fs_info,
>>   	/* don't allow cancel or unmount to disturb the finishing procedure =
*/
>>   	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
>>
>> -	down_read(&dev_replace->rwsem);
>> +	down_write(&dev_replace->rwsem);
>> +	dev_replace->replace_task =3D NULL;
>> +
>>   	/* was the operation canceled, or is it finished? */
>>   	if (dev_replace->replace_state !=3D
>>   	    BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED) {
>> -		up_read(&dev_replace->rwsem);
>> +		up_write(&dev_replace->rwsem);
>>   		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>>   		return 0;
>>   	}
>>
>>   	tgt_device =3D dev_replace->tgtdev;
>>   	src_device =3D dev_replace->srcdev;
>> -	up_read(&dev_replace->rwsem);
>> +	up_write(&dev_replace->rwsem);
>=20
> Is clearing replace_task this early intentional?

Yes.

The real work of dev-replace has all finished.
>=20
> At this point replace_state is still BTRFS_IOCTL_DEV_REPLACE_STATE_START=
ED,
> and btrfs_start_delalloc_roots() plus the btrfs_start_transaction() /
> btrfs_commit_transaction() loop are still ahead.  For all of that window=
 the
> replace task goes back to taking the rwsem in btrfs_map_block():
>=20
> fs/btrfs/volumes.c:btrfs_map_block() {
> 	...
> 	if (dev_replace->replace_task !=3D current)
> 		down_read(&dev_replace->rwsem);
>=20
> 	dev_replace_is_ongoing =3D btrfs_dev_replace_is_ongoing(dev_replace);
> 	...
> }
>=20
> which is the exemption 8cca35cb29f8 ("btrfs: don't take dev_replace rwse=
m on
> task already holding it") added.
>=20
> The down_write() further down already covers both the success exit and t=
he
> error: exit, so clearing replace_task next to the replace_state update t=
here,
> plus the three early returns, would leave the ongoing window unchanged.

Alright, I guess the model you're using is digging deeper than opus.

It looks like we should not reset replace_task until the replace_state=20
is also updated.

Or during the transaction commit, it will lead to the same problem.

We rely on btrfs_dev_replace_is_ongoing() to return false to release=20
rwsem early and avoid the deadlock.

So the early reset leaves a window we can deadlock again.

Will send an update to this patch.

Thanks,
Qu

>=20
> The changelog says only:
>=20
>>    - Reset replace_task to NULL for all paths of
>>      btrfs_dev_replace_finishing()
>=20
> Could it also mention that the read lock at the head of the function bec=
omes
> a write lock?
>=20
>=20

