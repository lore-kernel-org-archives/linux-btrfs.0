Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:46313 "EHLO
        smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750879AbdIOJuM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 05:50:12 -0400
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
To: Hugo Mills <hugo@carfax.org.uk>, Goffredo Baroncelli <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <20170914221824.GD7067@carfax.org.uk>
 <15f070ee-ec6a-2140-0908-c43f466505ad@inwind.it>
 <20170915082601.GE7067@carfax.org.uk>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <7aa8063a-2f1f-c611-d24a-d5e6a9ceb29b@rqc.ru>
Date: Fri, 15 Sep 2017 12:50:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170915082601.GE7067@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

May I state my user's point of view:

I know one applications that uses O_DIRECT, and it is subtly broken on 
BTRFS. I know no applications that use O_DIRECT and are not broken. 
(Really more statistics would help here, probably some exist that 
provably work.) According to developers making O_DIRECT work on BTRFS is 
difficult if not impossible. Isn't it time to disable O_DIRECT like ZFS 
does AFAIU? Data safety is certainly more important than performance 
gain it may or may not give some applications.

--

With Best Regards,
Marat Khalili

