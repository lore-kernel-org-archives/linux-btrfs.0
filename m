Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F32B37C10A;
	Mon, 10 Aug 2026 23:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786405006; cv=none; b=aLxAgYDHjWtVZAUMo55ervYde6OUbx1unyZQwKSVT8ejGOorGUKls2btY6PfdY+STR+YZva78IZe88WS/5yEvYIHZCVCVDcfwVfEPIk0kKuCO6tPjpLp0Ehnb7bq89gyQm8SIGc5IVelA7T9nxIcayXfq4dDDgmBfY2QITJVQ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786405006; c=relaxed/simple;
	bh=SrZCS7PQTySLxUnlZMDFlA+d6EcTuTxZux0QPqT/anw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=G5lXALV14EVZf4iANgFUcCgVgqp/NuXCXpc04HLx0gDTdGtEthsFquV0FS6GoF40L0qKe428rblAvjChUxT4PXXRTbeTbvT0BCeznF7S95A3vF1GB77RHhII1TJm2dJ27UFhWYArhS/W1J9ZE4raPKTZ3UXZXfNCyNgfRlhX0K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rlZ8JPqd; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rlZ8JPqd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1786404995; x=1787009795; i=quwenruo.btrfs@gmx.com;
	bh=SrZCS7PQTySLxUnlZMDFlA+d6EcTuTxZux0QPqT/anw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rlZ8JPqdtAMho+1LKQrS9fXmlUzPQmS47t71UIioThuLAThbyeWMuuYDwv0QLrb+
	 ZhE9aYBk2QNAJQTgU5KshQ8Wd2bg0+om2fWHci49TwLUGEUrDJnviPRzzx1+nhr8M
	 bgIHTiaAoC+2zrtHdnrNyl+ZbKxBuXtZzmaejwiyUi+HzKc/iS5i7GGBEtoZAmGEK
	 Bz6m5YEmy1JXNyrZzcwS9l2AP0LL1Nn7+xftYmg4W84TAgaccanCbhbqAXQA7y7Da
	 15sNtc7kBP5bP4gw/z5Z/RV51NBpgonR4e9Ro8yNvJM49Yo/S07wvX/jMEPCjHe+G
	 t/mA2yL/p+NxLd7SDw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MQMuR-1wXnZT2tEX-00KSOJ; Tue, 11
 Aug 2026 01:36:35 +0200
Message-ID: <4c5256bb-9536-4852-a590-c0c0dc178514@gmx.com>
Date: Tue, 11 Aug 2026 09:06:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] btrfs: fix failed sprout device add rollback
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <cover.1786358930.git.3497809730@qq.com>
 <tencent_AD274BC8BB1B11444FCC2955080F81A2BE06@qq.com>
 <b3dd9bf2-7318-43dd-87c1-a72b979eb796@gmx.com>
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
In-Reply-To: <b3dd9bf2-7318-43dd-87c1-a72b979eb796@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jOFWgucqUknKdQPAsi5b2C2zuO7JlPm+R1VlCxYB2WEZAMj7xk0
 Cu9goPqRBMp0HJE9iwr1K/J3zu6f31BM9rZ+ztYcBnusKPjnzijkzlP8lT+k4yMyb73kbDJ
 e4qbg+PcQbv89Vcn9ZXO5UI9Hj9KEXgeQvE5kEgeIT3jOF3tiSDcz1uJdP3bbXpbsJz2ofC
 /qc1+dA55d/A/24pWuGIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YjoaD45Yl3U=;LMhe7Cet0iCy1Dpo+tp72aih7lU
 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



=E5=9C=A8 2026/8/11 08:46, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/8/10 21:46, Guanghui Yang =E5=86=99=E9=81=93:
>> Hi,
>>
>> This series fixes the error path for adding the first writable device=
=20
>> to a
>> seed filesystem.
>>
>> I verified the failure path locally in QEMU with null_blk and a seed=20
>> btrfs
>> filesystem:
>>
>> - create btrfs on /dev/nullb0
>> - set the seed flag with btrfstune -S 1
>> - mount the filesystem read-only
>> - run "btrfs device add -f /dev/nullb1 /mnt"
>> - inject -EIO after metadata chunk creation in init_first_rw_device()
>>
>> Before these fixes, the injected failure triggered:
>>
>> - WARN_ON(!list_empty(&device->post_commit_list)) in btrfs_free_device(=
)
>> - a NULL pointer dereference through btrfs_show_devname()
>> - the sprout fs_devices state left with no open devices
>>
>> Without the injected failure, the same device-add path succeeds.
>>
>> AI disclosure: AI assistance was used during code analysis, patch
>> development, and drafting parts of the commit messages and cover letter=
.
>> I reviewed the final code and local validation results and take
>> responsibility for this submission.
>=20
> I mean the assisted-by tag for each patch.
> I'll add them when merging using your last disclosed one.
> Especially you seem to intentionally leave a blank line for "Assisted-=
=20
> by" tag but filled nothing.
>=20
> Hope you are not pretending to find all those bugs by yourself, not only=
=20
> for btrfs but also for all other subsystems you're going to submit patch=
es.
>=20
> And tell your agent to add the "assisted-by" tag or read the=20
> "Documentation/process/coding-assistants.rst" file.
>=20
> Otherwise the patches look good to me, and will be pushed to for-next.
>=20
> Reviewed-by: Qu Wenruo <wqu@suse.com>

More minor problems to your patches, there are lot of super long lines,=20
over 100 chars,

And DOS line endings in patches.

Run checkpatch before sending it.
>=20
>>
>> Changes in v3:
>> - Add AI assistance disclosure to the cover letter.
>> - No code changes.
>>
>> Guanghui Yang (3):
>> =C2=A0=C2=A0 btrfs: detach failed sprout device from transaction update=
 list
>> =C2=A0=C2=A0 btrfs: restore active device pointers after failed sprout
>> =C2=A0=C2=A0 btrfs: roll back sprout setup after device add failure
>>
>> =C2=A0 fs/btrfs/volumes.c | 43 ++++++++++++++++++++++++++++++++++++++++=
+++
>> =C2=A0 1 file changed, 43 insertions(+)
>>
>>
>> base-commit: 38fec10eb60d687e30c8c6b5420d86e8149f7557
>=20
>=20

