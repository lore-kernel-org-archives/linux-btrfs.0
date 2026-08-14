Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1CB3DB994;
	Fri, 14 Aug 2026 03:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678212; cv=none; b=eAlxeSWI4zyVgoIvzd1qIS7awjHPoR3o5864oYABld7Wz0TqxGyux4VrVskGrPG8bSM7TwGCCX04OKOzHujlIyNPzLIdsAn+rtNxKs3l9/9hW2XWZ3sJmdGJ3UN6uZsYrqREB0lHHNvDav1mAX2uxP8SkkoKmwY6ZrX0A/hGNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678212; c=relaxed/simple;
	bh=02E9NQTbLSIZDnaov2S8hEdlHVv3ickbnfnx+cyRYGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2AwCnS6vYweTsWrrM3UtAqpfCj44NNBkN9KhcLUy29IlHkS7e2gMmldtXB6GYV/ft/JEJgUP1zRFxkK4QyKowBMiOgmDQ9oy9kMsJf1tRz3xBg7zurHQNo194VQ0e/MHInCxmuPkqqCYm8W2vxsqlnWNMBKeVAUMcuklOGYm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=GNKiafPf; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="GNKiafPf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786678189; x=1787282989; i=quwenruo.btrfs@gmx.com;
	bh=qy9L6rm0nWj/jDttflnZqROl7i8owJaub6mNIyl0m50=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GNKiafPfUYCbSd02MFWVM7ZuMN+BXG8sI/jjmjAPhA8TYuS1mHutqGQr/wkQRVUT
	 7aL/t4YrD1FxVoGg5xrOAbdtm/ToCLYT6DMdMPbvqxx2Ehk4+4elFlSg+ieG+bXzt
	 qVzrW5VeJUVkotybHtBUkSI1k4OaZFkrlDCdH2ukSvGMKapuV/mS+ToHhNTuPTmQg
	 73MJkxjBGa+KxcR8msEllx6fOKaBFKYbhPUCZLTu7KmpGTck8kBh8ZqEI2WbTuZkQ
	 hY/axVTqkUNTm64++bFPYUSHF0oNIdxArDfSzfKsclnV6svUOIEGVVYF4FQ/m/ZoN
	 Wdqj5Ont6dBor7vhvQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MhD2O-1xOqNC43JC-00czR2; Fri, 14
 Aug 2026 05:29:49 +0200
Message-ID: <faf160bc-b4fd-426e-a3f1-367272e50f9b@gmx.com>
Date: Fri, 14 Aug 2026 12:59:38 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use mount idmap for defrag permission check
To: Seth Forshee <sforshee@kernel.org>, Tao Cui <cui.tao@linux.dev>,
 Qu Wenruo <wqu@suse.com>
Cc: clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, brauner@kernel.org,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260813034146.1207640-1-cui.tao@linux.dev>
 <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com> <an36yH30W965eqZk@ubuntu-x1>
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
In-Reply-To: <an36yH30W965eqZk@ubuntu-x1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FjGEpjTzlSiA4c/73vPIBc3193p4wEQuw5v4t9VC65B1PswhmAW
 HAO10Duecx6fazBMWQLO1/h4iKxjC7wUG0j2qFr6I9ueeS9BEWvD/5JXOsoaCrBLRMi59GQ
 +aYCzaTjx3HgzN71ywcN1XmvD+KszMWigHAow3NhPME82oMQqLwh1tb2wVJsUF8+pJ9JjrL
 68ZjlXhQs2lB9Jmpao5nw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:A0XmXBIFKdA=;xWNqI+FYlrVU6V/S7ZfBgY7hfol
 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
 22aXJwh7RDPO/q/SEhCocQg0Y7NE=



=E5=9C=A8 2026/8/14 02:41, Seth Forshee =E5=86=99=E9=81=93:
> On Thu, Aug 13, 2026 at 04:04:05PM +0930, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/8/13 13:11, Tao Cui =E5=86=99=E9=81=93:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
>>> the mount idmap.  On an idmapped mount the owner comparison then uses
>>> the caller's fsuid against the raw on-disk uid, dropping the mapping.
>>> Every other permission/owner check in btrfs ioctl uses
>>> file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.
>>>
>>> Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
>>> mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
>>> unprivileged callers on idmapped btrfs change.  The RO-fd note in the
>>> comment above is about the file descriptor, not this inode check, and
>>> is unaffected.
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>
>> Fixes: 4609e1f18e19 ("fs: port ->permission() to pass mnt_idmap")
>=20
> This is a misattribution. Using nop_mnt_idmap there keeps the behavior
> the same as it was before the commit. Switching to the mount idmap opens
> up BTRFS_IOC_DEFRAG* to idmapped users when they weren't before, which
> is a separate policy decision that didn't belong in that change.

OK, removed from for-next, and will not add the fixes tag.
>=20
> Saying that these ioctls should be allowed for idmapped users just
> because others are isn't a good justification. Why are these ioctls safe
> for idmapped users?  Do they actually require this capability?

I'll let the author to do the explanation.

Thanks,
Qu

>=20
> Thanks,
> Seth
>=20

