Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55795 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750961AbeEYC73 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 22:59:29 -0400
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
 <72a2ebde-6aa3-297a-dcf8-a78a7760f8d1@oracle.com>
 <53341d88-597b-7617-ef2d-61effeba1802@gmx.com>
Message-ID: <4e1024d1-9eed-31e4-f684-1a2cfa661c90@gmx.com>
Date: Fri, 25 May 2018 10:59:04 +0800
MIME-Version: 1.0
In-Reply-To: <53341d88-597b-7617-ef2d-61effeba1802@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MZoXWsX1k404q95SkFD9Ju1gT3KQi9v2x"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MZoXWsX1k404q95SkFD9Ju1gT3KQi9v2x
Content-Type: multipart/mixed; boundary="Un8Nsh1z31PDjGgQ76wsuUSv0S77SpZxf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Message-ID: <4e1024d1-9eed-31e4-f684-1a2cfa661c90@gmx.com>
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
 <72a2ebde-6aa3-297a-dcf8-a78a7760f8d1@oracle.com>
 <53341d88-597b-7617-ef2d-61effeba1802@gmx.com>
In-Reply-To: <53341d88-597b-7617-ef2d-61effeba1802@gmx.com>

--Un8Nsh1z31PDjGgQ76wsuUSv0S77SpZxf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8825=E6=97=A5 08:54, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B405=E6=9C=8825=E6=97=A5 00:24, Anand Jain wrote:
>>
>>
>> On misc-next this patch is causing regression, the seed sprout
>> functionality test [1] (in the mailing list) fails.
>>
>> =C2=A0[1]
>> =C2=A0[PATCH] fstests: btrfs: add seed sprout functionality test
>>
>> more below..
>>
>> On 05/11/2018 01:35 PM, Qu Wenruo wrote:
>>> Just move btrfs_check_super_valid() before its single caller to avoid=

>>> forward declaration.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> =C2=A0 fs/btrfs/disk-io.c | 299 ++++++++++++++++++++++---------------=
--------
>>> =C2=A0 1 file changed, 149 insertions(+), 150 deletions(-)
>>>
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 932ed61d9554..13c5f90995aa 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -55,7 +55,6 @@
>>> =C2=A0 static const struct extent_io_ops btree_extent_io_ops;
>>> =C2=A0 static void end_workqueue_fn(struct btrfs_work *work);
>>> =C2=A0 static void free_fs_root(struct btrfs_root *root);
>>> -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info);
>>> =C2=A0 static void btrfs_destroy_ordered_extents(struct btrfs_root *r=
oot);
>>> =C2=A0 static int btrfs_destroy_delayed_refs(struct btrfs_transaction=
 *trans,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str=
uct btrfs_fs_info *fs_info);
>>> @@ -2441,6 +2440,155 @@ static int btrfs_read_roots(struct
>>> btrfs_fs_info *fs_info)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> =C2=A0 }
>>> =C2=A0 +static int btrfs_check_super_valid(struct btrfs_fs_info *fs_i=
nfo)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *sb =3D fs_info->super_c=
opy;
>>> +=C2=A0=C2=A0=C2=A0 u64 nodesize =3D btrfs_super_nodesize(sb);
>>> +=C2=A0=C2=A0=C2=A0 u64 sectorsize =3D btrfs_super_sectorsize(sb);
>>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_magic(sb) !=3D BTRFS_MAGIC) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "no va=
lid FS found");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUP=
P) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "unrec=
ognized or unsupported super flag:
>>> %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_root_level(sb) >=3D BTRFS_MAX_LEV=
EL) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "tree_=
root level too big: %d >=3D %d",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_chunk_root_level(sb) >=3D BTRFS_M=
AX_LEVEL) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "chunk=
_root level too big: %d >=3D %d",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);=

