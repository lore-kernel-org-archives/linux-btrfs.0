Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60712 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753880AbdF0XMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 19:12:07 -0400
Date: Tue, 27 Jun 2017 16:11:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode normal doesn't?
Message-ID: <20170627231146.GA16192@merlins.org>
References: <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org> <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com> <20170622025330.GX5303@merlins.org> <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com> <20170623040601.akpyyvh3dgry6nn5@merlins.org> <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com> <20170623161750.r7utffpsmyl5tcik@merlins.org> <20170624023409.GT14690@merlins.org> <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0d93c1c4-1feb-b589-0c8f-1fced7b77686@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 06:46:16PM +0800, Lu Fengqi wrote:
> Thanks for the updated information. I'm sorry that the false alert make 
> you feel nervous.

If you can help me find out whether those are real errors that I need to fix
(and can't yet since there is no --repair), or whether they are not real
problems, I can ignore them as long as the other check --mode normal runs
clean (it does), we'll be good :)

> >ERROR: root 3862 EXTENT_DATA[18170706 4096] interrupt
> >ERROR: root 3862 EXTENT_DATA[18170706 16384] interrupt
> >ERROR: root 3862 EXTENT_DATA[18170706 20480] interrupt
> >ERROR: root 3862 EXTENT_DATA[18170706 135168] interrupt
> >ERROR: root 3862 EXTENT_DATA[18170706 1048576] interrupt
> >ERROR: errors found in fs roots
> 
> However, this looks like another problem. Could you dump this file tree 
> by the following command?
> # btrfs-debug-tree -t 3862 <dev> | grep -C 10 18170706

argamel:~# btrfs-debug-tree -t 3862 /dev/mapper/dshelf2 | grep -C 10 18170706  
                transid 522 data_len 0 name_len 45
                name: 007b01c69a8d_9582a070_425a45d7@mindspring.com
        item 89 key (835232 DIR_ITEM 1181375325) itemoff 10304 itemsize 64
                location key (877605 INODE_ITEM 0) type FILE
                transid 530 data_len 0 name_len 34
                name: PO.5078346.7051988@codeweavers.com
        item 90 key (835232 DIR_ITEM 1181489720) itemoff 10226 itemsize 78
                location key (873230 INODE_ITEM 0) type FILE
                transid 529 data_len 0 name_len 48
                name: 8-8356087-5CruUNCbuG3Kg9zuO@mail1.fireflypro.com
        item 91 key (835232 DIR_ITEM 1181707066) itemoff 10148 itemsize 78
                location key (869906 INODE_ITEM 0) type FILE
                transid 528 data_len 0 name_len 48
                name: 7-7026088-1uLzZJuFzYD6h4rzV@max.firmalliance.biz
        item 92 key (835232 DIR_ITEM 1181727135) itemoff 10084 itemsize 64
                location key (877380 INODE_ITEM 0) type FILE
                transid 530 data_len 0 name_len 34
                name: NJ.5943286.7059518@codeweavers.com
        item 93 key (835232 DIR_ITEM 1181873033) itemoff 10038 itemsize 46
                location key (859092 INODE_ITEM 0) type FILE
                transid 526 data_len 0 name_len 16
                name: mdadm_detail.0
        item 83 key (2640780 DIR_ITEM 3316050734) itemoff 12739 itemsize 39
                location key (15689752 INODE_ITEM 0) type FILE
                transid 8178 data_len 0 name_len 9
                name: sda3.dd.0
        item 84 key (2640780 DIR_ITEM 3349213389) itemoff 12697 itemsize 42
                location key (2667656 INODE_ITEM 0) type FILE
                transid 885 data_len 0 name_len 12
                name: sdb2.dd.1.gz
        item 85 key (2640780 DIR_ITEM 3351742419) itemoff 12663 itemsize 34
                location key (18170706 INODE_ITEM 0) type FILE
                transid 37866 data_len 0 name_len 4
                name: dm-0
        item 86 key (2640780 DIR_ITEM 3354578455) itemoff 12624 itemsize 39
                location key (13847590 INODE_ITEM 0) type FILE
                transid 2387 data_len 0 name_len 9
                name: sda7.3.gz
        item 87 key (2640780 DIR_ITEM 3361267344) itemoff 12586 itemsize 38
                location key (2667594 INODE_ITEM 0) type FILE
                transid 885 data_len 0 name_len 8
                name: .profile
--
                name: sdc1.dd.4.gz
        item 70 key (2640780 DIR_INDEX 1685) itemoff 13162 itemsize 42
                location key (17548883 INODE_ITEM 0) type FILE
                transid 34469 data_len 0 name_len 12
                name: sdc1.dd.5.gz
        item 71 key (2640780 DIR_INDEX 1687) itemoff 13120 itemsize 42
                location key (17548884 INODE_ITEM 0) type FILE
                transid 34469 data_len 0 name_len 12
                name: sdc1.dd.6.gz
        item 72 key (2640780 DIR_INDEX 2039) itemoff 13086 itemsize 34
                location key (18170706 INODE_ITEM 0) type FILE
                transid 37866 data_len 0 name_len 4
                name: dm-0
        item 73 key (2640780 DIR_INDEX 2041) itemoff 13051 itemsize 35
                location key (18170707 INODE_ITEM 0) type FILE
                transid 37866 data_len 0 name_len 5
                name: fdisk
        item 74 key (2640780 DIR_INDEX 2043) itemoff 13007 itemsize 44
                location key (18170708 INODE_ITEM 0) type FILE
                transid 37866 data_len 0 name_len 14
                name: mdadm_detail.0

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
