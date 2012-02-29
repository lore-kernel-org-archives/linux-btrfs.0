From: asj <anand.jain@oracle.com>
Subject: [PATCH] [RFC] Add btrfs autosnap feature
Date: Wed, 29 Feb 2012 10:59:36 +0800
Message-ID: <1330484376-16178-2-git-send-email-anand.jain@oracle.com>
References: <n>
 <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
Cc: hugo@carfax.org.uk, chris.mason@oracle.com,
	Anand Jain <Anand.Jain@oracle.com>, asj <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This patch adds btrfs autosnap feature. This creates and
saves the autosnap config at /etc/autosnap/config.
Depending on the configuration, autosnap either schedules
the snapshots by updating the crontab or provides an API
to trigger the snapshots from the respective applications.
The autosnap snapshots are identified and managed using
tag and subvol pair. Further autosnap attributes each
snapshots with creation-time, parent and the tag. Which
makes code to easily identify and retrieve any snapshots.

Signed-off-by: asj <anand.jain@oracle.com>
---
 Makefile     |    6 +-
 autosnap.c   | 1553 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 autosnap.h   |   81 +++
 btrfs-list.c |  140 +++++-
 btrfs.c      |   46 ++-
 btrfs_cmds.c |  186 +++++++-
 btrfs_cmds.h |    3 +-
 scrub.c      |    1 +
 8 files changed, 1982 insertions(+), 34 deletions(-)
 create mode 100644 autosnap.c
 create mode 100644 autosnap.h

