Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8C821883E
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 00:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791592144; cv=none; b=nhl4Dn2SI7rov/01rKcykWSuCZ3XmpbUdBSpS9+i90iHadocM1DSK6XNx15EqGdZSGmP5+nHZYN2CXXM7FqhV70pVwoJVFmlToGWPbHDyH75d6OYwGQhIxgHXlOnPQc9e4j5SRbWmwBxXMiwn5FjsswVSDOeyGjSFBuPIXXUog0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791592144; c=relaxed/simple;
	bh=9WwI/GEN+a7n0MZtjZjiH8ytzt/8H2SkAgmI33aS5Rw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Qxlmmv6Kyw00iagMPHqsMbOIU4+WT/HSEqVtDmPW0GAri90R3w3sn0Q4R2HVN4RcU6FARqodlqWLN6rX1gRV6r3flkuZ3nq4Bqzk/dnXb1EbBTZQbwE88prt3ll1+ygWMAZmObeFHRRwa/E4H5XagrsrNzxr+mFE1B8agOIuI4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=qxGUxffK; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="qxGUxffK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791592135; x=1792196935; i=quwenruo.btrfs@gmx.com;
	bh=6ZYiV3qOmxW2oOqpX9cOKrNgMp3WxvNJ6x+iSYflagM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qxGUxffKiur+Vh2zv2sogN+O/DXZIAd20wNOjJK2AYvAi9z7CKCh7AO5GFqxxyb1
	 lcxd3GBbu3D9kk1sm+5yF3RLyGKvdHzqRUzdIztGm7pNxoUKYyGQ+DMFGq9yT0AST
	 5T8EXeGKtgfJiedetmYYoXZQCRq5+/0LO0lX+LAkeIK8apSzEIJqu/wr8/E+K/Hvd
	 H0/zpaSPaUA9izN3L21nVmXCDfdDa7p+Plnuu8+aXRc4+1sX7KqujdQWMz63OtGFV
	 8cZPWF9F2WvizzDNGTIpSVFxzWPi1czLcVhjtItggglVYzTMODGCRcA2im3TF+zT4
	 bb2OaCe6CiCzvSjtIg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MXGrE-1xAVfE3nig-00N507; Sat, 10
 Oct 2026 02:28:55 +0200
Message-ID: <7558fd73-8bad-4bda-a090-5496b2b6d56c@gmx.com>
Date: Sat, 10 Oct 2026 10:58:50 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] btrfs: fs-verity "FILE CORRUPTED" on readahead of
 compressed extents since 7.2
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Roger_Alas=C3=A0?= <vonbloom@gmail.com>,
 linux-btrfs@vger.kernel.org
Cc: fsverity@lists.linux.dev, regressions@lists.linux.dev
References: <CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com>
 <7c0c0ce1-daf6-4ef1-ae7b-74dfbb6f5a4a@gmx.com>
Content-Language: en-US
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
In-Reply-To: <7c0c0ce1-daf6-4ef1-ae7b-74dfbb6f5a4a@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RFjFxc6YX3GA/7mn5aAOvgyp04emGJ3aaYhUp7F4Psq7we1KidC
 sdnFgnCAHIRkdLAuMBZbjEoxNoHyUz96+ctVAa3J7VesXnZg655b4RT2QMtOu36GuJrQNE2
 585RToIoZc33ktJgxIvi5Fpi/XuwqCIvtTWT7DfCo5H442DYY8MctiU7ngaOgGqZ2qRx7wN
 U/axYbgdj5zgee7t5OsSg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UULEIP2ENUs=;10Ap7blqpNxrA1H1l5pWiFQRPmV
 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
 w0RcnxFNS1i42wJlekD5veplw4gz8=



=E5=9C=A8 2026/10/10 07:43, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/10/10 04:41, Roger Alas=C3=A0 =E5=86=99=E9=81=93:
>> Hi,
>>
>> (Resent with a subject line: the first copy went out without one,
>> sorry for the noise.)
>>
>> Since 7.2, reading an fs-verity file on btrfs mounted with
>> compress=3Dzstd:1 logs "FILE CORRUPTED" for compressed extents read
>> through readahead, although every read succeeds:
>>
>> =C2=A0=C2=A0 fs-verity (vda3, inode 58996): FILE CORRUPTED! pos=3D89128=
96,
>> =C2=A0=C2=A0 level=3D-1, want_hash=3Dsha512:...
>>
>> (one line in dmesg, wrapped here). The positions are mostly multiples
>> of 128 KiB. read() returns no error and the data is correct: the
>> synchronous re-read passes verification. We hit it with composefs
>> (bootc) objects on the root filesystem of a laptop, and reproduced it
>> on a second machine and in a VM.
>>
>> Reproducer (root, any btrfs mounted with compress=3Dzstd:1):
>>
>> =C2=A0=C2=A0 cd /mnt/btrfs-zstd
>> =C2=A0=C2=A0 find /usr/lib -maxdepth 1 -name '*.so*' -size +500k -print=
0 |
>> =C2=A0=C2=A0=C2=A0=C2=A0 xargs -0 cat | head -c 60M > f
>> =C2=A0=C2=A0 sync
>> =C2=A0=C2=A0 fsverity enable --hash-alg=3Dsha512 f
>> =C2=A0=C2=A0 echo 3 > /proc/sys/vm/drop_caches
>> =C2=A0=C2=A0 cat f > /dev/null
>> =C2=A0=C2=A0 dmesg | grep -c 'FILE CORRUPTED'=C2=A0=C2=A0=C2=A0=C2=A0 #=
 10 here
>>
>> Same data with chattr +m before writing (uncompressed): no messages.
>> Reading with POSIX_FADV_RANDOM: no messages.
>>
>> Tested on Arch Linux's kernels (no out-of-tree patches) in a KVM
>> guest, virtio disk:
>>
>> - bad: 7.2.2-arch1, 7.2.7-arch1, 7.2.9-arch1
>> - good: 7.1.11-arch1, 7.0.14-arch1, 6.18.55-lts
>>
>> Also on bare metal (two NVMe laptops, Intel and AMD) with
>> 7.2.9-cachyos. A similar symptom in 6.16.8 was fixed by "btrfs: fix
>> incorrect readahead expansion length" (Oct 2025).
>>
>> #regzbot introduced: v7.1..v7.2.2
>>
>> I can test patches.
>=20
> Just a quick rule out, I suspect it's the new large folio support.
>=20
> You can test the following patch to rule it out:
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 03c00c99099d..a63b2eda877d 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -509,9 +509,11 @@ static inline void=20
> btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Metadata inode should not=
 reach here. */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(is_data_inode(inode))=
;
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mapping_set_folio_order_rang=
e(inode->vfs_inode.i_mapping,
>=20
> inode->root->fs_info->block_min_order,
>=20
> inode->root->fs_info->block_max_order);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
>  =C2=A0}

It's indeed related to large folios, although it's not the root cause.
The root problem is already there, and affecting bs < ps for a long time.

The proper fix is already sent to the ML and CCed you here:

https://lore.kernel.org/linux-btrfs/c1cbf7c27ca3685b6440c04c87b70fe779a253=
5b.1791591949.git.wqu@suse.com/T/

I verified it locally with your reproducer and it no longer causes the=20
verification failure.

Appreciate if you can verify the fix against the more complex workload=20
and give a tested-by tag to that patch.

Thanks,
Qu
>=20
>  =C2=A0bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct=
=20
> bvec_iter *orig_iter,
>>
>> Roger
>=20

