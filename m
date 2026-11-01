Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793522097;
	b=T4/Eiz3aiIdesqFL/VWVDO6g6j23T7JAubD6/u+5O37rtF7QWfVbbv+nB0LEYUqFvS71
	 pMxK3vTpq4gKHErxUSncp6hE7/nC0ZHHq1HTx101SW8ROIahAtN+Mgs6Yybk3SexdFSSi
	 u87UqzUXHqOITFAWZyqZrdVzu12t95pWWNs9t5E60KKUYOhyH0X75JAvcV6wpNlgcilWi
	 Va25vDEm3zr49QiyTjdhLT4ZAWO3mzTvq37vRq8a5L2kBzWreB/7oCrcSvc23L2DgRiW/
	 lnDXBp2ayUVk7n8IN9Dv73Ns6dDUiTxN4jsEh9Vb1wEnNiy3+3jaBZBdm7TFwxoPPRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793522097;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=Gi+rpX1k/LJWeBP0IyEQa2YjoheK/sHm/PzoZe4dq74=;
	b=JgMLAG1LiP6QLdaKwNZka1peY6cji/on1rwhJkves0jWNSFSbxWCuFyCM4wYroeDwZHa
	 lX/8OH3Casqjm+w8MROyT5h6C36jsa/c5XETkez2iwW5iyITpuhZ+IRGqhQeACIVWCrYf
	 y5MwVNAh8awqnN1ynixJmPx8xNs72JcVUXKarN9yd5t7XXhftSmuDd0mOWkQ+G1pUCZ8h
	 WlbJ2hl++e/Wnj+0krhlzNUGqp4uXFCd2bGIOpa8o5i+QLgI9L0USXF9o/AHyOQIxhltQ
	 Z85P00yHMD/LAit5uxbKYssg0PEbBRDoT+ovWxQuPEJaeeFekuROJt61vHcX0m2n9nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=buchOutG;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E96606A324;
	Sun,  1 Nov 2026 08:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11E96606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=buchOutG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793522089; x=1794126889; i=quwenruo.btrfs@gmx.com;
	bh=Gi+rpX1k/LJWeBP0IyEQa2YjoheK/sHm/PzoZe4dq74=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=buchOutG5335Ex9ZoYup7g7LsVuJJ7WQvBdtZNiV0MWfXWPFgknRIIbAALF5BuQv
	 mENHWH9+K4auc2BfhH2tOepCifh6CzxmTtdcZaQGIWCc+tNI/1p18O4gpJhGHT4tG
	 kuyAc/MYjJ8AzDBq0l/fi3eB4uMOpMUeyWD2ppKJpYGWa9xJoEwBuwHdL9+UFPMAF
	 8OTFMyzoC89zUQGLmFShdwIHDaC4BsUTKBeZ3rksHe263v4oGHKZ7f72cMyRzWLGJ
	 LJWBVQqcXu5f1q/EbvatJFgeQy5tAYVKLbtEF7VTc45XEM/+lRU+XUtN3Wv/uvo2y
	 tmJ7thHgdrbL6iVLmw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MnakX-1weRYb0cfV-00cxPl; Sun, 01
 Nov 2026 09:34:48 +0100
Message-ID: <7a6e984f-d703-4049-9c72-16737403e2e6@gmx.com>
Date: Sun, 1 Nov 2026 19:04:42 +1030
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
Subject: Re: [PATCH v2] btrfs: handle zero num_stripes in
 btrfs_chunk_item_size()
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, Qu Wenruo <wqu@suse.com>,
 Filipe Manana <fdmanana@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261101071444.1853699-1-teel4res@gmail.com>
 <29e8ef0f-211d-404c-b4ca-c47a956ef699@gmx.com>
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
In-Reply-To: <29e8ef0f-211d-404c-b4ca-c47a956ef699@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3OhuRvcmxMQmEIsm1OPfsGrZH+UbUn75kdoFPyzi8KcQ30PiGiK
 GgFOAppCUqCvBLAkIPLxx5Iu4Eu3x3wtgRVFcLMgs2Nx4UAtsg7SzhHrTYICRYVmOzoyWUd
 IyTyfEgkxYUJlx7ExKdMdmL+RyWqNv+Azm/xYi7p7anqwlZeRtom4+Aod7WRs0cHMMZ8w8j
 RfZM47OQRWS9+HTxDgrIg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3NSt8LfjW70=;yoEh+rvlPZhKJlWQuWkFh+CmoEL
 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
 8j9lh7KVYAEyUExdBOsU5aqSdvLA==