diff --git a/Makefile b/Makefile
index 834be47..dee5822 100644
--- a/Makefile
+++ b/Makefile
@@ -13,7 +13,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid
+LIBS = -luuid -lattr -lcrypto
 RESTORE_LIBS=-lz
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
@@ -36,8 +36,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
-	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
+btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o autosnap.o
+	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o autosnap.o\
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
diff --git a/autosnap.c b/autosnap.c
new file mode 100644
index 0000000..beddf68
--- /dev/null
+++ b/autosnap.c
@@ -0,0 +1,1553 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <uuid/uuid.h>
+#include <ctype.h>
+#include <attr/attributes.h>
+#include </usr/include/openssl/sha.h>
+#include <sys/statvfs.h>
+#include <sys/syscall.h>
+#include "kerncompat.h"
+#include "ctree.h"
+#include "transaction.h"
+#include "utils.h"
+#include "version.h"
+#include "ioctl.h"
+#include "volumes.h"
+#include "btrfslabel.h"
+#include "autosnap.h"
+#include "btrfs_cmds.h"
+
+/* during run time if not the below we use "/var/spool/cron"; */
+char cron_path[]="/var/spool/cron/crontabs";
+char autosnap_conf_file[]="/etc/autosnap/config";
+char tmp_file[]="/etc/autosnap/tmpfile";
+
+
+/* Take a snapshot with the default dest and adds attributes */
+int do_autosnap_now(int argc, char **argv)
+{
+	int	res;
+	int	opt;
+	int	erropt=-1;
+	int	fd;
+	char	*a[2];
+	char	**ap;
+	char	subvol[BTRFS_VOL_NAME_MAX];
+	char	sspath[BTRFS_VOL_NAME_MAX + 128];
+	char	tag[100];
+	char	new_hash[65];
+	char	*mnt;
+	FILE	*fp;
+	u8	fsid[BTRFS_FSID_SIZE];
+	struct stat sb;
+	struct rpolicy_cfg rp;
+
+	optind=1;
+	while((opt = getopt(argc,argv,"t:")) != -1) {
+		switch(opt) {
+		case 't':
+			strcpy(tag,optarg);
+			erropt++;
+			break;
+		case '?':
+			fprintf(stderr,"Error: Unknow option %c\n",optopt);
+			return -1;
+		}
+	}
+
+	if(((argc - optind) < 1 ) && ((argc - optind) >= 3)) {
+		fprintf(stderr, "Error: need a subvol\n");
+		return -1;
+	}
+	
+	if(optind == 1) {
+		fprintf(stderr,"Error: need tag \n");
+		return -1;
+	}
+
+	strcpy(subvol, argv[optind]);
+
+	if((res = test_issubvolume(subvol)) < 0) {
+		fprintf(stderr, "Error: error accessing '%s'\n", subvol);
+		return -1;
+	}
+
+	if(subvol_to_mnt(subvol, &mnt) == -1)
+		return -1;
+	fd = open_file_or_dir(mnt);
+	get_fsid(fd,&fsid[0]);
+	if ((res = read_config(subvol+strlen(mnt),tag,&rp,NULL,&fsid[0])) == 1) {
+		fprintf(stderr,"need to run autosnap enable for this subvol and tag pair\n");
+		return 1;
+	} else if(res == -1){
+		fprintf(stderr,"read_config failed\n");
+		return 1;
+	}
+
+	if ( take_autosnap(subvol, tag, sspath) !=0 )
+		return -1;
+
+	if (strcmp(rp.idcal, "older") == 0 ) {
+		fp = fopen(tmp_file, "w");
+		tree_scan(sspath, fp);
+		fclose(fp);
+		get_sha256(tmp_file, new_hash);
+		if((stat(rp.last_ss, &sb) == 0) && (strcmp(rp.last_ss_hash,new_hash) == 0)) {
+			printf("Newer snapshot is identical to the previous snapshot, deleting the newer\n"); 
+			a[1] = sspath;
+			ap = a;
+			res = do_delete_subvolume(2,ap);
+			if(res)
+				printf("do_delete_subvolume failed %d\n",res);
+		} else {
+			/* hash does not match so keep the new snasphot  OR
+			Last snapshot was deleted. */
+			update_last_hash(subvol+strlen(mnt),tag,&fsid[0],sspath,new_hash);
+		}
+		unlink(tmp_file);
+	}
+
+	#if 0
+	/* Un-def this when we have synchronous snapshot delete */
+	chk_fslimit(subvol);
+	#endif
+
+	/* clean based on the retain policy */
+	if (rp.rpval != -1) {
+		res = chk_retain_bynum(subvol, rp.rpval, tag);
+		if(res != 0 ) {
+			fprintf(stderr,"Error: Check for the retainable subvol failed %d\n",res);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/* Set and checks fslimit / autosnap threshold */
+int do_autosnap_fslimit(int argc, char **argv)
+{
+	int	opt;
+	int	chk=0;
+	int	fsl=-1;
+	char	*mnt;
+	char	*fsls=NULL;
+
+	optind=1;
+	while((opt = getopt(argc,argv,"cn:")) != -1) {
+		switch(opt) {
+		case 'n':
+			fsl = atoi(optarg);
+			fsls = optarg;
+			if(fsl > 100 || fsl < 0) {
+				printf("%d should number between 0 and 100%%\n",fsl);
+				return -1;
+			}
+			break;
+		case 'c':
+			chk=1;
+			break;
+		case '?':
+			fprintf(stderr,"Error: Unknow option %c\n",optopt);
+			return -1;
+		}
+	}
+
+	if((argc - optind) != 1) {
+		fprintf(stderr, "Error: usage: btrfs autosnap fslimit -n <n> |-c \n");
+		return -1;
+	}
+
+	if(fsl != -1) {
+		if(subvol_to_mnt(argv[argc-1],&mnt) == -1)
+			return -1;
+		attr_set(mnt,"autosnap.fslimit",fsls,strlen(fsls),ATTR_DONTFOLLOW);
+		printf("'%s' autosnap threshold set at %d%%\n",mnt,fsl);
+		free(mnt);
+		printf("Caveat:\n\
+		 Snapshot delete works in async manner, until there is a way\n\
+		 where btrfs can provide more accurate disk space info, this\n\
+		 feature can not be very effective.\n");
+	}
+
+	if(chk == 1 )
+		chk_fslimit(argv[argc-1]);
+	return 0;
+}
+
+/* disable the autosnap, update the config and crontab if needed */
+int do_autosnap_disable(int argc, char **argv)
+{
+	int	res;
+	int	opt;
+	int	t=0;
+	int	fd;
+	char	subvol[BTRFS_VOL_NAME_MAX];
+	char	tag[TAG_MAX_LEN];
+	char	*mnt;
+	u8	fsid[BTRFS_FSID_SIZE];
+	struct autosnap_cron *head = NULL;
+	struct autosnap_cron *tmp = NULL;
+
+	optind=1;
+	while((opt = getopt(argc,argv,"t:")) != -1) {
+		switch(opt) {
+		case 't':
+			strcpy(tag,optarg);
+			t=1;
+			break;
+		case '?':
+			fprintf(stderr,"Error: Unknow option %c\n",optopt);
+			return -1;
+		}
+	}
+
+	if((argc - optind) != 1) {
+		fprintf(stderr, "Error: usage: btrfs autosnap disable -t <tag> <subvol>\n");
+		return -1;
+	}
+
+	strcpy(subvol, argv[optind]);
+	if(subvol_to_mnt(subvol, &mnt) == -1) return -1;
+	fd = open_file_or_dir(mnt);
+	get_fsid(fd, &fsid[0]);
+	/* clean up cron entries */
+	if((res = cron_retrieve(1, &head)) == 0) {
+		/* remove all subvol or just a tag of the subvol */ 
+		if(t) delete_autosnap(&head, subvol, tag);
+		else while (delete_autosnap(&head, subvol, NULL) != 1);
+
+		/* cron_retrieve (above) removes all entries from cron so put the rest back */
+		if(head) {
+			cron_update(head);
+			while(head != NULL) {
+				tmp = head->next;
+				free(head);
+				head = tmp;
+			}
+		}
+	} else {
+		/* failed to read the cron file so clean up and exit */
+		fprintf(stderr,"Failed to read cron %d\n",res);
+		if(head) {
+			while(head != NULL) {
+				tmp = head->next;
+				free(head);
+				head = tmp;
+			}
+		}
+	}
+
+	if(t) 
+		delete_config(subvol+strlen(mnt), tag, &fsid[0]);
+	else
+		delete_config(subvol+strlen(mnt), NULL, &fsid[0]);
+		
+	return 0;
+}
+
+/* display the config info */
+int do_autosnap_show(int argc, char **argv)
+{
+	int	res;
+	int	fsused;
+	int	fd;
+	int	attrlen=ATTR_MAX_LEN;
+	int	opt;
+	int	showtag=0;
+	char	str_retain[100];
+	char	str_idcal[100];
+	char	*mnt;
+	char	attr[ATTR_MAX_LEN];
+	int	fslimit=0;
+	char	uuidbuf[37];
+	char	svpath[BTRFS_VOL_NAME_MAX + 128];
+	u8	fsid[BTRFS_FSID_SIZE];
+	struct rpolicy_cfg *rp=NULL;
+	struct rpolicy_cfg *cur;
+	struct rpolicy_cfg *prev;
+
+	optind=1;
+	while((opt = getopt(argc,argv,"t")) != -1) {
+		switch(opt) {
+		case 't':
+			showtag=1;
+			break;
+		default:
+			printf("Error, unknown option %c\n",optopt);
+			return -1;
+		}
+	}
+
+	if ((res = read_config(NULL,NULL,NULL,&rp,NULL)) == 1) {
+		return 1;
+	} else if(res == -1){
+		fprintf(stderr,"read_config failed\n");
+		return 1;
+	}
+
+	if(showtag == 1){
+		if ((argc - optind) != 1) {
+			printf("Error, need subvol\n"); 
+			return -1;
+		}
+	}
+
+	if(argc <= 1) {
+		printf("tag\tretain\tidentical\tfsid /subvol\n");
+		cur = rp;
+		while(cur != NULL) {
+			if(cur->rpval == -1)
+				sprintf(str_retain,"all");
+			else
+				sprintf(str_retain,"%d",cur->rpval);
+	
+			if(strcmp(cur->idcal, "older") == 0)
+				strcpy(str_idcal,"older");
+			else
+				sprintf(str_idcal,"%s",cur->idcal);
+	
+			printf("%s\t%s\t%s\t\t",cur->tag,str_retain,str_idcal);
+			uuid_unparse(cur->fsid, uuidbuf);
+			printf("%s ",uuidbuf);
+			printf("%s\n",cur->subvol);
+			cur = cur->next;
+		}
+		return 0;
+	}
+
+	if(subvol_to_mnt(argv[optind], &mnt) == -1) {
+		return -1;
+	}
+	fd = open_file_or_dir(argv[optind]);
+	if(get_fsid(fd, &fsid[0]) != 0) {
+		printf("Error: fsid not found\n");
+		free(mnt);
+		return -1;
+	}
+
+	if(showtag != 1){
+		printf("tag\tretain\tidentical\tsubvol\n");
+	}
+	cur = rp;
+	while(cur != NULL) {
+		strcpy(svpath, mnt);
+		strcat(svpath, cur->subvol);
+		if(memcmp(cur->fsid,fsid,BTRFS_FSID_SIZE)!=0) {
+			cur = cur->next;
+			continue;
+		} 
+		if((strcmp(mnt,argv[optind]) != 0) && (strcmp(svpath, argv[optind]) != 0)) {
+			cur = cur->next;
+			continue;
+		} 
+		if(showtag == 1) {
+			printf("%s\n",cur->tag);
+			cur = cur->next;
+			continue;
+		}
+			
+		if(cur->rpval == -1)
+			sprintf(str_retain,"all");
+		else
+			sprintf(str_retain,"%d",cur->rpval);
+
+		if(strcmp(cur->idcal, "older") == 0)
+			strcpy(str_idcal,"older");
+		else
+			sprintf(str_idcal,"%s",cur->idcal);
+
+		printf("%s\t%s\t%s\t\t%s%s\n",cur->tag,str_retain,str_idcal,mnt,cur->subvol);
+		cur = cur->next;
+	}
+	if(showtag == 1)
+		return 0;
+
+	/* also display the current FS full %*/
+	fsused = fs_used(mnt);
+	if(!(attr_get(mnt, "autosnap.fslimit", attr, &attrlen, ATTR_DONTFOLLOW))) {
+		attr[attrlen]='\0';
+		fslimit = atoi(attr);
+	}
+
+	/*attr_get doesn't err when attr not found, which when fslimit will be zero */
+	if(fslimit == 0) fslimit = 100;	
+
+	printf("autosnap threshold %d%%, %s %d%% full\n",fslimit,mnt,fsused);
+	if(fsused > fslimit)
+		printf("run \'btrfs au fslimit -c %s\' to level\n",mnt);
+
+	/* clean up */
+	cur = rp;
+	while(cur != NULL) {
+		prev = cur;
+		cur = cur->next;
+		free(prev);
+	}
+	free(mnt);
+	return 0;
+}
+
+/* Configure the autosnap */
+int do_autosnap_enable(int argc, char **argv)
+{
+	int res;
+	int opt;
+	int rpval=0;
+	int fcnt = 0;
+	int rcnt = 0;
+	int diffsz = 0;
+	int retcnt;
+	int founderr = 0;
+	int cron_ent = 1;
+	int fd;
+	char subvol[BTRFS_VOL_NAME_MAX + 512];
+	char dest[BTRFS_VOL_NAME_MAX + 128];
+	char *mnt;
+	char freq[TAG_MAX_LEN];
+	char tag[TAG_MAX_LEN];
+	char idcal[100];
+	u8 fsid[BTRFS_FSID_SIZE];
+	struct stat sb;
+	struct autosnap_cron *head = NULL;
+	struct autosnap_cron *tmp = NULL;
+	struct autosnap_cron *new = NULL;
+
+	strcpy(freq,"");
+	strcpy(tag,"");
+	strcpy(idcal,"older");
+
+	optind=1;
+	while((opt = getopt(argc,argv,"t:m:hdMwysc:n:")) != -1) {
+		switch(opt) {
+		case 't':
+			/* User externally set frequency so we don't update the cron*/
+			cron_ent = 0;
+			fcnt++;
+			if(strlen(optarg) > TAG_MAX_LEN){
+				fprintf(stderr,"Error: Tag len is gt %d\n",TAG_MAX_LEN);
+				return -1;
+			}
+			strcpy(tag,optarg);
+			break;
+		case 'm':
+			fcnt++;
+			if ((atoi(optarg) > 60) || (atoi(optarg) < 1)) {
+				fprintf(stderr, "Value for option -m: Minutes should be between 1 to 60\n");
+				founderr++;
+			} else {
+				sprintf(freq, "*/%s * * * *", optarg);
+				strcpy(tag,"@minute");
+			}
+			break;
+		case 'h':
+			fcnt++;
+			sprintf(freq, "@hourly");
+			sprintf(tag, "@hourly");
+			break;
+		case 'd':
+			fcnt++;
+			sprintf(freq, "@daily");
+			sprintf(tag, "@daily");
+			break;
+		case 'w':
+			fcnt++;
+			sprintf(freq, "@weekly");
+			sprintf(tag, "@weekly");
+			break;
+		case 'M':
+			fcnt++;
+			sprintf(freq, "@monthly");
+			sprintf(tag, "@monthly");
+			break;
+		case 'y':
+			fcnt++;
+			sprintf(freq, "@yearly");
+			sprintf(tag, "@yearly");
+			break;
+		case 's':
+			rcnt++;
+			rpval = -1;
+			break;
+		case 'c':
+			rcnt++;
+			retcnt = atoi(optarg);
+			if (retcnt <= 0) {
+				fprintf(stderr, "Value for option -c: Should be a number, snapshots to retain\n");
+				founderr++;
+			}
+			rpval = retcnt;
+			break;
+		case 'n':
+			strcpy(idcal,optarg);
+			if (!((strcmp(idcal, "disable") ==0) || (strcmp(idcal, "older") == 0))) {
+				fprintf(stderr, "Error: parameter %s should be one of disable|older\n",idcal);
+				founderr++;
+			}
+			break;
+		case '?':
+			if (optopt == 't' || optopt == 'm' || optopt == 'D' || optopt == 'c' || optopt == 'D')
+				fprintf (stderr, "Option -%c requires an argument.\n", optopt);
+			else if (isprint (optopt))
+				fprintf (stderr, "Unknown option `-%c'.\n", optopt);
+			else
+				fprintf (stderr, "Unknown option character `\\x%x'.\n", optopt);
+			founderr++;
+			break;
+		default:
+			fprintf(stderr, "Unknown\n");
+			founderr++;
+			break;
+		}
+	}
+
+	if (founderr)
+		return -1;
+
+	if (fcnt > 1 || fcnt == 0 || rcnt > 1 || rcnt ==0) {
+		fprintf(stderr, "ERROR: Provide a frequency with a retension\n");
+		return -1;
+	}
+
+	if((argc - optind) < 1 ) {
+		fprintf(stderr, "Error: need a subvol\n");
+		return -1;
+	}
+
+	if((argc - optind) >= 3) {
+		fprintf(stderr, "Error: needs _a_ subvol\n");
+		return -1;
+	}
+
+	strcpy(subvol, argv[optind]);
+
+	if((res = test_issubvolume(subvol)) < 0) {
+		fprintf(stderr, "Error: error accessing '%s'\n", subvol);
+		return -1;
+	}
+
+	if(subvol_to_mnt(subvol,&mnt) == -1) return -1;
+	sprintf(dest,"%s/.autosnap",mnt);
+
+	if (stat(dest,&sb) != 0) {
+		if((res = mkdir(dest, 0777)) != 0) {
+			fprintf(stderr,"Error: mkdir %s failed with error %d\n",dest,res);
+			free(mnt);
+			return res;
+		}
+	}
+
+	fd = open_file_or_dir(mnt);
+	if(get_fsid(fd,&fsid[0]) != 0) {
+		fprintf(stderr,"Error: get_fsid failed\n");
+		return -1;
+	}
+
+	/* Save config to the config file */
+	write_config(subvol+strlen(mnt),rpval,freq,diffsz,tag,idcal,&fsid[0]);
+	free(mnt);
+
+	/* create the cron entries and write them the cron file */
+	if (cron_ent == 1) {
+		new = malloc(sizeof(struct autosnap_cron));
+		memset(new,0,sizeof(struct autosnap_cron));
+		sprintf(new->cronstr,
+			"%s /usr/local/bin/btrfs autosnap now -t %s %s\n",
+			freq, tag, subvol);
+	
+		/* There might be some old entries so retrieve with copy=1*/
+		cron_retrieve(1, &head);
+		if ( head != NULL ) {
+			insert_autosnap(head, new);
+		} else {
+			head = new;
+		}
+		/*write crontab*/
+		cron_update(head);
+	
+		/* cron_retrieve will alloc now de-alloc them */
+		while(head != NULL) {
+			tmp = head->next;
+			free(head);
+			head = tmp;
+		}
+	}
+	printf("successful\n");
+	printf("\tsubvol: %s tag: %s retain: %d identical: %s\n",subvol,tag,rpval,idcal);
+	if (cron_ent == 0) {
+		printf("\tcommand to call in the script:\n");
+		printf("\tbtrfs autosnap now -t %s %s\n",tag,subvol);
+	}
+	return 0;
+}
+
+/* Checks if the number of snapshots have exceeded the retainable and deletes
+ * the oldest if needed.
+ */
+int chk_retain_bynum(char *subvol, int retain, char *tag)
+{
+	int fd;
+	int ret=0;
+	int cnt=0;
+	char *a[2];
+	char **ap;
+	char *mnt;
+	struct sv_list *head=NULL;
+	struct sv_list *cur=NULL;
+	struct sv_list *prev=NULL;
+	struct sv_list *tmp=NULL;
+
+	fd = open_file_or_dir(subvol);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+
+	if(subvol_to_mnt(subvol,&mnt) == -1) {
+		close(fd);
+		return -1;
+	}
+
+	ret = list_subvols(fd, 1, &head, mnt);
+	if (ret) {
+		close(fd);
+		free(mnt);
+		return 19; 
+	}
+
+	free(mnt);
+	/* now count the number of snapshot of a parent and tag tuple */
+	/* TODO: Instead of parent it should be parent_id */
+	cur=head;
+	while(cur) {
+		if (!((strcmp(cur->parent, subvol) == 0) && (strcmp(cur->tag, tag) == 0))) {
+			if (cur == head)
+				head = cur->next;
+			else
+				prev->next = cur->next;
+			tmp = cur;
+			cur = cur->next;
+			free(tmp);
+		} else  {
+			prev = cur;
+			cur = cur->next;
+			cnt++;
+		}
+	}
+
+	if (cnt == 0)
+		goto out;
+
+	/* -1 means We need one old snapshot to be deleted */
+	if (retain == -1) 
+		retain = cnt - 1;
+
+	while(cnt > retain ) {
+		prev=cur=head;
+		/* find the oldest snapshot for a given subvol */
+		while(cur) {
+			if (cur->crtime < prev->crtime)
+				prev = cur;
+			cur=cur->next;
+		}
+
+		/* delete the olderst snapshot */
+		tmp=prev;
+		a[1]=tmp->name;
+		ap=a;
+		ret = do_delete_subvolume(2,ap);
+		if(ret) {
+			printf("do_delete_subvolume failed %d\n",ret);
+			break;
+		}
+		cur = head;
+		prev = NULL;
+		while (cur) {
+			if (cur == tmp) {
+				if (cur == head)
+					head = cur->next;
+				if (prev != NULL)
+					prev->next = cur->next;
+
+				free(cur);
+				break;
+			} 
+			prev = cur;
+			cur = cur->next;
+		}
+		cnt--;
+	}
+
+out:
+	cur=head;
+	while(cur) {
+		prev = cur;
+		cur = cur->next;
+		free(prev);
+	}
+	close(fd);
+	return ret;
+}
+
+
+/* Create a new snapshot of a given subvol */
+int take_autosnap(char *subvol, char *tag, char *sspath)
+{
+	int	res;
+	char	r[10];
+	char	*a[3];
+	char	**ap;
+	char	*mnt;
+	char	ssname[BTRFS_VOL_NAME_MAX];
+	char 	dest[BTRFS_VOL_NAME_MAX + 128];
+	struct stat sb;
+
+        uuid_t  uuid;
+        uuid_generate_time(uuid);
+        uuid_unparse(uuid, ssname);
+
+	/* Ensure the auto-snapshot dir is present */
+	if(subvol_to_mnt(subvol,&mnt) == -1) return -1;
+	sprintf(dest,"%s/.autosnap",mnt);
+	if (stat(dest,&sb) != 0) {
+		if((res = mkdir(dest, 0777)) != 0) {
+			fprintf(stderr,"Error: mkdir %s failed with error %d\n",dest,res);
+			return res;
+		}
+	}
+
+	/* take a snap for the subvol */
+	sprintf(dest,"%s/.autosnap/%s",mnt,ssname);
+	free(mnt);
+	strcpy(r,"-r");
+	a[0]=r;
+	a[1]=subvol;
+	a[2]=dest;
+	ap=a;
+	if((res = do_clone(3, ap)))
+		return res;
+
+	/* set attribute tag to the snapshot */	
+	attr_set(dest,"tag",tag,strlen(tag),ATTR_DONTFOLLOW);
+	strcpy(sspath, dest);
+
+	return 0;
+}
+
+/* To modify the cron first call cron_retrieve */
+/* Adds autosnap entries to the end of the file */
+int cron_update(struct autosnap_cron *head)
+{
+	char *user;
+	FILE *fp;
+	char buffer[100];
+
+	user = getenv("USER");
+	get_cronpath();
+	sprintf(buffer,"%s/%s",cron_path,user);
+
+	if (!(fp = fopen(buffer,"a+"))) return 1;
+
+	/* Important marker in the cron file */
+	fprintf(fp,"%s\n","#BEGIN autosnap entry");
+	while(head != NULL ) {
+		fprintf(fp,"%s",head->cronstr);
+		head = head->next;
+	}
+	fprintf(fp,"%s\n","#END autosnap entry");
+	fclose(fp);
+	return 0;
+}
+
+/* retrieve and deletes cron entries made by autosnap and stores
+ * it in the struct autosnap_cron
+ * copy = 1 will copy into the head and deletes the cron entries
+ * copy = 0 will not copy into head but deletes the cron entries
+ * copy = 2 copies into head but does NOT deletes the cron entries
+ * return 0 success
+*/
+int cron_retrieve(int copy, struct autosnap_cron **head)
+{
+	char *user;
+	char buffer[100];
+	FILE *fp;
+	int fd;
+	char *line=NULL;
+	size_t len = 0;
+	ssize_t read;
+	ssize_t wrote=0;
+	int ret,res=0;
+	struct autosnap_cron *cron = NULL;
+	struct autosnap_cron *tmp = NULL;
+	struct autosnap_cron *tail = NULL;
+	long offset = 0;
+	long startoffset = -1;
+	long endoffset = -1;
+
+	user = getenv("USER");
+	get_cronpath();
+	sprintf(buffer,"%s/%s",cron_path,user);
+
+	fp = fopen(buffer,"r+");
+	if( fp == NULL ) {
+		if(errno == ENOENT) { res=1; } else { res=2; }
+		goto done;
+	}
+
+	/* look for start and end marker if copy != 0 then copy the content
+	   in between.
+	*/
+	while((read = getline(&line, &len, fp)) != -1) {
+		offset = offset + read;
+		if((ret = strcmp(line,"#BEGIN autosnap entry\n")) == 0) {
+			startoffset = offset - read;
+			if (startoffset == -1) { startoffset = 0;}
+			while((read = getline(&line, &len, fp)) != -1) {
+				offset = offset + read;
+				if(strcmp(line,"#END autosnap entry\n") == 0) {
+					endoffset = offset - read;
+					break;
+				}
+				if(!copy) continue;
+				cron = malloc(sizeof(struct autosnap_cron));
+				memset(cron,'\0',sizeof(struct autosnap_cron));
+				strcpy(cron->cronstr,line);
+				if (*head == NULL) {
+					*head = tail = cron;
+				} else {
+					tail->next = cron;
+					tail = cron;
+					cron->next = NULL;
+				}
+			}
+			break;
+		}
+	}
+
+	/* If the marker not found OR never created*/	
+	if (startoffset == -1 || endoffset == -1) {
+		if(copy) {
+			while(*head != NULL) {
+				tmp = (*head)->next;
+				free(*head);
+				*head = tmp;
+			}
+			*head=NULL;
+		}
+		res=3;
+		goto done;
+	}
+
+	/* if copy = 2 then don't remove cron entries just retrieve*/
+	if(copy == 2) {
+		if(line) free(line);
+		fclose(fp);
+		res=0;
+		return res;
+	}
+
+	/* Removes the cron entries */
+	while((read = getline(&line, &len, fp)) != -1 ) {
+		if(fseek(fp, startoffset, SEEK_SET)) {
+			res=4;
+			goto done;
+		}
+		wrote = fprintf(fp,"%s",line);
+		startoffset = startoffset + wrote;
+
+		offset = offset + read;
+		if(fseek(fp, offset, SEEK_SET)) {
+			res=4;
+			goto done;
+		}
+		line = NULL;
+	}
+
+	if(line) free(line);
+	fclose(fp);
+
+	get_cronpath(); 
+	sprintf(buffer,"%s/%s",cron_path,user);
+	fd = open(buffer,O_RDWR);
+	if(ftruncate(fd, startoffset)) {
+		close(fd);
+		res=5;
+	}
+
+done:
+	if( res == 3 || res == 4 ) {
+		if(line) free(line);
+		fclose(fp);
+	}
+
+	switch(res) {
+	case 0:
+		break;
+	case 1:
+		//fprintf(stderr,"cron file not found\n");
+		break;
+	case 2:
+		/* Error opening the cron filre */
+		fprintf(stderr,"%s\n",strerror(errno));
+		break;
+	case 3:
+		//fprintf(stderr,"autosnap is not yet enabled\n");
+		res = 0;
+		break;
+	case 4:
+		fprintf(stderr,"Error reading/writing the cron file\n");
+		break;
+	case 5:
+		fprintf(stderr,"Failed to write EOF to the cron file\n");
+		break;
+	default:
+		fprintf(stderr,"Bug: reached default for %d\n",res);
+		break;
+	}
+	return res;
+}
+
+/* To add an entry to the cron file first add to the link list */
+int insert_autosnap(struct autosnap_cron *head, struct autosnap_cron *new)
+{
+	char	*s1;
+	char 	*s2;
+	struct autosnap_cron *tmp;
+
+	s1 = strstr(new->cronstr, " -t ");
+	tmp = head;
+	while(1) {
+		s2 = strstr(tmp->cronstr, " -t ");
+		if(strcmp(s1, s2) == 0) {
+			/* There is an existing entry for this tag and subvol */
+			strcpy(tmp->cronstr, new->cronstr);
+			free(new);
+			return 0;
+		}
+		if(!tmp->next) break;
+		tmp = tmp->next;
+	}
+	tmp->next = new;
+	new->next = NULL;
+	return 0;
+}
+
+/* To delete an entry from the cron remove it from the link list*/
+int delete_autosnap(struct autosnap_cron **head, char *subvol, char *tag)
+{
+	char	*s1;
+	char	s2[BTRFS_VOL_NAME_MAX + TAG_MAX_LEN + 5];
+	char	*s3;
+	struct	autosnap_cron *prev;
+	struct	autosnap_cron *cur;
+
+	sprintf(s2, " -t %s %s",tag,subvol);
+	cur = *head;
+	prev = *head;
+	while(cur != NULL) {
+		s3 = strstr(cur->cronstr, " -t ");
+		s1 = strdup(s3);
+		s1[strlen(s1) - 1 ] = '\0';
+		if(tag != NULL) {
+			if(strcmp(s1, s2) == 0) {
+				if (cur == prev) {
+					/* if the first entry is a match 
+						head should point to next */
+					*head=(*head)->next;
+				} else {
+					prev->next = cur->next;
+				}
+				free(cur);
+				free(s1);
+				return 0;
+			}
+		} else {
+			s3 = rindex(s1, ' '); s3++;
+			if(strcmp(s3, subvol) == 0) {
+				if (cur == prev) {
+					/* if the first entry is a match 
+						head should point to next */
+					*head=(*head)->next;
+				} else {
+					prev->next = cur->next;
+				}
+				free(s1);
+				free(cur);
+				return 0;
+			}
+		}
+		prev = cur;
+		cur = cur->next;
+		free(s1);
+	}
+	return 1;
+}
+
+/* read the config file into the linked list structures 
+* return : 0 if subvol tag pair is found
+* return : -1 if some read error
+* return : 1 if subvol tag pair is NOT found
+*/
+int read_config(char *subvol, char *tag, struct rpolicy_cfg *retcfg, struct rpolicy_cfg **head, u8 *fsid)
+{
+	int fp,sz;
+	int found=0;
+	ssize_t ret;
+	struct rpolicy_cfg rcfg;
+	struct rpolicy_cfg *cur=NULL;
+	struct rpolicy_cfg *prev=NULL;
+	int i;
+
+	sz = sizeof(struct rpolicy_cfg);
+	fp = open(autosnap_conf_file,O_RDONLY|O_SYNC);
+	if (fp == -1) {
+		printf("open of autosnap_conf_file %s for read failed\n",autosnap_conf_file);
+		return -1;
+	}
+
+	/* This was written using the struct rpolicy_cfg so reading into the 
+	 * same struct will help.A
+	*/
+	while((ret = read(fp, &rcfg, sz)) == sz) {
+		if(head != NULL) {
+			/* which means caller needs all the entries */
+			cur = malloc(sz);
+			memset(cur,0,sz);
+			/* that means requester needs all the entries */
+			if(found == 0) {
+				*head = cur;
+			} else {
+				prev->next = cur;
+			}
+			cur->next = NULL;
+			cur->diffsz = rcfg.diffsz;
+			cur->rpval  = rcfg.rpval;
+			strcpy(cur->subvol, rcfg.subvol);
+			strcpy(cur->tag, rcfg.tag);
+			strcpy(cur->freq, rcfg.freq);
+			strcpy(cur->idcal, rcfg.idcal);
+			strcpy(cur->last_ss_hash, rcfg.last_ss_hash);
+			strcpy(cur->last_ss, rcfg.last_ss);
+			for(i=0; i<BTRFS_FSID_SIZE; i++)
+				cur->fsid[i]= rcfg.fsid[i];
+			prev = cur;
+			found++;
+		} else {
+			if((strcmp(rcfg.subvol,subvol) == 0) && (strcmp(rcfg.tag, tag) == 0) &&\
+					(memcmp(&rcfg.fsid,fsid,BTRFS_FSID_SIZE)==0)) {
+				retcfg->diffsz = rcfg.diffsz;
+				retcfg->rpval  = rcfg.rpval;
+				strcpy(retcfg->subvol, rcfg.subvol);
+				strcpy(retcfg->tag, rcfg.tag);
+				strcpy(retcfg->freq, rcfg.freq);
+				strcpy(retcfg->idcal, rcfg.idcal);
+				strcpy(retcfg->last_ss_hash, rcfg.last_ss_hash);
+				strcpy(retcfg->last_ss, rcfg.last_ss);
+				for(i=0; i<BTRFS_FSID_SIZE; i++)
+					retcfg->fsid[i] = rcfg.fsid[i];
+				close(fp);
+				return 0;
+			}
+		}
+		memset(&rcfg,'\0',sz);
+	}
+	if (ret) {
+		fprintf(stderr,"Failed read %d %s\n",ret,strerror(errno));
+		cur = *head;
+		while(cur != NULL) {
+			prev = cur;
+			cur = cur->next;
+			free(prev);
+		}
+		close(fp);
+		return -1;
+	}
+	close(fp);
+	if(found == 0)
+		return 1;
+	return 0;
+}
+
+/* This will completely rewrite the entire config file */
+int rewrite_config(struct rpolicy_cfg *cfg)
+{
+	int fp;
+	int ret;
+	int sz;
+
+	sz = sizeof(struct rpolicy_cfg);
+
+	unlink(autosnap_conf_file);
+
+	fp = open(autosnap_conf_file, O_RDWR|O_CREAT|O_SYNC,S_IRUSR|S_IWUSR);
+	if (fp == -1) {
+		fprintf(stderr,"open of autosnap_conf_file %s for write failed\n", autosnap_conf_file);
+		return 1;
+	}
+
+	while(cfg != NULL) {
+		ret = write(fp, cfg, sz);
+		if (ret != sz ) {
+			fprintf(stderr,"write failed %s\n",strerror(errno));
+			return 1;
+		}
+		cfg = cfg->next;
+	}
+	close(fp);
+	return 0;
+}
+
+/* Delete the specified config */
+int delete_config(char *subvol, char *tag, u8 *fsid)
+{
+	int	res;
+	struct rpolicy_cfg *head = NULL;
+	struct rpolicy_cfg *cur;
+	struct rpolicy_cfg *prev;
+
+	if ((res = read_config(NULL,NULL,NULL,&head,NULL)) == 1) {
+		//fprintf(stderr,"Nothing to disable\n");
+		return 1;
+	} else if(res == -1) {
+		fprintf(stderr,"read_config failed\n");
+		return 1;
+	}
+
+	cur = head;
+	prev = head;
+	while(cur != NULL) {
+		if(tag != NULL) {
+			if((strcmp(cur->subvol, subvol) == 0) && (strcmp(cur->tag, tag) == 0) &&\
+				(memcmp(&(cur->fsid),fsid,BTRFS_FSID_SIZE) == 0)) {
+				if(head == cur) 
+					head = cur->next;
+				prev->next = cur->next;
+				free(cur);
+				break;
+			}
+		} else {
+			if((strcmp(cur->subvol, subvol) == 0) && (memcmp(&(cur->fsid),fsid,BTRFS_FSID_SIZE) == 0)) {
+				if(head == cur) 
+					head = cur->next;
+				prev->next = cur->next;
+				free(cur);
+			}
+		}
+		prev = cur;
+		cur = cur->next;	
+	}
+	rewrite_config(head);
+	cur = head;
+	while(cur != NULL) {
+		prev = cur;
+		cur = cur->next;
+		free(prev);
+	}
+	return 0;
+}
+
+/* maintain the last snapshot hash info so that identical snapshots are not taken */
+int update_last_hash(char *subvol, char *tag, u8 *fsid,char *last_ss, char *hash)
+{
+	int	res;
+	struct rpolicy_cfg *head = NULL;
+	struct rpolicy_cfg *cur;
+	struct rpolicy_cfg *prev;
+
+	if ((res = read_config(NULL,NULL,NULL,&head,NULL)) == 1) {
+		return 1;
+	} else if(res == -1) {
+		fprintf(stderr,"read_config failed\n");
+		return 1;
+	}
+
+	cur = head;
+	while(cur != NULL) {
+		if((strcmp(cur->subvol, subvol) == 0) && (strcmp(cur->tag, tag) == 0) &&
+					(memcmp(&cur->fsid,fsid,BTRFS_FSID_SIZE)==0)) {
+			strcpy(cur->last_ss_hash,hash);
+			strcpy(cur->last_ss, last_ss);
+			break;
+		}
+		cur = cur->next;	
+	}
+	rewrite_config(head);
+	cur = head;
+	while(cur != NULL) {
+		prev = cur;
+		cur = cur->next;
+		free(prev);
+	}
+	return 0;
+}
+
+/* This will write to the autosnap config file */
+int write_config(char *subvol, int rpval, char *freq, int diffsz, char *tag, char *idcal, u8 *fsid)
+{
+	int fp,sz;
+	ssize_t ret=0;
+	off_t offset=0;
+	struct rpolicy_cfg rcfg;
+	int	i;
+
+	sz = sizeof(struct rpolicy_cfg);
+	memset(&rcfg,0,sz);
+
+	fp = open(autosnap_conf_file, O_RDWR|O_CREAT|O_SYNC, S_IRUSR|S_IWUSR);
+	if (fp == -1) {
+		fprintf(stderr,"open of autosnap_conf_file %s for write failed\n", autosnap_conf_file);
+		return 1;
+	}
+
+	/* need to find if user is modifying an exisiting entry or creating new*/
+	while((ret = read(fp, &rcfg, sz)) > 0) {
+		//if((strcmp(rcfg.subvol, subvol) == 0) && (strcmp(rcfg.tag, tag) == 0)) break;
+		if((strcmp(rcfg.subvol, subvol) == 0) && (strcmp(rcfg.tag, tag) == 0) &&\
+			(memcmp(&rcfg.fsid,fsid,BTRFS_FSID_SIZE) == 0)) break;
+		offset = offset + sz;
+		memset(&rcfg,0,sz);
+	}
+	if (ret < 0) {
+		fprintf(stderr,"read failed %s\n",strerror(errno));
+		return 1;
+	}
+
+	ret = lseek(fp, offset, SEEK_SET);
+	if (ret < 0) {
+		fprintf(stderr,"lseek failed %s\n",strerror(errno));
+		return 1;
+	}
+	rcfg.rpval = rpval;
+	rcfg.diffsz = diffsz;
+	strcpy(rcfg.freq, freq);
+	strcpy(rcfg.subvol, subvol);
+	strcpy(rcfg.tag, tag);
+	strcpy(rcfg.idcal, idcal);
+	strcpy(rcfg.last_ss_hash, "");
+	strcpy(rcfg.last_ss, "");
+
+	for(i=0;i<BTRFS_FSID_SIZE;i++)
+		rcfg.fsid[i] = *(fsid++);
+
+	ret = write(fp, &rcfg, sz);
+	if (ret < 0) {
+		fprintf(stderr,"write failed %s\n",strerror(errno));
+		return 1;
+	}
+
+	close(fp);
+	return 0;
+}
+
+/* Find the oldest snapshot
+ * returns an allocated string with the path to the oldest 
+ * snapshot, called funcation should free.
+*/
+char *find_oldest_snap(char *mnt, char *parent, char *tag)
+{
+	int fd;
+	int ret;
+	char *res;
+	struct	sv_list	*head=NULL;
+	struct	sv_list	*prev=NULL;
+	struct	sv_list	*cur=NULL;
+
+	fd = open_file_or_dir(mnt);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
+		return NULL;
+	}
+
+	ret = list_subvols(fd, 1, &head, mnt);
+	if (ret) {
+		close(fd);
+		return NULL; 
+	}
+
+	/*take only snapshot which is under autosnap */
+	prev = cur = head;
+	while(cur != NULL){
+		if(strstr(cur->name,".autosnap/")) {
+			prev = cur;
+			cur = cur->next;
+		} else {
+			if (cur == head) {
+				head = prev = cur->next;
+				free(cur);
+				cur = prev = head;
+			} else {
+				prev->next = cur->next;
+				free(cur);
+				cur = prev->next;
+			}
+		}
+	}
+
+	/* Take only snapshot which matches with the given parent and tag tuple */
+	/* TODO : Should be parent id instead of parent name */
+	if(!(parent == NULL && tag == NULL)) {
+		prev = cur = head;
+		while(cur != NULL){
+			if((strcmp(cur->parent,parent) || strcmp(cur->tag,tag))) {
+				if (cur == head) {
+					head = prev = cur->next;
+					free(cur);
+					cur = prev = head;
+				} else {
+					prev->next = cur->next;
+					free(cur);
+					cur = prev->next;
+				}
+			} else {
+				prev = cur;
+				cur = cur->next;
+			}
+		}
+	}
+
+	/* Now find the oldest snapshot */
+	if(!(head))
+		return NULL;
+
+	prev = head;
+	cur = head->next;
+	while(cur != NULL) {
+		if(cur->crtime < prev->crtime)
+			prev = cur;
+		cur = cur->next;
+	}
+
+	res = strdup(prev->name);
+	cur = head;
+	while(cur != NULL) {
+		prev = cur;
+		cur=cur->next;
+		free(prev);
+	}
+	return res;
+}
+
+/* check the autosnap threshold */
+int chk_fslimit(char *subvol)
+{
+	int	ret=0;
+	int	attrlen=ATTR_MAX_LEN;
+	int	fslimit;
+	char	attr[ATTR_MAX_LEN];
+	char	*mnt;
+	char	*oldest_ss;
+	char	*a[2];
+	char	**ap;
+
+	if((ret = test_issubvolume(subvol)) < 0) {
+		printf("Error: %s is not a subvol\n",subvol);
+		return -1;
+	}
+
+	if(subvol_to_mnt(subvol, &mnt) == -1)
+		return -1;
+
+	if(!(attr_get(mnt, "autosnap.fslimit", attr, &attrlen, ATTR_DONTFOLLOW))) {
+		attr[attrlen]='\0';
+		fslimit = atoi(attr);
+	} else
+		return -1;
+
+	/* attr_get when attr is not found doesn't error, so then fslimit becomes zero */
+	if(fslimit == 0) fslimit = 100;
+
+	if (fs_used(mnt) <= fslimit)
+		return 0;
+
+	oldest_ss = find_oldest_snap(mnt, NULL, NULL);
+	if(oldest_ss != NULL) {
+                a[1]=oldest_ss;
+                ap=a;
+                if(do_delete_subvolume(2,ap))
+                        printf("do_delete_subvolume failed %d\n",ret);
+	}
+	free(mnt);
+	free(oldest_ss);
+	return 0;
+}
+
+/* get the fsid given the mount point */
+int get_fsid(int fd, u8 *fsidp)
+{
+	int ret = 0;
+	int i;
+	struct btrfs_ioctl_fs_info_args fi_args;
+
+	memset(&fi_args, 0, sizeof(fi_args));
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
+	if (ret) {
+		fprintf(stderr,"Error: ioctl: %s\n",strerror(errno));
+		return -errno;
+	}
+
+	for(i=0;i<BTRFS_FSID_SIZE;i++)
+		*(fsidp++)=fi_args.fsid[i];
+
+	return 0;
+
+}
+
+/* Find the full-ness of the given mount point */
+int fs_used(char *mnt)
+{
+	struct statvfs statfs;
+	int res;
+	res = statvfs(mnt,&statfs);
+	if (res != 0) {
+		fprintf(stderr,"Error: statvfs failed\n");
+		return -1;
+	}
+	res = ((statfs.f_bsize * statfs.f_bavail) * 100) / ( statfs.f_frsize * statfs.f_blocks);
+	return (100 - res);
+}
+
+/* generate the sha256 code for a given file */
+int get_sha256(char *fpath, char *op)
+{
+	int i;
+	int br = 0;
+	unsigned char hash[SHA256_DIGEST_LENGTH];
+	FILE *fp = fopen(fpath, "r");
+	SHA256_CTX sha256;
+	const int bs = 32768;
+	unsigned char *buf = malloc(bs);
+
+	if(!fp)
+		return -1;
+
+	SHA256_Init(&sha256);
+
+	if(!buf)
+		return -1;
+
+	while((br = fread(buf, 1, bs, fp)))
+		SHA256_Update(&sha256, buf, br);
+
+	SHA256_Final(hash, &sha256);
+
+	for(i = 0; i < SHA256_DIGEST_LENGTH; i++)
+		sprintf(op + (i * 2), "%02x", hash[i]);
+
+	op[64]='\0';
+
+	fclose(fp);
+	free(buf);
+	return 0;
+}
+
+/* Lists all files and dir of a path and its child */
+int tree_scan( const char *path, FILE *fp)
+{
+	char            spath[FILENAME_MAX] = "";
+	char            calc_hash[65];
+	DIR             *dir;
+	struct dirent   *entry;
+	struct stat     sb;
+
+	if( !(dir = opendir( path))) {
+		perror("opendir");
+		return -1;
+	}
+
+	for( entry = readdir( dir); entry; entry = readdir( dir)) {
+		if((strcmp(".",entry->d_name) == 0) || (strcmp("..",entry->d_name) == 0))
+			continue;
+
+		if(strcmp(entry->d_name,".autosnap") == 0)
+			continue;
+
+		sprintf(spath, "%s/%s", path, entry->d_name);
+		stat(spath,&sb);
+		if(!(S_ISREG(sb.st_mode))) {
+			get_sha256(spath, calc_hash);
+			fprintf(fp,"%s %x %x %x %x %s %s %s\n",
+				entry->d_name,sb.st_mode,sb.st_nlink,sb.st_uid,sb.st_gid,\
+				ctime(&sb.st_mtime),ctime(&sb.st_ctime),calc_hash);
+		} else {
+			fprintf(fp,"%s %x %x %x %x %s %s\n",
+				entry->d_name,sb.st_mode,sb.st_nlink,sb.st_uid,sb.st_gid,\
+				ctime(&sb.st_mtime),ctime(&sb.st_ctime));
+		}
+		if(!(S_ISREG(sb.st_mode)) && (strcmp(".",entry->d_name)) && (strcmp("..",entry->d_name))) {
+				tree_scan( spath,fp);
+		}
+	}
+	closedir( dir);
+	return(0);
+}
+
+/* obtain mnt from the subvol path */
+int subvol_to_mnt(char *subvol, char **mnt)
+{
+	int i,x;
+	char *lv;
+
+	if(test_issubvolume(subvol) != 1) {
+		printf("Error: %s is not a subvol\n",subvol);
+		return -1;
+	}
+
+	lv = strdup(subvol);
+	x=strlen(subvol);
+	
+	for (i=0;i<=x;i++) {
+		if(lv[i] == '/') {
+			lv[i] = '\0';
+			if(test_issubvolume(lv) == 1) break;
+			else lv[i] = '/';
+		}
+	}
+	*mnt = lv;
+	return 0;
+}
+
+/* Fedora and ubuntu kind of distribution has different location for crontab
+ * this assumes ubuntu first if dir not found, assume fedora.
+*/
+void get_cronpath()
+{
+	int	fd;
+
+	fd = open_file_or_dir(cron_path);
+
+	/*
+	new string: /var/spool/cron
+	is shorter than
+	old string: /var/spool/cron/crontabs
+	so below code will work.
+	*/
+	if(fd < 0)
+		strcpy(cron_path,"/var/spool/cron");
+
+	close(fd);
+}
diff --git a/autosnap.h b/autosnap.h
new file mode 100644
index 0000000..dc126b6
--- /dev/null
+++ b/autosnap.h
@@ -0,0 +1,81 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define BTRFS_VOL_NAME_MAX 255
+#define ATTR_MAX_LEN BTRFS_VOL_NAME_MAX
+#define TAG_MAX_LEN 128
+
+struct sv_list {
+	int	inode;
+	char	name[BTRFS_VOL_NAME_MAX];
+	int	id;
+	int	p_id;
+	int	tl;
+	char	parent[BTRFS_VOL_NAME_MAX];
+	char	tag[TAG_MAX_LEN];
+	char	crtime[100];
+	struct	sv_list *next;
+}; 
+
+struct sv_filter {
+	char	*parent;
+	char	*tag;
+};
+
+struct autosnap_cron {
+	char	cronstr[BTRFS_VOL_NAME_MAX + 512];
+	struct autosnap_cron *next;
+};
+
+struct rpolicy_cfg {
+	char	subvol[BTRFS_VOL_NAME_MAX];
+	char 	freq[TAG_MAX_LEN];
+	char	tag[TAG_MAX_LEN];
+	char	idcal[50];
+	char	last_ss_hash[65];
+	char	last_ss[BTRFS_VOL_NAME_MAX];
+	int	rpval;
+	int	diffsz;
+	u8	fsid[BTRFS_FSID_SIZE];
+	struct rpolicy_cfg *next;
+};
+
+/* func declaration */
+int subvol_to_mnt(char *subvol, char **mnt);
+int tree_scan( const char *path, FILE *fp);
+int get_sha256(char *fpath, char *op);
+int fs_used(char *mnt);
+int get_fsid(int fd, u8 *fsidp);
+int chk_fslimit(char *subvol);
+char *find_oldest_snap(char *mnt, char *parent, char *tag);
+int write_config(char *subvol, int rpval, char *freq, int diffsz, char *tag, char *idcal, u8 *fsid);
+int update_last_hash(char *subvol, char *tag, u8 *fsid,char *last_ss, char *hash);
+int delete_config(char *subvol, char *tag, u8 *fsid);
+int rewrite_config(struct rpolicy_cfg *cfg);
+int read_config(char *subvol, char *tag, struct rpolicy_cfg *retcfg, struct rpolicy_cfg **head, u8 *fsid);
+int delete_autosnap(struct autosnap_cron **head, char *subvol, char *tag);
+int cron_retrieve(int copy, struct autosnap_cron **head);
+int cron_update(struct autosnap_cron *head);
+int take_autosnap(char *subvol, char *tag, char *sspath);
+int chk_retain_bynum(char *subvol, int retain, char *tag);
+int insert_autosnap(struct autosnap_cron *head, struct autosnap_cron *new);
+void get_cronpath(void);
+int do_autosnap_now(int argc, char **argv);
+int do_autosnap_fslimit(int argc, char **argv);
+int do_autosnap_disable(int argc, char **argv);
+int do_autosnap_show(int argc, char **argv);
+int do_autosnap_enable(int argc, char **argv);
+int sv_filter(struct sv_list **head, struct sv_filter *filter);
diff --git a/btrfs-list.c b/btrfs-list.c
index 5f4a9be..61eddf9 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -34,6 +34,8 @@
 #include "ctree.h"
 #include "transaction.h"
 #include "utils.h"
+#include "autosnap.h"
+#include <attr/attributes.h>
 
 /* we store all the roots we find in an rbtree so that we can
  * search for them later.
@@ -668,11 +670,53 @@ static int __list_subvol_fill_paths(int fd, struct root_lookup *root_lookup)
 	return 0;
 }
 
-int list_subvols(int fd, int print_parent)
+int sv_attr_read(struct sv_list *head)
+{
+	struct sv_list *cur=head;
+	int	attrlen;
+	char	attr[ATTR_MAX_LEN];
+	int	res=0;
+
+	while(cur != NULL) {
+		attrlen=ATTR_MAX_LEN;
+		res = attr_get(cur->name, "tag", attr, &attrlen, ATTR_DONTFOLLOW);
+		if(!res) {
+			attr[attrlen]='\0';
+			strcpy(cur->tag,attr);
+		} else {
+			strcpy(cur->tag,"");
+		}
+
+		attrlen=ATTR_MAX_LEN;
+		res = attr_get(cur->name, "parent", attr, &attrlen, ATTR_DONTFOLLOW);
+		if(!res) {
+			attr[attrlen]='\0';
+			strcpy(cur->parent,attr);
+		} else {
+			strcpy(cur->parent,"");
+		}
+
+		attrlen=ATTR_MAX_LEN;
+		res = attr_get(cur->name, "crtime", attr, &attrlen, ATTR_DONTFOLLOW);
+		if(!res) {
+			attr[attrlen]='\0';
+			strcpy(cur->crtime,attr);
+		} else {
+			strcpy(cur->crtime,"");
+		}
+		cur = cur->next;
+	}
+	return 0;
+}
+
+int list_subvols(int fd, int print_parent, struct sv_list **head, char *mnt)
 {
 	struct root_lookup root_lookup;
 	struct rb_node *n;
 	int ret;
+	struct sv_list *tail;
+	struct sv_list *prev;
+	char	*name_tmp;
 
 	ret = __list_subvol_search(fd, &root_lookup);
 	if (ret) {
@@ -703,20 +747,49 @@ int list_subvols(int fd, int print_parent)
 		entry = rb_entry(n, struct root_info, rb_node);
 		resolve_root(&root_lookup, entry, &root_id, &parent_id,
 				&level, &path);
-		if (print_parent) {
-			printf("ID %llu parent %llu top level %llu path %s\n",
-				(unsigned long long)root_id,
-				(unsigned long long)parent_id,
-				(unsigned long long)level, path);
+		if (head != NULL) {
+			tail = malloc(sizeof(struct sv_list));
+			tail->next = NULL;
+			if (*head == NULL) {
+				*head = tail;
+			}
+			else {
+				prev->next = tail;
+			}
+			tail->id = (unsigned long long)root_id;
+			tail->p_id = (unsigned long long)parent_id;
+			strcpy(tail->name, path);
+			prev = tail;
 		} else {
-			printf("ID %llu top level %llu path %s\n",
-				(unsigned long long)root_id,
-				(unsigned long long)level, path);
+			if (print_parent) {
+				printf("ID %llu parent %llu top level %llu path %s\n",
+					(unsigned long long)root_id,
+					(unsigned long long)parent_id,
+					(unsigned long long)level, path);
+			} else {
+				printf("ID %llu top level %llu path %s\n",
+					(unsigned long long)root_id,
+					(unsigned long long)level, path);
+			}
 		}
 		free(path);
 		n = rb_prev(n);
 	}
 
+	if (head != NULL) {
+		/* prefix mnt */
+		prev = *head;
+		while(prev != NULL) {
+			name_tmp = strdup(prev->name);
+			strcpy(prev->name,mnt);
+			strcat(prev->name,"/");
+			strcat(prev->name,name_tmp);
+			free(name_tmp);
+			prev = prev->next;
+		}
+		sv_attr_read(*head);
+	}
+
 	return ret;
 }
 
