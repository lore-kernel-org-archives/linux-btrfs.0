Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38118 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933991AbdKQHay (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 02:30:54 -0500
Date: Thu, 16 Nov 2017 23:30:46 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20171117073046.ehdlw5essf7lhw7k@merlins.org>
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171117061707.geqtk3ydj2elv4o7@merlins.org>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered,
 value -17
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's the whole output:
gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 1919805647
                location key (1919805647 INODE_ITEM 0) type FILE
        item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 160
        item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 itemsize 26
        item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize 53
parent transid verify failed on 1173964603392 wanted 2244945 found 2247404
parent transid verify failed on 1173964603392 wanted 2244945 found 2247404
parent transid verify failed on 1173964603392 wanted 2244945 found 2247404
parent transid verify failed on 1173964603392 wanted 2244945 found 2247404
Ignoring transid failure
parent transid verify failed on 1652248100864 wanted 2245186 found 2247494
parent transid verify failed on 1652248100864 wanted 2245186 found 2247494
parent transid verify failed on 1652248100864 wanted 2245186 found 2247494
parent transid verify failed on 1652248100864 wanted 2245186 found 2247494
Ignoring transid failure
parent transid verify failed on 1174605512704 wanted 2245171 found 2247435
parent transid verify failed on 1174605512704 wanted 2245171 found 2247435
parent transid verify failed on 1174605512704 wanted 2245171 found 2247435
parent transid verify failed on 1174605512704 wanted 2245171 found 2247435
Ignoring transid failure
WARNING: eb corrupted: item 130 eb level 0 next level 2, skipping the rest


On Thu, Nov 16, 2017 at 10:17:07PM -0800, Marc MERLIN wrote:
> On Fri, Nov 17, 2017 at 01:17:19PM +0800, Qu Wenruo wrote:
> > 
> > 
> > On 2017年11月17日 10:26, Marc MERLIN wrote:
> > > Howdy,
> > > 
> > > Up to date git pull from btrfs-progs:
> > > 
> > > gargamel:~# btrfs check --repair /dev/mapper/raid0d1
> > > enabling repair mode
> > > Checking filesystem on /dev/mapper/raid0d1
> > > UUID: 01334b81-c0db-4e80-92e4-cac4da867651
> > > checking extents
> > > corrupt extent record: key 203003699200 168 40960
> > > corrupt extent record: key 203003764736 168 172032
> > > ref mismatch on [203003699200 40960] extent item 0, found 1
> > > Data backref 203003699200 root 258 owner 1933897829 offset 0 num_refs 0 not found in extent tree
> > > Incorrect local backref count on 203003699200 root 258 owner 1933897829 offset 0 found 1 wanted 0 back 0x5596988c2130
> > > backpointer mismatch on [203003699200 40960]
> > > repair deleting extent record: key 203003699200 168 40960
> > > adding new data backref on 203003699200 root 258 owner 1933897829 offset 0 found 1
> > > Repaired extent references for 203003699200
> > > Data backref 203003764736 root 258 owner 1932315368 offset 0 num_refs 0 not found in extent tree
> > > Incorrect local backref count on 203003764736 root 258 owner 1932315368 offset 0 found 1 wanted 0 back 0x5596dde358f0
> > > backpointer mismatch on [203003764736 172032]
> > > repair deleting extent record: key 203003764736 168 172032
> > > adding new data backref on 203003764736 root 258 owner 1932315368 offset 0 found 1
> > > Repaired extent references for 203003764736
> > > Fixed 0 roots.
> > > checking free space cache
> > > cache and super generation don't match, space cache will be invalidated
> > > checking fs roots
> > > invalid location in dir item 0
> > > Deleting bad dir index [1919785864,96,1958] root 258
> > > Deleting bad dir index [1919785864,96,1957] root 258
> > > repairing missing dir index item for inode 1919805647
> > > cmds-check.c:2614: add_missing_dir_index: BUG_ON `ret` triggered, value -17
> > 
> > -EEXIST. Btrfs check --repair is trying to re-insert some key which
> > exists already.
> > 
> > Would you please provide the output of "btrfs-debug-tree -t 258 | grep
> > 1919805647" to help the debugging?
>  
> Sure. It may run all night and I'm going to bed now, but the output I
> got so far, is:
> gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 1919805647
>                 location key (1919805647 INODE_ITEM 0) type FILE
>         item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 160
>         item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 itemsize 26
>         item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize 53
> (...)
> 
> I'll post tomorrow if I get more overnight
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
