Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438Ab3BYCWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Feb 2013 21:22:06 -0500
Message-ID: <512ACA84.3010408@redhat.com>
Date: Sun, 24 Feb 2013 20:20:52 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Michael_Kj=F6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com> <1361627171-8246-2-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361627171-8246-2-git-send-email-goffredo.baroncelli@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/23/13 7:46 AM, Goffredo Baroncelli wrote:
> From: Goffredo Baroncelli <kreijack@inwind.it>
> 
> This patch adds some helpers to manage the strings allocation and
> deallocation.
> The function string_list_add(char *) adds the passed string to a list;
> the function string_list_free() frees all the strings together.

I have to say, I agree with Zach that there are more straightforward
and less error-prone ways to accomplish this same result.

You said:

> your suggestion is not so easy applicable

to Zach's suggestion.  Why do you consider it to be not applicable?
Maybe I am missing some subtlety, but it'd help if you could explain
the problem that you see.

I think that the asymmetry in i.e. _cmd_disk_free where you do:

+	printf("Disk size:\t\t%*s\n", width,
+		df_pretty_sizes(total_disk, mode));
<a few times>
and then:

+	string_list_free();

... because obviously (?)  "df_pretty_sizes" needs this cleanup ...

is unexpected, magic, and error-prone.

-Eric



thanks,
-Eric

> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  Makefile      |    3 ++-
>  string_list.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  string_list.h |   23 +++++++++++++++++++++
>  3 files changed, 88 insertions(+), 1 deletion(-)
>  create mode 100644 string_list.c
>  create mode 100644 string_list.h
> 
> diff --git a/Makefile b/Makefile
> index 596bf93..0d6c43a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -5,7 +5,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  root-tree.o dir-item.o file-item.o inode-item.o \
>  	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
>  	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
> -	  send-stream.o send-utils.o qgroup.o raid6.o
> +	  send-stream.o send-utils.o qgroup.o raid6.o \
> +	  string_list.o
>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>  	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>  	       cmds-quota.o cmds-qgroup.o cmds-replace.o
> diff --git a/string_list.c b/string_list.c
> new file mode 100644
> index 0000000..8d8cc1f
> --- /dev/null
> +++ b/string_list.c
> @@ -0,0 +1,63 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +
> +/* To store the strings */
> +static void **strings_to_free;
> +static int count_string_to_free;
> +
> +/* 
> + * Add a string to the dynamic allocated string list
> + */
> +char *string_list_add(char *s)
> +{
> +	int  size;
> +
> +	size = sizeof(void *) * ++count_string_to_free;
> +	strings_to_free = realloc(strings_to_free, size);
> +
> +	/* if we don't have enough memory, we have more serius
> +	   problem than that a wrong handling of not enough memory */
> +	if (!strings_to_free) {
> +		fprintf(stderr, "add_string_to_free(): Not enough memory\n");
> +		count_string_to_free = 0;
> +		return NULL;
> +	}
> +
> +	strings_to_free[count_string_to_free-1] = s;
> +	return s;
> +}
> +
> +/*
> + * Free the dynamic allocated strings list
> + */
> +void string_list_free()
> +{
> +	int	i;
> +	for (i = 0 ; i < count_string_to_free ; i++)
> +		free(strings_to_free[i]);
> +
> +	free(strings_to_free);
> +
> +	strings_to_free = 0;
> +	count_string_to_free = 0;
> +}
> +
> +
> diff --git a/string_list.h b/string_list.h
> new file mode 100644
> index 0000000..f974fbc
> --- /dev/null
> +++ b/string_list.h
> @@ -0,0 +1,23 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef STRING_LIST_H
> +#define STRING_LIST_H
> +
> +void string_list_add(char *s);
> +void string_list_free();
> +
> +#endif
> 

