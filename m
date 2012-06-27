Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:59941 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2F0RlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 13:41:09 -0400
Message-ID: <4FEB45CC.5010706@libero.it>
Date: Wed, 27 Jun 2012 19:41:32 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCHv2 0/3] Btrfs-progs: introduce btrfs property subgroup
References: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340803011-21882-1-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,

On 06/27/2012 03:16 PM, Alexander Block wrote:
> This patchset introduces the btrfs property subgroup. It is the
> result of a discussion we had on IRC. I tried to make the properties
> interface as generic and extensible as possible. Comments are welcome.
> 
> Currently the command group looks like this:
> btrfs prop set [-t <type>] /path/to/object <name> <value>
> btrfs prop get [-t <type>] /path/to/object [<name>] (omitting name dumps all)
> btrfs prop list [-t <type>] /path/to/object (lists properties with description)
> 
> The type is used to explicitly specify what type of object you mean. This is 
> necessary in case the object+property combination is ambiguous.  For example
> '/path/to/fs/root' could mean the root subvolume, the directory inode or the 
> filesystem itself. Normally, btrfs-progs will try to detect the type 
> automatically.


Instead of using

   btrfs prop set -t filesystem ....
   btrfs prop set -t subvolume ....
   btrfs prop set -t inode ....

what about

   btrfs filesystem prop set .....
   btrfs subvolume prop set .....
   btrfs inode prop set .....

?

btrfs has already grouped the commands by "category" (even tough I have
to admit that some command doesn't fit its group. Why do not use this
instead of "-t <object type>". If we need new type we could create it on
demand...

> 
> David suggested that it should also be possible to specify objects by
> their id/uuid/fsid. I like that idea, but would be happy if someone else
> could take over that part :)

This proposal makes sense.
> 
> For now, I've implemented two properties:
> 1. read-only. Usable on subvolumes to toggle the read-only flags.
> 2. label. I looked through btrfs to find good examples of things that
>    could be moved to the new properties interface and the filesystem
>    label looked like a good one. There are for sure more, but that is
>    something for later (and maybe for someone else). I would suggest 
>    to move everthing that makes sense over to the props interface and 
>    mark the old interfaces as deprecated. Comments on this are welcome.

What is the suppose goal/benefit/advantage to switch to a new interface
? Really, it is a true question.

> 
> Patch version history:
> v1
>   Initial version.
> v2
>   - Removed the filesystem prefix and implemented it as new command group
>   - Switched from the <name>[=<value>] form to the set/get <name> [<value>] 
>     form.
>   - Removed patches "Btrfs-progs: make filesystem_cmd_group non const"
>     and "Btrfs-progs: move skip_prefix and prefixcmp to utils.c". They
>     are not needed anymore due to the 'btrfs prop list' command.
>   - Udjusted the subvol flags patch to be compatible to the "Btrfs: use 
>     _IOR for BTRFS_IOC_SUBVOL_GETFLAGS" patch.
>   - Using -t <type> instead of <type>: prefix now.
>   - Changes are based on feedback from Ilya and David.
> 
> Alex.
> 
> Alexander Block (3):
>   Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
>   Btrfs-progs: let get_label return the label instead of of printing it
>   Btrfs-progs: introduce btrfs property subgroup
> 
>  Makefile          |    5 +-
>  btrfs.c           |    1 +
>  btrfslabel.c      |   13 +-
>  btrfslabel.h      |    4 +-
>  cmds-filesystem.c |   14 +-
>  cmds-property.c   |  459 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  commands.h        |    2 +
>  ioctl.h           |    2 +
>  props.c           |  114 +++++++++++++
>  props.h           |   43 +++++

Please update the man page too... This could help the process of
creating a new interface.

>  10 files changed, 645 insertions(+), 12 deletions(-)
>  create mode 100644 cmds-property.c
>  create mode 100644 props.c
>  create mode 100644 props.h
> 

