Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:32884 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3BHRiV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 12:38:21 -0500
Received: by mail-ee0-f49.google.com with SMTP id d4so2033776eek.36
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 09:38:20 -0800 (PST)
Message-ID: <51153840.1040004@gmail.com>
Date: Fri, 08 Feb 2013 18:39:12 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
References: <1360283822-23452-1-git-send-email-pomac@demius.net> <1360283822-23452-7-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-7-git-send-email-pomac@demius.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2013 01:37 AM, Ian Kumlien wrote:
> the btrfs command now lists:
>     btrfs rescue select-super -s <number> <device>
>         Select a superblock
>     btrfs rescue dump-super <device>
>         Dump a superblock to disk
>     btrfs rescue debug-tree [options] <device>
>         Debug the filesystem
> 
> btrfs-dump-super.c was imported in to cmds-rescue-super-ops.c
> 
> This patch integrates all the functionality...
> 
> cmds-rescue.c is used to glue cmds-rescue-debug-tree.c,
> cmds-rescue-restore.c and cmds-rescue-super-ops.c together to
> make the source files more managable.
[...]
> -int main(int ac, char **av)
> +const char * const cmd_dump_super_usage[] = {
> +	"btrfs rescue dump-super <device>",
> +	"Dump a superblock to disk",
> +	NULL
> +};
[...]
> +int cmd_dump_super(int argc, char **argv)
> +{
> +        int i;
> +
> +        if (argc != 2)
> +                usage(cmd_dump_super_usage);
> +
> +        for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +                u64 bytenr = btrfs_sb_offset(i);
> +                int fd;
> +                struct btrfs_super_block sb;
> +                int block_size = sizeof(struct btrfs_super_block);
> +                char filename[1024];
> +                int bytes_read = read_block(argv[optind], bytenr, &sb);
> +                if (bytes_read < block_size)
> +                        continue;
I think that we should also implement a check of the superblock checksum.

> +
> +                sprintf(filename, "/tmp/block.%s.%llu",
> +                        strrchr(argv[optind], '/') + 1, bytenr);
> +                fd = open(filename, O_CREAT|O_WRONLY, 0644);

This is the part that I don't like. The output file name should be
passed via the command line. It should not be defined by some obscure
logic. The user is able to understand where the sb is written only after.

> +                if (block_size != pwrite(fd, &sb, block_size, 0)) {
> +                        fprintf(stderr, "Failed to dump superblock %d", i);
> +                        continue;
> +                }
> +                fprintf(stderr, "Dumped superblock %s:%d, gen %llu to %s.\n",
> +                        argv[optind], i, sb.generation, filename);
> +                close(fd);
> +        }
[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
