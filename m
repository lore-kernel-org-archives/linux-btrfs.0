Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BEC1A6839
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780351902; cv=none; b=hwuXJ1GIYYQkzJmeye/l6exFvKOvP5hLR1KiwtotXXJ6t7Mc/vAR6lE851jnFoARFndT23S6Gger/YDjw7UE2TTmO77f0rkce9pT3lmEztfRfKtO1nLS5pQaUONUJtPofdRWIBHNjwW7gdGvUe9lBJ0gMn7RF41ezgUKr1v9AKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780351902; c=relaxed/simple;
	bh=uGDHy+F0pnIx/H/GgQni1+FdPdnq6UKGJTQiEwBligU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IX+cxFp9wEnuowu/cFSqI0/9SG4hpvhgWhxbb8JI4mq90wnmPjA+L0TA1LjEEKRxeDno5Pnu5EcZVBbYvXdci7VaMldHdcZV8dSCi0e/zlb35XkAHJe71ulOvp5cdesRHWoryb35ZgaJ4FN7fytfg2JSAGoW605qC3mxdv4flbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=jbtEHgg4; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="jbtEHgg4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780351898; x=1780956698; i=quwenruo.btrfs@gmx.com;
	bh=E2w5iO+pENJrRsDm1NF3xIKMIQcuuv3jakP6V4J0TtQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jbtEHgg4y/Fi2Fbj+/HSObpB3ODXiFr08duY1pyY4rrgjVGxt0XOQmSZTP44V5ap
	 9KFXUt794zU4lm3+ltb9i2YNs6Ys5QWyJkCT/LgMVKbCemul0fc47do+VeJ9E7Na3
	 A3LKC/Iux+n8isCWwFFH3M97wX6mSGntuvufrOEdBwuODt7ENGupQOBMJfrBIzK7q
	 jQCn1P6RuGDXFwpFSu84jQ4BLvUveGubvnnKtTyCTvFiMJcw1u9x7eU2YEI4Y1C1y
	 Q/1sSzxzb/FA7656uL6N4Idrs3EBfkSS4ux7zQJfuqhmoxaAo5NNSpxsNw0olmY1g
	 ySzBseb380YM91CGNw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N4Qwg-1xSMYw47ew-018DQT; Tue, 02
 Jun 2026 00:11:37 +0200
Message-ID: <04af4b51-9039-404f-808d-0011443f8ba6@gmx.com>
Date: Tue, 2 Jun 2026 07:41:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG report] btrfs/242 triggers kernel NULL pointer dereference
To: Su Yue <l@damenly.org>
Cc: linux-btrfs@vger.kernel.org, Su Yue <glass.su@suse.com>
References: <wlwir19t.fsf@damenly.org>
 <7edd1a98-4683-463d-b789-e75f7cb42de1@gmx.com> <ik82qx2i.fsf@damenly.org>
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
In-Reply-To: <ik82qx2i.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kf6Vz5GvgoenKTlLaVXQGIklo2JFtetbTwJcDzJUFm9mPGzjgyM
 pEVGkkFTSlVFReBCCkcx2VzoQtI1zOBLd/aVi2Uarw+EwtieMrJ/sEzEbGEJ45yfB4xlHNF
 dkq6CCs7K7b/+RIclUCKh7K1QI0SeNn9VYA9c+wkmGzwFIirwW7nBFUacxwXZfwjGIjeqFX
 YqiVGzxx5bBrq270HcJfQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n6by+G4XsOU=;ckPqE3WjheFfgq3wy/s4RzWnNwv
 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
 4DtsIPwEDQKVmt9SYY=



=E5=9C=A8 2026/6/1 21:42, Su Yue =E5=86=99=E9=81=93:
> On Mon 01 Jun 2026 at 21:23, Qu Wenruo <quwenruo.btrfs@gmx.com>
> wrote:
[...]
>> Since you can reproduce it on the latest for-next, mind to provide
>> the for-next call trace along with the faddr2line output for pc
>> register of the for-next run?
>>=20
> Sure.
>=20
> # ./scripts/faddr2line  fs/btrfs/btrfs.ko  btrfs_trim_fs+0x36c/0xa48=20
> btrfs_trim_fs+0x36c/0xa48: bdev_max_discard_sectors at /var/lib/
> btrfs-linux-for-next/./include/ linux/blkdev.h:1449 (discriminator
> 1) (inlined by) btrfs_trim_free_extents_throttle at /var/lib/btrfs-
> linux- for-next/fs/btrfs/extent-tree.c:6628 (discriminator 1)

Thanks! This is super helpful.

However this looks a little weird.

The NULL pointer dereference is from bdev_max_discard_sectors(), meaning
the bdev is NULL, most likely the device is missing.

However just before we call btrfs_trim_extents_throttle() we have
already checked the DEV_STATE_MISSING flag of the device and will skip
any missing device.

Furthermore the test case doesn't change the missing device state during
the run.

So there seems to be some weird race, or desychronization between
various bit flags.

Mind to test with the following diff?

Thanks,
Qu

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6030cdbdb742..94535c90de22 100644
=2D-- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6624,6 +6624,13 @@ static int=20
btrfs_trim_free_extents_throttle(struct btrfs_device *device,

         *trimmed =3D 0;

+       ASSERT(!test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state),
+              "devid=3D%llu path=3D%s dev_state=3D0x%lx\n",
+              device->devid, btrfs_dev_name(device), device->dev_state);
+       ASSERT(device->bdev,
+              "devid=3D%llu path=3D%s dev_state=3D0x%lx\n",
+              device->devid, btrfs_dev_name(device), device->dev_state);
+
         /* Discard not supported =3D nothing to do. */
         if (!bdev_max_discard_sectors(device->bdev))
                 return 0;
