Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778342E719B;
	Sat, 17 Oct 2026 08:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792224273; cv=none; b=sPhOmVwKFDzYMkp6Mq6r3TItWVFjO8sh5RUoOqxudYyvN0eFvBi2acyP5oYUFXpL96xhkTMKpltr8hO8KEMlcTQufPGTufu/iuEEv+lfuLJXB8dJhY6T/PCYR4qhaRW/7oUogpQ4kMX8sB0wBkVS9MKTX9OJZqDjb4adt1vqvwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792224273; c=relaxed/simple;
	bh=udCvdcBMD/CA9fRRo/L5+21AJX/IZFhFGTfhr9m0FlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGoyWMrYwmcpsF2rWwu+9lY4dU2U3jFumTTTVf8Kk6W/vigcNNn/u5rpd3L+kq1D3v0iunDrpButSOUvNueYzw7PxbhXNrTZaNvC93gbFdrV4+FF+PkwCNy5jE9V7ydaNKyeisbY9+9qC0ij3R6FLT54FYarV5Dtl3MfHcAdEzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=UYkXKN+m; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="UYkXKN+m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1792224265; x=1792829065; i=quwenruo.btrfs@gmx.com;
	bh=CzbuP6/eRC6qKj/ro6et9UJyKC61bAnXSNeNPNNW2lQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=UYkXKN+mENztzFj/WDd0LmYEtS2G1J5Z+T2WqsTSup0VksjU7GbSBL0iqOhBaMOI
	 qdcl+W0LJQZTDbJDDW/nRTQT11pzNFRqLthYAet5izVk7WFvh6PvQwRkBLbAq6SOM
	 ZPyVc65YYl3W1BB/P7+e1CRuzvWPO4s3HUAIcnDG2f7XkQxs0tMR8rL1e2XqN5hcc
	 Y13aRuMqvEeaUlUuTZvQykfoAJxyutiHyWoXCNACdJOIKvUbZ251GKV+vL5btTK6l
	 qI4A++Us+DkzQy3/ym1rH7tcqvbq8D+tiejy/cTbxkyJZiPsjMlNHF7/Oflucfii7
	 GFnp8mBme9tKbpIjhQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Ma24y-1x5wD64Acu-00YSQM; Sat, 17
 Oct 2026 10:04:25 +0200
Message-ID: <d14727e2-04f3-4603-8b76-8621f0d9e58e@gmx.com>
Date: Sat, 17 Oct 2026 18:34:21 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] fstests: generic: add a test case to check fsverity
 reads
To: Eric Biggers <ebiggers@kernel.org>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20261011222613.10793-1-wqu@suse.com> <20261016074756.GD3049@sol>
 <eac493e2-8bd6-4584-bd90-7601a210f802@suse.com> <20261016082422.GA1894@sol>
 <4cafa46b-2bdc-4a91-9f33-85d4cb5f9357@gmx.com> <20261017040550.GB29318@sol>
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
In-Reply-To: <20261017040550.GB29318@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RnwrafWlDXoYXqF9e8Nr39gkPYIQxtu9esXr3eacYFQ7AOI5QwW
 QkJB053GbRohviWCiZXqxh19uL71Fvaznos0zq3xZ//rv1Zz9amBSsf62fafxnXJHCflcXX
 cBEUgqtoYDtSBbw2vvb3+w+q5naLDDS4hFSVOZiHH1RiBZmSC/hisln/WtwMN/LyiI0e/D3
 s/KC/os/+lRRAFY9w9NKA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8os4qgGEIkc=;OoUoSwxYt0ochH59yA5v2IeiIE6
 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



=E5=9C=A8 2026/10/17 14:35, Eric Biggers =E5=86=99=E9=81=93:
> On Fri, Oct 16, 2026 at 07:24:32PM +1030, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/10/16 18:54, Eric Biggers =E5=86=99=E9=81=93:
>>> On Fri, Oct 16, 2026 at 06:35:05PM +1030, Qu Wenruo wrote:
>>>>
>>>>
>>>> =E5=9C=A8 2026/10/16 18:17, Eric Biggers =E5=86=99=E9=81=93:
>>>>> On Mon, Oct 12, 2026 at 08:56:13AM +1030, Qu Wenruo wrote:
>>>>>> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
>>>>>> +	"btrfs: fix the fsverity callback where unexpected range is verif=
ied"
>>>>>
>>>>> Even without that commit, 'kvm-xfstests -c btrfs generic/807' still
>>>>> passes.  Under what circumstances will this test fail?
>>>>
>>>> It need as least 7.2 upstream, which enables large data folios for bt=
rfs by
>>>> default.
>>>>
>>>> And I can always reproduce it here, mind to provide more info about t=
he
>>>> passed run?
>>>
>>> This is on the latest mainline (2f2f7eeef8b0).  Not sure what else
>>> you're looking for.
>>
>> It can be racy, since the fsverity call is at endio time, if all the en=
dio
>> of the same large folio is called after all the reads of the folio fini=
shed,
>> it can also pass the verification.
>>
>> But I don't think it's that possible, unless you have blazing fast stor=
age.
>> As the first hole read should trigger the verification for the whole fo=
lio
>> and trigger an fsverity error immediately.
>>
>> I can enlarge the file size, or even git it a loop to run multiple time=
s,
>> but I just can't figure out why...
>>
>> Or is it possible that the kernel config doesn't have
>> CONFIG_TRANSPARENT_HUGEPAGE?
>=20
> Indeed, I didn't have CONFIG_TRANSPARENT_HUGEPAGE enabled.  Enabling it
> makes the test fail as expected.  Maybe would be helpful to mention that
> prerequisite in a comment in the test.

Sure, I'll address all the comments in the next update.

Although for the fserror reporting part, btrfs doesn't support the full=20
fserror yet.
So I'm afraid the test will rely on the dmesg part for error detection=20
for now.

Thanks,
Qu
>=20
> - Eric

