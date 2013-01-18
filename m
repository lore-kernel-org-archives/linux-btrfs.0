Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:40486 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3ARPdT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 10:33:19 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130118153319.GQHJ2891.eastrmfepo101.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 18 Jan 2013 10:33:19 -0500
Message-ID: <50F96B3E.6000507@czarc.net>
Date: Fri, 18 Jan 2013 10:33:18 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
References: <20130117174721.GD22785@twin.jikos.cz>
In-Reply-To: <20130117174721.GD22785@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/17/2013 12:47 PM, David Sterba wrote:
> Hi Chris,
>
> please pull a few more fixes to the 0.20-rc series. I have reviewed and
> verified them where possible. There are the long awaited ARM fixes, help
> updates and unsorted code fixes.
>
>    git://repo.or.cz/btrfs-progs-unstable/devel.git for-chris
>
> Based on top of master commit
> 91d9eec1ff044394f2b98ee7fcb76713dd33b994
>
> Thanks.
> david
>
> ---
>   btrfs-list.c      |   69 +++++++++++++++++++++++++-----------------------------
>   btrfsck.c         |    3 +-
>   cmds-filesystem.c |   26 --------------------
>   cmds-inspect.c    |    5 ++-
>   cmds-receive.c    |    4 ++-
>   cmds-scrub.c      |    4 ++-
>   cmds-send.c       |    9 ++++++-
>   convert.c         |    5 +++
>   ctree.h           |    8 ++++--
>   debug-tree.c      |   10 +++++++
>   disk-io.c         |   13 ++++++++--
>   kerncompat.h      |   12 +++++++++
>   man/btrfs.8.in    |    4 ---
>   mkfs.c            |   35 ++-------------------------
>   restore.c         |    7 +++--
>   utils.c           |   48 +++++++++++++++++++++++++++++++++++++
>   utils.h           |    2 +
>   version.sh        |    2 -
>   volumes.c         |    8 +++---
>   19 files changed, 159 insertions(+), 115 deletions(-)
> ---
> Alex Lyakas (1):
>        btrfs-progs: Receive: preserve ownership for symlinks, by using 'lchown'
>
> Arne Jansen (1):
>        Btrfs-progs: fix unaligned accesses
>
> David Sterba (2):
>        btrfs-progs: do not send stream into a terminal
>        btrfs-progs: ignore -a option in mkfs
>
> Goffredo Baroncelli (3):
>        Move parse_size() to utils.[hc]
>        parse_size(): replace atoll() with strtoull()
>        parse_size(): add new suffixes
>
> Kenji Okimoto (3):
>        btrfs-progs: plug a memory leak reported by cppcheck
>        btrfs-progs: check malloc() result
>        btrfs-progs: plug memory leaks in btrfs_scan_one_dir() reported by cppcheck.
>
> Lluis Batlle i Rossell (1):
>        btrfs-progs: Fix getopt on arm platforms
>
> Sergei Trofimovich (1):
>        version.sh: fix version when built from tarball
>
> Simon Xu (2):
>        btrfs-progs: remove "device show" from btrfs man page
>        btrfs-progs: remove '-h' from btrfs man page
>
> Wade Cline (1):
>        Btrfs-progs: Fix compiler warnings on PPC64
>
> Wang Sheng-Hui (3):
>        btrfs-progs: add -V description in print_usage
>        btrfs-progs: update usage description for debug-tree.c
>        btrfs-progs: print the right mount checking info in restore.c
>
> Zach Brown (1):
>        btrfs-progs: fix 32bit int/pointer cast warnings
>

David, first of all let me thank you for pulling these together.  I do 
not believe I am alone in wondering what was happening to the 
btrfs-progs patches on the mailing list.

I would like to recommend some additional patches for inclusion since 
they are currently part of the Fedora 18 btrfs-tools package.

Josef Bacik:  detect if the disk we are formatting is a ssd V2
http://article.gmane.org/gmane.comp.file-systems.btrfs/18749

This one may be a little more of a problem since the suggested man 
update is missing and there is a second part for the kernel (status 
unknown).
Josef Bacik:  add btrfs device ready command
http://article.gmane.org/gmane.comp.file-systems.btrfs/18129
Since Fedora uses a "stock" a kernel as possible, I suspect the 
corresponding patch is applied.

There are two or three other patches that appear to make sense but I 
have no idea if they have been submitted.

Gene
