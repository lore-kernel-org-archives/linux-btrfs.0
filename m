Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51071 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaH1VXe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 17:23:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XN7AE-000090-AT
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 23:23:26 +0200
Received: from 11.161.185.203.dsl.dyn.mana.pf ([203.185.161.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 23:23:26 +0200
Received: from jd.girard by 11.161.185.203.dsl.dyn.mana.pf with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 23:23:26 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Undelete files / directory
Date: Thu, 28 Aug 2014 11:23:12 -1000
Message-ID: <lto6k2$ebq$1@ger.gmane.org>
References: <53FE1DB2.8040900@sysnux.pf> <pan$2ed7a$1001c22e$8c89f27e$d20dc522@cox.net> <262E2EAA-FE5F-4ADB-9D1D-258D51D81AFE@colorremedies.com> <ltnnfo$a57$1@ger.gmane.org> <883EA056-F115-4254-9412-622C07170707@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <883EA056-F115-4254-9412-622C07170707@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/08/2014 10:21, Chris Murphy a écrit :
> What do you get for 

[root@x220 ~]# btrfs-debug-tree -R /dev/mapper/home

root tree: 115230801920 level 1
chunk tree: 131072 level 1
extent tree key (EXTENT_TREE ROOT_ITEM 0) 115230806016 level 2
device tree key (DEV_TREE ROOT_ITEM 0) 115191881728 level 0
fs tree key (FS_TREE ROOT_ITEM 0) 115215908864 level 3
checksum tree key (CSUM_TREE ROOT_ITEM 0) 115230842880 level 3
uuid tree key (UUID_TREE ROOT_ITEM 0) 115196645376 level 0
data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 115623051264 level 0
btrfs root backup slot 0
        tree root gen 138441 block 115220434944
                extent root gen 138441 block 115217117184
                chunk root gen 73727 block 131072
                device root gen 130645 block 115191881728
                csum root gen 138441 block 115216838656
                fs root gen 138441 block 115215908864
                26813235200 used 42947575808 total 1 devices
btrfs root backup slot 1
        tree root gen 138442 block 115230801920
                extent root gen 138442 block 115230806016
                chunk root gen 73727 block 131072
                device root gen 130645 block 115191881728
                csum root gen 138442 block 115230842880
                fs root gen 138441 block 115215908864
                26813235200 used 42947575808 total 1 devices
btrfs root backup slot 2
        tree root gen 138439 block 115231158272
                extent root gen 138439 block 115230871552
                chunk root gen 73727 block 131072
                device root gen 130645 block 115191881728
                csum root gen 138440 block 115231473664
                fs root gen 138440 block 115231453184
                26818527232 used 42947575808 total 1 devices
btrfs root backup slot 3
        tree root gen 138440 block 115210838016
                extent root gen 138440 block 115233878016
                chunk root gen 73727 block 131072
                device root gen 130645 block 115191881728
                csum root gen 138441 block 115216838656
                fs root gen 138441 block 115215908864
                26813243392 used 42947575808 total 1 devices
total bytes 42947575808
bytes used 26813235200
uuid ca93d247-9076-4aa7-862b-a6add3a5c16c
Btrfs v3.14.2

So this seems fine; why is btrfs-find-root not working for me?

Then I tried to use the root with oldest generation:
[root@x220 ~]# btrfs restore -t 115231158272 -v /dev/mapper/home
--path-regex '^/(|jdg(|/tmp(|/.*)))$' .

It did recover many files / directories, but unfortunately not my
photos. Does it mean I discovered my mistake and unmounted the partition
too late, and the info is lost?

I made a dump of the device to another computer (using dd), I think the
data are still here (hexedit).

What else could I try?


Thanks,
Jean-Denis Girard

