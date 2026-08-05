Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F81C3CA4BB;
	Wed,  5 Aug 2026 21:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964760; cv=none; b=V3TD9EzoSR/tX/o96nrlhbWav8NjrG9t+zDcZoQRc/LSz8bE6hjjD8V0Yz7huSQY5fYXDTQiqQQttNq0HwOnyxzYX4ql9MDpL+4vYnOGIQdSIVdFBN/FmKZFaUCPJLDWhuM1z5AxziUkYXRTz1LUAD0aQ94yKOHrPRdSAA4q6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964760; c=relaxed/simple;
	bh=Ru36TqtP/PJo7nyLrf1jSV34ErLA+hJ5vn4RYYIzhAs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Z42SIluWB+F2swMOuwoAT2Ukeq85GSgVljk4mOagEsRKZ8f1kITjxNdklVtVnDif/zK/OmUjPxntWWmuxVdVBRNA2K1Ouu4sb1l3Wzw7FqKDwOXRO01NmkfGhckxCCXg/IVHIqji+/Odp7zGX8tuHjvNemBMtKx1g9oIms2wn8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Js0LLs8i; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Js0LLs8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785964748; x=1786569548; i=quwenruo.btrfs@gmx.com;
	bh=eTF+Jx4vQ2Ce0X+ItS/voOBVnQQyerYWSqD6TSyFZYA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Js0LLs8im7gBqV/ujCXq1fFF7BZgffFgOYg4J093NV23mqbi3aNu6PDeqaRHwFfd
	 9gHPePUuG8k9plfpn2pxZpBbzEJDFFBQrjz08fROktRC+ofL5fMEJ35vjr4qUtlfJ
	 K1moW8cpNz7hDjTzWEQYy9rp7cXa5/DOeFaV2PjfUNzprAd0qWHeWbC3r0KsjHm+Y
	 tLpjKxoIudACNylsPnSPIO1/HuuGyX+h30UeLDCLj2ZzhRb7o9S7j0XiNQyICuwqu
	 KbZRlzXjeKqDq1e46XtnOb0wOxTts2Zckz9oj2oPoxmpDorPD/6anYrSZPHbGE1M3
	 T+2yjJ+rxd4kH5G0ww==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MaJ3t-1wNoD312hB-00JuSK; Wed, 05
 Aug 2026 23:19:08 +0200
Message-ID: <61ade7aa-0471-48bb-998f-9dbb76d96cec@gmx.com>
Date: Thu, 6 Aug 2026 06:49:04 +0930
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
 <3d4d0167-8acb-44bd-9224-78561ddae4bb@gmx.com>
 <anNFEruUSvQ9Xh5r@zlang-mailbox>
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
In-Reply-To: <anNFEruUSvQ9Xh5r@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VnB6zZHjv7IYyl4Bg2K/RUF84seKsQHBJbI1E5evCIKQ3OHQH6x
 UQXjwJFWJbS0/LgPq0DWGWbRjRBD3GA78R4BKPP8DBfElSkZOEfW05YDWpezkwJI/qGwyL0
 lp400j2W9NNVUUWUgjPvrI0jLm+62U5M22/4sfsRqLBRH5skM/cbMnUWrSzFVoFFOgKQi94
 lUPWa/NB8cIKb/wrMNrEw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ynLLB+19Af0=;+RI8bbxfhhUDZ7m/EENVBIGDMm+
 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
 vxNwKRQ==



