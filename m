Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60959 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755342AbdKQC0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 21:26:19 -0500
Date: Thu, 16 Nov 2017 18:26:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value -17
Message-ID: <20171117022615.GO10969@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

Up to date git pull from btrfs-progs:

gargamel:~# btrfs check --repair /dev/mapper/raid0d1
enabling repair mode
Checking filesystem on /dev/mapper/raid0d1
UUID: 01334b81-c0db-4e80-92e4-cac4da867651
checking extents
corrupt extent record: key 203003699200 168 40960
corrupt extent record: key 203003764736 168 172032
ref mismatch on [203003699200 40960] extent item 0, found 1
Data backref 203003699200 root 258 owner 1933897829 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 203003699200 root 258 owner 1933897829 offset 0 found 1 wanted 0 back 0x5596988c2130
backpointer mismatch on [203003699200 40960]
repair deleting extent record: key 203003699200 168 40960
adding new data backref on 203003699200 root 258 owner 1933897829 offset 0 found 1
Repaired extent references for 203003699200
Data backref 203003764736 root 258 owner 1932315368 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 203003764736 root 258 owner 1932315368 offset 0 found 1 wanted 0 back 0x5596dde358f0
backpointer mismatch on [203003764736 172032]
repair deleting extent record: key 203003764736 168 172032
adding new data backref on 203003764736 root 258 owner 1932315368 offset 0 found 1
Repaired extent references for 203003764736
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
invalid location in dir item 0
Deleting bad dir index [1919785864,96,1958] root 258
Deleting bad dir index [1919785864,96,1957] root 258
repairing missing dir index item for inode 1919805647
cmds-check.c:2614: add_missing_dir_index: BUG_ON `ret` triggered, value -17
btrfs(+0x52207)[0x55966a6fa207]
btrfs(+0x5225a)[0x55966a6fa25a]
btrfs(+0x5cef3)[0x55966a704ef3]
btrfs(cmd_check+0x2e10)[0x55966a70ea35]
btrfs(main+0x85)[0x55966a6b9dc3]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f794aadf2b1]
btrfs(_start+0x2a)[0x55966a6b993a]
Aborted

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
