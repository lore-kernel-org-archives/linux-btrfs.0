Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919F7312819
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068417; cv=none; b=s2QPqnYqrdsdL8QhPsGMcT34CNbpWbOb+vHtBqBwtVAqAKra27J7XZm0KTAYFHxsnL2+b0KhlNM3rTjWZfIOaa81Tq7z81Z8EtiGzIGeb5HpJMbCIU2sXqftFj4ix1jN04z/zGkx2uv2AgLvyavk2YSXPV+iHP0Z+KBCO80R7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068417; c=relaxed/simple;
	bh=1LktkBydQec/HFS1odyOLDlzRuaZOk+TfeyQ67tC58M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AyJUjInF+OJcpxotBQHyDdyGny1R9gfR4JTJpKVxBTs2k5/wEob59jHDmP9CgNEvXHPDH3s3MfUbht2XURuW63H0IX7n57KiSvlzqGEumRaTfwXw6jS+S0R5NNghfcZhnrrAXxGPj6W5P1TbJg+sGXl2vtev3hHB9oajOu6K25E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=YR+pqnjW; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="YR+pqnjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777068413; x=1777673213; i=quwenruo.btrfs@gmx.com;
	bh=dbKYejqj0cKQNsYV/C2cgLFY3+czpaZs5iZYhTpka0E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YR+pqnjWoRB/OQR4uRU8pabYJZZB9Nq40se3+r4OlvnK68L1LjKZwG7R0Wow9pyW
	 pts7vgJ3JcTbJJP/6RgLdekGPI1Dd+AnhrooOy0rRbLR6b3xUeuVC2u72Ap2y2hqt
	 IfJAKUsIUuZwAh6H6s3AjI0yzQU0f6TNjCdKU4+sMvke91S6odhm5N/M7w84r3vBh
	 nqFfoNlacVj7P76elj3k5mMB5Y8lZdPvtKo9LYmAUhMdSDqL7N0+sZGV4cklqO/HM
	 yYyz3uBfLYMIrofdCOILiNRQtlZDwjlzdTQ4PrImVJ6JjF6yadPiwZuEIfVuwaclm
	 ovdfwSj+Tl3EuF4URg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MUGeB-1vp4Tn3Yf5-00ONmB; Sat, 25
 Apr 2026 00:06:53 +0200
Message-ID: <2dd6a177-b6f5-4c15-976b-7897c6d468dc@gmx.com>
Date: Sat, 25 Apr 2026 07:36:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
 <20260424201054.GA2801466@zen.localdomain>
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
In-Reply-To: <20260424201054.GA2801466@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:biwmdr7OxIGE9PcV55AtWlQzxBNgYN5ZgNvnLsk7R7ZnGSMqCIl
 XQ8+Utvnac2395zpVWTCkQtpJ5pBLPk5hxsSdAUGsrYPpfMT7Dz4O+Na8JYwSaqo1rtk41I
 IkwW28LvsEtBalQy4ZHU8TUqtCzwwLbGYMPXPz44lUoC9L1G+ac47l1bSOG6T8D3Cg0O1k9
 cQTyQVuYip/+WeflNQ6og==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sagi0OXKdmk=;p28ZB6+n1tMCorNDCYpCHkk7rVT
 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
 V2URTpGWjkBw66A==



=E5=9C=A8 2026/4/25 05:41, Boris Burkov =E5=86=99=E9=81=93:
> On Fri, Apr 24, 2026 at 07:37:38PM +0930, Qu Wenruo wrote:
[...]
>>
>> Furthermore, even with this particular patch *reverted*, I'm still seei=
ng
>> generic/224 hitting the same problem.
>>
>> Currently I'm testing at the commit before the whole series, which is
>> "btrfs: abort transaction in do_remap_reloc_trans() on failure", and no
>> generic/224 hang nor 100% kworker CPU usage.
>>
>> Thus I'm afraid the whole series may be involved.

Sorry, at least on my arm64 machine, the first 3 patches are not the=20
root problem.

In fact on v7.0-rc7, I can still hit generic/224 hang, aka kernel=20
detects 120s time out for hung processes, and my VM is configured to=20
reset after such detection.

I'm going to slightly loose the hung task detection time (120s->150s)=20
and check if it's just too slow in this particular case.


