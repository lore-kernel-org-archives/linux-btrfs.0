Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97F62750ED
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 21:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777326848; cv=none; b=DZsVPgUI/6Vf+1CiY8HS+yYNX1vUNc61vsAwK2RJUzuLeQTD0tiTj+0+q5HbF6zjOkXFIwCl4wLl/Iezq+8Mt0iHT45dmpQT7TLVQLoLcC7XEXZrac/SXO0JaUhpFq1zTHdXRg1lh+RJgfPY/dIE3fEfA2DrmXGJNz9jdhWjyks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777326848; c=relaxed/simple;
	bh=+q9R7P88qCAyFafV6KheRkJMI6DBG8ZC03Hesi+1tU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnn4BXTBJDr77ZPeX11OGs/RUAjpL5xil4q97sheMD2Q1HYYTsprcGBDecHpBwndAoPdKkE3WnJHOub/WP8gQDTWSF7tEGmyAXnGt1XD1bHMdkWCDtP1FwZDotZQ0IFx0pE/KHvD9atqUiEO+Fu5vc/6lZ5+kR3FAcSgNIIaRrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=JEJYgQG9; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="JEJYgQG9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1777326845; x=1777931645; i=quwenruo.btrfs@gmx.com;
	bh=3Bj+SvYeihTsWA+kLSEgtVE0FuLkofPNnnNfMiP8yDg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JEJYgQG9USkalvLSXXppZD1JESGgiVmAGLFlzcgrWV/6ekta0chmLVnzG/f+S/Y6
	 km8rKihJp27vj7cjllJRXyYRORiU8WystdMcFzE9ThB1nu7SaPGV1UFxeYG82KV+1
	 I7o4rtHEDqw5Nw3siL6UAusXHxF+DKzKVaR9z1uNq3+7qPYamNwH2TTUZ0qlbbkLU
	 QXBX1LF+y+F8BmOjVKJSBgcRj0eRvtsOvwboOupg609bRc/+vJTHZLqz4AYNiWntT
	 hN6/b9jm34XqvV1gnshTwSExjqYID7YNdrqJnjT2VWAx2FMthuREddeAkSJ+I8f2C
	 YNosXoo4CsZcuH7BZw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MeCtj-1vgDwR1qJb-00ng8E; Mon, 27
 Apr 2026 23:54:04 +0200
Message-ID: <af83ea95-fcf2-4405-9d63-2f4e70296105@gmx.com>
Date: Tue, 28 Apr 2026 07:24:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: enable cross-folio readahead for bs < ps and
 large folio cases
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1777189624.git.wqu@suse.com>
 <4eaa4b5b1839aecd6a2bed8f995e8430fcea8ba0.1777189624.git.wqu@suse.com>
 <20260427132155.GJ12792@twin.jikos.cz>
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
In-Reply-To: <20260427132155.GJ12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zCEuoH+UN1u8K1vbTMmlB+UVc8Ye0SVJtZJJRI4qxn7+Grc1Lzb
 pcPDLyT7LTEKdd26GpQZRJe1a6CGCWJprJe0FeySMMOp97eZrHdbOsSPixX70FyBMoiaOyQ
 DlQUV+5TmSXKWdyz9CPEQ+CTuEaqYfPJc2Q+kdbfZpoj3rlkZbwQ4WAFDHkCwJWZYl35R6E
 Gh5NHsguqJIw3gpoxApfw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YFI7+5hLbek=;jXPxbWEjhoO9Q+tKZtbxp2+vWcA
 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



=E5=9C=A8 2026/4/27 22:51, David Sterba =E5=86=99=E9=81=93:
> On Sun, Apr 26, 2026 at 05:21:03PM +0930, Qu Wenruo wrote:
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -358,10 +358,7 @@ struct compressed_bio *btrfs_alloc_compressed_writ=
e(struct btrfs_inode *inode,
>>    * Add extra pages in the same compressed file extent so that we don'=
t need to
>>    * re-read the same extent again and again.
>>    *
>> - * NOTE: this won't work well for subpage, as for subpage read, we loc=
k the
>> - * full page then submit bio for each compressed/regular extents.
>> - *
>> - * This means, if we have several sectors in the same page points to t=
he same
>> + * If we have several sectors in the same page points to the same
>=20
> The sentence seems to be missing some words, or I don't understand
> what's the meaning here.

This means the situation like the following:

       |      Folio range       |
       | Ext A|    | Ext B|

Where Ext A and B are backed by the same compressed extent.

In that case, if we're reading Ext A, the readahead won't work for Ext B.

Thanks,
Qu
>=20
>>    * on-disk compressed data, we will re-read the same extent many time=
s and
>>    * this function can only help for the next page.
>>    */
>=20

