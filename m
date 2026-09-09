Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362CA2931C0;
	Wed,  9 Sep 2026 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916430; cv=none; b=j5km3UzSE1bKkH9+cq8nsXCfbnsp+DRvvjh0lznmk7canWz9H9tXVY18WXhdGT2qTIqMhKACEYZgHali/fHmYEM3CUwD8UvscnJchmWU44AHEy+cFE5J+bswGPI+1Xx3Suc9nD9rRcMtXVEVWTzoVwoSB8ciUqbHlS3yPbZIzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916430; c=relaxed/simple;
	bh=oj/zzZLe7fXwvD1zJ2ykSYAovkGZAZE0/WusmuS7zSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YRcPXMVJ1zDehVJyFQ4xYS/pisFynLAUuV94WAZ1rpWNzMXSMyEnPExtHSqn25auEq/SpTBA5Q/bhSvSctdLPr7xe7CgfqZBwe5fttnDRv3h5tWjv3cms4G8ZEDJ12na25+znjnzAINH6wiK24cHEx/r2k7yFtSTTGcCxg8Zpd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=oohCVzgO; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="oohCVzgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788916425; x=1789521225; i=quwenruo.btrfs@gmx.com;
	bh=vMJK2RoT+7egZpspfqkOem5g6aZ6Swkeq0xnZz/fjM0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oohCVzgOn+m3BudedDx1OZJUIwycdaR/JEVqkxnaWTrG5qNzhaS3tZI/bN71jmQz
	 2v5JbpblsvYwg+hpoVLlYJ1ASy0bdKPNlQUJeQ2zNRttn9GTTIr15gh8uTJkmRQpZ
	 H2p3SKJbgKfO3zXgrsE0XFHuI/4x9vRJKbbv2Io9cifRyIPUgFHvep60WDKw6xPr4
	 2C91mRF5D/gT14pLknp4rLHnak+TyeCgewUvnC0V4jeFGAoSnS0FQUaFWYDDky0KV
	 SHBodbbeXLUA6Djkcv1A3e3DWlyb1DV9TG+fU5Rws20vcfePCB5+9a4QVRye9YRPs
	 c9DNysZK44cGrTU0fA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N1wq3-1wg5mz3koj-013AMH; Wed, 09
 Sep 2026 03:13:45 +0200
Message-ID: <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
Date: Wed, 9 Sep 2026 10:43:40 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: dsterba@suse.cz, Alex Romosan <aromosan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
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
In-Reply-To: <20260909002506.GF9053@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:H0VzSqYvWpQZz8RXnZL/w/+EI+urXbGIOFp8hmVCmpDB2yuQTf5
 xwSxnqsw3cRO0CLBCQPqp0xaRcScADd+KLX4rwb9Up8HSqzWwbKo9chMZ20aa/iwZY7CkFg
 VWDpySXgrGLwb+yjodGkT+4bTTM8QiVH+xMNbqxPRhEE6vjkAWfJjzI0ur2T7rd5EpVRy7U
 wVRYQbjLKsXg9U8hnmwqw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JBQry2fqHCU=;qVZFK6LRv6ynVyhpsX6OWiuDIkz
 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



=E5=9C=A8 2026/9/9 09:55, David Sterba =E5=86=99=E9=81=93:
> On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
>> Please Cc me as I am not subscribed to the list.
>>
>> Running my own compiled kernel without initramfs on a lenovo thinkpad
>> x1 carbon gen 7.  The linux disk is the only disk on the system. Since
>> version 7.3-rc1 i haven't been able to to a grub-update, instead i get
>> this error:
>>
>> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounte=
d?).
>>
>> 7.2 is fine. a git-bisect identified commit
>> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
>> reverting this commit from 7.3-rc2 allowed me to run grub-update
>> again.
>>
>> this is not the first time i reported grub-update being broken on
>> btrfs. i reported exactly the same problem on jan 8, 2024
>> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
>> the discussion that followed would help come up with a fix that will
>> make everybody happy.
>=20
> I remember debugging that one, https://bugzilla.kernel.org/show_bug.cgi?=
id=3D218353
> Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolution
> during device scan") would bring back the lockdep warning and there is a
> locking problem.
>=20
> The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
> device path update for the same device"), the difference is in lines
>=20
> (https://bugzilla.suse.com/show_bug.cgi?id=3D1230641)
>=20
> -       } else if (!device->name || strcmp(device->name->str, path)) {
> +	} else if (!device->name || !is_same_device(device, path)) {
>=20
> Which gets changed to (by 108cc8733989):
>=20
> -       } else if (!device->name || !is_same_device(device, path)) {
> +       } else if (!device->name || device->devt !=3D path_devt) {
>=20
> Each change is reaction to a bug, I don't see a clear fix which will
> make it work in all cases.

And I want to add that, the previous path based comparison is also=20
problematic for namespaces/weird block device names.

Although not common, it's definitely possible to map weird block file=20
name into a namespace.

Thus the path based comparison is not reliable in the first place, no to=
=20
mention the later lockdep problems.
