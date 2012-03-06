From: Anand jain <Anand.Jain@oracle.com>
Subject: [PATCH 2/2] Use transaction id to determin if there is any change in the subvol
Date: Tue,  6 Mar 2012 15:56:11 +0800
Message-ID: <1331020571-30261-2-git-send-email-Anand.Jain@oracle.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
 <1331020571-30261-1-git-send-email-Anand.Jain@oracle.com>
Cc: chris.mason@oracle.com, hugo@carfax.org.uk,
	Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331020571-30261-1-git-send-email-Anand.Jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Moved from hash method of determining the FS changes to the transaction
record id method

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 autosnap.c |  106 ++++++++++++++++++++++++++++++++++++++----------------------
 autosnap.h |    4 +--
 2 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/autosnap.c b/autosnap.c
index beddf68..1adaf01 100644
--- a/autosnap.c
+++ b/autosnap.c
@@ -45,7 +45,7 @@
 /* during run time if not the below we use "/var/spool/cron"; */
 char cron_path[]="/var/spool/cron/crontabs";
 char autosnap_conf_file[]="/etc/autosnap/config";
-char tmp_file[]="/etc/autosnap/tmpfile";
+//char tmp_file[]="/etc/autosnap/tmpfile";
 
 
 /* Take a snapshot with the default dest and adds attributes */
@@ -59,10 +59,10 @@ int do_autosnap_now(int argc, char **argv)
 	char	**ap;
 	char	subvol[BTRFS_VOL_NAME_MAX];
 	char	sspath[BTRFS_VOL_NAME_MAX + 128];
-	char	tag[100];
-	char	new_hash[65];
+	char	tag[TAG_MAX_LEN];
+	u64	cur_tranid = 0;
+	u64	ss_tranid = 0;
 	char	*mnt;
-	FILE	*fp;
 	u8	fsid[BTRFS_FSID_SIZE];
 	struct stat sb;
 	struct rpolicy_cfg rp;
@@ -101,6 +101,7 @@ int do_autosnap_now(int argc, char **argv)
 		return -1;
 	fd = open_file_or_dir(mnt);
 	get_fsid(fd,&fsid[0]);
+	close(fd);
 	if ((res = read_config(subvol+strlen(mnt),tag,&rp,NULL,&fsid[0])) == 1) {
 		fprintf(stderr,"need to run autosnap enable for this subvol and tag pair\n");
 		return 1;
@@ -109,28 +110,46 @@ int do_autosnap_now(int argc, char **argv)
 		return 1;
 	}
 
+	/* Check if there is any change in the FS by comparing the transaction id*/
+	if (strcmp(rp.idcal, "older") == 0 ) {
+		/* Sync Subvol*/
+		a[1] = subvol;
+		ap = a;
+		res = do_fssync(1, ap);
+		if(res != 0) {
+			return -1;
+		}
+		fd = open_file_or_dir(subvol);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+			return -1;
+		}
+		res = find_updated_files(fd, 0, -1, &cur_tranid);
+		close(fd);
+		if (res)
+			return -1;
+
+		if((stat(rp.last_ss, &sb) == 0) && (rp.last_ss_tranid == cur_tranid)) {
+			printf("FS is identical to the last snapshot. Aborting.\n"); 
+			return -1;
+		}
+	}
+
 	if ( take_autosnap(subvol, tag, sspath) !=0 )
 		return -1;
 
-	if (strcmp(rp.idcal, "older") == 0 ) {
-		fp = fopen(tmp_file, "w");
-		tree_scan(sspath, fp);
-		fclose(fp);
-		get_sha256(tmp_file, new_hash);
-		if((stat(rp.last_ss, &sb) == 0) && (strcmp(rp.last_ss_hash,new_hash) == 0)) {
-			printf("Newer snapshot is identical to the previous snapshot, deleting the newer\n"); 
-			a[1] = sspath;
-			ap = a;
-			res = do_delete_subvolume(2,ap);
-			if(res)
-				printf("do_delete_subvolume failed %d\n",res);
-		} else {
-			/* hash does not match so keep the new snasphot  OR
-			Last snapshot was deleted. */
-			update_last_hash(subvol+strlen(mnt),tag,&fsid[0],sspath,new_hash);
-		}
-		unlink(tmp_file);
+	fd = open_file_or_dir(sspath);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", sspath);
+		return -1;
 	}
+	res = find_updated_files(fd, 0, -1, &ss_tranid);
+	close(fd);
+	if (res)
+		return -1;
+
+	/* tranid does not match or Last snapshot was deleted. go ahead*/
+	update_last_tranid(subvol+strlen(mnt),tag,&fsid[0],sspath,ss_tranid);
 
 	#if 0
 	/* Un-def this when we have synchronous snapshot delete */
