Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4C5547043
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 03:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789790093; cv=none; b=QXfxWc2VTWkxTOS7vVAfBYUNx8ISZR9cP1s4m0/3CPMJYVOrWhQIGZpRkOfrou3ZeUeDTcKmTf21U7PLeDw0tyZwrVAnz/WBS/zUFD+VMnSfxvNgTzbT3uvZYJbaPvp8e0U+9HUq0y+2hlbgurJ8V+trnLUp1yX8W88DypiWwVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789790093; c=relaxed/simple;
	bh=gcC6EcEQqATSavjI8a6eyDQ7EBHhJdEM/YrEhsvdHTs=;
	h=From:Date:To:Cc:Message-Id:Mime-Version:Subject:Content-Type:
	 In-Reply-To:References; b=PT/buiTfVCfpWd0fJum7MZNEtpoWqpZR1fqIP/BzfBXkRgsCaBVTDSiWYbt3P+vHdxunBcP74rTSyTxB9NXajDBivjism0MdpEHKYG0dzhtUm3lVmXmybIKNboJzhl9a0LuloXBkwY8UfBo4pr13zS8VShdgFImOoz+QyvEdW4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=jgNFMvYg; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="jgNFMvYg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789790081;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=t7UYa3djtCgMTZenR1ZKwt5VugsjhDnoqVAjoYQL0bw=;
 b=jgNFMvYgmPr6nqLNbIcy2MFQ1XGaCz+27znL4Zs0i4bD7ZqfbErl38PjGZIT/FLNTRccwN
 rCMzR9AF42CNrwwOnuh4E12TpQE5RuOZaT3vpZ/aP0iqO2CF5I1oDw5PuQCbseJuBj9Cmq
 rCQ8I2kDA3bkdY8RVvMgpk5zb4nc8XPxdGTKtfqktCW1SGxs3LfFa8woT1iWrAMMKb/gp6
 AmjLqxClsOK5IPFubYid7HfCDq9whAGAn3bT9vx+zY1AoYq46hzmg5xYxB8n+rTVA3Qjhl
 SoDRVFGJHfz+ng2WiTcXPqw0zeNtyXeX6qdyoCkU1psSBo4tfBiMzNwNR9yCRQ==
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Sat, 19 Sep 2026 11:54:34 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
To: "Boris Burkov" <boris@bur.io>
Cc: <linux-btrfs@vger.kernel.org>
Message-Id: <7e87c73d-ee17-4d5f-aa37-648853b3910c@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: qgroup: use specific errors for simple quota rescan
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260918191243.GA2956775@zen.localdomain>
References: <20260916031104.2390777-1-zhudongjiang@fygo.io> <20260918191243.GA2956775@zen.localdomain>
Received: from [192.168.8.64] ([183.34.169.97]) by smtp.larksuite.com with ESMTPS; Sat, 19 Sep 2026 03:54:39 +0000
X-Lms-Return-Path: <lba+26aae0780+a75c69+vger.kernel.org+zhudongjiang@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/9/19 3:12, Boris Burkov =E5=86=99=E9=81=93:
> On Wed, Sep 16, 2026 at 11:11:04AM +0800, Dongjiang Zhu wrote:
>> With simple quotas enabled, running:
>>
>>    btrfs quota rescan /mnt
>>
>> fails with:
>>
>>    ERROR: quota rescan failed: Invalid argument
>>
>> Starting a qgroup rescan is not supported in simple quota mode.
>> Return -EOPNOTSUPP for new rescan requests so userspace can report
>> "Operation not supported" instead.
>>
>> qgroup_rescan_init() is also called during mount to resume a rescan
>> recorded in the qgroup status item. A RESCAN flag in simple quota mode
>> represents an inconsistent persisted state, so return -EUCLEAN for this
>> case and retain the warning for diagnostics.
>>
>=20
> Change looks good, these error values make more sense to me.
>=20
> Reviewed-by: Boris Burkov <boris@bur.io>
>=20
> With that said, I think Fixes: for this is kind of a stretch, as this
> isn't really a bug, it's a reporting improvement. I don't think anyone
> should rush to backport this to their "affected" kernels, for example.
>=20
> Thanks,
> Boris
>=20

Hi Boris,

That makes sense. I'll send a v2.

Thank you very much for the review and guidance!

Thanks,
Dongjiang
