Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41B730F7EA;
	Fri, 12 Jun 2026 08:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252872; cv=none; b=TeIZKG0GL8S+2/BC1WgB9s8em/3CsUAcAcUJTdqEpk9nM2lCrt76KXdBhmHa5dKsBCJl83aqUCJXpP5vn+EI6Dvx+ahRVWg8SF+8IgXJtgP7VV+KCCM9Wr9evfKcXV/cEOheHDNPSYGtFd6PMc5Yl6rVyzpT3yEFDgCMwf3ib8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252872; c=relaxed/simple;
	bh=1kVaEdcKw/iBVDpmBcZvo3UImclFdFy7Kgu86PoE6bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jv5g/gaHHED9Rq3rKU1OTMvFzeWQaclMHz+sONfqNqY9iyXROFlt74wLKfTx0ORL2ZWKhRF7yJpBWh8d8DD+lxtrVt0AcKG3eTsYed1Qi+mF7Pr4inPPSxv3yRg6RLfy6xahGxPcmeQVp5truQPuvXprEjanLDErILGK6QPmNE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=uXxKwQeT; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="uXxKwQeT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1781252859; x=1781857659; i=quwenruo.btrfs@gmx.com;
	bh=bYA9sJRTwW3jXGyP74eIwb+0WnjsT/Xt81w613k/PKE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uXxKwQeTV/YZahIrkIu/ssskIZdkkmvt4bIgV1O66i2Ff3l56PgtDwpLodE3Wb51
	 llN/H1y5xnfAAx3i/iB6Yc/fSoITdBeM9GKehC6VsfDB2oo6rpPBJHoIf7s16pnq1
	 p86r3UWVqPtO6F/Yp4jBxBHY44QM2baSSN4YE061+MZkYxn3jSDKWI3bPQ6/KOMT3
	 JbASWod+F5J8i8jKYMwUbMiUooFGQoTp4Wz4WdqbUagm626T9HD4rb6MYQjSTxjIq
	 gnSExrozt7W0LAwozpP3CkcK+i2tJ6Cyw3WeN2AJ/omUlZ2Hr8CSdB4J4ErZawz5q
	 GEMT/PO8hiqL7ZmdlQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mnpnm-1wzvFY3ZU2-00fs4O; Fri, 12
 Jun 2026 10:27:39 +0200
Message-ID: <c1134294-dd9e-4481-9cfe-cd708c1d7de6@gmx.com>
Date: Fri, 12 Jun 2026 17:57:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Direct IO page bouncing got some garbage?
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <b866b2e6-292f-4c5e-ae5a-d77e983cfefd@suse.com>
 <f1dbdcd6-4e6e-4304-8fa5-59c2c60252ad@suse.com>
 <aivABK8nwNR6Z__A@infradead.org>
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
In-Reply-To: <aivABK8nwNR6Z__A@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tQ7KsZItlZjnq21lHDli+cswh02G09moeLuXet1erTiTt1yaPFD
 hXsnd4+Gx451b29Y3O8rrrBk5xUKluEDF7pzO+a5QMjkT7PojliGKqCzTP52C3tLJEYsbEX
 pWSnc/Lazt2TWnMaFtryYKiIq9VPpuLnXcdpJWdQ9Nz7cpCCZFSCmW7CJA50Q/CC0x/Cnv4
 8OhGmFjbmHfs5khOew+zA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZLvzbVSc/3Y=;2UoX3RvPJ60rfwyHmF7yWaVPQDe
 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



=E5=9C=A8 2026/6/12 17:45, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Jun 12, 2026 at 02:54:22PM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/6/12 11:11, Qu Wenruo =E5=86=99=E9=81=93:
>>> Hi,
>>>
>>> Recently I'm trying to make btrfs utilize IOMAP_DIO_BOUNCE, however I'=
m
>>> experiencing weird data corruption.
>>>
>>> During test case generic/708, I'm reliably hitting garbage pages at th=
e
>>> last 64KiB, the garbage even contains an ELF header.
>>
>> Added ftrace shows that, since btrfs has to disable page fault to avoid
>> certain deadlock, bio_iov_iter_bounced() failed with a short copy.
>>
>> Initially bio_iov_iter_bounced() got a 1MiB page, but copy_iter_from() =
only
>> copied 64K then failed due to the disabled page fault.
>>
>> I don't think it's a coincident that the short 64K exactly matches wher=
e the
>> garbage is (the last 64K).
>>
>> I guess it's in the error path we didn't properly revert the iov iter?
>=20
> Looks like it.  The better option would probably be not to give up on
> a short copy, and just reduce the bio size to fit the short copy
> even if that wastes a little memory.

And that will only work if IOMAP_PARTIAL is specified.

For now I'll just fix the short copy path, and continue to make btrfs=20
work with IOMAP_DIO_BOUNCE first (already testing and finished one round).

The partial bio return solution will require some way to pass the dio=20
flag, or a refactor to move all the error handling to the only caller.
Anyway it will be a dedicated series for the change, meanwhile the=20
simple revert fix will be sent out soon along with the btrfs enablement.

Thanks,
Qu