@@ -141,7 +160,8 @@ int do_autosnap_now(int argc, char **argv)
 	if (rp.rpval != -1) {
 		res = chk_retain_bynum(subvol, rp.rpval, tag);
 		if(res != 0 ) {
-			fprintf(stderr,"Error: Check for the retainable subvol failed %d\n",res);
+			fprintf(stderr,"Error: Check for the retainable subvol failed %d\n",
+				res);
 			return -1;
 		}
 	}
@@ -457,7 +477,8 @@ int do_autosnap_enable(int argc, char **argv)
 		case 'm':
 			fcnt++;
 			if ((atoi(optarg) > 60) || (atoi(optarg) < 1)) {
-				fprintf(stderr, "Value for option -m: Minutes should be between 1 to 60\n");
+				fprintf(stderr, "Value for option -m: Minutes should be between\
+					1 to 60\n");
 				founderr++;
 			} else {
 				sprintf(freq, "*/%s * * * *", optarg);
@@ -497,7 +518,8 @@ int do_autosnap_enable(int argc, char **argv)
 			rcnt++;
 			retcnt = atoi(optarg);
 			if (retcnt <= 0) {
-				fprintf(stderr, "Value for option -c: Should be a number, snapshots to retain\n");
+				fprintf(stderr, "Value for option -c: Should be a number,\
+					snapshots to retain\n");
 				founderr++;
 			}
 			rpval = retcnt;
@@ -505,12 +527,14 @@ int do_autosnap_enable(int argc, char **argv)
 		case 'n':
 			strcpy(idcal,optarg);
 			if (!((strcmp(idcal, "disable") ==0) || (strcmp(idcal, "older") == 0))) {
-				fprintf(stderr, "Error: parameter %s should be one of disable|older\n",idcal);
+				fprintf(stderr, "Error: parameter %s should be one of disable|older\n",
+					idcal);
 				founderr++;
 			}
 			break;
 		case '?':
-			if (optopt == 't' || optopt == 'm' || optopt == 'D' || optopt == 'c' || optopt == 'D')
+			if (optopt == 't' || optopt == 'm' || optopt == 'D' || optopt == 'c'\
+				|| optopt == 'D')
 				fprintf (stderr, "Option -%c requires an argument.\n", optopt);
 			else if (isprint (optopt))
 				fprintf (stderr, "Unknown option `-%c'.\n", optopt);
@@ -1050,7 +1074,7 @@ int read_config(char *subvol, char *tag, struct rpolicy_cfg *retcfg, struct rpol
 			strcpy(cur->tag, rcfg.tag);
 			strcpy(cur->freq, rcfg.freq);
 			strcpy(cur->idcal, rcfg.idcal);
-			strcpy(cur->last_ss_hash, rcfg.last_ss_hash);
+			cur->last_ss_tranid  = rcfg.last_ss_tranid;
 			strcpy(cur->last_ss, rcfg.last_ss);
 			for(i=0; i<BTRFS_FSID_SIZE; i++)
 				cur->fsid[i]= rcfg.fsid[i];
@@ -1065,7 +1089,7 @@ int read_config(char *subvol, char *tag, struct rpolicy_cfg *retcfg, struct rpol
 				strcpy(retcfg->tag, rcfg.tag);
 				strcpy(retcfg->freq, rcfg.freq);
 				strcpy(retcfg->idcal, rcfg.idcal);
-				strcpy(retcfg->last_ss_hash, rcfg.last_ss_hash);
+				retcfg->last_ss_tranid = rcfg.last_ss_tranid;
 				strcpy(retcfg->last_ss, rcfg.last_ss);
 				for(i=0; i<BTRFS_FSID_SIZE; i++)
 					retcfg->fsid[i] = rcfg.fsid[i];
@@ -1150,7 +1174,8 @@ int delete_config(char *subvol, char *tag, u8 *fsid)
 				break;
 			}
 		} else {
-			if((strcmp(cur->subvol, subvol) == 0) && (memcmp(&(cur->fsid),fsid,BTRFS_FSID_SIZE) == 0)) {
+			if((strcmp(cur->subvol, subvol) == 0) &&\
+				(memcmp(&(cur->fsid),fsid,BTRFS_FSID_SIZE) == 0)) {
 				if(head == cur) 
 					head = cur->next;
 				prev->next = cur->next;
@@ -1170,8 +1195,8 @@ int delete_config(char *subvol, char *tag, u8 *fsid)
 	return 0;
 }
 
-/* maintain the last snapshot hash info so that identical snapshots are not taken */
-int update_last_hash(char *subvol, char *tag, u8 *fsid,char *last_ss, char *hash)
+/* maintain the trans id when last snapshot occurred */
+int update_last_tranid(char *subvol, char *tag, u8 *fsid,char *last_ss, u64 tranid)
 {
 	int	res;
 	struct rpolicy_cfg *head = NULL;
@@ -1189,7 +1214,7 @@ int update_last_hash(char *subvol, char *tag, u8 *fsid,char *last_ss, char *hash
 	while(cur != NULL) {
 		if((strcmp(cur->subvol, subvol) == 0) && (strcmp(cur->tag, tag) == 0) &&
 					(memcmp(&cur->fsid,fsid,BTRFS_FSID_SIZE)==0)) {
-			strcpy(cur->last_ss_hash,hash);
+			cur->last_ss_tranid = tranid;
 			strcpy(cur->last_ss, last_ss);
 			break;
 		}
@@ -1223,11 +1248,15 @@ int write_config(char *subvol, int rpval, char *freq, int diffsz, char *tag, cha
 		return 1;
 	}
 
+	rcfg.last_ss_tranid = 0; 
+	strcpy(rcfg.last_ss, "");
+
 	/* need to find if user is modifying an exisiting entry or creating new*/
 	while((ret = read(fp, &rcfg, sz)) > 0) {
-		//if((strcmp(rcfg.subvol, subvol) == 0) && (strcmp(rcfg.tag, tag) == 0)) break;
 		if((strcmp(rcfg.subvol, subvol) == 0) && (strcmp(rcfg.tag, tag) == 0) &&\
-			(memcmp(&rcfg.fsid,fsid,BTRFS_FSID_SIZE) == 0)) break;
+			(memcmp(&rcfg.fsid,fsid,BTRFS_FSID_SIZE) == 0)) {
+			break;
+		}
 		offset = offset + sz;
 		memset(&rcfg,0,sz);
 	}
@@ -1247,8 +1276,6 @@ int write_config(char *subvol, int rpval, char *freq, int diffsz, char *tag, cha
 	strcpy(rcfg.subvol, subvol);
 	strcpy(rcfg.tag, tag);
 	strcpy(rcfg.idcal, idcal);
-	strcpy(rcfg.last_ss_hash, "");
-	strcpy(rcfg.last_ss, "");
 
 	for(i=0;i<BTRFS_FSID_SIZE;i++)
 		rcfg.fsid[i] = *(fsid++);
@@ -1431,6 +1458,7 @@ int fs_used(char *mnt)
 	return (100 - res);
 }
 
+#ifndef DELETE
 /* generate the sha256 code for a given file */
 int get_sha256(char *fpath, char *op)
 {
@@ -1498,13 +1526,15 @@ int tree_scan( const char *path, FILE *fp)
 				entry->d_name,sb.st_mode,sb.st_nlink,sb.st_uid,sb.st_gid,\
 				ctime(&sb.st_mtime),ctime(&sb.st_ctime));
 		}
-		if(!(S_ISREG(sb.st_mode)) && (strcmp(".",entry->d_name)) && (strcmp("..",entry->d_name))) {
+		if(!(S_ISREG(sb.st_mode)) && (strcmp(".",entry->d_name)) &&\
+			(strcmp("..",entry->d_name))) {
 				tree_scan( spath,fp);
 		}
 	}
 	closedir( dir);
 	return(0);
 }
+#endif
 
 /* obtain mnt from the subvol path */
 int subvol_to_mnt(char *subvol, char **mnt)
diff --git a/autosnap.h b/autosnap.h
index dc126b6..2b4322c 100644
--- a/autosnap.h
+++ b/autosnap.h
@@ -45,7 +45,7 @@ struct rpolicy_cfg {
 	char 	freq[TAG_MAX_LEN];
 	char	tag[TAG_MAX_LEN];
 	char	idcal[50];
-	char	last_ss_hash[65];
+	u64	last_ss_tranid;
 	char	last_ss[BTRFS_VOL_NAME_MAX];
 	int	rpval;
 	int	diffsz;
@@ -62,7 +62,7 @@ int get_fsid(int fd, u8 *fsidp);
 int chk_fslimit(char *subvol);
 char *find_oldest_snap(char *mnt, char *parent, char *tag);
 int write_config(char *subvol, int rpval, char *freq, int diffsz, char *tag, char *idcal, u8 *fsid);
-int update_last_hash(char *subvol, char *tag, u8 *fsid,char *last_ss, char *hash);
+int update_last_tranid(char *subvol, char *tag, u8 *fsid,char *last_ss, u64 tranid);
 int delete_config(char *subvol, char *tag, u8 *fsid);
 int rewrite_config(struct rpolicy_cfg *cfg);
 int read_config(char *subvol, char *tag, struct rpolicy_cfg *retcfg, struct rpolicy_cfg **head, u8 *fsid);
-- 
1.7.9.2.315.g25a78

