Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA7E43F0AB;
	Fri, 17 Jul 2026 06:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271577; cv=none; b=dlnKejPd7xffIE4ZxgBbK2Y/l0L3pdVSK0+gyEHDZILgnVHhNTjfuJBMDKTQjKyxN9uGFL0vodVxU0Mgra15pvZGkIhdkNXeUDRfRLGe0+ZJ1whaDLUNsch5nbqllT0UdXQfuMaU4ziMGuUdM4rTg/m/SU8AejM4ueIi/tb3UvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271577; c=relaxed/simple;
	bh=wNtb0FKxLEgNPFmOw+2d5sx3zDoOIZ2BjSlXfWvrHGs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=HIcZeJ0SAS5+qqi2cgoiW/PWuMU0AMbekRIv/FVsHRmuyc+gWDqg2rah5xnVTLcPpCFj6rIu98dBcjVyD82D8CR7mlCqy9Y+oYZvaMwUxM5XgDES3LK1yprF+OiPhb8wVYUBYr9sZTc1n/4TZFwqF3dYspjiJBBd9oqH0JcaYs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uFJ1PcW2; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uFJ1PcW2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784271570; x=1784876370; i=quwenruo.btrfs@gmx.com;
	bh=BNJeFqQLjx+O5jRj3BhhbIYwlFF6iqKvvejKUXAvP70=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=uFJ1PcW2VmFmDLPCgpv5yno1PkZwlvsHG3mLwNktlWcKGQWDrqh2SUlvGOJs7bac
	 OA0ADVtDlmyFLsMIVcIYohKCNlO4pDUqeXGV6+1HALYoMrv8w+Jm5godjxiRIERjW
	 fPHDiCmab7J9V7HqvC+UXAQyAQ9odvEV3QcD2VkjaU/WMKXL/neZNyqMnsiCtE5ph
	 lHFha0vy8ZnwBYXsJVDkL2ngaR1LVWBT3uWsoToyvirWf2Aj5IwxYh87ip+wUiJlg
	 r9BaRjvcbFjaJqydviFBNsMkvAddE1DKNFzli8kscAz+SjRie9Kpsqd3jloL/wqsq
	 DNyb+poigw/q29h8Kg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mzyuc-1wzFPb1m0U-00yDdc; Fri, 17
 Jul 2026 08:59:29 +0200
Message-ID: <31464b3b-a183-4dfd-a8e7-2c6c45c2ee5c@gmx.com>
Date: Fri, 17 Jul 2026 16:29:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: generic/633, generic/696, generic/697 failure on btrfs with
 rc2/rc3
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>
References: <9b3313bd-cdb2-455a-9dcf-e1106276974f@gmx.com>
Content-Language: en-US
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
In-Reply-To: <9b3313bd-cdb2-455a-9dcf-e1106276974f@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:czDh4WuABGqdiaZNLJiQ9TioQrDddfWuLxWk7/ebL3ZMMeOn51Y
 0GboowsA3jqLdgwTjDSM5xCXJinQPie/TANIUl7B++1vMjwBRCFH0lb/bXd2Uac6dp7v9aA
 +dPele/Jnb4wSEB0UVv/txhA2P44x+f0IG4s1uJcs2BE5uKRrk9QZSle5dZum8fg7hTtjtk
 bac4QNaDuarWQ7bd0dDqg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:f9T44dt7LGY=;VfmTKUKw9gGpNVRHUqcIe0X6ris
 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
 pOkYcr17skO+XiVYEWeXq

My bad, forgot to Cc fstests.

=E5=9C=A8 2026/7/17 16:27, Qu Wenruo =E5=86=99=E9=81=93:
> Hi,
>=20
> It looks like 539dce114465 ("fs: refuse O_TMPFILE creation with an=20
> unmapped fsuid or fsgid") has changed the behavior that the above tests=
=20
> will fail on btrfs/ext4/xfs:
>=20
> FSTYP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- ext4
> PLATFORM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- Linux/x86_64 btrfs-vm 7.2.0-rc=
3-custom+ #411 SMP=20
> PREEMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
> MKFS_OPTIONS=C2=A0 -- -F /dev/mapper/test-scratch1
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratc=
h
>=20
> generic/633=C2=A0 1s ... - output mismatch (see /home/adam/xfstests/resu=
lts//=20
> generic/633.out.bad)
>  =C2=A0=C2=A0=C2=A0 --- tests/generic/633.out=C2=A0=C2=A0=C2=A0 2022-05-=
11 11:25:30.816666664 +0930
>  =C2=A0=C2=A0=C2=A0 +++ /home/adam/xfstests/results//generic/633.out.bad=
=C2=A0=C2=A0=C2=A0 2026-07-17=20
> 16:25:45.033967541 +0930
>  =C2=A0=C2=A0=C2=A0 @@ -1,2 +1,4 @@
>  =C2=A0=C2=A0=C2=A0=C2=A0 QA output created by 633
>  =C2=A0=C2=A0=C2=A0=C2=A0 Silence is golden
>  =C2=A0=C2=A0=C2=A0 +utils.c: 948: openat_tmpfile_supported - Value too =
large for=20
> defined data type - failure: create
>  =C2=A0=C2=A0=C2=A0 +utils.c: 948: openat_tmpfile_supported - Value too =
large for=20
> defined data type - failure: create
>  =C2=A0=C2=A0=C2=A0 ...
>  =C2=A0=C2=A0=C2=A0 (Run 'diff -u /home/adam/xfstests/tests/generic/633.=
out /home/adam/=20
> xfstests/results//generic/633.out.bad'=C2=A0 to see the entire diff)
> Ran: generic/633
> Failures: generic/633
> Failed 1 of 1 tests
>=20
> Did a quick search but didn't hit an exact fix.
>=20
> I guess we need to update the test case to avoid the EOVERFLOW errors?
>=20
> Thanks,
> Qu
>=20