>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_log_root_level(sb) >=3D BTRFS_MAX=
_LEVEL) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "log_r=
oot level too big: %d >=3D %d",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Check sectorsize and nodesize first, othe=
r check will need it.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Check all possible sectorsize(4K, 8K, 16K=
, 32K, 64K) here.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(sectorsize) || sectorsize < 40=
96 ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectorsize > BTRFS_MAX_ME=
TADATA_BLOCKSIZE) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id sectorsize %llu", sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 /* Only PAGE SIZE is supported yet */
>>> +=C2=A0=C2=A0=C2=A0 if (sectorsize !=3D PAGE_SIZE) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
sectorsize %llu not supported yet, only support %lu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
ectorsize, PAGE_SIZE);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(nodesize) || nodesize < sector=
size ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodesize > BTRFS_MAX_META=
DATA_BLOCKSIZE) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id nodesize %llu", nodesize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (nodesize !=3D le32_to_cpu(sb->__unused_leafsi=
ze)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id leafsize %u, should be %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 le32_to_cpu(sb->__unused_leafsize), nodesize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* Root alignment check */
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)=
) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "tree=
_root block unaligned: %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_root(sb));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_chunk_root(sb), secto=
rsize)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "chun=
k_root block unaligned: %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_chunk_root(sb));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_log_root(sb), sectors=
ize)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "log_=
root block unaligned: %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_log_root(sb));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRF=
S_FSID_SIZE) !=3D
>>> 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "dev_item UUID does not match fsid: %pU !=3D %pU",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->fsid, sb->dev_item.fsid);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>
>>
>> No. Not all devices will have the same fsid in case of seed-sprout
>> mounted devices.
>=20
> Yes, for seed device it's possible that seed device has different fsid.=

>=20
> But the problem here is, for seed device, it shouldn't get modified.
> Thus its super block shouldn't get updated and written.
>=20
> Or did I miss something?

OK, the problem is that we're using the old super block copy from seed
device.

The timming of checking superblock should be called after we have set
dev_item/fsid correct.

I'll update the patchset to handle it.

Thanks,
Qu

>=20
> Thanks,
> Qu
>=20
>>
>> [55090.664841] BTRFS error (device sdc): dev_item UUID does not match
>> fsid: 994fd365-9baf-4cbc-bcb2-ac65cba6a183 !=3D
>> 2f459b44-def5-45d6-aa39-60d7d2350a6e
>> [55090.698052] BTRFS error (device sdc): super block corruption detect=
ed
>> before writing it to disk
>> [55090.700661] BTRFS warning (device sdc): Skipping commit of aborted
>> transaction.
>> [55090.701914] ------------[ cut here ]------------
>> [55090.702751] BTRFS: Transaction aborted (error -22)
>> [55090.703644] WARNING: CPU: 1 PID: 14960 at fs/btrfs/transaction.c:18=
36
>> cleanup_transaction+0x8a/0x270 [btrfs]
>> [55090.704597] Modules linked in: btrfs xor zstd_decompress
>> zstd_compress xxhash raid6_pq [last unloaded: xor]
>> [55090.704597] CPU: 1 PID: 14960 Comm: btrfs Tainted: G=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 W
>> 4.17.0-rc6+ #52
>> [55090.704597] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS=

