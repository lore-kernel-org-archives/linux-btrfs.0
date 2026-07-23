Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452B7466B19
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784805446; cv=none; b=asjvsTSgyMLcmtWBtqpKPkiSMw0ZPVHwzCpjuezXrZtYpbIHYrcOBndF1+CAp8RKuYAS3jo9oMZgVsO7jX0bOwCr5zskX4r/SL9PTl/xkD0EbZZQ2l1L4Gg8RWVmAsL+idEP9MQ97hJUo77bEONF05W+cIptpn9yPehnkUaH38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784805446; c=relaxed/simple;
	bh=wbTMfsRttKAhURyoinb7AMZJb/bM8U9rCA39e+KAaJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJHohOQmNTahFR8JQcXSahgCpOe6bHJ5zcl1BV5l1g8Heg5i4eOmzZjNGsX1boTmwX3vJHvAbhmGYwgXBEdJs9SJfSTeBsJYFbyVjWzLWd+j9qXDA9aoiKm4V9p5oTZPErq2n98GGcolyw+818J5PVtVGp3kCFv087jCp2lPd2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=l7XzbM2C; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="l7XzbM2C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784805434; x=1785410234; i=quwenruo.btrfs@gmx.com;
	bh=p3kIxo136+ek2uLa1envOmULOcZMl3BZXiqutLSEMmk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=l7XzbM2CJAAZ1kkc7QWuAX+phEh1t62YlyMR8sv7BadlU6GSVPucAMqJ+x0tQdmT
	 m2qHA6/55kHcLjv2UAjMyj1qIycbqQlNUZ84NhsLi1s5VLtXAsuqIG5y1SKyrqJds
	 BreLty+LC4aHj/Moo3OyJ0CYgl4giR8OV1WgaC8Aeu5q6a50AMAzj3l6rVgGgAF1E
	 tdEkfH6iPVm4sAA3usQHz0jfR3H3YhmsjRpbzSy8SUlB2NaZpFNxsnu/aavkW/pcA
	 B35F6sutEQhOmB2kLjIgM5V0MVdZXN8fjX7V4preyVLFSZ6Kt8d/sRzAGabsGbdi7
	 Zm3IzT83YYi1rRLmpQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1ML9yS-1wVkHT1vtK-00W1qQ; Thu, 23
 Jul 2026 13:17:13 +0200
Message-ID: <f4f41f37-304f-41e7-af53-d7037e54cde9@gmx.com>
Date: Thu, 23 Jul 2026 20:47:10 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com>
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
In-Reply-To: <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fhBnTkQXI1hqEydzYHmgULGvXBaK+e5FRUNWrmlx+VKrqUZwqnw
 tvduC3TcPiCDJCFxg1/kAWbbJKLRM7RmxVOwBEezsWPigXEkrvsTVUS3d1mXl+mi5A7di8X
 xYIp0z/UmLe1NIEKWvZYJFOzRPtc+ZIu4fuwtdhNXj5rHnaIEPzLZ9Hrrt78Ofa9Aa7pszA
 9DFpdYDaeQf2suItN8whA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sIFYab5mw2s=;XXYW3UaIPF7dA3YKCdd6HPOcHLx
 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



=E5=9C=A8 2026/7/23 20:08, Filipe Manana =E5=86=99=E9=81=93:
> On Thu, Jul 23, 2026 at 7:16=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>> There is a bug report that a reproducer which doing the following
>> workloads in two threads:
>>
>> - Direct read into memory mapped from page cache
>> - Sync the above range
>>
>> This can lead to dirty folios without fs knowing, this can be a huge
>=20
> Can you please explain where, and why, the folio is dirtied?


btrfs_check_read_bio()
|- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
    |- bio_check_pages_dirty()
       |- bio_dirty_fn()
          |- bio_release_pages(bio, true)
             |- __bio_release_pages(bio, mark_dirty =3D=3D true)
                |- folio_mark_dirty()

At least this is the one from the reproducer.

Thanks,
Qu

>=20
> How does a direct IO read dirties a folio or a sync_file_range(2) call?
>=20
> Thanks.
>=20
>> problem for btrfs, as even on the very basic bs =3D=3D ps cases without
>> large folios, such reproducer can screw up the ordered extent accountin=
g
>> already:
>>
>>   ------------[ cut here ]------------
>>   WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent.isr=
a.0+0x56/0x1f0 [btrfs], CPU#1: kworker/u42:0/68
>>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            E    =
   7.2.0-rc4-custom+ #415 PREEMPT(full)  74dbeafab12c410178747d5bec9fb200a=
e56949f
>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/0=
2/2022
>>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
>>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>>   Call Trace:
>>    <TASK>
>>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 7d1ffd99bb9696179883f25=
7e5fd838e2d1a0ca3]
>>    end_bbio_data_write+0x1ff/0x280 [btrfs 7d1ffd99bb9696179883f257e5fd8=
38e2d1a0ca3]
>>    btrfs_bio_end_io+0x76/0xf0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d=
1a0ca3]
>>    process_one_work+0x198/0x380
>>    worker_thread+0x1c8/0x330
>>    kthread+0xee/0x120
>>    ret_from_fork+0x28f/0x310
>>    ret_from_fork_asm+0x11/0x20
>>    </TASK>
>>   ---[ end trace 0000000000000000 ]---
>>   BTRFS critical (device dm-3): bad ordered extent accounting, root=3D5=
 ino=3D257 OE offset=3D3465216 OE len=3D2826240 to_dec=3D319488 left=3D135=
168
>>
>> Unfortunately we have removed cow fixup mechanism, which is to work
>> around such dirty folios by re-dirtying them and reserve space for them=
,
>> across several kernel releases, meaning we can not easily revert a
>> single commit to bring it back.
>> And without doubt, that old cow fixup mechanism is not support larger
>> folios.
>>
>> As a hot fix, disable btrfs direct reads for non-experimental builds fo=
r
>> now, so this can buy some time before we find out a proper way to addre=
ss
>> this.
>>
>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693be=
4c863ac@linux.ibm.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Changelog:
>> v2:
>> - Fallback to buffered IO to avoid failing existing direct IO users
>>
>> - Allow direct writes
>>
>> Reason for RFC:
>> I'm not 100% sure if disabling direct IOs can fill all the holes.
>>
>> We still allow mmapping page cache into user spaces, thus I'm not sure
>> if this is the only hole.
>> ---
>>   fs/btrfs/direct-io.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index ed1779ccb4de..32b29a4faaf2 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -1093,6 +1093,11 @@ ssize_t btrfs_direct_read(struct kiocb *iocb, st=
ruct iov_iter *to)
>>          if (check_direct_read(inode_to_fs_info(inode), to, iocb->ki_po=
s))
>>                  return 0;
>>
>> +#ifndef CONFIG_BTRFS_EXPERIMENTAL
>> +       /* To avoid dirty folios without fs knowing through */
>> +       return 0;
>> +#endif
>> +
>>          btrfs_inode_lock(BTRFS_I(inode), BTRFS_ILOCK_SHARED);
>>   again:
>>          /*
>> --
>> 2.54.0
>>
>>
>=20

