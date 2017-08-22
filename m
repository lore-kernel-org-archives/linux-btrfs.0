Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:35861 "EHLO
        smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932654AbdHVNlO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:41:14 -0400
Received: from smtp35.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp35.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 2A94060ED
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 09:41:13 -0400 (EDT)
Received: by smtp35.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id CE8405B56
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 09:41:12 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id BEA7AF69B
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 13:41:10 +0000 (UTC)
Subject: Re: finding root filesystem of a subvolume?
To: linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <fb1f381a-9f88-95cf-529c-2b12059fdae7@rqc.ru>
 <20170822131213.GC14804@rus.uni-stuttgart.de>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <268b7bd4-c663-9c5f-5ec5-990521b335d0@rqc.ru>
Date: Tue, 22 Aug 2017 16:41:10 +0300
MIME-Version: 1.0
In-Reply-To: <20170822131213.GC14804@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have no subvol=/ option at all:
Probably depends on kernel, but I presume missing subvol means the same 
as subvol=/ .

> I am only interested in mounted volumes.
If your initial path (/local/.backup/home) is a subvolume but it's not 
itself present in /proc/mounts then it's probably mounted as a part some 
higher-level subvolume, but this higher-level subvolume does not have to 
be root. Do you need volume root or just some higher-level subvolume 
that's mounted?

--

With Best Regards,
Marat Khalili