Although the last patch is still causing excessive CPU usage here, and=20
very reliably.

>>
>> Thanks,
>> Qu
>>
>=20
> Now that I have had a good chance to try and repro, here is what I have
> seen so far on my desktop x86 machine and a cloud arm machine.
>=20
> x86:
> a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on fai=
lure")
>    consistently done in 1 second
> 8099a837f487 ("btrfs: cap shrink_delalloc iterations to 128M")
>    finishes, but in ~500s
> ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
>    finishes, but in ~500s
>=20
> arm:
> a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on fai=
lure")
>    consistently done in ~300 seconds
> ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
>    done in ~600s
>=20
> The two inconsistencies are that I didn't see it go fast on g/027 with j=
ust
> the shrink_delalloc iterations patch reverted, and I don't have a 2
> second baseline on my arm setup.

At least we got something that both of us can reproduce.

Another thing is, for g/027 on arm64 I'm also actively monitoring the=20
CPU usage through top.

Have you experienced very high (~100%) CPU usage on a kworker during g/027=
?

That's the most reliably symptom on my arm64 systems, and that's the=20
criteria I used to bisect, as it takes less than 5 seconds to determine=20
if it's good or not.

>=20
> So I agree that this patch series effectively breaks those tests, on x86
> as well. I didn't notice the change in runtime, unfortunately, as I only
> looked for success/failure.
>=20
> As to the cause:
> Both g/027 and g/224 are explicitly testing lots of writes to a small
> filesystem.
>=20
> I suspect that what is happening is what Filipe warned about with
> excessive space reclaim/pinning reclaim/etc. choking the workload
> due to excessive reservation. I have played around with reducing the
> reservation sizes in various ways (set it back to 0, set the level
> estimate to 4 as test, etc.) and the result varies from back to full
> speed or a 60s run. So in my setup, at least, it looks like the
> performance of g/027 is very sensitive to how much we reserve.

At least to me, the biggest problem is the 100% CPU usage of the=20
kworker, which indicates a pretty bad dead looping.

>=20
> Would you be willing to let it run for 5-10m to see if you also
> reproduce this behavior?

Unfortunately it didn't even finish after 15m here.
And there is the dmesg with time stamps, the calltrace is triggered by
"echo l > /proc/sysrq-trigger".

