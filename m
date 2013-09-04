Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60068 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934851Ab3IDQ02 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Sep 2013 12:26:28 -0400
Received: by mail-wg0-f51.google.com with SMTP id a12so583087wgh.6
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Sep 2013 09:26:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378308157-4621-19-git-send-email-wangshilong1991@gmail.com>
References: <1378308157-4621-1-git-send-email-wangshilong1991@gmail.com>
	<1378308157-4621-19-git-send-email-wangshilong1991@gmail.com>
Date: Wed, 4 Sep 2013 19:26:27 +0300
Message-ID: <CAOi1vP-m3drMT7Ljj7MZmHK+qOCfVfaSD4OYC3RQ8mobOUup8A@mail.gmail.com>
Subject: Re: [PATCH 18/20] Btrfs-progs: fix magic return value in cmds-balance.c
From: Ilya Dryomov <idryomov@gmail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,

Thank you for doing the grunt work, it's been a long standing todo.
See the comments below.

On Wed, Sep 4, 2013 at 6:22 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> If there is no balance in progress.resume/pause/cancel will
> return 2. For usage or syntal errors will return 1. 0 means
> operations return successfully.

This needs to be reworded (spelling, punctuation).

>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  cmds-balance.c | 93 ++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 58 insertions(+), 35 deletions(-)
>
> diff --git a/cmds-balance.c b/cmds-balance.c
> index b7382ef..fd68051 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -58,7 +58,7 @@ static int parse_one_profile(const char *profile, u64 *flags)
>                 *flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
>         } else {
>                 fprintf(stderr, "Unknown profile '%s'\n", profile);
> -               return 1;
> +               return -ENOENT;
>         }
>
>         return 0;
> @@ -68,12 +68,14 @@ static int parse_profiles(char *profiles, u64 *flags)
>  {
>         char *this_char;
>         char *save_ptr = NULL; /* Satisfy static checkers */
> +       int ret;
>
>         for (this_char = strtok_r(profiles, "|", &save_ptr);
>              this_char != NULL;
>              this_char = strtok_r(NULL, "|", &save_ptr)) {
> -               if (parse_one_profile(this_char, flags))
> -                       return 1;
> +               ret = parse_one_profile(this_char, flags);
> +               if (ret)
> +                       return ret;
>         }
>
>         return 0;
> @@ -86,7 +88,7 @@ static int parse_u64(const char *str, u64 *result)
>
>         val = strtoull(str, &endptr, 10);
>         if (*endptr)
> -               return 1;
> +               return -EINVAL;
>
>         *result = val;
>         return 0;
> @@ -95,6 +97,7 @@ static int parse_u64(const char *str, u64 *result)
>  static int parse_range(const char *range, u64 *start, u64 *end)
>  {
>         char *dots;
> +       int ret;
>
>         dots = strstr(range, "..");
>         if (dots) {
> @@ -107,29 +110,31 @@ static int parse_range(const char *range, u64 *start, u64 *end)
>                         *end = (u64)-1;
>                         skipped++;
>                 } else {
> -                       if (parse_u64(rest, end))
> -                               return 1;
> +                       ret = parse_u64(rest, end);
> +                       if (ret)
> +                               return ret;
>                 }
>                 if (dots == range) {
>                         *start = 0;
>                         skipped++;
>                 } else {
> +                       ret = parse_u64(rest, end);
>                         if (parse_u64(range, start))
> -                               return 1;
> +                               return ret;
>                 }
>
>                 if (*start >= *end) {
>                         fprintf(stderr, "Range %llu..%llu doesn't make "
>                                 "sense\n", (unsigned long long)*start,
>                                 (unsigned long long)*end);
> -                       return 1;
> +                       return -EINVAL;
>                 }
>
>                 if (skipped <= 1)
>                         return 0;
>         }
>
> -       return 1;
> +       return -EINVAL;
>  }
>
>  static int parse_filters(char *filters, struct btrfs_balance_args *args)
> @@ -137,6 +142,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
>         char *this_char;
>         char *value;
>         char *save_ptr = NULL; /* Satisfy static checkers */
> +       int ret = 0;
>
>         if (!filters)
>                 return 0;
> @@ -150,70 +156,72 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the profiles filter requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         if (parse_profiles(value, &args->profiles)) {
>                                 fprintf(stderr, "Invalid profiles argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_PROFILES;
>                 } else if (!strcmp(this_char, "usage")) {
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the usage filter requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         if (parse_u64(value, &args->usage) ||
>                             args->usage > 100) {
>                                 fprintf(stderr, "Invalid usage argument: %s\n",
>                                        value);
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_USAGE;
>                 } else if (!strcmp(this_char, "devid")) {
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the devid filter requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         if (parse_u64(value, &args->devid) ||
>                             args->devid == 0) {
>                                 fprintf(stderr, "Invalid devid argument: %s\n",
>                                        value);
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_DEVID;
>                 } else if (!strcmp(this_char, "drange")) {
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the drange filter requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
> -                       if (parse_range(value, &args->pstart, &args->pend)) {
> +                       ret = parse_range(value, &args->pstart, &args->pend);
> +                       if (ret) {
>                                 fprintf(stderr, "Invalid drange argument\n");
> -                               return 1;
> +                               return ret;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_DRANGE;
>                 } else if (!strcmp(this_char, "vrange")) {
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the vrange filter requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
> -                       if (parse_range(value, &args->vstart, &args->vend)) {
> +                       ret = parse_range(value, &args->vstart, &args->vend);
> +                       if (ret) {
>                                 fprintf(stderr, "Invalid vrange argument\n");
> -                               return 1;
> +                               return ret;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_VRANGE;
>                 } else if (!strcmp(this_char, "convert")) {
>                         if (!value || !*value) {
>                                 fprintf(stderr, "the convert option requires "
>                                        "an argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         if (parse_one_profile(value, &args->target)) {
>                                 fprintf(stderr, "Invalid convert argument\n");
> -                               return 1;
> +                               return -EINVAL;
>                         }
>                         args->flags |= BTRFS_BALANCE_ARGS_CONVERT;
>                 } else if (!strcmp(this_char, "soft")) {
> @@ -221,7 +229,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
>                 } else {
>                         fprintf(stderr, "Unrecognized balance option '%s'\n",
>                                 this_char);
> -                       return 1;
> +                       return -EINVAL;
>                 }
>         }
>

All of the above hunks are unnecessary and need to be dropped.
Returning 0/1 is not magic, and all of those are just (static) helpers.

> @@ -297,9 +305,10 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
>         DIR *dirstream = NULL;
>
>         fd = open_file_or_dir(path, &dirstream);
> +       e = errno;
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -               return 12;
> +               return e;
>         }
>
>         ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);

Unnecessary, do a simple 'return 1' here.  You are explicitly
discarding the return value below in your patch anyway.

> @@ -330,7 +339,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
>                         if (e != EINPROGRESS)
>                                 fprintf(stderr, "There may be more info in "
>                                         "syslog - try dmesg | tail\n");
> -                       ret = 19;
> +                       ret = 1;
>                 }
>         } else {
>                 printf("Done, had to relocate %llu out of %llu chunks\n",

Ack.

> @@ -370,6 +379,7 @@ static int cmd_balance_start(int argc, char **argv)
>         int verbose = 0;
>         int nofilters = 1;
>         int i;
> +       int ret = 0;
>
>         memset(&args, 0, sizeof(args));
>
> @@ -473,7 +483,8 @@ static int cmd_balance_start(int argc, char **argv)
>         if (verbose)
>                 dump_ioctl_balance_args(&args);
>
> -       return do_balance(argv[optind], &args, nofilters);
> +       ret = do_balance(argv[optind], &args, nofilters);
> +       return !!ret;
>  }
>
>  static const char * const cmd_balance_pause_usage[] = {

Unnecessary, needs to be dropped.  The above two hunks (with the
suggested change) already make sure do_balance() returns 0/1.

> @@ -498,7 +509,7 @@ static int cmd_balance_pause(int argc, char **argv)
>         fd = open_file_or_dir(path, &dirstream);
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -               return 12;
> +               return 1;
>         }
>
>         ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_PAUSE);
> @@ -508,7 +519,10 @@ static int cmd_balance_pause(int argc, char **argv)
>         if (ret < 0) {
>                 fprintf(stderr, "ERROR: balance pause on '%s' failed - %s\n",
>                         path, (e == ENOTCONN) ? "Not running" : strerror(e));
> -               return 19;
> +               if (e == ENOTCONN)
> +                       return 2;
> +               else
> +                       return 1;
>         }
>
>         return 0;
> @@ -536,7 +550,7 @@ static int cmd_balance_cancel(int argc, char **argv)
>         fd = open_file_or_dir(path, &dirstream);
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -               return 12;
> +               return 1;
>         }
>
>         ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_CANCEL);
> @@ -546,7 +560,10 @@ static int cmd_balance_cancel(int argc, char **argv)
>         if (ret < 0) {
>                 fprintf(stderr, "ERROR: balance cancel on '%s' failed - %s\n",
>                         path, (e == ENOTCONN) ? "Not in progress" : strerror(e));
> -               return 19;
> +               if (e == ENOTCONN)
> +                       return 2;
> +               else
> +                       return 1;
>         }
>
>         return 0;
> @@ -575,7 +592,7 @@ static int cmd_balance_resume(int argc, char **argv)
>         fd = open_file_or_dir(path, &dirstream);
>         if (fd < 0) {
>                 fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> -               return 12;
> +               return 1;
>         }
>
>         memset(&args, 0, sizeof(args));
> @@ -596,12 +613,15 @@ static int cmd_balance_resume(int argc, char **argv)
>                                 "failed - %s\n", path,
>                                 (e == ENOTCONN) ? "Not in progress" :
>                                                   "Already running");
> -                       return 19;
> +                       if (e == ENOTCONN)
> +                               return 2;
> +                       else
> +                               return 1;
>                 } else {
>                         fprintf(stderr,
>  "ERROR: error during balancing '%s' - %s\n"
>  "There may be more info in syslog - try dmesg | tail\n", path, strerror(e));
> -                       return 19;
> +                       return 1;
>                 }
>         } else {
>                 printf("Done, had to relocate %llu out of %llu chunks\n",

Ack up to this point.

> @@ -719,6 +739,8 @@ const struct cmd_group balance_cmd_group = {
>
>  int cmd_balance(int argc, char **argv)
>  {
> +       int ret = 0;
> +
>         if (argc == 2) {
>                 /* old 'btrfs filesystem balance <path>' syntax */
>                 struct btrfs_ioctl_balance_args args;
> @@ -726,7 +748,8 @@ int cmd_balance(int argc, char **argv)
>                 memset(&args, 0, sizeof(args));
>                 args.flags |= BTRFS_BALANCE_TYPE_MASK;
>
> -               return do_balance(argv[1], &args, 1);
> +               ret = do_balance(argv[1], &args, 1);
> +               return !!ret;
>         }
>
>         return handle_command_group(&balance_cmd_group, argc, argv);

Unnecessary, needs to be dropped.  See the first do_balance() call
site.

Thanks,

                Ilya
