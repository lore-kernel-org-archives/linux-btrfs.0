Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853B43D669A;
	Wed, 30 Sep 2026 08:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790758642; cv=none; b=N/PTHMn7zhjaYKlbonAoo5sjLXFLO6LWqfZPtm3MfUAW+8ccK6Uc/dH/2vYm3f1uUCsCN3EEsjyZyE6br+Yqq1djsf5e12oiH+pvjsXxzLUcWhTEvNxrmioxYFmroK0eqTCFKzHPPlcVE7cfQpt53nRpEl9s5Emvx44/MMfRH7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790758642; c=relaxed/simple;
	bh=HW40BdUdJ8ePeP8pemDWtkp0y/x18YzAjSN7f3IcvYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fk2VoSrFn12R8WyoXjt1wC5k4+SMkASUzLuxd5h+660cYIHG+Gb3BZVoJ+4iqA1PG5HWvIL++HmRVcL9Ry5LfSTlrHxEDgVD7JZh+MjkfTd37Z5XOSKJ34zvy14p1DLTo6xN5rO4/fyEWVhyQuOoKccj9Btg4yNnwKdkERru7Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=Tq04K/3h; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="Tq04K/3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790758633; x=1791363433; i=quwenruo.btrfs@gmx.com;
	bh=HW40BdUdJ8ePeP8pemDWtkp0y/x18YzAjSN7f3IcvYg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Tq04K/3hkdu8ykXQuHhp1jhISH8ayd3CxtujKsB+V3kvvQVBcfNDHVVIXSGfjc//
	 3bYUidn04coXIhEHhPy4GG43AxLUwcgKYlj++8UPz31wNblEzqmB5QRRlYG2TQXDH
	 WwdqmMrA9K0zIhEq2+vvIvf8HRLTTYV0S07efhsP2fveeF3eSAGVPuZj+9Q2sf6nk
	 V1zCCaV5Kl/mCQejM29u3lUzq5KqMAJagjw9XNLnTGU3lBP8ErEtf/QdwjHtAu9+S
	 F9tglLwvPY32wL0sStzsZO8uEfWpKmQ6HbzNpxS3txaLP5WcH/o0Sp2yXx4Z2fUsV
	 879uB919rrT+F81Trg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MzhjF-1wpvYn1ibp-016GCW; Wed, 30
 Sep 2026 10:57:13 +0200
Message-ID: <8ade35a8-eed6-49d6-bff7-cdb1b0400821@gmx.com>
Date: Wed, 30 Sep 2026 18:27:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: raid56: do not verify the content if there is no
 data checksum
To: Bartosz Fenski <bartosz@fenski.pl>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
References: <2989cda015c8673ccd463a5225cb985dc9e36825.1790730674.git.wqu@suse.com>
 <42c847ba-6984-4f8d-91de-a359e968db11@fenski.pl>
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
In-Reply-To: <42c847ba-6984-4f8d-91de-a359e968db11@fenski.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Rjx5gzXrpzJLCdqDn65oAQkNxxl+T3FxXWRVexsP4voTk1wnBAG
 io7KMfXXIfHwOXkw+dGlOmwPSFuKLBaydlVbQMUUxiTvlNcJWNlvY9SQ/edVebWkRDHkYcQ
 eYf8uH17q00BxPIGSRg3hNqpWMDgNA0WJaeV4vbH41RfJ9Y/lRsxOFR0NVRJEzg81DGYJaD
 OyeVJ/3bWaRXIQXIH/UfQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9oYTWqF5eNc=;5rJ5XIORN/bka7xFPnsOgIKa3Cn
 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



=E5=9C=A8 2026/9/30 17:58, Bartosz Fenski =E5=86=99=E9=81=93:
> The total_sector_nr calculation appears to have a typo:
>=20
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0stripe_nr + rbio->stripe_nsectors + sector_n=
r;
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0stripe_nr * rbio->stripe_nsectors + sector_n=
r;

My bad, sashiko also exposed this bug.

I'll update it the v2 to fix the typo.

