Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38DD3EDE7E
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2026 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788385466; cv=none; b=KwKvjD+V1Z6gdsWkSHAjtvGDFferivQB8wC78IfaMj2Cyiu3BYtbDf/PjMwKOwvMs9qucMbzMSolGMxftDbh3tgQhoGVVDiyYmJUCy2/XQrzcQxPgWhRGJg2k/yFq+1WtsNDni0hhGS9KdRSRc+0MFZUxBEBrFaI3kwH1NwMyVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788385466; c=relaxed/simple;
	bh=nPuPQFvwAKuQ0qHVSfBS7Ws6X1P9TeUAk5fPZCuckKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpZZ7+zZn+2WX3NpvFHAc+yDma/9zBFhakNCvQO3OqPH2U+Usloh5sM/RzT9NmaGKbitl96lFu2gnwdSu4y/O5ZWSMXIsWCeZLNDRVMjm0e9n5SS5EgS9ybKgbjbmLm8YxvpTxQmZz6PNMyn2LQs+n2G6PLn1duF39lzNnmC1BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=mAiD5Dhl; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="mAiD5Dhl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788385452; x=1788990252; i=quwenruo.btrfs@gmx.com;
	bh=eJPXfX21moEkKFTQLdVFRORPnYrKphmBPjgU07p2EJs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mAiD5DhlsE9Yh9RtMW/2MofDUgABeYacsZy/hpSi76C14TBEQmcU7EGFx9IuuS6g
	 WUGHX4SzmR65P/81jGj4c6Nxje6IMKYBLyzVOglDR+djU+rgGkCG6yX2w5iOaZbZx
	 H6bQ0y6Hb/3jyYuKZyySZx2fxn/8l0NkPP75OdOW9TjpLVzFdMTJCiW471a7lviQ+
	 D2iPSQnj+qvcvIN7yoGO9QjzetspSFe1oW0D8UdomA5wim140UXnfQ1M/V5a+eVJY
	 EJzGdq1U1Kf3eUeWUH9YXZfapTQxhN8O1nm78A014IR0DGadhJw1/5dcwEZK3vTgz
	 0NT4e280XALiAlKbLg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MTzay-1xSw4v0shW-00SRHl; Wed, 02
 Sep 2026 23:44:11 +0200
Message-ID: <ea64c701-f488-4cca-ab2d-59c45a2b3604@gmx.com>
Date: Thu, 3 Sep 2026 07:14:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: use ordered extent to grab the logical address
 for submission
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
References: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
 <CAPjX3Ffo1jF0=u3atBr+mdco=aYFGU5GWQ6FNtuzgFUQEMvHdQ@mail.gmail.com>
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
In-Reply-To: <CAPjX3Ffo1jF0=u3atBr+mdco=aYFGU5GWQ6FNtuzgFUQEMvHdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8eepWesJKs2qEl9rOyQjTJswpQdXNh5NxPk2F4ubyI1IhE26FDQ
 hZKsSdMqplolCqBd6JXY6aeXSoS3g1Wz18h0fEI4MOnOgGVpPDg3gE5y/497KA8E9eYmjcY
 jtxFlkj+7GRpleaf+l2ouAZjT2aQ//id4hjNbVLMEOPFpJovKu1jrPGGhnc229EZvXv0o39
 MSEOWRnFFvCEVNwrsMEyg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:e158PHYb2yQ=;CdiqXcHot/Grxnqffogv9cNcAm6
 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



