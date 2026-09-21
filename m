Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C1345DF49
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998816; cv=none; b=LE7CYQc/q4RmOSh0lprc+hTqiuyh9bSxZw1mFVelT9quW+DC4pl1ARm4fgb6WMXHxZSq9RNDRvDVso03YLbqcszMus1k7cbOjHAkB6wd/nvwfeE5a9cBMmyuYmdg5AOvwmAxNY/Jgi8YAqQZRdXfbylNp8600an/wxWZAsxfjvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998816; c=relaxed/simple;
	bh=/zkzaLu6cP/5sOWEe20Wpkw38MGX75DpwvglDSE4x7c=;
	h=Cc:Message-Id:Mime-Version:References:Subject:From:Date:
	 In-Reply-To:Content-Type:To; b=u8NN7WRJSJPBbzQuoA6vcdwuxvtunp8/rr07trIXDvVn4OINcSR2q/Gz0wMe1jlj3SUWxqZd6kbcpfkbV4LU7qgiH2EIyUPEqxeLnF0+b4TpZiFkVadTjblSDGmrGvB7+vStzvgdODze8O4ujf9sc6/TesxSL6N0p1i6LH0Ju1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=EMZ8yaRs; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="EMZ8yaRs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789998809;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JA/0xC4P5PXrjrY62tbyO9w0q1E67f9bo0tPZR518P0=;
 b=EMZ8yaRsS/1oYvGG3PFeYUjfkPF8umV3AYeXOPOTge2SDBNSzqxO7u3p9rosW5YciFVlZg
 fst/UdciyCdMIf6qJQM2xOKB7q2p16CnOggksqoSp+S8CYaKmENz16nyz77aAAc/XOY6vn
 frf3DU7cfQQvPEbrCJeKKUGrE1k5r4WCBBwQIce2mARsp/Zp+y6EEGftR2JkbnM5vT4BvR
 7ajqdTiARG+nlysC9vGBgFfpTTXPN3q13kHvsLkX9YYetfr4fqgcjFCg/AkuOh6l21N9SK
 +dpiSNY47Eri+2G+KxePspcSffsjnQvw3LFVIEKlPBbxWAuN/oEasT4Yx917qg==
X-Lms-Return-Path: <lba+26ab136d9+7f8396+vger.kernel.org+zhudongjiang@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Received: from [192.168.8.64] ([183.34.169.232]) by smtp.larksuite.com with ESMTPS; Mon, 21 Sep 2026 13:53:28 +0000
Cc: <linux-btrfs@vger.kernel.org>, <boris@bur.io>
Message-Id: <82b37efe-7b21-46ad-b685-9ddfae3ad235@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260919040249.912597-1-zhudongjiang@fygo.io> <20260921132706.GG54722@twin.jikos.cz>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: qgroup: use specific errors for simple quota rescan
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Mon, 21 Sep 2026 21:53:22 +0800
In-Reply-To: <20260921132706.GG54722@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
To: <dsterba@suse.cz>

=E5=9C=A8 2026/9/21 21:27, David Sterba =E5=86=99=E9=81=93:
> On Sat, Sep 19, 2026 at 12:02:49PM +0800, Dongjiang Zhu wrote:
>> With simple quotas enabled, running:
>>
>>   btrfs quota rescan /mnt
>>
>> fails with:
>>
>>   ERROR: quota rescan failed: Invalid argument
>>
>> Starting a qgroup rescan is not supported in simple quota mode.
>> Return -EOPNOTSUPP for new rescan requests so userspace can report
>> "Operation not supported" instead.
>>
>> qgroup_rescan_init() is also called during mount to resume a rescan
>> recorded in the qgroup status item. A RESCAN flag in simple quota mode
>> represents an inconsistent persisted state, so return -EUCLEAN for this
>> case and retain the warning for diagnostics.
>=20
> I'm not sure EUCLEAN is a good choice here. It means the filesystem is
> corrupted, which in a sense it is, but it's not from user inputs or
> on-disk state. The 'init-flags' is from calls and this matches more the
> assertion pattern.

Hi David,

Currently, the only caller passing init_flags =3D=3D 0 is
btrfs_read_qgroup_config() during mount. It calls qgroup_rescan_init()
only when RESCAN is set in the flags read from the on-disk qgroup
status item.

If simple quota mode is also set, I would consider that an inconsistent
on-disk state, which is why I chose -EUCLEAN.

I observed this with the following sequence:

1. Enable full qgroups and wait for the initial rescan to finish.
2. Start another rescan.
3. Disable quotas while the rescan worker is running.
4. Enable simple quotas.
5. Unmount and mount again.

The worker can leave RESCAN set after quota disable. Enabling simple
quotas then persists ON|SIMPLE_MODE|RESCAN in the new status item,
which triggers this check on the next mount.

Thanks,
Dongjiang
