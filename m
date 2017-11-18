Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46082 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161234AbdKRQeR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 11:34:17 -0500
Date: Sat, 18 Nov 2017 08:34:04 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20171118163404.u434t6afi7ghns57@merlins.org>
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
 <20171117073046.ehdlw5essf7lhw7k@merlins.org>
 <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
 <20171117155009.po4wxaqlyqnzqpom@merlins.org>
 <46fbd8c2-65f1-b281-7e17-2253f6dc3aa9@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46fbd8c2-65f1-b281-7e17-2253f6dc3aa9@gmx.com>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered,
 value -17
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 18, 2017 at 08:16:32AM +0800, Qu Wenruo wrote:
> >         item 27 key (1919785864 DIR_ITEM 2591417872) itemoff 14637 itemsize 46
> >                 location key (1919805647 INODE_ITEM 0) type FILE
> >                 transid 2231988 data_len 0 name_len 16
> >                 name: 1955-capture.jpg
> 
> OK, this DIR_ITEM matches with INODE_REF.
> So btrfs-check should only need to insert DIR_INDEX for it.
> > 
> >> Although what we could try is to avoid BUG_ON(), but I'm afraid the
> >> problem is more severe than my expectation.
> >  
> > How does it look now?
> 
> At least we know what btrfs check should do.
> I could dig it a little deeper to see if we could fix it.
> (Or something strange happened again)

Thanks for having had a look, hopefully it helps improving btrfs check,
thanks for getting the info and getting it turned into better code :)

In the meantime this was an easy FS to just wipe and start over with, so
I just did that.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
