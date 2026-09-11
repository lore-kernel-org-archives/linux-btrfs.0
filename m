Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D45540E8CD
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 23:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789170287; cv=none; b=QyLchiZ9lg4c814TXnhYFXdlDGyw7oqKB43Q5cGNYgoBoPbjzOLzz6VnFD9Th7z0f1MNME4q83rZDQga8VkMSlO8r/upaUEF/iQNV3N9uB2eT8ilAN+q3/4O0YvG58aQKI/73wdElYcjMM6NhlWwBUckYbl4DqyvhezsNxh3BpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789170287; c=relaxed/simple;
	bh=3xJjQP7CqekPMDNqLNNM9Zh9TRpBwk+xKRJP3QfsjVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lINYhJGdnRa2/xsA6eUODjghkIhPFWImeq1rP+LZUjkKO0rmhDMADWafgSlfC7h8kGwYoc9t9y0YrYhY4N9lr3T8G0byDQA/SdbR7o/SRc0NXfO1MhJKky/HSU7HoWhzQ5nijjL19VXUA4WK6l0z/vyxp099pcOpIU4ofTEmM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=g74Z4Fhj; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="g74Z4Fhj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789170277; x=1789775077; i=quwenruo.btrfs@gmx.com;
	bh=GmrlSkJQKkceRIVczKMPa4JAM03x7hZ0flKkJiW2qSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=g74Z4FhjKmtxHovU7BNNzfb+GoABjiXIqauVyf9ckx4hP0zKSkC1kFeDCySdUVJj
	 rYTZIxMKtr7ADR1c1VIv+L1Iub4l4p191AzGKUMyEE0o/72rsNn73/GmVNj68gUGt
	 gRabK9YlDCTMYG6WuK7WaXKE6bpV1swttQnrEKXw7SU7pM6Cznz9HY7OAY3s2zzjZ
	 qNnAGvz9nybgKpTAefzN2kYzVgsVnVHM47ZSx5O+H7tTN4PjgfxaXsZPjnaXGkx+E
	 w+BCeP3hyVq4k7UrUl0gVakZmKaHfspW4ruh+Lm+HNCgab5tD6p2n7OYB6WFO1A3d
	 UAsVxqZErloI0nAl9A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MRTN9-1xQPCa0Irt-00PZbm; Sat, 12
 Sep 2026 01:44:37 +0200
Message-ID: <dcdc63bc-13ce-47cf-9928-3a02862663ff@gmx.com>
Date: Sat, 12 Sep 2026 09:14:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: tree-checker: cache accessor return value in
 CHECK_FE_ALIGNED()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <bfbeb06553e40d94aadfe5490f2749b3e43bc83f.1789143253.git.fdmanana@suse.com>
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
In-Reply-To: <bfbeb06553e40d94aadfe5490f2749b3e43bc83f.1789143253.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kzs2YyLiIPTFpRbkaEpjW6KN3zZotHgBAs0ci7Rb3SgYPplaRqn
 Jv0TkjsgoCDKdVNGHerLncwPToAySvAPqqFxF0vzIuijlRJVSDKzwcQmU3qVmQwVUXgslni
 mUFrPGiMGwwGXkpYUfwT/YpD8JD0/DjhrHZuT3q2uNXGSy2rIXx8110bqskF+rx6JH+FLNK
 d4/OIar9+NltHzTdiJRzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:55S6ZH4EnQQ=;TcZLDNTySNJT8KUj82cupCDi7wc
 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



