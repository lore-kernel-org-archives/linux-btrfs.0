Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5B44A724;
	Wed, 13 May 2026 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778689653; cv=none; b=NjSxIUAqFqfaLka9eAJfmV4qM3i2DpElGcXdG4aWpAiu/CAI112WiUDatUL3WKr8Fc8WjuIv4z3f1um27GLqLoUZufi0skKyuFprwsvHb7KcQ93Mk22bOucZfF9htoOQj1yrLP5bvDtsukxPBisIgcJqUJPHhsBCsabE+x2DFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778689653; c=relaxed/simple;
	bh=CDzF6zxpWm/EIG7IClV3NwFJ7pzNxzMC2HVtf6q6ESc=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=CwVEUnQ+XZhcOIiU6+3cne3D42kLjnU08brxc+vpnxcgBFX5Fx3khnczAQkMlUr3sZfZAEgHnP7dAczgnnEf+6wU/MqW4Bs6hxmFNJivM3crGjo/WF5GRKpNcBoRNfFI3uxGEK8VOIQNQzhIh4LavpOKCDrvsz7YW89Lo7FquCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Ahhs2ZaN; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ahhs2ZaN"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 64DGEn1a2905667
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 13 May 2026 09:14:50 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 64DGEn1a2905667
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026042601; t=1778688894;
	bh=kzc3j2nHoRxQd9M0vkzx/uZg5Iwn8WIixU3RTEBg+i4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Ahhs2ZaNxCuIyTcDd/to/S7gqU6ft6zabx6TakulFhnIjDt8bXMJ0LGzYVyEfrxzF
	 EoSq1ir5sKEz+X8RiAhKD9hHd7SJ2OozMvt9/+9wrxu0pBvVJBlgjVq84smFg5PvWl
	 ODAygtu3MetLOSzf39fcORVc45KgUJxXa0B3c1WcYV/TBfKv8I2j2JZj6Oo7LMLnaS
	 F/w+6e9Kh9WjQd20++VspvTwbnc9Zogl0CKsAiiMu7QXkJbZu0hP9l3BvRBi3h/lIE
	 60H32//SMm5Gsh1hto9j6ldrE4pFtBClA6C9ESo0hnzWXYJCYw3OlK+u43GeYa68K6
	 OTz8RC1DMTHsw==
Date: Wed, 13 May 2026 09:14:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        Song Liu <song@kernel.org>,
        Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Li Nan <linan122@huawei.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 01/19] btrfs: require at least 4 devices for RAID 6
User-Agent: K-9 Mail for Android
In-Reply-To: <20260512052230.2947683-2-hch@lst.de>
References: <20260512052230.2947683-1-hch@lst.de> <20260512052230.2947683-2-hch@lst.de>
Message-ID: <45B68AA3-36E2-4187-BD30-F4631C7F32C2@zytor.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On May 11, 2026 10:20:41 PM PDT, Christoph Hellwig <hch@lst=2Ede> wrote:
>While the RAID6 algorithm could in theory support 3 devices by just
>copying the data disk to the two parity disks, this version is not only
>useless because it is a suboptimal version of 3-way mirroring, but also
>broken with various crashes and incorrect parity generation in various
>architecture-optimized implementations=2E  Disallow it similar to mdraid
>which requires at least 4 devices for RAID 6=2E
>
>Fixes: 53b381b3abeb ("Btrfs: RAID5 and RAID6")
>Signed-off-by: Christoph Hellwig <hch@lst=2Ede>
>---
> fs/btrfs/volumes=2Ec | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/fs/btrfs/volumes=2Ec b/fs/btrfs/volumes=2Ec
>index a88e68f90564=2E=2E0b54b97bdad8 100644
>--- a/fs/btrfs/volumes=2Ec
>+++ b/fs/btrfs/volumes=2Ec
>@@ -159,7 +159,7 @@ const struct btrfs_raid_attr btrfs_raid_array[BTRFS_N=
R_RAID_TYPES] =3D {
> 		=2Esub_stripes	=3D 1,
> 		=2Edev_stripes	=3D 1,
> 		=2Edevs_max	=3D 0,
>-		=2Edevs_min	=3D 3,
>+		=2Edevs_min	=3D 4,
> 		=2Etolerated_failures =3D 2,
> 		=2Edevs_increment	=3D 1,
> 		=2Encopies	=3D 1,

Yes, if anyone cares about < 4 disks for the RAID-6 case (or < 3 for the R=
AID-4/5 case), just use the RAID-1 code=2E
