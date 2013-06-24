Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36824 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3FXQ2u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 12:28:50 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8898C7C041C
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 10:28:50 -0600 (MDT)
Date: Mon, 24 Jun 2013 12:28:48 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
CC: Linux BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: help: btrfs bad tree block start
Message-ID: <20130624162848.GK4288@localhost.localdomain>
References: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 23, 2013 at 05:33:59AM +0200, Andrea Gelmini wrote:
> Hi everybody,
>    and thanks a lot for your work.
> 
>    I have this problem.
>    With latest 3.9 kernel and btrfs-next I was close to full my home.
>    The system went read only mode while I was copying in some files.
> 
>    Everything was good. I can't write, but I can read and copy last files.
> 
>    Then I rebooted, but since that moment I cannot mount.
> 
>    The kernel complain is:
> 
> [ 1026.226883] device label 16K devid 1 transid 66906 /dev/mapper/glen-home
> [ 1026.227452] btrfs: disk space caching is enabled
> [ 1026.311650] Btrfs detected SSD devices, enabling SSD mode
> [ 1026.311825] btrfs bad tree block start 4262492213953725727 591596257280
> [ 1026.312000] btrfs bad tree block start 4262492213953725727 591596257280
> [ 1026.312010] btrfs: failed to read log tree
> [ 1026.332708] btrfs: open_ctree failed
> 
>    If I use btrfsck (Joseph one) I got this:
> 
> root@glen:/home/gelma/dev/prg/btrfs_josef# ./btrfsck --repair
> /dev/mapper/glen-home enabling repair mode
> Check tree block failed, want=591596257280, have=4262492213953725727
> Check tree block failed, want=591596257280, have=4262492213953725727
> Check tree block failed, want=591596257280, have=4262492213953725727
> Check tree block failed, want=591596257280, have=4262492213953725727
> Check tree block failed, want=591596257280, have=4262492213953725727
> read block failed check_tree_block
> Checking filesystem on /dev/mapper/glen-home
> UUID: 920ae0b9-55da-4606-af40-b58493c7882b
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 127643191167 bytes used err is 0
> total csum bytes: 355191196
> total tree bytes: 2457419776
> total fs tree bytes: 1832763392
> total extent tree bytes: 195133440
> btree space waste bytes: 472140292
> file data blocks allocated: 1525241155584
>  referenced 396208013312
> Btrfs v0.20-rc1
> 
>    The home partition is 352,70 GiB.
> 
>    I've got backup, but I would like to recover it.
> 

So it looks like you just have a few transid mismatches but we manage to find
something that works out just fine.  Could you make an image of this fs for me
and upload it somewhere so I can pull it down and run some stuff on it?  I've
been toying with making fsck just re-write transid mismatched blocks if we
manage to put together the file system properly and I'd like to experiment with
this on your fs so maybe we can put it back together without you having to
restore from backups.  Thanks,

Josef
