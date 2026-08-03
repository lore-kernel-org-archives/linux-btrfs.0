Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C73394798;
	Mon,  3 Aug 2026 23:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785800495; cv=none; b=dQuEzXsKDIjlEfcY8ybDBzV0WqpkJ74ZsgZ/JYQajJfu+Aa8KzE7JWvWgY2roJx4p+ykw7j8PMi1A1mNbKhtKE/lGeSAJQrJ8t1Vb3h8vU4hdEWxNyXjVQlR12TRL5PAfhAi0N678a3YbF4l/63qrRTXyvv3vRAi7wzRrfqzw4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785800495; c=relaxed/simple;
	bh=fgBnw8klM7SzPZWMR3W1ChKVbOVzq99aNaLSSo3X8ZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ETwVpgEgJAoZsr1PMoqAdKqaLMVM4TGygKWnRhBDmtOWN3Grgr+lp1bVNO2MmM8mTpkLPdV5gB0UHxYyHCXbTxkZfsAXsQPza0RuXcbTMCe9LPuxwKwr4jzjPDJZxH+SW3CJhCHJ4cP1uAKFpj97oB1IYpDDqPF5f7Zse2u4DxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=MjGY8D5F; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="MjGY8D5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785800487; x=1786405287; i=quwenruo.btrfs@gmx.com;
	bh=wxHH9hWsQDYE8jdC0VNcSifycA4CuD/RaQ7EmukVxeQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MjGY8D5FWutLkGXph8bGTpuIEqnS0xCEbnBB1GUoTgXtY6h6Xuu2WMGCQxCms3TH
	 /M4dFi3gr3DIhMtGY7hM+3BonsJe8AEZPoGjE5FpFkwhqpAfablQPlKxNNUfkVF6a
	 ZyYrLsVMDWDPboWMWEYzLJ1/XKWGdECKMWOWvpGKDFBAtIu+KAMbM4JiswLSo0hpz
	 blZw58j1ykeKUYWbbxqaozef2wAj9E3zuo1uiHH4BXSALGKl082PVpJ5tuqFvJwuT
	 Kt7Cm3flKRHNduVz2gqoyBeTSY/WP7vyABw/sof5n00GiwarDtLdERwtJGUE4xGvw
	 vyC79LTInWe8gVfJrg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MVN6j-1wS2VM19U7-00LuDP; Tue, 04
 Aug 2026 01:41:27 +0200
Message-ID: <3d4d0167-8acb-44bd-9224-78561ddae4bb@gmx.com>
Date: Tue, 4 Aug 2026 09:11:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fstests: add a dio-read-into-mmap and sync race test case
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260725110724.75124-1-wqu@suse.com>
 <anBiV3ta3qe5Kzfo@zlang-mailbox>
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
In-Reply-To: <anBiV3ta3qe5Kzfo@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MSdzq4fWizkMEUh85gg5mrJrtlNERKiDNpjI99HACx5IdSDVDhd
 U/uswiEexciAFDfZRLc9eEy+SBWjw4PBjIm7xf4XGeU8LwgNStjtiTTwxBpYMEta5scbIxP
 /GunoUMq+7jQRxUUQEVwi4OZfvu0P2Kf8iFXjsXqWcFGkPfrSHWrrBT2qkZLIXmCb+4FpbM
 w6pZ5wjh2xfNuTqOEY4Zw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:rvzOtEOSsiA=;Ttzar5iQEFWMIFxOP0rPx5CtKpt
 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



=E5=9C=A8 2026/8/3 20:05, Zorro Lang =E5=86=99=E9=81=93:
> On Sat, Jul 25, 2026 at 08:37:24PM +0930, Qu Wenruo wrote:
>> There is a report that on btrfs, if the following workload are running,
>> btrfs can fail:
>>
>> - A dio read into a mmaped range
>>    Only the mmap range needs to be on btrfs.
>>    The dio read source makes no difference.
>>
>> - Sync_range on the mapped range
>>
>> The btrfs errors include:
>>
>> - Hang during data writeback
>> - Filesystem flips RO
>>
>> The mmap range is dirtied but written back by the sync_range process,
>> then dio read finished and found that the folios are no longer dirty,
>> so dio endio will mark those folios dirty again so that the fs can writ=
e
>> them back again.
>>
>> However for non-experimental btrfs with 4K block size and 4K page size,
>> there is a regression in v7.2 that such case is no longer handled
>> properly, due to the enablement of large folios and removal of cow
>> fixup.
>> And btrfs can never handle it for bs < ps from day 1.
>>
>> Add a regression test for it.
>>
>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-bornt=
raeger@linux.ibm.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>=20
> Hi Wenruo,
>=20
> Thanks for this new test!

Thanks for the review. Will update the patch to address all the comments=
=20
and refresh the test number.

But one comment inlined below.

>> +
>> +kill "$read_pid" "$sync_pid" &> /dev/null
>=20
> How about:
>    kill -TERM -"$read_pid" -"$sync_pid" &> /dev/null
> ?
>=20
> As the (man 1 kill) says:
>=20
>    pid
>      Each pid can be expressed in one of the following ways:
>      ...
>      -n
>         where n is larger than 1. All processes in process group n are s=
ignaled.
>         When an argument of the form '-n' is given, and it is meant to d=
enote a
>         process group, either a signal must be specified first, or the a=
rgument
>         must be preceded by a '--' option, otherwise it will be taken as=
 the
>         signal to send.
>=20
> I didn't give it a try, but I think this might help to kill the
> dio-read-into-mmap and sync_range process too.

Unfortunately this doesn't seems to work.

If I removed the redirection, it shows the following error:

/home/adam/xfstests/tests/generic/801: line 76: kill: (-1271) - No such=20
process
/home/adam/xfstests/tests/generic/801: line 76: kill: (-1272) - No such=20
process

Thus it will not really kill the children processes.

Despite this change, all other comments will be addressed.

Thanks,
Qu

>=20
> (same in _cleanup)
>=20
>> +unset "$read_pid" "$sync_pid"
>=20
> unset read_pid sync_pid
>=20
>> +wait
>> +
>> +echo "Silence is golden"
>> +_exit 0
>> diff --git a/tests/generic/799.out b/tests/generic/799.out
>> new file mode 100644
>> index 00000000..f3fd9fa2
>> --- /dev/null
>> +++ b/tests/generic/799.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 799
>> +Silence is golden
>> --=20
>> 2.51.2
>>
>>
>=20

