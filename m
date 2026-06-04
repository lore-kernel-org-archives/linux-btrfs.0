Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1818643CEDB
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 12:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575275; cv=none; b=VposTKAAxDbAMktznQPGaOGd+0RYtEdzw9CDloa/VGp+2lqS7Z272MaMlChI3R0m4f/E6I0BBpqFD8XKZikNMhZ1SPS8C7OoHrHcla82GO96g4iGd7OJdgoHKaZAFaGRHu1IO+udtFqFw/mNoXpLFPfiMDRXvKtsCNJfl9SmHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575275; c=relaxed/simple;
	bh=JojnOV87DQpyDe1lUwiEuf5uFTfxa8ik6B4WNoRu4G4=;
	h=References:To:Message-Id:In-Reply-To:Date:Mime-Version:
	 Content-Type:Cc:From:Subject; b=XRjsOri069QPUCNAYkYd2aO80jG+y5nEvfWBzm1bWvW1vsyiq0NZy1aqzR1wusY/R+LELVRSXazjfQNYG3qFX72TCy6dGKlFk3xSZo5CaCNuJT3GKVr5Ef8poSjs+MYvFDhyYZt1/3Vhm4vAcLGVx0viY2JsvyL/nRM8G5lTcg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mLqcf4jE; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mLqcf4jE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780575260;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JojnOV87DQpyDe1lUwiEuf5uFTfxa8ik6B4WNoRu4G4=;
 b=mLqcf4jEcax1W6M8SobrgECfSrpwbJ18939EBBXDZaEgv3Jk4R6FJkTlh1Hy7k/1K6eI4Y
 jz8k5q8egHhrlAK9SjON9CpYekqXoCTjywUmieEA7F1WtslDGFp5kgZBuiklluceuqHYTN
 Upiv+hET9ei7OlS1RbxxV6GS38vrTINfIqIw5n0WL43ehck+Rp9sYOqFtv+3rG0XChO3xl
 XHVkCLRgVkdW3VpchhjlRxIx03ez/W7UKnaOGXq/cnRMotRRyjEimPbJWvJW73+5yEspFw
 ped8pf9ACvA8cxbQTkTo/tGL5I44wbFBfGNpyNdJyS6gkFVBWmEAB2zM6oZ4MA==
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com> <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com>
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Message-Id: <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com>
In-Reply-To: <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Date: Thu, 4 Jun 2026 20:14:14 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.79] ([183.34.166.141]) by smtp.feishu.cn with ESMTPS; Thu, 04 Jun 2026 20:14:17 +0800
X-Lms-Return-Path: <lba+26a216c1a+60db2c+vger.kernel.org+zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <dsterba@suse.com>, <fdmanana@suse.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota root

=E5=9C=A8 2026/6/4 17:15, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/6/4 18:25, Dongjiang Zhu =E5=86=99=E9=81=93:
>> The qgroup ioctls update the quota tree, but they currently start their
>> transactions using the root of the inode passed to the ioctl. This makes
>> the transaction reservation depend on the path used for the ioctl instea=
d
>> of the tree being modified.
>>
>> Start qgroup ioctl transactions on the quota root instead. Grab a
>> reference to the quota root before starting the transaction, as quota
>> disable can clear fs_info->quota_root concurrently after the early quota
>> enabled check.
>>
>> Suggested-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
>> ---
>> Changes since RFC:
>> - Rework the fix to start qgroup ioctl transactions on fs_info-=20
>> >quota_root
>> =C2=A0=C2=A0 instead of adding a no-qgroup-enforce transaction helper.
>> - Grab the quota root before starting the transaction to handle=20
>> concurrent
>> =C2=A0=C2=A0 quota disable.
>>
>> =C2=A0 fs/btrfs/ioctl.c | 38 +++++++++++++++++++++++++++++++-------
>> =C2=A0 1 file changed, 31 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 9d47d16394fc..bec4f921aefd 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -3606,7 +3606,7 @@ static long btrfs_ioctl_qgroup_assign(struct=20
>> file *file, void __user *arg)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D file_inode(file);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D inode_t=
o_fs_info(inode);
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D BTRFS_I(inode)->root;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *quota_root;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_qgroup_assign_args AUT=
O_KFREE(sa);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_qgroup_list AUTO_KFREE(preal=
loc);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>> @@ -3637,8 +3637,15 @@ static long btrfs_ioctl_qgroup_assign(struct=20
>> file *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 quota_root =3D btrfs_grab_root(fs_info->quota_root);
>=20
> No need to increase the root refs.
>=20
> Qgroup root is a global one, no need to grabbing it using ref count.
>=20
> Furthermore, all those qgroup related operations (including enabling/=20
> disabling) are all holding qgroup_ioctl_lock, thus there is no way the=20
> quota root is gone halfway.
>=20

I may have misunderstood this part.

The ioctl handler checks btrfs_qgroup_enabled() before starting the
transaction, but it does not hold qgroup_ioctl_lock between that check
and btrfs_start_transaction(). btrfs_quota_disable() can clear
fs_info->quota_root and put the quota root under qgroup_ioctl_lock.

I enlarged that window locally. If the ioctl reads fs_info->quota_root
after the delay and passes it directly to btrfs_start_transaction(), it
can hit a NULL root after quota disable. If the ioctl saves
fs_info->quota_root into a local variable before the delay and then
starts the transaction on that saved pointer, KASAN reports a
slab-use-after-free in start_transaction(), with the root allocated by
btrfs_quota_enable() and freed by btrfs_quota_disable().

So I think I may be missing the intended serialization here. Since
qgroup_ioctl_lock cannot be held across btrfs_start_transaction(), as
noted in btrfs_quota_enable(), what would be the right way to protect
the quota root for this transaction start?

>> +=C2=A0=C2=A0=C2=A0 if (!quota_root) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOTCONN;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 2 BTRFS_QGROUP_RELATION_KEY items. */
>> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 2);
>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(quota_root, 2);
>> +=C2=A0=C2=A0=C2=A0 btrfs_put_root(quota_root);
>=20
> Again unnecessary.
>=20
> Furthermore, the pattern of grab root -> start trans -> put root is=20
> completely incorrect and dangerous.
>=20
> If we're the last one holding a root pointer, after holding a trans=20
> handler, calling btrfs_put_root() can cause the root pointer to be gone,=
=20
> resulting all kinds of use-after-free bugs.
>=20
> I do not understand where you come up this cursed usage, it's completely=
=20
> incorrect.
>=20

