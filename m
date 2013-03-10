Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63418 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3CJOes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 10:34:48 -0400
Received: by mail-pb0-f53.google.com with SMTP id un1so2829193pbc.12
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 07:34:48 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings allocation/deallocation.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1362917859-18824-2-git-send-email-goffredo.baroncelli@yahoo.com>
Date: Sun, 10 Mar 2013 22:34:41 +0800
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?utf-8?Q?Michael_Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Message-Id: <9199E774-B2A4-4C7F-B85A-464BF00FA517@gmail.com>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com> <1362917859-18824-2-git-send-email-goffredo.baroncelli@yahoo.com>
To: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> From: Goffredo Baroncelli <kreijack@inwind.it>
> 
> This patch adds some helpers to manage the strings allocation and
> deallocation.
> The function string_list_add(char *) adds the passed string to a list;
> the function string_list_free() frees all the strings together.
> 
> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
> ---
> Makefile      |    3 ++-
> string_list.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> string_list.h |   23 ++++++++++++++++++++
> 3 files changed, 90 insertions(+), 1 deletion(-)
> create mode 100644 string_list.c
> create mode 100644 string_list.h
> 
> diff --git a/Makefile b/Makefile
> index 596bf93..0d6c43a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -5,7 +5,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
> 	  root-tree.o dir-item.o file-item.o inode-item.o \
> 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
> 	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
> -	  send-stream.o send-utils.o qgroup.o raid6.o
> +	  send-stream.o send-utils.o qgroup.o raid6.o \
> +	  string_list.o
> cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
> 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
> 	       cmds-quota.o cmds-qgroup.o cmds-replace.o
> diff --git a/string_list.c b/string_list.c
> new file mode 100644
> index 0000000..f840048
> --- /dev/null
> +++ b/string_list.c
> @@ -0,0 +1,65 @@
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
> +#include "string_list.h"
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
	
	I'd prefer to have a check here firstly, like:
	if (!s)
		return s;

	Since this function is called directly without any check about 'char *s'
        in your next patch..
	
	Thanks,
	Wang

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
> index 0000000..fdc027d
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
> +char *string_list_add(char *s);
> +void string_list_free();
> +
> +#endif
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