>> VirtualBox 12/01/2006
>> [55090.704597] RIP: 0010:cleanup_transaction+0x8a/0x270 [btrfs]
>> [55090.704597] RSP: 0000:ffffa94a0155bb88 EFLAGS: 00010286
>> [55090.704597] RAX: 0000000000000000 RBX: ffff9ec4d7ad4000 RCX:
>> 0000000000000000
>> [55090.704597] RDX: ffff9ec4dfd1d1f0 RSI: ffff9ec4dfd154b8 RDI:
>> ffff9ec4dfd154b8
>> [55090.704597] RBP: ffff9ec4da2dfe00 R08: 00000000000008af R09:
>> 0000000000000000
>> [55090.704597] R10: ffffa94a0155bc10 R11: ffffffff92d977ad R12:
>> ffff9ec4d2c58410
>> [55090.704597] R13: 00000000ffffffea R14: 00000000ffffffea R15:
>> ffff9ec4d7ad4778
>> [55090.704597] FS:=C2=A0 00007f7ead00d8c0(0000) GS:ffff9ec4dfd00000(00=
00)
>> knlGS:0000000000000000
>> [55090.704597] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [55090.704597] CR2: 00005565919f7ab0 CR3: 0000000117b12004 CR4:
>> 00000000000606e0
>> [55090.704597] Call Trace:
>> [55090.704597]=C2=A0 ? wait_woken+0x80/0x80
>> [55090.704597]=C2=A0 btrfs_commit_transaction+0x71a/0x8b0 [btrfs]
>> [55090.704597]=C2=A0 ? kobject_rename+0x112/0x150
>> [55090.704597]=C2=A0 btrfs_init_new_device+0xa64/0xf60 [btrfs]
>> [55090.704597]=C2=A0 ? unlazy_walk+0x32/0xa0
>> [55090.704597]=C2=A0 ? btrfs_ioctl+0xde2/0x25d0 [btrfs]
>> [55090.704597]=C2=A0 btrfs_ioctl+0xde2/0x25d0 [btrfs]
>> [55090.704597]=C2=A0 ? selinux_inode_getattr+0x71/0x90
>> [55090.704597]=C2=A0 ? _copy_to_user+0x22/0x30
>> [55090.704597]=C2=A0 ? cp_new_stat+0x12c/0x160
>> [55090.704597]=C2=A0 ? do_vfs_ioctl+0xa1/0x600
>> [55090.704597]=C2=A0 ? proc_kprobes_optimization_handler+0x17a/0x1a0
>> [55090.704597]=C2=A0 do_vfs_ioctl+0xa1/0x600
>> [55090.704597]=C2=A0 ksys_ioctl+0x70/0x80
>> [55090.704597]=C2=A0 __x64_sys_ioctl+0x16/0x20
>> [55090.704597]=C2=A0 do_syscall_64+0x42/0xf0
>> [55090.704597]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [55090.704597] RIP: 0033:0x7f7eac0ae277
>> [55090.704597] RSP: 002b:00007ffd85a76958 EFLAGS: 00000206 ORIG_RAX:
>> 0000000000000010
>> [55090.704597] RAX: ffffffffffffffda RBX: 00007ffd85a77b38 RCX:
>> 00007f7eac0ae277
>> [55090.704597] RDX: 00007ffd85a769a0 RSI: 000000005000940a RDI:
>> 0000000000000003
>> [55090.704597] RBP: 0000000000000001 R08: 0000000000000000 R09:
>> 0000000000001011
>> [55090.704597] R10: 000000000000018f R11: 0000000000000206 R12:
>> 0000000000000000
>> [55090.704597] R13: 0000000000000002 R14: 000000000209e290 R15:
>> 00007ffd85a77b40
>> [55090.704597] Code: 38 83 f8 01 0f 87 f5 01 00 00 f0 48 0f ba ab 88 0=
c
>> 00 00 02 72 17 41 83 fd fb 74 11 44 89 ee 48 c7 c7 18 7b 1e c0 e8 e6 e=
6
>> 10 d1 <0f> 0b 44 89 e9 4c 8d ab 70 07 00 00 ba 2c 07 00 00 48 c7 c6 f0=

>> [55090.704597] ---[ end trace 09b3c3dd4f060772 ]---
>> [55090.753144] BTRFS: error (device sdc) in cleanup_transaction:1836:
>> errno=3D-22 unknown
>> [55090.761076] BTRFS info (device sdc): forced readonly
>> [55090.767639] BTRFS info (device sdc): delayed_refs has NO entry
>> [55090.854114] umount btrfs dev=3Dsdb s_active=3D2 dir=3Drunner
>> [55090.875108] umount btrfs dev=3Dsdc s_active=3D2 dir=3Dscratch
>> [55090.892160] BTRFS error (device sdc): cleaner transaction attach
>> returned -30
>>
>>
>> Thanks, Anand
>>
>>
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Hint to catch really bogus numbers, bitfl=
ips or so, more exact
>>> checks are
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * done later
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_=
nodesize(sb)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "bytes=
_used is too small %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_bytes_used(sb));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(btrfs_super_stripesize(sb))) {=

>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id stripesize %u",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_stripesize(sb));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_num_devices(sb) > (1UL << 31))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "susp=
icious number of devices: %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_num_devices(sb));
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_num_devices(sb) =3D=3D 0) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "numbe=
r of devices is 0");
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D BTRFS_SUPER_INFO_=
OFFSET) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "super=
 offset mismatch %llu !=3D %u",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_array corruptions, it m=
