From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1301!
Date: Mon, 20 Jun 2011 18:12:10 +0800
Message-ID: <4DFF1CFA.7060201@cn.fujitsu.com>
References: <4DFB7C77.6010807@sandia.gov>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010904020402010708010605"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	ceph-devel@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFB7C77.6010807@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>


--------------010904020402010708010605
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

Hi, Jim

Could you test the attached patch for me? 
I have done some quick tests, it worked well. But I'm not sure if it can fix
the bug you reported or not, so I need your help!

Thanks
Miao

On fri, 17 Jun 2011 10:10:31 -0600, Jim Schutt wrote:
> Hi,
> 
> I've hit this delayed-inode BUG several times.  I'm using btrfs
> as the data store for Ceph OSDs, and testing a heavy write load.
> The kernel I'm running is a recent commit (f8f44f09eaa) from
> Linus' tree with the for-chris branch (commit ed0ca14021e5) of
>   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
> merged in.
> 
> Please let me know what I can do to help resolve this.
> 
> [ 5447.554187] err add delayed dir index item(name: pglog_0.965_0) into the insertion tree of the delayed node(root id: 262, inode id: 258, errno: -17)
> [ 5447.569766] ------------[ cut here ]------------
> [ 5447.575361] kernel BUG at fs/btrfs/delayed-inode.c:1301!
> [ 5447.580672] invalid opcode: 0000 [#1] SMP
> [ 5447.584806] CPU 2
> [ 5447.586646] Modules linked in: loop btrfs zlib_deflate lzo_compress ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd scsi_transport_iscsi rds ib_ipoib rdma_ucm rdma_cm ib_ucm ib_uverbs ib_umad ib_cm iw_cm ib_addr ipv6 ib_sa dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod video sbs sbshc pci_slot battery acpi_pad ac kvm sg ses enclosure sd_mod megaraid_sas ide_cd_mod cdrom qla2xxx ib_mthca scsi_transport_fc ib_mad scsi_tgt ib_core button serio_raw ata_piix i5k_amb libata hwmon i5000_edac scsi_mod tpm_tis edac_core ehci_hcd pcspkr iTCO_wdt tpm dcdbas tpm_bios iTCO_vendor_support uhci_hcd rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 
 e1000 [last unloaded: freq_table]
> [ 5447.660248]
> [ 5447.661744] Pid: 7622, comm: cosd Not tainted 3.0.0-rc3-00178-gbfc8ccb #34 Dell Inc. PowerEdge 1950/0DT097
> [ 5447.671421] RIP: 0010:[<ffffffffa068a7fc>]  [<ffffffffa068a7fc>] btrfs_insert_delayed_dir_index+0x124/0x14c [btrfs]
> [ 5447.681922] RSP: 0018:ffff88021c0edaf8  EFLAGS: 00010292
> [ 5447.687351] RAX: 000000000000009e RBX: ffff880085bf0480 RCX: 0000000000012e0f
> [ 5447.694487] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffffffff819aed98
> [ 5447.701631] RBP: ffff88021c0edb48 R08: ffff88021c0ed908 R09: ffffffff8189ef98
> [ 5447.708783] R10: 0000000000000000 R11: 0000000000000006 R12: 00000000ffffffef
> [ 5447.715923] R13: ffff880072e64240 R14: ffff880072e64288 R15: 000000000000000d
> [ 5447.723065] FS:  00007fefc66a9940(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
> [ 5447.731178] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 5447.736934] CR2: 00000000004042b0 CR3: 00000001ca4ef000 CR4: 00000000000006e0
> [ 5447.744087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5447.751218] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 5447.758343] Process cosd (pid: 7622, threadinfo ffff88021c0ec000, task ffff8801d92996b0)
> [ 5447.766422] Stack:
> [ 5447.768429]  00000001d2da3700 ffff88021c0edb88 ffff8802238d50f8 ffff880225627000
> [ 5447.775866]  ffff8801e32f5e58 ffff8801d2da3700 0000000000000000 ffff8801d9aec510
> [ 5447.783291]  000000000000000d ffff8802238d50f8 ffff88021c0edbf8 ffffffffa0641c4e
> [ 5447.790721] Call Trace:
> [ 5447.793191]  [<ffffffffa0641c4e>] btrfs_insert_dir_item+0x189/0x1bb [btrfs]
> [ 5447.800156]  [<ffffffffa0651a45>] btrfs_add_link+0x12b/0x191 [btrfs]
> [ 5447.806517]  [<ffffffffa0651adc>] btrfs_add_nondir+0x31/0x58 [btrfs]
> [ 5447.812876]  [<ffffffffa0651d6a>] btrfs_create+0xf9/0x197 [btrfs]
> [ 5447.818961]  [<ffffffff8111f840>] vfs_create+0x72/0x92
> [ 5447.824090]  [<ffffffff8111fa8c>] do_last+0x22c/0x40b
> [ 5447.829133]  [<ffffffff8112076a>] path_openat+0xc0/0x2ef
> [ 5447.834438]  [<ffffffff810c58e2>] ? __perf_event_task_sched_out+0x24/0x44
> [ 5447.841216]  [<ffffffff8103ecdd>] ? perf_event_task_sched_out+0x59/0x67
> [ 5447.847846]  [<ffffffff81121a79>] do_filp_open+0x3d/0x87
> [ 5447.853156]  [<ffffffff811e126c>] ? strncpy_from_user+0x43/0x4d
> [ 5447.859072]  [<ffffffff8111f1f5>] ? getname_flags+0x2e/0x80
> [ 5447.864636]  [<ffffffff8111f179>] ? do_getname+0x14b/0x173
> [ 5447.870112]  [<ffffffff8111f1b7>] ? audit_getname+0x16/0x26
> [ 5447.875682]  [<ffffffff8112b1ab>] ? spin_lock+0xe/0x10
> [ 5447.880882]  [<ffffffff81112d39>] do_sys_open+0x69/0xae
> [ 5447.886153]  [<ffffffff81112db1>] sys_open+0x20/0x22
> [ 5447.891114]  [<ffffffff813b9aab>] system_call_fastpath+0x16/0x1b
> [ 5447.897124] Code: 85 c0 41 89 c4 74 28 49 8b 45 10 49 8b 4d 00 45 89 e0 48 8b 75 c0 48 c7 c7 bb 43 69 a0 48 8b 90 e8 02 00 00 31 c0 e8 ce fb 9b e0 <0f> 0b eb fe 4c 89 f7 e8 81 7b d2 e0 4c 89 ef e8 d4 e4 ff ff 48
> [ 5447.916562] RIP  [<ffffffffa068a7fc>] btrfs_insert_delayed_dir_index+0x124/0x14c [btrfs]
> [ 5447.924683]  RSP <ffff88021c0edaf8>
> [ 5447.928514] ---[ end trace 461a7f9887994fe0 ]---
> 
> -- Jim
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------010904020402010708010605
Content-Type: text/plain;
 name="0001-btrfs-fix-inconsonant-inode-information.patch"
