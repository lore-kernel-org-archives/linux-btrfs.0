Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:54266 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758424AbdEXIYA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 04:24:00 -0400
Received: from smtp34.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp34.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 90B7924BCD
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 04:23:59 -0400 (EDT)
Received: by smtp34.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 40E4E24BB8
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 04:23:59 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 9191D9A9C
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2017 08:23:57 +0000 (UTC)
Subject: Re: snapshot destruction making IO extremely slow
To: linux-btrfs@vger.kernel.org
References: <550E7917.5030602@gmail.com>
 <20150325011937.GB20767@twin.jikos.cz> <55129428.7090508@gmail.com>
 <20150330142532.GI32051@suse.cz> <55196740.1000705@gmail.com>
 <20150331170516.GD6821@suse.cz> <5534CC2F.4080109@gmail.com>
 <553912EF.7010004@gmail.com>
 <CAKbZ4cK8-Fh6MvS1X4Tj-S9k6VBgaPEFj8x30de3NQf-UdZBrg@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <76463d77-7747-c27b-e874-cea1f88edd05@rqc.ru>
Date: Wed, 24 May 2017 11:23:57 +0300
MIME-Version: 1.0
In-Reply-To: <CAKbZ4cK8-Fh6MvS1X4Tj-S9k6VBgaPEFj8x30de3NQf-UdZBrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> It occurs when enabling quotas on a volume. When there are a
> lot of snapshots that are deleted, the system becomes extremely
> unresponsive (IO often waiting for 30s on a SSD). When I don't have
> quotas, removing snapshots is fast.
Same problem here. It is now common knowledge in the list that qgroups 
cause performance problems. I try to avoid deleting many snapshots at 
once because of this.

--

With Best Regards,
Marat Khalili