ust hold at least one
>>> key
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * and one chunk
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_sys_array_size(sb) >
>>> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "syste=
m chunk array too big %u > %u",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_sys_array_size(sb),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_sys_array_size(sb) < sizeof(struc=
t btrfs_disk_key)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +=
 sizeof(struct btrfs_chunk)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "syste=
m chunk array too small %u < %zu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_sys_array_size(sb),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sizeof(struct btrfs_disk_key)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 + sizeof(struct btrfs_chunk));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * The generation is a global counter, we'll=
 trust it more than
>>> the others
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 * but it's still possible that it's the one=
 that's wrong.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_generation(sb) <
>>> btrfs_super_chunk_root_generation(sb))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
suspicious: generation < chunk_root_generation: %llu <
>>> %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_generation(sb),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_chunk_root_generation(sb));
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_super_generation(sb) < btrfs_super_cach=
e_generation(sb)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && btrfs_super_cache_gene=
ration(sb) !=3D (u64)-1)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
suspicious: generation < cache_generation: %llu < %llu",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_generation(sb),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_cache_generation(sb));
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return ret;
>>> +}
>>> +
>>> =C2=A0 int open_ctree(struct super_block *sb,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 struct btrfs_fs_devices *fs_devices,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 char *options)
>>> @@ -3972,155 +4120,6 @@ int btrfs_read_buffer(struct extent_buffer
>>> *buf, u64 parent_transid, int level,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 level, first_key);
>>> =C2=A0 }
>>> =C2=A0 -static int btrfs_check_super_valid(struct btrfs_fs_info *fs_i=
nfo)
>>> -{
>>> -=C2=A0=C2=A0=C2=A0 struct btrfs_super_block *sb =3D fs_info->super_c=
opy;
>>> -=C2=A0=C2=A0=C2=A0 u64 nodesize =3D btrfs_super_nodesize(sb);
>>> -=C2=A0=C2=A0=C2=A0 u64 sectorsize =3D btrfs_super_sectorsize(sb);
>>> -=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> -
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_magic(sb) !=3D BTRFS_MAGIC) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "no va=
lid FS found");
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUP=
P) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "unrec=
ognized or unsupported super flag:
>>> %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_root_level(sb) >=3D BTRFS_MAX_LEV=
EL) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "tree_=
root level too big: %d >=3D %d",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_chunk_root_level(sb) >=3D BTRFS_M=
AX_LEVEL) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "chunk=
_root level too big: %d >=3D %d",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);=

