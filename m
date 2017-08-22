Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:60154 "EHLO
        smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932787AbdHVNGl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:06:41 -0400
Received: from smtp12.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp12.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 09450C0584
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 08:58:30 -0400 (EDT)
Received: from smtp89.ord1d.emailsrvr.com (relay.ord1c.rsapps.net [172.28.255.120])
        by smtp12.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTPS id 043AAC057E
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 08:58:30 -0400 (EDT)
Received: from smtp12.relay.ord1d.emailsrvr.com (localhost [127.0.0.1])
        by smtp12.relay.ord1d.emailsrvr.com (SMTP Server) with ESMTP id 6A22CE0061
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 08:58:29 -0400 (EDT)
Received: by smtp12.relay.ord1d.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 1533BE0085
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 08:58:28 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 02771F693
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 12:58:26 +0000 (UTC)
Subject: Re: finding root filesystem of a subvolume?
To: linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <fb1f381a-9f88-95cf-529c-2b12059fdae7@rqc.ru>
Date: Tue, 22 Aug 2017 15:58:26 +0300
MIME-Version: 1.0
In-Reply-To: <20170822125030.GB14804@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/08/17 15:50, Ulli Horlacher wrote:
> It seems, I have to scan the subvolume path upwards until I found a real
> mount point,
I think searching /proc/mounts for the same device and subvol=/ in 
options is most straightforward. But what makes you think it's mounted 
at all?

--

With Best Regards,
Marat Khalili
