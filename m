Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37225 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaKCTsi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 14:48:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlNcC-0007vK-Nv
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 20:48:36 +0100
Received: from hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de ([149.172.191.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 20:48:36 +0100
Received: from mailinglists by hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 20:48:36 +0100
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Re: Can't mount: open_ctree failed!
Date: Mon, 03 Nov 2014 20:48:24 +0100
Message-ID: <m38m68$m5j$1@ger.gmane.org>
References: <m35i04$u5p$1@ger.gmane.org> <55F19B93-4AF2-4A43-82D5-425433DF006B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:

> 
> On Nov 2, 2014, at 8:18 AM, Florian Lindner <mailinglists@xgm.de> wrote:
> 
>> Hello,
>> 
>> all after sudden I can't mount my btrfs home partition anymore. System is
>> Arch with kernel 3.17.2, but I use snapper which does snapshopts
>> regularly and I had 3.17.1 before, which afaik had some problems with
>> snapshops.
> 
> It was with creating read-only snapshots. I forget if snapper's snapshots
> are ro. If they are then you need to use 3.17 btrfs-progs to fix it.
> 
> 
>> # btrfsck --init-extent-tree /dev/sdb1
>> root 3377 has a root item with a more recent gen (8589934592) compared to
>> the found root node (49443)
>> 
>> # btrfsck --init-csum-tree /dev/sdb1
>> Creating a new CRC tree
>> root 3377 has a root item with a more recent gen (8589934592) compared to
>> the found root node (49443)
> 
> Did you use btrfs-image before using --repair?
> 
> Once you've done an init-extent-tree and it still won't mount, you're
> almost certainly in btrfs restore territory. Get the data out while you
> still can. And then you can check the recent patches from Josef for fsck
> that aren't yet in btrfs-progs 3.17. I'm not sure if they're in David's
> master branch, worth checking. There's a good chance it won't make things
> worse, might even fix the file system, but there's a fair chance it'll
> totally toast it. So definitely btrfs restore important stuff first.

Ok, problem is that I need to organise another hard disk for that. ;-)

I tried restore for a test run, it gave a lot of messages about wrong 
compression length. I found some discussion about that, but I don't know if 
its indicates an actual error or not? I did use compression on the drive.

Is there some guarantee that the data restore restores are correct or is it 
just a I try what I can do...

Thanks,
Florian
 

