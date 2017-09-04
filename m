Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:34544 "EHLO
        smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753333AbdIDJb4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 05:31:56 -0400
Received: from smtp19.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp19.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id DD7384FF4
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 05:31:55 -0400 (EDT)
Received: by smtp19.relay.iad3a.emailsrvr.com (Authenticated sender: intranet-AT-rqc.ru) with ESMTPSA id 8CF7D50DE
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 05:31:55 -0400 (EDT)
Received: from CM01.administration.intranet.rqc.ru (unknown [10.101.2.94])
        by postfix.thinky.servers.rqc.ru (Postfix) with ESMTPS id 0E14CFED1
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 09:31:54 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Subject: Is autodefrag recommended?
Message-ID: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Date: Mon, 4 Sep 2017 12:31:54 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,
good time of the day,

More than once I see mentioned in this list that autodefrag option 
solves problems with no apparent drawbacks, but it's not the default. 
Can you recommend to just switch it on indiscriminately on all 
installations?

I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's 
Ubuntu that gives us this strange choice, no idea why it's not 4.9). 
Only spinning rust here, no SSDs.

--

With Best Regards,
Marat Khalili
