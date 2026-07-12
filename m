Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C440C7478;
	Sun, 12 Jul 2026 03:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783826411; cv=none; b=CZwCYX1yO+ttl+DxgwdAV39HbTbX/UQ8My14tAG1Rd3Zp/Dit2kh9ojttQTLZLuZTRHjQT00OU40BTrxFshW7tl7RvoQDVUu9hMPf9mdjduewpLurTeWWG55X283UNaVV85L9LHqfeTylJdreP5Ad+M6mSZw+Qy7iPirZEAiIFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783826411; c=relaxed/simple;
	bh=FuWHsG3sVGS/NVkJBF8fqaLKQfK2a5JGul3KdP6bDxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QBAzJ3ZQOrWEDggvOYFPGOCkg6Z5GyCpDXr428f96x67pnry2c81JzlG0xYVnQB3+u+/ejtTa97Pop41J29I3isdr/TIlZRZWA+pV68eHPckio8nqMZEUhDLmSMGaWYmQP61YpDG2kSI9XVGd1JwEp+IC81Qm6hT1j+SYC0vTNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=la5RZxj+; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="la5RZxj+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783826402; x=1784431202; i=quwenruo.btrfs@gmx.com;
	bh=yhdoXrcZ0bm0hoSoruNxZxOHEolok4w0sjbe3ofbKA0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=la5RZxj+TGy5vs02NYcuXRADdZsf/6c1RcTRBFGR/OcMPPGUO0VVVf4kGsg8dnMF
	 ob/cbd4SYPLmHhF8QeWyZqrN0TYN9vY0QOkok9/06RITvl7fuYqG+O1W3rC8hp4NT
	 GIYrqOIkYbT/FFtydcgr3wVVFsA/P0HldOKygWjrtapbQ4b+mDXung2bmhYSql2dG
	 Y3W4skV+SMFp9fODBbXvWd/HzuQUBi8tUB7L1woyyxBw/YLMxWeL+qjtVEp7ztPID
	 0JlBecuMy9km6mXQR+YSPO/4TzklH9QLV/dSyItcHP/e2I8Cz2vL3YKcklhF7rgDS
	 cFy/sjmTFp4L30ojGA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M5wLT-1wfkbJ0BGF-0023Bs; Sun, 12
 Jul 2026 05:20:02 +0200
Message-ID: <7fdbed91-beb5-41c0-a181-e14a384c05b4@gmx.com>
Date: Sun, 12 Jul 2026 12:49:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: propagate errors from fast commit range replay
To: Guanghui Yang <3497809730@qq.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <tencent_39D68A519E8921206E77105E313354703C08@qq.com>
 <tencent_19048AD99E6321356E0F10A131F254603C08@qq.com>
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
In-Reply-To: <tencent_19048AD99E6321356E0F10A131F254603C08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6naCAIAjhDUc3h9NrHCw72xQ6NbKuUuMPYXpG/2w0SVszjf8YMI
 gNygYX9SQYY0evd8AJN53k3lkp9hXNkWkDeXiRqoSu6+mCYaGSMFuCs31D+bgT2RsANIHzX
 3l/ou1jmKU8Ri7j5JDEd8hWlj2pWNdLrSFSkdFrg0QcKdDdTfrE23L78gmbLzHVbn09qnQk
 DIizVbzQoN3Uj6EtN21DQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Plx15UqXTVk=;C4cPJrdhPd69we/LuuZkXsKu7dx
 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
 =



=E5=9C=A8 2026/7/12 12:41, Guanghui Yang =E5=86=99=E9=81=93:
> ext4_fc_replay() stops replaying fast commit tags only when a tag
> handler returns a negative error. However, ext4_fc_replay_add_range()
> and ext4_fc_replay_del_range() currently return 0 from their common
> exit paths even after internal failures.
>=20
> This hides errors from ext4_fc_record_modified_inode(),
> ext4_map_blocks(), ext4_find_extent(), ext4_ext_insert_extent(),
> ext4_ext_replay_update_ex(), and ext4_ext_remove_space(). As a result,
> a failed ADD_RANGE or DEL_RANGE replay can be treated as successful and
> the replay code may continue with subsequent fast commit tags.
>=20
> This is particularly problematic for DEL_RANGE because it may already
> have marked blocks as free before ext4_ext_remove_space() fails. If the
> error is swallowed, replay may continue from a partially applied range
> operation.
>=20
> Return the saved error from the common exit paths and make the
> ERR_PTR() cases in ADD_RANGE store PTR_ERR() before jumping to out.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Fixes: 57a304cfd43b ("btrfs: do not panic in __add_reloc_root")

WTF? Stop hallucinate, no matter if it's from LLM or yourself.

How could a ext4 commit related to btrfs?

> Signed-off-by: Guanghui Yang <3497809730@qq.com>
> ---
> Changes in v2:
> - Add Fixes tag for the commit that made the duplicate-insert error path=
 reachable.
>=20
>   fs/ext4/fast_commit.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 8e2259799614..fbb486d917b0 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2196,8 +2196,11 @@ static int ext4_fc_replay_add_range(struct super_=
block *sb, u8 *val)
>   		if (ret =3D=3D 0) {
>   			/* Range is not mapped */
>   			path =3D ext4_find_extent(inode, cur, path, 0);
> -			if (IS_ERR(path))
> +			if (IS_ERR(path)) {
> +				ret =3D PTR_ERR(path);
> +				path =3D NULL;
>   				goto out;
> +			}
>   			memset(&newex, 0, sizeof(newex));
>   			newex.ee_block =3D cpu_to_le32(cur);
>   			ext4_ext_store_pblock(
> @@ -2209,8 +2212,11 @@ static int ext4_fc_replay_add_range(struct super_=
block *sb, u8 *val)
>   			path =3D ext4_ext_insert_extent(NULL, inode,
>   						      path, &newex, 0);
>   			up_write((&EXT4_I(inode)->i_data_sem));
> -			if (IS_ERR(path))
> +			if (IS_ERR(path)) {
> +				ret =3D PTR_ERR(path);
> +				path =3D NULL;
>   				goto out;
> +			}
>   			goto next;
>   		}
>  =20
> @@ -2257,10 +2263,11 @@ static int ext4_fc_replay_add_range(struct super=
_block *sb, u8 *val)
>   	}
>   	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
>   					sb->s_blocksize_bits);
> +	ret =3D 0;
>   out:
>   	ext4_free_ext_path(path);
>   	iput(inode);
> -	return 0;
> +	return ret;
>   }
>  =20
>   /* Replay DEL_RANGE tag */
> @@ -2320,9 +2327,10 @@ ext4_fc_replay_del_range(struct super_block *sb, =
u8 *val)
>   	ext4_ext_replay_shrink_inode(inode,
>   		i_size_read(inode) >> sb->s_blocksize_bits);
>   	ext4_mark_inode_dirty(NULL, inode);
> +	ret =3D 0;
>   out:
>   	iput(inode);
> -	return 0;
> +	return ret;
>   }
>  =20
>   static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)

