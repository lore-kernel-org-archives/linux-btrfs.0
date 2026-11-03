Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745609;
	b=VE28sU6s+2FjSD91yoRlQqr/5BW9sBSerWu6fpEB+1AF+NZfUVt2BlUsxX/7wRB4Tmln
	 w52v6X+d49xNAavyuGLqN2n6MO8g6ClcNTnP+SDVM7vAXAhXsPggzKZmxf/yWxUiPryls
	 EQ9NHzg75dQXS86516UlfoKD6MxhkRlZhYj/bwJpy39s3TG/J1cSRpb5L3qA/m+n4Iv4/
	 5csJgfA+uFUZ/8AoyKcd8KpdSzA6SzaaPGGjEh/vkF971m5zP0eweieUx8gIyraNAkN+Q
	 EgKLf+02MDaD8uvxsW9mV8u+9E3SkAZFqXV5Absz9VSF8i+QT3UCU8OX3P0iyyUPWJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745609;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=mXJWkyZVPvuCO2rZ3jNEbfHeDEGefSRMROXrIljaY7o=;
	b=NV5B68MyYx08fwSRxJ+yTZNu0upBrE2l60MMVlFMOwwvgc5UdY+HDRVwFh1gltjvYOS5
	 fwaxL0cI3a11BJlQmN+p6Vmhl0xgodVEyJVu2F72cfRKJAWcplQkC4+VGOm8gXMOb9Es+
	 auXBa5f5yi0QAcss/8RSsRDNvhjhejUyqYQsEVYyeJBh7kY4ithxiCPrBO/MMRwQ4n+Ja
	 aTkqCJrkOmAmykMNyN4Op3/0oDBtZUpI++L9o9VLAYvIoVNZKqSJU2mxlFRTG9StQkidP
	 Lo+3JCdGLcBv+0idQqAJirow7jlwlywqFY+Q/S8LXzuniktWgr7QfKFTTQw/m9HmknQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=mKkuuRep;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A7A606A31B;
	Tue,  3 Nov 2026 22:40:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60A7A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=mKkuuRep
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793745604; x=1794350404; i=quwenruo.btrfs@gmx.com;
	bh=mXJWkyZVPvuCO2rZ3jNEbfHeDEGefSRMROXrIljaY7o=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mKkuuRepGd9YOYn3q/vkUvlo2KEXh9+JesbNZnjAEcmhSlbhbsdQTMHNkJOQs4C9
	 WZQaz0pUc31d2VaSiQDR99oBcF2DBc3rwNy+9P93yexZg136sjqzoSnBE+COt4cV0
	 ieHwQBxCHSy+vvW4R0CRI7C5VnZvN//rOBRGd9HcHUqpPTHso2BHrG3ZEVAUZDaNA
	 ueLBEK8HAU5E+trlabMPkKtIcgqySDzsndcXSxx/SReDwb/OlmJdEYzIqGYs3H2qX
	 EJH+FTnJe9W5aCVLHZnwDXoAX7KybXa/rKdi0zyecAqqDRXZlO0xdyaBUBlzRt37Y
	 LvT/OMQ3lwAL81dJMQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N5mGB-1wQlBY2mkd-00wHeM; Tue, 03
 Nov 2026 23:40:04 +0100
Message-ID: <3de376db-c102-44c0-8a4a-199ccae3ee8f@gmx.com>
Date: Wed, 4 Nov 2026 09:09:58 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: keep drop_progress when resuming snapshot deletion
To: kernel@pelam.fi, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, josef@toxicpanda.com, dsterba@suse.com,
 fdmanana@suse.com, mason@kernel.org
References: <20261103-drop-progress-v1-1-16e345565109@pelam.fi>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261103-drop-progress-v1-1-16e345565109@pelam.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HwstsTpE0Gf89+tbOPdMM3Jv1hLnBBApZIiUlJ4jcJlYga3/8Fe
 qu9VB0o2Qm72oHoviGs41tFzdZEz4K75lSQx8FNhd+76QUSmFmz4/bZLDhxVroEdz2K/lPq
 QdkUq9VPvoE/cO2pp9LFIe+QGsouLRWDiyyPjpjDUWNw7x+6ztsdgXebBkmCwt5u+MGof8F
 KZKgwgwoRYUwDc5lCkoKw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5D3PhcL2QKw=;9Jd/KZZDkkeVgJqff40i8XPvaZJ
 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



