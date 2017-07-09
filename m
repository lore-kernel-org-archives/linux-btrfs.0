Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42944 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdGIGe3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 02:34:29 -0400
Date: Sat, 8 Jul 2017 23:34:24 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <20170709063424.7ixzjkwkgrzmobiy@merlins.org>
References: <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
 <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com>
 <20170502051155.igmbqcqgzi4ukefg@merlins.org>
 <20170707053718.GA9735@merlins.org>
 <20170707053953.GB9735@merlins.org>
 <20170707093318.GD3224@fnst>
 <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170709043417.GE6704@merlins.org>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a
 more recent gen (33682) compared to the found root node (0)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 08, 2017 at 09:34:17PM -0700, Marc MERLIN wrote:
> Sigh,
> 
> This is now the 3rd filesystem I have (on 3 different machines) that is
> getting corruption of some kind (on 4.11.6).
> This is starting to look suspicious :-/
> 
> Can I fix this filesystem in some other way?
> gargamel:/var/local/scr/host# btrfs check --repair /dev/mapper/crypt_bcache2 
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_bcache2
> UUID: c4e6f9ca-e9a2-43d7-befa-763fc2cd5a57
> checking extents
> ref mismatch on [14655689654272 16384] extent item 0, found 1
> Backref 14655689654272 parent 15455 root 15455 not found in extent tree
> backpointer mismatch on [14655689654272 16384]
> owner ref check failed [14655689654272 16384]
> repair deleting extent record: key 14655689654272 169 1
> adding new tree backref on start 14655689654272 len 16384 parent 0 root 15455
> Repaired extent references for 14655689654272
> root 15455 has a root item with a more recent gen (33682) compared to the found root node (0)
> ERROR: failed to repair root items: Invalid argument

Mmmh, actually to be fair, this was the 2nd run, I didn't scroll back
enough and missed the first run (doing too many recoveries at once,
I'm getting mixed up).
This first run looks like a lot more things happened:
http://marc.merlins.org/tmp/btrfs_check_ds5.txt

The amount of things that went wrong here are very worrisome, given that
there were no issues with those drives and that array has been working
for over a year without problems, until I recently upgraded to 4.11 :(

Now mind you, despite the 21MB of things that got fixed, I still kind of
have the expectation that btrfs check --repairs continues and fixes
everything until the filesystem is clean again, just like e2fsck -f
would, but I understand that this filesystem somehow got corrupted to a
point that it's maybe not that simple to do so.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
