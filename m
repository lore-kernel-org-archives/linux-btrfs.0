Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:44675 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3AVVZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:25:45 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122212545.IEDB21186.eastrmfepo203.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 16:25:45 -0500
Message-ID: <50FF03D8.3040009@czarc.net>
Date: Tue, 22 Jan 2013 16:25:44 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com, sandeen@redhat.com
Subject: Re: [PATCH 2/6] Fedora 18 - build-fixes.patch
References: <1358618781-26629-1-git-send-email-gene@czarc.net> <1358618781-26629-3-git-send-email-gene@czarc.net>
In-Reply-To: <1358618781-26629-3-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I believe that this if the likely source of this patch:
http://article.gmane.org/gmane.comp.file-systems.btrfs/4547

I do wonder how much this is still applicable.  However, it has been in 
the btrfs-progs package for Fedora 15, 16, 17, and 18 plus likely some 
versions of RHEL.

On 01/19/2013 01:06 PM, Gene Czarcinski wrote:
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>   btrfsck.c | 2 ++
>   mkfs.c    | 4 ++--
>   2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/btrfsck.c b/btrfsck.c
> index a851008..6274ff7 100644
> --- a/btrfsck.c
> +++ b/btrfsck.c
> @@ -22,7 +22,9 @@
>   #include <stdlib.h>
>   #include <unistd.h>
>   #include <fcntl.h>
> +#include <sys/types.h>
>   #include <sys/stat.h>
> +#include <unistd.h>
>   #include <getopt.h>
>   #include "kerncompat.h"
>   #include "ctree.h"
> diff --git a/mkfs.c b/mkfs.c
> index fbf8319..d123d5f 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1206,7 +1206,7 @@ int main(int ac, char **av)
>   	u64 alloc_start = 0;
>   	u64 metadata_profile = 0;
>   	u64 data_profile = 0;
> -	u32 leafsize = getpagesize();
> +	u32 leafsize = sysconf(_SC_PAGESIZE);
>   	u32 sectorsize = 4096;
>   	u32 nodesize = leafsize;
>   	u32 stripesize = 4096;
> @@ -1282,7 +1282,7 @@ int main(int ac, char **av)
>   				print_usage();
>   		}
>   	}
> -	sectorsize = max(sectorsize, (u32)getpagesize());
> +	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
>   	if (check_leaf_or_node_size(leafsize, sectorsize))
>   		exit(1);
>   	if (check_leaf_or_node_size(nodesize, sectorsize))

