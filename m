Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47693 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752915Ab2GWM33 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 08:29:29 -0400
Message-ID: <500D43A7.1010801@gmx.net>
Date: Mon, 23 Jul 2012 14:29:27 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.07.2012 15:39, Alexander Block wrote:
> Hello all,
> 
> This is the user space side of btrfs send/receive.
> 
> You can apply them manually or use my git repo:
> 
> git://github.com/ablock84/btrfs-progs.git (branch send)
> 
> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
> probably need it if you want to base on the integration branch. I hope this is not
> required in the future when a new integration branch comes out.
> 
> Example usage:
> 
> Multiple snapshots at once:
> btrfs send /mnt/snap[123] > snap123.btrfs

a) Do we really want a single token command here, not
btrfs filesystem send or subvol send?
b) zfs makes sure stdout is not a tty, to prevent flooding
your console. This kinda makes sense.

> 
> Single snapshot with manual parent:
> btrfs send -p /mnt/snap3 /mnt/snap4 > snap4.btrfs
> 
> Receive both streams:
> btrfs receive /mnt2 < snap123.btrfs
> btrfs receive /mnt2 < snap4.btrfs
> 
> (Please give suggestions for a file extension)
> 
> Please read the kernel side email as well, especially the warnings!
> 
> Alex.
> 
> Alexander Block (6):
>   Btrfs-progs: add BTRFS_IOC_SUBVOL_GET/SETFLAGS to ioctl.h
>   Btrfs-progs: update ioctl.h to support clone range ioctl
>   Btrfs-progs: print inode transid and dir item data field in
>     debug-tree
>   Btrfs-progs: update btrfs-progs for subvol uuid+times support
>   Btrfs-progs: update ioctl.h to support btrfs send ioctl
>   Btrfs-progs: add btrfs send/receive commands
> 
>  Makefile       |    7 +-
>  btrfs.c        |    2 +
>  cmds-receive.c |  910 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  cmds-send.c    |  677 +++++++++++++++++++++++++++++++++++++++++
>  commands.h     |    4 +
>  ctree.h        |   40 ++-
>  ioctl.h        |   35 ++-
>  print-tree.c   |   88 ++++--
>  send-stream.c  |  480 ++++++++++++++++++++++++++++++
>  send-stream.h  |   58 ++++
>  send-utils.c   |  337 +++++++++++++++++++++
>  send-utils.h   |   69 +++++
>  send.h         |  132 ++++++++
>  13 files changed, 2815 insertions(+), 24 deletions(-)
>  create mode 100644 cmds-receive.c
>  create mode 100644 cmds-send.c
>  create mode 100644 send-stream.c
>  create mode 100644 send-stream.h
>  create mode 100644 send-utils.c
>  create mode 100644 send-utils.h
>  create mode 100644 send.h
> 

