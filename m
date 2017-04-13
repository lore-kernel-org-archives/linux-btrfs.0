Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:33263 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbdDMLGK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 07:06:10 -0400
Received: from smtp17.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp17.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id A901E25FDC
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 07:06:09 -0400 (EDT)
Received: by smtp17.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id 5991825FD7
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 07:06:09 -0400 (EDT)
From: Marat Khalili <mkh@rqc.ru>
Subject: Deduplication tools
To: linux-btrfs@vger.kernel.org
Message-ID: <37e02202-b9a9-3953-7bc8-92c4d1fd485f@rqc.ru>
Date: Thu, 13 Apr 2017 14:06:07 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After reading this maillist for a while I became a bit more cautious 
about using various BTRFS features, so decided to ask just in case: is 
it safe to use out-of-band deduplication tools 
<https://btrfs.wiki.kernel.org/index.php/Deduplication>, and which of 
them are considered more stable/mainstream? Also, won't running these 
tools exacerbate often mentioned stability/performance problems with 
too-many-snapshots? Any first-hand experience is very welcome.


--

With Best Regards,
Marat Khalili
