Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpmx04.bayer.de ([212.64.225.223]:11411 "EHLO
        smtpmx04.bayer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbeCTRsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 13:48:03 -0400
From: Mike Stevens <michael.stevens@bayer.com>
To: Liu Bo <obuil.liubo@gmail.com>,
        "waxhead@dirtcellar.net" <waxhead@dirtcellar.net>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        "David Sterba" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Crashes running btrfs scrub
Date: Tue, 20 Mar 2018 17:44:06 +0000
Message-ID: <93b4d10e04d34ecfa97f705d939ab671@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CANQeFDDEtYYummhR7gZAxidQxTjbCbzEpLsR5L=HtykFkP2BBQ@mail.gmail.com>
 <1a292eab288a4c90bf6dbf804dc92c86@MOXDE7.na.bayer.cnb>
 <CANQeFDCSv9pwrGOqimQnb0kW8ZBJY=smF2MbZ7zcmEev-M7YzQ@mail.gmail.com>
 <CANQeFDB5pu+h++p3-GTUO28DE52r9JiW6TyLdy+rYGfUwjOfGA@mail.gmail.com>
 <fa53b8c8-1cf9-2d3d-4a9b-70e760ec45bb@dirtcellar.net>
 <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
In-Reply-To: <CANQeFDDK7uU+USWzzDvWBG1SCpQJyZgrTnYoZ0qp99txSp7cEg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> 30 devices is really not that much, heck you get 90 disks top load JBOD
>> storage chassis these days and BTRFS does sound like an attractive choice
>> for things like that.

> So Mike's case is, that both metadata and data are configured as
> raid6, and the operations, balance and scrub, that he tried, need to
> set the existing block group as readonly (in order to avoid any
> further changes being applied during operations are running), then we
> got into the place where another system chunk is needed.

> However, I think it'd be better to have some warnings about this when
> doing a) mkfs.btrfs -mraid6, b) btrfs device add.

> David, any idea?

I'll certainly vote for a warning, I would have set this up differently had I been aware.  

My filesystem check seems to have returned successfully:

[root@auswscs9903] ~ # btrfs check --readonly /dev/sdb
Checking filesystem on /dev/sdb
UUID: 77afc2bb-f7a8-4ce9-9047-c031f7571150
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 97926270238720 bytes used err is 0
total csum bytes: 95395030288
total tree bytes: 201223503872
total fs tree bytes: 84484636672
total extent tree bytes: 7195869184
btree space waste bytes: 29627784154
file data blocks allocated: 97756261568512

I've remounted the filesystem and I can at least touch a file.  I'm restarting the rsync that was running when it originally went read only.
What is the next step if it drops back to r/o?

________________________________________________________________________
The information contained in this e-mail is for the exclusive use of the 
intended recipient(s) and may be confidential, proprietary, and/or 
legally privileged.  Inadvertent disclosure of this message does not 
constitute a waiver of any privilege.  If you receive this message in 
error, please do not directly or indirectly use, print, copy, forward,
or disclose any part of this message.  Please also delete this e-mail 
and all copies and notify the sender.  Thank you. 
________________________________________________________________________
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
