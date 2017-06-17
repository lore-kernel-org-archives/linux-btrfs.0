Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:45773 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdFQIbE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 04:31:04 -0400
Date: Sat, 17 Jun 2017 10:30:58 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170617083058.7z67mw4622oa7ajo@angband.pl>
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 17, 2017 at 03:43:18PM +0800, Qu Wenruo wrote:
> On 2017年06月16日 20:33, David Sterba wrote:
> > I see a lot of warnings from btrfs/094
> > 
> > [13458.628334] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=581632 phys=13078528 len=4096 flags=0x800
> 
> Strangely, I can't reproduce it either on my original branch (v4.12 with
> this patch), or torvalds/master (this patch is already merged with your
> renaming)

I for one get this a lot even in regular use.  Somehow, it always has Comm:
dpkg, despite the vast majority of activity on the system obviously not
being dpkg.

> However I tried all btrfs/09*,  nothing happened.
> 
> Is some other out-of-tree patch causing the problem?
> If so, which branch are you testing? I think I could help to fix it.

For me, linus/master with a handful of not possibly relevant patches
(in fs/btrfs/ I have dedupe and defrag on files opened ro, raid5/6 warning,
raid5/6 incompat flag clearing).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
