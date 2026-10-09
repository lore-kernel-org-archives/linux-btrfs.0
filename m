Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F383386C2A
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 21:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791580397; cv=none; b=ZZDMVu813IEa4E0zswOrjiIn/Gohef2B8WyNQBH+K7Evh+0Hf95qrfw1eT31NN0q6KfWahk7LFSLaF0XRZacpJia2NfNyGcrCqlPwycZuqNyWvBbllZwF9bUfpxVWNZXRg8XrsXiLB1E0cU3PQS///gfwcv/IzzCWU0IAkZooRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791580397; c=relaxed/simple;
	bh=DD37psxwIpA93RmQ77YvbyD7iVhr1WIfecLnCLLLKGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3QDMPfxyg/GA7I+DM+MH26Irltvw3iEgG3Kcp486ZGGt3A8cjRjbGx9g13BiMnq9sXb4S7KeRFwK34ligrs9yKPKQaCDYbjqd6uwJCLpqEx9eUfF1hnxYDjVNEeoGsYCnAmOxYsHKfdjWktZ/PKRH5WXLYBSyiNpMSofNs2k9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cI8Gp+X3; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cI8Gp+X3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791580388; x=1792185188; i=quwenruo.btrfs@gmx.com;
	bh=ypdvrI81NRYFZlNz3Xi6ebyQiJytX+E+hLfKgcn3Flc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cI8Gp+X3Daoh5vU9nvr3r4zhRiplbDF5WY7xh1LELEOwZLrRBf/UfGQUMuhs9nTC
	 +Qf9oQvPXOYPbcBKEmXbOHeH3eQ8DM+2ZteIs6QRoSrU7M9XHq+Zpae3blDuX4B1F
	 8TQch0Z1hi/wzpDB1tfjBYWE2Vc/e1WMvtEjBsrbWRNhxUo0iQbcclJmkDvMpzsiT
	 xbaZtpkE3/mfLYITuvHu9sGKq31wR7Kw1FKzXSQxdPDSetT4EwNttUkh7ecyoZJRa
	 Yx2kkbz0J6Matx3pmsODsttpMEfSCQqCZcxpbBXx7nsg112QiK2yXpqYbBOA0NUMq
	 kSs6CNBh8qnwpyEnSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mz9Ux-1wTDgu21SN-00qp6g; Fri, 09
 Oct 2026 23:13:08 +0200
Message-ID: <7c0c0ce1-daf6-4ef1-ae7b-74dfbb6f5a4a@gmx.com>
Date: Sat, 10 Oct 2026 07:43:03 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] btrfs: fs-verity "FILE CORRUPTED" on readahead of
 compressed extents since 7.2
To: =?UTF-8?Q?Roger_Alas=C3=A0?= <vonbloom@gmail.com>,
 linux-btrfs@vger.kernel.org
Cc: fsverity@lists.linux.dev, regressions@lists.linux.dev
References: <CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com>
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
In-Reply-To: <CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HHC4B4hPNYvVYNGaRyQrEDxdGj/9duiVFegmgxX3nj8IV2wwqFB
 CyKuPXGm2Dwj3qs5k6x6hEiU1wQyl+Bt7rWzj3uM5hT8frPfdskWhX3lT5lYMzT69xAsz7i
 h5SARihSL1mXKUrMBlEKCcvnv4G9Rf/t4+sVsXhmBtZseC/04XO2Xl/irOKjeIDPqijOK1V
 IYC18An/RZrbthlQlKOiA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Fe1QOAmeMuw=;vJvxqg85Zpfh42BpGuAms6MUo29
 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
 6sAlPwSQ==



=E5=9C=A8 2026/10/10 04:41, Roger Alas=C3=A0 =E5=86=99=E9=81=93:
> Hi,
>=20
> (Resent with a subject line: the first copy went out without one,
> sorry for the noise.)
>=20
> Since 7.2, reading an fs-verity file on btrfs mounted with
> compress=3Dzstd:1 logs "FILE CORRUPTED" for compressed extents read
> through readahead, although every read succeeds:
>=20
>    fs-verity (vda3, inode 58996): FILE CORRUPTED! pos=3D8912896,
>    level=3D-1, want_hash=3Dsha512:...
>=20
> (one line in dmesg, wrapped here). The positions are mostly multiples
> of 128 KiB. read() returns no error and the data is correct: the
> synchronous re-read passes verification. We hit it with composefs
> (bootc) objects on the root filesystem of a laptop, and reproduced it
> on a second machine and in a VM.
>=20
> Reproducer (root, any btrfs mounted with compress=3Dzstd:1):
>=20
>    cd /mnt/btrfs-zstd
>    find /usr/lib -maxdepth 1 -name '*.so*' -size +500k -print0 |
>      xargs -0 cat | head -c 60M > f
>    sync
>    fsverity enable --hash-alg=3Dsha512 f
>    echo 3 > /proc/sys/vm/drop_caches
>    cat f > /dev/null
>    dmesg | grep -c 'FILE CORRUPTED'     # 10 here
>=20
> Same data with chattr +m before writing (uncompressed): no messages.
> Reading with POSIX_FADV_RANDOM: no messages.
>=20
> Tested on Arch Linux's kernels (no out-of-tree patches) in a KVM
> guest, virtio disk:
>=20
> - bad: 7.2.2-arch1, 7.2.7-arch1, 7.2.9-arch1
> - good: 7.1.11-arch1, 7.0.14-arch1, 6.18.55-lts
>=20
> Also on bare metal (two NVMe laptops, Intel and AMD) with
> 7.2.9-cachyos. A similar symptom in 6.16.8 was fixed by "btrfs: fix
> incorrect readahead expansion length" (Oct 2025).
>=20
> #regzbot introduced: v7.1..v7.2.2
>=20
> I can test patches.

Just a quick rule out, I suspect it's the new large folio support.

You can test the following patch to rule it out:

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 03c00c99099d..a63b2eda877d 100644
=2D-- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -509,9 +509,11 @@ static inline void=20
btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
         /* Metadata inode should not reach here. */
         ASSERT(is_data_inode(inode));

+       /*
         mapping_set_folio_order_range(inode->vfs_inode.i_mapping,
 =20
inode->root->fs_info->block_min_order,
 =20
inode->root->fs_info->block_max_order);
+                                     */
  }

  bool btrfs_bio_data_csum_ok(struct btrfs_bio *bbio, const struct=20
bvec_iter *orig_iter,
>=20
> Roger

