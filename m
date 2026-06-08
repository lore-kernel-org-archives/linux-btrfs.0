Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6A25782A;
	Mon,  8 Jun 2026 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917831; cv=none; b=BnL1fNu1rG7dJYRIBCatbyFfo0QRSZNwfrCWPYEvdwjZxGyi8WPZlduBzgrGcnRUUP9pg3epFbpyfbFT9Z5/QpXMZW69GuJjAOsVL6Nd/lqRDD5wIvZsUEdao+KJJIiP4f0lxtwdJTek/H/TU6ewLwR+cMhn7Dq+0MmEkRJ63NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917831; c=relaxed/simple;
	bh=1CFMcha76WDptctYtWO8pKX/qTBi7O9fcWPOK7XD7Y8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBRDQD9WR7vEySbsTW0sAhhtVVxtLiO6wnmLcUNbYj8sFkHUNLrbbdmS7Dy3F9vouyxN4tIbnYmB3gZqhkDxj/+tH3vEdKtJe+d0D7CCKlWRuJWu9klwG9xDCxkB6DeZzqdrg2RtH5HnCxB2fYbbnugUFfcfZcow3hlXQctEgrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=HvS+rm2e; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="HvS+rm2e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780917823; x=1781522623; i=quwenruo.btrfs@gmx.com;
	bh=3/BQbN3NryOl7r7m/92I8QydN41XMzTfR3HWTqm50bg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HvS+rm2eCHpyAC2isWmEA9D31zeuHJsyu5qfc97yeEmxU6AH5mKycuo3mP7difCw
	 xquY5gd240illLofM6G32gJrrtrOck23fg2TRWNyFLbNwJhRDv0vxeR0oL5SNkQpX
	 nHAO1LPeFatxYflp+sAv/uOUCISp/2zwyQeRiWmHBpv4V+VgORX/RoQanFsts4GbO
	 s1Hoy1LsloeXCw67bldH+VXCWagVmiyhBD7lK86HGpOQMLnzLt2MR1eW2QxfHEHQx
	 JiwDXUkbmtStudvKAUOzQ6+G7SX4TIGgQ2AGayNW3X2uJKOE6K/juPyT8LcagJ7VQ
	 ycnbkt2Nqv/D5VgJrw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MEFzx-1wMt1m02s9-006J9b; Mon, 08
 Jun 2026 13:23:43 +0200
Message-ID: <2408e64c-ffac-4276-8631-a9f073fb5892@gmx.com>
Date: Mon, 8 Jun 2026 20:53:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do not overwrite NODATASUM flag when removing
 NODATACOW flag
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <e0be9c192cf8896a7f02ae23880f8e4921102129.1780912039.git.wqu@suse.com>
 <CAL3q7H4SXDUCsKrLK27GwT0itbSd_aozt5A2TvVR5e34gZD51w@mail.gmail.com>
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
In-Reply-To: <CAL3q7H4SXDUCsKrLK27GwT0itbSd_aozt5A2TvVR5e34gZD51w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JuOniuWdM90Dx0Ov6T75/YA7bjZZUIen2xAKdTi0ek7q36W2QXv
 vjfeum38yDyoAgec2bTYXrQHWp/zEtt92wWOQHeUuomy7yYaEvQBkuH4ww5Nt0aFRtu9P3a
 tsqY29pzQtC/UZk0z4TeU4jTbgTQgn2KAcyiSBuliFQzRhAJ5wff6h/7L6HYr113kFEuOZv
 5NfZzGzBTAkEu4cGJGjUQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fhAydHi56wQ=;VO7tXNgWl7t5sne7/TPOyc5ZCBF
 +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



=E5=9C=A8 2026/6/8 20:44, Filipe Manana =E5=86=99=E9=81=93:
> On Mon, Jun 8, 2026 at 10:49=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
[...]
>> Previously such operations will revert to inode flags 0, but now it wil=
l
>> revert to inode flags NODATASUM.
>> This is due to the fact that we have no way to change NODATASUM flag bu=
t
>> only through mount options.
>>
>> I know this is not ideal, but at least "chattr +S" removing unrelated
>> flags looks more serious and more like a bug.
>>
>> So here I'm fine to slightly change the behavior of "chattr -C".
>=20
> I'm not sure what's best here or how common this use case is and I
> wonder how it might affect users.
> I agree it's better to not remove the nodatasum flag, the only concern
> is if it affects existing user workflows.

I doubt if it will affect any existing user workflows, at least not=20
directly.

But the biggest one is no way to remove NODATASUM flags.

This means those files will never be verified by scrub, which will=20
eventually affect existing btrfs maintenance.


I'm wondering if it makes more sense, to only set NODATASUM if the=20
current mount option has nodatasum.

This will fix the test case but also provide a way to keep the existing=20
full revert behavior.

Thanks,
Qu

> I can only guess it's very rare.
>=20
>>
>> Fixes: 7e97b8daf634 ("btrfs: allow setting NOCOW for a zero sized file =
via ioctl")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/ioctl.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index d4981d2a42d7..74849a4208b5 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -336,8 +336,7 @@ int btrfs_fileattr_set(struct mnt_idmap *idmap,
>>                   */
>>                  if (S_ISREG(inode->vfs_inode.i_mode)) {
>>                          if (inode->vfs_inode.i_size =3D=3D 0)
>> -                               inode_flags &=3D ~(BTRFS_INODE_NODATACO=
W |
>> -                                                BTRFS_INODE_NODATASUM)=
;
>> +                               inode_flags &=3D ~BTRFS_INODE_NODATACOW=
;
>>                  } else {
>>                          inode_flags &=3D ~BTRFS_INODE_NODATACOW;
>>                  }
>=20
> This can now be simplified:
>=20
> if (!S_ISREG(inode->vfs_inode.i_mode) || inode->vfs_inode.i_size =3D=3D =
0)
>      inode_flags &=3D ~BTRFS_INODE_NODATACOW;
>=20
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>=20
> Thanks.
>=20
>> --
>> 2.54.0
>>
>>
>=20

