Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpmx03.bayer.de ([212.64.225.222]:5853 "EHLO
        smtpmx03.bayer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeCPQVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:21:15 -0400
From: Mike Stevens <michael.stevens@bayer.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Crashes running btrfs scrub
Date: Fri, 16 Mar 2018 16:17:18 +0000
Message-ID: <4d543ebaf4404f1b8111e48ff221e51d@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
 <5389894b-5553-27b8-f9b3-4f6938bd75dd@dirtcellar.net>
 <3a6b6a6fb7d441b5a8081300067d6e02@MOXDE7.na.bayer.cnb>
 <CAJCQCtTUsH5ynMCjRRcnGZHAccOcUL4os3GriBb+mwwtR8SC2w@mail.gmail.com>
 <6b4f2b33edb44f1ea8cef47ae68960af@MOXDE7.na.bayer.cnb>
 <CAJCQCtS+PsWLmSq_UWTaBd8gikumtQaO16dX6HCz_RdGp-grJg@mail.gmail.com>
In-Reply-To: <CAJCQCtS+PsWLmSq_UWTaBd8gikumtQaO16dX6HCz_RdGp-grJg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Also, in the meantime, maybe the problem can be prevented by
> preventing the balance from resuming when mounting. First umount then
> mount with -o skip_balance.

Thanks for the suggestion Chris.  I already had mounted it with skip_balance and then cancelled
the balance.  It will mount, but any significant i/o to the volume cause it to drop r/o.

Mike Stevens

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
