Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E73876A9;
	Mon,  7 Sep 2026 06:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762582; cv=none; b=fRh0m5PMtjVbftwpHaacnGhyidn/P3nTZdaaVpyj79/KegVF2FtFSwRC9DFohQhlUjGd3JtpH0ntjKBt2Xz5BSFz40BjMXY8643rBb77lSfVh3hza6ClAtDTvogKndjj634IKp6o7J2HXmhpNWCCYEsIOnIyZB0yDqqh5P7Ez2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762582; c=relaxed/simple;
	bh=S6D0FE4Se/ruzpUXLSU6J/AaHfk2ITGOCyVV5lskCMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDwanJAB64HqS2eVuaQfKquDnDs2sUhNWKeWgXaIhrpKW80ULwpnEQwVhUd0Fm1m90ZEG9gVqwtlWfc0i2c18D8qSyngCw+2IbUjku4JY8Rs0xoTKN08KY1p8L0XszCCpho5W79lmXuoIdjdPMIxDTrCOK+nPyq4IbGB8Bdunbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=OULw+Da2; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="OULw+Da2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788762574; x=1789367374; i=quwenruo.btrfs@gmx.com;
	bh=t6DtV5JOlgzM1Je24mA4EjdIv+XGNsRWxN7U0Z+sWD0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OULw+Da2P3grhRk+1JOwagbw3qEvfSm0KWii46clDpoMUfbBg4i6gcxfUmzKAD2V
	 vJli4qvK8nXUNngcqqNQwrHpfsci8jzN88e9IKq0PnPKi7YiIJKfkoThCZ31CStD7
	 CUfD8yR/C6SD1JCxx/rL9LJ/ID4BqNHgQ6J2klNylRYa0oioymb/FYKa1MC0tEv9e
	 2LQE5NH9iGo7QyAyXLS/6DpT4NKkY/76HSLI/grP7uvuot+IeBAoeFgCThXFD13Xj
	 khjJg/qHlcoAik6DQ1dLo44RQt31abdJjwGrOCGkiLT9VLebaYCGlPD9XFkBwFMtj
	 Kl1BLvBQAx0iud+LXA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M5fIW-1wwI7j1ORu-008Xrb; Mon, 07
 Sep 2026 08:29:34 +0200
Message-ID: <631c8d65-417a-40ed-af3b-c3a93b4b681c@gmx.com>
Date: Mon, 7 Sep 2026 15:59:27 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] btrfs: tests: convert test_find_delalloc() to use
 folios
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-2-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-2-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cEm6rZyTF5O+Xv3mob+VI233YD79Lw1q+EhvwcQdrmBrZgzMilb
 CybmxFCpwJzH+WBv4TEEY9f1AQdlvZIUocxAexH+1Y/nywHLfvUBlt/vBkq3V8JiUVlBR5w
 xNuaovSOZmxvCzG/MvlrL/Bk+C0dQC7NREFygHGv20xmyzriitbAz45g6kdFLT5bsyZ806w
 emSvnH3qMDTTQBhVgyw6Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CjUSBINhAF0=;nT0GvguScprDCILRF15m9qXYxhv
 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
 Il01aNpxD9wWy6+8uCCF5eKxTVxJrf0YUvg==



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> This removes the last btrfs callers of find_or_create_page(),
> find_lock_page(), SetPageDirty(), ClearPageDirty(), and get_page(), and
> 15 calls to compound_head(). The folio lookups return an ERR_PTR instead
> of NULL, so adjust the error handling.
>=20
> Update the comments and test messages accordingly.

