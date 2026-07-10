Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC673955FF
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2026 09:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783674222; cv=none; b=oBylUcbrn8SQZ2WxNBX7EzM1zdDUehTIc5qVUm782vk/YfiGgOg3ixBJix7/A1LaEgeGwoAurCZ1hPljLegMP+Uj52Dlq46V+vhR1kUecApSGN0NHSi/1z4vqRqoYQ8NO0HBHasbXnVFArD+KtD6QQZunm5d0I00zMv8a4IiCgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783674222; c=relaxed/simple;
	bh=3nJKdaXWSeVWuq+7OoGVS2ffG0alCkQPYkNFUYCvlPA=;
	h=Message-Id:Mime-Version:Subject:Cc:From:To:In-Reply-To:References:
	 Content-Type:Date; b=CVSYHjCz3k36NPfQhM7EihGguobi0cfOpcMgLu/12+AnK86rayD8KtrAvSjZ+Shoj8KjL1OBWu7XGlJ3tpeCDGznu4cFszLFREXbYC+7bYuwGNis9lKcDLcZpVm5uifrKRghbP581egpqu51A46qoRFmlLxYIUA1YMRgU+1Nb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=kKPBIVXe; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="kKPBIVXe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783674208;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Zufe88Yzk1fjouxp855ie1Qg0SbUjOV9l280vfMOtIc=;
 b=kKPBIVXeyr3OYWwk/boECQGK56dQjRKJCK7tgBU+C7YFy9NntddVH0rfqEMWg8umnwhLYb
 FSkArHbihXwlpUTIU6LOGheOYF/h8sBwUzgrnmLzrL3+D8Ao0ySpsAxexk+Dq3Zfa7bOjG
 bETTfcbHNx9MKPf8otnC03829QwuesnYWZvHG5Do1Iq3GfT3YF4jGrcGjeF3PRF9Cm8/97
 Celh9jEO6DIRc3SeE93QVsUMBN5vQz4WzIlHjlSsDJj9poix/PZ9Kyt64IeLt9MKEzJZlw
 nL/pjcwQ7Ab0SLYJVNzn66LJXF1+rvngKPBsOChlJTumnI+xLyhJQ2IirampJQ==
Message-Id: <2edb04cd-4939-41d5-a696-ab40aba6e85f@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Sun YangKai <sunyangkai@fnnas.com>
Subject: Re: [PATCH v2] btrfs: check if root is readonly when setting posix acl
Content-Transfer-Encoding: quoted-printable
Cc: <linux-btrfs@vger.kernel.org>, <sunk67188@gmail.com>
From: "Sun YangKai" <sunyangkai@fnnas.com>
X-Lms-Return-Path: <lba+26a50b55e+2d3208+vger.kernel.org+sunyangkai@fnnas.com>
To: "Filipe Manana" <fdmanana@kernel.org>
Received: from [192.168.10.239] ([183.34.167.72]) by smtp.feishu.cn with ESMTPS; Fri, 10 Jul 2026 17:03:24 +0800
User-Agent: Mozilla Thunderbird
In-Reply-To: <CAL3q7H6wxWNKWcXD7u58O4JJ_0z0_XMpAHc6eQfAiBOPNbKkQw@mail.gmail.com>
References: <20260709082500.17907-2-sunk67188@gmail.com> <CAL3q7H6wxWNKWcXD7u58O4JJ_0z0_XMpAHc6eQfAiBOPNbKkQw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 17:03:22 +0800

On 2026/7/9 18:43, Filipe Manana wrote:
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
>>
>> That commit didn't check if all the callers properly check the root's
>> read-only flag. A previous fix is
>> commit b51111271b03("btrfs: check if root is readonly while setting secu=
rity xattr")
>>
>> Always check if the root is read-only before performing the set acl
>> operation.
>>
>> Fixes: 353c2ea735e4 ("btrfs: remove redundant readonly root check in btr=
fs_setxattr_trans")
>> Signed-off-by: Sun YangKai <sunyangkai@fnnas.com>
>=20
> Test case please (fstests).

Ok, I'll work on that later.

I've noticed the test case btrfs/275 for b51111271b03 and I'll take that=20
as reference.

Thanks,
Sun YangKai

>=20
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
