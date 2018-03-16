Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpmx04.bayer.de ([212.64.225.223]:8385 "EHLO
        smtpmx04.bayer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeCPS5k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 14:57:40 -0400
From: Mike Stevens <michael.stevens@bayer.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Crashes running btrfs scrub
Date: Fri, 16 Mar 2018 18:53:43 +0000
Message-ID: <d12959311b31474fa3e7ab7d373f2b57@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
 <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
 <CAJCQCtS+PsWLmSq_UWTaBd8gikumtQaO16dX6HCz_RdGp-grJg@mail.gmail.com>
 <4d543ebaf4404f1b8111e48ff221e51d@MOXDE7.na.bayer.cnb>
 <CAJCQCtSW4RxSAPjVC5yZLAjb5WUMDV+8=6Bdt4aUWDhXBuZa5Q@mail.gmail.com>
In-Reply-To: <CAJCQCtSW4RxSAPjVC5yZLAjb5WUMDV+8=6Bdt4aUWDhXBuZa5Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>Mar 15 14:03:06 auswscs9903 kernel: BTRFS warning (device sdag): failed setting block group ro: -30


> These are only found in scrub.c

Interesting.  I'm running an offline btrfs check right now, so far extents and free space cache seem to have passed.
If that finishes successfully, I'll try resuming my rsync and see what happens. 

> Another thing you could try is mounting with nospace_cache. This is a
> coin toss if it will matter, but the fact it's not able to create
> pending bg's makes me wonder if possibly something is awry with the on
> disk free space cache, and this would eliminate that possibility
> without having to clear the cache. There's a performance penalty with
> nospace_cache but that's the least of the issues right now.

I'll try this as well if the above fails.  Thanks for the input.

-- 
Mike S

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