I think the interface change itself is fine, although still some minor=20
concerns inlined below.
>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>   fs/btrfs/tests/extent-io-tests.c | 94 ++++++++++++++++++++------------=
=2D-------
>   1 file changed, 46 insertions(+), 48 deletions(-)
>=20
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io=
-tests.c
> index 6eb55bfb2bd4..3056dd934b54 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -112,8 +112,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   	struct btrfs_root *root =3D NULL;
>   	struct inode *inode =3D NULL;
>   	struct extent_io_tree *tmp;
> -	struct page *page;
> -	struct page *locked_page =3D NULL;
> +	struct folio *folio;
> +	struct folio *locked_folio =3D NULL;
>   	/* In this test we need at least 2 file extents at its maximum size *=
/
>   	u64 max_bytes =3D BTRFS_MAX_EXTENT_SIZE;
>   	u64 total_dirty =3D 2 * max_bytes;
> @@ -152,23 +152,24 @@ static int test_find_delalloc(u32 sectorsize, u32 =
nodesize)
>   	btrfs_extent_io_tree_init(NULL, tmp, IO_TREE_SELFTEST);
>  =20
>   	/*
> -	 * First go through and create and mark all of our pages dirty, we pin
> -	 * everything to make sure our pages don't get evicted and screw up ou=
r
> +	 * First go through and create and mark all of our folios dirty, we pi=
n
> +	 * everything to make sure our folios don't get evicted and screw up o=
ur
>   	 * test.
>   	 */
>   	for (pgoff_t index =3D 0; index < (total_dirty >> PAGE_SHIFT); index+=
+) {
> -		page =3D find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
> -		if (!page) {
> -			test_err("failed to allocate test page");
> -			ret =3D -ENOMEM;
> +		folio =3D __filemap_get_folio(inode->i_mapping, index,
> +				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);

No matter if it's the older or newer code, it's not exactly following=20
the real kernel behavior.

We're relying on the fact that the test inode doesn't have a folio order=
=20
range set, thus we always get page size folios.
> +		if (IS_ERR(folio)) {
> +			test_err("failed to allocate test folio");
> +			ret =3D PTR_ERR(folio);
>   			goto out;
>   		}
> -		SetPageDirty(page);
> +		folio_set_dirty(folio);

We only need to update the folio flags, no need to bother the possible=20
bitmaps for bs < ps cases, or large folio cases exactly because we=20
always get page sized folio, and for now the test case only handles bs=20
=3D=3D ps cases.

I'm not pushing for using btrfs_folio_set_dirty() helpers immediately,=20
but an "ASSERT(folio_order(folio) =3D=3D 0);" would be a little safer.

>   		if (index) {
> -			unlock_page(page);
> +			folio_unlock(folio);
>   		} else {
> -			get_page(page);
> -			locked_page =3D page;
> +			folio_get(folio);
> +			locked_folio =3D folio;
>   		}
>   	}
>  =20
> @@ -179,8 +180,7 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   	btrfs_set_extent_bit(tmp, 0, sectorsize - 1, EXTENT_DELALLOC, NULL);
>   	start =3D 0;
>   	end =3D start + PAGE_SIZE - 1;
> -	found =3D find_lock_delalloc_range(inode, page_folio(locked_page), &st=
art,
> -					 &end);
> +	found =3D find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("should have found at least one delalloc");
>   		goto out_bits;
> @@ -191,8 +191,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
> -	unlock_page(locked_page);
> -	put_page(locked_page);
> +	folio_unlock(locked_folio);
> +	folio_put(locked_folio);
>  =20
>   	/*
>   	 * Test this scenario
> @@ -201,17 +201,17 @@ static int test_find_delalloc(u32 sectorsize, u32 =
nodesize)
>   	 *           |--- search ---|
>   	 */
>   	test_start =3D SZ_64M;
> -	locked_page =3D find_lock_page(inode->i_mapping,
> -				     test_start >> PAGE_SHIFT);
> -	if (!locked_page) {
> -		test_err("couldn't find the locked page");
> +	locked_folio =3D filemap_lock_folio(inode->i_mapping,
> +					  test_start >> PAGE_SHIFT);
> +	if (IS_ERR(locked_folio)) {
> +		test_err("couldn't find the locked folio");
> +		locked_folio =3D NULL;
>   		goto out_bits;
>   	}
>   	btrfs_set_extent_bit(tmp, sectorsize, max_bytes - 1, EXTENT_DELALLOC,=
 NULL);
>   	start =3D test_start;
>   	end =3D start + PAGE_SIZE - 1;

The same here, the range only works if the folio is page sized.

Thus an ASSERT() would be preferred for every range that is still based=20
on PAGE_SIZE.

Otherwise looks good to me.

Thanks,
Qu

> -	found =3D find_lock_delalloc_range(inode, page_folio(locked_page), &st=
art,
> -					 &end);
> +	found =3D find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("couldn't find delalloc in our range");
>   		goto out_bits;
> @@ -223,12 +223,12 @@ static int test_find_delalloc(u32 sectorsize, u32 =
nodesize)
>   	}
>   	if (process_folio_range(inode, start, end,
>   				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> -		test_err("there were unlocked pages in the range");
> +		test_err("there were unlocked folios in the range");
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
> -	/* locked_page was unlocked above */
> -	put_page(locked_page);
> +	/* locked_folio was unlocked above */
> +	folio_put(locked_folio);
>  =20
>   	/*
>   	 * Test this scenario
> @@ -236,16 +236,16 @@ static int test_find_delalloc(u32 sectorsize, u32 =
nodesize)
>   	 *                    |--- search ---|
>   	 */
>   	test_start =3D max_bytes + sectorsize;
> -	locked_page =3D find_lock_page(inode->i_mapping, test_start >>
> -				     PAGE_SHIFT);
> -	if (!locked_page) {
> -		test_err("couldn't find the locked page");
> +	locked_folio =3D filemap_lock_folio(inode->i_mapping,
> +					  test_start >> PAGE_SHIFT);
> +	if (IS_ERR(locked_folio)) {
> +		test_err("couldn't find the locked folio");
> +		locked_folio =3D NULL;
>   		goto out_bits;
>   	}
>   	start =3D test_start;
>   	end =3D start + PAGE_SIZE - 1;
> -	found =3D find_lock_delalloc_range(inode, page_folio(locked_page), &st=
art,
> -					 &end);
> +	found =3D find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (found) {
>   		test_err("found range when we shouldn't have");
>   		goto out_bits;
> @@ -265,8 +265,7 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   	btrfs_set_extent_bit(tmp, max_bytes, total_dirty - 1, EXTENT_DELALLOC=
, NULL);
>   	start =3D test_start;
>   	end =3D start + PAGE_SIZE - 1;
> -	found =3D find_lock_delalloc_range(inode, page_folio(locked_page), &st=
art,
> -					 &end);
> +	found =3D find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> @@ -278,36 +277,35 @@ static int test_find_delalloc(u32 sectorsize, u32 =
nodesize)
>   	}
>   	if (process_folio_range(inode, start, end,
>   				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
> -		test_err("pages in range were not all locked");
> +		test_err("folios in range were not all locked");
>   		goto out_bits;
>   	}
>   	btrfs_unlock_extent(tmp, start, end, NULL);
>  =20
>   	/*
> -	 * Now to test where we run into a page that is no longer dirty in the
> +	 * Now to test where we run into a folio that is no longer dirty in th=
e
>   	 * range we want to find.
>   	 */
> -	page =3D find_get_page(inode->i_mapping,
> -			     (max_bytes + SZ_1M) >> PAGE_SHIFT);
> -	if (!page) {
> -		test_err("couldn't find our page");
> +	folio =3D filemap_get_folio(inode->i_mapping,
> +				  (max_bytes + SZ_1M) >> PAGE_SHIFT);
> +	if (IS_ERR(folio)) {
> +		test_err("couldn't find our folio");
>   		goto out_bits;
>   	}
> -	ClearPageDirty(page);
> -	put_page(page);
> +	folio_clear_dirty(folio);
> +	folio_put(folio);
>  =20
>   	/* We unlocked it in the previous test */
> -	lock_page(locked_page);
> +	folio_lock(locked_folio);
>   	start =3D test_start;
>   	end =3D start + PAGE_SIZE - 1;
>   	/*
> -	 * Currently if we fail to find dirty pages in the delalloc range we
> +	 * Currently if we fail to find dirty folios in the delalloc range we
>   	 * will adjust max_bytes down to PAGE_SIZE and then re-search.  If
>   	 * this changes at any point in the future we will need to fix this
>   	 * tests expected behavior.
>   	 */
> -	found =3D find_lock_delalloc_range(inode, page_folio(locked_page), &st=
art,
> -					 &end);
> +	found =3D find_lock_delalloc_range(inode, locked_folio, &start, &end);
>   	if (!found) {
>   		test_err("didn't find our range");
>   		goto out_bits;
> @@ -319,7 +317,7 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   	}
>   	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
>   				PROCESS_UNLOCK)) {
> -		test_err("pages in range were not all locked");
> +		test_err("folios in range were not all locked");
>   		goto out_bits;
>   	}
>   	ret =3D 0;
> @@ -328,8 +326,8 @@ static int test_find_delalloc(u32 sectorsize, u32 no=
desize)
>   		dump_extent_io_tree(tmp);
>   	btrfs_clear_extent_bit(tmp, 0, total_dirty - 1, (unsigned)-1, NULL);
>   out:
> -	if (locked_page)
> -		put_page(locked_page);
> +	if (locked_folio)
> +		folio_put(locked_folio);
>   	process_folio_range(inode, 0, total_dirty - 1,
>   			    PROCESS_UNLOCK | PROCESS_RELEASE);
>   	iput(inode);
>=20

