Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16E847A0A4
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Jun 2026 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780491569; cv=none; b=FuD2WHF1wWWAl9ZiFj313l4AjqaVZbDwsqhQhE6aMbVruSW/9VcJs+YXKbQzXxQ3n5oxuoAbnyhQf9jEVMdkPJCowkcOKqsB9vOASoW0i6XHbp0wWOFbu11loCcorO1rglhbB1VOip8srBYwfesq/4LC7LSKZYqAqjm1t/JmBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780491569; c=relaxed/simple;
	bh=AKYKY6cAYs45BR2tdbwrCClG0xJR+Su1POpzVrlLZFk=;
	h=In-Reply-To:From:Subject:Mime-Version:To:Cc:Message-Id:References:
	 Content-Type:Date; b=Oju9d4+WMNhrt/RdM/FO/uOe2cgsPK9xcPJe7jlQaBlzZw2tHMkp8dOrI80kDhTwDELvj4QdWYbu56M0zB6hCV5Zzpxg9rfRV0uNtCWkxjPG72Tv+PpDQrynhs/S+/trsyBTuxZ71UxGMMep9FnGoYNG2A4HFK147IkhWBxtZ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=m3pVe/7U; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="m3pVe/7U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780491561;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AKYKY6cAYs45BR2tdbwrCClG0xJR+Su1POpzVrlLZFk=;
 b=m3pVe/7U3bw7s0M1zoYaA3Cim5dFv0veEVke/LQvL6iRtKwsdQYmXY49kOfPSDSHNWm2GY
 D4YmSDLw5ikxtTGdi8IyH0a/XeSO0ZVMAemJIVnnwu7AV0aBblvhkPpb4aYlshvBemTqxp
 KN2+rit/QvHj0UfRrLcX4r9+ulhIfyqugcjuOlyvQY7EFr/qykdC14H+J2/Uy3qkTZ1HF3
 AmeDETLLL5ZMoWQGvmSjC0YpMI8iu/XWeoPB6mx9nStAiLR9nsdSW7nRdUsSnwARplKhg1
 AHiJvI9zL4SYvPNoFpcC5yAKoQaJTwD8NMYjaKv00/4NSX2XEdfz9US/mvko4w==
In-Reply-To: <ad4ceb68-99e5-432a-8589-de5e917b47d6@gmx.com>
X-Lms-Return-Path: <lba+26a202527+721143+vger.kernel.org+zhudongjiang@fnnas.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Subject: Re: [RFC PATCH] btrfs: do not enforce qgroup limits when changing qgroup limits
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.79] ([183.34.161.59]) by smtp.feishu.cn with ESMTPS; Wed, 03 Jun 2026 20:59:19 +0800
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Cc: <dsterba@suse.com>, <fdmanana@suse.com>
Message-Id: <7159aec7-f117-4e3e-9b91-bfef6cbf8d6b@fnnas.com>
Content-Transfer-Encoding: quoted-printable
References: <20260603111857.230985-1-zhudongjiang@fnnas.com> <ad4ceb68-99e5-432a-8589-de5e917b47d6@gmx.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 3 Jun 2026 20:59:14 +0800
User-Agent: Mozilla Thunderbird
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>

=E5=9C=A8 2026/6/3 19:33, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/6/3 20:48, Dongjiang Zhu =E5=86=99=E9=81=93:
>> Since qgroup ioctls started reserving transaction space, qgroup limit
>> changes can fail before reaching btrfs_limit_qgroup().
>>
>> For example, if a subvolume qgroup has reached its max referenced limit,
>> issuing BTRFS_IOC_QGROUP_LIMIT on a path inside that subvolume makes
>> btrfs_start_transaction(root, 1) reserve qgroup metadata against that
>> same qgroup. The reservation can fail with -EDQUOT, so the administrator
>> cannot increase or disable the limit that caused the failure.
>>
>> This is also path dependent. The same operation may succeed when the
>> ioctl is issued on another path from the same filesystem whose root
>> qgroup is not limited, while it fails on the target subvolume path.
>>
>> Keep reserving transaction space for the QGROUP_LIMIT item, but do not
>> enforce qgroup limits for that transaction reservation. This preserves
>> the metadata and delayed ref reservation semantics added for qgroup
>> ioctls, while avoiding a qgroup limit self-deadlock for limit changes.
>>
>> Currently this can be worked around by enabling quota_override or by
>> issuing the ioctl on another path from the same filesystem whose root
>> qgroup is not limited. However, changing a qgroup limit should not depen=
d
>> on either of those.
>>
>> This only changes BTRFS_IOC_QGROUP_LIMIT. A follow-up question is whethe=
r
>> the same helper should also be used for other qgroup management ioctls,
>> such as qgroup destroy or relation removal, when they are part of
>> recovering from an over-limit state.
>>
>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
>> ---
>> =C2=A0 fs/btrfs/ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 +++++++=
+--
>> =C2=A0 fs/btrfs/transaction.c |=C2=A0 8 ++++++++
>> =C2=A0 fs/btrfs/transaction.h |=C2=A0 3 +++
>> =C2=A0 3 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 9d47d16394fc..1e410db06c19 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3758,8 +3758,14 @@ static long btrfs_ioctl_qgroup_limit(struct=20
>> file *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 /* 1 BTRFS_QGROUP_LIMIT_KEY item. */
>> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 1);
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * 1 BTRFS_QGROUP_LIMIT_KEY item.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 *
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Do not enforce the current qgroup limit whil=
e changing that=20
>> limit,
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * otherwise a qgroup that already reached its =
limit cannot have the
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * limit increased or disabled.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction_no_qgroup_enforce(=
root, 1);
>=20
> Nope, you should not work on the subvolume root.
>=20
> The transaction is working on qgroup tree, so it's just simply passing=20
> the wrong root.

Yes, that makes sense. The qgroup ioctls update the quota tree, so using
the inode root makes the transaction reservation depend on the path used
for the ioctl.

I'll rework this to start the transaction on fs_info->quota_root instead
of adding a no-qgroup-enforce helper.

I think the same should apply to the other qgroup management ioctls,
such as create/destroy and assign/remove, since they also update the
quota tree. Do you think v2 should switch them to fs_info->quota_root as
well?

Thanks,
Dongjiang
