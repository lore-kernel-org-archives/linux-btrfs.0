Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34785 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbcEBOK3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 10:10:29 -0400
Received: by mail-oi0-f65.google.com with SMTP id d139so6412083oig.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 07:10:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462177984-23980-1-git-send-email-dsterba@suse.com>
References: <1462177984-23980-1-git-send-email-dsterba@suse.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Mon, 2 May 2016 10:09:48 -0400
Message-ID: <CADfjVrjY246makTpiW398C5fM1D7uwrJAmMNt+aZCyEnY_u7jA@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: add safety delay before starting full balance
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 2, 2016 at 4:33 AM, David Sterba <dsterba@suse.com> wrote:
> A short delay with a warning before starting a full balance should
> improve usability. We have been getting reports from people who run full
> balance after following some random advice and then get surprised by the
> performance impact.
>
> The countdown is done even when run from scripts, but as the whole
> balance takes significanly more time, this shouldn't be an issue.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  Documentation/btrfs-balance.asciidoc |  6 ++++
>  cmds-balance.c                       | 65 ++++++++++++++++++++++++++++++------
>  2 files changed, 60 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
> index 8b5df96ad41f..7df40b9c6f49 100644
> --- a/Documentation/btrfs-balance.asciidoc
> +++ b/Documentation/btrfs-balance.asciidoc
> @@ -67,6 +67,12 @@ resume interrupted balance
>  start the balance operation according to the specified filters, no filters
>  will rewrite the entire filesystem. The process runs in the foreground.
>  +
> +NOTE: the balance command without filters will basically rewrite everything
> +in the filesystem. The run time is potentially very long, depending on the
> +filesystem size. To prevent starting a full balance by accident, the user is
> +warned and has a few seconds to cancel the operation before it starts. The
> +warning and delay can be skipped with '--full-balance' option.
> ++
>  `Options`
>  +
>  -d[<filters>]::::
> diff --git a/cmds-balance.c b/cmds-balance.c
> index 33f91e41134e..5f05f603d4c8 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -417,8 +417,13 @@ static int do_balance_v1(int fd)
>         return ret;
>  }
>
> +enum {
> +       BALANCE_START_FILTERS = 1 << 0,
> +       BALANCE_START_NOWARN  = 1 << 1
> +};
> +
>  static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
> -                     int nofilters)
> +                     unsigned flags)
>  {
>         int fd;
>         int ret;
> @@ -429,6 +434,24 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
>         if (fd < 0)
>                 return 1;
>
> +       if (!(flags & BALANCE_START_FILTERS) && !(flags & BALANCE_START_NOWARN)) {
> +               int delay = 10;
> +
> +               printf("WARNING:\n\n");
> +               printf("\tFull balance without filters requested. This operation is very\n");
> +               printf("\tintense and takes potentially very long. It is recommended to\n");
> +               printf("\tuse the balance filters to narrow down the balanced data.\n");
> +               printf("\tUse 'btrfs balance start --full-balance' option to skip this\n");
> +               printf("\twarning. The operation will start in %d seconds.\n", delay);
> +               printf("\tUse Ctrl-C to stop it.\n");
> +               while (delay) {
> +                       sleep(1);
> +                       printf("%2d", delay--);
> +                       fflush(stdout);
> +               }

Shouldn't the sleep be after the fflush?

> +               printf("\nStarting balance without any filters.\n");
> +       }
> +
>         ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);
>         e = errno;
>
> @@ -438,7 +461,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
>                  * old one.  But, the old one doesn't know any filters, so
>                  * don't fall back if they tried to use the fancy new things
>                  */
> -               if (e == ENOTTY && nofilters) {
> +               if (e == ENOTTY && !(flags & BALANCE_START_FILTERS)) {
>                         ret = do_balance_v1(fd);
>                         if (ret == 0)
>                                 goto out;
> @@ -477,13 +500,16 @@ static const char * const cmd_balance_start_usage[] = {
>         "passed all filters in a comma-separated list of filters for a",
>         "particular chunk type.  If filter list is not given balance all",
>         "chunks of that type.  In case none of the -d, -m or -s options is",
> -       "given balance all chunks in a filesystem.",
> +       "given balance all chunks in a filesystem. This is potentially",
> +       "long operation and the user is warned before this start, with",
> +       "a delay to stop it.",
>         "",
>         "-d[filters]    act on data chunks",
>         "-m[filters]    act on metadata chunks",
>         "-s[filters]    act on system chunks (only under -f)",
>         "-v             be verbose",
>         "-f             force reducing of metadata integrity",
> +       "--full-balance do not print warning and do not delay start",
>         NULL
>  };
>
> @@ -494,19 +520,22 @@ static int cmd_balance_start(int argc, char **argv)
>                                                 &args.meta, NULL };
>         int force = 0;
>         int verbose = 0;
> -       int nofilters = 1;
> +       unsigned start_flags = 0;
>         int i;
>
>         memset(&args, 0, sizeof(args));
>
>         optind = 1;
>         while (1) {
> +               enum { GETOPT_VAL_FULL_BALANCE = 256 };
>                 static const struct option longopts[] = {
>                         { "data", optional_argument, NULL, 'd'},
>                         { "metadata", optional_argument, NULL, 'm' },
>                         { "system", optional_argument, NULL, 's' },
>                         { "force", no_argument, NULL, 'f' },
>                         { "verbose", no_argument, NULL, 'v' },
> +                       { "full-balance", no_argument, NULL,
> +                               GETOPT_VAL_FULL_BALANCE },
>                         { NULL, 0, NULL, 0 }
>                 };
>
> @@ -516,21 +545,21 @@ static int cmd_balance_start(int argc, char **argv)
>
>                 switch (opt) {
>                 case 'd':
> -                       nofilters = 0;
> +                       start_flags |= BALANCE_START_FILTERS;
>                         args.flags |= BTRFS_BALANCE_DATA;
>
>                         if (parse_filters(optarg, &args.data))
>                                 return 1;
>                         break;
>                 case 's':
> -                       nofilters = 0;
> +                       start_flags |= BALANCE_START_FILTERS;
>                         args.flags |= BTRFS_BALANCE_SYSTEM;
>
>                         if (parse_filters(optarg, &args.sys))
>                                 return 1;
>                         break;
>                 case 'm':
> -                       nofilters = 0;
> +                       start_flags |= BALANCE_START_FILTERS;
>                         args.flags |= BTRFS_BALANCE_METADATA;
>
>                         if (parse_filters(optarg, &args.meta))
> @@ -542,6 +571,9 @@ static int cmd_balance_start(int argc, char **argv)
>                 case 'v':
>                         verbose = 1;
>                         break;
> +               case GETOPT_VAL_FULL_BALANCE:
> +                       start_flags |= BALANCE_START_NOWARN;
> +                       break;
>                 default:
>                         usage(cmd_balance_start_usage);
>                 }
> @@ -567,7 +599,7 @@ static int cmd_balance_start(int argc, char **argv)
>                         sizeof(struct btrfs_balance_args));
>         }
>
> -       if (nofilters) {
> +       if (!(start_flags & BALANCE_START_FILTERS)) {
>                 /* relocate everything - no filters */
>                 args.flags |= BTRFS_BALANCE_TYPE_MASK;
>         }
> @@ -595,7 +627,7 @@ static int cmd_balance_start(int argc, char **argv)
>         if (verbose)
>                 dump_ioctl_balance_args(&args);
>
> -       return do_balance(argv[optind], &args, nofilters);
> +       return do_balance(argv[optind], &args, start_flags);
>  }
>
>  static const char * const cmd_balance_pause_usage[] = {
> @@ -833,6 +865,16 @@ static int cmd_balance_status(int argc, char **argv)
>         return 1;
>  }
>
> +static int cmd_balance_full(int argc, char **argv)
> +{
> +       struct btrfs_ioctl_balance_args args;
> +
> +       memset(&args, 0, sizeof(args));
> +       args.flags |= BTRFS_BALANCE_TYPE_MASK;
> +
> +       return do_balance(argv[1], &args, BALANCE_START_NOWARN);
> +}
> +
>  static const char balance_cmd_group_info[] =
>  "balance data accross devices, or change block groups using filters";
>
> @@ -843,20 +885,21 @@ const struct cmd_group balance_cmd_group = {
>                 { "cancel", cmd_balance_cancel, cmd_balance_cancel_usage, NULL, 0 },
>                 { "resume", cmd_balance_resume, cmd_balance_resume_usage, NULL, 0 },
>                 { "status", cmd_balance_status, cmd_balance_status_usage, NULL, 0 },
> +               { "--full-balance", cmd_balance_full, NULL, NULL, 1 },
>                 NULL_CMD_STRUCT
>         }
>  };
>
>  int cmd_balance(int argc, char **argv)
>  {
> -       if (argc == 2) {
> +       if (argc == 2 && strcmp("start", argv[1]) != 0) {
>                 /* old 'btrfs filesystem balance <path>' syntax */
>                 struct btrfs_ioctl_balance_args args;
>
>                 memset(&args, 0, sizeof(args));
>                 args.flags |= BTRFS_BALANCE_TYPE_MASK;
>
> -               return do_balance(argv[1], &args, 1);
> +               return do_balance(argv[1], &args, 0);
>         }
>
>         return handle_command_group(&balance_cmd_group, argc, argv);
> --
> 2.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
