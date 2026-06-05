Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05B30566F
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 22:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780696891; cv=none; b=uqdkASLXeSsBKanlQe4MY/KoJMtqltaOvILpJfYsZhScGQbsULtMBtLSA+sguwFYzfFZvq1Mg30Sep/TLgD/2rZHN5TbobXBrH9i4REFMD7wOqd6Hsac+X/jTQzn4n/PFLI7PVB6Uz4yficVvvqwrLAgmMlcMKEo9K/FPrbuW0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780696891; c=relaxed/simple;
	bh=XeiA4x+CEeEKAxQiWWdZIDbzM5z/CbicPvk3/YdKSKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AM2gukzYH1MHmZsDE4X7xdA0i4EMa5jXoFB4DmFNccjzdO1nL/G++03udUjSmjYBSr0b6hVJ974/16fUNTiPRG+Erg/M77Ii74wTcP+KHJF4uP4uGxdxzfTonz6nEGui6UdxW00ws4d4GfW31O0JQUf4aTM3rcRefH2nF7GNanE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=nJTGAfCG; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="nJTGAfCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780696884; x=1781301684; i=quwenruo.btrfs@gmx.com;
	bh=XeiA4x+CEeEKAxQiWWdZIDbzM5z/CbicPvk3/YdKSKI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nJTGAfCGmAsqWMVIOmApyCZtUYiuso9fcCtZrPBNroYA9PYafWAF5ZYYYo8xoaF5
	 xoIJFQJ3dRWpYqOdeH8DMyjPDF5ZM3UtEMBaeLzMdSyMrJmanbxTuqTWrc6dRb2so
	 S++MOxFoAjfSd+0SgWsYTh22pkMUFZKIWqZ8G67PbjdDp2xskWsbGhl+NHpgz4N/+
	 QAJix4D0Gg3xKhEJEPESauvUm3PtZbTPi2ZnVre1u8f+ikgkkRd0hJ1LN8PfK9Nu3
	 /31bhEtkZCSOlkdli+rKS2WjyqH/kuUvBpcMl/MAnax1bxkSeerYo1E2h1SqmSmxZ
	 Y9QlU1CL8Ft4IunSBQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MpDJX-1x35Ke1wit-00aUm2; Sat, 06
 Jun 2026 00:01:23 +0200
Message-ID: <d438efaf-6ec5-4c4b-9767-7d0ac0ebbb63@gmx.com>
Date: Sat, 6 Jun 2026 07:31:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs: return the written number if there is any
 progress for dio
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1780645090.git.wqu@suse.com>
 <9e638119748a83f475861e69388b4dda9715b660.1780645090.git.wqu@suse.com>
 <CAL3q7H4dEGHd=LmmW5PVVnaxY=qFq31ZSb1qE24wPGU-bKv39g@mail.gmail.com>
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
In-Reply-To: <CAL3q7H4dEGHd=LmmW5PVVnaxY=qFq31ZSb1qE24wPGU-bKv39g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zfG4AqFpdjtX/imlAHen+LeTbDAKJQ9SJNfQBzqCAcZ1WjfQL/m
 1MEC8UPnjV9m7qNqEpOLHeyKcZHqOecfyY80JXrXR368Gu+xp+PuXG2LhHvE4PEBFWybGpu
 +FD/OM+9hRZ7gBgXuBU1dlaFcZgZDShytjWiXJ4O2pZVNwsCIspZeXKyMMKVZoFryCFqPuo
 P09g7AmJsDe/05Fs0fewA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:WwndIOcsIU0=;qZW1lvn4OLe86fir4eB56c3/XlR
 +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
 CuQOrQ==



=E5=9C=A8 2026/6/5 19:35, Filipe Manana =E5=86=99=E9=81=93:
> On Fri, Jun 5, 2026 at 10:10=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>>
>> Currently btrfs_direct_write() will return error even if there is some
>> progress made.
>>
>> E.g. a NOWAIT direct write has submitted 16KiB data, but later
>> failed due to -EFAULT.
>>
>> In that case we can not fallback to buffered IO either, as it's an
>> NOWAIT operation, so we set @ret to -EAGAIN.
>>
>> In that case, we should not return -EAGAIN but 16K to indicate that we
>> have already submitted 16KiB data.
>=20
> No, this will cause partial writes, resulting in unexpected behaviour
> for applications.
>=20
> For NOWAIT writes, if we perform a partial write we must return
> EAGAIN, so that the remainder is attempted again in a blocking
> context.
> If we return what we were able to write, there's no retry in a
> blocking context and the application gets a partial write.
>=20
> We've had such bugs and reports of unexpected reads and writes in the
> past, at least
> with MariaDB.

But what about non-NOWAIT cases? And APPEND writes?

Especially for APPEND writes, if we got a partial write, the isize is=20
already increased, the next APPEND writes would land in the new position.

Thanks,
Qu
