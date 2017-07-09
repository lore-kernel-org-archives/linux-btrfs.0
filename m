Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40925 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdGIEeS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 00:34:18 -0400
Date: Sat, 8 Jul 2017 21:34:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: 4.11.6 / more corruption / root 15455 has a root item with a more recent gen (33682) compared to the found root node (0)
Message-ID: <20170709043417.GE6704@merlins.org>
References: <20170501170641.GG3516@merlins.org> <20170501180856.GH3516@merlins.org> <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com> <20170502032346.ayhh3n3uh5d5ekbb@merlins.org> <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com> <20170502051155.igmbqcqgzi4ukefg@merlins.org> <20170707053718.GA9735@merlins.org> <20170707053953.GB9735@merlins.org> <20170707093318.GD3224@fnst> <20170707163834.GA6083@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170707163834.GA6083@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sigh,

This is now the 3rd filesystem I have (on 3 different machines) that is
getting corruption of some kind (on 4.11.6).
This is starting to look suspicious :-/

Can I fix this filesystem in some other way?
gargamel:/var/local/scr/host# btrfs check --repair /dev/mapper/crypt_bcache2 
enabling repair mode
Checking filesystem on /dev/mapper/crypt_bcache2
UUID: c4e6f9ca-e9a2-43d7-befa-763fc2cd5a57
checking extents
ref mismatch on [14655689654272 16384] extent item 0, found 1
Backref 14655689654272 parent 15455 root 15455 not found in extent tree
backpointer mismatch on [14655689654272 16384]
owner ref check failed [14655689654272 16384]
repair deleting extent record: key 14655689654272 169 1
adding new tree backref on start 14655689654272 len 16384 parent 0 root 15455
Repaired extent references for 14655689654272
root 15455 has a root item with a more recent gen (33682) compared to the found root node (0)
ERROR: failed to repair root items: Invalid argument

Recreating the filesystem is going to take me a week of work, a lot of if
manual, and I'm not feeling very good with doing this since the backup
server this is a backup of, is also seeing some hopefully minor) problems
too.

I really hope there isn't a new corruption problem in 4.11, because when
I'm getting corruption on my laptop, my backup server, and the backup of my
backup server, I'm starting to run out of redundant backups :(
(and I'm not mentioning all the time this is costing me)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
