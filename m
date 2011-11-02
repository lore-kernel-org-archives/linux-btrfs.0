From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/7] qgroup/quota info for man page
Date: Wed, 02 Nov 2011 22:23:26 +0100
Message-ID: <1588018.167s3yyKQn@venice>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2100129.2BCQMNkVDl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org, Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart2100129.2BCQMNkVDl
Content-Type: multipart/mixed; boundary="nextPart1742496.ipQ6A1WGJ1"
Content-Transfer-Encoding: 7Bit


--nextPart1742496.ipQ6A1WGJ1
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Add qgroup/quota btrfs commands info for man page.

Arne,
please  could you be so kindly to take care of these info for the man page 
from now onwards ? I extract the text both from your pdf and your email. May be
something was wrong because I am not familiar with the qgroup/quota commands.

After merging this patch you can see this text in the man page doing:

make man/btrfs.8.in
man man/btrfs.8.in

Don't hesitate to contact me for further information.

Comments are welcome.

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 btrfs.c      |   79 ++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 198 insertions(+), 5 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index d7ece5b..3c72d0a 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -184,6 +184,82 @@
  * the filesystem. Can be mixed with the \Bdevid\b filter to select
  * chunks in a given address range on a specific device.
  * 
+ * \h Subvolume Quota concept
+ * 
+ * \BSubvolume Quota Groups\b
+ * 
+ * The basic notion of the Subvolume Quota feature is the quota group, short
+ * qgroup. Qgroups are notated as <level>/<id>, e.g. the qgroup 3/2 is a qgroup
+ * of level 3. For level 0 the leading \I0/\i can be omitted. Qgroups of level 
+ * 0 get created automatically when a subvolume/snapshot gets created. The ID 
+ * of the qgroup corresponds to the ID of the subvolume, so 0/5 is the qgroup 
+ * for the root subvolume. For the \Ibtrfs qgroup\i command, the path to the 
+ * subvolume can also be used instead of 0/<ID>. For all higher levels, the ID 
+ * can be choosen freely.
+ * Each qgroup can contain a set of lower level qgroups, thus creating a 
+ * hierarchy of qgroups.
+ * 
+ *  
+ *                         /- {0/1} ------->[   1   ]
+ *                        /
+ *            /- {1/1} ->-+             /-->[   2   ]
+ *           /            \\\\            /
+ *   {2/1}->-+             +  {0/2} ->-+ 
+ *           \\\\            /            \\\\
+ *            \\\\- {1/2} ->-+             +-->[   3   ]
+ *                        \\\\            /
+ *                         \\\\- {0/3} ->-+
+ *                                     \\\\
+ *                                      \\\\-->[   4   ]
+ *  
+ * 
+ * At the bottom of the figure above some extents are depicted showing which 
+ * qgroups reference which extents. It is important to understand the notion 
+ * of referenced versus exclusive. 
+ * In the example qgroup 0/2 references extents 2 and 3, while 1/2 references 
+ * extents 2-4. 2/1 references all extents.
+ * On the other hand, extent 1 is exclusive to 0/1, extent 2 is exclusive to
+ * 0/2, while extent 3 is neither exclusive to 0/2 nor to 0/3.
+ * But because both references can be reached from 1/2, extent 3 is exclusive
+ * to 1/2.
+ * All extents are exclusive to 2/1. So exclusive doesn't mean there's no other
+ * way to reach the extent, but it does mean that if you delete all subvolumes
+ * contained in a qgroup, the extent will get deleted. Exclusive of a qgroup 
+ * conveys the useful information how much space will be freed in case all 
+ * subvolumes of the qgroup get deleted.
+ * All data extents are accounted this way. Metadata that belong to a specific
+ * subvolume (i.e. its fs tree) are also accounted. Checksums and extent 
+ * allocation information are not accounted.
+ * 
+ * In turn the referenced count of a qgroup can be limited. All writes beyond
+ * that limit will lead to a \IQuota Exceeded\i error.
+ * 
+ * \BQuota Inheritance\b
+ * 
+ * If a subvolume should be part of a qgroup, it has to be added to the qgroup
+ * at creation time. To add it at a later time, it would be necessary to at 
+ * least rescan the full subvolume for a proper accounting.
+ * A snapshot references the exact amount of space as its source, and both 
+ * source and destination now have an exclusive count of 0 (4k to be precise, 
+ * as the roots of the trees are not shared). Regarding the qgroups of higher 
+ * levels, if the qgroup contains both the source and the destination, nothing
+ * changes. If the qgroup contains only the source, it might lose some 
+ * exclusive. But how much? The tempting answer is, \Bsubtract all exclusive 
+ * of the source from the qgroup\b, but that's wrong, or at
+ * least not enough. There could have been an extent that's referenced from the
+ * source and another subvolume from that qgroup. This extent would have been
+ * exclusive to the qgroup, but not to the source subvolume. With the creation
+ * of the snapshot the qgroup would also lose this extent from its exclusive 
+ * set.
+ * So how can this problem be solved? In the instant the snapshot gets cre-
+ * ated we already have to know the correct exclusive count. We need to have a
+ * second qgroup that contains all the subvolumes as the first qgroup, except 
+ * the subvolume we want to snapshot. The moment we create the snapshot, the 
+ * exclusive count from the second qgroup needs to be copied to the first 
+ * qgroup, as it represents the correct value. The second qgroup is called a 
+ * tracking qgroup.
+ * It is only there in case a snapshot is needed.
+ * 
  * \h EXIT STATUS
  * \Bbtrfs\b returns a zero exist status if it succeeds. Non zero is returned in
  * case of failure.
