Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.robertbuhren.de ([91.190.225.190]:57881 "EHLO
	mail.robertbuhren.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2HWIzL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 04:55:11 -0400
Message-ID: <5035EFDE.4090404@robertbuhren.de>
Date: Thu, 23 Aug 2012 10:54:54 +0200
From: Robert Buhren <robert@robertbuhren.de>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
References: <5028D57F.5090803@robertbuhren.de> <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,


thanks for the patch! Sending works. But i got some trouble on the 
receiving side.
Here's my complete test-setup:


I have two btrfs partitions:

mount | grep btrfs:

/dev/loop0 on /mnt/TEST_ROOT type btrfs 
(rw,relatime,compress=lzo,space_cache)  # default-subvolume
/dev/loop0 on /mnt/TEST_ROOT/root_volid0 type btrfs 
(rw,relatime,compress=lzo,space_cache) # subvolid= 0
/dev/loop1 on /mnt/TEST_ROOT/backup_volid0 type btrfs 
(rw,relatime,compress=lzo,space_cache)

With the patch this works now:

btrfs subvolume snapshot -r /mnt/TEST_ROOT/root_volid0/root/ 
/mnt/TEST_ROOT/root_volid0/root_snap
btrfs send /mnt/TEST_ROOT/root_volid0/root_snap > root_snap_send

But when i try to receive it on the /mnt/TEST_ROOT/backup_volid0 btrfs 
partition i get:

btrfs receive -f root_snap_send /mnt/TEST_ROOT/backup_volid0/
     ERROR: utimes  failed. Bad file descriptor

i also tried  "cat root_snap_send | btrfs receive 
/mnt/TEST_ROOT/backup_volid0". But the result is the same.
What's interesting is that there is actually a subvolume "root_snap" 
created in "backup_volid0", but it's empty.

I'm on linux-3.6-rc2 and btrfs-progs from git.

If further Information is needed, just tell me.


Regards,

Robert






On 20.08.2012 13:57, Jan Schmidt wrote:
> Hi Robert,
>
> i made a quick patch, can you please give it a try? Can be applied with
> "git am --scissors".
>
> Thanks,
> -Jan
>
> -- >8 --
>
> find_mount_root had the problem that it tried to conclude from a file system
> path to a mount point, taking the fsid as an indicator. This only works if
> no two subvolumes (sharing the same btrfs fsid) are mounted in the same
> hierarchy.
>
> Now instead, we're parsing /etc/mtab and look for the longest match.
>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>   cmds-send.c |   88 ++++++++++++++---------------------------------------------
>   1 files changed, 21 insertions(+), 67 deletions(-)
>
> diff --git a/cmds-send.c b/cmds-send.c
> index 8a0c110..41ea523 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -28,6 +28,7 @@
>   #include <sys/types.h>
>   #include <sys/ioctl.h>
>   #include <libgen.h>
> +#include <mntent.h>
>
>   #include <uuid/uuid.h>
>
> @@ -55,82 +56,35 @@ struct btrfs_send {
>
>   int find_mount_root(const char *path, char **mount_root)
>   {
> -	int ret;
> -	char *cur;
> -	char fsid[BTRFS_FSID_SIZE];
> +	FILE *mnttab;
>   	int fd;
> -	struct stat st;
> -	char *tmp;
> -	char *dup = NULL;
> -
> -	struct btrfs_ioctl_fs_info_args args;
> +	struct mntent *ent;
> +	int len;
> +	int longest_matchlen = 0;
> +	char *longest_match = NULL;
>
>   	fd = open(path, O_RDONLY | O_NOATIME);
> -	if (fd < 0) {
> -		ret = -errno;
> -		goto out;
> -	}
> -
> -	ret = fstat(fd, &st);
> -	if (fd < 0) {
> -		ret = -errno;
> -		goto out;
> -	}
> -	if (!S_ISDIR(st.st_mode)) {
> -		ret = -ENOTDIR;
> -		goto out;
> -	}
> -
> -	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
> -	if (fd < 0) {
> -		ret = -errno;
> -		goto out;
> -	}
> -	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
> +	if (fd < 0)
> +		return -errno;
>   	close(fd);
> -	fd = -1;
>
> -	cur = strdup(path);
> -
> -	while (1) {
> -		dup = strdup(cur);
> -		tmp = dirname(dup);
> -
> -		if (!tmp)
> -			break;
> -		fd = open(tmp, O_RDONLY | O_NOATIME);
> -		if (fd < 0) {
> -			ret = -errno;
> -			goto out;
> +	mnttab = fopen("/etc/mtab", "r");
> +	while ((ent = getmntent(mnttab))) {
> +		len = strlen(ent->mnt_dir);
> +		if (strncmp(ent->mnt_dir, path, len) == 0) {
> +			/* match found */
> +			if (longest_matchlen < len) {
> +				free(longest_match);
> +				longest_matchlen = len;
> +				longest_match = strdup(ent->mnt_dir);
> +			}
>   		}
> -
> -		ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
> -		close(fd);
> -		fd = -1;
> -		if (ret < 0)
> -			break;
> -		if (memcmp(fsid, args.fsid, BTRFS_FSID_SIZE) != 0)
> -			break;
> -
> -		free(cur);
> -		cur = strdup(tmp);
> -		free(dup);
> -		dup = NULL;
> -		if (strcmp(cur, "/") == 0)
> -			break;
> -		if (strcmp(cur, ".") == 0)
> -			break;
>   	}
>
> -	ret = 0;
> -	*mount_root = realpath(cur, NULL);
> +	*mount_root = realpath(longest_match, NULL);
> +	free(longest_match);
>
> -out:
> -	if (dup)
> -		free(dup);
> -	if (fd != -1)
> -		close(fd);
> -	return ret;
> +	return 0;
>   }
>
>   static int get_root_id(struct btrfs_send *s, const char *path, u64 *root_id)


