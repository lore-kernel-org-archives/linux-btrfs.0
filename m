Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:52624 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdJBIjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 04:39:06 -0400
Received: by mail-qt0-f195.google.com with SMTP id o52so6334188qtc.9
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Oct 2017 01:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Mon, 2 Oct 2017 11:39:05 +0300
Message-ID: <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to also
 accept subvol path
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 2, 2017 at 11:19 AM, Misono, Tomohiro
<misono.tomohiro@jp.fujitsu.com> wrote:
> This patch changes "subvol set-default" to also accept the subvolume path
> for convenience.
>
> This is the one of the issue on github:
> https://github.com/kdave/btrfs-progs/issues/35
>
> If there are two args, they are assumed as subvol id and path to the fs
> (the same as current behavior), and if there is only one arg, it is assumed
> as the path to the subvolume. Therefore there is no ambiguity between subvol
> id and subvol name, which is mentioned in the above issue page.
>
> Only the absolute path to the subvolume is allowed, for the safety when
> multiple filesystems are used.
>
> subvol id is resolved by get_subvol_info() which is used by "subvol show".
>
> change to v2:
> restrict the path to only allow absolute path.

This is absolutely arbitrary restriction. Why we can do "btrfs
subvolume create ./relative/path" but cannot do "btrfs subvolume
set-default ./relative/path"?

> documents are updated accordingly.
>
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  Documentation/btrfs-subvolume.asciidoc | 11 +++----
>  cmds-subvolume.c                       | 53 +++++++++++++++++++++++++++-------
>  2 files changed, 48 insertions(+), 16 deletions(-)
>
> diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
> index 5cfe885..7973567 100644
> --- a/Documentation/btrfs-subvolume.asciidoc
> +++ b/Documentation/btrfs-subvolume.asciidoc
> @@ -142,12 +142,13 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
>  for --sort you can combine some items together by \',', just like
>  --sort=+ogen,-gen,path,rootid.
>
> -*set-default* <id> <path>::
> -Set the subvolume of the filesystem <path> which is mounted as
> -default.
> +*set-default* [<path>|<id> <mountpoint>]::
> +Set the subvolume of the filesystem which is mounted as default.
>  +
> -The subvolume is identified by <id>, which is returned by the *subvolume list*
> -command.
> +Only absolute path is allowed to specify the subvolume.
> +Alterantively, the pair of <id> and <mountpoint> can be used. In that
> +case, the subvolume is identified by <id>, which is returned by the
> +*subvolume list* command. The filesystem is specified by <mountpoint>.
>
>  *show* <path>::
>  Show information of a given subvolume in the <path>.
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 666f6e0..dda9e73 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -803,28 +803,59 @@ out:
>  }
>
>  static const char * const cmd_subvol_set_default_usage[] = {
> -       "btrfs subvolume set-default <subvolid> <path>",
> -       "Set the default subvolume of a filesystem",
> +       "btrfs subvolume set-default [<path>|<id> <mountpoint>]",
> +       "Set the default subvolume of the filesystem mounted as default.",
> +       "The subvolume can be specified by its absolute path,",
> +       "or the pair of subvolume id and mount point to the filesystem.",
>         NULL
>  };
>
>  static int cmd_subvol_set_default(int argc, char **argv)
>  {
> -       int     ret=0, fd, e;
> -       u64     objectid;
> -       char    *path;
> -       char    *subvolid;
> -       DIR     *dirstream = NULL;
> +       int ret = 0;
> +       int fd, e;
> +       u64 objectid;
> +       char *path;
> +       char *subvolid;
> +       DIR *dirstream = NULL;
>
>         clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
>
> -       if (check_argc_exact(argc - optind, 2))
> +       if (check_argc_min(argc - optind, 1) ||
> +                       check_argc_max(argc - optind, 2))
>                 usage(cmd_subvol_set_default_usage);
>
> -       subvolid = argv[optind];
> -       path = argv[optind + 1];
> +       if (argc - optind == 1) {
> +               /* path to the subvolume is specified */
> +               struct root_info ri;
> +               char *fullpath;
>
> -       objectid = arg_strtou64(subvolid);
> +               path = argv[optind];
> +               if (path[0] != '/') {
> +                       error("only absolute path is allowed");
> +                       return 1;
> +               }
> +
> +               fullpath = realpath(path, NULL);
> +               if (!fullpath) {
> +                       error("cannot find real path for '%s': %s",
> +                               path, strerror(errno));
> +                       return 1;
> +               }
> +
> +               ret = get_subvol_info(fullpath, &ri);
> +               free(fullpath);
> +
> +               if (ret)
> +                       return 1;
> +
> +               objectid = ri.root_id;
> +       } else {
> +               /* subvol id and path to the filesystem are specified */
> +               subvolid = argv[optind];
> +               path = argv[optind + 1];
> +               objectid = arg_strtou64(subvolid);
> +       }
>
>         fd = btrfs_open_dir(path, &dirstream, 1);
>         if (fd < 0)
> --
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
