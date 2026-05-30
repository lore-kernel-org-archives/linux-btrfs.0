Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3A013DDAE
	for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2026 21:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780176232; cv=none; b=S18lj0jBGr8pEpA7W2WoJ3+ArOQYgYQYrvVDv/6Bmp58Pvi5poKN1KeebR/mGE8wbwuBWqZUcvd1v0CQM9PpV2dmKUm/3LHU2+36SFu0XpQR26+Si6tGzIzFlvWuKkNwhd1AJFyj7rF97E7TRde2DT7Pkw0KaOZikljO/qhsrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780176232; c=relaxed/simple;
	bh=G+GOu1OVBEdzN1/16BCoSIs8LzK8WVnv+hsRaCPvj3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S+HtEXMP0XaNnhpgvhivs3ON9kpxRv0ZahtgiF5AV3/l/9CKIT4cAlAMbcIURgQAQEykU5P1XDD0mMNimU8I6aVDVMn+CFbtLQKY4Cu3ljgALKKlBl8vjTOKNxk2Viq0gbfw5+eEVo6piNyvKKICh+je9Eru2TwtpZQKduEuakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=FbCkCgmm; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="FbCkCgmm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780176228; x=1780781028; i=quwenruo.btrfs@gmx.com;
	bh=shcK/VscL9eV90J3tCHkvo3qsr7B6sN3AFlqJLE3Y9Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FbCkCgmmGwEalZaJ/JQir92/+pnqIhY0hU86A6JnPfY0N8VvyalV/VfZh8j3PeLb
	 9mSYCY3BmW8wLgLuoVAZBXp9S48LihYZHVrzFKsaM+KEaKyoKIGKzPkw26wt6R6cF
	 XB6E8TyN6m2prZiQsSaKKJJK7JQrtu5h/vb3JXM8Sot6Pu9q7Qevb2A9NXCekl5Vz
	 wJITTPlcUhV/WOrRDiIEFJjUFoeWN1jI0eWHQEHEW63RPtiVCLI18cY9t0aeoAkZK
	 rJBL/vGfMPlWzmTXPGB5SqvTHNOq+22jIoEhgFFMvIE2ByB1cwxnbkSLqM76fF2FS
	 A0HEtE6OrywtR+WirQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M5fMY-1wMHUX2bAg-0013yu; Sat, 30
 May 2026 23:23:48 +0200
Message-ID: <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
Date: Sun, 31 May 2026 06:53:44 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
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
In-Reply-To: <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6vMXROCohztspk2cITADlaz0EvSXZlrAEfjmjjJ8a4SlZkHOzQd
 eHKevYW8nsbG8OeCEyEI34xjHeoJY1YkGpzKm9eDsO+fnKmwgQtULeKbZTIThIQU17wnpsq
 no8O6cRVp9aP3aLbMCrXeGktLsWEKS32WjmW8xrFTHlctC/D0ilHVFl/wVfApDMzu3AHz5s
 U4mHAtPi9Jyj3SZyxkwJg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:c8qaKvQEFTA=;DlqmdAmfNDzB2tQdEPyohTG3kwr
 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



=E5=9C=A8 2026/5/31 00:51, Michael Zacherl =E5=86=99=E9=81=93:
> Thank you very much for your super-swift response and action!
>=20
> I safely could remove two files which indeed decreased the error count.
> However, there=E2=80=99s still one uncorrectable error left which I don=
=E2=80=99t know how to tackle.
>=20
> Scrub=E2=80=99s output:
>=20
> $ sudo btrfs scrub start -B /mnt
> Starting scrub on devid 1
> scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
> Scrub started:    Sat May 30 12:42:56 2026
> Status:           finished
> Duration:         0:10:29
> Total to scrub:   912.31GiB
> Rate:             1.45GiB/s
> Error summary:    csum=3D1
>    Corrected:      0
>    Uncorrectable:  1
>    Unverified:     0
> ERROR: there are 1 uncorrectable errors
>=20
> Associated log output:
>=20
> May 30 12:42:56 EndeavourOS kernel: BTRFS info (device dm-0): scrub: sta=
rted on devid 1
> May 30 12:42:56 EndeavourOS kernel: BTRFS error (device dm-0): scrub: un=
able to fixup (regular) error at logical 20316160 on dev /dev/mapper/crypt=
root
>   physical 20316160
> May 30 12:42:56 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5327, gen 0
> =E2=80=A6
> May 30 12:53:25 EndeavourOS kernel: BTRFS info (device dm-0): scrub: fin=
ished on devid 1 with status: 0
>=20
> Also, since the fs is not live I na=C3=AFvely ran a  cat file >/dev/null=
 over all sub-volumes and a third file (/etc/gai.conf) threw an Input/Outp=
ut error.
> This seems to correlate with another log entry (inode matches):
>=20
> May 30 15:10:04 EndeavourOS kernel: BTRFS warning (device dm-0): csum fa=
iled root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 =
mirr
> or 1
> May 30 15:10:04 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5328, gen 0
>=20
> This file is completely unreadable.

Even with "ro,rescue=3Didatacsums" you still can not read that file?

That file should be a human readable text configure file for getaddrinfo.

If you have not yet deleted that file, mind to take a copy of that file=20
with "ro,rescue=3Didatacsums"?

I'm interested in how the corruption looks like, normally it shouldn't=20
be modified unless it's updated by the package manager.

> Is there a correlation to the scrub error?

You can always use "btrfs logical-resolve -o 20316160 <mnt>" to resolve=20
the logical bytenr to a file path, to confirm if that's the culprit.

But overall, your "cat file > /dev/null" also works.

Thanks,
Qu

>=20
> Thanks again, Michael.
>=20
>> On 30.05.2026, at 03:03, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> =E5=9C=A8 2026/5/30 09:49, Michael Zacherl =E5=86=99=E9=81=93:
>>> Hello, I did a routine scrub on the offline root fs of a notebook (End=
eavourOS, Arch based).
>>> This is the output:
>>> $ sudo btrfs scrub start -B /mnt
>>> Starting scrub on devid 1
>>> scrub done for 44cb181f-faf6-48c2-a462-904cfe493576
>>> Scrub started:    Fri May 29 23:54:53 2026
>>> Status:           finished
>>> Duration:         0:10:23
>>> Total to scrub:   911.45GiB
>>> Rate:             1.46GiB/s
>>> Error summary:    csum=3D18
>>>    Corrected:      0
>>>    Uncorrectable:  18
>>>    Unverified:     0
>>> ERROR: there are 1 uncorrectable errors
>>> Last line vs. "Uncorrectable:  18=E2=80=9D ..
>>
>> Indeed it's confusing. Will update the message.
>>
>> In fact the "1" is only accounting for how many device(s) have uncorrec=
table errors.
>>
>> So the more correct one should be "there are 1 device(s) with uncorrect=
able errors".
>>
>>> How would I deal with that?
>>
>> Check the dmesg, it should contain the file path of the bad blocks wher=
e it belongs to.
>>
>> And if that file is not important, you can just delete it.
>>
>> If it's important, you can verify how bad the damage is, by going
>> "ro,rescue=3Didatacsums" and read out the affected file, manually check
>> how damaged they are.
>>
>> Thanks,
>> Qu
>=20
>=20
>=20