[   30.140269] run fstests generic/027 at 2026-04-25 07:19:32
[   30.392655] BTRFS: device fsid 85ba0f7c-dfed-4220-9d47-72b07a1c81d8=20
devid 1 transid 8 /dev/mapper/test-scratch1 (253:2) scanned by mount (1108=
)
[   30.395605] BTRFS info (device dm-2): first mount of filesystem=20
85ba0f7c-dfed-4220-9d47-72b07a1c81d8
[   30.395625] BTRFS info (device dm-2): using crc32c checksum algorithm
[   30.398590] BTRFS info (device dm-2): checking UUID tree
[   30.398734] BTRFS info (device dm-2): turning on async discard
[   30.398737] BTRFS info (device dm-2): enabling free space tree
[   33.294754] systemd-journald[360]: Time jumped backwards, rotating.
[  993.736548] sysrq: Show backtrace of all active CPUs
[  993.736581] NMI backtrace for cpu 0
[  993.736608] CPU: 0 UID: 0 PID: 2410 Comm: bash Not tainted=20
7.0.0-rc7-custom-64k+ #10 PREEMPT(full)
[  993.736613] Hardware name: QEMU KVM Virtual Machine, BIOS unknown=20
2/2/2022
[  993.736616] Call trace:
[  993.736618]  show_stack+0x20/0x38 (C)
[  993.736635]  dump_stack_lvl+0x60/0x80
[  993.736646]  dump_stack+0x18/0x24
[  993.736649]  nmi_cpu_backtrace+0xf0/0x128
[  993.736665]  nmi_trigger_cpumask_backtrace+0x1c4/0x1f8
[  993.736668]  arch_trigger_cpumask_backtrace+0x20/0x40
[  993.736675]  sysrq_handle_showallcpus+0x24/0x38
[  993.736686]  __handle_sysrq+0x9c/0x1b8
[  993.736689]  write_sysrq_trigger+0xcc/0x100
[  993.736692]  proc_reg_write+0x7c/0xf0
[  993.736701]  vfs_write+0xd8/0x3a8
[  993.736716]  ksys_write+0x70/0x120
[  993.736719]  __arm64_sys_write+0x20/0x40
[  993.736722]  invoke_syscall.constprop.0+0x64/0xe8
[  993.736726]  el0_svc_common.constprop.0+0x40/0xe8
[  993.736728]  do_el0_svc+0x24/0x38
[  993.736730]  el0_svc+0x3c/0x198
[  993.736733]  el0t_64_sync_handler+0xa0/0xe8
[  993.736735]  el0t_64_sync+0x198/0x1a0
[  993.736755] Sending NMI from CPU 0 to CPUs 1-7:
[  993.736769] NMI backtrace for cpu 3
[  993.736777] CPU: 3 UID: 0 PID: 212 Comm: kworker/u38:2 Not tainted=20
7.0.0-rc7-custom-64k+ #10 PREEMPT(full)
[  993.736780] Hardware name: QEMU KVM Virtual Machine, BIOS unknown=20
2/2/2022
[  993.736782] Workqueue: events_unbound=20
btrfs_async_reclaim_metadata_space [btrfs]
[  993.736879] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS=20
BTYPE=3D--)
[  993.736882] pc : _raw_spin_unlock_irqrestore+0x10/0x60
[  993.736899] lr : __percpu_counter_sum+0x94/0xc0
[  993.736909] sp : ffff8000834cfc10
[  993.736910] x29: ffff8000834cfc10 x28: 0000000000000400 x27:=20
0000000008000000
[  993.736912] x26: ffff0000ccfef81c x25: 0000000000000000 x24:=20
ffffb6b45621ef98
[  993.736914] x23: ffff0000d2e48698 x22: ffffb6b45621a000 x21:=20
ffffb6b456219080
[  993.736916] x20: ffffb6b456219288 x19: 0000000000009000 x18:=20
ffff494da90b0000
[  993.736917] x17: 0000000000000000 x16: ffffb6b45524e920 x15:=20
ffffb6b45621ef98
[  993.736919] x14: ffffb6b456111740 x13: 0000000000000180 x12:=20
ffff0001ff1c1740
[  993.736921] x11: 00000000000000c0 x10: 4eb904daffc7d416 x9 :=20
ffffb6b45524e9b4
[  993.736922] x8 : ffff8000834cfab0 x7 : 0000000000000000 x6 :=20
ffffffffffffffff
[  993.736924] x5 : 0000000000000000 x4 : 0000000000000000 x3 :=20
0000000000000008
[  993.736926] x2 : 0000000000000008 x1 : 0000000000000000 x0 :=20
ffff0000d2e48698
[  993.736928] Call trace:
[  993.736929]  _raw_spin_unlock_irqrestore+0x10/0x60 (P)
[  993.736932]  flush_space+0x45c/0x6b0 [btrfs]
[  993.737001]  do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
[  993.737064]  btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs]
[  993.737126]  process_one_work+0x174/0x540
[  993.737138]  worker_thread+0x1a0/0x318
[  993.737140]  kthread+0x140/0x158
[  993.737145]  ret_from_fork+0x10/0x20
[  993.737156] NMI backtrace for cpu 4

>=20
> I will try to instrument the reservations and reclaim codepaths and see
> if I can think of a nice fix to reserve "enough but not too much".
>=20
> I can also try to attack the "stuck big fs under big reclaim" more
> directly by trying to make reclaim less stuck-prone, rather than messing
> with reservations. Though it would be quite disappointing if we
> practically cannot make the reservation choices more accurate..

Totally understandable, ENOSPC in btrfs is always the biggest challenge,=
=20
and the trade-offs are always hard to balance.

Meanwhile I'd prefer to have the last commit reverted so that we can=20
continue our regular testing.

Thanks,
Qu

