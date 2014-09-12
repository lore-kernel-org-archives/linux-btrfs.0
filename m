Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44936 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752237AbaILIe1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 04:34:27 -0400
Message-ID: <1410510831.21185.13.camel@localhost.localdomain>
Subject: Re: [PATCH v2] btrfs-progs: deal with conflict options for btrfs fi
 show
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Date: Fri, 12 Sep 2014 16:33:51 +0800
In-Reply-To: <54128AF5.8080202@jp.fujitsu.com>
References: <1410412751-9277-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1410484541-16422-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <54128AF5.8080202@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-09-12 at 14:56 +0900, Satoru Takeuchi wrote:
> Hi Gui,
> 
> (2014/09/12 10:15), Gui Hecheng wrote:
> > For btrfs fi show, -d|--all-devices & -m|--mounted will
> > overwrite each other, so if specified both, let the user
> > know that he should not use them at the same time.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> > changelog:
> > 	v1->v2: add option conflict descriptions to manpage and usage.
> > ---
> >   Documentation/btrfs-filesystem.txt |  9 ++++++---
> >   cmds-filesystem.c                  | 12 ++++++++++--
> >   2 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
> > index c9c0b00..d3d2dcc 100644
> > --- a/Documentation/btrfs-filesystem.txt
> > +++ b/Documentation/btrfs-filesystem.txt
> > @@ -20,15 +20,18 @@ SUBCOMMAND
> >   *df* <path> [<path>...]::
> >   Show space usage information for a mount point.
> >   
> > -*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
> > +*show* [-m|--mounted|-d|--all-devices|<path>|<uuid>|<device>|<label>]::
> 
> This line seems to be too long. Please see also the
> following thread.
> 
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg36270.html
> 

Hi Satoru,

Ah, there is a patch that is changing the same document before but not
merged yet. So I think I will rebase my "additional words" about the
"option conflict" after the former patch merged.
----------------------------------------------------------------------
Hi David,
Sorry to bother, would you please give a glance at the v1 patch and
ignore this v2 first. And I will add the "option conflict" stuff in
another patch after the former path below merged. Is that OK?

https://patchwork.kernel.org/patch/4711831/

-Gui

> Thanks,
> Satoru
> 
> 
> >   Show the btrfs filesystem with some additional info.
> >   +
> >   If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
> >   information of all the btrfs filesystem both mounted and unmounted.
> > -If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
> > +If '-m|--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
> >   filesystem(s);
> > -If '--all-devices' is passed, all the devices under /dev are scanned;
> > +If '-d|--all-devices' is passed, all the devices under /dev are scanned;
> >   otherwise the devices list is extracted from the /proc/partitions file.
> > +Don't combine -m|--mounted and -d|--all-devices, because these two options
> > +will overwrite each other, and only one scan way will be adopted,
> > +probe the kernel to scan or scan devices under /dev.
> >   
> >   *sync* <path>::
> >   Force a sync for the filesystem identified by <path>.
> > diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> > index 69c1ca5..51c4c55 100644
> > --- a/cmds-filesystem.c
> > +++ b/cmds-filesystem.c
> > @@ -495,6 +495,7 @@ static const char * const cmd_show_usage[] = {
> >   	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
> >   	"-m|--mounted       show only mounted btrfs",
> >   	"If no argument is given, structure of all present filesystems is shown.",
> > +	"Don't combine -d|--all-devices and -m|--mounted, refer to manpage for details.",
> >   	NULL
> >   };
> >   
> > @@ -526,16 +527,23 @@ static int cmd_show(int argc, char **argv)
> >   			break;
> >   		switch (c) {
> >   		case 'd':
> > -			where = BTRFS_SCAN_PROC;
> > +			where &= ~BTRFS_SCAN_LBLKID;
> > +			where |= BTRFS_SCAN_PROC;
> >   			break;
> >   		case 'm':
> > -			where = BTRFS_SCAN_MOUNTED;
> > +			where &= ~BTRFS_SCAN_LBLKID;
> > +			where |= BTRFS_SCAN_MOUNTED;
> >   			break;
> >   		default:
> >   			usage(cmd_show_usage);
> >   		}
> >   	}
> >   
> > +	if ((where & BTRFS_SCAN_PROC) && (where & BTRFS_SCAN_MOUNTED)) {
> > +		fprintf(stderr, "Don't use -d|--all-devices and -m|--mounted options at the same time.\n");
> > +		usage(cmd_show_usage);
> > +	}
> > +
> >   	if (check_argc_max(argc, optind + 1))
> >   		usage(cmd_show_usage);
> >   
> > 
> 


