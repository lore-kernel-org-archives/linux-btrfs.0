Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33392 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbDSHZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 03:25:58 -0400
Received: by wgin8 with SMTP id n8so149360824wgi.0
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 00:25:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429365545-2419-1-git-send-email-lauri.vosandi@gmail.com>
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
	<1429365545-2419-1-git-send-email-lauri.vosandi@gmail.com>
Date: Sun, 19 Apr 2015 08:25:56 +0100
Message-ID: <CAMU1PDhNJJHLOuuXCm3YMsWT01+Gu22VFF0qbt=F5mO+RiTWTw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: optionally enforce chroot for btrfs receive
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 April 2015 at 14:59, Lauri Võsandi <lauri.vosandi@gmail.com> wrote:
> This patch forces btrfs receive to issue chroot before
> parsing the btrfs stream using command-line flag -C
> to confine the process and minimize damage that could
> be done via malicious btrfs stream.
>
> Signed-off-by: Lauri Võsandi <lauri.vosandi@gmail.com>
> ---
>  cmds-receive.c | 37 ++++++++++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 9 deletions(-)
>
> diff --git a/cmds-receive.c b/cmds-receive.c
> index 44ef27e..73bd88b 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -61,6 +61,7 @@ struct btrfs_receive
>         char *root_path;
>         char *dest_dir_path; /* relative to root_path */
>         char *full_subvol_path;
> +       int dest_dir_chroot;
>
>         struct subvol_info *cur_subvol;
>
> @@ -867,14 +868,27 @@ static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd,
>                 goto out;
>         }
>
> -       /*
> -        * find_mount_root returns a root_path that is a subpath of
> -        * dest_dir_full_path. Now get the other part of root_path,
> -        * which is the destination dir relative to root_path.
> -        */
> -       r->dest_dir_path = dest_dir_full_path + strlen(r->root_path);
> -       while (r->dest_dir_path[0] == '/')
> -               r->dest_dir_path++;
> +       if (r->dest_dir_chroot) {
> +               if (chroot(dest_dir_full_path)) {
> +                       ret = -errno;
> +                       fprintf(stderr,
> +                               "ERROR: failed to chroot to %s, %s\n",
> +                               dest_dir_full_path,
> +                               strerror(-ret));
> +                       goto out;
> +               }
> +               if(chdir("/")) {
> +                       ret = -errno;
> +                       fprintf(stderr,
> +                               "ERROR: failed to chdir to /, %s\n",
> +                               strerror(-ret));

There appears to be a goto out missing here.

> +               }
> +               if (g_verbose >= 1) {
> +                       fprintf(stderr, "chrooted to %s\n",
> +                               dest_dir_full_path);
> +               }
> +               r->root_path = r->dest_dir_path = strdup("/");
> +       }
>
>         ret = subvol_uuid_search_init(r->mnt_fd, &r->sus);
>         if (ret < 0)
> @@ -940,6 +954,7 @@ int cmd_receive(int argc, char **argv)
>         r.write_fd = -1;
>         r.dest_dir_fd = -1;
>         r.explicit_parent = NULL;
> +       r.dest_dir_chroot = 0;
>
>         while (1) {
>                 int c;
> @@ -948,7 +963,7 @@ int cmd_receive(int argc, char **argv)
>                         { NULL, 0, NULL, 0 }
>                 };
>
> -               c = getopt_long(argc, argv, "evf:p:", long_opts, NULL);
> +               c = getopt_long(argc, argv, "Cevf:p:", long_opts, NULL);
>                 if (c < 0)
>                         break;
>
> @@ -962,6 +977,9 @@ int cmd_receive(int argc, char **argv)
>                 case 'e':
>                         r.honor_end_cmd = 1;
>                         break;
> +               case 'C':
> +                       r.dest_dir_chroot = 1;
> +                       break;
>                 case 'E':
>                         max_errors = arg_strtou64(optarg);
>                         break;
> @@ -1014,6 +1032,7 @@ const char * const cmd_receive_usage[] = {
>         "                 in the data stream. Without this option,",
>         "                 the receiver terminates only if an error",
>         "                 is recognized or on EOF.",
> +       "-C               Confine the process to <mount> using chroot",
>         "--max-errors <N> Terminate as soon as N errors happened while",
>         "                 processing commands from the send stream.",
>         "                 Default value is 1. A value of 0 means no limit.",
> --
> 1.9.1

Mike
