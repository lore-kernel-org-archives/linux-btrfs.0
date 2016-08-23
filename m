Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.visageimaging.com ([80.150.143.228]:58909 "EHLO
        mail.visageimaging.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932261AbcHWQ3k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 12:29:40 -0400
From: Malte Westerhoff <MWesterhoff@visageimaging.com>
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs partition fails to mount after power outage
Date: Tue, 23 Aug 2016 16:29:39 +0000
Message-ID: <A90A4F56-58D7-4AF9-A185-97F6797F9BFB@visageimaging.com>
References: <FBA93BA3BE574649A3C97265F3CE0D54013A625685@ber-vi4.ad.vi>
 <CAJCQCtQf2bhxWc6+nYoxYz8HquMOsj5hAfTc=5B2w0_1d8U9rQ@mail.gmail.com>
 <B26BAB7E-A049-4730-B7AD-3E906026F25C@visageimaging.com>
 <CAJCQCtSuiSrLVLVmF9wktcMJqApET0DoOf=_2V=oEb=5sPPTgg@mail.gmail.com>
 <E80D3AE3-69A9-40E7-9946-D2F66214828B@visageimaging.com>
 <CAJCQCtTyuxQee_GzgZCY2WRC04LEXAOvbg_BW_uBVh+iTTgrEQ@mail.gmail.com>
 <CAJCQCtTgzJxTV6WEre0jZ7d-f0Apng6kBoBfHmcktQfB5rq5xA@mail.gmail.com>
In-Reply-To: <CAJCQCtTgzJxTV6WEre0jZ7d-f0Apng6kBoBfHmcktQfB5rq5xA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The output for btrfs-debug-tree â€“d /dev/â€¦ is quite large â€“ so I have placed it here:
https://cloud.visageimaging.com/index.php/s/Q7ILbVWFoGeckCI

The â€“b one is this:

quickstore2:~/btrfs-progs # ./btrfs-debug-tree -b 29556736 /dev/mapper/VGBIGRAID6-DATA1
btrfs-progs v4.7
parent transid verify failed on 7375769206784 wanted 52059 found 52028
parent transid verify failed on 7375769206784 wanted 52059 found 52028
parent transid verify failed on 7375769206784 wanted 52059 found 52028
parent transid verify failed on 7375769206784 wanted 52059 found 52028
Ignoring transid failure
leaf parent key incorrect 7375769206784
leaf 29556736 items 4 free space 15949 generation 6 owner 5
fs uuid 0397b3eb-fdc4-4d3f-9cc9-d38467dcb6c2
chunk uuid 74addbad-a6f1-4c82-9e70-97d9aab63103
       	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
       		inode generation 3 transid 6 size 2 nbytes 16384
       		block group 0 mode 40755 links 1 uid 0 gid 0
       		rdev 0 flags 0x0
       	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
       		inode ref index 0 namelen 2 name: ..
       	item 2 key (256 DIR_ITEM 512897553) itemoff 16080 itemsize 31
       		location key (257 ROOT_ITEM -1) type DIR
       		namelen 1 datalen 0 name: @
       	item 3 key (256 DIR_INDEX 2) itemoff 16049 itemsize 31
       		location key (257 ROOT_ITEM -1) type DIR
       		namelen 1 datalen 0 name: @


On 8/23/16, 6:07 PM, "linux-btrfs-owner@vger.kernel.org on behalf of Chris Murphy" <linux-btrfs-owner@vger.kernel.org on behalf of lists@colorremedies.com> wrote:

    On Tue, Aug 23, 2016 at 10:05 AM, Chris Murphy <lists@colorremedies.com> wrote:
    
    
    >btrfs-find-root -d /dev/mapper/VGBIGRAID6-DATA1
    
    I meant to ask for
    
    btrfs-debug-tree -d /dev/...
    
    
    
    
    
    -- 
    Chris Murphy
    --
    To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
    the body of a message to majordomo@vger.kernel.org
    More majordomo info at  http://vger.kernel.org/majordomo-info.html
    

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
