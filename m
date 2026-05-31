Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0621ADC83
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 02:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780193438; cv=none; b=Bm1Xz/XWchBMx02mj+XWE1kQFxrOWxCRzOEMl2EMoyysJhXq5e/5z4mCQyL3kn2d6rJB6pKHymq800RrIa3wudXK4+VszNChCtAnK4fNKvievRuenZH34TVatxnTr0+25vnSAoV7f55kkBCPKn55EB6eWVc1bPwsiesz3mt4qKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780193438; c=relaxed/simple;
	bh=C5r4zeVncSXe9ErJySE8m56pjCr7/RnF0fhSfv+LGPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d3HCbumXxWVq496U/hE80Hs0mcTJmDeopYdinP3hOkUQYDvtNKHLByo0vJ5ib0rRc7ytic79LbQYlBZEbAUgSJs/y3PpjjNO/sR39QScKQ0nBmToVrQEZoIkpCZB3tYi081x1hTCOPUGZiVDmsdL1pe9Z9xjoEysct8tvey+VJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=QC4HNOsk; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="QC4HNOsk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780193434; x=1780798234; i=quwenruo.btrfs@gmx.com;
	bh=C5r4zeVncSXe9ErJySE8m56pjCr7/RnF0fhSfv+LGPo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QC4HNOskrwKWympHE2C59TcXq5j8i1ubVO7x7kp9FV3jcOV6xQ/UNiyH9Thm+XGR
	 wgjwpPCqpaaM+rMouiZbOErbD8FuNdDjyb/Z50pKP39nmcVPbOAILqNF2sDTU8pv3
	 J+32Dlp4j2mHm32UWD9R/cOxPjBy4UJf2qnb/SXpTuQ1apF1i52OnybAEDyrI33Vq
	 dj/iMne7Eww0+rmERKKZ+9DltueN6h/Yc+PvCug2B0VTa1dGyMVD1LAJYG8OMrtJf
	 TXV9K1a/7fn06LzOFWN4TJ9u4M3QWjEdMkIBaLtwFq9DwfoviFYPDb+Ob8udIJEh7
	 LhPHBsK5Xi5p3u6K0g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mg6dy-1wwV3X37J0-00bDjP; Sun, 31
 May 2026 04:10:34 +0200
Message-ID: <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
Date: Sun, 31 May 2026 11:40:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
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
In-Reply-To: <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:X98Pu7WYKuPlkHx3aT95MqQxL9gag/qKD79UGHu4BWHv+WyZoAp
 lUEK59AStoe6Z4nAvTjlSusSrp19Fy2+xWiAXaZkphtSQHnA65asWSq0HWQi1ddx03eci83
 TssW1Mm6HhW4rZmeQ8A0ItrLyfzWJoA/aByzz/0Enx+mXRF02S0WD7hfOcpl2TMLG3e09d9
 rcgRKTQXbfXjOJI98YkWA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jAi25k59jJo=;6jq9349F2T6QC/HjX/9YubkT0Z1
 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



=E5=9C=A8 2026/5/31 09:43, Michael Zacherl =E5=86=99=E9=81=93:
>=20
>=20
>> On 30.05.2026, at 23:23, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> Even with "ro,rescue=3Didatacsums" you still can not read that file?
>> That file should be a human readable text configure file for getaddrinf=
o.
>=20
> far from that. ( I=E2=80=99ve yet to re-check my rsync parameters becaus=
e the original is not on the most recent backup. :/ )
> however, an older backup shows me 65 lines of comments embedding (deacti=
vated) network parameters which suggests the system relies on the default =
configuration.

Indeed looks like some random binary data, but at the end there are a=20
lot of padding zeros.

This looks like some kind of compressed data.

Does the fs has compression enabled?

>=20
>> If you have not yet deleted that file, mind to take a copy of that file=
 with "ro,rescue=3Didatacsums"?
>> I'm interested in how the corruption looks like, normally it shouldn't =
be modified unless it's updated by the package manager.
>=20
> PLS:
>=20
>=20
>=20
>=20
>>> Is there a correlation to the scrub error?
>>
>> You can always use "btrfs logical-resolve -o 20316160 <mnt>" to resolve=
 the logical bytenr to a file path, to confirm if that's the culprit.
>=20
> I did
> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt
> which returned
> ERROR: logical ino ioctl: No such file or directory
>=20
> Is this related to https://github.com/kdave/btrfs-progs/issues/724 ?
>=20
> Trying to read the file when rw-mounted throws an error stating the inod=
e. Obviously this is easy to correlate:
>=20
> May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum fa=
iled root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 =
mirr
> or 1

It looks like the backref walk is not doing its work, thus neither scrub=
=20
nor logical-resolve works.

Despite the csum mismatch, have you tried "btrfs check" on the fs?

I think it will report some metadata problems.

Thanks,
Qu

> May 30 23:46:38 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5331, gen 0
> May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum fa=
iled root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 =
mirr
> or 1
> May 30 23:46:38 EndeavourOS kernel: BTRFS error (device dm-0): bdev /dev=
/mapper/cryptroot errs: wr 0, rd 0, flush 0, corrupt 5332, gen 0
>=20
> Thanks, Michael.
>=20

