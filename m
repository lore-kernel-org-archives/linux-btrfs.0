Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E3B1FC8;
	Mon,  1 Jun 2026 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780356350; cv=none; b=TOZhGq1dwi88TErlU46aQkN7DvzHlGZvsumI3sXNV0e1dBUMrfopZ+uaeRYECHbxhZoD+YHncVvDSOuWX3L98ZutrNg1hKqhYjt28vuuxPVNVwZYpvVj7H3QAmSBtXGIwTjCVtRliKgawQwvtJEhTOPesPOh7d/sGk91qB9k00Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780356350; c=relaxed/simple;
	bh=Asaby4lXrsB07XM55hrY440qnhttSpyPT43wCOlNo9Q=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=rZqv/lLRO7Liz6S/6xo0PMRcMxDt3j5YLadeyuXTWeJOJg7cs0j9Xg9FX3VMXxZnMXdzarR2RhEK8767uuUU7wZYDwZf37XRe4fywU3ugF3Xv0T0eOzD9CvGK4TDTD5fRL6TRm/X7T7BJpBeVBG5UAuF6H7t2nj+BI3mqVW1iQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=ChnU6p3j; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="ChnU6p3j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780356346; x=1780961146; i=quwenruo.btrfs@gmx.com;
	bh=eFDh9UUfDdkc4FvoOjJ9TTVQzpR4DEW46vvIt3bO4As=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ChnU6p3jlL9RRgEX61RqmMONTgdOXv3+KRYvQPuscx84dsBRTM3eFnZTvQE674u5
	 hyeFuwA2BwL78llK9Q8rFvwFLh1LmUbb2ZJ1yza5nfvHZGNMv1dwqeuNUnH9sMziX
	 6qHNseHwCzzOJQEnCY9GZQLbBZfPLf5NPQG6P1tKSUvBn1Ei3m+SRBUNAvfb3USaO
	 EhMMSt4oCx5SSJyfs3VNO2cpp6NrHbT5uBEo7Rn/AYR9k/dZ5+LDqhknGGaIKei83
	 Hje55ChIJapwb7fnxbPgl4Y/SRKPyMonldBjj56GEc3H+tcOAtYd8XVLfNKx4hFX5
	 2mIlsd8aTwwahmT//w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MbzuB-1wzxaw2YwB-00fIaN; Tue, 02
 Jun 2026 01:25:46 +0200
Message-ID: <8550fde2-bcc6-4e8a-aa57-49944acba415@gmx.com>
Date: Tue, 2 Jun 2026 08:55:42 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Inconsistent mount option for TEST_DIR after _test_cycle_mount()
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
X-Provags-ID: V03:K1:AtX0dNpHQKpLzNCrgE904RyKnCH1WAvapPVmH67aGbMSYvp9bP0
 2spM9/L106U553dAZrxwVsvcchAiObi42incEsPPEeG0J1NpUjx/DxjtK73g3hCXVwdm+n2
 zkED0ZDXwhwN0atgBSOYVWnLXdsWL7ZzOoj9C2scD8/LlczgcwsHf+Rt5UFwmVhlsO6RM5m
 pXQpqjIGggnDp4diMq6bg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wJbG5c5wk2M=;EyT2sB8pK+eVHz9COB2OlvEyFaX
 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
 Dpotkg==

Hi,

Recently I'm testing btrfs with its nodatasum options to verify some=20
direct IO bugs.

But it turns out _test_cycle_mount() doesn't respect $MOUNT_OPTIONS, and=
=20
will cause mount options that affect new files to be not applied.

E.g, there is a super simple test case:

  . ./common/preamble
  _begin_fstest auto
  _require_test
  mount | grep "$TEST_DIR"
  _test_cycle_mount
  mount | grep "$TEST_DIR"
  _exit 0

With MOUNT_OPTIONS set to "-o nodatasum", the output looks like the=20
following:

/dev/mapper/test-test on /mnt/test type btrfs=20
(rw,relatime,nodatasum,discard=3Dasync,space_cache=3Dv2,subvolid=3D5,subvo=
l=3D/)
/dev/mapper/test-test on /mnt/test type btrfs=20
(rw,relatime,discard=3Dasync,space_cache=3Dv2,subvolid=3D5,subvol=3D/)

Note the missing "nodatasum" mount option after the _test_cycle_mount.

However I failed to find out how the initial _require_test is different=20
from the later _test_cycle_mount.

They all call the same _test_mount(), and that function never really=20
respect $MOUNT_OPTIONS, but still the first test mount still got the=20
correct "nodatasum" option.

Any clue on how to fix this weird problem?

Thanks,
Qu