Thanks a lot for the testing and review.
Qu>
> I tested the patch as posted against the original v7.3-rc5 reproducer.
> It still returned EIO from fdatasync, at offset 148971520 after 1632
> writes.
>=20
> After changing the addition to multiplication, the default-preallocation
> test completed successfully twice. The fallocate=3Dnone control also
> completed successfully. Kernel taint remained zero, all Btrfs device
> error counters remained zero, and dmesg contained no Btrfs errors or
> warnings.
>=20
> regards
> Bartosz Fenski
>=20
> On 30/09/2026 03:11, Qu Wenruo wrote:
>> [BUG]
>> There is a bug report that fio can fail to sync the data on a degraded
>> RAID56 mount:
>>
>> =C2=A0 # mkfs.btrfs -m raid1 -d raid5 -f $dev1 $dev2 $dev3
>> =C2=A0 # mount $dev1 $mnt
>> =C2=A0 # btrfs balance start -d $mnt
>> =C2=A0 # umount $mnt
>> =C2=A0 # btrfs dev scan -u $dev2
>> =C2=A0 # wipefs -fa $dev2
>> =C2=A0 # mount -o degraded $dev1 $mnt
>> =C2=A0 # fio --name=3Ddegraded-write --directory=3D$mnt --rw=3Drandwrit=
e --=20
>> fdatasync=3D4 \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 --bs=3D4k --size=3D512M --ra=
ndrepeat=3D1
>>
>> The run will fail at fsync:
>>
>> =C2=A0 fio: io_u error on file /mnt/btrfs/degraded-write.0.0: Input/out=
put=20
>> error: datasync offset=3D142254080, buflen=3D0
>> =C2=A0 fio: pid=3D2064, err=3D5/file:io_u.c:2008, func=3Dio_u error, er=
ror=3DInput/=20
>> output error
>>
>> [CAUSE]
>> With extra debug output, it shows the problem pretty well:
>>
>> =C2=A0 rbio=3D2876243968 faila=3D0 sectornr=3D0
>> =C2=A0 rbio=3D2876243968 error=3D0-15 csum=3D2 bio=3D15
>>
>> The first line shows the rbio's full stripe logical, and stripe/sector
>> number when verify_one_sector() failed.
>>
>> The second line shows more detail about the rbio, the sector range [0,=
=20
>> 16)
>> is corrupted, which indicates the first data stripe is corrupted,=20
>> matching
>> the missing device.
>>
>> The important part is that the csum bitmap shows the data csum is only
>> for sector number 2, meanwhile the failed verification is at sector
>> number 0.
>>
>> This means we did the checksum verification even if no corresponding
>> checksum is populated.
>>
>> [FIX]
>> There is already a similar check at verify_bio_data_sectors(), but
>> unfortunately there is no such check at verify_one_sector().
>>
>> Add the missing check to skip the csum verification if there is no
>> corresponding data checksum.
>>
>> Reported-by: Bartosz Fenski <bartosz@fenski.pl>
>> Link: https://lore.kernel.org/linux-btrfs/=20
>> a72409af-45ef-45df-9970-2e38bcb22ea6@fenski.pl/
>> Fixes: 7a3150723061 ("btrfs: raid56: do data csum verification during=
=20
>> RMW cycle")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 fs/btrfs/raid56.c | 11 ++++++++---
>> =C2=A0 1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 8ec24dbb180f..38b48e53e11d 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -1889,6 +1889,8 @@ static int verify_one_sector(struct=20
>> btrfs_raid_bio *rbio,
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D rbio->=
bioc->fs_info;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 phys_addr_t *paddrs;
>> +=C2=A0=C2=A0=C2=A0 const unsigned int total_sector_nr =3D
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 stripe_nr + rbio->stripe_ns=
ectors + sector_nr;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 csum_buf[BTRFS_CSUM_SIZE];
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 *csum_expected;
>> @@ -1898,6 +1900,11 @@ static int verify_one_sector(struct=20
>> btrfs_raid_bio *rbio,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* No way to verify P/Q as they are not =
covered by data csum. */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (stripe_nr >=3D rbio->nr_data)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> +=C2=A0=C2=A0=C2=A0 /* No data checksum for this sector. */
>> +=C2=A0=C2=A0=C2=A0 if (!test_bit(total_sector_nr, rbio->csum_bitmap))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If we're rebuilding a read, we h=
ave to use pages from the
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * bio list if possible.
>> @@ -1908,9 +1915,7 @@ static int verify_one_sector(struct=20
>> btrfs_raid_bio *rbio,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 paddrs =3D rbio_=
stripe_paddrs(rbio, stripe_nr, sector_nr);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 csum_expected =3D rbio->csum_buf +
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (st=
ripe_nr * rbio->stripe_nsectors + sector_nr) *
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_=
info->csum_size;
>> +=C2=A0=C2=A0=C2=A0 csum_expected =3D rbio->csum_buf + total_sector_nr =
* fs_info-=20
>> >csum_size;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 calculate_block_csum_paddrs(fs_info, pad=
drs, csum_buf);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(memcmp(csum_buf, csum_expec=
ted, fs_info-=20
>> >csum_size) !=3D 0))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>=20