>=20
> Thanks,
> Boris
>=20
>>>
>>> Do you have any clue on what's going wrong? I guess it's pretty hard t=
o
>>> hit on x86_64.
>>>
>>> I have a local btrfs branch with huge folios support, with that it's
>>> pretty easy to hit similar problems on x86_64, but without that branch=
,
>>> no hit is observed so far on x86_64.
>>>
>>> Thanks,
>>> Qu
>>>
>>>> ---
>>>>  =C2=A0 fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
>>>>  =C2=A0 1 file changed, 20 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>>>> index f0436eea1544..e931deb3d013 100644
>>>> --- a/fs/btrfs/space-info.c
>>>> +++ b/fs/btrfs/space-info.c
>>>> @@ -725,9 +725,8 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 delalloc_bytes;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ordered_bytes;
>>>> -=C2=A0=C2=A0=C2=A0 u64 items;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long time_left;
>>>> -=C2=A0=C2=A0=C2=A0 int loops;
>>>> +=C2=A0=C2=A0=C2=A0 u64 orig_tickets_id;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 delalloc_bytes =3D percpu_counter_sum=
_positive(&fs_info-
>>>>> delalloc_bytes);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ordered_bytes =3D percpu_counter_sum_=
positive(&fs_info-
>>>>> ordered_bytes);
>>>> @@ -735,9 +734,7 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Calc the number of the pages we ne=
ed flush for space
>>>> reservation */
>>>> -=C2=A0=C2=A0=C2=A0 if (to_reclaim =3D=3D U64_MAX) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 items =3D U64_MAX;
>>>> -=C2=A0=C2=A0=C2=A0 } else {
>>>> +=C2=A0=C2=A0=C2=A0 if (to_reclaim !=3D U64_MAX) {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to_re=
claim is set to however much metadata we need to
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * recla=
im, but reclaiming that much data doesn't really track
>>>> @@ -751,7 +748,6 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * aggre=
ssive.
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to_reclaim =
=3D max(to_reclaim, delalloc_bytes >> 3);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 items =3D calc_reclaim_it=
ems_nr(fs_info, to_reclaim) * 2;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trans =3D current->journal_info;
>>>> @@ -764,10 +760,14 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ordered_bytes > delalloc_bytes &&=
 !for_preempt)
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wait_ordered =
=3D true;
>>>> -=C2=A0=C2=A0=C2=A0 loops =3D 0;
>>>> -=C2=A0=C2=A0=C2=A0 while ((delalloc_bytes || ordered_bytes) && loops=
 < 3) {
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 temp =3D min(delalloc=
_bytes, to_reclaim) >> PAGE_SHIFT;
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long nr_pages =3D min_t(u=
64, temp, LONG_MAX);
>>>> +=C2=A0=C2=A0=C2=A0 spin_lock(&space_info->lock);
>>>> +=C2=A0=C2=A0=C2=A0 orig_tickets_id =3D space_info->tickets_id;
>>>> +=C2=A0=C2=A0=C2=A0 spin_unlock(&space_info->lock);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 while ((delalloc_bytes || ordered_bytes) && to_re=
claim) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 iter_reclaim =3D min_=
t(u64, to_reclaim, SZ_128M);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 long nr_pages =3D min_t(u=
64, delalloc_bytes, iter_reclaim) >>
>>>> PAGE_SHIFT;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 items =3D calc_reclai=
m_items_nr(fs_info, iter_reclaim) * 2;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int async_pag=
es;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_start_d=
elalloc_roots(fs_info, nr_pages, true);
>>>> @@ -811,7 +811,7 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_read(&fs_info->async_delalloc_pages)=
 <=3D
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 async_pages);
>>>>  =C2=A0 skip_async:
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loops++;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 to_reclaim -=3D iter_recl=
aim;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (wait_orde=
red && !trans) {
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 btrfs_wait_ordered_roots(fs_info, items, NULL);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>>>> @@ -834,6 +834,15 @@ static void shrink_delalloc(struct
>>>> btrfs_space_info *space_info,
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 spin_unlock(&space_info->lock);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 break;
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If a ticket was s=
atisfied since we started, break out
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * so the async recl=
aim state machine can process delayed
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * refs before we fl=
ush more delalloc.
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (space_info->tickets_i=
d !=3D orig_tickets_id) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
pin_unlock(&space_info->lock);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&=
space_info->lock);
>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 delalloc_byte=
s =3D percpu_counter_sum_positive(
>>>
>>>
>>

