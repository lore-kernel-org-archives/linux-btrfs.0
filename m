Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5E3054C7
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 23:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789861121; cv=none; b=jq6i6GW8Nej9TNLbhEyQeQO3Y4SKFr+PjtzWajdUGseZoEeVzDwuQ4cgNbCzYRGUbjpXtJemPo8wdyrFkyzp9A0PS0V4/GfWcvv5YOKYvK3Up6g7qDehsHfkdIvmM6oO0Ml3TgP6M9xmWUBDiZX+UKiu2HBhiAvxtN62etGOAtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789861121; c=relaxed/simple;
	bh=N6gQTrATSoQqK8hJ+AK99k+uz/+tGc1KaHNBMDOcXak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiNtNqTIXkc6sCmCp296fsQW8oqxDQlLNdJxCnYNYCdGO1FLZMOC6O8tQxu9YOolXRKCGqo96c56nZarCnFk0ImOVJVCnnoLSBdD30pDooM0kNNaY3rcS9DHGJeIj/cRpRJtEw/rTazukELzBfodopnwMzHoSmzC4AgCTNWWwkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=N4TsHK+H; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="N4TsHK+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1789861117; x=1790465917; i=quwenruo.btrfs@gmx.com;
	bh=ZEoFLmZ1Q+M2btDlJgvdN98ZJpz3xtFN6MdCnsdJhlI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=N4TsHK+H9RooKhwKhwNMkiatfgQ6jN0t+KAeXY/7I7X2c8VgDPvndG0V+uPD68So
	 0EEHuLH6qfzpN6nj5jDx078hxTdBsoMX8a14Cq32z2JQCrjynX5F0rvih6lbG+XsS
	 FyQVo9q8GgpiqW67Rz6iXqq54W61gRwgQ7En4OY4NShkCq0/k+byPnZ8t2GIVy7X9
	 RdCuo6+kyvB8Kx/z+hOiBi0NOQnJMr2XKUQCQdlr2kJgVJ553KeFIITPEEnwn0zph
	 IOE58bVmlMmQh4mg0t41Bvfq9JaRjzmYLkv242IBOU46u6628WerHWWPEgHqE+myx
	 T8E4Hbl/xcRaw9vsPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M1Ygt-1x52lb1RqF-005hd9; Sun, 20
 Sep 2026 01:38:37 +0200
Message-ID: <72837ffa-61da-4ea1-9d98-ad2a350a955a@gmx.com>
Date: Sun, 20 Sep 2026 09:08:33 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: qgroup rescan worker makes suspend fail
To: Richard Weinberger <richard@nod.at>, linux-btrfs@vger.kernel.org
Cc: johannes.thumshirn@wdc.com
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
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
In-Reply-To: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5v0O4NPPjXVdJ8hXhnscAgWK+ZD1l/LQxZWt1LTk9hyJvQFtatT
 grUR8IsipXIN2esymYLRDRlHcHBuhlE4m2Ss3MbW0+2OPJ6YxWA/ifr+c2CcqfsWa/jS5zc
 VYlq7hT5F9+MYgqMqgnXePfyqMdinmmk/xF57pvyYf9CFMNzWKdnecU5dVdNfwTNCNMx84n
 aygyi20GvJAgknX/9sJ7A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:K+6GzlC+MKk=;GgricPRGcuHSrroxrymHKwJbOlh
 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



=E5=9C=A8 2026/9/19 23:10, Richard Weinberger =E5=86=99=E9=81=93:
> Once in a while, suspending my laptop just causes the screen to freeze.
> Initially, I thought Linux had crashed, but it usually recovers after 2 =
minutes,
> though the suspend doesn't actually happen. You can imagine this can be =
very
> unfortunate when you just close the laptop lid and pack the laptop into =
your
> bag...
>=20
> After the problem started occurring more frequently, I investigated and =
found
> that the qgroup rescan worker is the problem. In dmesg, logs like these =
can
> usually be found:
>=20
> [246013.777637] [ T278489] Freezing remaining freezable tasks
> [246033.780538] [ T278489] Freezing remaining freezable tasks failed aft=
er 20.003 seconds (0 tasks refusing to freeze, wq_busy=3D1):
> [246033.780576] [ T278489] Showing freezable workqueues that are still b=
usy:
> [246033.780582] [ T278489] workqueue events_freezable: flags=3D0x104
> [246033.780590] [ T278489]   pwq 10: cpus=3D2 node=3D0 flags=3D0x0 nice=
=3D0 active=3D0 refcnt=3D2
> [246033.780609] [ T278489]     inactive: pci_pme_list_scan
> [246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=3D0xe
> [246033.780649] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 ni=
ce=3D0 active=3D0 refcnt=3D2
> [246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
> [246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=3D0x2000=
e
> [246033.781189] [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 ac=
tive=3D1 refcnt=3D16
> [246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper [btrf=
s] for 111s
> [246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=3D0x6
> [246033.781726] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 ni=
ce=3D0 active=3D0 refcnt=3D2
> [246033.781736] [ T278489]     inactive: wg_packet_handshake_send_worker=
 [wireguard]
>=20
> My first thought was that the worker is likely not freezable, but it is.
> The problem is that the whole qgroup rescan is a single work item.
> In my case, such a scan can take up to 10 minutes, even though I have a
> fast NVMe SSD installed...
>=20
> Wouldn't it make sense to have rescan_should_stop() return true when
> suspend starts? I think using a pm notifier could help here.
> What do you think?

Mind to try this diff? Although it requires certain pm freezing=20
sequence, for now the kernel freezes the fs before processes, thus it=20
should work:

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 05e35eb126dc..9ca81dfb9ee8 100644
=2D-- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3872,6 +3872,8 @@ static bool rescan_should_stop(struct=20
btrfs_fs_info *fs_info)
                 return true;
         if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,=20
&fs_info->qgroup_flags))
                 return true;
+       if (fs_info->sb->s_writers.frozen > SB_UNFROZEN)
+               return true;
         return false;
  }

>=20
> Thanks,
> //richard

