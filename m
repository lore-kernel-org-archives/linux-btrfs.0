Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56564 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2F0CQg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 22:16:36 -0400
Message-ID: <4FEA6F23.3020600@cn.fujitsu.com>
Date: Wed, 27 Jun 2012 10:25:39 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] introduce btrfs filesystem property command
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/25/2012 05:20 AM, Alexander Block wrote:

> This patchset introduces the btrfs filesystem property command. It is the
> result of a discussion we had on IRC. I tried to make the properties
> interface as generic and extensible as possible. Comments are welcome.
> 
> Currently the command looks like this:
> btrfs fi prop /path/to/object [name[=value]]
> 
> Some people may prefer other forms. For example I got suggestions for
> these forms:
> btrfs set/get /path/to/object [name [value]]
> btrfs prop /pach/to/object [name[=value]] (and also without the =)
> 
> I'm open to more suggestions and a discussion on this. I'm definitely
> for removing the fi[lesystem] prefix but I'm neutral to the other 
> suggestions made so far.
> 
> For now, I've implemented three properties:
> 1. read-only. Usable on subvolumes to toggle the read-only flags.
> 2. label. I looked through btrfs to find good examples of things that
>    could be moved to the new properties interface and the filesystem
>    label looked like a good one. There are for sure more, but that is
>    something for later (and maybe for someone else). I would suggest 
>    to move everthing that makes sense over to the props interface and 
>    mark the old interfaces as deprecated. Comments on this are welcome.
> 


Hi Alex,

Thanks for doing these!

I'm doing something similar to yours, but I prefer keeping these prefixes and making some
efforts to enhance original APIs:

For subvolume, right now we can have two attributes: readonly and default, and let 'btrfs sub list'
work just like 'ls' so that we can get their attributes easier:

o       btrfs subvolume list [-p] path
        subvol (Default)
        snap (Readonly)

o       btrfs subvolume list [-p] path/subvol
        subvol (Default)

o       btrfs subvolume list [-p] path/snap
        snap (Readonly)


how about this?

thanks,
liubo

> Alex.
> 
> Alexander Block (5):
>   Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
>   Btrfs-progs: move skip_prefix and prefixcmp to utils.c
>   Btrfs-progs: let get_label return the label instead of of printing it
>   Btrfs-progs: make filesystem_cmd_group non const
>   Btrfs-progs: introduce btrfs filesystem property command
> 
>  Makefile          |    3 +-
>  btrfs.c           |   19 +--
>  btrfslabel.c      |   13 +-
>  btrfslabel.h      |    4 +-
>  cmds-filesystem.c |  115 +++++++++++++-
>  commands.h        |    9 +-
>  help.c            |    2 +
>  ioctl.h           |    2 +
>  props.c           |  460 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  props.h           |   45 ++++++
>  utils.c           |   15 ++
>  utils.h           |    3 +
>  12 files changed, 659 insertions(+), 31 deletions(-)
>  create mode 100644 props.c
>  create mode 100644 props.h
> 


