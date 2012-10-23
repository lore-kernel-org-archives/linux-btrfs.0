Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58115 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab2JWTof (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 15:44:35 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1287121eaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 12:44:33 -0700 (PDT)
Message-ID: <5086F3C4.50804@gmail.com>
Date: Tue, 23 Oct 2012 21:45:08 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add btrfs-show-super tool
References: <1350631087-1169-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1350631087-1169-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

On 2012-10-19 09:18, Stefan Behrens wrote:
> Just a small program to print the fields of a super block.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
[...]
> +
> +
> +static void print_usage(void)
> +{
> +	fprintf(stderr, "usage: btrfs-show-super [-i super_mirror] dev\n");
> +	fprintf(stderr, "\tThe super_mirror number is between 0 and %d.\n",
> +		BTRFS_SUPER_MIRROR_MAX - 1);

What about adding a flag '-a' to show all the superblocks ?

> +	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
> +}
> +
[...]
> +static void dump_superblock(struct btrfs_super_block *sb)
> +{
> +	printf("bytenr\t%llu\n", (unsigned long long)btrfs_super_bytenr(sb));
> +	printf("flags\t0x%llx\n", (unsigned long long)btrfs_super_flags(sb));
> +	printf("magic \t0x%llx (little endian)\n",
> +	       (unsigned long long)sb->magic);

I suggest to print if magic matches or not. The same if csum matches or
not. This help to understand if the superblock is valid or not.

> +	btrfs_print_id("fsid\t", sb->fsid, BTRFS_FSID_SIZE);

Please, use the uuid_unparse() function, so the output is like the other
btrfs tools. Be aware that the libuuid is already linked.

> +	btrfs_print_id("label\t", (u8 *)sb->label, BTRFS_LABEL_SIZE);

Does make sense to output the label as hex digits ? I prefer the ascii
value, in order to avoid garbage I suggest something like:

	#include <ctype.h>

	char *p;
	for( p= sb->label ; *p ; p++ ) putchar(isprint(*p) ? *p : '_' );

> +	printf("generation\t%llu\n",
> +	       (unsigned long long)btrfs_super_generation(sb));
> +	printf("root\t%llu\n", (unsigned long long)btrfs_super_root(sb));
> +	printf("sys_array_size\t%llu\n",
> +	       (unsigned long long)btrfs_super_sys_array_size(sb));
[...]

> +	printf("dev_item.generation\t%llu\n", (unsigned long long)
> +	       btrfs_stack_device_generation(&sb->dev_item));

Could you please add also the sb->dev_item.uuid and sb->dev_item.fsid
fields ?

Moreover I suggest to align every value to the right. For example a my
test shows:

bytenr	65536
flags	0x1
magic 	0x4d5f53665248425f (little endian)
fsid	1A:FD:C9:5D:3C:27:43:90:A2:C8:7A:F6:87:C8:82:B1
label
00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
generation	4
root	4214784
sys_array_size	97
chunk_root_generation	2
root_level	0
chunk_root	139264
chunk_root_level	0
log_root	0
log_root_transid	0
log_root_level	0
total_bytes	1073741824


[...]


I think that it could be more readable as

bytenr                                  65536
flags                                     0x1
magic                      0x4d5f53665248425f (little endian)
generation                                  4
root                                  4214784
sys_array_size                             97
chunk_root_generation                       2
root_level                                  0
chunk_root                             139264
chunk_root_level                            0
log_root                                    0
log_root_transid                            0
log_root_level                              0
total_bytes                        1073741824


In order to avoid to check every space, I suggest to change every printf
from

> + printf("dev_item.type\t%llu\n", (unsigned long long)
> +	       btrfs_stack_device_type(&sb->dev_item));

to
   printf("%-50s%20llu\n",
          "dev_item.type",
          (unsigned long long)btrfs_stack_device_type(&sb->dev_item));



BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
