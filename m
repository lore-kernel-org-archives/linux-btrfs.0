Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658CB377EA2;
	Mon, 22 Jun 2026 22:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782167209; cv=none; b=pAvqtUKoqA8QTkO9i/Ee5NvPFM+vOdbToyPeQ/t0usXhnyQ/syYKV05O+ivWXxo7efX6yPrdFo2BD6CpjitVR9AIKuW5jC+UXsMwgNbUgVlrIJ9vU6ZgisA1pSj+ZLYLVJl/QRxjfFQoaQqduRAtCCU54p6yRM6Nh2XN2F1/gDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782167209; c=relaxed/simple;
	bh=NMt8QjFyWg5YZqUhys5zr/iCGCt9Zn4BMgGBb2i0I6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ed9p/aNsVTAdbYqxfoVDrOImdJf05R8TtsicLSha2jkrQ/68eqOAqXj0+Ce9khc2Yb1eOpR3FNML7SwoKGPSIX0a+ZnWXRpUY++cL4HG/o5uSeSF0WkNJ5njWQWR9hThiTigfAHJOfFDyqJtlk50MO4EN9dQxXxF4Nfp2Noa5Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=eMNZPvGx; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="eMNZPvGx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1782167205; x=1782772005; i=quwenruo.btrfs@gmx.com;
	bh=OSH1MKKRJIA18x6iaFMtiaYFLk9KsO1eZNLrIzcrLyA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eMNZPvGxWsRRuRO1MFhnxDAyK403sfQEmDm77oE3spmEt58GJhggcmPsjPez4SoI
	 5a1U8CSQZOBqlj3Ip2Sl/Bx5rQhgJUouoL7ala8Jv4dR5bip75BJaQIk93IUHFlqu
	 jntZlniymdxdxd2QopL+ZllkuJtN3K41oC1RVi284HLMJuL1a28xutqoZiwQqaGnO
	 1pEUMLDHk+5LP5palVCgKYJFKA74dxEXdxFL8lycHTYqNivq7zq5+IQx3g4oWxf6Y
	 nV/qOsYoi0Dye9NjD2W1XP7LpV7OgqpNGzoB4XiQlcKkvK7pdahpQCqfxUzNwr4po
	 /g8NRczYsWjyQwR9mw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MDQic-1wUbI44AsA-003W5r; Tue, 23
 Jun 2026 00:26:45 +0200
Message-ID: <132d73b7-4271-49f9-90ca-074f70876b54@gmx.com>
Date: Tue, 23 Jun 2026 07:56:35 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: do not try compression for data reloc inodes
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
 syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <cover.1782022263.git.wqu@suse.com>
 <9206a06ed48a4dc40d50909dddf3daa9b17965eb.1782022263.git.wqu@suse.com>
 <CAL3q7H43PTL7AfGz4nNWTOYX4pHgUKYo+c5+R_=qpUOkj_R_eA@mail.gmail.com>
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
In-Reply-To: <CAL3q7H43PTL7AfGz4nNWTOYX4pHgUKYo+c5+R_=qpUOkj_R_eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v/uFjvcEioVqlJIJXBHXTcTBT5/NjrWVRQ7wXQ5hBVJBti95M7s
 F1HpUCSgGO3AaLEddXOxg3YwaiX5AKop2C35halLXgB+SB23+8uuwbZAoGaVv2rSVBe/Apf
 5l6mN433/kcYR29/62/Mp7rcLSRVK2qJ6JeVaCZ+g0J6ecvEYSFDWrEGCFFrffuCIZHoZK0
 5mo4jAXR63sIw/a4Doy+A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3a4dvwZt3y4=;g52v3EHcml1D6zoOv8l8wxUUj2C
 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
 u/vXFL/pAwFG6+aHhY=



=E5=9C=A8 2026/6/22 20:47, Filipe Manana =E5=86=99=E9=81=93:
> On Sun, Jun 21, 2026 at 7:13=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>> [BUG]
>> There is a syzbot report that the check inside get_new_location()
>> triggered:
>>
>>   BTRFS info (device loop0): found 31 extents, stage: move data extents
>>   BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free spa=
ce 1676 owner 18446744073709551607
>>          item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
>>                  inode generation 5 transid 0 size 0 nbytes 0
>>                  block group 0 mode 40755 links 1 uid 0 gid 0
>>                  rdev 0 sequence 0 flags 0x0
>>                  atime 1669132761.0
>>                  ctime 1669132761.0
>>                  mtime 1669132761.0
>>                  otime 0.0
>>          item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
>>                  index 0 name_len 2
>>          item 2 key (258 INODE_ITEM 0) itemoff 3663 itemsize 160
>>                  inode generation 1 transid 16 size 733184 nbytes 10649=
6
>>                  block group 0 mode 100600 links 0 uid 0 gid 0
>>                  rdev 0 sequence 24 flags 0x18
>>          item 3 key (258 EXTENT_DATA 0) itemoff 3595 itemsize 68
>>                  generation 16 type 0
>>                  inline extent data size 47 ram_bytes 4096 compression =
1
>>   [...]
>>          item 27 key (18446744073709551611 ORPHAN_ITEM 258) itemoff 237=
6 itemsize 0
>>   BTRFS error (device loop0): unexpected non-zero offset in file extent=
 item for data reloc inode 258 key offset 0 offset 9277520992061368337
