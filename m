Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D682377EA1
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2026 02:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796398; cv=none; b=K2AD8K7zpj1mnmDWY8Kr6FAkC9Y/3dYMtathURZ/Zt1d0CqfrJbuFLXWTooZu7tFkfxpFtEhgXZsBwLaqoTbMzwv7GjaIFr9Xvvm8f5lvI3J3G+AdMVEuyHUyJT062ZkG842UfAr0fE0V38Y8GxwpqrMctxdTvb+r3PDhr64bsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796398; c=relaxed/simple;
	bh=8a8HjnacJnrhRKOFfd3y0Sh/JcF+6fv7xCzY14SZPVc=;
	h=Subject:Mime-Version:Cc:In-Reply-To:References:Content-Type:To:
	 From:Date:Message-Id; b=kBcCX3xNSzJTX8pKeopi/mB9P26YgyX4eyw1idJPnKpM7RuwGu/AvaPOFX4piav767SZN4vjd/Os4BcNpFqxHsKQnMXFbi9V29y8QKgs/fa3cmoSA39e6dWMyCHJGNwxVxR2EFTbvuFQOSQmltpsBipJqWj7wpuZvMrgQVZAF+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=gVwWc7M0; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="gVwWc7M0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1787796388;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8a8HjnacJnrhRKOFfd3y0Sh/JcF+6fv7xCzY14SZPVc=;
 b=gVwWc7M03L5EtbL3BHFOnIYGgxL2JUoTIxIQY88I8cVks5njdQMbCaCjWb1NJZyzBreJGr
 5Nzg3aRyaZ4Dx+WOfK9cRXIqwB2C34imA4J//KEdXdncigS7DACLhJJ9xr81Vofy1zhOBB
 7G9+AUwdceiZvh1uu/BDTGfGZg4XdFMx7wkMP5qB8ZZGiR1BJsTRD8agHxgGRTpzCSq31P
 N8PTqHFRXavujrCH/ljJrDhCzFtMg3V6DA6ogGZOjSqCdy93ZQvbvsiqLgNpj50VdLFZzZ
 /UeDb2cFMSqI9hWo5Fhjl4FeR6UIm9WgCyBv4G8RzkfCwPSRfbgCeMywxJhfsg==
Subject: Re: [PATCH v2 1/4] btrfs: zoned: track only sequential zones as active
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: <naohiro.aota@wdc.com>
Received: from [192.168.8.64] ([14.21.226.247]) by smtp.larksuite.com with ESMTPS; Thu, 27 Aug 2026 02:06:27 +0000
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e852d4c2-6765-4d8e-aaa4-f7dd1dc21163@wdc.com>
References: <cover.1787717573.git.zhudongjiang@fygo.io> <c51aaf7f4621dedc36c275bfa9ba1ec884de09c4.1787717573.git.zhudongjiang@fygo.io> <e852d4c2-6765-4d8e-aaa4-f7dd1dc21163@wdc.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>, 
	<linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Thu, 27 Aug 2026 10:06:23 +0800
Message-Id: <c0207d19-0c87-4d36-bf63-8d8174d19271@fygo.io>
X-Lms-Return-Path: <lba+26a8f9ba3+5e42a4+vger.kernel.org+zhudongjiang@fygo.io>

=E5=9C=A8 2026/8/26 17:00, Johannes Thumshirn =E5=86=99=E9=81=93:
> On 8/26/26 6:27 AM, Dongjiang Zhu wrote:
>> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
>> index 69d56864d4ba..37ab8b7eee9c 100644
>> --- a/fs/btrfs/block-group.h
>> +++ b/fs/btrfs/block-group.h
>> @@ -80,13 +80,17 @@ enum btrfs_block_group_flags {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_TO_COPY,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_RELOCATING_REPAIR,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK_GROUP_FLAG_CHUNK_ITEM_INSERTED,
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Only block groups containing sequential zone=
s can have this=20
>> bit set;
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * conventional-only block groups never do.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>=20
> Again this comment does not really serve any purpose.

OK, I will remove it in v3.

Thanks,
Dongjiang