@@ -934,3 +1007,52 @@ char *path_for_root(int fd, u64 root)
 
 	return ret_path;
 }
+
+
+/* Filters based on the tag and parent */
+int sv_filter(struct sv_list **head, struct sv_filter *filter)
+{
+	struct sv_list *cur;
+	struct sv_list *prev;
+	struct sv_list *tmp;
+	
+	prev = cur = *head;
+	if(filter->tag != NULL) {
+		while(cur != NULL) {
+			if(strcmp(cur->tag, filter->tag) != 0) {
+				if(*head == cur) {
+					*head = (*head)->next;
+					prev = *head;
+				} else {
+					prev->next = cur->next;
+				}
+				tmp = cur;
+				cur = cur->next;
+				free(tmp);
+			} else {
+				prev = cur;
+				cur = cur->next;
+			}
+		}
+	}
+	cur = *head;
+	if(filter->parent != NULL) {
+		while(cur != NULL) {
+			if(strcmp(cur->parent, filter->parent) != 0) {
+				if(*head == cur) {
+					*head = (*head)->next;
+					prev = *head;
+				} else {
+					prev->next = cur->next;
+				}
+				tmp = cur;
+				cur = cur->next;
+				free(tmp);
+			} else {
+				prev = cur;
+				cur = cur->next;
+			}
+		}
+	}
+	return 0;
+}
diff --git a/btrfs.c b/btrfs.c
index 1def354..2aa61c9 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -20,6 +20,8 @@
 #include <string.h>
 
 #include "kerncompat.h"
