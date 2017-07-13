Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54689 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdGMBKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 21:10:02 -0400
Date: Thu, 13 Jul 2017 03:09:49 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: dsterba@suse.cz, Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        ahferroin7@gmail.com
Subject: Re: [PATCH v4 0/6] Chunk level degradable check
Message-ID: <20170713010949.jyt24oebfwjngmcz@angband.pl>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
 <20170710211150.7210ac36@fire>
 <20170713005010.GA2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170713005010.GA2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 02:50:10AM +0200, David Sterba wrote:
> On Mon, Jul 10, 2017 at 09:11:50PM +0300, Dmitrii Tcvetkov wrote:
> > Tested on top of current mainline master (commit
> > af3c8d98508d37541d4bf57f13a984a7f73a328c). Didn't find any
> > regressions.

I've retested this yet again.  No regressions as well.

> Thanks for testing.
> 
> If anybody wants to get their Tested-by in the patches, please let me
> know, I'll add the tags (can be done until rc6). Your efforts are
> appreciated so you get the credit in the undying history log of linux
> kernel.

Heh.  Let's not play such games but finally get this patch set in, it's by
far the biggest problem for multi-device.

Any issues with degraded mounts which I reported before are not related to
this patch set, I merely found them at the time of testing.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