=E5=9C=A8 2026/11/4 06:59, Peter Lamberg via B4 Relay =E5=86=99=E9=81=93:
> From: Peter Lamberg <kernel@pelam.fi>
>=20
> When btrfs_drop_snapshot() resumes a partially dropped subvolume, it
> copies the saved resume key from the root item into wc->update_progress
> only. wc is kzalloc'ed, so wc->drop_progress and wc->drop_level stay
> zero. The main loop writes both back into the root item on every
> iteration, and wc->drop_progress is only updated once this run drops a
> reference itself (DROP_REFERENCE stage).
>=20
> If the child at the resume slot is shared and the walk is still in
> UPDATE_BACKREF when a checkpoint happens (an unmount or commit before
> the first drop), the root item gets drop_progress (0 0 0) and
> drop_level 0 while the root item still exists. The next mount then
> restarts the drop from the left edge of the tree. Children that the
> earlier run already finished now have refs =3D=3D 1, held by the survivi=
ng
> snapshot only, so the restarted walk treats them as exclusively owned
> and tries to free the dropped tree's reference again:
>=20
>    unable to find ref byte nr ... parent 0 root N owner L offset 0
>    BTRFS: error ... in __btrfs_free_extent: errno=3D-117 Filesystem corr=
upted
>=20
> and the transaction aborts.
>=20
> Before the commit below, the root item's drop_progress was left alone
> while in UPDATE_BACKREF. Restore that behaviour by seeding
> wc->drop_progress and wc->drop_level from the root item on resume, so a
> checkpoint before the first drop rewrites the same resume point instead
> of zeroing it.
>=20
> Fixes: aea6f028d01d ("btrfs: save drop_progress if we drop refs at all")
> Cc: stable@vger.kernel.org # 5.1+
> Assisted-by: LLM
> Signed-off-by: Peter Lamberg <kernel@pelam.fi>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Test notes (not for the commit log):
>=20
> Reproducer: subvolume S1 with a level-3 tree, read-only snapshot S2,
> delete S1, unmount after the first root child is dropped, mount and
> unmount right away, then let the drop finish. fstests test sent
> separately (btrfs/355).
>=20
> Reproducers and logs: https://pelam.fi/btrfs-drop-progress/
>=20
> Tested on Ubuntu 26.10, kernel 7.3.0-9-generic (v7.3-rc6 based), with
> btrfs.ko rebuilt from the matching Ubuntu source, 3 runs per module of
> the same sequence on a loop image with dm-delay plus btrfs check
> --readonly:
>=20
>    module              drop key zeroed  abort  btrfs check  snapshot S2
>    stock               3/3              3/3    errors 3/3   EIO 3/3
>    built, unpatched    3/3              3/3    errors 3/3   EIO 3/3
>    built, patched      0/3              0/3    clean 3/3    intact 3/3
>=20
> Unpatched and patched were built from the same tree with the same
> toolchain. With the patch the drop key kept the resume point over 20
> mount/unmount cycles and the following mount finished the drop.
>=20
> fstests -g quick (btrfs): 765 of 766 pass with and without the patch;
> generic/574 (fs-verity, 1K block size) fails in both runs, unrelated
> to this change.
>=20
> btrfs/355 (no dm-delay, checks the drop key after each resume): fails
> 3/3 on stock and 3/3 unpatched, passes 3/3 with the patch, ~15 s per
> run; same result with the devices on tmpfs.
>=20
> The patch applies to v7.0.14 through v7.4-rc1; v7.4-rc1 still has the
> unpatched resume code. Upstream tags were built (v7.3.1, W=3D1 clean on
> extent-tree.o) but not run.
> ---
>=20
> ---
>   fs/btrfs/extent-tree.c | 3 +++
>   1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3..41a8b25c6e0f 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6333,9 +6333,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root, =
bool update_ref, bool for_reloc
>   		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
>   		memcpy(&wc->update_progress, &key,
>   		       sizeof(wc->update_progress));
> +		/* keep the resume point until this run drops something itself */
> +		memcpy(&wc->drop_progress, &key, sizeof(wc->drop_progress));
>  =20
>   		level =3D btrfs_root_drop_level(root_item);
>   		BUG_ON(level =3D=3D 0);
> +		wc->drop_level =3D level;
>   		path->lowest_level =3D level;
>   		ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
>   		path->lowest_level =3D 0;