+#include "ioctl.h"
+#include "autosnap.h"
 #include "btrfs_cmds.h"
 #include "version.h"
 
@@ -66,11 +68,12 @@ static struct Command commands[] = {
 		"not passed).",
 	  NULL
 	},
-	{ do_subvol_list, -1, "subvolume list", "[-p] <path>\n"
+	{ do_subvol_list, -1, "subvolume list", "[-p] [-t [tag=<t>][,parent=<p>]] <path>\n"
 		"List the snapshot/subvolume of a filesystem.",
 		"[-p] <path>\n"
 		"List the snapshot/subvolume of a filesystem.\n"
-		"-p	   print parent ID"
+		"-p	   print parent ID\n"
+		"-t        print autosnap tag information\n"
 	},
 	{ do_set_default_subvol, 2,
 	  "subvolume set-default", "<id> <path>\n"
@@ -179,6 +182,45 @@ static struct Command commands[] = {
 		"get file system paths for the given logical address.",
 	  NULL
 	},
+	{ do_autosnap_enable, -3,
+	  "autosnap enable", "<frequency|tag> <retension> [identical] <subvol>\n"
+		"Enable autosnap for the tag and subvol pair\n"
+		"  frequency:\n"
+		"     <-m <n>|-h|-d|-M|-w|-y>\n"
+		"      Snapshot every 'n' minutes, hourly, daily, Monthly, weekly, yearly respectively\n"
+		"  retension:\n"
+		"     <-s|-c <n>>\n"
+		"	-s  Save all snapshots\n"
+		"       -c  Keep upto 'n' snapshot per tag and subvol tuple\n"
+		"  identical:\n"
+		"     [-n <older|disable>]\n"
+		"	When two consecutive autosnap snapshots are identical\n"
+		"	older  : (default) Keeps only the older snapshot\n"
+		"	disable: Keeps both the identical snapshots\n",
+	  NULL
+	},
+	{ do_autosnap_fslimit, -2,
+	  "autosnap fslimit", "<-n <x>|-c> <mnt>\n"
+		"Set the disk space threshold when managing the autosnap' snapshots\n"
+		"-n <x>: Configure 'x'% used space above which an autosnap snapshot to be deleted\n"
+		"-c    : Check disk used space and delete a snapshot if used space is above threshold\n",
+	 NULL
+	},
+	{ do_autosnap_disable, -1,
+	  "autosnap disable", "[-t <tag>] <subvol>\n"
+	  "Disable all autosnap tags for a subvol or disable only for the given tag and subvol pair\n",
+	  NULL
+	},
+	{ do_autosnap_show, 999,
+	  "autosnap show", "[-t] [subvol|mnt]\n"
+	  "Show the autosnap configuration\n",
+	  NULL
+	},
+	{ do_autosnap_now, -3,
+	  "autosnap now", "<-t <tag>> <subvol>\n"
+	  "Takes an autosnap snapshot for the given tag and subvol tuple\n",
+	  NULL
+	},
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index b59e9cb..7aab105 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -39,8 +39,10 @@
 #include "ioctl.h"
 #include "volumes.h"
 
+#include "autosnap.h"
 #include "btrfs_cmds.h"
 #include "btrfslabel.h"
+#include <attr/attributes.h>
 
 #ifdef __CHECKER__
 #define BLKGETSIZE64 0
@@ -57,7 +59,7 @@ static inline int ioctl(int fd, int define, void *arg) { return 0; }
  * 1-> path exists and it is  a subvolume
  * -1 -> path is unaccessible
  */
-static int test_issubvolume(char *path)
+int test_issubvolume(char *path)
 {
 
 	struct stat	st;
@@ -303,26 +305,88 @@ int do_subvol_list(int argc, char **argv)
 	int fd;
 	int ret;
 	int print_parent = 0;
+	int print_tag = 0;
+	int print_csv =0;
+	int tag_match = 0;
 	char *subvol;
-        int optind = 1;
+	char *targ;
+	char *argp0;
+	char *argp1;
+	struct sv_filter filter;
+	struct sv_list *head=NULL;
+	struct sv_list *cur;
+	time_t	lt;
+	char	*ct;
+	char	*mnt;
 
+	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "p");
+		int c = getopt(argc, argv, "cpt:");
 		if (c < 0) break;
 		switch(c) {
+		case 'c':
+			print_csv =1;
+			break;
 		case 'p':
 			print_parent = 1;
-			optind++;
+			break;
+		case 't':
+			print_tag++;
+			filter.parent = NULL;
+			filter.tag = NULL;
+			targ = strdup(optarg);
+
+			argp0 = strtok(targ,"=");
+			while(argp0 != NULL) {	
+				if(!(strcmp(argp0,"parent"))) {
+					tag_match++;
+					argp1 = strtok(NULL,",");
+					if(argp1 == NULL) {
+						fprintf(stderr,"\"parent=\" argument missing\n"); 
+						return 1;
+					}
+					filter.parent = strdup(argp1);
+				}else if (!(strcmp(argp0,"tag"))) {
+					tag_match++;
+					argp1 = strtok(NULL,",");
+					if(argp1 == NULL) {
+						fprintf(stderr,"\"tag\" must have value\n"); 
+						return 1;
+					}
+					filter.tag = strdup(argp1);
+				}
+				argp0 = strtok(NULL,"=");
+			}
+			free(targ);
+			break;
+		case '?':
+			fprintf(stderr,"Error: unknown option\n");
+			return -1;
 			break;
 		}
 	}
-	
-	if (argc - optind != 1) {
-		fprintf(stderr, "ERROR: invalid arguments for subvolume list\n");
-		return 1;
-	}
 
-	subvol = argv[optind];
+	if(print_tag) {
+		if(tag_match) {
+			if (argc - optind != 1) {
+				fprintf(stderr, "ERROR: invalid arguments for subvolume list\n");
+				return 1;
+			}
+			subvol = argv[optind];
+		} else {
+			if (argc != optind) {
+				fprintf(stderr, "ERROR: invalid arguments for subvolume list\n");
+				return 1;
+			}
+			subvol = argv[optind-1];
+		}
+	} else {
+		if (argc - optind != 1) {
+			fprintf(stderr, "ERROR: invalid arguments for subvolume list\n");
+			return 1;
+		}
+		subvol = argv[optind];
+	}
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
@@ -334,14 +398,73 @@ int do_subvol_list(int argc, char **argv)
 		return 13;
 	}
 
