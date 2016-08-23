Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50780 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbcHWRR1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 13:17:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bcFKG-0000iK-8u
        for linux-btrfs@vger.kernel.org; Tue, 23 Aug 2016 19:17:24 +0200
To: linux-btrfs@vger.kernel.org
From: Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Stuck btrfs-cleaner on 4.7 and 4.6
Date: Tue, 23 Aug 2016 07:17:16 -1000
Message-ID: <npi0er$aqo$1@blaine.gmane.org>
References: <npds64$nu3$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <npds64$nu3$1@blaine.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 21/08/2016 à 17:39, Jean-Denis Girard a écrit :
> Hi list,
> 
> After upgrading my Fedora 23 system from 4.4.12 to 4.7.2, I'm seeing one
> btrfs-cleaner process stuck at 100% CPU. The problem disappears when
> going back to 4.4 kernel (4.4.17), but is also present with Fedora
> kernel 4.6.6-200.fc23.

Just for the archives, I found that the problem was related to
fragmentation. Mounting without autodefrag on 4.7.2 avoided
btrfs-cleaner stuck at 100 % CPU. Then I did manually defragment all
Btrfs volumes, and could then remount with autodefrag. Every thing is ok
after ~12 hours uptime.


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


