Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383A54CC28B
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 22:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288096; cv=none; b=iZOavNNXwobJhUI4TEplKewMkHLuq1srayKg+shj3aB6FVaE+F2WmLr+wEJqNXdGG1uO3t+nTNXCXWZgDGIgbAhKlPX6nASlfKRIFxmsIm//jILQClVBQRux8nzs9GT1hXY4raY4dleMQWDlU3DAGS+5Rsm6q/GBh+Nn0fYlZLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288096; c=relaxed/simple;
	bh=GTAJJYP54EGkFksbONGyh/9W0GZ08KZZFRxEXyNuvIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J9jWlNHCkrTxAKd5eaWkhkXjE8UJLUWguL/BTkp82BvEefZOJziDcWGOsnD/E+hHMUWykA/rZsfIYI59BP0ysGpRUuh/69Pg2E/n7ZvIlCmsQwSZb96Z1RI5LxUNSs5Cr6TVJizAnLVUC+Fn05U+vS9iYHO0oUxGR/BCJv0QZiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=h/7sr/dv; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="h/7sr/dv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1790288087; x=1790892887; i=quwenruo.btrfs@gmx.com;
	bh=1PZpNCzlN0ma3Rpa5UiSmIlIAKfVg/wQlSc7mkGauS4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=h/7sr/dvkcVrETxgDAQGDin5Y5i8KUzrNQEt0QSv+CV9sa0SlL3mgmeLtYUVNnWd
	 Aj7oYm5LA/KvylPlGgGH3+ByPJMo6ISrhLI+n8/uxzHhep9Oyr5xoZgLhBnam4cpE
	 79QrDbaI6w61h66Xlhpc8E6iUU3dKgB5/oejc0DMLOUHlo2HVMxXWJxhN1fywp4yA
	 qAbM05QfY9OT2XTOW2+y1PAsCVs2y7jmAWUJ7HjOc+dcHnS9/fx9i6qRFxsb/ChK2
	 uGG0kAo+Gus28p7D63cv0kbRVPlk1P6NMoJX57o9Id2SOhx1IZVjihFN+G/cULgGQ
	 0b5o+zERymMu/XR4qQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N1Obb-1wlql32RVD-015BwR; Fri, 25
 Sep 2026 00:14:47 +0200
Message-ID: <7aeb8a6a-471f-4051-a1ab-b5741ad27b0f@gmx.com>
Date: Fri, 25 Sep 2026 07:44:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] btrfs: introduce compression for delayed bbio
To: Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1789687750.git.wqu@suse.com>
 <8836d526f71544e21557b428cc697b44dc060d62.1789687750.git.wqu@suse.com>
 <20260924173029.GB2146908@zen.localdomain>
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
In-Reply-To: <20260924173029.GB2146908@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SIbpcWjQ21HozlmHa8lfpnm9mAjNJPIzAJsZyIFhWDn97BBq/ji
 8Qxl9Hd0zE/w4CXi56HbN98Gl1CRsn1i9pZEB6Vc3YVx8BoSNDYzdMRyDHRkNdNr6ZYBEjD
 7b322f3z+3l8M+jwT+tEooB4NG1Lp90JOtrEO3w29sIk8k4fZo2eGqLGGTo4X68uwQmga+U
 8b/qR5q1BYXHAEnSDL2RQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gqb6GenX+UE=;e4ecO63Kd9Tu4pBYYbLTLvoc93r
 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
 t7ih



