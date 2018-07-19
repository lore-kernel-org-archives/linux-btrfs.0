Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26870 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbeGSGki (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 02:40:38 -0400
Date: Thu, 19 Jul 2018 13:59:04 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: ins: Add v2 ioctl support in logical-resolve
Message-ID: <20180719055904.GK575@fnst.localdomain>
References: <fe355417-0516-b27f-1114-a3777916fb87@jp.fujitsu.com>
 <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <3ed9676f-13e1-3072-5d2c-9b9e10fd36e5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 01:51:59PM +0800, Qu Wenruo wrote:
>
>
>On 2018年07月19日 13:15, Misono Tomohiro wrote:
>> Add -i (ignore offset) option to logical-resolve command
>> to show how BTRFS_IOC_LOGICAL_INO_V2 ioctl works
>> (returns every ref to the extent of given logical address).
>> 
>> [Example]
>> $ mkfs.btrfs -f $DEV
>> $ mount $DEV /mnt
>> 
>> $ dd if=/dev/urandom of=/mnt/file bs=4k count=100
>> # split above extent
>> $ dd if=/dev/urandom of=/mnt/file bs=4k seek=10 count=1 conv=notrunc
>> $ btrfs filesystem sync
>> 
>> # v1
>> $ btrfs inspect-internal logical-resolve -P 13631488 /mnt
>> inode 257 offset 0 root 5
>> 
>> # v2
>> $ btrfs inspect-internal logical-resolve -iP 13631488 /mnt
>> inode 257 offset 0 root 5
>> inode 257 offset 45056 root 5
>> 
>> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>> ---
>>  Documentation/btrfs-inspect-internal.asciidoc |  4 ++++
>>  cmds-inspect.c                                | 17 +++++++++++++++--
>>  ioctl.h                                       | 10 +++++++++-
>>  libbtrfsutil/btrfs.h                          | 10 +++++++++-
>
>Not related to this patch itself, but I'm wondering could we just use
>/usr/include/linux/btrfs.h?
>
>So we could save 2 same copies of headers here.

If we want to compile the newest btrfs-progs, but the older
/usr/include/linux/btrfs.h maybe doesn't have already defined the ioctl,
this will cause the compile error. I am curious about why the
libbtrfsutil need to copy the part of ioctl.h instead of including the
ioctl.h directly?

-- 
Thanks,
Lu

>
>Thanks,
>Qu
>
>>  4 files changed, 37 insertions(+), 4 deletions(-)
>> 
>> diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
>> index e2db6466..a55c9add 100644
>> --- a/Documentation/btrfs-inspect-internal.asciidoc
>> +++ b/Documentation/btrfs-inspect-internal.asciidoc
>> @@ -125,6 +125,10 @@ skip the path resolving and print the inodes instead
>>  verbose mode, print count of returned paths and all ioctl() return values
>>  -s <bufsize>::::
>>  set internal buffer for storing the file names to 'bufsize', default is 4096, maximum 64k
>> +-i::::
>> +ignore offset and return all the ref information
>> +which points to the extent containing given logical address.
>> +This requires version 2 ioctl support (BTRFS_IOC_LOGICAL_INO_V2, since 4.15).
>>  
>>  *min-dev-size* [options] <path>::
>>  (needs root privileges)
>> diff --git a/cmds-inspect.c b/cmds-inspect.c
>> index 2fc50c1a..d47eeacb 100644
>> --- a/cmds-inspect.c
>> +++ b/cmds-inspect.c
>> @@ -131,6 +131,9 @@ static const char * const cmd_inspect_logical_resolve_usage[] = {
>>  	"-s bufsize  set inode container's size. This is used to increase inode",
>>  	"            container's size in case it is not enough to read all the ",
>>  	"            resolved results. The max value one can set is 64k",
>> +	"-i          ignore offset and return all the ref information",
>> +	"            which points to the extent containing given logical address",
>> +	"            (requires version 2 ioctl support)",
>>  	NULL
>>  };
>>  
>> @@ -142,7 +145,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
>>  	int verbose = 0;
>>  	int getpath = 1;
>>  	int bytes_left;
>> +	int ignore_offset = 0;
>>  	struct btrfs_ioctl_logical_ino_args loi;
>> +	unsigned long ioctl_num = BTRFS_IOC_LOGICAL_INO;
>>  	struct btrfs_data_container *inodes;
>>  	u64 size = 4096;
>>  	char full_path[PATH_MAX];
>> @@ -151,7 +156,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
>>  
>>  	optind = 0;
>>  	while (1) {
>> -		int c = getopt(argc, argv, "Pvs:");
>> +		int c = getopt(argc, argv, "Pvs:i");
>>  		if (c < 0)
>>  			break;
>>  
>> @@ -165,6 +170,9 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
>>  		case 's':
>>  			size = arg_strtou64(optarg);
>>  			break;
>> +		case 'i':
>> +			ignore_offset = 1;
>> +			break;
>>  		default:
>>  			usage(cmd_inspect_logical_resolve_usage);
>>  		}
>> @@ -183,13 +191,18 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
>>  	loi.size = size;
>>  	loi.inodes = ptr_to_u64(inodes);
>>  
>> +	if (ignore_offset) {
>> +		loi.flags = BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
>> +		ioctl_num = BTRFS_IOC_LOGICAL_INO_V2;
>> +	}
>> +
>>  	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
>>  	if (fd < 0) {
>>  		ret = 12;
>>  		goto out;
>>  	}
>>  
>> -	ret = ioctl(fd, BTRFS_IOC_LOGICAL_INO, &loi);
>> +	ret = ioctl(fd, ioctl_num, &loi);
>>  	if (ret < 0) {
>>  		error("logical ino ioctl: %m");
>>  		goto out;
>> diff --git a/ioctl.h b/ioctl.h
>> index 709e996f..74f30c20 100644
>> --- a/ioctl.h
>> +++ b/ioctl.h
>> @@ -491,10 +491,16 @@ BUILD_ASSERT(sizeof(struct btrfs_ioctl_ino_path_args) == 56);
>>  struct btrfs_ioctl_logical_ino_args {
>>  	__u64				logical;	/* in */
>>  	__u64				size;		/* in */
>> -	__u64				reserved[4];
>> +	__u64				reserved[3];	/* must be 0 for now */
>> +	__u64				flags;		/* in, v2 only */
>>  	/* struct btrfs_data_container	*inodes;	out   */
>>  	__u64				inodes;
>>  };
>> +/*
>> + * Return every ref to the extent, not just those containing logical block.
>> + * Requires logical == extent bytenr.
>> + */
>> +#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
>>  
>>  enum btrfs_dev_stat_values {
>>  	/* disk I/O failure stats */
>> @@ -828,6 +834,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>>                                    struct btrfs_ioctl_feature_flags[3])
>>  #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
>>  				   struct btrfs_ioctl_vol_args_v2)
>> +#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>> +					struct btrfs_ioctl_logical_ino_args)
>>  #ifdef __cplusplus
>>  }
>>  #endif
>> diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
>> index c293f6bf..b4debba7 100644
>> --- a/libbtrfsutil/btrfs.h
>> +++ b/libbtrfsutil/btrfs.h
>> @@ -609,10 +609,16 @@ struct btrfs_ioctl_ino_path_args {
>>  struct btrfs_ioctl_logical_ino_args {
>>  	__u64				logical;	/* in */
>>  	__u64				size;		/* in */
>> -	__u64				reserved[4];
>> +	__u64				reserved[3];	/* must be 0 for now */
>> +	__u64				flags;		/* in, v2 only */
>>  	/* struct btrfs_data_container	*inodes;	out   */
>>  	__u64				inodes;
>>  };
>> +/*
>> + * Return every ref to the extent, not just those containing logical block.
>> + * Requires logical == extent bytenr.
>> + */
>> +#define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
>>  
>>  enum btrfs_dev_stat_values {
>>  	/* disk I/O failure stats */
>> @@ -836,5 +842,7 @@ enum btrfs_err_code {
>>  				   struct btrfs_ioctl_feature_flags[3])
>>  #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
>>  				   struct btrfs_ioctl_vol_args_v2)
>> +#define BTRFS_IOC_LOGICAL_INO_V2 _IOWR(BTRFS_IOCTL_MAGIC, 59, \
>> +					struct btrfs_ioctl_logical_ino_args)
>>  
>>  #endif /* _LINUX_BTRFS_H */
>> 
>


