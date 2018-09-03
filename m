Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49802 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727536AbeICQBP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Sep 2018 12:01:15 -0400
Subject: Re: [PATCH v2] btrfs-progs: defrag: open files RO on new enough
 kernels
To: Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
References: <51e331d1-0f61-7ccb-7424-99450658805b@suse.com>
 <20180903113115.13609-1-kilobyte@angband.pl>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c47c376f-68c6-c00c-80eb-0a6dd95d5ac1@suse.com>
Date: Mon, 3 Sep 2018 14:41:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180903113115.13609-1-kilobyte@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.09.2018 14:31, Adam Borowski wrote:
> Defragging an executable conflicts both way with it being run, resulting in
> ETXTBSY.  This either makes defrag fail or prevents the program from being
> executed.
> 
> Kernels 4.19-rc1 and later allow defragging files you could have possibly
> opened rw, even if the passed descriptor is ro.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

So this commit really seems to be the userspace counterpart of
616d374efa23 ("btrfs: allow defrag on a file opened read-only that has
rw permissions") as such IMO it will be good if you reference it.


> ---
> v2: more eloquent description; root can't defrag RO on old kernels (unlike
> dedupe)
> 
> 
>  cmds-filesystem.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 06c8311b..17e992a3 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -26,6 +26,7 @@
>  #include <ftw.h>
>  #include <mntent.h>
>  #include <linux/limits.h>
> +#include <linux/version.h>
>  #include <getopt.h>
>  
>  #include <btrfsutil.h>
> @@ -39,12 +40,14 @@
>  #include "list_sort.h"
>  #include "disk-io.h"
>  #include "help.h"
> +#include "fsfeatures.h"
>  
>  /*
>   * for btrfs fi show, we maintain a hash of fsids we've already printed.
>   * This way we don't print dups if a given FS is mounted more than once.
>   */
>  static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
> +static mode_t defrag_ro = O_RDONLY;
>  
>  static const char * const filesystem_cmd_group_usage[] = {
>  	"btrfs filesystem [<group>] <command> [<args>]",
> @@ -877,7 +880,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
>  	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
>  		if (defrag_global_verbose)
>  			printf("%s\n", fpath);
> -		fd = open(fpath, O_RDWR);
> +		fd = open(fpath, defrag_ro);
>  		if (fd < 0) {
>  			goto error;
>  		}
> @@ -914,6 +917,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  	int compress_type = BTRFS_COMPRESS_NONE;
>  	DIR *dirstream;
>  
> +	if (get_running_kernel_version() < KERNEL_VERSION(4,19,0))
> +		defrag_ro = O_RDWR;

I completely missed those lines in the previous posting, so alongside
the context information of the kernel commit this makes sense. However,
defrag_ro is a really bad name because there are case where, well, it's
not going to be ro, is it ? How about something like "defrag_open_mode"
or "defrag_open_flags" or something neutral which won't be implying the
mode of operation.

> +
>  	/*
>  	 * Kernel has a different default (256K) that is supposed to be safe,
>  	 * but it does not defragment very well. The 32M will likely lead to
> @@ -1014,7 +1020,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
>  		int defrag_err = 0;
>  
>  		dirstream = NULL;
> -		fd = open_file_or_dir(argv[i], &dirstream);
> +		fd = open_file_or_dir3(argv[i], &dirstream, defrag_ro);
>  		if (fd < 0) {
>  			error("cannot open %s: %m", argv[i]);
>  			ret = -errno;
> 
