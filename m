Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:59374 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2GTTgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 15:36:07 -0400
Message-ID: <5009B323.3040607@libero.it>
Date: Fri, 20 Jul 2012 21:36:03 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is
 a ssd V2
References: <1342811743-8748-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1342811743-8748-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2012 09:15 PM, Josef Bacik wrote:
> SSD's do not gain anything by having metadata DUP turned on.  The underlying
> file system that is a part of all SSD's could easily map duplicate metadat

If I understood correctly you are stating that because an SSD *might*
"eliminates the benefit of duplicating the metadata"  mkfs.btrfs *must*
remove _silently_ this behaviour on all SSD ?

To me it seems too strong; or almost it should be documented in the man
page and/or issuing a warning during the format process.

> blocks into the same erase block which effectively eliminates the benefit of
> duplicating the metadata on disk.  So detect if we are formatting a single
> SSD drive and if we are do not use DUP.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: use blkid to get the full disk in case we happen to be formatting a
> partition.
> 
>  Makefile |    2 +-
>  mkfs.c   |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 52 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 9694444..d827216 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -65,7 +65,7 @@ btrfsck: $(objects) btrfsck.o
>  	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
>  
>  mkfs.btrfs: $(objects) mkfs.o
> -	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
> +	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
>  
>  btrfs-debug-tree: $(objects) debug-tree.o
>  	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
> diff --git a/mkfs.c b/mkfs.c
> index dff5eb8..fc2b6ed 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -37,6 +37,7 @@
>  #include <linux/fs.h>
>  #include <ctype.h>
>  #include <attr/xattr.h>
> +#include <blkid/blkid.h>
>  #include "kerncompat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -234,7 +235,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
>  static int create_raid_groups(struct btrfs_trans_handle *trans,
>  			      struct btrfs_root *root, u64 data_profile,
>  			      int data_profile_opt, u64 metadata_profile,
> -			      int metadata_profile_opt, int mixed)
> +			      int metadata_profile_opt, int mixed, int ssd)
>  {
>  	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
>  	u64 allowed;
> @@ -246,7 +247,7 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
>  	 */
>  	if (!metadata_profile_opt && !mixed) {

Please put something like

+		if(ssd)
+		    printf("SSD detected: remove the metadata duplication;");


>  		metadata_profile = (num_devices > 1) ?
> -			BTRFS_BLOCK_GROUP_RAID1 : BTRFS_BLOCK_GROUP_DUP;
> +			BTRFS_BLOCK_GROUP_RAID1 : (ssd) ? 0: BTRFS_BLOCK_GROUP_DUP;
>  	}
>  	if (!data_profile_opt && !mixed) {
>  		data_profile = (num_devices > 1) ?
> @@ -1201,6 +1202,49 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
>  	return ret;
>  }
>  
> +static int is_ssd(const char *file)
> +{
> +	char *devname;
> +	blkid_probe probe;
> +	char *dev;
> +	char path[PATH_MAX];
> +	dev_t disk;
> +	int fd;
> +	char rotational;
> +
> +	probe = blkid_new_probe_from_filename(file);
> +	if (!probe)
> +		return 0;
> +
> +	/*
> +	 * We want to use blkid_devno_to_wholedisk() but it's broken for some
> +	 * reason on F17 at least so we'll do this trickery
> +	 */
> +	disk = blkid_probe_get_wholedisk_devno(probe);
> +	devname = blkid_devno_to_devname(disk);
> +
> +	dev = strrchr(devname, '/');
> +	dev++;
> +
> +	snprintf(path, PATH_MAX, "/sys/block/%s/queue/rotational", dev);
> +
> +	free(devname);
> +	blkid_free_probe(probe);
> +
> +	fd = open(path, O_RDONLY);
> +	if (fd < 0) {
> +		return 0;
> +	}
> +
> +	if (read(fd, &rotational, sizeof(char)) < sizeof(char)) {
> +		close(fd);
> +		return 0;
> +	}
> +	close(fd);
> +
> +	return !atoi((const char *)&rotational);
> +}
> +
>  int main(int ac, char **av)
>  {
>  	char *file;
> @@ -1227,6 +1271,7 @@ int main(int ac, char **av)
>  	int data_profile_opt = 0;
>  	int metadata_profile_opt = 0;
>  	int nodiscard = 0;
> +	int ssd = 0;
>  
>  	char *source_dir = NULL;
>  	int source_dir_set = 0;
> @@ -1352,6 +1397,9 @@ int main(int ac, char **av)
>  			exit(1);
>  		}
>  	}
> +
> +	ssd = is_ssd(file);
> +


>  	if (mixed) {
>  		if (metadata_profile != data_profile) {
>  			fprintf(stderr, "With mixed block groups data and metadata "
> @@ -1438,7 +1486,7 @@ raid_groups:
>  	if (!source_dir_set) {
>  		ret = create_raid_groups(trans, root, data_profile,
>  				 data_profile_opt, metadata_profile,
> -				 metadata_profile_opt, mixed);
> +				 metadata_profile_opt, mixed, ssd);
>  		BUG_ON(ret);
>  	}
>  

