Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:54459 "EHLO
        smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932343AbdJZPZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 11:25:54 -0400
Received: from smtp23.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp23.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id C5BFB406FC
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 11:25:53 -0400 (EDT)
Received: from smtp81.ord1d.emailsrvr.com (relay.ord1c.rsapps.net [172.28.255.120])
        by smtp23.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTPS id C0C01406F2
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 11:25:53 -0400 (EDT)
Subject: Re: btrfs-subv-backup v0.1b
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
References: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <49c49e21-0834-5038-2059-5171a6a154d5@rqc.ru>
Date: Thu, 26 Oct 2017 18:25:52 +0300
MIME-Version: 1.0
In-Reply-To: <cc9e6302-125b-b120-cc45-35a2e12a3d6a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Austin,

Looks very useful. Two questions:

1. Can you release it under some standard license recognized by github, 
in case someone wants to include it in other projects? AGPL-3.0 would be 
nice.

2. I don't understand mentioned restore performance issues. It shouldn't 
apply if data is restored _after_ subvolume structure is re-created, but 
even if (1) data is already there, and (2) copyless move doesn't work 
between subvolumes (really a limitation of some older systems, not 
Python), there's a known workaround of creating a reflink and then 
removing the original.

--

With Best Regards,
Marat Khalili