Content-Disposition: attachment;
 filename="0001-btrfs-fix-inconsonant-inode-information.patch"
Content-Transfer-Encoding: quoted-printable

>From 457f39393b2e3d475fbba029b90b6a4e17b94d43 Mon Sep 17 00:00:00 2001=0AFr=
om: Miao Xie <miaox@cn.fujitsu.com>=0ADate: Mon, 20 Jun 2011 17:21:51 +0800=
=0ASubject: [PATCH] btrfs: fix inconsonant inode information=0A=0AWhen iput=
ting the inode, We may leave the delayed nodes if they have some=0Adelayed =
items that have not been dealt with. So when the inode is read again,=0Awe =
must look up the relative delayed node, and use the information in it to=0A=
initialize the inode. Or we will get inconsonant inode information.=0A=0ASi=
gned-off-by: Miao Xie <miaox@cn.fujitsu.com>=0A---=0A fs/btrfs/delayed-inod=
e.c |  104 +++++++++++++++++++++++++++++++++++-----------=0A fs/btrfs/delay=
ed-inode.h |    1 +=0A fs/btrfs/inode.c         |   12 ++++-=0A 3 files cha=
nged, 91 insertions(+), 26 deletions(-)=0A=0Adiff --git a/fs/btrfs/delayed-=
inode.c b/fs/btrfs/delayed-inode.c=0Aindex f1cbd02..280755e 100644=0A--- a/=
fs/btrfs/delayed-inode.c=0A+++ b/fs/btrfs/delayed-inode.c=0A@@ -82,19 +82,1=
6 @@ static inline struct btrfs=5Fdelayed=5Froot *btrfs=5Fget=5Fdelayed=5Fr=
oot(=0A 	return root->fs=5Finfo->delayed=5Froot;=0A }=0A =0A-static struct =
btrfs=5Fdelayed=5Fnode *btrfs=5Fget=5For=5Fcreate=5Fdelayed=5Fnode(=0A-				=
			struct inode *inode)=0A+static struct btrfs=5Fdelayed=5Fnode *btrfs=5Fge=
