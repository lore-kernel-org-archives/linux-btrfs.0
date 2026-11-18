Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.22
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034016;
	b=3R8Z7dH+Qzd5MjEnqzBh8YDfTJXWGETNsXmVwiv5olbAjvNvRI8kQkq7+8yYthuWQN1u
	 7bfCmma30xnNGd/6CIvrVNP/RU6H0YiAWYQ7PRysXmmq3i9TWbuCjgUvbqZUA/AmgHrSk
	 JKCYEq0prDZMHg9wb1tUsBLYuCi5653NDt0m3u+8sV5X+9CcOz84jDg9XrdNFCpbwjBTR
	 XsHdKu3/NhTx6+kSuPvRs7kQfLKnk7v/AKiwEti+CnmwHdA8Mdi0x7uJsIsFOi9GVEI6R
	 RFH9r1ionphNiHy589tWOV+gUv0Ny/7Dkl7s+zw39gcGwl5Y3j8OUovwQnOTTdoU+RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034016;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=aD8/6A9Iu1ACzkELqlK8/FVNHKftTQO0qljY4nRsAeI=;
	b=MH6/ZIOZD5wsEmUPG8SkyPSBQKnN10Zgy+UUWJDuVT2qt9HKj4S9DrgNUlxt9hunhUwq
	 Qlg1l3lZDg+F6GIBRTuXwa66lub6u/uFTvDdLSpxVlN+VhOF6WbWBk6M9nLN0gTY7VMwd
	 Eu9DD1SM1tUb3Hm8jJvh9n4DRDwShhYpVdbjiUmA2c0iA/c/ChUKX8lCSx+e5aII/DOkz
	 2abwle1ZDbHefnxniWQa+D9BDj++lAAp+HuGRGt33dCE5XE3qe0KOYloffFkFX1y4F7+w
	 tBJaa0NgGWek6xT4Eg7pM717P4MfddT44Qy69W7UJvm8/WD6NETiXDZZWbl0XqDewRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=PQfzVLzP;
	arc=none smtp.remote-ip=212.227.17.22
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF70E606A320
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 20:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF70E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=PQfzVLzP
DKIM2-Signature:  i=1; m=1; t=1795034013;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:mYeo4xe/DwZvTZAeyxFFFKCYO8RG
   DNcxrbw0+tgbI3CTfKdLnr1Xa8aisa1UzNR03qn9Yo/jVXjmCQpGPTCtnksuvL44HY1kpcUuG1U
   4G7jvBUgoWmX3gqoIwL2PGK2t2pZSETqlPLU/GpB9FNygbgRGQdF1IjDMEVnHG7sdoXdT9dTXji
   rBU1+FzJz8Mm/yJe6trCIQBdbkhRhjvVFdnKR94wbETxDEdLYdh/RGszO1ohoXecdIH3WwuTyLZ
   S4yjn/xgRRCUyCD4bbhs6W2acWhpDaIG6veZeu+N1B95FDVTHqnySv+tHJshvAjyXjnC6o7jQnB
   j5lxmQ30yv41FQ==;
Message-Instance:  m=1;
 h=sha256:
   DyWETmkbPnPJ3CvgNPKkcyDRhVsoWOXASJqiyqYn4u8=:
   aD8/6A9Iu1ACzkELqlK8/FVNHKftTQO0qljY4nRsAeI=,
  sha512:
   KfNkNw0O25UZwJiOiWj3dwCdfU8OkRvDpWUMHXoUuzOKpYTNsWuGHjipER1bBNlleINDls+DT/CySbbCNanU8A==:
   9BOkBPvGm8NLOxuBgZzrD78/PXfAqdeWmevQScrWaclWk0jiFCiAuENjgJsHlgLIpiE8R27RzgUypcvjEJdhag==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795034006; x=1795638806; i=quwenruo.btrfs@gmx.com;
	bh=aD8/6A9Iu1ACzkELqlK8/FVNHKftTQO0qljY4nRsAeI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=PQfzVLzPB3N40y+3jVUl1V21bDqxIqW91AzWkuiFIYgjBEfgn6XVVJFSXE0HB/0x
	 sdyUN9KfwsPQuEfbzY6DGNLpQnamQgDdvN5FEGVVKey7wjzXI2ccr8bTlh1T1VRvc
	 dbCR1mxbKKpr/z+rqRoNTptS3P3kWN4NKZc6TSKdVSWjgt2GbROJN0hrykkEtF+xt
	 66nPk7CfOHlhU8kTjNAlYWcZZ4+CO8R5jZIeGsUXvpjfNVG08sTLFsH/Q0/qA034H
	 CDpUJMLr6TDRYvd6aDUs1yqqs615PqIryA6IVgTeT7o8O1QLjPZ24qQc5/4YIjVI8
	 O81/M/Jr8IXz09U/mA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MSKy8-1x1H931sRE-00UEWb; Wed, 18
 Nov 2026 21:33:25 +0100
