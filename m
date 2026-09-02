Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1E937DEBE;
	Wed,  2 Sep 2026 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389300; cv=none; b=aE76sMSssrlxyO8TDHsuB+h76Fdv+JiICnPWLE+/msdlLszWUN1vFFaYKd90mhR1qsh6iElUvkzQlEQ8uqWk6LCgT5/RSX8070iXDRAshiVFERI/bfk4blna7CrolGbZgTUQa6sZ3fucpjYl/RR9ptPDRzU4IHYnjgsHDPev/qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389300; c=relaxed/simple;
	bh=clA8Q6iteJ2aHysBAKf6g+LCjMb4D9QuEE6AvsFN8FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QM3/1vrnTiSNVejm4wwqh2nxjpAHyT0myetxFa4AJjr3oMiZ7Ic/yJ8ex2PJCHAS/8fgM81MImiBAmV+yIFf97/qWxkyPpLskWliGY3fHVy/25oSMR06yPcwPTmOljU+lYgrYuxeSVVFGjXl61iyT0K26yyrEfRvw6eEi062qBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=m71BdAeP; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="m71BdAeP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788389283; x=1788994083; i=quwenruo.btrfs@gmx.com;
	bh=clA8Q6iteJ2aHysBAKf6g+LCjMb4D9QuEE6AvsFN8FM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=m71BdAePSXbItwOhOhtcjofmK7Ix2puAUYcbJ3+18znMDH+NrF0ZfjRIDjsmoJDM
	 KDaiEIrlqUVUW9dRAi/HUHYmDs1lghCyp21n3kRcJuY1SPKbuCvjZ9NrptTBAjzsl
	 8EbXkBoxuMVpt04/hg2cDbDYaLWv4LkMEPIaM4iPWinHbUvKF0cZr9lyDRzY0Bmzs
	 ddltJ2d2oRDxPOQWzKf7Hepgi7maQJc/PeBTnuzJswzLk1f38nVNNhALz8Xliq6w8
	 Z5eG38w/9Xg+JwVsT+FopO9c+gq6i0esWC7kDawuLEUH1U/0VzS7Luqt4IMWSUTDr
	 KAc5Jh/tKlRdA470ZA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mkpf3-1wb3NN3fPL-00kv3o; Thu, 03
 Sep 2026 00:48:03 +0200
Message-ID: <37793d4b-d10d-49d5-8269-1e21fa312be0@gmx.com>
Date: Thu, 3 Sep 2026 08:17:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: consume the given iter directly instead of
 copying in csum_one_bio()
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qu Wenruo <wqu@suse.com>
References: <20260902165137.3781696-1-neelx@suse.com>
 <20260902165137.3781696-2-neelx@suse.com>
 <afeb40a2-5996-4e36-bcc6-db8c7973db7f@gmx.com>
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
In-Reply-To: <afeb40a2-5996-4e36-bcc6-db8c7973db7f@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DktEv/HtmLiyCVGNuUf5gHQL31FFafFMLwbj39I3cywUp7+QxT+
 htvJW56NJLoVDC+j6q/EScoTFcnTPmSUH+LoPGg0WeObhv5A65y0mt0xNOxFooMsHL91Ykm
 GdCFtGL4ryG1u7eN79yZ2RxSPK5Bna8po4vS1m+K+Jh74WA3Pl8a4k69JnzF+XmKu5si1vC
 s8NIQCuacjSkKHP+j97KQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:GwvU+kYv2TA=;mUvNREHzJH19lgsBYLxtIhD2qlY
 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
 fhAhzbY6KVw=



=E5=9C=A8 2026/9/3 07:21, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/9/3 02:21, Daniel Vacek =E5=86=99=E9=81=93:
>> This is just a small cleanup to avoid copying the iter twice in async=
=20
>> case.
>> We already have a copy csum_one_bio() can consume directly. No need to=
=20
>> copy
>> again the second time.
>> In the sync case we can copy in the caller (as we did before dd57c78aec=
39
>> ("btrfs: introduce btrfs_bio::async_csum")).
>>
>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>> ---
>> =C2=A0 fs/btrfs/file-item.c | 14 +++++++-------
>> =C2=A0 1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>> index 581ca5653be9..5a5cffb18922 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -797,18 +797,16 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root=
=20
>> *root, struct btrfs_path *path,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> -static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src=
)
>> +static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *ite=
r)
>=20
> Since we're here, what about adding const prefix to iter?

My bad, we're advancing the iter, so it can not be const.

>=20
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_inode *inode =3D bbio->inod=
e;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D inode-=
>root->fs_info;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ordered_sum *sums =3D bbio-=
>sums;
>> -=C2=A0=C2=A0=C2=A0 struct bvec_iter iter;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D fs_info->sectors=
ize;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int index =3D 0;
>> -=C2=A0=C2=A0=C2=A0 for (iter =3D *src; iter.bi_size; bio_advance_iter(=
&bbio->bio,=20
>> &iter, blocksize)) {
>=20
> I'm thinking the opposite way.
>=20
> What about still keeping a local bvec_iter copy, but remove=20
> csum_saved_iter completely?
>=20
> Since at bio calculation time, the bio is not yet submitted, so the=20
> csum_saved_iter always match bio.bi_iter.
>=20
> I think removing csum_saved_iter would also reduce the size of btrfs_bio=
.

My bad, this won't work.

During csum calculation the bio can be submitted already, thus its=20
bio::bi_iter is no longer reliable.

And since it's a data write, we do not have bbio::saved_iter to utilize=20
either.

Now it looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_csum_one_bio_block(fs=
_info, &bbio->bio, &iter,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sums->sums + index);
>> +=C2=A0=C2=A0=C2=A0 for (; iter->bi_size; bio_advance_iter(&bbio->bio, =
iter,=20
>> blocksize)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_csum_one_bio_block(fs=
_info, &bbio->bio, iter, sums-=20
>> >sums + index);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index +=3D fs_in=
fo->csum_size;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> @@ -851,12 +849,14 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio,=20
>> bool async)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_add_ordered_sum(ordered, sums);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!async) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 csum_one_bio(bbio, &bbio->b=
io.bi_iter);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bvec_iter iter =3D b=
io->bi_iter;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 csum_one_bio(bbio, &iter);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_completion(&bbio->csum_done);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bbio->async_csum =3D true;
>> -=C2=A0=C2=A0=C2=A0 bbio->csum_saved_iter =3D bbio->bio.bi_iter;
>> +=C2=A0=C2=A0=C2=A0 bbio->csum_saved_iter =3D bio->bi_iter;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 INIT_WORK(&bbio->csum_work, csum_one_bio=
_work);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 schedule_work(&bbio->csum_work);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>=20

