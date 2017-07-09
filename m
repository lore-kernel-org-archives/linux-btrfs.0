Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45825 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdGIIGL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 04:06:11 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Marc MERLIN <marc@merlins.org>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more recent gen (33682) compared to the found root node (0)
Date: Sun, 09 Jul 2017 09:57:35 +0200
Message-ID: <21425367.VGcO8ck7Vu@merkaba>
In-Reply-To: <20170709043417.GE6704@merlins.org>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org> <20170709043417.GE6704@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Marc.

Marc MERLIN - 08.07.17, 21:34:
> Sigh,
> 
> This is now the 3rd filesystem I have (on 3 different machines) that is
> getting corruption of some kind (on 4.11.6).

Anyone else getting corruptions with 4.11?

I happily switch back to 4.10.17 or even 4.9 if that is the case. I may even 
do so just from your reports. Well, yes, I will do exactly that. I just switch 
back for 4.10 for now. Better be safe, than sorry.

I know how you feel, Marc. I posted about a corruption on one of my backup 
harddisks here some time ago that btrfs check --repair wasn´t able to handle. 
I redid that disk from scratch and it took a long, long time.

I agree with you that this has to stop. Before that I will never *ever* 
recommend this to a customer. Ideally no corruptions in stable kernels, 
especially when its a .6 at the end of the version number. But if so… then 
fixable. Other filesystems like Ext4 and XFS can do it… so this should be 
possible with BTRFS as well.

Thanks,
-- 
Martin
