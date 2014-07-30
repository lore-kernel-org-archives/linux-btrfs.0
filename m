Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:45452 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaG3HTT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 03:19:19 -0400
Received: by mail-vc0-f171.google.com with SMTP id hq11so1164240vcb.30
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 00:19:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D865B7.8040307@jp.fujitsu.com>
References: <53D865B7.8040307@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 08:19:19 +0100
Message-ID: <CAMU1PDhAXcrr9Dx-Ks9rKvP0G1eMGs99xHYox=7iZL0wxGCxdg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs-progs: introduce test_issubvolname() for simplicity
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 July 2014 04:25, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>
> There are many duplicated codes to check if the given string is
> correct subvolume name. Introduce test_issubvolname() for this
> purpose for simplicity.
>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Cc: David Sterba <dsterba@suse.cz>
>
> ---
> changelog:
> v2: Move test_issubvolname() to utils.c.
>     Change the target branch to integ-20140729.
> ---
>  cmds-subvolume.c |  9 +++------
>  utils.c          | 12 ++++++++++++
>  utils.h          |  1 +
>  3 files changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 8bdc447..c075fb2 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -127,8 +127,7 @@ static int cmd_subvol_create(int argc, char **argv)
>         dupdir = strdup(dst);
>         dstdir = dirname(dupdir);
>
> -       if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
> -            strchr(newname, '/') ){
> +       if (!test_issubvolname(newname)) {
>                 fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>                         newname);
>                 goto out;
> @@ -302,8 +301,7 @@ again:
>         vname = basename(dupvname);
>         free(cpath);
>
> -       if (!strcmp(vname, ".") || !strcmp(vname, "..") ||
> -            strchr(vname, '/')) {
> +       if (!test_issubvolname(vname)) {
>                 fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>                         vname);
>                 ret = 1;
> @@ -711,8 +709,7 @@ static int cmd_snapshot(int argc, char **argv)
>                 dstdir = dirname(dupdir);
>         }
>
> -       if (!strcmp(newname, ".") || !strcmp(newname, "..") ||
> -            strchr(newname, '/') ){
> +       if (!test_issubvolname(newname)) {
>                 fprintf(stderr, "ERROR: incorrect snapshot name '%s'\n",
>                         newname);
>                 goto out;
> diff --git a/utils.c b/utils.c
> index d61cbec..e2a2acd 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2685,3 +2685,15 @@ int btrfs_read_sysfs(char path[PATH_MAX])
>         close(fd);
>         return atoi((const char *)&val);
>  }
> +
> +/*
> + * test if name is a correct subvolume name
> + * this function return
> + * 0-> name is not a correct subvolume name
> + * 1-> name is a correct subvolume name
> + */
> +int test_issubvolname(char *name)

(const char *name) please.  The string is not modified by the function.

> +{
> +       return name[0] != '\0' && !strchr(name, '/') &&
> +               strcmp(name, ".") && strcmp(name, "..");
> +}
> diff --git a/utils.h b/utils.h
> index 0c9b65f..d635c84 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -133,6 +133,7 @@ int get_fslist(struct btrfs_ioctl_fslist **out_fslist, u64 *out_count);
>  int fsid_to_mntpt(__u8 *fsid, char *mntpt, int *mnt_cnt);
>
>  int test_minimum_size(const char *file, u32 leafsize);
> +int test_issubvolname(char *name);

And in the prototype to match.

>
>  /*
>   * Btrfs minimum size calculation is complicated, it should include at least:
> --
> 1.9.3

Thanks,
Mike
