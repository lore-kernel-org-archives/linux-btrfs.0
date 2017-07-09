Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41400 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdGIFFk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 01:05:40 -0400
Date: Sat, 8 Jul 2017 22:05:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: We really need a better/working btrfs check --repair
Message-ID: <20170709050538.GF6704@merlins.org>
References: <20170501180856.GH3516@merlins.org> <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com> <20170502032346.ayhh3n3uh5d5ekbb@merlins.org> <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com> <20170502051155.igmbqcqgzi4ukefg@merlins.org> <20170707053718.GA9735@merlins.org> <20170707053953.GB9735@merlins.org> <20170707093318.GD3224@fnst> <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170709043417.GE6704@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+Chris

On Sat, Jul 08, 2017 at 09:34:17PM -0700, Marc MERLIN wrote:
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

On this note, getting hit 3 times on 3 different filesystems, that are not
badly damaged, but in none of those caess can btrfs check --repair put them
in a working state, is really bringing home the problem with lack of proper
fsck.

I understand that some errors are hard to fix without unknown data loss, but
btrfs check --repair should just do what it takes to put the filesystem back
into a consistent state, never mind what data is lost.
Restoring 10 to 20TB of data is getting old and is not really an acceptable
answer as the only way out.
I should not have to recreate a filesystem as the only way to bring it back
to a working state. 

Before Duncan tells me my filesystem is too big, and I should keep to very
small filesystems so that it's less work for each time btrfs gets corrupted
again, and fails again to bring back the filesystem to a usable state after
discarding some data, that's just not an acceptable answer long term, and by
long term honestly I mean now.
I just have data that doesn't segment well and the more small filesystems I
make the more time I'm going to waste managing them all and dealing with
which one gets full first :(

So, whether 4.11 has a corruption problem, or not, please put some resources
behind btrfs check --repair, be it the lowmem mode, or not.

Thank you
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