-	fd = open_file_or_dir(subvol);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
-		return 12;
+	if(print_tag) {
+		fd = open_file_or_dir(subvol);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+			return 12;
+		}
+		if(subvol_to_mnt(subvol, &mnt) == -1) {
+			close(fd);
+			return -1;
+		}
+		ret = list_subvols(fd, print_parent, &head, mnt);
+		if (ret) {
+			cur=head;
+			while(cur != NULL) {
+				head = cur->next;
+				free(cur);
+				cur = head;
+			}
+			free(mnt);
+			close(fd);
+			return 19;
+		}
+
+		sv_filter(&head, &filter);
+		if(filter.parent)
+			free(filter.parent);
+		if(filter.tag)
+			free(filter.tag);
+
+		cur = head;
+		ct = "";
+		while(cur) {
+			lt = atoi(cur->crtime);
+			if(lt) {
+				ct = ctime(&lt);
+				ct[strlen(ct)-1] = '\0';
+			}
+			if(print_csv)
+				printf("%s,%s,%s,%s,\n",
+					cur->name,ct,cur->parent,cur->tag);
+			else
+				printf("%s %s %s %s\n",
+					cur->name,ct,cur->parent,cur->tag);
+
+			cur = cur->next;
+			ct = "";
+		}
+		cur=head;
+		while(cur != NULL) {
+			head = cur->next;
+			free(cur);
+			cur = head;
+		}
+		free(mnt);
+	} else {
+		fd = open_file_or_dir(subvol);
+		if (fd < 0) {
+			fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+			return 12;
+		}
+		ret = list_subvols(fd, print_parent, NULL, NULL);
+		if (ret) {
+			close(fd);
+			return 19;
+		}
 	}
