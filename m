Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65312 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3CKUs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:48:27 -0400
Received: by mail-ob0-f177.google.com with SMTP id eh20so3821283obb.36
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 13:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130311101242.GA18346@gmail.com>
References: <20130311101242.GA18346@gmail.com>
Date: Mon, 11 Mar 2013 20:48:25 +0000
Message-ID: <CAMU1PDiwXNhK8zRts_2ZWWtU-gx+XAwYP4KuJ3NjOxQDz-+qgQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: add options for changing size representations
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 March 2013 10:12, Audrius Butkevicius
<audrius.butkevicius@elastichosts.com> wrote:
> Add '--si', '-h'/'--human-readable' and '--block-size' global options,
> which allow users to customize the way sizes are displayed.
>
> Options and their format tries to mimic GNU ls utility.
>
> Signed-off-by: Audrius Butkevicius <audrius.butkevicius@elastichosts.com>
> ---
>  btrfs.c |    3 ++
>  utils.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  utils.h |    6 +++
>  3 files changed, 138 insertions(+), 17 deletions(-)
>
> diff --git a/btrfs.c b/btrfs.c
> index 691adef..6a8fc30 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -22,6 +22,8 @@
>  #include "crc32c.h"
>  #include "commands.h"
>  #include "version.h"
> +#include "ctree.h"
> +#include "utils.h"
>
>  static const char * const btrfs_cmd_group_usage[] = {
>         "btrfs [--help] [--version] <group> [<group>...] <command> [<args>]",
> @@ -291,6 +293,7 @@ int main(int argc, char **argv)
>
>         crc32c_optimization_init();
>
> +       handle_size_unit_args(&argc, &argv);
>         fixup_argv0(argv, cmd->token);
>         exit(cmd->fn(argc, argv));
>  }
> diff --git a/utils.c b/utils.c
> index d660507..58c1919 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -16,6 +16,7 @@
>   * Boston, MA 021110-1307, USA.
>   */
>
> +#define _GNU_SOURCE
>  #define _XOPEN_SOURCE 700
>  #define __USE_XOPEN2K8
>  #define __XOPEN2K8 /* due to an error in dirent.h, to get dirfd() */
> @@ -1095,33 +1096,144 @@ out:
>         return ret;
>  }
>
> -static char *size_strs[] = { "", "KB", "MB", "GB", "TB",
> -                           "PB", "EB", "ZB", "YB"};
> +static int sizes_format = SIZES_FORMAT_BYTES;
> +static u64 sizes_divisor = 1;
> +
> +void remove_arg(int i, int *argc, char ***argv)
> +{
> +       while (i++ < *argc)
> +               (*argv)[i - 1] = (*argv)[i];
> +       (*argc)--;
> +}
> +
> +void handle_size_unit_args(int *argc, char ***argv)
> +{
> +       int k;
> +       int base = 1024;
> +       char *suffix;
> +       char *block_size;
> +       u64 value;
> +
> +       for (k = *argc - 1; k >= 0; k--) {
> +                if (!strcmp((*argv)[k], "-h") ||
> +                    !strcmp((*argv)[k], "--human-readable")) {
> +                       sizes_format = SIZES_FORMAT_HUMAN;
> +                       remove_arg(k, argc, argv);
> +                } else if (!strcmp((*argv)[k], "--si")) {
> +                       sizes_format = SIZES_FORMAT_SI;
> +                       remove_arg(k, argc, argv);
> +                } else if (!strncmp((*argv)[k], "--block-size", 12)) {
> +                       if (strlen((*argv)[k]) < 14 || (*argv)[k][12] != '=') {
> +                               fprintf(stderr,
> +                                        "--block-size requires an argument\n");
> +                               exit(1);
> +                       }
> +
> +                       sizes_format = SIZES_FORMAT_BLOCK;
> +                       block_size = strchr((*argv)[k], '=');
> +
> +                       errno = 0;
> +                       value = strtoull(++block_size, &suffix, 10);
> +                       if (errno == ERANGE && value == ULLONG_MAX) {
> +                               fprintf(stderr,
> +                                        "--block-size argument '%s' too large\n",
> +                                        block_size);
> +                               exit(1);
> +                       }
> +                       if (suffix == block_size)
> +                               value = 1;
> +
> +                       if (strlen(suffix) == 1 && value > 0) {
> +                               base = 1024;
> +                       } else if (strlen(suffix) == 2 && suffix[1] == 'B'
> +                                   && value > 0) {
> +                               base = 1000;
> +                       /* Allow non-zero values without a suffix */
> +                       } else if (strlen(suffix) != 0 || value == 0) {
> +                               fprintf(stderr,
> +                                        "invalid --block-size argument '%s'\n",
> +                                        block_size);
> +                               exit(1);
> +                       }
> +
> +                       if (strlen(suffix) > 0) {
> +                               switch(suffix[0]) {
> +                                       case 'E':
> +                                               sizes_divisor *= base;
> +                                       case 'P':
> +                                               sizes_divisor *= base;
> +                                       case 'T':
> +                                               sizes_divisor *= base;
> +                                       case 'G':
> +                                               sizes_divisor *= base;
> +                                       case 'M':
> +                                               sizes_divisor *= base;
> +                                       case 'K':
> +                                               sizes_divisor *= base;
> +                                               break;
> +                                       default:
> +                                               fprintf(stderr,
> +                                                        "invalid --block-size \
> +argument '%s'\n",
> +                                                        block_size);
> +                                               exit(1);
> +                               }
> +                       }
> +
> +                       if (ULLONG_MAX / sizes_divisor < value) {
> +                               fprintf(stderr,
> +                                        "--block-size argument '%s' too large\n",
> +                                        block_size);
> +                               exit(1);
> +                       }
> +
> +                       if (suffix != block_size)
> +                               sizes_divisor *= value;
> +
> +                       remove_arg(k, argc, argv);
> +               }
> +       }
> +}
> +
> +static char *size_strs[] = { "", "K", "M", "G", "T", "P", "E"};
>  char *pretty_sizes(u64 size)
>  {
>         int num_divs = 0;
> -        int pretty_len = 16;
> +       int sizes_base = 1024;
>         float fraction;
>         char *pretty;
> -
> -       if( size < 1024 ){
> -               fraction = size;
> -               num_divs = 0;
> +       char *sizes_suffix = "iB";
> +       u64 last_size;
> +
> +       if (sizes_format == SIZES_FORMAT_BYTES) {
> +               asprintf(&pretty, "%llu", (unsigned long long)size);
> +       } else if (sizes_format == SIZES_FORMAT_BLOCK) {
> +               fraction = (float)size / sizes_divisor;
> +               asprintf(&pretty, "%.2f", fraction);
>         } else {
> -               u64 last_size = size;
> -               num_divs = 0;
> -               while(size >= 1024){
> +               if (sizes_format == SIZES_FORMAT_SI) {
> +                       sizes_base = 1000;
> +                       sizes_suffix = "B";
> +               }
> +
> +               if (size < sizes_base) {
> +                       fraction = size;
> +               } else {
>                         last_size = size;
> -                       size /= 1024;
> -                       num_divs ++;
> +                       while (size >= sizes_base) {
> +                               last_size = size;
> +                               size /= 1024;
> +                               num_divs++;
> +                       }
> +
> +                       if (num_divs > ARRAY_SIZE(size_strs))
> +                               return NULL;
> +                       fraction = (float)last_size / sizes_base;
>                 }
>
> -               if (num_divs >= ARRAY_SIZE(size_strs))
> -                       return NULL;
> -               fraction = (float)last_size / 1024;
> +               asprintf(&pretty, "%.2f%s%s", fraction, size_strs[num_divs],
> +                         sizes_suffix);
>         }
> -       pretty = malloc(pretty_len);
> -       snprintf(pretty, pretty_len, "%.2f%s", fraction, size_strs[num_divs]);
>         return pretty;
>  }
>
> diff --git a/utils.h b/utils.h
> index 60a0fea..56d7950 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -23,6 +23,11 @@
>
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
>
> +#define SIZES_FORMAT_BYTES 0
> +#define SIZES_FORMAT_HUMAN 1
> +#define SIZES_FORMAT_SI 2
> +#define SIZES_FORMAT_BLOCK 3
> +
>  int make_btrfs(int fd, const char *device, const char *label,
>                u64 blocks[6], u64 num_bytes, u32 nodesize,
>                u32 leafsize, u32 sectorsize, u32 stripesize);
> @@ -44,6 +49,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>                                  int super_offset);
>  char *pretty_sizes(u64 size);
> +void handle_size_unit_args(int *argc, char ***argv);
>  int check_label(char *input);
>  int get_mountpt(char *dev, char *mntpt, size_t size);
>  int btrfs_scan_block_devices(int run_ioctl);
> --
> 1.7.10.4

(This time reply all)

General concept seems OK to me, but I think there are a few issues with
the implementation ...

Btrfs program has an established default of using human units for
figures, but this patch changes to reporting figures in bytes.

--block-size=K|M|G|... doesn't append the number with unit multiplier
as would be expected.

The new options should be documented in the manual page.

The new options should be documented in the program help output.

Thanks,
Mike
