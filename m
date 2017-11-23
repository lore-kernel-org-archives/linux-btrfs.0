Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52025 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752948AbdKWTZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 14:25:47 -0500
Date: Thu, 23 Nov 2017 20:23:51 +0100
From: David Sterba <dsterba@suse.cz>
To: "John L. Center" <jlcenter15@gmail.com>
Cc: Uli Heller <uli.heller@daemons-point.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-4.13: cmds-inspect-tree-stats.h: No such file or
 directory
Message-ID: <20171123192351.GU3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <8fab0623-c8ad-ade0-fde7-382742c801bf@daemons-point.com>
 <4f52f934-6bbd-88db-e915-7b1a9e079e4f@gmail.com>
 <b354680c-5ceb-0e39-f4b6-8d01071e7ec8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b354680c-5ceb-0e39-f4b6-8d01071e7ec8@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 22, 2017 at 11:20:52PM -0500, John L. Center wrote:
> On 11/22/2017 11:15 PM, John L. Center wrote:
> > On 09/09/2017 01:48 AM, Uli Heller wrote:
> >> I dowloaded the btrfs-progs-v4.13.tar.xz tarball and tried to build it.
> >> Unfortunately, I get an error about cmds-inspect-tree-stats.h. The 
> >> file seems
> >> to be missing from the tarball, it used to exist in v4.12.
> >>
> >> ...
> >> true -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
> >> -Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
> >> -include .cc-defines.h -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise 
> >> -Wuninitialized -Wshadow -Wundef -U_FORTIFY_SOURCE btrfs-calc-size.c
> >>      [CC]     btrfs-calc-size.o
> >> gcc -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
> >> -Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
> >> -c btrfs-calc-size.c -o btrfs-calc-size.o  \
> >>
> >> btrfs-calc-size.c:22:37: fatal error: cmds-inspect-tree-stats.h: No 
> >> such file or directory
> >>   #include "cmds-inspect-tree-stats.h"
> >>                                       ^
> >>
> >> $ LANG=C ls -l btrfs-progs-v4.12/cmds-inspect-tree-stats.h 
> >> btrfs-progs-v4.13/cmds-inspect-tree-stats.h
> >> ls: cannot access btrfs-progs-v4.13/cmds-inspect-tree-stats.h: No such 
> >> file or directory
> >> -rw-rw-r-- 1 uli uli 905 Jul 28 15:29 
> >> btrfs-progs-v4.12/cmds-inspect-tree-stats.h
> >>
> > The issue exists in the new btrfs-progs-v4.14.tar.gz, also.
> > 
> I forgot to mention, it was in btrfs-show-super.c.

Fixed in devel, thanks.