Understood, I will drop that pattern. I added it only because of the
race above, but I misunderstood the root lifetime rules around
transaction start.

For my understanding, is the problem that btrfs_start_transaction() does
not take ownership of the root pointer, so the caller must not drop the
last root reference while the transaction handle is still alive?

I really appreciate your review and the detailed explanation.

Thanks,
Dongjiang

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(t=
rans);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> @@ -3675,7 +3682,8 @@ static long btrfs_ioctl_qgroup_assign(struct=20
>> file *file, void __user *arg)
>> =C2=A0 static long btrfs_ioctl_qgroup_create(struct file *file, void __u=
ser=20
>> *arg)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D file_inode(file);
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D BTRFS_I(inode)->root;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D inode_to_fs_info(i=
node);
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *quota_root;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_qgroup_create_args AUT=
O_KFREE(sa);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> @@ -3684,7 +3692,7 @@ static long btrfs_ioctl_qgroup_create(struct=20
>> file *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!capable(CAP_SYS_ADMIN))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EPERM;
>> -=C2=A0=C2=A0=C2=A0 if (!btrfs_qgroup_enabled(root->fs_info))
>> +=C2=A0=C2=A0=C2=A0 if (!btrfs_qgroup_enabled(fs_info))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOTCONN;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D mnt_want_write_file(file);
>> @@ -3707,11 +3715,18 @@ static long btrfs_ioctl_qgroup_create(struct=20
>> file *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 quota_root =3D btrfs_grab_root(fs_info->quota_root);
>=20
> The same.
>=20
>> +=C2=A0=C2=A0=C2=A0 if (!quota_root) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOTCONN;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 1 BTRFS_QGROUP_INFO_KEY item.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * 1 BTRFS_QGROUP_LIMIT_KEY item.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 2);
>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(quota_root, 2);
>> +=C2=A0=C2=A0=C2=A0 btrfs_put_root(quota_root);
>=20
> The same.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(t=
rans);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> @@ -3736,6 +3751,8 @@ static long btrfs_ioctl_qgroup_limit(struct file=
=20
>> *file, void __user *arg)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D file_inode(file);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D BTRFS_I(inode=
)->root;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *quota_root;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D root->fs_info;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_qgroup_limit_args AUTO=
_KFREE(sa);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>> @@ -3745,7 +3762,7 @@ static long btrfs_ioctl_qgroup_limit(struct file=
=20
>> *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!capable(CAP_SYS_ADMIN))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EPERM;
>> -=C2=A0=C2=A0=C2=A0 if (!btrfs_qgroup_enabled(root->fs_info))
>> +=C2=A0=C2=A0=C2=A0 if (!btrfs_qgroup_enabled(fs_info))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -ENOTCONN;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D mnt_want_write_file(file);
>> @@ -3758,8 +3775,15 @@ static long btrfs_ioctl_qgroup_limit(struct=20
>> file *file, void __user *arg)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 quota_root =3D btrfs_grab_root(fs_info->quota_root);
>=20
> The same.
>=20
>> +=C2=A0=C2=A0=C2=A0 if (!quota_root) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOTCONN;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* 1 BTRFS_QGROUP_LIMIT_KEY item. */
>> -=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(root, 1);
>> +=C2=A0=C2=A0=C2=A0 trans =3D btrfs_start_transaction(quota_root, 1);
>> +=C2=A0=C2=A0=C2=A0 btrfs_put_root(quota_root);
>=20
> The same.
>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(trans)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D PTR_ERR(t=
rans);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto drop_write;
>
