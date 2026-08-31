Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED47391E43;
	Mon, 31 Aug 2026 23:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788217788; cv=none; b=dWySI6vycwf5dXybUjA0mF3WEoLrLNDFtdNU7Lt43gnU0C67dMAAwDPxszRnO9PhD8v0Q/L+iR//9w69nB/g38da+3dAFVZ1wiyrP09dG/PZcvCSu/ERR+x/yaCgoDXv3AKzbaztZ1JDbWTwfkxGrG0fciSyU/kopSt1RaHBoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788217788; c=relaxed/simple;
	bh=+A3ljWhG6tIJS+KveY9w8314BGPNITy56b/1OPoR3us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L6icNca0z4wyO1Klr02SRsFSltdvoWLuqeoP9nhulsF4oCEVGocapQiVq4pCbDqpaBOmEffn2eLF+OW0G1+4NlFQJcXzHXtdqRgCgVOhYOB3Sc3JRWUjRJQwSgc9eeagxIx1l9+h1ZtHPiQ+DXYq+i6qSbvq5NVUNpnxv7Uzp+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VbCH6ybL; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VbCH6ybL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788217784; x=1788822584; i=quwenruo.btrfs@gmx.com;
	bh=cDJkWJSPX6mMfeFef/PQa74LdTSDDdiqjnGq76xvWp4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VbCH6ybLCHTqEXNw5zsbjw5F/EcJq8MI3Ec7gFNBc49q27CdaPhT4z9GXWYJAqKB
	 T0k43z1j0Azi2DeF06aqX7GGcqgrTPXlxu1H+6V7TZ5iG0AkbJLNlwD18JutPaErO
	 HHkXUc+gwGLAbd//FI2Nl15a6mSF3S1toexWK6o2hNmXV+f0HcF6hpxaWkSYxCq09
	 dLNHq8JOVllXuF4sCXjN7iV3/ue6itcm7S5v2YdSTZywLdUfSrOtcsK1S3MvnpEXN
	 0ERA8vtinuhyORlK8MQYWAGcLd4TX9hsO3ZzKQ7VZ1uhHIMrPWp+PYccfLk+ob4PU
	 mzy1la4YFlnMjX+G4w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MHXBj-1x5u581jIf-00CUgJ; Tue, 01
 Sep 2026 01:09:43 +0200
Message-ID: <29144563-4ddb-49f9-af44-9605b78e3332@gmx.com>
Date: Tue, 1 Sep 2026 08:39:39 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs/333: require scratch before checking encoded reads
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>, fstests@vger.kernel.org
Cc: Zorro Lang <zlang@kernel.org>, Anand Jain <asj@kernel.org>,
 Filipe Manana <fdmanana@suse.com>, linux-btrfs@vger.kernel.org
References: <20260831104200.2269-1-prabhakar.pujeri@dell.com>
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
In-Reply-To: <20260831104200.2269-1-prabhakar.pujeri@dell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FwtfQwDwwNG9FXnr97hezC75ta73UfoUc0zppTQKhrYAUSZqmcM
 02U3x1Lp6zHhsXAuJI8ykmqLDynIFygM3N3I7nKKtU0sghE7tryjIyDcVzoQ0AipvhuHdfP
 YrRsTuULkMiN629Wyu/aMzecvHleO/y191SOvpt7gVzdLo0VQq3IV8LP1H5AvgYLW9l0n/d
 hKc5e5r/0vIg6wOPqJAtw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SA9jI5FksAw=;2AED1RXDoXq1MhKIG66PWMXwubT
 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



=E5=9C=A8 2026/8/31 20:12, Prabhakar Pujeri =E5=86=99=E9=81=93:
> _require_btrfs_iouring_encoded_read() formats and mounts the scratch
> device while checking for encoded-read support.  Without a configured
> scratch device, the test therefore fails before reaching its existing
> _require_scratch call.

In that case it's better to just add _require_scratch to=20
_require_btrfs_iouring_encoded_read(), instead of changing every=20
possible caller.

BTW, without a scratch device, more than half of the tests will be=20
skipped, thus it may not provide much coverage for such runs.

Thanks,
Qu

>=20
> Move _require_scratch before the encoded-read check so the test is skipp=
ed
> before its first scratch operation.
>=20
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> ---
>   tests/btrfs/333 | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/tests/btrfs/333 b/tests/btrfs/333
> index 6214d7c..9dcdf1c 100755
> --- a/tests/btrfs/333
> +++ b/tests/btrfs/333
> @@ -13,6 +13,7 @@ _begin_fstest auto quick compress rw io_uring ioctl
>  =20
>   _require_command src/btrfs_encoded_read
>   _require_command src/btrfs_encoded_write
> +_require_scratch
>   _require_btrfs_iouring_encoded_read
>   # Encoded writes are reject for inodes with the NODATASUM flag, so we =
must skip
>   # the test if running with either the nodatasum or nodatacow (which im=
plies

