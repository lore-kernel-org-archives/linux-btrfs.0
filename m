Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:58496 "EHLO
        smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750820AbdE1HNU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 03:13:20 -0400
Received: from smtp18.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp18.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id BC66AE01F2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:13:19 -0400 (EDT)
Received: from smtp105.ord1d.emailsrvr.com (relay.ord1c.rsapps.net [172.28.255.120])
        by smtp18.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTPS id B7F68E01ED
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:13:19 -0400 (EDT)
Received: from smtp6.relay.ord1d.emailsrvr.com (localhost [127.0.0.1])
        by smtp6.relay.ord1d.emailsrvr.com (SMTP Server) with ESMTP id 9AAADE005B
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:13:18 -0400 (EDT)
Received: by smtp6.relay.ord1d.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 3C52FE0058
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 03:13:17 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id C05199F43
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 07:13:15 +0000 (UTC)
Subject: Re: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
To: linux-btrfs@vger.kernel.org
References: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
 <c3d2a91c-6fea-d273-2d58-1f8ea700b942@mendix.com>
 <CADzmB21E6btzsS9HQXk_AC+zVks1CHu=x8NVSnPQ+=+y4fgzPQ@mail.gmail.com>
 <5be5a686-216c-2976-9618-276f049b1a9e@mendix.com>
 <CADzmB23zKnH35mW8jVPW3Z552t7Kw3wWhRn+x0jxtT3tCcCS9Q@mail.gmail.com>
 <pan$639c2$50c928c5$2b2a8c90$6b4270a1@cox.net>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <0efd7808-e66c-d9e7-76e9-b6520b4686ff@rqc.ru>
Date: Sun, 28 May 2017 10:13:14 +0300
MIME-Version: 1.0
In-Reply-To: <pan$639c2$50c928c5$2b2a8c90$6b4270a1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> If
> you do have scripted snapshots being taken, be sure you have a script
> thinning down your snapshot history as well.


I know Ivan P never mentioned qgroups, but just a warning for future 
readers: *with qgroups don't let this script delete more than couple 
dozen snapshots at once*, then wait for btrfs kernel activity to subside 
before trying again. Especially be very careful when running this script 
in production the very first time, it will most likely find too many 
snapshots to delete. (Temporary removing all affected qgroups beforehand 
may also work.)


--

With Best Regards,
Marat Khalili