>>   ------------[ cut here ]------------
>>   btrfs_abort_should_print_stack(__error)
>>
>> [CAUSE]
>> The above dump tree shows the first file extent item is inlined, which
>> should make no sense for data reloc inodes, as such inodes are just
>> representing where the data extents are in the relocation destination c=
hunk.
>>
>> However the relocation path is just dirtying the data reloc inode
>> cluster by cluster. It's possible to have a single block, not adjacent
>> to any other data extents.
>>
>> Then relocation will dirty the first block of the data reloc inode, the=
n
>> memory pressure forces the data reloc inode to be written back.
>>
>> In that case, since the syzbot has forced compression, we try to
>> compress the first block and if it can be compressed and inlined, an
>> inlined extent will be created.
>=20
> If it were that simple, users would have encountered it and reported
> it, and fstests would have triggered this (we have several balance +
> fsstress + compression tests).
>=20
> Something is missing here.
> A very important detail, which is not mentioned here at all, is that
> relocation works by preallocating extents (see
> prealloc_file_extent_cluster()) before dirtying pages/folios.
>=20
> This means that flushing delalloc of the data reloc inode should
> always go into the nocow path.

Not really.

Since commit 3eaf5f082c4c ("btrfs: extract inlined creation into a=20
dedicated delalloc helper"), we do not try nocow first, but inline first.

So even if we had a preallocated file extent for the first block, as=20
long as the isize is no larger than 1 block, the write back path will=20
still try inline first.

And since global force compression is set, we try compression and then=20
inline the compressed data.


In fact, this can be reproduced on regular inodes:

  $ mkfs.btrfs -f /dev/test/scratch1
  $ sudo mount -o compress-force=3Dzstd /dev/test/scratch1  /mnt/btrfs/
  $ sudo xfs_io -f -c "falloc 0 4k" -c sync /mnt/btrfs/foobar
  $ sudo xfs_io -f -c "pwrite 0 4k" -c sync /mnt/btrfs/foobar
  $ btrfs ins dump-tree -t 5 /dev/test/scratch1
  [...]
	item 4 key (257 INODE_ITEM 0) itemoff 15879 itemsize 160
		generation 9 transid 10 size 4096 nbytes 4096
		block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
		sequence 3 flags 0x10(PREALLOC)
		atime 1782166878.155000000 (2026-06-23 07:51:18)
		ctime 1782166892.349000000 (2026-06-23 07:51:32)
		mtime 1782166892.349000000 (2026-06-23 07:51:32)
		otime 1782166878.155000000 (2026-06-23 07:51:18)
	item 5 key (257 INODE_REF 256) itemoff 15863 itemsize 16
		index 2 namelen 6 name: foobar
	item 6 key (257 EXTENT_DATA 0) itemoff 15823 itemsize 40
		generation 10 type 0 (inline)
		inline extent data size 19 ram_bytes 4096 compression 3 (zstd)

Note that, inode 257 has PREALLOC flag, meaning it indeed went through=20
preallocation before.

But still the final extent is still inlined.

I'll add the explanation in the next update.
>=20
> Even if the nocow path would fallback into cow, which should never
> happen for a data reloc inode, we never try to compress and inline the
> fallback path - fallback_to_cow() -> cow_file_range() ->
> cow_one_range() - nothing here attempts inline extents (or
> compression).
>=20
> What you are describing would be easy to convert into an fstests test ca=
se.

Not really. It requires a very specific cluster layout (only one block=20
at the beginning of the bg, and no other block in the cluster).
And also very specific timing on when the writeback happens.

The required timing/layout means it's pretty hard to hit with regular=20
stress runs.

Thanks,
Qu
>=20
> Flushing delalloc of the data reloc inode should never reach
> btrfs_inode_can_compress() - if we end up there, then the problem is
> somewhere else.
>=20
> Thanks.
>=20
>>
>> Then the check in get_new_location() will check the file offset, withou=
t
>> checking if the file extent is inlined or not, resulting the above
>> failure.
>>
>> [FIX]
>> Do not allow compression for data reloc inodes in the first place.
>>
>> Reported-by: syzbot+d950c6ba09b79f6e1864@syzkaller.appspotmail.com
>> Link: https://lore.kernel.org/linux-btrfs/6a373dc5.764cf64f.168fbe.0001=
.GAE@google.com/
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/btrfs_inode.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index d5d81f9546c3..fff72f6cc1e8 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -476,6 +476,8 @@ static inline bool btrfs_inode_can_compress(const s=
truct btrfs_inode *inode)
>>          if (inode->flags & BTRFS_INODE_NODATACOW ||
>>              inode->flags & BTRFS_INODE_NODATASUM)
>>                  return false;
>> +       if (btrfs_root_id(inode->root) =3D=3D BTRFS_DATA_RELOC_TREE_OBJ=
ECTID)
>> +               return false;
>>          return true;
>>   }
>>
>> --
>> 2.54.0
>>
>>
>=20

