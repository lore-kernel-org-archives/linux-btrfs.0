Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E02137DE92
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 21:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777586343; cv=none; b=hDofZthy7JKmJp+J2MBbrgH6CGjoSx0T1977F6X3w/SPFMEkNKAamA4L2hndkP+oiRwPt2v+B611EeAKLjMdDcPR0yB3Ugc7lfsmKjjJCIa0RNi4CQlwL6C4JUSnOqzpfXVk6xuzj/bs8tFx1j1iDYV8htaLn2RZ+TAHJZ6OimU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777586343; c=relaxed/simple;
	bh=DSAK4pcrA0mdn396iAOZTXOo4x63VeMuWSM7cyYTTMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMaepbBTVQVqZ4jcvMsphXsqbEje5B1CXVasywho9lj6j/gRRF/Hh9JfXLDNB1hpqiZiNWlaxx3hjii4JvWc8C0AsKSsbCU5ozku5pz3entvAvpeXveJnCJI3ZYDsSTe4tcRUoT7Ir7UiSZ6xJDUdS439WqaRJSkn+NBFYVZyqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=GGf0GWZy; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="GGf0GWZy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777586335; x=1778191135; i=quwenruo.btrfs@gmx.com;
	bh=KePhbQAgIepe7YbPxWjDJv5Sd7OQxEqGWpJxHhkdBd4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GGf0GWZyVLnBLSDew1u9vnOq4vf8ZL1Ah2MNQ3oVwgs9iDfSQrleb3I2/GQl+jBk
	 SuzxNvHVofaHcgAsiU6wKyOQbfp5RyQxwiCLvFH8IO9eJO6upn6h7zShbGuWc6Y7l
	 yZjSCCsdYpUPrJMOh5iGnlg2IkKudb1D4XMxGlRlFFEbB2fCy6+ur1V0P6owlR+vd
	 JAZmsGz+I+7Pu9zKu0SR7mHsGrPlXEHP9t9L8XEOh+j1htJ/Q9E0cVjl7xZqaOB4W
	 uxCc6EjlK4Igb9bjYb1eYzrUAvkQ5RIynCf3ozJu7llm4pZAyJ5xFM7ignLUXEkh4
	 1VpHTdGrLsdVDjRfmA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MFKGP-1w7K4N3Nzl-000nZv; Thu, 30
 Apr 2026 23:58:55 +0200
Message-ID: <24c783e3-fb72-41d2-8a82-dcebd768eff0@gmx.com>
Date: Fri, 1 May 2026 07:28:49 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] btrfs: warn about extent buffer that can not be
 released
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>,
 Teng Liu <27rabbitlt@gmail.com>
References: <cover.1777510825.git.wqu@suse.com>
 <ecc473cee5a79c8c8b1006febbfeb24963c46714.1777510825.git.wqu@suse.com>
 <CAL3q7H60GiqmvVge1WxpG1GXONjE5xXiHuWOSO9Ae=7ATfb-VQ@mail.gmail.com>
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
In-Reply-To: <CAL3q7H60GiqmvVge1WxpG1GXONjE5xXiHuWOSO9Ae=7ATfb-VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RT50PfAOMqZaY22QFQdHHlMU9m412CN0RxPb+eUHDMOpqpq0E1W
 kV5P5RnqQXX6qUwImhc0eXK/m9QPiaGWIQPXDSPaiwYYs5uwo6/YzSDNT7BYaTjbs41BiRu
 X7PmheuBRFOx2UA9BamIhuy7eyI/36ugfdWUZU9jhaZ1w04UFEVDFfnM1ZHBAz+V34ogz1w
 JPos0haNfjKggvJklSSSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aNv87LBxgiA=;/CtsSEnim5L17C/wDbwzy1FcBXh
 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



=E5=9C=A8 2026/4/30 22:18, Filipe Manana =E5=86=99=E9=81=93:
> On Thu, Apr 30, 2026 at 2:08=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
[...]
>> +       }
>> +       rcu_read_unlock();
>> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>=20
> Can we report/WARN_ON if invalidate_inode_pages2() returns an error agai=
n?

May not be a good idea, especially if we already hit a dirty eb and=20
warned before.

Thanks,
Qu

>=20
> Otherwise:
>=20
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>=20
> Thanks.
>=20
>> +}
>> +
>>   int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices=
 *fs_devices)
>>   {
>>          u32 sectorsize;
>> @@ -3709,7 +3759,7 @@ int __cold open_ctree(struct super_block *sb, str=
uct btrfs_fs_devices *fs_device
>>          if (fs_info->data_reloc_root)
>>                  btrfs_drop_and_free_fs_root(fs_info, fs_info->data_rel=
oc_root);
>>          free_root_pointers(fs_info, true);
>> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       invalidate_and_check_btree_folios(fs_info);
>>
>>   fail_sb_buffer:
>>          btrfs_stop_all_workers(fs_info);
>> @@ -4438,7 +4488,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_=
info)
>>           * We must make sure there is not any read request to
>>           * submit after we stop all workers.
>>           */
>> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>> +       invalidate_and_check_btree_folios(fs_info);
>>          btrfs_stop_all_workers(fs_info);
>>
>>          /*
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 8800faa8b4be..9c9dffda2b07 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2882,12 +2882,6 @@ bool try_release_extent_mapping(struct folio *fo=
lio, gfp_t mask)
>>          return try_release_extent_state(io_tree, folio);
>>   }
>>
>> -static int extent_buffer_under_io(const struct extent_buffer *eb)
>> -{
>> -       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
>> -               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> -}
>> -
>>   static bool folio_range_has_eb(struct folio *folio)
>>   {
>>          struct btrfs_folio_state *bfs;
>> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
>> index b310a5145cf6..7b4152387d88 100644
>> --- a/fs/btrfs/extent_io.h
>> +++ b/fs/btrfs/extent_io.h
>> @@ -327,6 +327,12 @@ static inline bool extent_buffer_uptodate(const st=
ruct extent_buffer *eb)
>>          return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>>   }
>>
>> +static inline bool extent_buffer_under_io(const struct extent_buffer *=
eb)
>> +{
>> +       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
>> +               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
>> +}
>> +
>>   int memcmp_extent_buffer(const struct extent_buffer *eb, const void *=
ptrv,
>>                           unsigned long start, unsigned long len);
>>   void read_extent_buffer(const struct extent_buffer *eb, void *dst,
>> --
>> 2.54.0
>>
>>
>=20