=E5=9C=A8 2026/9/25 03:00, Boris Burkov =E5=86=99=E9=81=93:
> On Fri, Sep 18, 2026 at 09:00:29AM +0930, Qu Wenruo wrote:
>> The compressed write path inside a delayed bbio is mostly the same as
>> regular compression, but with some differences:
>>
>> - The error handling should not touch folio flags
>>    It will be handled by the parent delayed bbio.
>>    And those folios already have WRITEBACK flag set, not the LOCKED fla=
g
>>    of the async submission path.
>>
>> - A successful compression will lead to a child compressed bio
>>    That compressed bio will be properly submitted, and if there are no
>>    more pending IOs of the delayed bbio, end the delayed bbio.
>>
>>    There is a minor note, since we're going through the regular
>>    extent_writepage_io() path, we can have multiple bbios for the same
>>    delayed ordered extent.
>>
>>    This means we may have a slightly lower compression ratio if for
>>    whatever reason the writeback path chooses to submit a smaller bio.
>>
>> - No sequential execution of data extent reservation
>>    The existing async thread has one quirk related to the ordered
>>    function execution, which is not suitable for this call site.
>>
>>    After the compressed bio is submitted, we can no longer touch the
>>    child compressed bio (it could finish immediately and also finish th=
e
>>    parent delayed bbio).
>>    Meanwhile the async ordered function needs different entries to hand=
le
>>    the workload and free involved structures.
>>
>>    These will be the major changes compared to the existing compressed
>>    write.
>>
>> - No extra blkcg/write flag inheritance
>>    This is a missing feature compared to the older async compression.
>>    This needs to be implemented in the future, but priority shouldn't b=
e
>>    that high.
>=20
> I believe there is reservation double counting, detailed inline.
>=20
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/inode.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++=
-
>>   1 file changed, 113 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 2d6a581d977b..fbc0e5426d45 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -7696,14 +7696,126 @@ struct extent_map *btrfs_create_delayed_em(str=
uct btrfs_inode *inode,
>>   	return em;
>>   }
>>  =20
>> +static void end_bbio_delayed_compressed(struct btrfs_bio *bbio)
>> +{
>> +	struct delayed_bio_private *dbp =3D bbio->private;
>> +	struct btrfs_bio *parent =3D dbp->delayed_bbio;
>> +	struct folio_iter fi;
>> +
>> +	bio_for_each_folio_all(fi, &bbio->bio)
>> +		btrfs_free_compr_folio(fi.folio);
>> +	btrfs_bio_end_io(parent, bbio->bio.bi_status);
>> +	bio_put(&bbio->bio);
>> +}
>> +
>> +static bool try_submit_compressed(struct btrfs_bio *parent)
>> +{
>> +	struct delayed_bio_private *dbp =3D parent->private;
>> +	struct btrfs_inode *inode =3D parent->inode;
>> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>> +	struct btrfs_key ins;
>> +	struct compressed_bio *cb;
>> +	struct extent_state *cached =3D NULL;
>> +	struct extent_map *em;
>> +	struct btrfs_ordered_extent *ordered;
>> +	struct btrfs_file_extent file_extent;
>> +	u64 alloc_hint;
>> +	const u32 len =3D bio_get_size(&parent->bio);
>> +	const u64 fileoff =3D parent->file_offset;
>> +	const u64 end =3D fileoff + len - 1;
>> +	u32 compressed_size;
>> +	int compress_type =3D fs_info->compress_type;
>> +	int compress_level =3D fs_info->compress_level;
>> +	int ret;
>> +
>> +	if (!btrfs_inode_can_compress(inode) ||
>> +	    !inode_need_compress(inode, fileoff, end, false))
>> +		return false;
>> +
>> +	if (inode->defrag_compress > 0 &&
>> +	    inode->defrag_compress < BTRFS_NR_COMPRESS_TYPES) {
>> +		compress_type =3D inode->defrag_compress;
>> +		compress_level =3D inode->defrag_compress_level;
>> +	} else if (inode->prop_compress) {
>> +		compress_type =3D inode->prop_compress;
>> +	}
>> +	cb =3D btrfs_compress_bio(inode, fileoff, len, compress_type,
>> +				compress_level, 0);
>> +	if (IS_ERR(cb))
>> +		return false;
>> +
>> +	round_up_last_block(cb, fs_info->sectorsize);
>> +	compressed_size =3D cb->bbio.bio.bi_iter.bi_size;
>> +	/* If no space is saved, abort and mark the inode NOCOMPRESS. */
>> +	if (compressed_size >=3D len) {
>> +		if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) &&
>> +		    !inode->prop_compress)
>> +			inode->flags |=3D BTRFS_INODE_NOCOMPRESS;
>> +		cleanup_compressed_bio(cb);
>> +		return false;
>> +	}
>> +
>> +	alloc_hint =3D btrfs_get_extent_allocation_hint(inode, fileoff, len);
>> +	ret =3D btrfs_reserve_extent(inode->root, len,
>> +				   compressed_size, compressed_size,
>> +				   0, alloc_hint, &ins, true, true);
>=20
> This consumes bytes_may_use and moves it to bytes_reserved
>=20
>> +	if (ret < 0) {
>> +		cleanup_compressed_bio(cb);
>> +		return false;
>> +	}
>> +	btrfs_lock_extent(&inode->io_tree, fileoff, end, &cached);
>> +	file_extent.disk_bytenr =3D ins.objectid;
>> +	file_extent.disk_num_bytes =3D ins.offset;
>> +	file_extent.ram_bytes =3D len;
>> +	file_extent.num_bytes =3D len;
>> +	file_extent.offset =3D 0;
>> +	file_extent.compression =3D cb->compress_type;
>> +
>> +	cb->bbio.bio.bi_iter.bi_sector =3D ins.objectid >> SECTOR_SHIFT;
>> +	em =3D btrfs_create_io_em(inode, fileoff, &file_extent, BTRFS_ORDERED=
_COMPRESSED);
>> +	if (IS_ERR(em)) {
>> +		ret =3D PTR_ERR(em);
>> +		goto out_free_reserve;
>> +	}
>> +	btrfs_free_extent_map(em);
>> +
>> +	ordered =3D btrfs_alloc_ordered_extent(inode, fileoff, &file_extent,
>> +					     1U << BTRFS_ORDERED_COMPRESSED);
>> +	if (IS_ERR(ordered)) {
>> +		btrfs_drop_extent_map_range(inode, fileoff, end, false);
>> +		ret =3D PTR_ERR(ordered);
>=20
> Now this fails with ENOMEM
>=20
>> +		goto out_free_reserve;
>> +	}
>> +	cb->bbio.ordered =3D ordered;
>> +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>> +	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
>> +
>> +	cb->bbio.end_io =3D end_bbio_delayed_compressed;
>> +	cb->bbio.private =3D dbp;
>> +	atomic_inc(&parent->pending_ios);
>> +	btrfs_submit_bbio(&cb->bbio, 0);
>> +	return true;
>> +
>> +out_free_reserve:
>> +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
>=20
> We free bytes_reserved, so bytes_may_use and bytes_reserved both no
> longer reflect the reservation.
>=20
>> +	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
>> +	btrfs_unlock_extent(&inode->io_tree, fileoff, end, &cached);
>> +	cleanup_compressed_bio(cb);
>> +	return false;
>=20
> And fallback to uncompressed submission in run_delayed_bbio() which
> calls btrfs_reserve_extent() again.

Right, and that's also why the old async submission do not fallback to=20
uncompressed submission.

The old code only fallback after a btrfs_reserve_extent() failure, but=20
treat later failures as regular errors.

So here we should also follow that behavior.

Thanks a lot for exposing this problem.
Qu

>=20
>> +}
>> +
>>   static void run_delayed_bbio(struct work_struct *work)
>>   {
>>   	struct delayed_bio_private *dbp =3D container_of(work, struct delaye=
d_bio_private, work);
>>   	struct btrfs_bio *parent =3D dbp->delayed_bbio;
>>  =20
>> -	/* Compressed and uncompressed fallback is not yet implemented. */
>> +	if (try_submit_compressed(parent))
>> +		goto finish;
>> +
>> +	/* Uncompressed fallback is not yet implemented. */
>>   	ASSERT(0);
>=20
> Sorry hard to reply across patches, but clearly it is still OK in this
> version :)
>=20
>>  =20
>> +finish:
>>   	/*
>>   	 * Any real compressed/uncompressed bios have increased
>>   	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
>> --=20
>> 2.55.0
>>
>=20