=E5=9C=A8 2026/9/3 03:53, Daniel Vacek =E5=86=99=E9=81=93:
> On Tue, 1 Sept 2026 at 02:02, Qu Wenruo <wqu@suse.com> wrote:
>> In submit_one_sector() we call btrfs_get_extent() to grab the IO extent
>> map so that we know where the logical location to submit the block.
>>
>> However there is no guarantee that there is an IO extent map for the
>> block, and if there is no IO extent map nor ordered extent,
>> btrfs_get_extent() can grab the file extent from on-disk metadata.
>>
>> That's why we have ASSERT()s to reject holes and compressed file
>> extents.
>>
>> On the other hand, for the write range we should have both an IO extent
>> map and an ordered extent, so there is no reason not to grab the ordere=
d
>> extent instead.
>>
>> There is some minor advantages:
>>
>> - No hole ordered extent
>>    So no need to rely on ASSERT()s to reject hole extents.
>>
>>    And the ASSERT()s are depending on the kernel config, without
>>    CONFIG_BTRFS_ASSERT those ASSERT()s won't even trigger.
>>
>> - No IO errors
>>    Unlike btrfs_get_extent() which can return IO error when doing the
>>    metadata tree search, btrfs_lookup_ordered_extent() will either retu=
rn
>>    an OE or not found.
>>
>> - Cached OE in bio_ctrl->bbio
>>    At bbio allocation we have already did an OE lookup, and we have a
>>    high chance that the current block also belongs to that OE.
>>    Use that cached OE can reduce the frequency to do an rb-tree search.
>>
>> - Smaller rb-tree
>>    Unlike extent-map-tree, which can contain cached extent maps, the li=
fe
>>    span of ordered extents are much shorter, they get removed from the
>>    ordered tree after the file extent item is inserted into the subvolu=
me
>>    tree.
>>
>>    So doing ordered extent tree search can be a tiny faster.
>>
>> And since we're here, also address some minor points:
>>
>> - Add error message for every EUCLEAN error
>>
>> - Remove a dead comment on btrfs_folio_clear_dirty()
>>    We no longer call folio_clear_dirty_for_io() since commit 095be159f3=
eb
>>    ("btrfs: unify folio dirty flag clearing"), so the folio flag is
>>    still dirty, and the folio dirty flag will be cleared by the last di=
rty
>>    block.
>>
>> Reviewed-by: Boris Burkov <boris@bur.io>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> ---
>> Changelog:
>> v3:
>> - Refactor the helper to grab the OE and increase its refs in one go
>>
>> v2:
>> - Extract a helper to determine if the @filepos is in the bbio OE range
>>    Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
>>    in_range() to make is easier to read.
>> ---
>>   fs/btrfs/extent_io.c | 64 +++++++++++++++++++++++++++----------------=
-
>>   1 file changed, 40 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index d7600e5fa3d9..a221b63bdb20 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -1808,6 +1808,22 @@ static noinline_for_stack int writepage_delalloc=
(struct btrfs_inode *inode,
>>          return 0;
>>   }
>>
>> +static struct btrfs_ordered_extent *get_oe_from_bbio(const struct btrf=
s_bio *bbio,
>> +                                                    u64 filepos)
>> +{
>> +       struct btrfs_ordered_extent *oe;
>> +
>> +       if (!bbio || !bbio->ordered)
>> +               return NULL;
>> +
>> +       oe =3D bbio->ordered;
>> +       if (!in_range(filepos, oe->file_offset, oe->num_bytes))
>> +               return NULL;
>> +
>> +       refcount_inc(&oe->refs);
>=20
> Thinking about it again, do we even need to raise the refcount?

That is to co-operate with that btrfs_put_ordered_extent().


>=20
> One reference is already held by the bbio itself, so the lifetime is gua=
ranteed.
>=20
>> +       return oe;
>> +}
>> +
>>   /*
>>    * Return 0 if we have submitted or queued the sector for submission.
>>    * Return <0 for critical errors, and the involved sector will be cle=
aned up.
>> @@ -1820,11 +1836,10 @@ static int submit_one_sector(struct btrfs_inode=
 *inode,
>>                               loff_t i_size)
>>   {
>>          struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>> -       struct extent_map *em;
>> +       struct btrfs_ordered_extent *oe;
>>          u64 block_start;
>>          u64 disk_bytenr;
>>          u64 extent_offset;
>> -       u64 em_end;
>>          const u32 sectorsize =3D fs_info->sectorsize;
>>          unsigned int queued;
>>
>> @@ -1833,8 +1848,11 @@ static int submit_one_sector(struct btrfs_inode =
*inode,
>>          /* @filepos >=3D i_size case should be handled by the caller. =
*/
>>          ASSERT(filepos < i_size);
>>
>> -       em =3D btrfs_get_extent(inode, NULL, filepos, sectorsize);
>> -       if (IS_ERR(em)) {
>> +       /* Try to reuse the existing OE from bbio first. */
>> +       oe =3D get_oe_from_bbio(bio_ctrl->bbio, filepos);
>> +       if (!oe)
>          {
>> +               oe =3D btrfs_lookup_ordered_extent(inode, filepos);
>                  put =3D true; // or !!oe

I prefer not to introduce an extra if check just for a single case.

So the existing unconditional put and refcount inc for the OE from bbio=20
looks fine to me.

Thanks,
Qu


>          }
>> +       if (unlikely(!oe)) {
>>                  /*
>>                   * bio_ctrl may contain a bio crossing several folios.
>>                   * Submit it immediately so that the bio has a chance
>> @@ -1857,31 +1875,25 @@ static int submit_one_sector(struct btrfs_inode=
 *inode,
>>                   */
>>                  btrfs_mark_ordered_io_finished(inode, filepos, fs_info=
->sectorsize,
>>                                                 false);
>> -               return PTR_ERR(em);
>> +               btrfs_err_rl(fs_info,
>> +               "no ordered extent for root %lld ino %llu filepos %llu"=
,
>> +                            btrfs_root_id(inode->root), btrfs_ino(inod=
e),
>> +                            filepos);
>> +               return -EUCLEAN;
>>          }
>>
>> -       extent_offset =3D filepos - em->start;
>> -       em_end =3D btrfs_extent_map_end(em);
>> -       ASSERT(filepos <=3D em_end);
>> -       ASSERT(IS_ALIGNED(em->start, sectorsize));
>> -       ASSERT(IS_ALIGNED(em->len, sectorsize));
>> +       extent_offset =3D filepos - oe->file_offset;
>> +       ASSERT(filepos < oe->file_offset + oe->num_bytes);
>> +       ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
>> +       ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
>> +       ASSERT(oe->compress_type =3D=3D BTRFS_COMPRESS_NONE);
>> +       ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
>>
>> -       block_start =3D btrfs_extent_map_block_start(em);
>> -       disk_bytenr =3D btrfs_extent_map_block_start(em) + extent_offse=
t;
>> +       block_start =3D oe->disk_bytenr + oe->offset;
>> +       disk_bytenr =3D block_start + extent_offset;
>>
>> -       ASSERT(!btrfs_extent_map_is_compressed(em));
>> -       ASSERT(block_start !=3D EXTENT_MAP_HOLE);
>> -       ASSERT(block_start !=3D EXTENT_MAP_INLINE);
>=20
>          if (put)
>=20
>> +       btrfs_put_ordered_extent(oe);
>>
>> -       btrfs_free_extent_map(em);
>> -       em =3D NULL;
>> -
>> -       /*
>> -        * Although the PageDirty bit is cleared before entering this
>> -        * function, subpage dirty bit is not cleared.
>> -        * So clear subpage dirty bit here so next time we won't submit
>> -        * a folio for a range already written to disk.
>> -        */
>>          btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
>>          btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize)=
;
>>          /*
>> @@ -1898,6 +1910,10 @@ static int submit_one_sector(struct btrfs_inode =
*inode,
>>                  btrfs_folio_clear_writeback(fs_info, folio, filepos, s=
ectorsize);
>>                  btrfs_mark_ordered_io_finished(inode, filepos, fs_info=
->sectorsize,
>>                                                 false);
>> +               btrfs_err_rl(fs_info,
>> +               "failed to queue sector for root %lld ino %llu filepos =
%llu",
>> +                            btrfs_root_id(inode->root),
>> +                            btrfs_ino(inode), filepos);
>>                  return -EUCLEAN;
>>          }
>>          return 0;
>> --
>> 2.55.0
>>
>>
>=20

