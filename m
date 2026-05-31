Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AFA126BF1
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780267734; cv=none; b=CAxArYjqYRwyO9QTja2iu+trQAqr6MR5d04piGtC90nXOh0Ysbd7uJX03MtfW5Vk+I57Z4BvFr4XE2ZbtLTevTsBQYySShi+fymNe9qaPzO05rtBuoDyXN1jfBNaaNS+W9ld61Lwze+jQm9NkUQc5kUBuzaoYS5V1SOnwyxqYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780267734; c=relaxed/simple;
	bh=TXJOn71490yJq0gX9MiTmQTF1zPFCLlIf8hjS8oumVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p6je9Hzus4W8BfjXbYGWKEROhi05YeuPoKiz7wsxHt7zfaKREfAlqRy9colaoDCrJ45VbaDk5RQQwc2jC3ZLkgYcFA90nfm3yv6dINQM/Z0ZmvIcFVgmlwyXozjVGuWcJhSC2H36bGMpwhinIl+TFVo3lhZFwp0Sz1He2AtomuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=srNMalR9; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="srNMalR9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780267730; x=1780872530; i=quwenruo.btrfs@gmx.com;
	bh=wtiXihVfPpppTRlwlxdAdXZceBqqAlcOkdcZx76ko5Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=srNMalR95ic4SGAqvKl7BXpogJnExwU2ncAOjmIE4+hvPm4DhMXZxY5V4O/fK9O1
	 K+T7/1mYaJHn/ry4NjkZ7c7Jyqse37xT0tOgD9+gxKZUwqB/asjn1jQMH6fj3M6ET
	 uuevPUUeBp7dfoOG7wICCP0eGjMEGh/VrA1r7GzoCmzZICSyMtCfVFOagGZYMfFkV
	 +yWPqdEmRR4NGSkGeOi3W+I50KejJyY7IdzN+/Gk1UwFOFjL7KyYgQgARtUSR203y
	 VjOIiGSW7e/GE1dPRt6jeXyS6mctW0I9ifLGHlr/GFXNK0kM3w5vAMyKyfSzwDhPn
	 8qCg1q6vluCeqT7tYw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MoO6M-1x51Kc0Ybw-00bGfC; Mon, 01
 Jun 2026 00:48:50 +0200
Message-ID: <abdefca9-5e72-4f63-bc7d-958b9ec50468@gmx.com>
Date: Mon, 1 Jun 2026 08:18:47 +0930
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
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
 <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
 <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
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
In-Reply-To: <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QEMCfg102SpLsdCQVosahz30kTA8n2ZO3IHvPlHIQkTzY8fgsLX
 ej04TXG7QVy6/tO8VW/lpgsmq3RM7iKgY2IR8jcbMMvwdcN0+Az7FfK46HVOnsnvepKlEam
 SeKAirFY/f7dbEijUSPQoJx6oSAf4tLlBaQwDxQecBTjVWv2Zi+QHaaQUQe1S0mp8/5IiRZ
 tUfELrLAg7PvOvsfZBs+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jaT4OsY0TB4=;TD8pVfH4wPtX+2/ttLJqfFdqCM4
 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
 a+D5Uw==



=E5=9C=A8 2026/6/1 04:18, Michael Zacherl =E5=86=99=E9=81=93:
>=20
>=20
>> On 31.05.2026, at 10:27, Qu Wenruo <wqu@suse.com> wrote:
>>
>>> [4/8] checking free space tree
>>> Space key logical 1048576 length 4194304 has no corresponding block gr=
oup
>>> Space key logical 5242880 length 8388608 has no corresponding block gr=
oup
>>
>> This is a bug introduced in mkfs.btrfs, and fortunately it should not c=
ause anything wrong.
>> You can completely ignore it.
>=20
> Is this valid for any "Space key logical =E2=80=A6 has no corresponding =
block group=E2=80=9C warning?

Not for any one, but those specific ones. The common patterns are:

- The logical are pretty low (<10M)

- The logical bytenr starts at 1M

Those are all temporary chunks created by mkfs.btrfs, and later deleted.=
=20
But the free space tree entries are not.

The latest upstream kernel (v7.0) will automatically fix them at the=20
first RW mount.

>=20
>> With that said, your fs has nothing wrong, except the csum mismatch.
>>
>> Sorry, I have no clue how such corruption happened at all.
>=20
> I had a look at the underlying SSD.
> The number of unsafe shutdowns is IMO rather high.
> I suspect the notebook=E2=80=99s power management in combination with Li=
nux is a problem.
> Quite a few times the OS didn=E2=80=99t manage to finish writing the hib=
ernation image once the battery was depleted.
> Resulting in a hard shutdown and/or an unreadable hibernation image.
> How this may correlate with a corrupted config-file which is basically o=
nly read I don=E2=80=99t know.

In theory, as long as the ssd/firmware/controller properly respect=20
FUA/FLUSH commands, it should not cause any corruption.

But we live in the real world, sometimes bugs can sneak in between (and=20
include) btrfs and lower storage stack.

Thanks,
Qu

>=20
> Available Spare:                    100%
> Available Spare Threshold:          10%
> Percentage Used:                    0%
> Data Units Read:                    132,882,223 [68.0 TB]
> Data Units Written:                 49,545,231 [25.3 TB]
> Host Read Commands:                 763,229,890
> Host Write Commands:                1,041,806,327
> Controller Busy Time:               2,205
> Power Cycles:                       5,029
> Power On Hours:                     837
> Unsafe Shutdowns:                   336
> Media and Data Integrity Errors:    0
> Error Information Log Entries:      12,792
>=20
> However, I=E2=80=99ll bring the system back to normal operation and have=
 a closer eye on the fs and SSD.
>=20
> Many thanks,
>    Michael.
>=20
>> At least the corrupted gai.conf fail should be able to restored by re-i=
nstalling glibc package.
>=20
>=20
>=20

