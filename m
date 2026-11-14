Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.120.160.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794652184;
	b=tC7oTszSV7kVg3MbJ7rHCuGBgCMU6WXLxQJmONRxS+5rwM0svQTD8LYGcuR0MeHWnlfJ
	 4lpkexuq5lYhxol9Gk5sn4tr++aCu6lrFXIQLhEgF/xQcnMjJIjGMQbaUrkV7ohwW4h2b
	 j6taz7YDtgYOftgPgC8pUDhtHOg1SAwCdFRiQxlVGta0bPDPmuFgc1zwzhS6WZ7+52Cj6
	 lyPJ4e6ytv1IDwx/T4wQ/dbVCCEfjuPgz4UwnbwUmUolIX+J7FI9NGQbqqLJXyWcUngR7
	 MsJM6ApmCSmfdI7yr2QISFf1RHUuLBIM2Q9wQqXOu/lT7VK0DuDsbh8n6+V/syj8+ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794652184;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=12X51jK1O/PQJBixDC7eeAU7nooKJureWbz7mE/Myyk=;
	b=Bv6eoPpM2xNh92RbwHbHovTuntq2mqxf5MPZECF7Hj/9lHjv3iuSlPuhCL9rKZFZNRc+
	 POM+6VBBgKS/G8rhkN+5jtY/lWGj93QUR9DpeCnrtPRgN99h0xw07uz0MCqSQKSxnECYm
	 mlIQm5krv2+jLm6NUhmAGw66x+ZCzIqbds76qVzLz8BqauHzqx/4qWnCHzC51PV/kOBJr
	 rK7jv/ZQVIzjXm6P3wjTy4qPE4sJVxJi97/ouiRRCXd1v18zt2cWfntH8WDu6QupEMgRM
	 SP+sOgGnttczpbN3JjxELYH28D138YTefdd53yK8SXs0jagA7kyev2hs+ibdDNUyvNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lichtvoll.de;
	spf=pass smtp.mailfrom=lichtvoll.de;
	arc=none smtp.remote-ip=37.120.160.25
Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E3A606A333
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 10:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E3A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6F836291B13;
	Sat, 14 Nov 2026 10:29:33 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: BTRFS <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject:
 Re: SSD overheating during scrub in laptop (SOLVED: no overheating but
 firmware issue)
Date: Sat, 14 Nov 2026 11:29:30 +0100
Message-ID: <-8JrlgE5SLizPVsfOSFaOg@lichtvoll.de>
In-Reply-To: <967be80b-f683-4611-a473-0ad02897c451@gmx.com>
References:
 <1938311.tdWV9SEqCh@lichtvoll.de> <2031348.PYKUYFuaPT@laptop>
 <967be80b-f683-4611-a473-0ad02897c451@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Greetings Qu, greetings.

Qu Wenruo - 16.09.25, 23:17:18 CET:
> >>> I have hit similar situation, but the symptom is very different, the
> >>> death come silently at boot, the drive is no longer recognized by
> >>> the
> >>> BIOS thus no longer bootable, and Linux kernel from liveUSB will not
> >>> recognize it either.
> > 
> > Hmm, did you capture any logs?
> 
> Nothing suspicious at all, except no PCIE device detected at all.
> 
> So in my case it's really toasted so that it can not even be detected
> anymore.

I think I finally got this sorted.

You have been right, Qu: It was no overheating issue.

Just completed a scrub of 2 TiB data. Twice in a row, first on TTY without 
loaded desktop with about 3 GiB/s, then on desktop with power-profiles-
daemon set to performance mode with about 3,8 GiB/s.

Sensor 2 of SSD temp went up to 101 degree Celsius and it was no issue.

What did I change? I upgraded firmware from 4B2QJXD7 to 8B2QJXD7 after in 
a dialog with AI I was hinted about issues that users lost their device at 
least temporarily after unsafe shutdown. Or even needed to send them in 
for repair. Luckily I never had one of these.

However they also wrote something interesting about read-operation 
stability:

-----------------------------------------------------------------------

* (8B2QJXD7) To improve read-operation stability. (Release : December 
2025)

* (7B2QJXD7) To address the intermittent non-recognition and blue screen 
issue. (Release: September 2025)

* (4B2QJXD7) To address reports of high temperatures logged on Samsung 
Magician. (Release: December 2024)

*990 PRO I 990 PRO with Heatsink will be manufactured using a mixed 
production between the V7 and V8 process starting September 2023.

-----------------------------------------------------------------------

https://semiconductor.samsung.com/consumer-storage/support/tools/

What can I say?

With 4B2QJXD7 a scrub of more than 1 TiB data was always interrupted with 
SSD being gone until forced restart of the machine, unless I paused and 
resumed it myself quite an amount of times.

With 8B2QJXD7 two scrubs of 2 TiB in a row completed without any issue.

Happy to have this sorted. Thanks for firmware update to Samsung!

So make a backup and update your firmware!


What a mess, really: Just took some years until I finally seem to have a 
fully working product. And it has not been the first firmware issue I have 
seen. Not even the first issue regarding this SSD model. Also I still 
remember "no operating system found" with Intel SSD 320 after unsafe 
shutdown with a firmware that should even fix this issue and despite this 
SSD even having some sort of Power Loss Protection (PLP) unlike the 
Samsung 990 Pro.

Another note to Samsung: Pretty please update the way you create your 
firmware ISOs. Kernel 4.5.3 and it does not even boot on my laptop? You 
gotta be kidding me. Sure I can extract the update tool from initrd and 
run it manually, but really? How about just going with Linux Vendor 
Firmware Service via fwupd? Then I would have seen this update much 
earlier.

Best,
-- 
Martin