=E5=9C=A8 2026/8/6 00:25, Zorro Lang =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 09:11:24AM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/8/3 20:05, Zorro Lang =E5=86=99=E9=81=93:
>>> On Sat, Jul 25, 2026 at 08:37:24PM +0930, Qu Wenruo wrote:
>>>> There is a report that on btrfs, if the following workload are runnin=
g,
>>>> btrfs can fail:
>>>>
>>>> - A dio read into a mmaped range
>>>>     Only the mmap range needs to be on btrfs.
>>>>     The dio read source makes no difference.
>>>>
>>>> - Sync_range on the mapped range
>>>>
>>>> The btrfs errors include:
>>>>
>>>> - Hang during data writeback
>>>> - Filesystem flips RO
>>>>
>>>> The mmap range is dirtied but written back by the sync_range process,
>>>> then dio read finished and found that the folios are no longer dirty,
>>>> so dio endio will mark those folios dirty again so that the fs can wr=
ite
>>>> them back again.
>>>>
>>>> However for non-experimental btrfs with 4K block size and 4K page siz=
e,
>>>> there is a regression in v7.2 that such case is no longer handled
>>>> properly, due to the enablement of large folios and removal of cow
>>>> fixup.
>>>> And btrfs can never handle it for bs < ps from day 1.
>>>>
>>>> Add a regression test for it.
>>>>
>>>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>>>> Link: https://lore.kernel.org/linux-btrfs/20260721191152.101118-1-bor=
ntraeger@linux.ibm.com/
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>
>>> Hi Wenruo,
>>>
>>> Thanks for this new test!
>>
>> Thanks for the review. Will update the patch to address all the comment=
s and
>> refresh the test number.
>>
>> But one comment inlined below.
>>
>>>> +
>>>> +kill "$read_pid" "$sync_pid" &> /dev/null
>>>
>>> How about:
>>>     kill -TERM -"$read_pid" -"$sync_pid" &> /dev/null
>>> ?
>>>
>>> As the (man 1 kill) says:
>>>
>>>     pid
>>>       Each pid can be expressed in one of the following ways:
>>>       ...
>>>       -n
>>>          where n is larger than 1. All processes in process group n ar=
e signaled.
>>>          When an argument of the form '-n' is given, and it is meant t=
o denote a
>>>          process group, either a signal must be specified first, or th=
e argument
>>>          must be preceded by a '--' option, otherwise it will be taken=
 as the
>>>          signal to send.
>>>
>>> I didn't give it a try, but I think this might help to kill the
>>> dio-read-into-mmap and sync_range process too.
>>
>> Unfortunately this doesn't seems to work.
>>
>> If I removed the redirection, it shows the following error:
>>
>> /home/adam/xfstests/tests/generic/801: line 76: kill: (-1271) - No such
>> process
>> /home/adam/xfstests/tests/generic/801: line 76: kill: (-1272) - No such
>> process
>>
>> Thus it will not really kill the children processes.
>>
>> Despite this change, all other comments will be addressed.
>=20
> Hi Wenruo,
>=20
> Sorry for the confusion! I assumed that approach would work, but from th=
e
> error message, it seems running "read_workload &" doesn't create a prope=
r
> Process Group (PGID).
>=20
> How about this approach instead?
>=20
> 1) kill -TERM "$read_pid" 2>/dev/null
>=20
> Based on the trap in read_workload(), it should enter "wait" upon receiv=
ing
> SIGTERM, preventing any new iterations of the loop. Then we can run:
>=20
> 2) pkill -P "$read_pid" 2>/dev/null
>=20
> to clean up any remaining child processes, followed by a wait for the ma=
in
> process to exit.

Not sure if pkill is really needed, as the last wait will handle it well.


So in short, the existing

kill "$pid"
wait "$pid"
unset pid

is good enough, that's what I did in the v2.

Although the child processes still need to trap the corresponding=20
signals, which is also done in v2.

Finally I have already tested the signal interruption for v2 several=20
times, it all properly catch the signal and terminate the children=20
processes and the main script without any delay.

So I think the one used in v2 is working properly.

Thanks,
Qu
>=20
> 3) wait "$read_pid"
>     unset read_pid
>=20
> (We can wrap this logic in a function and invoke it inside _cleanup)
>=20
> I hope this can prevent the script from waiting long time, and no orphan=
ed
> processes are left behind. Feel free to tell me if anyone has better ide=
a :)
>=20
> Thanks,
> Zorro
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>> (same in _cleanup)
>>>
>>>> +unset "$read_pid" "$sync_pid"
>>>
>>> unset read_pid sync_pid
>>>
>>>> +wait
>>>> +
>>>> +echo "Silence is golden"
>>>> +_exit 0
>>>> diff --git a/tests/generic/799.out b/tests/generic/799.out
>>>> new file mode 100644
>>>> index 00000000..f3fd9fa2
>>>> --- /dev/null
>>>> +++ b/tests/generic/799.out
>>>> @@ -0,0 +1,2 @@
>>>> +QA output created by 799
>>>> +Silence is golden
>>>> --=20
>>>> 2.51.2
>>>>
>>>>
>>>
>>
>>
>=20