t=5Fdelayed=5Fnode(struct inode *inode)=0A {=0A-	struct btrfs=5Fdelayed=5Fn=
ode *node;=0A 	struct btrfs=5Finode *btrfs=5Finode =3D BTRFS=5FI(inode);=0A=
 	struct btrfs=5Froot *root =3D btrfs=5Finode->root;=0A 	u64 ino =3D btrfs=
=5Fino(inode);=0A-	int ret;=0A+	struct btrfs=5Fdelayed=5Fnode *node;=0A =0A=
-again:=0A 	node =3D ACCESS=5FONCE(btrfs=5Finode->delayed=5Fnode);=0A 	if (=
node) {=0A-		atomic=5Finc(&node->refs);	/* can be accessed */=0A+		atomic=
=5Finc(&node->refs);=0A 		return node;=0A 	}=0A =0A@@ -103,7 +100,9 @@ agai=
n:=0A 	if (node) {=0A 		if (btrfs=5Finode->delayed=5Fnode) {=0A 			spin=5Fu=
nlock(&root->inode=5Flock);=0A-			goto again;=0A+			BUG=5FON(btrfs=5Finode-=
>delayed=5Fnode !=3D node);=0A+			atomic=5Finc(&node->refs);	/* can be acce=
ssed */=0A+			return node;=0A 		}=0A 		btrfs=5Finode->delayed=5Fnode =3D no=
de;=0A 		atomic=5Finc(&node->refs);	/* can be accessed */=0A@@ -113,6 +112,=
23 @@ again:=0A 	}=0A 	spin=5Funlock(&root->inode=5Flock);=0A =0A+	return N=
ULL;=0A+}=0A+=0A+static struct btrfs=5Fdelayed=5Fnode *btrfs=5Fget=5For=5Fc=
reate=5Fdelayed=5Fnode(=0A+							struct inode *inode)=0A+{=0A+	struct btrf=
s=5Fdelayed=5Fnode *node;=0A+	struct btrfs=5Finode *btrfs=5Finode =3D BTRFS=
=5FI(inode);=0A+	struct btrfs=5Froot *root =3D btrfs=5Finode->root;=0A+	u64=
 ino =3D btrfs=5Fino(inode);=0A+	int ret;=0A+=0A+again:=0A+	node =3D btrfs=
=5Fget=5Fdelayed=5Fnode(inode);=0A+	if (node)=0A+		return node;=0A+=0A 	nod=
e =3D kmem=5Fcache=5Falloc(delayed=5Fnode=5Fcache, GFP=5FNOFS);=0A 	if (!no=
de)=0A 		return ERR=5FPTR(-ENOMEM);=0A@@ -548,19 +564,6 @@ struct btrfs=5Fd=
elayed=5Fitem *=5F=5Fbtrfs=5Fnext=5Fdelayed=5Fitem(=0A 	return next;=0A }=
=0A =0A-static inline struct btrfs=5Fdelayed=5Fnode *btrfs=5Fget=5Fdelayed=
=5Fnode(=0A-							struct inode *inode)=0A-{=0A-	struct btrfs=5Finode *btrf=
s=5Finode =3D BTRFS=5FI(inode);=0A-	struct btrfs=5Fdelayed=5Fnode *delayed=
=5Fnode;=0A-=0A-	delayed=5Fnode =3D btrfs=5Finode->delayed=5Fnode;=0A-	if (=
delayed=5Fnode)=0A-		atomic=5Finc(&delayed=5Fnode->refs);=0A-=0A-	return de=
layed=5Fnode;=0A-}=0A-=0A static inline struct btrfs=5Froot *btrfs=5Fget=5F=
fs=5Froot(struct btrfs=5Froot *root,=0A 						   u64 root=5Fid)=0A {=0A@@ -=
1404,8 +1407,7 @@ end:=0A =0A int btrfs=5Finode=5Fdelayed=5Fdir=5Findex=5Fc=
ount(struct inode *inode)=0A {=0A-	struct btrfs=5Fdelayed=5Fnode *delayed=
=5Fnode =3D BTRFS=5FI(inode)->delayed=5Fnode;=0A-	int ret =3D 0;=0A+	struct=
 btrfs=5Fdelayed=5Fnode *delayed=5Fnode =3D btrfs=5Fget=5Fdelayed=5Fnode(in=
ode);=0A =0A 	if (!delayed=5Fnode)=0A 		return -ENOENT;=0A@@ -1415,11 +1417=
,14 @@ int btrfs=5Finode=5Fdelayed=5Fdir=5Findex=5Fcount(struct inode *inod=
e)=0A 	 * a new directory index is added into the delayed node and index=5F=
cnt=0A 	 * is updated now. So we needn't lock the delayed node.=0A 	 */=0A-=
	if (!delayed=5Fnode->index=5Fcnt)=0A+	if (!delayed=5Fnode->index=5Fcnt) {=
=0A+		btrfs=5Frelease=5Fdelayed=5Fnode(delayed=5Fnode);=0A 		return -EINVAL=
;=0A+	}=0A =0A 	BTRFS=5FI(inode)->index=5Fcnt =3D delayed=5Fnode->index=5Fc=
nt;=0A-	return ret;=0A+	btrfs=5Frelease=5Fdelayed=5Fnode(delayed=5Fnode);=
=0A+	return 0;=0A }=0A =0A void btrfs=5Fget=5Fdelayed=5Fitems(struct inode =
*inode, struct list=5Fhead *ins=5Flist,=0A@@ -1613,6 +1618,57 @@ static voi=
d fill=5Fstack=5Finode=5Fitem(struct btrfs=5Ftrans=5Fhandle *trans,=0A 				=
      inode->i=5Fctime.tv=5Fnsec);=0A }=0A =0A+int btrfs=5Ffill=5Finode(str=
uct inode *inode, u32 *rdev)=0A+{=0A+	struct btrfs=5Fdelayed=5Fnode *delaye=
d=5Fnode;=0A+	struct btrfs=5Finode=5Fitem *inode=5Fitem;=0A+	struct btrfs=
=5Ftimespec *tspec;=0A+=0A+	delayed=5Fnode =3D btrfs=5Fget=5Fdelayed=5Fnode=
(inode);=0A+	if (!delayed=5Fnode)=0A+		return -ENOENT;=0A+=0A+	mutex=5Flock=
(&delayed=5Fnode->mutex);=0A+	if (!delayed=5Fnode->inode=5Fdirty) {=0A+		mu=
tex=5Funlock(&delayed=5Fnode->mutex);=0A+		btrfs=5Frelease=5Fdelayed=5Fnode=
(delayed=5Fnode);=0A+		return -ENOENT;=0A+	}=0A+=0A+	inode=5Fitem =3D &dela=
yed=5Fnode->inode=5Fitem;=0A+=0A+	inode->i=5Fuid =3D btrfs=5Fstack=5Finode=
=5Fuid(inode=5Fitem);=0A+	inode->i=5Fgid =3D btrfs=5Fstack=5Finode=5Fgid(in=
ode=5Fitem);=0A+	btrfs=5Fi=5Fsize=5Fwrite(inode, btrfs=5Fstack=5Finode=5Fsi=
ze(inode=5Fitem));=0A+	inode->i=5Fmode =3D btrfs=5Fstack=5Finode=5Fmode(ino=
de=5Fitem);=0A+	inode->i=5Fnlink =3D btrfs=5Fstack=5Finode=5Fnlink(inode=5F=
item);=0A+	inode=5Fset=5Fbytes(inode, btrfs=5Fstack=5Finode=5Fnbytes(inode=
=5Fitem));=0A+	BTRFS=5FI(inode)->generation =3D btrfs=5Fstack=5Finode=5Fgen=
eration(inode=5Fitem);=0A+	BTRFS=5FI(inode)->sequence =3D btrfs=5Fstack=5Fi=
node=5Fsequence(inode=5Fitem);=0A+	inode->i=5Frdev =3D 0;=0A+	*rdev =3D btr=
fs=5Fstack=5Finode=5Frdev(inode=5Fitem);=0A+	BTRFS=5FI(inode)->flags =3D bt=
rfs=5Fstack=5Finode=5Fflags(inode=5Fitem);=0A+=0A+	tspec =3D btrfs=5Finode=
=5Fatime(inode=5Fitem);=0A+	inode->i=5Fatime.tv=5Fsec =3D btrfs=5Fstack=5Ft=
imespec=5Fsec(tspec);=0A+	inode->i=5Fatime.tv=5Fnsec =3D btrfs=5Fstack=5Fti=
mespec=5Fnsec(tspec);=0A+=0A+	tspec =3D btrfs=5Finode=5Fmtime(inode=5Fitem)=
;=0A+	inode->i=5Fmtime.tv=5Fsec =3D btrfs=5Fstack=5Ftimespec=5Fsec(tspec);=
=0A+	inode->i=5Fmtime.tv=5Fnsec =3D btrfs=5Fstack=5Ftimespec=5Fnsec(tspec);=
=0A+=0A+	tspec =3D btrfs=5Finode=5Fctime(inode=5Fitem);=0A+	inode->i=5Fctim=
e.tv=5Fsec =3D btrfs=5Fstack=5Ftimespec=5Fsec(tspec);=0A+	inode->i=5Fctime.=
tv=5Fnsec =3D btrfs=5Fstack=5Ftimespec=5Fnsec(tspec);=0A+=0A+	inode->i=5Fge=
neration =3D BTRFS=5FI(inode)->generation;=0A+	BTRFS=5FI(inode)->index=5Fcn=
t =3D (u64)-1;=0A+=0A+	mutex=5Funlock(&delayed=5Fnode->mutex);=0A+	btrfs=5F=
release=5Fdelayed=5Fnode(delayed=5Fnode);=0A+	return 0;=0A+}=0A+=0A int btr=
fs=5Fdelayed=5Fupdate=5Finode(struct btrfs=5Ftrans=5Fhandle *trans,=0A 			 =
      struct btrfs=5Froot *root, struct inode *inode)=0A {=0Adiff --git a/f=
s/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h=0Aindex d1a6a29..8d27af4=
 100644=0A--- a/fs/btrfs/delayed-inode.h=0A+++ b/fs/btrfs/delayed-inode.h=
=0A@@ -119,6 +119,7 @@ void btrfs=5Fkill=5Fdelayed=5Finode=5Fitems(struct i=
node *inode);=0A =0A int btrfs=5Fdelayed=5Fupdate=5Finode(struct btrfs=5Ftr=
ans=5Fhandle *trans,=0A 			       struct btrfs=5Froot *root, struct inode *=
inode);=0A+int btrfs=5Ffill=5Finode(struct inode *inode, u32 *rdev);=0A =0A=
 /* Used for drop dead root */=0A void btrfs=5Fkill=5Fall=5Fdelayed=5Fnodes=
(struct btrfs=5Froot *root);=0Adiff --git a/fs/btrfs/inode.c b/fs/btrfs/ino=
de.c=0Aindex 5813dec..1d25a04 100644=0A--- a/fs/btrfs/inode.c=0A+++ b/fs/bt=
rfs/inode.c=0A@@ -2509,6 +2509,11 @@ static void btrfs=5Fread=5Flocked=5Fin=
ode(struct inode *inode)=0A 	int maybe=5Facls;=0A 	u32 rdev;=0A 	int ret;=
=0A+	bool filled =3D false;=0A+=0A+	ret =3D btrfs=5Ffill=5Finode(inode, &rd=
ev);=0A+	if (!ret)=0A+		filled =3D true;=0A =0A 	path =3D btrfs=5Falloc=5Fp=
ath();=0A 	BUG=5FON(!path);=0A@@ -2520,6 +2525,10 @@ static void btrfs=5Fre=
ad=5Flocked=5Finode(struct inode *inode)=0A 		goto make=5Fbad;=0A =0A 	leaf=
 =3D path->nodes[0];=0A+=0A+	if (filled)=0A+		goto cache=5Facl;=0A+=0A 	ino=
de=5Fitem =3D btrfs=5Fitem=5Fptr(leaf, path->slots[0],=0A 				    struct bt=
rfs=5Finode=5Fitem);=0A 	if (!leaf->map=5Ftoken)=0A@@ -2556,7 +2565,7 @@ st=
atic void btrfs=5Fread=5Flocked=5Finode(struct inode *inode)=0A =0A 	BTRFS=
=5FI(inode)->index=5Fcnt =3D (u64)-1;=0A 	BTRFS=5FI(inode)->flags =3D btrfs=
=5Finode=5Fflags(leaf, inode=5Fitem);=0A-=0A+cache=5Facl:=0A 	/*=0A 	 * try=
 to precache a NULL acl entry for files that don't have=0A 	 * any xattrs o=
r acls=0A@@ -2572,7 +2581,6 @@ static void btrfs=5Fread=5Flocked=5Finode(st=
ruct inode *inode)=0A 	}=0A =0A 	btrfs=5Ffree=5Fpath(path);=0A-	inode=5Fite=
m =3D NULL;=0A =0A 	switch (inode->i=5Fmode & S=5FIFMT) {=0A 	case S=5FIFRE=
G:=0A-- =0A1.7.4=0A=0A=

--------------010904020402010708010605--