=E5=9C=A8 2026/9/12 01:45, fdmanana@kernel.org =E5=86=99=E9=81=93:
> From: Filipe Manana <fdmanana@suse.com>
>=20
> We are calling an accessor for a file extent item multiple times in the
> CHECK_FE_ALIGNED() macro, even when we don't find a corruption (once in
> the if statement's expression and then once again in the expression for
> the return value). This adds extra runtime overhead (which is critical
> since the tree checker runs against every extent buffer when it's read
> or before persisting it) and increases the module's size.
>=20
> So cache the accessor's return value in a variable and use it, reducing
> runtime, object size and making the source code shorter too. Also avoid
> repeating twice the IS_ALIGNED() computation.
>=20
> Before:
>=20
>    $ size fs/btrfs/btrfs.ko
>       text	   data	    bss	    dec	    hex	filename
>    2073340	 217928	  15624	2306892	 23334c	fs/btrfs/btrfs.ko
>=20
> After:
>=20
>    $ size fs/btrfs/btrfs.ko
>       text	   data	    bss	    dec	    hex	filename
>    2073076	 217928	  15624	2306628	 233244	fs/btrfs/btrfs.ko
>=20
> Also running the following fsstress test and capturing the runtime of
> check_extent_data_item() (the only caller of CHECK_FE_ALIGNED()) in
> nanoseconds (using bpftrace), showed the following runtime improvements:
>=20
> Test:
>=20
>    mkfs.btrfs -f /dev/nullb0
>    mount /dev/nullb0 /mnt
>    fsstress -w -p 8 -n 5000 -s 12345 -d /mnt
>    umount /mnt
>=20
> Before:
>=20
>    Count: 2033671
>    Range:  0.000 - 1336060.000; Mean: 679.642; Median: 656.000; Stddev: =
2031.323
>    Percentiles:  90th: 850.000; 95th: 909.000; 99th: 1272.000
>       0.000 -    6.647:      11 |
>       6.647 -   28.241:      36 |
>      28.241 -  110.807:     176 |
>     110.807 -  426.512:   38012 #
>     426.512 - 1633.663: 1983372 ########################################=
#############
>    1633.663 - 6249.399:    8315 |
>    6249.399 - 23898.422:   3243 |
>    23898.422 - 91382.340:   153 |
>    91382.340 - 349418.114:   36 |
>    349418.114 - 1336060.000: 11 |
>=20
> After:
>=20
>    Count: 2092797
>    Range:  0.000 - 1677284.000; Mean: 627.650; Median: 617.000; Stddev: =
1848.010
>    Percentiles:  90th: 809.000; 95th: 859.000; 99th: 1209.000
>       0.000 -    6.823:       18 |
>       6.823 -   29.602:       82 |
>      29.602 -  118.702:      416 |
>     118.702 -  467.232:   515774 #################
>     467.232 - 1830.549:  1565599 #######################################=
##############
>    1830.549 - 7163.339:     5297 |
>    7163.339 - 28023.237:    4186 |
>    28023.237 - 109619.427:   166 |
>    109619.427 - 428793.471:   25 |
>    428793.471 - 1677284.000:   4 |
>=20
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/tree-checker.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 857ded43c3b9..081365770c51 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -108,13 +108,14 @@ static void file_extent_err(const struct extent_bu=
ffer *eb, int slot,
>    */
>   #define CHECK_FE_ALIGNED(leaf, slot, fi, name, alignment)		      \
>   ({									      \
> -	if (unlikely(!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)),      =
\
> -				 (alignment))))				      \
> +	const u64 val =3D btrfs_file_extent_##name((leaf), (fi));             =
  \
> +	const bool not_aligned =3D !IS_ALIGNED(val, (alignment));		      \
> +									      \
> +	if (unlikely(not_aligned))			      		      \
>   		file_extent_err((leaf), (slot),				      \
>   	"invalid %s for file extent, have %llu, should be aligned to %u",    =
 \
> -			(#name), btrfs_file_extent_##name((leaf), (fi)),      \
> -			(alignment));					      \
> -	(!IS_ALIGNED(btrfs_file_extent_##name((leaf), (fi)), (alignment)));   =
\
> +			(#name), val, (alignment));			      \
> +	not_aligned;			                                      \
>   })
>  =20
>   static u64 file_extent_end(struct extent_buffer *leaf,