Message-ID: <7eaf139b-12ef-41bd-b6b8-49fc62745f11@gmx.com>
Date: Thu, 19 Nov 2026 07:03:18 +1030
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
Subject: Re: [PATCH 0/8] btrfs: assemble a multi-device root filesystem
 without an initrd
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261116224316.11237-10-ismael@iodev.co.uk>
 <fc1f9f58-71ad-410e-bf03-8b27e607ab76@suse.com>
 <20261117183643.36afff2b@pirotess>
 <ce9f04e8-a5e6-478b-acf7-e2ad56e0c456@gmx.com>
 <20261118130742.4378354e@pirotess>
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
In-Reply-To: <20261118130742.4378354e@pirotess>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0T0hbeWNBhS7Owxve2f6gsBQYy0hhribNgamlo5xa5vPOQVojfJ
 x20nGB6EuXye28IbPVIfKwEQKB1Mw+8rhGUSeexMiqHuW+rpMl+AfbaCa7lG7pMA7P8Rn4H
 vqjNbjTOebrc8FqwZTrMYX5Fm7Z4Ov82ReaHnTEKORGEYhJcafhbnKXsG+rmp488XkTCShJ
 XYjZjae7bliFhrXZWi2eA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jknV6ukV4Sw=;rYWUiJEN6xb0qcWDj3bW2jFHS4D
 +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
 Q==



=E5=9C=A8 2026/11/18 22:37, Ismael Luceno =E5=86=99=E9=81=93:
> On Wed, 18 Nov 2026 06:30:31 +1030
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> =E5=9C=A8 2026/11/18 04:06, Ismael Luceno =E5=86=99=E9=81=93:
>>> On Tue, 17 Nov 2026 10:11:46 +1030
>>> Qu Wenruo <wqu@suse.com> wrote:
>>>> =E5=9C=A8 2026/11/17 09:13, Ismael Luceno =E5=86=99=E9=81=93:
>>>>> A multi-device btrfs root filesystem is normally assembled by the
>>>>> device scanner that an initrd runs before mounting the root.
>>>>
>>>> What is the problem here?
>>>>
>>>> Is generating an initramfs really that complex?
>>>
>>> Why depend on an initramfs?
>>
>> Why not? One should not put everything into kernel.
>>
>> E.g. what if the customer has some custom udev rules for devices
>> names? Now they can not use the custom devices names during boot,
>> which they can before.
>>
>> Shouldn't this count as a regression?
>=20
> I don't think that's a possibility since the initramfs takes precedence,
> everything would follow the same sequence as before the patch.
>=20
> If anything it makes the boot process more consistent and enables
> migrating initramfs-less systems to a multi-device setup without
> changes to the boot process, which was my main goal (unfortunately all
> the generators produce bloated initramfs', and I didn't want to
> introduce yet another implementation just for this, plus it would be
> slower anyway).

I don't think it's even a good idea to put every workload in the kernel.

And personally speaking, I don't think the busy-box based mkinitcpio is=20
that bloated nor slow, even with all LVM/cryptosetup included.

This is not a small change, but the benefit looks very limited, thus a=20
strong argument is needed to push for this.