-	ret = list_subvols(fd, print_parent, 0);
-	if (ret)
-		return 19;
+	close(fd);
 	return 0;
 }
 
@@ -350,8 +473,12 @@ int do_clone(int argc, char **argv)
 	char	*subvol, *dst;
 	int	res, fd, fddst, len, e, optind = 0, readonly = 0;
 	char	*newname;
+	char	*sspath;
 	char	*dstdir;
 	struct btrfs_ioctl_vol_args_v2	args;
+	char	*ts;
+	time_t	lt;
+	struct	tm tm;
 
 	memset(&args, 0, sizeof(args));
 
@@ -458,8 +585,29 @@ int do_clone(int argc, char **argv)
 		return 11;
 	}
 
-	return 0;
+	sspath = malloc(strlen(dstdir) + strlen(newname) + 10);
+	sprintf(sspath,"%s/%s",dstdir,newname);
 
+	res = attr_set(sspath,"parent",subvol,strlen(subvol),ATTR_DONTFOLLOW);
+	if (res != 0) {
+		fprintf( stderr, "Error: attr_setf\n");
+	} 
+	
+	lt = time(NULL);
+	tm = *localtime(&lt);
+	ts = (char *)malloc(sizeof(char) * 80);
+	res = strftime(ts, sizeof(char)*80, "%s",&tm); 
+	if (res) {
+		res = attr_set(sspath,"crtime",ts,res,ATTR_DONTFOLLOW);
+		if (res != 0) {
+			fprintf( stderr, "Error: attr_setf\n");
+		} 
+	} else {
+		fprintf(stderr,"Error: strftime failed %d\n",res);
+	}
+	free(ts);
+	free(sspath);
+	return 0;
 }
 
 int do_delete_subvolume(int argc, char **argv)
