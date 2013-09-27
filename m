Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43900 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3I0QKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 12:10:44 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r8RGAhgs026229
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 16:10:44 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8RGAggj029333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 16:10:42 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8RGAgDA023322
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 16:10:42 GMT
Message-ID: <5245ADFC.2090706@oracle.com>
Date: Sat, 28 Sep 2013 00:10:36 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: create helper function to use lblkid to
 scan for btrfs disks
References: <1380296700-7232-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1380296700-7232-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Following this patch the idea is to use lblkid to scan
  for the btrfs disks by default which means we don't
  use BTRFS_SCAN_PROC any more.
  which implies commands btrfs filesystem show and btrfs device scan will
  use lblkid to scan disks instead of current /proc/partitions
  by default.

  So now the question is, if there is any need to have option to scan
  using /proc/partitions ? and instead of removing it completely
  would we need it under a new option '-p' (in filesystem show and
  device  scan) so that user can use /proc/partitions when needed,
  I really don't know what would be that circumstance though,

  Any thoughts?

Thanks Anand



On 09/27/2013 11:45 PM, Anand Jain wrote:
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   utils.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   utils.h |  2 ++
>   2 files changed, 56 insertions(+)
>
> diff --git a/utils.c b/utils.c
> index c6022fc..ccb5199 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1914,6 +1914,57 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
>   	return 0;
>   }
>
> +int test_skip_this_disk(char *path)
> +{
> +	int fd;
> +	/* this will eliminate disks which are mounted (btrfs)
> +	 * and non-dm disk path when dm is enabled
> +	 */
> +	fd = open(path, O_RDWR|O_EXCL);
> +	if (fd < 0)
> +		return 1;
> +	close(fd);
> +	return 0;
> +}
> +
> +int btrfs_scan_lblkid(int update_kernel)
> +{
> +	int fd = -1;
> +	u64 num_devices;
> +	struct btrfs_fs_devices *tmp_devices;
> +	blkid_dev_iterate iter = NULL;
> +	blkid_dev dev = NULL;
> +	blkid_cache cache = NULL;
> +	char path[PATH_MAX];
> +
> +	if (blkid_get_cache(&cache, 0) < 0) {
> +		printf("ERROR: lblkid cache get failed\n");
> +		return 1;
> +	}
> +	blkid_probe_all(cache);
> +	iter = blkid_dev_iterate_begin(cache);
> +	blkid_dev_set_search(iter, "TYPE", "btrfs");
> +	while (blkid_dev_next(iter, &dev) == 0) {
> +		dev = blkid_verify(cache, dev);
> +		if (!dev)
> +			continue;
> +		/* if we are here its definitly a btrfs disk*/
> +		strcpy(path, blkid_dev_devname(dev));
> +		if (test_skip_this_disk(path))
> +			continue;
> +
> +		fd = open(path, O_RDONLY);
> +		btrfs_scan_one_device(fd, path, &tmp_devices,
> +				&num_devices, BTRFS_SUPER_INFO_OFFSET);
> +		close(fd);
> +		fd = -1;
> +		if (update_kernel)
> +			btrfs_register_one_device(path);
> +	}
> +	blkid_dev_iterate_end(iter);
> +	return 0;
> +}
> +
>   /*
>    * scans devs for the btrfs
>   */
> @@ -1928,6 +1979,9 @@ int scan_for_btrfs(int where, int update_kernel)
>   	case BTRFS_SCAN_DEV:
>   		ret = btrfs_scan_one_dir("/dev", update_kernel);
>   		break;
> +	case BTRFS_SCAN_LBLKID:
> +		ret = btrfs_scan_lblkid(update_kernel);
> +		break;
>   	}
>   	return ret;
>   }
> diff --git a/utils.h b/utils.h
> index e944685..0f31db7 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -28,6 +28,7 @@
>   #define BTRFS_SCAN_PROC		(1ULL << 0)
>   #define BTRFS_SCAN_DEV		(1ULL << 1)
>   #define BTRFS_SCAN_MOUNTED	(1ULL << 2)
> +#define BTRFS_SCAN_LBLKID	(1ULL << 3)
>
>   #define BTRFS_UPDATE_KERNEL	1
>
> @@ -89,5 +90,6 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
>   			   int verify);
>   int ask_user(char *question);
>   int lookup_ino_rootid(int fd, u64 *rootid);
> +int btrfs_scan_lblkid(int update_kernel);
>
>   #endif
>

