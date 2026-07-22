Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88BE279DAF
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784684326; cv=none; b=jJpGIpPIT/7d3YKU5M7yaaL7zzFfgV1xVAvkSkX6ho6KEvEK46MoalncwMraxR4g8IceCDHsnWOdPEw9rom1/RY9DGxwL4AvoMcHg6RRAoLdGRhhdyrRx5zRp8ggH6x/eoJquJsOEEBnGlnsGTEx7oYp6YQdfRsjajkEq9Puqgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784684326; c=relaxed/simple;
	bh=KNend9IV/cb2Gae0zAJqwYL732j+JW30COqXEe+ePS0=;
	h=Cc:From:Mime-Version:Content-Type:To:Message-Id:Subject:Date:
	 References:In-Reply-To; b=spT5aP0v6N+vGQe/EVimaAVXVmxbIkAum/+JWT9bXZ7uB3Sj6+oJRvpP/d+iwTysxXsQJGWDdRqTr1A1Zd9b2VuOE4xzcfeJOs9MMI4ekiPnO4682hZyccda8rHptwKzXuVto5AFm/wbgQNmh0cUDcwqnmACuQizFUJrvRVXrtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=hs0V1T0k; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="hs0V1T0k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784684311;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NXjRr5FwtpHl12Rv4LXKafdv0seki/igCS++eQV6xd4=;
 b=hs0V1T0k2G0rIcTVUPIEGVUWaoiagE8CaXWj9zp4o0RP6mdE6hIksLJN+uqkRjUl/1pHqG
 hhOVgJ0GSFU58+Vgu8t863sb2xBLRJcV1Mgfm0yiLh1uJ4SPtCM82y4tXe5m58Sqjq7eYB
 yqDDh7X6S6wP1IKMNdlSXMw/FJ94jBuzsf3lmzeYKa9AUeUQq7gF0BZ52JkelgmibCCpOA
 /HYNbaiASuQYH1ZdxZF9+IM/2vlLSr0e6yqVRFglplT15/xN/lItiJyKtEIuf6upga0hUX
 uaIk31v77rBFelsFBPyj4Y5g8xJa430qnq9zaHZM0bYkTbYyQUwJc9yePI3ouQ==
Cc: <linux-btrfs@vger.kernel.org>, "Sun YangKai" <sunyangkai@fnnas.com>
From: "Sun YangKai" <sunyangkai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: Sun YangKai <sunyangkai@fnnas.com>
To: "Filipe Manana" <fdmanana@kernel.org>
Message-Id: <cd88d7de-aab8-4fb6-a94a-1ae4a17a758b@fnnas.com>
Content-Language: en-US
X-Lms-Return-Path: <lba+26a601f15+cd5bcb+vger.kernel.org+sunyangkai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.10.244] ([183.34.163.75]) by smtp.feishu.cn with ESMTPS; Wed, 22 Jul 2026 09:38:28 +0800
Subject: Re: [PATCH v2] btrfs: check if root is readonly when setting posix acl
Date: Wed, 22 Jul 2026 09:38:27 +0800
References: <20260709082500.17907-2-sunk67188@gmail.com> <CAL3q7H5n5-TJMkFmUCnN5-xoVAcqDc7zNFNGR3ywF7Dx+PRetQ@mail.gmail.com>
In-Reply-To: <CAL3q7H5n5-TJMkFmUCnN5-xoVAcqDc7zNFNGR3ywF7Dx+PRetQ@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable

On 2026/7/21 00:03, Filipe Manana wrote:
> On Thu, Jul 9, 2026 at 9:26=E2=80=AFAM Sun YangKai <sunk67188@gmail.com> =
wrote:
>>
>> From: Sun YangKai <sunyangkai@fnnas.com>
>>
>> For a filesystem which has btrfs read-only property set to true, all
>> write operations including acl and xattr should be denied. However,
>> acl can still be set even if btrfs ro property is true.
>>
>> This happens because no function on the set_acl code path checks the roo=
t
>> is readonly or not. It was checked in btrfs_setxattr_trans() but got
>> removed in
>> commit 353c2ea735e4 ("btrfs: remove redundant readonly root check in btr=
fs_setxattr_trans")
>=20
> This can be split across multiple lines, the only place it shouldn't
> be is in the Fixes tag.

Got it.

>>
>> That commit didn't check if all the callers properly check the root's
>> read-only flag. A previous fix is
>> commit b51111271b03("btrfs: check if root is readonly while setting secu=
rity xattr")
>=20
> Please always leave a space between the commit hash and the opening paren=
thesis.

My bad

> I've amended that and pushed to for-next on github, thanks.
>=20
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks a lot for your fix and review.

Sun YangKai

>>
>> Always check if the root is read-only before performing the set acl
>> operation.
>>
>> Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btr=
fs_setxattr_trans")
>> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
>> ---
>> Changes to v1:
>> - add the missing header file
>>
>> ---
>>   fs/btrfs/acl.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
>> index e55b686fe1ab..662cdd1cbdef 100644
>> --- a/fs/btrfs/acl.c
>> +++ b/fs/btrfs/acl.c
>> @@ -15,6 +15,7 @@
>>   #include "xattr.h"
>>   #include "acl.h"
>>   #include "misc.h"
>> +#include "btrfs_inode.h"
>>
>>   struct posix_acl *btrfs_get_acl(struct inode *inode, int type, bool rc=
u)
>>   {
>> @@ -107,6 +108,9 @@ int btrfs_set_acl(struct mnt_idmap *idmap, struct de=
ntry *dentry,
>>          struct inode *inode =3D d_inode(dentry);
>>          umode_t old_mode =3D inode->i_mode;
>>
>> +       if (btrfs_root_readonly(BTRFS_I(inode)->root))
>> +               return -EROFS;
>> +
>>          if (type =3D=3D ACL_TYPE_ACCESS && acl) {
>>                  ret =3D posix_acl_update_mode(idmap, inode,
>>                                              &inode->i_mode, &acl);
>> --
>> 2.54.0
>>
>>
