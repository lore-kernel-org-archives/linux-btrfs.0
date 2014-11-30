Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:55320 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3NjM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 08:39:12 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so6562611qcr.14
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 05:39:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141130115908.GF32735@carfax.org.uk>
References: <CAH-HCWWVR=g6mZFZyu6wYRfP7Harr5bxokJi+_qW8QHsniFPFg@mail.gmail.com>
 <20141130115908.GF32735@carfax.org.uk>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 19:08:51 +0530
Message-ID: <CAH-HCWWk7J6N0M1z=2N__T0TQ1qffORnxdVNrpjGHh1gtQx3dg@mail.gmail.com>
Subject: Re: root subvol id is 0 or 5?
To: Hugo Mills <hugo@carfax.org.uk>, Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 5:29 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
>    In the data structures on disk, it's 5. The kernel aliases 0 to
> mean subvolid 5.

So why 5 and not just 0 which seems a logical choice? On top of this,
one needs to alias 0 to 5!

-- 
Shriramana Sharma à®¶à¯à®°à¯€à®°à®®à®£à®¶à®°à¯à®®à®¾ à¤¶à¥à¤°à¥€à¤°à¤®à¤£à¤¶à¤°à¥à¤®à¤¾
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