@@ -204,9 +280,6 @@
  ****/
 
 
-
-
-
 typedef int (*CommandFunction)(int argc, char **argv);
 
 struct Command {
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 967917e..a071853 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -419,7 +419,7 @@ int do_subvol_list(int argc, char **argv)
 
 /**** man: btrfs subvolume snapshot
  * 
- * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] [-i <qid>] [-c <cspec>] [-x <cspec>]  <source> [<dest>/]<name>\i
  * 
  * Create a writable/readonly snapshot of the subvolume <source> with
  * the name <name> in the <dest> directory.
@@ -428,6 +428,17 @@ int do_subvol_list(int argc, char **argv)
  * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
  * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
  * will be readonly.
+ *
+ * With the creation of a snapshot 
+ * a qgroup gets created automatically. With -i this qgroup can be
+ * added to a higher level qgroup <qid> at creation time. This option can be
+ * given multiple times.
+ * -c and -x copy the values from one qgroup to another at creation time.
+ * In some usecases this is necessary to keep the values consistent. 
+ * The copy spec <cspec>
+ * consists of two qgroupid separated by ':', giving <srcid>:<dstid>. -c
+ * copies the 'referenced' value, -x copies the 'exclusive' value.  These
+ * options can be given multiple times.
  ****/
 
 int do_clone(int argc, char **argv)
@@ -646,13 +657,24 @@ int do_delete_subvolume(int argc, char **argv)
 
 /**** man: btrfs subvolume create
  * 
- * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ * \Bbtrfs\b \Bsubvolume create\b\I [-i <qid>] [-c <cspec>] [-x <cspec>] [<dest>/]<name>\i
  * 
  * Create a subvolume in <dest> (or the current directory if
  * not passed).
  * 
  * Create a subvolume in \I<dest>\i (or in the current directory if
  * \I<dest>\i is omitted).
+ * 
+ * With the creation of a subvolume 
+ * a qgroup gets created automatically. With -i this qgroup can be
+ * added to a higher level qgroup <qid> at creation time. This option can be
+ * given multiple times.
+ * -c and -x copy the values from one qgroup to another at creation time.
+ * In some usecases this is necessary to keep the values consistent. 
+ * The copy spec <cspec>
+ * consists of two qgroupid separated by ':', giving <srcid>:<dstid>. -c
+ * copies the 'referenced' value, -x copies the 'exclusive' value.  These
+ * options can be given multiple times.
  ****/
 
 int do_create_subvol(int argc, char **argv)
@@ -1922,6 +1944,14 @@ int do_get_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs filesystem df
+ * 
+ * \Bbtrfs\b \Bfilesystem df\b \I<path>\i
+ * 
+ * Show space usage information for the mount point \I<path>\i.
+ * 
+ * Show space usage information for the mount point \I<path>\i.
+ ****/
 int do_df_filesystem(int nargs, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
@@ -2170,16 +2200,43 @@ int quota_ctl(int cmd, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs quota enable
+ * 
+ * \Bbtrfs\b \Bquota enable\b \I<path>\i
+ * 
+ * Enable subvolume quota support for a filesystem.
+ * 
+ * Enable subvolume quota support for a filesystem. It creates the quota
+ * tree.
+ ****/
 int do_quota_enable(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_ENABLE, nargs, argv);
 }
 
+/**** man: btrfs quota disable
+ * 
+ * \Bbtrfs\b \Bquota disable\b \I<path>\i
+ * 
+ * Disable subvolume quota support for a filesystem.
+ * 
+ * Disable subvolume quota support for a filesystem. It removes the quota
+ * tree and with it all configuration information.
+ ****/
 int do_quota_disable(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_DISABLE, nargs, argv);
 }
 
+/**** man: btrfs quota rescan
+ * 
+ * \Bbtrfs\b \Bquota rescan\b \I<path>\i
+ * 
+ * Rescan the subvolume for a changed quota setting.
+ * 
+ * Triggers a full re-init of quota information, doing a full fs rescan.
+ * (Kernel side currently does not implement it yet.)
+ ****/
 int do_quota_rescan(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_RESCAN, nargs, argv);
@@ -2220,11 +2277,29 @@ int qgroup_assign(int assign, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs qgroup assign
+ * 
+ * \Bbtrfs\b \Bqgroup assign\b \I<src-id> <dst-id> <path>\i
+ * 
+ * Assign a subvol to a quota group.
+ * 
+ * Assigns the lower level qgroup <src-id> to the higher level 
+ * qgroup <dst-id> in the
+ * btrfs found in <path>. It is used to build qgroup hierarchies.
+ ****/
 int do_qgroup_assign(int nargs, char **argv)
 {
 	return qgroup_assign(1, nargs, argv);
 }
 
+/**** man: btrfs qgroup remove
+ * 
+ * \Bbtrfs\b \Bqgroup remove\b \I<src-id> <dst-id> <path>\i
+ * 
+ * Remove a subvol from a quota group.
+ * 
+ * Remove the qgroup <src-id> from the qgroup <dst-id>.
+ ****/
 int do_qgroup_remove(int nargs, char **argv)
 {
 	return qgroup_assign(0, nargs, argv);
@@ -2257,11 +2332,29 @@ int qgroup_create(int create, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs qgroup create
+ * 
+ * \Bbtrfs\b \Bqgroup create\b \I<qgroupid> <path>\i
+ * 
+ * Create a subvolume quota group.
+ * 
+ * Creates a qgroup with id <qgroupid> for the btrfs found in <path>. 
+ * It will not be part of any hierarchy.
+ ****/
 int do_qgroup_create(int nargs, char **argv)
 {
 	return qgroup_create(1, nargs, argv);
 }
 
+/**** man: btrfs qgroup destroy
+ * 
+ * \Bbtrfs\b \Bqgroup destroy\b \I<qgroupid> <path>\i
+ * 
+ * Destroy a subvolume quota group.
+ * 
+ * Removes the qgroup <qgroupid> from the btrfs found in <path>. It will also
+ * be removed from any higher-level qgroups.
+ ****/
 int do_qgroup_destroy(int nargs, char **argv)
 {
 	return qgroup_create(0, nargs, argv);
@@ -2361,6 +2454,15 @@ done:
 	return ret;
 }
 
+/**** man: btrfs qgroup show
+ * 
+ * \Bbtrfs\b \Bqgroup show\b \I<path>\i
+ * 
+ * Show all subvolume quota groups.
+ * 
+ * Lists all configured qgroup together with the current exclusive and
+ * referenced values.
+ ****/
 int do_qgroup_show(int nargs, char **argv)
 {
 	int	ret=0, fd;
@@ -2422,6 +2524,24 @@ static int parse_limit(const char *p, unsigned long long *s)
 	return 1;
 }
 
+
+/**** man: btrfs qgroup limit
+ * 
+ * \Bbtrfs\b \Bqgroup limit\b [-c] [-e] \I<size>|none {<qgroupid> <path>|<subvolume>}\i
+ * 
+ * Limit the size of a subvolume quota group.
+ * 
+ * Impose a limit of <size> for the amount of referenced space onto the
+ * qgroup <qgroupid> in btrfs <path-to-btrfs> or onto the qgroup referenced
+ * by <path-to-subvol>. A size of none removes the limit.
+ * 
+ * \B-c\b	referenced
+ * 
+ * \B-e\b	exclusive
+ * 
+ * \Isize\i may be in the form nnnn{K|M|G|T}, where K means Kilobytes, M 
+ * means Megabytes....
+ ****/
 int do_qgroup_limit(int argc, char **argv)
 {
 	int	ret=0, fd, e;

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--nextPart1742496.ipQ6A1WGJ1
Content-Disposition: inline; filename="send-via-kmail-attach-18218-1320267572-27071.msg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="send-via-kmail-attach-18218-1320267572-27071.msg"

diff --git a/btrfs.c b/btrfs.c
index d7ece5b..3c72d0a 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -184,6 +184,82 @@
  * the filesystem. Can be mixed with the \Bdevid\b filter to select
  * chunks in a given address range on a specific device.
  * 
+ * \h Subvolume Quota concept
+ * 
+ * \BSubvolume Quota Groups\b
+ * 
+ * The basic notion of the Subvolume Quota feature is the quota group, short
+ * qgroup. Qgroups are notated as <level>/<id>, e.g. the qgroup 3/2 is a qgroup
+ * of level 3. For level 0 the leading \I0/\i can be omitted. Qgroups of level 
+ * 0 get created automatically when a subvolume/snapshot gets created. The ID 
+ * of the qgroup corresponds to the ID of the subvolume, so 0/5 is the qgroup 
+ * for the root subvolume. For the \Ibtrfs qgroup\i command, the path to the 
+ * subvolume can also be used instead of 0/<ID>. For all higher levels, the ID 
+ * can be choosen freely.
+ * Each qgroup can contain a set of lower level qgroups, thus creating a 
+ * hierarchy of qgroups.
+ * 
+ *  
+ *                         /- {0/1} ------->[   1   ]
+ *                        /
+ *            /- {1/1} ->-+             /-->[   2   ]
+ *           /            \\\\            /
+ *   {2/1}->-+             +  {0/2} ->-+ 
+ *           \\\\            /            \\\\
+ *            \\\\- {1/2} ->-+             +-->[   3   ]
+ *                        \\\\            /
+ *                         \\\\- {0/3} ->-+
+ *                                     \\\\
+ *                                      \\\\-->[   4   ]
+ *  
+ * 
+ * At the bottom of the figure above some extents are depicted showing which 
+ * qgroups reference which extents. It is important to understand the notion 
+ * of referenced versus exclusive. 
+ * In the example qgroup 0/2 references extents 2 and 3, while 1/2 references 
+ * extents 2-4. 2/1 references all extents.
+ * On the other hand, extent 1 is exclusive to 0/1, extent 2 is exclusive to
+ * 0/2, while extent 3 is neither exclusive to 0/2 nor to 0/3.
+ * But because both references can be reached from 1/2, extent 3 is exclusive
+ * to 1/2.
+ * All extents are exclusive to 2/1. So exclusive doesn't mean there's no other
+ * way to reach the extent, but it does mean that if you delete all subvolumes
+ * contained in a qgroup, the extent will get deleted. Exclusive of a qgroup 
+ * conveys the useful information how much space will be freed in case all 
+ * subvolumes of the qgroup get deleted.
+ * All data extents are accounted this way. Metadata that belong to a specific
+ * subvolume (i.e. its fs tree) are also accounted. Checksums and extent 
+ * allocation information are not accounted.
+ * 
+ * In turn the referenced count of a qgroup can be limited. All writes beyond
+ * that limit will lead to a \IQuota Exceeded\i error.
+ * 
+ * \BQuota Inheritance\b
+ * 
+ * If a subvolume should be part of a qgroup, it has to be added to the qgroup
+ * at creation time. To add it at a later time, it would be necessary to at 
+ * least rescan the full subvolume for a proper accounting.
+ * A snapshot references the exact amount of space as its source, and both 
+ * source and destination now have an exclusive count of 0 (4k to be precise, 
+ * as the roots of the trees are not shared). Regarding the qgroups of higher 
+ * levels, if the qgroup contains both the source and the destination, nothing
+ * changes. If the qgroup contains only the source, it might lose some 
+ * exclusive. But how much? The tempting answer is, \Bsubtract all exclusive 
+ * of the source from the qgroup\b, but that's wrong, or at
+ * least not enough. There could have been an extent that's referenced from the
+ * source and another subvolume from that qgroup. This extent would have been
+ * exclusive to the qgroup, but not to the source subvolume. With the creation
+ * of the snapshot the qgroup would also lose this extent from its exclusive 
+ * set.
+ * So how can this problem be solved? In the instant the snapshot gets cre-
+ * ated we already have to know the correct exclusive count. We need to have a
+ * second qgroup that contains all the subvolumes as the first qgroup, except 
+ * the subvolume we want to snapshot. The moment we create the snapshot, the 
+ * exclusive count from the second qgroup needs to be copied to the first 
+ * qgroup, as it represents the correct value. The second qgroup is called a 
+ * tracking qgroup.
+ * It is only there in case a snapshot is needed.
+ * 
  * \h EXIT STATUS
  * \Bbtrfs\b returns a zero exist status if it succeeds. Non zero is returned in
  * case of failure.
@@ -204,9 +280,6 @@
  ****/
 
 
-
-
-
 typedef int (*CommandFunction)(int argc, char **argv);
 
 struct Command {
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 967917e..a071853 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -419,7 +419,7 @@ int do_subvol_list(int argc, char **argv)
 
 /**** man: btrfs subvolume snapshot
  * 
- * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] <source> [<dest>/]<name>\i
+ * \Bbtrfs\b \Bsubvolume snapshot\b\I [-r] [-i <qid>] [-c <cspec>] [-x <cspec>]  <source> [<dest>/]<name>\i
  * 
  * Create a writable/readonly snapshot of the subvolume <source> with
  * the name <name> in the <dest> directory.
@@ -428,6 +428,17 @@ int do_subvol_list(int argc, char **argv)
  * name \I<name>\i in the \I<dest>\i directory. If \I<source>\i is not a
  * subvolume, \Bbtrfs\b returns an error. If \I-r\i is given, the snapshot
  * will be readonly.
+ *
+ * With the creation of a snapshot 
+ * a qgroup gets created automatically. With -i this qgroup can be
+ * added to a higher level qgroup <qid> at creation time. This option can be
+ * given multiple times.
+ * -c and -x copy the values from one qgroup to another at creation time.
+ * In some usecases this is necessary to keep the values consistent. 
+ * The copy spec <cspec>
+ * consists of two qgroupid separated by ':', giving <srcid>:<dstid>. -c
+ * copies the 'referenced' value, -x copies the 'exclusive' value.  These
+ * options can be given multiple times.
  ****/
 
 int do_clone(int argc, char **argv)
@@ -646,13 +657,24 @@ int do_delete_subvolume(int argc, char **argv)
 
 /**** man: btrfs subvolume create
  * 
- * \Bbtrfs\b \Bsubvolume create\b\I [<dest>/]<name>\i
+ * \Bbtrfs\b \Bsubvolume create\b\I [-i <qid>] [-c <cspec>] [-x <cspec>] [<dest>/]<name>\i
  * 
  * Create a subvolume in <dest> (or the current directory if
  * not passed).
  * 
  * Create a subvolume in \I<dest>\i (or in the current directory if
  * \I<dest>\i is omitted).
+ * 
+ * With the creation of a subvolume 
+ * a qgroup gets created automatically. With -i this qgroup can be
+ * added to a higher level qgroup <qid> at creation time. This option can be
+ * given multiple times.
+ * -c and -x copy the values from one qgroup to another at creation time.
+ * In some usecases this is necessary to keep the values consistent. 
+ * The copy spec <cspec>
+ * consists of two qgroupid separated by ':', giving <srcid>:<dstid>. -c
+ * copies the 'referenced' value, -x copies the 'exclusive' value.  These
+ * options can be given multiple times.
  ****/
 
 int do_create_subvol(int argc, char **argv)
@@ -1922,6 +1944,14 @@ int do_get_default_subvol(int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs filesystem df
+ * 
+ * \Bbtrfs\b \Bfilesystem df\b \I<path>\i
+ * 
+ * Show space usage information for the mount point \I<path>\i.
+ * 
+ * Show space usage information for the mount point \I<path>\i.
+ ****/
 int do_df_filesystem(int nargs, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs;
@@ -2170,16 +2200,43 @@ int quota_ctl(int cmd, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs quota enable
+ * 
+ * \Bbtrfs\b \Bquota enable\b \I<path>\i
+ * 
+ * Enable subvolume quota support for a filesystem.
+ * 
+ * Enable subvolume quota support for a filesystem. It creates the quota
+ * tree.
+ ****/
 int do_quota_enable(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_ENABLE, nargs, argv);
 }
 
+/**** man: btrfs quota disable
+ * 
+ * \Bbtrfs\b \Bquota disable\b \I<path>\i
+ * 
+ * Disable subvolume quota support for a filesystem.
+ * 
+ * Disable subvolume quota support for a filesystem. It removes the quota
+ * tree and with it all configuration information.
+ ****/
 int do_quota_disable(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_DISABLE, nargs, argv);
 }
 
+/**** man: btrfs quota rescan
+ * 
+ * \Bbtrfs\b \Bquota rescan\b \I<path>\i
+ * 
+ * Rescan the subvolume for a changed quota setting.
+ * 
+ * Triggers a full re-init of quota information, doing a full fs rescan.
+ * (Kernel side currently does not implement it yet.)
+ ****/
 int do_quota_rescan(int nargs, char **argv)
 {
 	return quota_ctl(BTRFS_QUOTA_CTL_RESCAN, nargs, argv);
@@ -2220,11 +2277,29 @@ int qgroup_assign(int assign, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs qgroup assign
+ * 
+ * \Bbtrfs\b \Bqgroup assign\b \I<src-id> <dst-id> <path>\i
+ * 
+ * Assign a subvol to a quota group.
+ * 
+ * Assigns the lower level qgroup <src-id> to the higher level 
+ * qgroup <dst-id> in the
+ * btrfs found in <path>. It is used to build qgroup hierarchies.
+ ****/
 int do_qgroup_assign(int nargs, char **argv)
 {
 	return qgroup_assign(1, nargs, argv);
 }
 
+/**** man: btrfs qgroup remove
+ * 
+ * \Bbtrfs\b \Bqgroup remove\b \I<src-id> <dst-id> <path>\i
+ * 
+ * Remove a subvol from a quota group.
+ * 
+ * Remove the qgroup <src-id> from the qgroup <dst-id>.
+ ****/
 int do_qgroup_remove(int nargs, char **argv)
 {
 	return qgroup_assign(0, nargs, argv);
@@ -2257,11 +2332,29 @@ int qgroup_create(int create, int nargs, char **argv)
 	return 0;
 }
 
+/**** man: btrfs qgroup create
+ * 
+ * \Bbtrfs\b \Bqgroup create\b \I<qgroupid> <path>\i
+ * 
+ * Create a subvolume quota group.
+ * 
+ * Creates a qgroup with id <qgroupid> for the btrfs found in <path>. 
+ * It will not be part of any hierarchy.
+ ****/
 int do_qgroup_create(int nargs, char **argv)
 {
 	return qgroup_create(1, nargs, argv);
 }
 
+/**** man: btrfs qgroup destroy
+ * 
+ * \Bbtrfs\b \Bqgroup destroy\b \I<qgroupid> <path>\i
+ * 
+ * Destroy a subvolume quota group.
+ * 
+ * Removes the qgroup <qgroupid> from the btrfs found in <path>. It will also
+ * be removed from any higher-level qgroups.
+ ****/
 int do_qgroup_destroy(int nargs, char **argv)
 {
 	return qgroup_create(0, nargs, argv);
@@ -2361,6 +2454,15 @@ done:
 	return ret;
 }
 
+/**** man: btrfs qgroup show
+ * 
+ * \Bbtrfs\b \Bqgroup show\b \I<path>\i
+ * 
+ * Show all subvolume quota groups.
+ * 
+ * Lists all configured qgroup together with the current exclusive and
+ * referenced values.
+ ****/
 int do_qgroup_show(int nargs, char **argv)
 {
 	int	ret=0, fd;
@@ -2422,6 +2524,24 @@ static int parse_limit(const char *p, unsigned long long *s)
 	return 1;
 }
 
+
+/**** man: btrfs qgroup limit
+ * 
+ * \Bbtrfs\b \Bqgroup limit\b [-c] [-e] \I<size>|none {<qgroupid> <path>|<subvolume>}\i
+ * 
+ * Limit the size of a subvolume quota group.
+ * 
+ * Impose a limit of <size> for the amount of referenced space onto the
+ * qgroup <qgroupid> in btrfs <path-to-btrfs> or onto the qgroup referenced
+ * by <path-to-subvol>. A size of none removes the limit.
+ * 
+ * \B-c\b	referenced
+ * 
+ * \B-e\b	exclusive
+ * 
+ * \Isize\i may be in the form nnnn{K|M|G|T}, where K means Kilobytes, M 
+ * means Megabytes....
+ ****/
 int do_qgroup_limit(int argc, char **argv)
 {
 	int	ret=0, fd, e;


--nextPart1742496.ipQ6A1WGJ1--

--nextPart2100129.2BCQMNkVDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQBOsbTOvwTxYT3FBRIRAk6IAJ9sCa7DFatySUu0pLFKtGih9cjKBgCfbFXs
XtfbthpGYB8FiIqF9ta9RHo=
=cVzX
-----END PGP SIGNATURE-----

--nextPart2100129.2BCQMNkVDl--

