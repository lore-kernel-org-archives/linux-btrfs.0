Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E9B370AFD
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2026 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789421323; cv=none; b=VvqBBFAl++7KZEKXkZm4cPtYQyR916FijrNDVgoc6WUO95xQAheVqCA3gqamextHBoHEs1GJYCzMsKHE8mvylYU2jhVrwh/3FQkVVi3T3KixzUojl62jmhvWogawrTXCJwxyqltkUS1hPZNIZD1VvOaLeIWBge0lF4Snvy3t7To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789421323; c=relaxed/simple;
	bh=x5deNjefMw47twWcMxvB1ySuJ2fMNG1SqrLXQVEON30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mxkw5ofgr8vX3FqYKSRR0MdZyOc6CPK67xhG1T8eNm5XX4pJGu+mik/7F7tvXRmgpxG6EYOWtwrCgKE/XNqgBk3fPNQ8AyaHJgC7fBDqkTosHY/7V+rRyWiKv5nWzL4U5t0RHqzC5MPkeo5GsDif1TFDA6N89swaVf25T8XXgsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=On4yGSl+; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="On4yGSl+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789421316; x=1790026116; i=quwenruo.btrfs@gmx.com;
	bh=64IjApWkpTeWd5rNCZTeJrSfLyusO910tfLkTTnJk8A=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=On4yGSl+LfIDplDOG1L+DbkuqTqb8GvT5Mm6m+wUUTPeola5Feemoz9svt0zzihU
	 oHoLkR84JA4+OFPyQsI854Dnbq6DF6udLnBnyDgTUrxWLRo1iRTZ46Y+5JbxZUWzz
	 B7nR0UOow7tl5a3DDfvQ3Q5pWec746EE23Em7X45gRKZM5ErancT/EO5zyDiXRQz2
	 OdE7CvmqtfoC3JpA0vZE8ibjrY6qnO7j+92jWdDxEoy6EeePCJcwSSZzmaYsX7zvk
	 LxDqiPyR6BoMrl9Jth1c2ndiV/ltvx7gO6yFypEgfh6l/o3+43NDGyV+tep9KNGSF
	 J0uu6Si3gaboV7jISw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MBUqF-1wx7Yi1Evn-00DMuN; Mon, 14
 Sep 2026 23:28:36 +0200
Message-ID: <f60fd3c6-e9ad-4b0b-b0c6-e91e6801d0eb@gmx.com>
Date: Tue, 15 Sep 2026 06:58:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: docs: discourage root btrfs usage without an
 initramfs
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <c0fbd931a33a130a51f215fc0712954edb18b654.1789205131.git.wqu@suse.com>
 <20260914171831.GP54722@twin.jikos.cz>
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
In-Reply-To: <20260914171831.GP54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/o9PP0h6NMGCmdkNxyJKUYfZ1041eo6ISk0xF7ABEZLeK4w1Psb
 PiYXnQwmcPbOqunlHvLaRdQuq8pjTiBPaRUojJixn1gFzs/cHu+DSbCcy1PvVG3uU4SFfbI
 dK96oc9jsUOwlMniIGiNwuw6mbPU1WKiATlEalrfvUCQTjSfK4XyekAsZGrq1O15t/6MCY/
 B1uCQjO6vTj3tIj2jLbxw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wHCrYJh4X1U=;tHix/UxCeItdWEIiR2brVqu0Vhk
 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



=E5=9C=A8 2026/9/15 02:48, David Sterba =E5=86=99=E9=81=93:
> On Sat, Sep 12, 2026 at 06:55:32PM +0930, Qu Wenruo wrote:
>> For multi-device btrfs, device scanning is required before mounting, an=
d
>> without an initramfs it's impossible to mount a multi-device btrfs.
>>
>> Even if the rootfs is a single-device btrfs, there is nothing preventin=
g
>> the end user to add a device to that btrfs, and fail the next boot.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   Documentation/mkfs.btrfs.rst | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/mkfs.btrfs.rst b/Documentation/mkfs.btrfs.rs=
t
>> index 0d3d6051b0e7..0bc7b7ac3808 100644
>> --- a/Documentation/mkfs.btrfs.rst
>> +++ b/Documentation/mkfs.btrfs.rst
>> @@ -346,6 +346,10 @@ devices to scan at the time of mount.
>>           before all block devices are discovered. The waiting is usual=
ly done on the
>>           initramfs/initrd systems.
>>  =20
>> +        Thus using btrfs as a rootfs without an initramfs is not recom=
mended.
>> +        Adding a new device to the rootfs can easily cause the next bo=
ot to fail, as
>> +        there is no way to register all devices prior to mounting.
>=20
> That's not a good placement, we should write a full section how to use
> btrfs without initrd and what are the caveats. A paragraph burried in
> mkfs will probably never got noticed.

I'll add a dedicated chapter for device scan related behavior in man 5=20
btrfs.

>=20
>> +
>>   .. warning::
>>           RAID5/6 has known problems and should not be used in producti=
on.
>>  =20
>> --=20
>> 2.55.0
>>
>=20

