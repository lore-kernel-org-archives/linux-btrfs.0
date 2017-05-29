Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:33979 "EHLO
        smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750846AbdE2IjR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 04:39:17 -0400
Received: from smtp15.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp15.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 53DA85484
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 04:39:16 -0400 (EDT)
Received: by smtp15.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 0884D5481
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 04:39:15 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 148A59FDD
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 08:39:14 +0000 (UTC)
Subject: Re: btrfs mounts RO, kernel oops on RW
Cc: linux-btrfs@vger.kernel.org
References: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
 <pan$3ce02$7e425613$62194897$37882c38@cox.net>
 <CAHPjZW5sRxns7CN8QmhB_HaQP5PGo7smFrf+q1QWHRRVnAToMA@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <161856ce-4df2-cfda-2412-7d8f842e2cd0@rqc.ru>
Date: Mon, 29 May 2017 11:39:13 +0300
MIME-Version: 1.0
In-Reply-To: <CAHPjZW5sRxns7CN8QmhB_HaQP5PGo7smFrf+q1QWHRRVnAToMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'm not asking for a specific endorsement, but should I be considering
> something like the seagate ironwolf or WD red drives?

You need two qualitative features from HDD for RAID usage:
1) being failfast (TLER in WD talk), and
2) be designed to tolerate vibrations from other disks in a box.

Therefore you need _at least_ WD Red or alternative from Seagate. Paying 
more can only bring you quantitative benefits AFAIK. Just don't put 
desktop drives in RAID.

(Sorry for being off-topic, but after some long recent discussions I 
don't feel as guilty. :) )

--

With Best Regards,
Marat Khalili

