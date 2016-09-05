Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:14197 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbcIEEcj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 00:32:39 -0400
From: Naohiro Aota <Naohiro.Aota@hgst.com>
To: "jbacik@fb.com" <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>
Subject: Re: [PATCH] btrfs: let btrfs_delete_unused_bgs() to clean relocated
 bgs
Date: Mon, 5 Sep 2016 04:32:37 +0000
Message-ID: <1473049955.14093.37.camel@hgst.com>
References: <1472802392-10851-1-git-send-email-naohiro.aota@hgst.com>
         <b5c2852a-fe0a-834e-0fcd-2b61b5c47088@fb.com>
In-Reply-To: <b5c2852a-fe0a-834e-0fcd-2b61b5c47088@fb.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-09-02 (é‡‘) ã® 09:35 -0400 ã« Josef Bacik ã•ã‚“ã¯æ›¸ãã¾ã—ãŸ:
> On 09/02/2016 03:46 AM, Naohiro Aota wrote:
> > 
> > Currently, btrfs_relocate_chunk() is removing relocated BG by
> > itself. But
> > the work can be done by btrfs_delete_unused_bgs() (and it's better
> > since it
> > trim the BG). Let's dedupe the code.
> > 
> > While btrfs_delete_unused_bgs() is already hitting the relocated
> > BG, it
> > skip the BG since the BG has "ro" flag set (to keep balancing BG
> > intact).
> > On the other hand, btrfs cannot drop "ro" flag here to prevent
> > additional
> > writes. So this patch make use of "removed" flag.
> > btrfs_delete_unused_bgs() now detect the flag to distinguish
> > whether a
> > read-only BG is relocating or not.
> > 
> 
> This seems racey to me.Â Â We remove the last part of the block group,
> it ends upÂ 
> on the unused_bgs_list, we process this list, see that removed isn't
> set and weÂ 
> skip it, then later we set removed, but it's too late.Â Â I think the
> right way isÂ 
> to actually do a transaction, set ->removed, manually add it to theÂ 
> unused_bgs_list if it's not already, then end the transaction.Â Â This
> way we areÂ 
> guaranteed to have the bg on the list when it is ready to be
> removed.Â Â This isÂ 
> my analysis after looking at it for 10 seconds after being awake for
> like 30Â 
> minutes so if I'm missing something let me know.Â Â Thanks,

I don't think a race will happen. Since we are holding
delete_unused_bgs_mutex here, btrfs_delte_unused_bgs() checks ->removed
flag after we unlock the mutex i.e. we setup the flag properly. For a
case btrfs_delete_usused_bgs() checks the BG before we hold
delte_unused_bgs_mutex, then that BG is removed by it (if it's empty)
and btrfs_relocate_chunk() should never see it.

Regards,
Naohiro
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
