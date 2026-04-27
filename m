Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2E3BB40
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777267615; cv=none; b=fFvL/eVz0KwMzqp4Z3wTGzCogBodEnYYCxuhzGzYcM/2onOILvpAOwTnjJvS6xIbUiLuZAZQG0JnF/y1ZnTmskjRuj/94K+2yNZAA4VuehhrHRLsAr5iZ73VeCSqZlK4/GGpKKxZESfExBbz+Emac24h6HAgcnufarv4c2FuVcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777267615; c=relaxed/simple;
	bh=rmJox4MbECdZc2Xa8JWz/tjxjtfeIdWPA2g/nItyUso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGHXwKRZOPttY2dkwDVGjlEQC8dHNCa5QbSNqQ+aX1EtxeAxtjnTfnzVvfAl99c/fGyPgU4KM8c2uStT9nz4hXsCm5IeO0ZeBGhk+YFigDg32F8e9V1bp50gVkPj2bba/mUr1QSY6Z9gjuxJ+kxUrH2zYrKaDBjU394Xyveh2ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NZzrZ4Xq; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NZzrZ4Xq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777267611; x=1777872411; i=quwenruo.btrfs@gmx.com;
	bh=rmJox4MbECdZc2Xa8JWz/tjxjtfeIdWPA2g/nItyUso=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NZzrZ4XqGrD6+PK+NK9Nz5HqjpJCjh9J/u5AncXqe1RNStW/K+wkFFLAx7zgu03E
	 qZf+C6pOwRh3a9FY31CtkaOl4JVcfKyd6rbVfdK/vKd45t4/pdnByx6JCNIII3VyL
	 s5n/kIOeYfTdCU4b3poURVSqQL5a/+EECOCBOeuSrl5SdwTC3oFcyGdqK2r6aTrtS
	 uPm1hkXmPuU464pqunQgwOuqRDlUtTME3qTzpenpNIvLTyVqeNVBujHXzyqHgZ2Rd
	 Ax2xaRiso/tRtg+04N1O4CGM1TuspiQh6+5FqTdqMW6yDC5tG4uiln9HrWfoO82y3
	 +WOZBiQFmYB2DxkYdg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MqaxU-1vdRhR0ODg-00aBlz; Mon, 27
 Apr 2026 07:26:49 +0200
Message-ID: <634f9a5b-0e1c-4142-b82c-d34662a7a9ad@gmx.com>
Date: Mon, 27 Apr 2026 14:56:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
To: Thomas Debesse <dev@illwieckz.net>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
 <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
 <CALpuBKx=EQY=-K5VtLKATufdAbptZD0x6ZiSgbXZgOAG8Q8vAQ@mail.gmail.com>
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
In-Reply-To: <CALpuBKx=EQY=-K5VtLKATufdAbptZD0x6ZiSgbXZgOAG8Q8vAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dHyrGeKVU/PLpdsEtQMxpgqjqmWBh1W6r4tkCBC3U3jRz7uc3p9
 HXYQAw29Jb1G2dc1e37FPOckDefi9+zc9wjk4b2B8R/CPNKRCjbuCSsRqUGS/Z0xGXHPjxv
 UNzpNXNji0/MQJXKvJBVQ/aaAiBz96BbYaUBgfyFjuPetsJOcNmNRTSRCmbaGSABox5iQXp
 uo78jIKMleuJW1gm/wA/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FFHoLDF5w/M=;OXOLy81GicyWHqCSIUKdmaAlaMa
 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



=E5=9C=A8 2026/4/27 12:13, Thomas Debesse =E5=86=99=E9=81=93:
> Le lun. 27 avr. 2026 =C3=A0 00:18, Qu Wenruo <wqu@suse.com> a =C3=A9crit=
 :
>> Unfortunately, transid mismatch is not reliably repairable.
>> I'm afraid restoring from backup is the only reliable solution.
>=20
> Thank you for your answers. Is the data from the =E2=80=9Cbadly converte=
d=E2=80=9D
> volume be assumed safe?

If you really want to know that, only a full "btrfs check" can give you=20
some clue.

The transid mismatch means the block group tree block is being=20
over-written by some other tree blocks.

It can be minor, e.g. over-written by a new bg tree block, or it can=20
cause data loss, e.g. over-written by a subvolume tree.

And it can even be worse, if there are multiple tree blocks being=20
overwritten.


Your "rescue=3Dall" mount working is a good indication that at least most=
=20
of your subvolume trees are good, but it also disables datachecksum=20
verification, so there is still a chance that csum tree is corrupted.


>=20
> The idea is that, instead of overwriting the =E2=80=9Cbadly converted=E2=
=80=9D volume
> with a brand newly created and empty btrfs volume and copying the data
> from backup, I may consider the option to create the new btrfs volume
> on brand new devices I may source. I would have then the option to
> copy the data from either the backup or the =E2=80=9Cbadly converted=E2=
=80=9D volume.
> If the data is safely copyable from the =E2=80=9Cbadly converted=E2=80=
=9D volume (once
> mounted with recovery options), I expect copying from the =E2=80=9Cbadly
> converted=E2=80=9D volume to be way faster than copying from backup.

In that case, you may want to try this mount option instead:

"-o ro,rescue=3Dibadroots,nologreplay", which will allow btrfs to skip the=
=20
bad block group tree, but still enables data checksum verification.

>=20
> Also another question: if it happens that copying from the =E2=80=9Cbadl=
y
> converted=E2=80=9D volume can be assumed to be safe, would `btrfs send` =
work
> or do I would still have to do it the btrfs-agnostic way, like by
> using rsync?

I think 'btrfs send' may work, but haven't yet verified.

>=20
> Thanks in advance for your answers, that helps a lot.
>=20

And I forgot to ask, when did the corruption happen?
Immediately after the conversion finished, or the first mount worked,=20
but corruption happened later?

If immediately after a finished conversion, then it's very possible the=20
conversion is the cause.

If not, then it may be something else, like the older non-upstream LTS=20
kernel from Ubuntu.

The reason I'm asking is, although there are some fixes in progs v6.15,=20
they are all addressing problems related to resuming interrupted conversio=
n.
Thus I'm wondering what is the root cause of the transid mismatch.

Thanks,
Qu
