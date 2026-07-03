Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CAD381EBB
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783070487; cv=none; b=Ko4IaqzeNrAitiR/1Dd/oPYYhFaBnB1MAOmAPTjctlrlEHTb1DnsPmFzKrRaYjdbzDM0V5TP8dbPYh4Hp8xSBNhrnMQ1vslI2zOrVWe8dwWjNy+ZPFhbPjriOfCQbimbdIhQYKtFmzSKj1/Y5ogRuR+DkVX6EU4eOT6uz1z20sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783070487; c=relaxed/simple;
	bh=2yqlUoGxhFTZG8X+sSDUHje22NeRHdjX5WjyEf+0Cp0=;
	h=From:Mime-Version:Content-Type:To:Subject:References:In-Reply-To:
	 Message-Id:Date; b=hf3Ettu5W48HlSQQk4l2lXyezOWJpX2ea7/xCZZdRjXdBEkdNoKqb5xnqHVMc+6YBX5Jw1qFnAL+7jvfAOoaCbyOednAkY0Te8g6KSUNBb6OTg3B8ONYfp70nnk8AkYT0MvzENqbMgqYiGaqDE3UMk7gHKAyWkQGSZ9Pg3Scx/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uiupD2n5; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uiupD2n5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783070479;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=oVyLd/LDaUQ5sj9bVainblVmON4Xysk/wdanlg2iu6c=;
 b=uiupD2n5vTLHbMlxhckwG+258MFzm3oZ+1096uYyI2CHec8B6bcQ+ZRaLTvIrrfxOTBgUf
 HzF4nClt5oxYTyHnvBWNXhQXGhuXPhRcrB8sS2fIzErsNPnIaWpDi6B3un8ywXJmlzkVLa
 +lX+QXBgECfsacstfGaIBQueRPKA0mxX6fltPUUJPnqRYiQCc0GxjiiQR8Tp0pni4iHC4r
 iydPUGhvqm9MoHntpBUZrzsv7fhVdRS6wMZkiBDyXTRbxI14c2vuMBtV0xKM4Ath3PP/oS
 gT7dLOsPS27xYZGm6mCkT9b871DX1Q+ErVj0WCjUmSsNjwgpvVhmjyqZURrNBQ==
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.8.64] ([183.34.165.6]) by smtp.feishu.cn with ESMTPS; Fri, 03 Jul 2026 17:21:16 +0800
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/3] btrfs: add "rescue=usebackuproot" into forced read-only options
User-Agent: Mozilla Thunderbird
References: <cover.1783068013.git.wqu@suse.com> <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783068013.git.wqu@suse.com>
In-Reply-To: <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783068013.git.wqu@suse.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
X-Lms-Return-Path: <lba+26a477f0d+ad3b28+vger.kernel.org+zhudongjiang@fnnas.com>
Message-Id: <c20f62ae-eef2-4eb5-9290-a7bebe6a259d@fnnas.com>
Date: Fri, 3 Jul 2026 17:21:15 +0800

=E5=9C=A8 2026/7/3 16:41, Qu Wenruo =E5=86=99=E9=81=93:
> According to btrfs(5) man page, all rescue options should require an
> read-only mount.
>
> But that read-only check is only introduced for newer rescue options,
> not for the pre-existing "usebackuproot" one.
>
> Unify the behavior to match the document.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   fs/btrfs/super.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 0a6ce6c19d8c..fef9025a2f76 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -692,7 +692,8 @@ bool btrfs_check_options(const struct btrfs_fs_info *=
info,
>   	bool ret =3D true;
>  =20
>   	if (!(flags & SB_RDONLY) &&
> -	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nologr=
eplay") ||
> +	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_USEBACKUPROOT, "useb=
ackuproot") ||
> +	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nologr=
eplay") ||
>   	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREBADROOTS, "ig=
norebadroots") ||
>   	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREDATACSUMS, "i=
gnoredatacsums") ||
>   	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREMETACSUMS, "i=
gnoremetacsums") ||

Hi Qu,

One more thing I noticed: should BTRFS_MOUNT_USEBACKUPROOT also be added
to BTRFS_MOUNT_FULL_RO_MASK?

Thanks,
Dongjiang
