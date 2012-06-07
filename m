Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:34160 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab2FGTiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 15:38:24 -0400
Message-ID: <4FD10331.3010606@libero.it>
Date: Thu, 07 Jun 2012 21:38:25 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/3] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1337954838-10140-1-git-send-email-sbehrens@giantdisaster.de> <1337954838-10140-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337954838-10140-2-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

On 05/25/2012 04:07 PM, Stefan Behrens wrote:
> This is a preparation step to add support for device stats. The definition
> of the function open_file_or_dir() is moved from common.c to utils.c in
> order to be able to share some common code between scrub and the device
> stats in the following step. That common code uses open_file_or_dir().
> Since open_file_or_dir() makes use of the function dirfd(3), the required
> XOPEN version was raised from 6 to 7.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  Makefile         |    4 ++--
>  btrfsctl.c       |   28 ----------------------------
>  cmds-balance.c   |    1 +
>  cmds-inspect.c   |    1 +
>  cmds-subvolume.c |    1 +
>  commands.h       |    3 ---
>  common.c         |   46 ----------------------------------------------
>  utils.c          |   31 +++++++++++++++++++++++++++++--
>  utils.h          |    3 +++
>  9 files changed, 37 insertions(+), 81 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 79818e6..fe2b432 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -39,8 +39,8 @@ all: version $(progs) manpages
>  version:
>  	bash version.sh
>  
> -btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
> -	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
> +btrfs: $(objects) btrfs.o help.o $(cmds_objects)
> +	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
>  		$(objects) $(LDFLAGS) $(LIBS) -lpthread
>  
>  calc-size: $(objects) calc-size.o
> diff --git a/btrfsctl.c b/btrfsctl.c
> index d45e2a7..f0584f3 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -63,34 +63,6 @@ static void print_usage(void)
>  	exit(1);
>  }
>  
> -static int open_file_or_dir(const char *fname)
> -{
> -	int ret;
> -	struct stat st;
> -	DIR *dirstream;
> -	int fd;
> -
> -	ret = stat(fname, &st);
> -	if (ret < 0) {
> -		perror("stat:");
> -		exit(1);
> -	}
> -	if (S_ISDIR(st.st_mode)) {
> -		dirstream = opendir(fname);
> -		if (!dirstream) {
> -			perror("opendir");
> -			exit(1);
> -		}
> -		fd = dirfd(dirstream);
> -	} else {
> -		fd = open(fname, O_RDWR);
> -	}
> -	if (fd < 0) {
> -		perror("open");
> -		exit(1);
> -	}
> -	return fd;
> -}

I suppose that you want to remove open_file_or_dir() from btrfsctl.c and
use the one provided by utils.c (or common.c). However I have to point
out that these two function are a bit different: the first one does
exit() in case of error; the second one returns an error.

In any case I think that it is time to deprecate and remove btrfsctl.

BR
Goffredo



>  int main(int ac, char **av)
>  {
>  	char *fname = NULL;
> diff --git a/cmds-balance.c b/cmds-balance.c
> index 38a7426..5793b5c 100644
> --- a/cmds-balance.c
> +++ b/cmds-balance.c
> @@ -26,6 +26,7 @@
>  #include "ctree.h"
>  #include "ioctl.h"
>  #include "volumes.h"
> +#include "utils.h"
>  
>  #include "commands.h"
>  
> diff --git a/cmds-inspect.c b/cmds-inspect.c
> index 2f0228f..7a8785b 100644
> --- a/cmds-inspect.c
> +++ b/cmds-inspect.c
> @@ -22,6 +22,7 @@
>  
>  #include "kerncompat.h"
>  #include "ioctl.h"
> +#include "utils.h"
>  
>  #include "commands.h"
>  
> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
> index 950fa8f..8ecd3f4 100644
> --- a/cmds-subvolume.c
> +++ b/cmds-subvolume.c
> @@ -26,6 +26,7 @@
>  
>  #include "kerncompat.h"
>  #include "ioctl.h"
> +#include "utils.h"
>  
>  #include "commands.h"
>  
> diff --git a/commands.h b/commands.h
> index a303a50..aea4cb1 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -79,9 +79,6 @@ void help_ambiguous_token(const char *arg, const struct cmd_group *grp);
>  
>  void help_command_group(const struct cmd_group *grp, int argc, char **argv);
>  
> -/* common.c */
> -int open_file_or_dir(const char *fname);
> -
>  extern const struct cmd_group subvolume_cmd_group;
>  extern const struct cmd_group filesystem_cmd_group;
>  extern const struct cmd_group balance_cmd_group;
> diff --git a/common.c b/common.c
> deleted file mode 100644
> index 03f6570..0000000
> --- a/common.c
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -/*
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public
> - * License v2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public
> - * License along with this program; if not, write to the
> - * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> - * Boston, MA 021110-1307, USA.
> - */
> -
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <dirent.h>
> -#include <fcntl.h>
> -
> -int open_file_or_dir(const char *fname)
> -{
> -	int ret;
> -	struct stat st;
> -	DIR *dirstream;
> -	int fd;
> -
> -	ret = stat(fname, &st);
> -	if (ret < 0) {
> -		return -1;
> -	}
> -	if (S_ISDIR(st.st_mode)) {
> -		dirstream = opendir(fname);
> -		if (!dirstream) {
> -			return -2;
> -		}
> -		fd = dirfd(dirstream);
> -	} else {
> -		fd = open(fname, O_RDWR);
> -	}
> -	if (fd < 0) {
> -		return -3;
> -	}
> -	return fd;
> -}
> diff --git a/utils.c b/utils.c
> index ee7fa1b..6157115 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -16,8 +16,9 @@
>   * Boston, MA 021110-1307, USA.
>   */
>  
> -#define _XOPEN_SOURCE 600
> -#define __USE_XOPEN2K
> +#define _XOPEN_SOURCE 700
> +#define __USE_XOPEN2K8
> +#define __XOPEN2K8 /* due to an error in dirent.h, to get dirfd() */
>  #include <stdio.h>
>  #include <stdlib.h>
>  #ifndef __CHECKER__
> @@ -1206,3 +1207,29 @@ scan_again:
>  	return 0;
>  }
>  
> +int open_file_or_dir(const char *fname)
> +{
> +	int ret;
> +	struct stat st;
> +	DIR *dirstream;
> +	int fd;
> +
> +	ret = stat(fname, &st);
> +	if (ret < 0) {
> +		return -1;
> +	}
> +	if (S_ISDIR(st.st_mode)) {
> +		dirstream = opendir(fname);
> +		if (!dirstream) {
> +			return -2;
> +		}
> +		fd = dirfd(dirstream);
> +	} else {
> +		fd = open(fname, O_RDWR);
> +	}
> +	if (fd < 0) {
> +		return -3;
> +	}
> +	return fd;
> +}
> +
> diff --git a/utils.h b/utils.h
> index c5f55e1..e281002 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -19,6 +19,8 @@
>  #ifndef __UTILS__
>  #define __UTILS__
>  
> +#include "ctree.h"
> +
>  #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
>  
>  int make_btrfs(int fd, const char *device, const char *label,
> @@ -46,4 +48,5 @@ int check_label(char *input);
>  int get_mountpt(char *dev, char *mntpt, size_t size);
>  
>  int btrfs_scan_block_devices(int run_ioctl);
> +int open_file_or_dir(const char *fname);
>  #endif