>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_log_root_level(sb) >=3D BTRFS_MAX=
_LEVEL) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "log_r=
oot level too big: %d >=3D %d",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 /*
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * Check sectorsize and nodesize first, othe=
r check will need it.
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * Check all possible sectorsize(4K, 8K, 16K=
, 32K, 64K) here.
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(sectorsize) || sectorsize < 40=
96 ||
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectorsize > BTRFS_MAX_ME=
TADATA_BLOCKSIZE) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id sectorsize %llu", sectorsize);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 /* Only PAGE SIZE is supported yet */
>>> -=C2=A0=C2=A0=C2=A0 if (sectorsize !=3D PAGE_SIZE) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
sectorsize %llu not supported yet, only support %lu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s=
ectorsize, PAGE_SIZE);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(nodesize) || nodesize < sector=
size ||
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodesize > BTRFS_MAX_META=
DATA_BLOCKSIZE) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id nodesize %llu", nodesize);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (nodesize !=3D le32_to_cpu(sb->__unused_leafsi=
ze)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id leafsize %u, should be %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 le32_to_cpu(sb->__unused_leafsize), nodesize);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 /* Root alignment check */
>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_root(sb), sectorsize)=
) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "tree=
_root block unaligned: %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_root(sb));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_chunk_root(sb), secto=
rsize)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "chun=
k_root block unaligned: %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_chunk_root(sb));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(btrfs_super_log_root(sb), sectors=
ize)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "log_=
root block unaligned: %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_log_root(sb));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRF=
S_FSID_SIZE) !=3D
>>> 0) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 "dev_item UUID does not match fsid: %pU !=3D %pU",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->fsid, sb->dev_item.fsid);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 /*
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * Hint to catch really bogus numbers, bitfl=
ips or so, more exact
>>> checks are
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * done later
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytes_used(sb) < 6 * btrfs_super_=
nodesize(sb)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "bytes=
_used is too small %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_bytes_used(sb));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (!is_power_of_2(btrfs_super_stripesize(sb))) {=

>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "inval=
id stripesize %u",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_stripesize(sb));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_num_devices(sb) > (1UL << 31))
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info, "susp=
icious number of devices: %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 btrfs_super_num_devices(sb));
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_num_devices(sb) =3D=3D 0) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "numbe=
r of devices is 0");
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_bytenr(sb) !=3D BTRFS_SUPER_INFO_=
OFFSET) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "super=
 offset mismatch %llu !=3D %u",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 /*
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * Obvious sys_chunk_array corruptions, it m=
ust hold at least one
>>> key
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * and one chunk
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_sys_array_size(sb) >
>>> BTRFS_SYSTEM_CHUNK_ARRAY_SIZE) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "syste=
m chunk array too big %u > %u",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_sys_array_size(sb),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_sys_array_size(sb) < sizeof(struc=
t btrfs_disk_key)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 +=
 sizeof(struct btrfs_chunk)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_err(fs_info, "syste=
m chunk array too small %u < %zu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs_super_sys_array_size(sb),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sizeof(struct btrfs_disk_key)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 + sizeof(struct btrfs_chunk));
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EINVAL;
>>> -=C2=A0=C2=A0=C2=A0 }
>>> -
>>> -=C2=A0=C2=A0=C2=A0 /*
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * The generation is a global counter, we'll=
 trust it more than
>>> the others
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 * but it's still possible that it's the one=
 that's wrong.
>>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_generation(sb) <
>>> btrfs_super_chunk_root_generation(sb))
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
suspicious: generation < chunk_root_generation: %llu <
>>> %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_generation(sb),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_chunk_root_generation(sb));
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_super_generation(sb) < btrfs_super_cach=
e_generation(sb)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 && btrfs_super_cache_gene=
ration(sb) !=3D (u64)-1)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn(fs_info,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=
suspicious: generation < cache_generation: %llu < %llu",
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_generation(sb),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_super_cache_generation(sb));
>>> -
>>> -=C2=A0=C2=A0=C2=A0 return ret;
>>> -}
>>> -
>>> =C2=A0 static void btrfs_error_commit_super(struct btrfs_fs_info *fs_=
info)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_lock(&fs_info->cleaner_mutex);
>>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.htm=
l
>=20


--Un8Nsh1z31PDjGgQ76wsuUSv0S77SpZxf--

--MZoXWsX1k404q95SkFD9Ju1gT3KQi9v2x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsHe/gACgkQwj2R86El
/qhJnAf/WBXzWvwUg1+1vkNhB+RmJu81PG2UyaQYcND3PiZug/68gOZyLyn4rjLt
R6HPSkrP8XhS0NAM7mwCufsCJJZ3w4dDWMrfMWkbnjbYizHAgI1ATA7xu0XSkRXS
SqilSJbxTJaMOjrxgMCxSPoZOFGOZBPJ3Ve53L0EZ7fX43L3wbTQo+vKp1AhgJp4
vaayHQfBL8PrZI+LlyDzxvWzuNf53xdSx8ZzhNbvulKyF7my2GJPKigNcZyMaUpZ
qQNgdSFAKYOAvz0erwTjPSz6GIb4LipILC8U/hPPDABXQFV7drPPClI8drFoKB66
j5QYHBJ5epeDeYcYA+Zon1kMbOPnjw==
=SfMD
-----END PGP SIGNATURE-----

--MZoXWsX1k404q95SkFD9Ju1gT3KQi9v2x--
