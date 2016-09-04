Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0052.outbound.protection.outlook.com ([104.47.116.52]:28236
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751586AbcIDFe7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Sep 2016 01:34:59 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: gazillions of Incorrect local/global backref count
Date: Sun, 4 Sep 2016 05:33:27 +0000
Message-ID: <SY3PR01MB138680D8161F8D2B951F65709EE70@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <1472964653.8683.17.camel@scientia.net>
In-Reply-To: <1472964653.8683.17.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Christoph Anton Mitterer
> Sent: Sunday, 4 September 2016 2:51 PM
> To: linux-btrfs@vger.kernel.org
> Subject: gazillions of Incorrect local/global backref count
> 
> Hey.
> 
> I just did a btrfs check on my notebooks root fs, with:
> $ uname -a
> Linux heisenberg 4.7.0-1-amd64 #1 SMP Debian 4.7.2-1 (2016-08-28)
> x86_64 GNU/Linux
> $ btrfs --version
> btrfs-progs v4.7.1
> 
> 
> 
> during:
> checking extents
> 
> it found gazillions of these:
> Incorrect local backref count on 1107980288 root 257 owner 17807428
> offset 13568135168 found 2 wanted 3 back 0x2d69990
> Incorrect local backref count on 1107980288 root 257 owner 14055042
> offset 13568135168 found 2 wanted 3 back 0x2d69930
> Incorrect global backref count on 1107980288 found 4 wanted 6
> backpointer mismatch on [1107980288 61440]
> Incorrect local backref count on 1108049920 root 257 owner 17807428
> offset 13568262144 found 2 wanted 5 back 0x2d69ac0
> Incorrect local backref count on 1108049920 root 257 owner 14055042
> offset 13568262144 found 2 wanted 5 back 0x2d69b20
> Incorrect global backref count on 1108049920 found 4 wanted 10
> backpointer mismatch on [1108049920 77824]
> 
> See stdout/err[0] logfiles from the check.
> 
> 
> What do they mean?
> 
> And does this now mean that data is corrupted and I should try to
> recover that from a backup?
> And if so... how to I map the affected addresses above back to files?
> 
> Or can I somehow simply (and foremost cleanly/perfectly) correct these
> errors?

The errors are wrong. I nearly ruined my filesystem a few days ago by trying to repair similar errors, thankfully all seems ok.
Check again with btrfs-progs 4.6.1 and see if the errors go away, mine did.
See open bug https://bugzilla.kernel.org/show_bug.cgi?id=155791 for more details.

Cheers,
Paul.




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