=E5=9C=A8 2026/11/1 17:56, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/11/1 17:44, Cheng Yongkang =E5=86=99=E9=81=93:
>> validate_sys_chunk_array() calls btrfs_chunk_item_size() with the
>> on-disk num_stripes before btrfs_check_chunk_valid() has checked the
>> chunk. With CONFIG_BTRFS_ASSERT=3Dy, a zero-stripe system chunk trips
>> ASSERT(num_stripes) instead of being rejected:
>>
>> =C2=A0=C2=A0 assertion failed: num_stripes, in fs/btrfs/volumes.h:714
>> =C2=A0=C2=A0 kernel BUG at fs/btrfs/volumes.h:714!
>> =C2=A0=C2=A0 RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
>> =C2=A0=C2=A0 Call Trace:
>> =C2=A0=C2=A0=C2=A0 open_ctree
>> =C2=A0=C2=A0=C2=A0 btrfs_get_tree
>> =C2=A0=C2=A0=C2=A0 vfs_get_tree
>> =C2=A0=C2=A0=C2=A0 do_new_mount
>>
>> Drop the assertion and compute the size as the chunk header plus
>> num_stripes stripes. The size is unchanged for num_stripes > 0, and a
>> zero-stripe chunk now reaches btrfs_check_chunk_valid(), which rejects
>> it, so the mount fails with -EINVAL.
>=20
> It's not -EINVAL, it's -EUCLEAN.
>=20
>>
>> Tested on btrfs for-next d1dca33127ef with CONFIG_BTRFS_ASSERT=3Dy and
>> KASAN, using a crafted image whose system chunk array contains a
>> zero-stripe chunk: without this change, mounting it hits the assertion
>> above; with it, both read-only and read-write mounts fail with EINVAL
>> ("invalid chunk num_stripes, have 0"). Mounting, writing, reading back
>> and unmounting a normal filesystem, and btrfs check on it, still pass.
>=20
> Very chatgpt behavior. Write into your memory file to drop unnecessary=
=20
> test steps when crafting a patch.

I'll push the patch with above points modified.

No need for a new version.

>=20
>>
>> Suggested-by: Qu Wenruo <wqu@suse.com>
>> Link: https://lore.kernel.org/linux-btrfs/d2ee0cc1-674e-4447-88da-=20
>> d346122a43a4@suse.com/
>> Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at=20
>> btrfs_validate_super()")
>> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
>> ---
>> Changes in v2:
>> - Fix btrfs_chunk_item_size() as Qu suggested and drop the early
>> =C2=A0=C2=A0 zero-stripe check from disk-io.c, along with the comment F=
ilipe
>> =C2=A0=C2=A0 reviewed.
>>
>> v1: https://lore.kernel.org/linux-=20
>> btrfs/179328314071.648427.12527832319954042748@gmail.com/
>>
>> =C2=A0 fs/btrfs/volumes.h | 5 ++---
>> =C2=A0 1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index d5fe5cba0..891bc2432 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -711,9 +711,8 @@ static inline enum btrfs_map_op btrfs_op(const=20
>> struct bio *bio)
>> =C2=A0 static inline unsigned long btrfs_chunk_item_size(int num_stripe=
s)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 ASSERT(num_stripes);
>> -=C2=A0=C2=A0=C2=A0 return sizeof(struct btrfs_chunk) +
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct btrfs_stripe)=
 * (num_stripes - 1);
>> +=C2=A0=C2=A0=C2=A0 return offsetof(struct btrfs_chunk, stripe) +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct btrfs_stripe)=
 * num_stripes;
>> =C2=A0 }
>> =C2=A0 /*
>>
>> base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a
>=20

