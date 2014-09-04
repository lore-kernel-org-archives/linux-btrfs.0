Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46198 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaIDLjT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Sep 2014 07:39:19 -0400
Message-ID: <5408504C.1050203@oracle.com>
Date: Thu, 04 Sep 2014 19:43:08 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
CC: zab@redhat.com, wangshilong1991@gmail.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
References: <20130709202443.GJ18717@lenny.home.zabbo.net> <1373466615-30013-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1373466615-30013-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



 > +		static __thread char _str[24];

  This patch is causing segmentation fault as it reached maximum stack
  depth on the sparc machine. Just earlier method of malloc is better ?
  unless we want to change the stack depth.  Any comments ?

Thanks, Anand


On 07/10/2013 10:30 PM, David Sterba wrote:
> From: Zach Brown <zab@redhat.com>
>
> From: Zach Brown <zab@redhat.com>
>
> We don't need callers to manage string storage for each pretty_sizes()
> call.  We can use a macro to have per-thread and per-call static storage
> so that pretty_sizes() can be used as many times as needed in printf()
> arguments without requiring a bunch of supporting variables.
>
> This lets us have a natural interface at the cost of requiring __thread
> and TLS from gcc and a small amount of static storage.  This seems
> better than the current code or doing something with illegible format
> specifier macros.
>
> Signed-off-by: Zach Brown <zab@redhat.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>
> I've updated the rest of pretty_size callers in targets that were not built by
> default.
>
>   btrfs-calc-size.c | 13 +++----------
>   btrfs-fragments.c |  2 +-
>   cmds-filesystem.c | 27 +++++++++------------------
>   cmds-scrub.c      |  8 ++++----
>   mkfs.c            |  4 +---
>   utils.c           | 19 ++++++++++---------
>   utils.h           | 10 +++++++++-
>   7 files changed, 37 insertions(+), 46 deletions(-)
>
> diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
> index c4adfb0..5aa0b70 100644
> --- a/btrfs-calc-size.c
> +++ b/btrfs-calc-size.c
> @@ -162,18 +162,11 @@ out_print:
>   		       stat.total_inline, stat.total_nodes, stat.total_leaves,
>   		       level + 1);
>   	} else {
> -		char *total_size;
> -		char *inline_size;
> -
> -		total_size = pretty_sizes(stat.total_bytes);
> -		inline_size = pretty_sizes(stat.total_inline);
> -
>   		printf("\t%s total size, %s inline data, %Lu nodes, "
>   		       "%Lu leaves, %d levels\n",
> -		       total_size, inline_size, stat.total_nodes,
> -		       stat.total_leaves, level + 1);
> -		free(total_size);
> -		free(inline_size);
> +		       pretty_size(stat.total_bytes),
> +		       pretty_size(stat.total_inline),
> +		       stat.total_nodes, stat.total_leaves, level + 1);
>   	}
>   out:
>   	btrfs_free_path(path);
> diff --git a/btrfs-fragments.c b/btrfs-fragments.c
> index a012fe1..7ec77e7 100644
> --- a/btrfs-fragments.c
> +++ b/btrfs-fragments.c
> @@ -87,7 +87,7 @@ print_bg(FILE *html, char *name, u64 start, u64 len, u64 used, u64 flags,
>
>   	fprintf(html, "<p>%s chunk starts at %lld, size is %s, %.2f%% used, "
>   		      "%.2f%% fragmented</p>\n", chunk_type(flags), start,
> -		      pretty_sizes(len), 100.0 * used / len, 100.0 * frag);
> +		      pretty_size(len), 100.0 * used / len, 100.0 * frag);
>   	fprintf(html, "<img src=\"%s\" border=\"1\" />\n", name);
>   }
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index f41a72a..222e458 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -111,8 +111,6 @@ static int cmd_df(int argc, char **argv)
>
>   	for (i = 0; i < sargs->total_spaces; i++) {
>   		char description[80];
> -		char *total_bytes;
> -		char *used_bytes;
>   		int written = 0;
>   		u64 flags = sargs->spaces[i].flags;
>
> @@ -155,10 +153,9 @@ static int cmd_df(int argc, char **argv)
>   			written += 7;
>   		}
>
> -		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
> -		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
> -		printf("%s: total=%s, used=%s\n", description, total_bytes,
> -		       used_bytes);
> +		printf("%s: total=%s, used=%s\n", description,
> +			pretty_size(sargs->spaces[i].total_bytes),
> +			pretty_size(sargs->spaces[i].used_bytes));
>   	}
>   	close(fd);
>   	free(sargs);
> @@ -192,7 +189,6 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>   	char uuidbuf[37];
>   	struct list_head *cur;
>   	struct btrfs_device *device;
> -	char *super_bytes_used;
>   	u64 devs_found = 0;
>   	u64 total;
>
> @@ -204,25 +200,20 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>   	else
>   		printf("Label: none ");
>
> -	super_bytes_used = pretty_sizes(device->super_bytes_used);
>
>   	total = device->total_devs;
>   	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
> -	       (unsigned long long)total, super_bytes_used);
> -
> -	free(super_bytes_used);
> +	       (unsigned long long)total,
> +	       pretty_size(device->super_bytes_used));
>
>   	list_for_each(cur, &fs_devices->devices) {
> -		char *total_bytes;
> -		char *bytes_used;
>   		device = list_entry(cur, struct btrfs_device, dev_list);
> -		total_bytes = pretty_sizes(device->total_bytes);
> -		bytes_used = pretty_sizes(device->bytes_used);
> +
>   		printf("\tdevid %4llu size %s used %s path %s\n",
>   		       (unsigned long long)device->devid,
> -		       total_bytes, bytes_used, device->name);
> -		free(total_bytes);
> -		free(bytes_used);
> +		       pretty_size(device->total_bytes),
> +		       pretty_size(device->bytes_used), device->name);
> +
>   		devs_found++;
>   	}
>   	if (devs_found < total) {
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index 95dfee3..bf50650 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -139,7 +139,6 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
>   {
>   	u64 err_cnt;
>   	u64 err_cnt2;
> -	char *bytes;
>
>   	err_cnt = p->read_errors +
>   			p->csum_errors +
> @@ -151,10 +150,11 @@ static void print_scrub_summary(struct btrfs_scrub_progress *p)
>   	if (p->malloc_errors)
>   		printf("*** WARNING: memory allocation failed while scrubbing. "
>   		       "results may be inaccurate\n");
> -	bytes = pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed);
> -	printf("\ttotal bytes scrubbed: %s with %llu errors\n", bytes,
> +
> +	printf("\ttotal bytes scrubbed: %s with %llu errors\n",
> +		pretty_size(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
>   		max(err_cnt, err_cnt2));
> -	free(bytes);
> +
>   	if (err_cnt || err_cnt2) {
>   		printf("\terror details:");
>   		PRINT_SCRUB_ERROR(p->read_errors, "read");
> diff --git a/mkfs.c b/mkfs.c
> index 95fceb3..ade85c7 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1356,7 +1356,6 @@ int main(int ac, char **av)
>   	u64 num_of_meta_chunks = 0;
>   	u64 size_of_data = 0;
>   	u64 source_dir_size = 0;
> -	char *pretty_buf;
>   	struct btrfs_super_block *super;
>   	u64 flags;
>   	int dev_cnt = 0;
> @@ -1629,8 +1628,7 @@ raid_groups:
>   	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
>   	    "sectorsize %u size %s\n",
>   	    label, first_file, nodesize, leafsize, sectorsize,
> -	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
> -	free(pretty_buf);
> +	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
>
>   	printf("%s\n", BTRFS_BUILD_VERSION);
>   	btrfs_commit_transaction(trans, root);
> diff --git a/utils.c b/utils.c
> index 1eeda0f..ced85aa 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1152,13 +1152,14 @@ out:
>   }
>
>   static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
> -			    "PB", "EB", "ZB", "YB"};
> -char *pretty_sizes(u64 size)
> +			    "PB", "EB"};
> +void pretty_size_snprintf(u64 size, char *str, size_t str_bytes)
>   {
>   	int num_divs = 0;
> -        int pretty_len = 16;
>   	float fraction;
> -	char *pretty;
> +
> +	if (str_bytes == 0)
> +		return;
>
>   	if( size < 1024 ){
>   		fraction = size;
> @@ -1172,13 +1173,13 @@ char *pretty_sizes(u64 size)
>   			num_divs ++;
>   		}
>
> -		if (num_divs >= ARRAY_SIZE(size_strs))
> -			return NULL;
> +		if (num_divs >= ARRAY_SIZE(size_strs)) {
> +			str[0] = '\0';
> +			return;
> +		}
>   		fraction = (float)last_size / 1024;
>   	}
> -	pretty = malloc(pretty_len);
> -	snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
> -	return pretty;
> +	snprintf(str, str_bytes, "%.2f%s", fraction, size_strs[num_divs]);
>   }
>
>   /*
> diff --git a/utils.h b/utils.h
> index 3c17e14..36fb591 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -44,7 +44,15 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>   			struct btrfs_fs_devices **fs_devices_mnt);
>   int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>   				 int super_offset);
> -char *pretty_sizes(u64 size);
> +
> +void pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
> +#define pretty_size(size) 						\
> +	({								\
> +		static __thread char _str[24];				\
> +		pretty_size_snprintf((size), _str, sizeof(_str));	\
> +		_str;							\
> +	})
> +
>   int get_mountpt(char *dev, char *mntpt, size_t size);
>   int btrfs_scan_block_devices(int run_ioctl);
>   u64 parse_size(char *s);
>
