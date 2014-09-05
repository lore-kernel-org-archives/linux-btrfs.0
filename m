Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47167 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIEHLY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Sep 2014 03:11:24 -0400
Message-ID: <54096204.70508@oracle.com>
Date: Fri, 05 Sep 2014 15:11:00 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
References: <20130709202443.GJ18717@lenny.home.zabbo.net> <1373466615-30013-1-git-send-email-dsterba@suse.cz> <5408504C.1050203@oracle.com> <20140904194545.GI15881@lenny.home.zabbo.net>
In-Reply-To: <20140904194545.GI15881@lenny.home.zabbo.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




  Great! Thanks Zach for your quick patch. it works.

Anand

On 05/09/2014 03:45, Zach Brown wrote:
> On Thu, Sep 04, 2014 at 07:43:08PM +0800, Anand Jain wrote:
>>
>>
>>> +		static __thread char _str[24];
>>
>>   This patch is causing segmentation fault as it reached maximum stack
>>   depth on the sparc machine.
>
> Sigh.  I guess it was inevitable that this would fail somewhere :).
>
>> Just earlier method of malloc is better ?
>
> No. Callers having to allocate per-argument buffers was insane.
>
>>   unless we want to change the stack depth.
>
> Prooobably not.
>
> gcc still hasn't learned about registered format specifiers so we don't
> want to do that.
>
> How about just going back to the idea of using boring old macros for the
> format and args?  I kind of remember that being discussed but I don't
> remember why we didn't go that route.
>
> Something like this, anyway..
>
> (I even rememebered to fix the binaries that are mysteriously not built
> by default because reasons!  Yeah!)
>
> - z
>
>  From 3d132362f4c87b065b63cb38726a030db2277919 Mon Sep 17 00:00:00 2001
> From: Zach Brown <zab@zabbo.net>
> Date: Thu, 4 Sep 2014 12:32:00 -0700
> Subject: [PATCH] btrfs-progs: use pretty printing macros
>
> The original pretty printing code was a mess and required callers to
> allocate and free buffers for each argument.  The obvious fix would be
> to use glibc's dynamic format specifier registration, but gcc has yet to
> learn how to parse them when checking formats.  It'd spew unknown
> specifier warnings if we add a pretty printing specifier.
>
> So you'd think we'd just use macros like everyone else.  I don't
> remember the details now, but it seemed that people weren't excited by
> that. So we rolled some silly thread-local buffer for the pretty string
> for each argument.
>
> But that balloons the stack and crashes on sparc.. sure, fine.
>
> So we can go back to the dumb macros that are easy and work.
>
> Signed-off-by: Zach Brown <zab@zabbo.net>
> ---
>   btrfs-calc-size.c | 30 +++++++++++++++---------------
>   btrfs-fragments.c |  4 ++--
>   cmds-filesystem.c | 26 +++++++++++++-------------
>   cmds-scrub.c      |  4 ++--
>   mkfs.c            |  4 ++--
>   utils.c           | 35 ++++++++++++++++++++++++-----------
>   utils.h           | 18 +++++++++++-------
>   7 files changed, 69 insertions(+), 52 deletions(-)
>
> diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
> index 501111c..bea7c81 100644
> --- a/btrfs-calc-size.c
> +++ b/btrfs-calc-size.c
> @@ -324,6 +324,7 @@ static int calc_root_size(struct btrfs_root *tree_root, struct btrfs_key *key,
>   	int level;
>   	int ret = 0;
>   	int size_fail = 0;
> +	u64 avg;
>
>   	root = btrfs_read_fs_root(tree_root->fs_info, key);
>   	if (IS_ERR(root)) {
> @@ -369,14 +370,15 @@ out_print:
>   		stat.total_clusters = 1;
>   	}
>
> +	avg = stat.total_seeks ? stat.total_seek_len / stat.total_seeks : 0;
> +
>   	if (no_pretty || size_fail) {
>   		printf("\tTotal size: %Lu\n", stat.total_bytes);
>   		printf("\t\tInline data: %Lu\n", stat.total_inline);
>   		printf("\tTotal seeks: %Lu\n", stat.total_seeks);
>   		printf("\t\tForward seeks: %Lu\n", stat.forward_seeks);
>   		printf("\t\tBackward seeks: %Lu\n", stat.backward_seeks);
> -		printf("\t\tAvg seek len: %Lu\n", stat.total_seek_len /
> -		       stat.total_seeks);
> +		printf("\t\tAvg seek len: %Lu\n", avg);
>   		print_seek_histogram(&stat);
>   		printf("\tTotal clusters: %Lu\n", stat.total_clusters);
>   		printf("\t\tAvg cluster size: %Lu\n", stat.total_cluster_size /
> @@ -389,25 +391,23 @@ out_print:
>   		       (int)diff.tv_usec);
>   		printf("\tLevels: %d\n", level + 1);
>   	} else {
> -		printf("\tTotal size: %s\n", pretty_size(stat.total_bytes));
> -		printf("\t\tInline data: %s\n", pretty_size(stat.total_inline));
> +		printf("\tTotal size: "PF"\n", PA(stat.total_bytes));
> +		printf("\t\tInline data: "PF"\n", PA(stat.total_inline));
>   		printf("\tTotal seeks: %Lu\n", stat.total_seeks);
>   		printf("\t\tForward seeks: %Lu\n", stat.forward_seeks);
>   		printf("\t\tBackward seeks: %Lu\n", stat.backward_seeks);
> -		printf("\t\tAvg seek len: %s\n", stat.total_seeks ?
> -			pretty_size(stat.total_seek_len / stat.total_seeks) :
> -			pretty_size(0));
> +		printf("\t\tAvg seek len: "PF"\n", PA(avg));
>   		print_seek_histogram(&stat);
>   		printf("\tTotal clusters: %Lu\n", stat.total_clusters);
> -		printf("\t\tAvg cluster size: %s\n",
> -				pretty_size((stat.total_cluster_size /
> +		printf("\t\tAvg cluster size: "PF"\n",
> +				PA((stat.total_cluster_size /
>   						stat.total_clusters)));
> -		printf("\t\tMin cluster size: %s\n",
> -				pretty_size(stat.min_cluster_size));
> -		printf("\t\tMax cluster size: %s\n",
> -				pretty_size(stat.max_cluster_size));
> -		printf("\tTotal disk spread: %s\n",
> -				pretty_size(stat.highest_bytenr -
> +		printf("\t\tMin cluster size: "PF"\n",
> +				PA(stat.min_cluster_size));
> +		printf("\t\tMax cluster size: "PF"\n",
> +				PA(stat.max_cluster_size));
> +		printf("\tTotal disk spread: "PF"\n",
> +				PA(stat.highest_bytenr -
>   					stat.lowest_bytenr));
>   		printf("\tTotal read time: %d s %d us\n", (int)diff.tv_sec,
>   		       (int)diff.tv_usec);
> diff --git a/btrfs-fragments.c b/btrfs-fragments.c
> index d03c2c3..fd45822 100644
> --- a/btrfs-fragments.c
> +++ b/btrfs-fragments.c
> @@ -85,9 +85,9 @@ print_bg(FILE *html, char *name, u64 start, u64 len, u64 used, u64 flags,
>   {
>   	double frag = (double)areas / (len / 4096) * 2;
>
> -	fprintf(html, "<p>%s chunk starts at %lld, size is %s, %.2f%% used, "
> +	fprintf(html, "<p>%s chunk starts at %lld, size is "PF", %.2f%% used, "
>   		      "%.2f%% fragmented</p>\n", chunk_type(flags), start,
> -		      pretty_size(len), 100.0 * used / len, 100.0 * frag);
> +		      PA(len), 100.0 * used / len, 100.0 * frag);
>   	fprintf(html, "<img src=\"%s\" border=\"1\" />\n", name);
>   }
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 7e8ca95..d8b6938 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -210,11 +210,11 @@ static void print_df(struct btrfs_ioctl_space_args *sargs)
>   	struct btrfs_ioctl_space_info *sp = sargs->spaces;
>
>   	for (i = 0; i < sargs->total_spaces; i++, sp++) {
> -		printf("%s, %s: total=%s, used=%s\n",
> +		printf("%s, %s: total="PF", used="PF"\n",
>   			group_type_str(sp->flags),
>   			group_profile_str(sp->flags),
> -			pretty_size(sp->total_bytes),
> -			pretty_size(sp->used_bytes));
> +			PA(sp->total_bytes),
> +			PA(sp->used_bytes));
>   	}
>   }
>
> @@ -326,18 +326,18 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>
>
>   	total = device->total_devs;
> -	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
> +	printf(" uuid: %s\n\tTotal devices %llu FS bytes used "PF"\n", uuidbuf,
>   	       (unsigned long long)total,
> -	       pretty_size(device->super_bytes_used));
> +	       PA(device->super_bytes_used));
>
>   	list_sort(NULL, &fs_devices->devices, cmp_device_id);
>   	list_for_each(cur, &fs_devices->devices) {
>   		device = list_entry(cur, struct btrfs_device, dev_list);
>
> -		printf("\tdevid %4llu size %s used %s path %s\n",
> +		printf("\tdevid %4llu size "PF" used "PF" path %s\n",
>   		       (unsigned long long)device->devid,
> -		       pretty_size(device->total_bytes),
> -		       pretty_size(device->bytes_used), device->name);
> +		       PA(device->total_bytes),
> +		       PA(device->bytes_used), device->name);
>
>   		devs_found++;
>   	}
> @@ -382,9 +382,9 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   	else
>   		printf("Label: none ");
>
> -	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
> +	printf(" uuid: %s\n\tTotal devices %llu FS bytes used "PF"\n", uuidbuf,
>   			fs_info->num_devices,
> -			pretty_size(calc_used_bytes(space_info)));
> +			PA(calc_used_bytes(space_info)));
>
>   	for (i = 0; i < fs_info->num_devices; i++) {
>   		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
> @@ -396,10 +396,10 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   			continue;
>   		}
>   		close(fd);
> -		printf("\tdevid %4llu size %s used %s path %s\n",
> +		printf("\tdevid %4llu size "PF" used "PF" path %s\n",
>   			tmp_dev_info->devid,
> -			pretty_size(tmp_dev_info->total_bytes),
> -			pretty_size(tmp_dev_info->bytes_used),
> +			PA(tmp_dev_info->total_bytes),
> +			PA(tmp_dev_info->bytes_used),
>   			tmp_dev_info->path);
>   	}
>
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index 731c5c9..10a6692 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -151,8 +151,8 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
>   		printf("*** WARNING: memory allocation failed while scrubbing. "
>   		       "results may be inaccurate\n");
>
> -	printf("\ttotal bytes scrubbed: %s with %llu errors\n",
> -		pretty_size(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
> +	printf("\ttotal bytes scrubbed: "PF" with %llu errors\n",
> +		PA(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
>   		max(err_cnt, err_cnt2));
>
>   	if (err_cnt || err_cnt2) {
> diff --git a/mkfs.c b/mkfs.c
> index 9de61e1..d649e03 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1643,9 +1643,9 @@ raid_groups:
>   	BUG_ON(ret);
>
>   	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
> -	    "sectorsize %u size %s\n",
> +	    "sectorsize %u size "PF"\n",
>   	    label, first_file, nodesize, leafsize, sectorsize,
> -	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
> +	    PA(btrfs_super_total_bytes(root->fs_info->super_copy)));
>
>   	btrfs_commit_transaction(trans, root);
>
> diff --git a/utils.c b/utils.c
> index 6c09366..0064587 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -709,8 +709,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
>   		 * optimization.
>   		 */
>   		if (discard_range(fd, 0, 0) == 0) {
> -			fprintf(stderr, "Performing full device TRIM (%s) ...\n",
> -				pretty_size(block_count));
> +			fprintf(stderr, "Performing full device TRIM ("PF") ...\n",
> +				PA(block_count));
>   			discard_blocks(fd, 0, block_count);
>   		}
>   	}
> @@ -1376,22 +1376,21 @@ out:
>   	return ret;
>   }
>
> -static char *size_strs[] = { "", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
> -int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
> +static float pretty_calc(u64 size, char **str)
>   {
>   	int num_divs = 0;
>   	float fraction;
> +	static char *size_strs[] = {
> +		"", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB",
> +	};
>
> -	if (str_bytes == 0)
> -		return 0;
> -
> -	if( size < 1024 ){
> +	if (size < 1024) {
>   		fraction = size;
>   		num_divs = 0;
>   	} else {
>   		u64 last_size = size;
>   		num_divs = 0;
> -		while(size >= 1024){
> +		while (size >= 1024) {
>   			last_size = size;
>   			size /= 1024;
>   			num_divs ++;
> @@ -1403,8 +1402,22 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
>   		}
>   		fraction = (float)last_size / 1024;
>   	}
> -	return snprintf(str, str_bytes, "%.2f%s", fraction,
> -			size_strs[num_divs]);
> +
> +	*str = size_strs[num_divs];
> +	return fraction;
> +}
> +
> +float pretty_float(u64 size)
> +{
> +	char *str;
> +	return pretty_calc(size, &str);
> +}
> +
> +char *pretty_suffix(u64 size)
> +{
> +	char *str;
> +	pretty_calc(size, &str);
> +	return str;
>   }
>
>   /*
> diff --git a/utils.h b/utils.h
> index fd25126..26c767b 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -71,13 +71,17 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>   int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>   				 int super_offset);
>
> -int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
> -#define pretty_size(size) 						\
> -	({								\
> -		static __thread char _str[24];				\
> -		(void)pretty_size_snprintf((size), _str, sizeof(_str));	\
> -		_str;							\
> -	})
> +/*
> + * It's annoying that gcc hasn't yet figured out how to learn about
> + * formats added by register_printf_specifier().  If that were the case
> + * we could just add some %P type and be done with it.  Some day..
> + *
> + *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=47781
> + */
> +float pretty_float(u64 size);
> +char *pretty_suffix(u64 size);
> +#define PF "%.2f%s"
> +#define PA(x) pretty_float(x), pretty_suffix(x)
>
>   int get_mountpt(char *dev, char *mntpt, size_t size);
>   int btrfs_scan_block_devices(int run_ioctl);
>
