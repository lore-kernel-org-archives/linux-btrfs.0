Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:38250 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946838Ab3BHSHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 13:07:14 -0500
Date: Fri, 8 Feb 2013 19:07:13 +0100
From: Ian Kumlien <pomac@vapor.com>
To: kreijack@inwind.it
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] Btrfs-progs: add the rescue section to btrfs
Message-ID: <20130208180712.GN15780@pomac.netswarm.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-7-git-send-email-pomac@demius.net>
 <51153840.1040004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51153840.1040004@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 06:39:12PM +0100, Goffredo Baroncelli wrote:
> On 02/08/2013 01:37 AM, Ian Kumlien wrote:
> > the btrfs command now lists:
> >     btrfs rescue select-super -s <number> <device>
> >         Select a superblock
> >     btrfs rescue dump-super <device>
> >         Dump a superblock to disk
> >     btrfs rescue debug-tree [options] <device>
> >         Debug the filesystem
> > 
> > btrfs-dump-super.c was imported in to cmds-rescue-super-ops.c
> > 
> > This patch integrates all the functionality...
> > 
> > cmds-rescue.c is used to glue cmds-rescue-debug-tree.c,
> > cmds-rescue-restore.c and cmds-rescue-super-ops.c together to
> > make the source files more managable.
> [...]
> > -int main(int ac, char **av)
> > +const char * const cmd_dump_super_usage[] = {
> > +	"btrfs rescue dump-super <device>",
> > +	"Dump a superblock to disk",
> > +	NULL
> > +};
> [...]
> > +int cmd_dump_super(int argc, char **argv)
> > +{
> > +        int i;
> > +
> > +        if (argc != 2)
> > +                usage(cmd_dump_super_usage);
> > +
> > +        for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> > +                u64 bytenr = btrfs_sb_offset(i);
> > +                int fd;
> > +                struct btrfs_super_block sb;
> > +                int block_size = sizeof(struct btrfs_super_block);
> > +                char filename[1024];
> > +                int bytes_read = read_block(argv[optind], bytenr, &sb);
> > +                if (bytes_read < block_size)
> > +                        continue;
> I think that we should also implement a check of the superblock checksum.
> 
> > +
> > +                sprintf(filename, "/tmp/block.%s.%llu",
> > +                        strrchr(argv[optind], '/') + 1, bytenr);
> > +                fd = open(filename, O_CREAT|O_WRONLY, 0644);
> 
> This is the part that I don't like. The output file name should be
> passed via the command line. It should not be defined by some obscure
> logic. The user is able to understand where the sb is written only after.

This is only the import of the command, we can add anything we want
after that.

Josef also said that it could use some better usability - right now it's
only there since the functionality is good to have when <something> hits
the fan =)

> > +                if (block_size != pwrite(fd, &sb, block_size, 0)) {
> > +                        fprintf(stderr, "Failed to dump superblock %d", i);
> > +                        continue;
> > +                }
> > +                fprintf(stderr, "Dumped superblock %s:%d, gen %llu to %s.\n",
> > +                        argv[optind], i, sb.generation, filename);
> > +                close(fd);
> > +        }
> [...]
> 
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