@@ -1013,7 +1161,7 @@ int do_get_default_subvol(int nargs, char **argv)
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
-	ret = list_subvols(fd, 0, 1);
+	ret = list_subvols(fd, 0, NULL, NULL);
 	if (ret)
 		return 19;
 	return 0;
diff --git a/btrfs_cmds.h b/btrfs_cmds.h
index 81182b1..f53c113 100644
--- a/btrfs_cmds.h
+++ b/btrfs_cmds.h
@@ -33,7 +33,7 @@ int do_resize(int nargs, char **argv);
 int do_subvol_list(int nargs, char **argv);
 int do_set_default_subvol(int nargs, char **argv);
 int do_get_default_subvol(int nargs, char **argv);
-int list_subvols(int fd, int print_parent, int get_default);
+int list_subvols(int fd, int print_parent, struct sv_list **head, char *mnt);
 int do_df_filesystem(int nargs, char **argv);
 int find_updated_files(int fd, u64 root_id, u64 oldest_gen);
 int do_find_newer(int argc, char **argv);
@@ -42,3 +42,4 @@ int open_file_or_dir(const char *fname);
 int do_ino_to_path(int nargs, char **argv);
 int do_logical_to_ino(int nargs, char **argv);
 char *path_for_root(int fd, u64 root);
+int test_issubvolume(char *path);
diff --git a/scrub.c b/scrub.c
index 9dca5f6..9130aa9 100644
--- a/scrub.c
+++ b/scrub.c
@@ -34,6 +34,7 @@
 
 #include "ctree.h"
 #include "ioctl.h"
+#include "autosnap.h"
 #include "btrfs_cmds.h"
 #include "utils.h"
 #include "volumes.h"
-- 
1.7.0.4

