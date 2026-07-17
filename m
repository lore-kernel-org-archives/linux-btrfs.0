Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BC3CB543;
	Fri, 17 Jul 2026 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271488; cv=none; b=ac6i+TAb/sBYbP3DiYyWrqPIPQ60vvIneBDDFXZmFboPe6ORtKFMMYeh2Hc9r6gTg2vE/oZLPLoeUyniBKpWb9VTUPukpYyM9/mqfT8u7izjr4o81oO7CxA97AzaICU98Qv8i2ABcz65ovQ5D6RYZkXrDvfvKxtiIbL5oMs85ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271488; c=relaxed/simple;
	bh=8MpIPeXcoFUshcYLnWwUoQQimvC4vKMUE+UFbuxq5tc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=TU6mpZK3PEnKxbSQ2Y/2vH2Vk4RfXdh2uzoaWZPKhGugrfeLSUSl+LzzQgpM3MjE8aAHNrYjS472koyyu31VtiURsDtKCeKea1hi+D017kUsElyiMoARFTr/jQKgsOocVahNKDceIAkETske24OwW57DBBh1PGaoraax4yEPHCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=SFl7ok8z; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="SFl7ok8z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784271480; x=1784876280; i=quwenruo.btrfs@gmx.com;
	bh=Mypkr3rxdu9Xyka8DbExmuQe7yGVucUgakPo2fQf3e8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SFl7ok8zWDUY/SPeOMX//bq15JPB+ie5DZJH3LxEWZqxDCHvKBTnkX/40YNK6z79
	 NsOlj/fT3NDtjWkXSYkaag5m2uKaxTzZLbeI+qZZ94pOYQ2qKhQeNPvSnc7Fd8+9Q
	 B1hxcsWL/Bfi5LzLg0Ew6+uA3DX8BG+QVzXk+8le+6FfsYecGrvU0XhFLqwVDoJlm
	 60+MaJWqj2Em/90mvFWSrjn7rhO+dZ86qzH6AtoXCRFk/S9nFB8sRb0ysmZv0JcQG
	 BEtJwJuTBvRE4W2/GAgeh8TOMTRFFD8zmyDik3Ys1EFEf3F6NjtE7Z0nOJsfFnlzj
	 BzcZrp+sloEecuPksg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MXXyJ-1wWYX22DHz-00ViN7; Fri, 17
 Jul 2026 08:58:00 +0200
Message-ID: <9b3313bd-cdb2-455a-9dcf-e1106276974f@gmx.com>
Date: Fri, 17 Jul 2026 16:27:56 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christian Brauner <brauner@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: generic/633, generic/696, generic/697 failure on btrfs with rc2/rc3
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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2kc3/Cwt9pI8ZDFQvggSGxC91rebdavsaMMhFHCwZS5Km4kgeBw
 wlHcs8pebvnKP5rTxUHqpK7fU8IGNhb6Hna2SMX9guMXX1acWw6RHhD+tsTGNdYVtbIkT7T
 ZKVnXApATxhqfwLpxz8QJA1/Jm726+vF9XaysSBgdybRv3B8y1qAxdI6p+7DWSHVAhN0uC4
 jptQyqXOy076f6MiTdN9A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nqC0kJueQjo=;lhHj7ZK4lQd0m0AXrlDQYvpb4vm
 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
 WCf2WiduO8vAWvWR1daSO

Hi,

It looks like 539dce114465 ("fs: refuse O_TMPFILE creation with an=20
unmapped fsuid or fsgid") has changed the behavior that the above tests=20
will fail on btrfs/ext4/xfs:

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 btrfs-vm 7.2.0-rc3-custom+ #411 SMP=20
PREEMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch

generic/633  1s ... - output mismatch (see=20
/home/adam/xfstests/results//generic/633.out.bad)
     --- tests/generic/633.out	2022-05-11 11:25:30.816666664 +0930
     +++ /home/adam/xfstests/results//generic/633.out.bad	2026-07-17=20
16:25:45.033967541 +0930
     @@ -1,2 +1,4 @@
      QA output created by 633
      Silence is golden
     +utils.c: 948: openat_tmpfile_supported - Value too large for=20
defined data type - failure: create
     +utils.c: 948: openat_tmpfile_supported - Value too large for=20
defined data type - failure: create
     ...
     (Run 'diff -u /home/adam/xfstests/tests/generic/633.out=20
/home/adam/xfstests/results//generic/633.out.bad'  to see the entire diff)
Ran: generic/633
Failures: generic/633
Failed 1 of 1 tests

Did a quick search but didn't hit an exact fix.

I guess we need to update the test case to avoid the EOVERFLOW errors?

Thanks,
Qu
