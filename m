Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42130 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbaJASup (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 14:50:45 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s91ImK2O004094
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Oct 2014 11:50:45 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1prpfa86e6-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Oct 2014 11:50:44 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add the ability to fix shifted item offsets V2
Date: Wed, 1 Oct 2014 14:50:40 -0400
Message-ID: <1412189440-5033-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a corrupted fs where the items had been shifted improperly.  This
patch adds the ability to fix this sort of problem within fsck.  We will simply
shift the item over to the proper offset and update the offsets to make sure
they are correct.  I tested this with a hand crafted fs that was broken in the
same way as the user, and I've included the file as a new test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2:
-Exit if we fail to fix the block, we may have started to move things which
could make the fs worse, and since we don't have a transaction abort mechanism
we will just exit to save us from ourselves.

 cmds-check.c                           | 119 +++++++++++++++++++++++++++++----
 tests/fsck-tests/003-shift-offsets.img | Bin 0 -> 4096 bytes
 2 files changed, 106 insertions(+), 13 deletions(-)
 create mode 100644 tests/fsck-tests/003-shift-offsets.img

diff --git a/cmds-check.c b/cmds-check.c
index 02fbd4e..b962b15 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2413,15 +2413,9 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 	return 0;
 }
 
-/*
- * Attempt to fix basic block failures.  Currently we only handle bad key
- * orders, we will cycle through the keys and swap them if necessary.
- */
-static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct extent_buffer *buf,
-				struct btrfs_disk_key *parent_key,
-				enum btrfs_tree_block_status status)
+static int fix_key_order(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct extent_buffer *buf)
 {
 	struct btrfs_path *path;
 	struct btrfs_key k1, k2;
@@ -2429,9 +2423,6 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	int level;
 	int ret;
 
-	if (status != BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
-		return -EIO;
-
 	k1.objectid = btrfs_header_owner(buf);
 	k1.type = BTRFS_ROOT_ITEM_KEY;
 	k1.offset = (u64)-1;
@@ -2482,6 +2473,109 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int fix_item_offset(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf)
+{
+	struct btrfs_path *path;
+	struct btrfs_key k1;
+	int i;
+	int level;
+	int ret;
+
+	k1.objectid = btrfs_header_owner(buf);
+	k1.type = BTRFS_ROOT_ITEM_KEY;
+	k1.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &k1);
+	if (IS_ERR(root))
+		return -EIO;
+
+	record_root_in_trans(trans, root);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -EIO;
+
+	level = btrfs_header_level(buf);
+	path->lowest_level = level;
+	path->skip_check_block = 1;
+	if (level)
+		btrfs_node_key_to_cpu(buf, &k1, 0);
+	else
+		btrfs_item_key_to_cpu(buf, &k1, 0);
+
+	ret = btrfs_search_slot(trans, root, &k1, path, 0, 1);
+	if (ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
+
+	buf = path->nodes[level];
+	for (i = 0; i < btrfs_header_nritems(buf); i++) {
+		unsigned int shift = 0, offset;
+
+		if (i == 0 && btrfs_item_end_nr(buf, i) !=
+		    BTRFS_LEAF_DATA_SIZE(root)) {
+			if (btrfs_item_end_nr(buf, i) >
+			    BTRFS_LEAF_DATA_SIZE(root)) {
+				fprintf(stderr, "item is off the end of the "
+					"leaf, can't fix\n");
+				ret = -EIO;
+				break;
+			}
+			shift = BTRFS_LEAF_DATA_SIZE(root) -
+				btrfs_item_end_nr(buf, i);
+		} else if (i > 0 && btrfs_item_end_nr(buf, i) !=
+			   btrfs_item_offset_nr(buf, i - 1)) {
+			if (btrfs_item_end_nr(buf, i) >
+			    btrfs_item_offset_nr(buf, i - 1)) {
+				fprintf(stderr, "items overlap, can't fix\n");
+				ret = -EIO;
+				break;
+			}
+			shift = btrfs_item_offset_nr(buf, i - 1) -
+				btrfs_item_end_nr(buf, i);
+		}
+		if (!shift)
+			continue;
+
+		printf("Shifting item nr %d by %u bytes in block %llu\n",
+		       i + 1, shift, (unsigned long long)buf->start);
+		offset = btrfs_item_offset_nr(buf, i);
+		memmove_extent_buffer(buf, offset + shift, offset,
+				      btrfs_item_size_nr(buf, i));
+		btrfs_set_item_offset(buf, btrfs_item_nr(i),
+				      offset + shift);
+		btrfs_mark_buffer_dirty(buf);
+	}
+
+	/*
+	 * We may have moved things, in which case we want to exit so we don't
+	 * write those changes out.  Once we have proper abort functionality in
+	 * progs this can be changed to something nicer.
+	 */
+	BUG_ON(ret);
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Attempt to fix basic block failures.  If we can't fix it for whatever reason
+ * then just return -EIO.
+ */
+static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *buf,
+				enum btrfs_tree_block_status status)
+{
+	if (status == BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
+		return fix_key_order(trans, root, buf);
+	if (status == BTRFS_TREE_BLOCK_INVALID_OFFSETS)
+		return fix_item_offset(trans, root, buf);
+	return -EIO;
+}
+
 static int check_block(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       struct cache_tree *extent_cache,
@@ -2520,7 +2614,6 @@ static int check_block(struct btrfs_trans_handle *trans,
 	if (status != BTRFS_TREE_BLOCK_CLEAN) {
 		if (repair)
 			status = try_to_fix_bad_block(trans, root, buf,
-						      &rec->parent_key,
 						      status);
 		if (status != BTRFS_TREE_BLOCK_CLEAN) {
 			ret = -EIO;
diff --git a/tests/fsck-tests/003-shift-offsets.img b/tests/fsck-tests/003-shift-offsets.img
new file mode 100644
index 0000000000000000000000000000000000000000..ba762cedf2b2e17b05596e8fe5cd38f83e819247
GIT binary patch
literal 4096
zcmeH}cTiK=9>)V30V#_>2)GnM>AflfhF~bt5rm~GJ%CiDW(f#H5SAjnBcTX}62;IV
zz=CuXF=zq-K?M<{NeI;}@OEb3?!5Qr{rP6zp1JeApL@>lo^yZSx%YQ&qI+iGoQQop
z;P=LGc&0l(4uSEI006CH6+PC@W0gL2)ZKN=lgA<5$2@b)J;xk=#DLCYbvW)h#=qrn
z2mW^8f5(AP5+aXpq(6#bS)H7rxKx?=<qg%(ZUR#q(bEYqXB+2Q{dgvWn{Rc9Zv2%$
zK=M-*dFmt;)taNlqI&A&1NjsvpbV67@Ae}Ui}a<btoUK49&Bd`lkYi}55R?d1KDNe
zwJF?WfG0ieVO)qp`;}*O>Ss0Q0Ll+Eq4AfZu8AsxjQTx!6L=q{izlCqbET91rhE&h
z#e{mv*bv3kOCOKC%gnyPfE`r&CE8s6v~HI;53m%#&v%KjR>fw_%LevslRa;r&N7VQ
z?oLeQ2He<1H;}yOpL3?!Gii48MBJ;7V{b}Z>*<V(Y*#b@3fcS~p#so!vG*nn%9J;O
z3x~7)3IYHe*KW#$lD<wVn09M%b*_hK+q(&^=mzWYzKY4=QDuMtpkURj?-Y`5c0qIb
z<OAf{OeT8nz8ZkK@VWX&HC<xwxMyC=MGDW5#~wru;8s`22)V^+tFIe+92y$xaSNvE
z&ErtoN6`>6=a^S$?f&y8c#lNuk=GrqVXq=F)3p_PK~-Z2wYxS~qR-)FuCuyzL<h{+
z2_wd0RlA6^SdZvu<=wG`(f#Jt-LbfH|E82Om&c`)uTRi+!Ze@J?09L(c^SEB;K%FX
zjpo6tiC+f?U8qVKa>NbcKIi;KRYZ|N(Lz<&yu^?ONR8@Rgj~!$*vvqZNPcZEjjWy*
z>(5aummQlb9t6)tr1h%5pe@jVrdAQ+hb|R*-{!i(bKfJ_W0hdZ8CyopALGfl39s{U
z=;?uLp{p8qOSM{62&5N|!aV3t93MnDoNu>X$m6)Cm2_PQE(OYVc4_N5N9g?Fl{h<7
znWvE%QkgC!e7>OYph3yPQ;d203M9vGq43)%weXI6NbdadbN(D8?AiNHYQF6ZFTU0F
zmRI1=N?HmnwJfLlYj&=52(1lHWRRO8Z0iIKeSC;RfcGfD0ugrSc~j<V$63>q;qTJB
zVyaGk)zOA)?0;Hwmbt_S-uR_^CrOZu0Ty3}ekt;O9sRZ{mCU{TI$A)ofEP}Z=QI=Y
zLobKPh^H{`=*~_V&(_#t#mjpaRaU*aAQYHC4d;{1%~#$Hw7!k!X0dQWJIy`kZZnQ0
z$hLD9mqy!x1s+GEnS(6fmu6fA*2&sepN}>LBTMN8w|PMHE!e`-P=|LgRI2QAGoh>C
zthZ0sQy1I9X>6)>u9xek6PSf!u&z4^HDb8;9Zmj`KQE!J1Sb@wz__#0?pCs1lv@h*
zffg7|o#8>_nqY1Psf)Pq>UbN8H(q6_hx#R5+r8WjLqH7=UafHk9_bcHUg`&2I6BHE
ztcq}PXL!)CM)zB8X0~n6ypoh4ZdW12W~Y)+qT&9j)G8uuc+j*4IpAi6^rAS()^Au~
zSeu6>wQ7<V<S_u;u0)&-u#zy(=ME~f606U>k!s67<ZcD^q8O;wpEk$T+YC#>YLFw&
zt7suFoJ^w4pI+GQ$WGc+x}2NA_aeCA%@D-u?&~7B9>Qa$rDHU!cC=w@6z+ZJrq5fF
zSgB0=2pQ+|m49r0nj~;zE;2LVniIj0Wh9k#JvnKj1yuZLdZN-tiJ^!szjyS800(iR
z46_!Li|KZMdI!az(?D31-2aU6dM6!RyB5{oAnAb0-t}cUj0LTLiB=VuwdH;Z!r`EQ
zaesrb1FDV$sm(hY1QD|yW7a&RLY^E=gn%`;ElO(me>Xmk)p2cAc0fT$I7gMlbrsg%
z>-apgFKup1?w=*$cEBF>N%MhvT{l^H(!b^OOhm&qmBd1+DUoN!lNT>q+ZB3o|CnNG
zv!A8^Mr6QA1ztOpX3vSuz#L=+X1=^$yJ<TJ5-@DGf0{8gm9=p_yPPje#w`d*cDBed
z_EJR=S(}U-iCn%)uBs<|m53Z+Sy?RuXAGNo6!5;H+2xLMC2Ee=la!^tFOhmLKBQpw
zwrqFGt7$32J_nFU@8)SZ_Xjt>j&v$4mia)b%R)PTWWUw$H6%;&gEk7vE)&RUrRZHk
zU2Z;gO;U*w-3yDkq!*Y79TR?GC%-5%Ev#*;(POvCS(3{9FlM0JQqvC_Yc30Wk%r1f
ztpz<>lL!A-JDg{n9Pa|e{DY!qV832os6J;0Ee^)nTQMN*!IUa`+DAKk#PBLuR$*JV
z<>vyw#tV7<AElA$J<iTa2dSyf1H4?5Hszwjt<dV3w>a&5($066Zts2>`%Igcx_#OB
z>GR{f@{@*YYCp6TFJ!9OZ$2hmFtnk~KpH7DjqD|N{$2}8+GcY>zX@aGTZMZecTUmB
zvCB>VF-~U_xW{ZKx((Hx+H@nu)o^F4oJ{-X>wZl6C4!R2-F60Sz``#(8h}nHJg<ey
zm&#35G<U4NCANUL+_a_z+~beIQy$2Pev(;lZ+y|XpTNElT44k^`m_EIt;zk-kWSC_
z()gW#dd;9W5?pyv-*b!xE|}K0RFYK`ebGjOL<5OBkjrGwwMcPM_x&c8ag&vc8gpui
zCKa^K`0v}q7<?pxz?K}h^11kJ*{5KS4TFqCkrAnxA05Kr%SHTRYmW8USKe_DJ*r~d
zNJvr}As&^H%^`J0=RxfRd@`>i*|DQ<`@#|z-&v0j>D421z@oT=fdedd+kzv0#6w_L
zPKmWH$#?6K|AL%F#HhpKs+fe}iQN;e3p)x?bp@kof$gx@fjbVK`^*rfwDhAL6>p$z
z&I4GxQ*&R-KmPE`K7H4xrE;6`3Y2oPhBaaHw5*AWs(wt289U?UW*rNcz231dp)(*~
z*jx6#8Nc1{1>Xv1hi}f_xeHcoGbUXm2eiM-6{WuHowlxIDRtAd#g$H`jDNAHp9pPk
zGnua2^@v+S)URgR>laTO74`{flu7Ow%O_<s{l)fWbJ+|7hDa4D$hbI2j6k0GSpyHh
zojC3|Bo<R0hTo#u5%*|%ONhP>!N1)3-G^@Yq?*`KYMN|xPF$#2btFf7JTM+sWvOtV
zA4^{y1!V7GQ|8b_iC0+k!_a6BsYl$nWZs!r1!0)w^y7fJsXfs6jF+Es26!G5?1PmS
z-Rrv=l2@<{y9wW-k#G}VCVxUsDG$~gQLt4x>sS(V)lC0^ix^HMsX+hBRzfxTL3g=6
zf|<-@9_gg!R7~-^MBD^trK_8&(g%xcO0cM3u>4cS{Ud|ObDvL9w{7{o6E6cI+mvWX
zN9!sPd~V~%U#XA+>WbzlevkZ;E&L|>FukD?)^0O^&KT{6*f|!h7QmB)=dovU06CAC
zQ`s-m-)EI%M6=yPKS`FS>u>^USBkRuC%4Jf<&BEY#(6hR@=fZ5hf?<LgooeX=Z0t^
z7k;{;tJ7X6Cr50-*X0E$?x+3nRR5s;C03;sPV2*!ho7=`%d-Q`?6@p>?*luD!}`j%
zJ7twk;-6Wx=)W@yrN1zpZsKvEK7*Y$p#~uKz4?FDd$5}2l~`g#$-K(EF{Rqk^;)&)
j>8aW9%KD*Z@@IURbqLpA*ZaS^Mvk$0o+vT;mpT6iVbMSq

literal 0
HcmV?d00001

-- 
1.8.3.1

