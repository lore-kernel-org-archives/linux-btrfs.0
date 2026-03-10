Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC029993D
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 07:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773126214; cv=none; b=LoeJLTFObfWHCw9OJVwJp9c45qu/jZuWRaUF86NTlatVsgSVEcWMPHlEg2dyVLkZeNSxyquRRw93w72tApnFCk8toTHfNMstkiBSgClNbccmTSMeby3suD14596BLiqrHU2YvHAqIlGoSktu1E0FxEv6GPK4c1zt1szMpbs9v+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773126214; c=relaxed/simple;
	bh=ozX7UE5orb6eNp1znTNYiahWVhJczk56k7wvyL6iugE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpEM6OQx0T03T1FcemAY/iJb/dFOjr+fYEYCE28jl2BlseF/p2bCq9qgjPoI7IDelwnhpNoJQuSQdj/mVIXboMZ9Ba6KqyEUKgm5QWmyPxUZU0cg5EfIJOH7YHmjp+qQgvfL2401IuMrcOqLDsPKn83oZIxLiev18Nxc5pDeqnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=b63ISKc5; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="b63ISKc5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773126206; x=1773731006; i=quwenruo.btrfs@gmx.com;
	bh=prJWPjI65Gfzy7Q98TAugpuqwjSOrfEpm5gkTzOx++8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=b63ISKc5bh+kMVZ9dQWOmo665kGoNNQr04s1Al3z8+379QM6aNCVVbx1u8jCYrrV
	 EyILOiSlZgfwqakoPaBtfAPrbQkaBtANHg8zv/d8YO64OUoI+HmDHMauN/umF4NMT
	 UtS+WE1vj2D0QBqE2jT5gc1h26lokEm+3tUL2qVAfGVvhzajDCaocdkTTUH7c7VJT
	 A5wMfQ/tOg7VU0UYPkkhyvv0SIQWetxeorTVnwA/Fl9QVguJ5L2amZQP/LJP+cZfQ
	 L0XgPieP6ylmuguPOlwvzRBOeCCvhjA7mH+aIVqa8dDjuxj55AgGG/+tS+XzkqokP
	 YOK0BUgW7lbJfkZo4g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnaof-1vGO1A3RLx-00e0tt; Tue, 10
 Mar 2026 08:03:26 +0100
Message-ID: <933c12fd-0d10-4ef7-b10e-cb64497829eb@gmx.com>
Date: Tue, 10 Mar 2026 17:33:16 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: move larger data folios out of experimental
 features
To: kernel test robot <oliver.sang@intel.com>, Qu Wenruo <wqu@suse.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-btrfs@vger.kernel.org
References: <202603101405.288f83f3-lkp@intel.com>
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
In-Reply-To: <202603101405.288f83f3-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zudRgtVwVurAGt/gGCoy7CP8cn+BHo4gUbFSh7ep/JCAcwC4Oo2
 comA50jhgIDtu0plccfLwEw8rOCmPlZl0EMI+KEyJQfQX+/TO4+WL/T8bGI1YCEE3uN3onK
 KOtPUhrsLi6cYatDCoZo26SU1ozp6UKWMFDibHI1bNQi87ARRGoMBVas8LJeh6F//+gwzd+
 m3SmUlgdW3f0bEN1OGWCA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PHTYCuXQANc=;7MKxxP8b3nWdsOehonqMIvjHU4n
 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



=E5=9C=A8 2026/3/10 17:13, kernel test robot =E5=86=99=E9=81=93:
>=20
>=20
> Hello,
>=20
> kernel test robot noticed "xfstests.btrfs.052.fail" on:
>=20
> commit: 50bb0fb60d1d55c7447535d17081ea009700cfd7 ("[PATCH v2 3/4] btrfs:=
 move larger data folios out of experimental features")
> url: https://github.com/intel-lab-lkp/linux/commits/Qu-Wenruo/btrfs-drop=
-2K-block-size-support/20260227-113649
> base: https://git.kernel.org/cgit/linux/kernel/git/kdave/linux.git for-n=
ext
> patch link: https://lore.kernel.org/all/0d8fe02f58ccbc0c53714ea45b0a4303=
f2ee8206.1772162871.git.wqu@suse.com/
> patch subject: [PATCH v2 3/4] btrfs: move larger data folios out of expe=
rimental features
>=20
> in testcase: xfstests
> version: xfstests-x86_64-63a29724-1_20260218
> with following parameters:
>=20
> 	disk: 6HDD
> 	fs: btrfs
> 	test: btrfs-052
>=20
>=20
>=20
> config: x86_64-rhel-9.4-func
> compiler: gcc-14
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GH=
z (Haswell) with 8G memory
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
>=20
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new ver=
sion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202603101405.288f83f3-lkp@intel=
.com
>=20
>=20
> 2026-03-06 18:12:00 cd /lkp/benchmarks/xfstests
> 2026-03-06 18:12:00 export TEST_DIR=3D/fs/sdb1
> 2026-03-06 18:12:00 export TEST_DEV=3D/dev/sdb1
> 2026-03-06 18:12:00 export FSTYP=3Dbtrfs
> 2026-03-06 18:12:00 export SCRATCH_MNT=3D/fs/scratch
> 2026-03-06 18:12:00 mkdir /fs/scratch -p
> 2026-03-06 18:12:00 export SCRATCH_DEV_POOL=3D"/dev/sdb2 /dev/sdb3 /dev/=
sdb4 /dev/sdb5 /dev/sdb6"
> 2026-03-06 18:12:00 echo btrfs/052
> 2026-03-06 18:12:00 ./check btrfs/052
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 lkp-hsw-d01 7.0.0-rc1-00110-g50bb0fb60d1d =
#1 SMP PREEMPT_DYNAMIC Sat Mar  7 01:56:32 CST 2026
> MKFS_OPTIONS  -- /dev/sdb2
> MOUNT_OPTIONS -- /dev/sdb2 /fs/scratch
>=20
> btrfs/052          [failed, exit status 1]- output mismatch (see /lkp/be=
nchmarks/xfstests/results//btrfs/052.out.bad)
>      --- tests/btrfs/052.out	2026-02-18 09:47:02.000000000 +0000
>      +++ /lkp/benchmarks/xfstests/results//btrfs/052.out.bad	2026-03-06 =
18:12:03.421371379 +0000
>      @@ -91,553 +91,5 @@
>       23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
>       *
>       30
>      -0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>      -*
>      -2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
>      -*
>      ...
>      (Run 'diff -u /lkp/benchmarks/xfstests/tests/btrfs/052.out /lkp/ben=
chmarks/xfstests/results//btrfs/052.out.bad'  to see the entire diff)
> Ran: btrfs/052
> Failures: btrfs/052
> Failed 1 of 1 tests

Can you provide the full btrfs/052.full?

I checked my older logs (we have enabled larger folios for a while for=20
experimental tests) and can not fild a similar failure.

Thus I'm wondering what is causing the failure.

Thanks,
Qu

>=20
>=20
>=20
>=20
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260310/202603101405.288f83f3-l=
kp@intel.com
>=20
>=20
>=20

